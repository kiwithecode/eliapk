from flask import request, jsonify
from flask_jwt_extended import create_access_token
from app.extensions import db
from app.login import bp as app
from marshmallow import ValidationError
from werkzeug.security import check_password_hash
from flask_cors import cross_origin
from datetime import timedelta
from app.models.SAMM_Usuario import SAMM_Usuario, SAMM_UsuarioSchema

from flask import jsonify, request
from flask_cors import cross_origin
from flask_jwt_extended import jwt_required, get_jwt_identity
from datetime import date, datetime


@app.route('/login', methods=['POST'])
@cross_origin()
def login():
    try:
        data = request.get_json()
        if not data:
            return jsonify({'message': 'No input data provided'}), 400
        Codigo = data.get('Codigo')
        Pin= data.get('Pin')
        Clave = data.get('Clave')
        if not Codigo:
            return jsonify({'message': 'No Codigo provided'}), 400
        if not Clave and not Pin:
            return jsonify({'message': 'No Clave or Pin provided'}), 400
        usuario = SAMM_Usuario.query.filter_by(Codigo=Codigo).first()
        if not usuario:
            return jsonify({'message': 'Usuario no existe'}), 400
        if Pin and not (usuario.Pin == Pin):
            return jsonify({'message': 'Pin incorrecto'}), 400
        if Clave and not check_password_hash(usuario.Clave, Clave):
            return jsonify({'message': 'Contraseña incorrecta'}), 400
        if usuario.Estado != 'A' and usuario.Estado != 'T':
            return jsonify({'message': 'Usuario inactivo'}), 400
        if usuario.Confirmado == 'N':
            return jsonify({'message': 'Usuario no confirmado'}), 400
        
        #check if data request has a web field
        if 'web' in data:
            if data['web'] == True:
                if usuario.IdPerfil == 2 or usuario.IdPerfil == 3:
                    return jsonify({'message': 'Usuario no autorizado'}), 400	
        
        expires = timedelta(hours=120)
        #change the fechaultimologin of the user
        usuario.Fechaultimologin = datetime.now()
        user=SAMM_UsuarioSchema().dump(usuario)
        access_token = create_access_token(identity=usuario.Codigo, expires_delta=expires)
        return jsonify(access_token=access_token, usuario=user), 200
    except Exception as e:
        return jsonify({'message': str(e)}), 500
    

@app.route('/loginPin', methods=['POST'])
@cross_origin()
def loginPin():
    data=request.get_json()
    if not data:
        return jsonify({'message': 'No input data provided'}), 400
    pin=data.get('Pin')
    if not pin:
        return jsonify({'message': 'No Pin provided'}), 400
    usuario = SAMM_Usuario.query.filter_by(Pin=pin).first()
    if not usuario:
        return jsonify({'message': 'Usuario no existe'}), 400
    if usuario.Estado != 'A' and usuario.Estado != 'T':
        return jsonify({'message': 'Usuario inactivo'}), 400
    if usuario.Confirmado == 'N':
        return jsonify({'message': 'Usuario no confirmado'}), 400
    expires = timedelta(hours=120)
    #change the fechaultimologin of the user
    usuario.Fechaultimologin = datetime.now()
    user=SAMM_UsuarioSchema().dump(usuario)
    access_token = create_access_token(identity=usuario.Codigo, expires_delta=expires)
    return jsonify(access_token=access_token, usuario=user), 200