From: Hugo Mills <hugo@carfax.org.uk>
Subject: [patch v3 0/4] Size reporting of btrfs tool
Date: Tue, 26 Oct 2010 13:23:44 +0100
Message-ID: <20101026122344.934075672@carfax.org.uk>
Cc: Goffredo Baroncelli <kreijack@libero.it>,
	Frank Kingswood <frank@kingswood-consulting.co.uk>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

   While playing around with resizing volumes recently, I realised
that I didn't know whether btrfs fi show and btrfs fi df reported
sizes in ISO (e.g. powers of 10^3) units, as they appear to from the
labels they use, or in binary (powers of 2^10) units. Also, a mere
three significant figures is somewhat less than I'm comfortable with
if I'm about to resize the containing block device downwards.
   
   This patch series adds the ability to pick which scale is used for
show and df, and labels the amounts properly (e.g. MB for ISO, MiB for
binary units).

   I've incorporated Frank's suggestion of defaulting to raw, and
matching coreutils' use of -h and -H. I've also updated the man pages
and command help as requested by Goffredo.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
    --- Jazz is the sort of music where no-one plays anything the ---    
                             same way once.                              

