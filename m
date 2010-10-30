From: Hugo Mills <hugo@carfax.org.uk>
Subject: [patch 0/2] Control filesystem balances (kernel side)
Date: Sat, 30 Oct 2010 01:07:26 +0100
Message-ID: <20101030000726.286517546@carfax.org.uk>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

   These two patches give a degree of control over balance operations.
The first makes it possible to get an idea of how much work remains to
do, by tracking the number of block groups (chunks) that need to be
moved/rewritten. The second patch allows a running balance operation
to be cancelled when the current block group has been moved.

   One fundamental question, though -- is the progress monitor
function best implemented as an ioctl, as I've done here, or should it
be two or three sysfs files? I'm thinking of /proc/mdstat...
Obviously, /proc/mdstat would never get into /sys, but exposing the
"expected" and "remaining" values as files has an attractive
simplicity to it.

   The user-space side of things are in a separate patch series, to
follow.

   Please be gentle with me, this is my first (serious, non-trivial)
kernel patch. :)

   Hugo.


-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- "No!  My collection of rare, incurable diseases! Violated!" ---   

