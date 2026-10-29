import '../dtos/sales/create_sale_dto.dart';
import '../dtos/sales/sale_response_dto.dart';
import '../dtos/sales/update_sale_dto.dart';

abstract class SaleService {
  Future<List<SaleResponseDto>> getAll({String? statusFilter, String? query});
  Future<SaleResponseDto?> getById(String id);
  Future<SaleResponseDto> create(CreateSaleDto dto);
  Future<SaleResponseDto> update(UpdateSaleDto dto);
  Future<bool> delete(String id);
}
