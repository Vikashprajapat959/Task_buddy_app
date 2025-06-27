class PasswordValidator { 
  //  Function to validate password
    static String? validate(String password) {
   if (password.isEmpty) {
     return 'Password is required'; 
     } if (password.length < 8) 
     {
       return 'Password must be at least 8 characters';
        } if (!RegExp(r'[A-Z]').hasMatch(password)) {
           return 'Must include at least one uppercase letter';
            } if (!RegExp(r'[a-z]').hasMatch(password))
             {
               return 'Must include at least one lowercase letter';
                }
                 if (!RegExp(r'[0-9]').hasMatch(password))
                  {
                   return 'Must include at least one number';
                    }
                    if (!RegExp(r'[!@#\$&_\-\*]').hasMatch(password))
                     {
                       return 'Must include at least one special character (!@#\$&*_-)' ; 
                       } 
                    return null; // ✅ Valid password  
                       }
                        }