From: Jan Engelhardt <jengelh@medozas.de>
Subject: btr fs unmountable after disk failure
Date: Fri, 13 Apr 2012 12:55:43 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1204131252070.26191@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


I originally created a RAID1(0) compound out of 4 drives. One of them 
[sdf] failed recently and was removed. The filesystem is no longer 
mountable with the 3 drives left.
On 3.3.1:

# btrfs dev scan
[ 1065.572938] device label srv devid 1 transid 11386 /dev/sdc
[ 1065.573044] device label srv devid 3 transid 11386 /dev/sde
[ 1066.089981] device label srv devid 2 transid 11386 /dev/sdd
# mount /dev/sdd /top.srv
[ 1070.201339] device label srv devid 2 transid 11386 /dev/sdd
[ 1070.201666] btrfs: disk space caching is enabled
[ 1070.203310] btrfs: failed to read the system array on sde
[ 1070.204458] btrfs: open_ctree failed
(Sparse error message, innit..)
