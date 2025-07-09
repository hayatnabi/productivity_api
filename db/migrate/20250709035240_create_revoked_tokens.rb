class CreateRevokedTokens < ActiveRecord::Migration[8.0]
  def change
    create_table :revoked_tokens do |t|
      t.string :token

      t.timestamps
    end
  end
end
