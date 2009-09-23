From: Goffredo Baroncelli <kreijack@alice.it>
Subject: Btrfs programs repository a bit old ?
Date: Wed, 23 Sep 2009 20:01:42 +0200
Message-ID: <200909232001.43202.kreijack@alice.it>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I noticed that the official repository[*] for the btrfs program is quite old. 
The last commit is dated June 2009.

   btrfs-progs-unstable$ git log | head -3
   commit 4f89b6eb0718ade63152791db32794da78fbba70
   Author: Yan Zheng <zheng.yan@oracle.com>
   Date:   Fri Jun 12 12:55:50 2009 -0400

I am interested to test the Yan's patches about the snapshot removing, but I 
need the btrfs utils updated !

Is there another updated repository for the btrfs programs or I have to apply 
the Yan's patches by hands :-)

BR
G.Baroncelli


[*] git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs-
unstable.git
-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijackATinwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
