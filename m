Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:57906 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752573Ab3JYNqv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Oct 2013 09:46:51 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VZhiv-0002QJ-0M
	for linux-btrfs@vger.kernel.org; Fri, 25 Oct 2013 15:46:45 +0200
Received: from 63-245-179-205.ip.mtelco.net ([63-245-179-205.ip.mtelco.net])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Oct 2013 15:46:45 +0200
Received: from jgoerzen by 63-245-179-205.ip.mtelco.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Oct 2013 15:46:45 +0200
To: linux-btrfs@vger.kernel.org
From: John Goerzen <jgoerzen@complete.org>
Subject: Excessive RAM usage in =?utf-8?b?YnRyZnNfaW5vZGU=?= & =?utf-8?b?YnRyZnNfZGVsYXllZF9ub2Rl?=
Date: Fri, 25 Oct 2013 13:46:24 +0000 (UTC)
Message-ID: <loom.20131025T154209-63@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

This is an x86_64 box running 3.10.  It is presently running restore from
the e2fs dump/restore, restoring a dump made on an ext4 system onto a btrfs
filesystem.  The btrfs filesystem is the only btrfs filesystem mounted on
the machine, and it is mounted with only the noatime mount option.  It
begins by creating millions of directories.  During this process, I observed
strangeness in top:

KiB Mem:   8180424 total,  8033296 used,   147128 free,      356 buffers
KiB Swap:  4194300 total,  1941492 used,  2252808 free,    61740 cached

  PID USER      PR  NI  VIRT  RES  SHR S  %CPU %MEM    TIME+  SWAP COMMAND 
             
 9551 root      20   0 6767m 5.3g  228 R  95.1 68.2 631:52.89 1.2g restore 
             
 9550 root      20   0  529m  29m  168 S   0.0  0.4   0:26.85 471m mbuffer 
             
 3916 root      20   0  146m 1424  668 S   0.0  0.0   0:00.28  340
NetworkManager        
10534 root      20   0  126m 1612  560 S   0.0  0.0   0:01.07   16
udisks-daemon         
 4750 root      20   0  126m  772  432 S   0.0  0.0   0:00.05  824
console-kit-dae       
 3388 root      20   0  116m  564  140 S   0.0  0.0   0:00.20  692 rsyslogd
             

The system has 8GB RAM, and restore is using less than 7GB.  The system is
otherwise idle and I had carefully plucked any other even slightly large
processes.  Yet it is 2GB into swap and has very little RAM free.  To
investigate that, I turned to slabtop, and found:

 Active / Total Objects (% used)    : 3058057 / 3117455 (98.1%)
 Active / Total Slabs (% used)      : 539669 / 539716 (100.0%)
 Active / Total Caches (% used)     : 121 / 212 (57.1%)
 Active / Total Size (% used)       : 1759683.27K / 1770895.45K (99.4%)
 Minimum / Average / Maximum Object : 0.02K / 0.57K / 4096.00K

  OBJS ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME                   
1145183 1145183 100%    0.29K  88091       13    352364K btrfs_delayed_node
1145181 1145181 100%    1.02K 381727        3   1526908K btrfs_inode
478060 477416  99%    0.19K  23903       20     95612K dentry
135908 134151  98%    0.94K  33977        4    135908K ext4_inode_cache
 45816  38564  84%    0.04K    498       92      1992K ext4_extent_status
 28000  22874  81%    0.55K   4000        7     16000K radix_tree_node
 21930  21633  98%    0.11K    645       34      2580K sysfs_dir_cache
 20827   8033  38%    0.06K    353       59      1412K kmalloc-64
 11872  11122  93%    0.03K    106      112       424K kmalloc-32


It seems there is something about btrfs_inode in particular that is
consuming a vast amount of RAM.  Any ideas?

Thanks,

John

