import '../dtos/customers/create_customer_dto.dart';
import '../dtos/customers/customer_response_dto.dart';
import '../dtos/customers/update_customer_dto.dart';

abstract class CustomerService {
  Future<List<CustomerResponseDto>> getAll({String? query});
  Future<CustomerResponseDto?> getById(String id);
  Future<CustomerResponseDto> create(CreateCustomerDto dto);
  Future<CustomerResponseDto> update(UpdateCustomerDto dto);
  Future<bool> delete(String id);
}
