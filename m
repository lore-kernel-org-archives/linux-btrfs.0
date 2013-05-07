Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 110-174-82-20.static.tpgi.com.au ([110.174.82.20]:46983 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753821Ab3EGJrU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 May 2013 05:47:20 -0400
Received: from athena.localnet (unknown [10.10.10.1])
	by smtp.sws.net.au (Postfix) with ESMTP id 6A42081713
	for <linux-btrfs@vger.kernel.org>; Tue,  7 May 2013 19:38:09 +1000 (EST)
From: Russell Coker <russell@coker.com.au>
Reply-To: russell@coker.com.au
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: btrfs-progs compile warnings on i386
Date: Tue, 7 May 2013 19:38:03 +1000
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <201305071938.03938.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

https://git.kernel.org/cgit/linux/kernel/git/mason/btrfs-progs.git/

I've just tried building btrfs-progs on i386 with a git pull from a few 
minutes ago and I got the following warnings:

    [CC]     btrfs-list.o
btrfs-list.c: In function 'filter_by_parent':
btrfs-list.c:1183:34: warning: cast to pointer from integer of different size 
[-Wint-to-pointer-cast]
    [CC]     cmds-subvolume.o
cmds-subvolume.c: In function 'cmd_subvol_show':
cmds-subvolume.c:917:5: warning: cast from pointer to integer of different size 
[-Wpointer-to-int-cast]
    [CC]     cmds-restore.o
cmds-restore.c: In function 'decompress_lzo':
cmds-restore.c:116:10: warning: passing argument 4 of 'lzo1x_decompress_safe' 
from incompatible pointer type [enabled by default]
In file included from cmds-restore.c:31:0:
/usr/include/lzo/lzo1x.h:77:1: note: expected 'lzo_uint *' but argument is of 
type 'size_t *'

I've compiled it on Debian/Wheezy on i386 and AMD64.  On AMD64 there are no 
warnings but the above warnings appear on i386.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
