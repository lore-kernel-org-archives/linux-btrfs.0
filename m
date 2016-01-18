Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:38831 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982AbcARA1t (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 17 Jan 2016 19:27:49 -0500
Received: from merlin by mail1.merlins.org with local (Exim 4.80 #2)
	id 1aKxfg-0005xj-Ga by authid <merlin>
	for <linux-btrfs@vger.kernel.org>; Sun, 17 Jan 2016 16:27:48 -0800
Date: Sun, 17 Jan 2016 16:27:48 -0800
From: Marc MERLIN <marc@merlins.org>
To: Btrfs mailing list <linux-btrfs@vger.kernel.org>
Subject: BTRFS: bdev /dev/mapper/dshelf1 errs: wr 2970, rd 848, flush 0, corrupt 189, gen 0
Message-ID: <20160118002748.GE12045@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

So, I had an FS with a few issues, I ran btrfs check --repair to completion

Then, after mounting, I still get this warning.
Shouldn't those error counters be reset after check --repair?

Kernel: 4.2.5
Btrfs-tools: 4.3-1

If that matters, here's the output of check --repair (captured with script
-f, so the output is a bit wrong):
gargamel:~# btrfs check --repair -p /dev/mapper/dshelf1
enabling repair mode
Checking filesystem on /dev/mapper/dshelf1
UUID: 6358304a-2234-4243-b02d-4944c9af47d7
badcextentx[29368320, 29372416), type mismatch with chunk
bad extent [29372416, 29376512), type mismatch with chunk

(2856970 lines deleted)

bad extent [8697338122240, 8697338126336), type mismatch with chunk
bad extent [8697338126336, 8697338130432), type mismatch with chunk
bad extent [8697338130432, 8697338134528), type mismatch with chunk
checking extents [.]

repaired damaged extent references

Fixed 0 roots.
cache and super generation don't match, space cache will be invalidated
Fixedidiscountofileoextents for inode: 204450 in root: 45851
FixedidiscountofileOextents for inode: 204452 in root: 45851
root 45851 inode 204452 errors 40, bad file extent
Fixedidiscountofileoextents for inode: 204452 in root: 45851
root 45851 inode 204452 errors 40, bad file extent
rootk45851sinodes204452 errors 40, bad file extent
FixedidiscountofileOextents for inode: 204450 in root: 45852
FixedidiscountofileOextents for inode: 204452 in root: 45852
checking fs roots [o]
rootk45851sinodes204452 errors 40, bad file extent
Fixedidiscountofile.extents for inode: 204450 in root: 45856
Fixed discount file extents for inode: 204452 in root: 45856
rootk45851sinodes204452 errors 40, bad file extent
warninggliner3653 [o]

checking csums
checking root refs
found 9826147025859 bytes used err is 0
total csum bytes: 9584068648
total tree bytes: 12200706048
total fs tree bytes: 330457088
total extent tree bytes: 498716672
btree space waste bytes: 1372963760
file data blocks allocated: 9976766078976
 referenced 9987816431616
btrfs-progs v4.3

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
