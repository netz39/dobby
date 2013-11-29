
/*
 * GET home page.
 */

exports.index = function(req, res, data){
  res.render('index', { title: 'Express' });
};
