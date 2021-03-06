require "csv"

class MaterialDbToCsv
  SIMPLE_ATTRS = [
    :circuitdata_material_db_id,
    :cti,
    :df,
    :dielectric_breakdown,
    :dk,
    :electric_strength,
    :finish,
    :flexible,
    :foil_roughness,
    :function,
    :group,
    :ipc_sm_840_class,
    :ipc_standard,
    :link,
    :mot,
    :name,
    :t260,
    :t280,
    :t300,
    :td_min,
    :tg_min,
    :thermal_conductivity,
    :water_absorption,
    :z_cte,
    :z_cte_after_tg,
    :z_cte_before_tg,
  ]

  COLUMNS = SIMPLE_ATTRS + [
    :manufacturer,
    :ipc_slash_sheet,
    :ul94,
  ]

  def headers
    COLUMNS
  end

  def body
    @body ||= build_body
  end

  def to_csv
    column_names = body.first.keys
    CSV.generate do |csv|
      csv << column_names
      body.each do |x|
        csv << x.values
      end
    end
  end

  private

  def build_body
    attr_names = SIMPLE_ATTRS.map(&:to_s)
    materials.map do |material|
      {
        circuitdata_material_db_id: material.id,
        manufacturer: material.manufacturer&.name,
        ul94: material.ul_94,
        ipc_slash_sheet: values(material, "ipc_slash_sheet"),
      }.merge(material.attributes.slice(*attr_names)).transform_values(&:to_s)
    end
  end

  def materials
    Material.includes(:manufacturer)
      .order("manufacturers.name", :name)
  end

  def values(material, attr)
    material[attr]&.join("|")
  end
end
