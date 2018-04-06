class Tool < ApplicationRecord
  belongs_to :owner, class_name: "User", foreign_key: 'user_id'
  has_many :reviews
  has_many :loans
  has_many :borrowers, through: :loans, source: :borrower

  has_many :owner_images

  validates :name, :condition, :description, :loan_length, presence: true
  validates :condition, numericality: { only_integer: true, greater_than: 0, less_than: 11 }


  def lend_out
    self.on_loan = true
    self.save
  end

  def get_back
    self.on_loan = false
    self.save
  end

  def active_loan
    if self.on_loan == true
      Loan.find_by(user_id: self.current_borrower.id, tool_id: self.id, active: true)
    end
  end

  def self.search(tool_name, neighbourhood_name)
    if tool_name != "" && neighbourhood_name != ""
      tools = []

      where('name iLIKE ?', "%#{tool_name}%").each do |tool|
        if tool.owner.neighbourhood.name == neighbourhood_name
          tools << tool
        end
      end

      return tools

    elsif tool_name != ""
      where('name iLIKE ?', "%#{tool_name}%")

    elsif neighbourhood_name != ""
      tools = []

      all.each do |tool|
        if tool.owner.neighbourhood.name == neighbourhood_name
          tools << tool
        end
      end

      return tools

    else
      all
    end
  end

  def current_borrower
    if self.on_loan == true
      Loan.find_by(tool_id: self.id, active: true).borrower
    end
  end

end
