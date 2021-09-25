package com.airplane.pension.dao;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;

import com.airplane.pension.dto.AdminDto;

public class AdminImplDao implements AdminDao{

	@Autowired
	SqlSession sqlsession;
	
	@Override
	public AdminDto login(AdminDto dto) throws Exception {
		return sqlsession.selectOne("admin.adminLogin", dto);
	}
}
