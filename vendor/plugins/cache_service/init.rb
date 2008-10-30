# $Id$
# *****************************************************************************
# Copyright (C) 2005 - 2007 somewhere in .Net ltd.
# All Rights Reserved.  No use, copying or distribution of this
# work may be made except in accordance with a valid license
# agreement from somewhere in .Net LTD.  This notice must be included on
# all copies, modifications and derivatives of this work.
# *****************************************************************************
# $LastChangedBy$
# $LastChangedDate$
# $LastChangedRevision$
# *****************************************************************************
require File.join(File.dirname(__FILE__), "/lib/cache_service.rb")

# load cache related configuration file
Cache::Configuration.discover()

# inject class methods for object
Object.class_eval do
  include Cache::ClassMethods
end