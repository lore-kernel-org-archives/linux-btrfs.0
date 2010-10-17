From: hugo-lkml@carfax.org.uk
Subject: (unknown)
Date: Sun, 17 Oct 2010 19:18:46 +0100
Message-ID: <E1P7Xok-0003Al-AH@vlad.carfax.org.uk>
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

>From hugo-lkml@carfax.org.uk Sun Oct 17 19:13:46 2010
Message-Id: <20101017181321.592805312@carfax.org.uk>
User-Agent: quilt/0.48-1
Date: Sun, 17 Oct 2010 19:13:21 +0100
From: hugo-lkml@carfax.org.uk
To: linux-btrfs@vger.kernel.org
Subject: [patch 0/4] Size reporting of userspace tools

   While playing around with resizing volumes recently, I realised
that I didn't know whether btrfs fi show and btrfs fi df reported
sizes in ISO (e.g. powers of 10^3) units, as they appear to from the
labels they use, or in binary (powers of 2^10) units. Also, a mere
three significant figures is somewhat less than I'm comfortable with
if I'm about to resize the containing block device downwards.

   This patch series adds the ability to pick which scale is used for
show and df, and labels the amounts properly (e.g. MB for ISO, MiB for
binary units).

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
        --- emacs:  Eighty Megabytes And Constantly Swapping. ---        

