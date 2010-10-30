From: Hugo Mills <hugo@carfax.org.uk>
Subject: [patch 0/2] Control filesystem balances (userspace)
Date: Sat, 30 Oct 2010 01:10:22 +0100
Message-ID: <20101030001022.247934404@carfax.org.uk>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

   These two patches complement the previous two kernel-side
patches. The first implements a way of displaying the current progress
of any running balance process. The second patch allows a running
balance to be cancelled.

   I'm a bit uncertain about the best name for these commands. Several
options:

1)
# btrfs filesystem progress <path>
# btrfs filesystem cancel <path>

   Way too vague (cancel *what*?)


2)
# btrfs filesystem balance-progress <path>
# btrfs filesystem balance-cancel <path>

   Clashes horribly with "filesystem balance" -- no abbreviations
possible.


3)
btrfs filesystem balance -p <path>
btrfs filesystem balance -c <path>

   Changes behaviour significantly on a switch, in contrast to the
behaviour of the rest of the btrfs tool.


4)
btrfs balance progress <path>
btrfs balance cancel <path>

   My current favourite, although we introduce a new namespace
("balance") for commands. We could add "btrfs balance start <path>" as
a synonym for "btrfs filesystem balance <path>", for some degree of
consistency.

   At some point, I'll add a "monitor" function, which will poll at 1s
intervals for progress updates, and print out progress when it changes.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- "No!  My collection of rare, incurable diseases! Violated!" ---   

