From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: passing positive numbers to ERR_PTR()
Date: Wed, 8 Feb 2012 12:18:09 +0300
Message-ID: <20120208085712.GA6554@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Jan,

Smatch complains when you pass positive numbers to ERR_PTR().  There
is a warning triggered in iref_to_path().

fs/btrfs/backref.c +920 iref_to_path()
   918  
   919          if (ret)
   920                  return ERR_PTR(ret);
                                       ^^^
"ret" can be either a negative error code, zero, or one here.

   921  

I looked at the code, but couldn't tell if it was intentional or not.
It really is pretty unusual to do that, so maybe there should be a
comment or something.

regards,
dan carpenter
