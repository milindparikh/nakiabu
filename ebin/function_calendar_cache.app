{application, function_calendar_cache,
 [{description, "Cache of Function Calendars"},
  {vsn, "0.1.0"},
  {modules, [
             fcc_app,
             fcc_root_sup,				
             fcc_function_version_sup,
	     fcc_function_version_element,
             fcc_function_calendar_sup,
	     fcc_function_calendar_element,
             fcc_store,
	     fcc_utils,
	     function_calendar_cache
            ]},
  {registered, [fcc_root_sup,
		fcc_function_calendar_sup, 
		fcc_function_version_sup]},
  {applications, [kernel, stdlib]},
  {mod, {fcc_app, []}}
 ]}.