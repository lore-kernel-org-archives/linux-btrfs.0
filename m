From: Goffredo Baroncelli <kreijack@libero.it>
Subject: [PATCH 0/5][REPOST][BTRFS-PROGS] Repost of some patches
Date: Sun, 5 Dec 2010 18:46:41 +0100
Message-ID: <201012051846.42073.kreijack@libero.it>
Reply-To: kreijack@libero.it
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Cc: linux-btrfs@vger.kernel.org
To: chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

in the next emails, I will repost some patches which never were merged in the 
btrfs-progs repository. 
Two patches are document only and not add new functions, in particular:

patch-1) this patch correct some little problem in the help page
patch-2) this patch makes the error more verbose

The next patch (#3) doesn't add a new functionality, but declare as deprecated 
the old programs like btrfs-show, btrfs-vol, btrfsctl; this because these 
utilities are superseded by the "btrfs" command.

The last two patches (#4 and #5) add a new function to the btrfs command:
patch-4) this patch avoids to scan device like cdrom and/or floppy when a 
automatic volume discovery is performed.
patch-5) this patch adds a "filesystem label" command to change a label for an 
unmounted volume. 

Chris all these patches were already posted in the past. Some are very trivial 
(like the #1 and #2). Regarding the #3 I know that you agreed that btrfs is 
better that btrfsctl, so I hope that this patch may be accepted quickly. 
Finally regarding the last two, they adedded new functionality; so if you 
complain and/or suggestion I am open to improve it.

Regards
Goffredo

-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
