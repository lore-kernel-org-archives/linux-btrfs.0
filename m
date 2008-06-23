From: "Jeff Schroeder" <jeffschroed@gmail.com>
Subject: HP opensourced advfs from tru64 and what it means for btrfs
Date: Mon, 23 Jun 2008 07:37:32 -0700
Message-ID: <c24352ca0806230737g287de15bv5916d1c7501f06be@mail.gmail.com>
Reply-To: jeffschroeder@computer.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

http://advfs.sourceforge.net/ HP open sourced the advfs filesystem
from tru64 Unix today under the gplv2.

>From the page

"""
Our objective is to make the code available so that Linux developers
can pick and choose pieces
that make sense for existing and new linux file systems.  Its also a
good reference for anyone
interested in file systems.  However, we discourage Tru64 users from
trying to build and use the
code as it won't be supported by HP on Tru64.
"""

Would it make sense to look at using any of the code from this in
btrfs, or would it be easier to
re-implement it all over again? Even though filesystems ported from
other Posix operating systems to Linux (Ever looked at XFS code)
can be ugly, this might be a way to accelerate btrfs development.
If nothing else, it might be interesting to see how HP solved problems
btrfs will soon be solving.

-- 
Jeff Schroeder

Don't drink and derive, alcohol and analysis don't mix.
http://www.digitalprognosis.com
