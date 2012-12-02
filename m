Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtprelay03.ispgateway.de ([80.67.31.26]:44536 "EHLO
	smtprelay03.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751748Ab2LBJtU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 2 Dec 2012 04:49:20 -0500
Received: from [91.65.33.110] (helo=server.fritz.box)
	by smtprelay03.ispgateway.de with esmtps (TLSv1:AES256-SHA:256)
	(Exim 4.68)
	(envelope-from <btrfs@nentwig.biz>)
	id 1Tf62Q-0005I3-Ro
	for linux-btrfs@vger.kernel.org; Sun, 02 Dec 2012 10:40:38 +0100
Date: Sun, 2 Dec 2012 10:40:38 +0100 (CET)
From: Timo Nentwig <btrfs@nentwig.biz>
To: linux-btrfs@vger.kernel.org
Subject: 3 root nodes, -o recovery/btrfs has no effect
Message-ID: <alpine.LNX.2.00.1212021127110.1570@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi there,

I had remote filesystem not unmounting during shutdown so I hit the reboot 
button. Did so a couple of times in the past. 3.6.8-1-ARCH, btrfs-progs 
0.19.20121005-4, don't remember the exact version I used when creating the 
filesystem (0.19 something).

btrfsck looks like this:

checking extents
checking fs roots
parent transid verify failed on 167047168 wanted 713090 found 713088
parent transid verify failed on 167047168 wanted 713090 found 713088
parent transid verify failed on 167047168 wanted 713090 found 713088
parent transid verify failed on 167047168 wanted 713090 found 713088
Ignoring transid failure
parent transid verify failed on 167047168 wanted 713090 found 713088
Ignoring transid failure

(repeating ~1800 times, always with the same IDs)

root 5 inode 8156558 errors 400
root 5 inode 9930070 errors 800
root 5 inode 9930168 errors 800

Tried -o recovery, mounts instantly and apparently doesn't change anything; 
tried btrfs --repair, doesn't appear to change anything as well.

Did mkfs.btrfs in order to restore from backup but mounting failed (broken 
superblock something). How can a freshly mkfs'ed fs not mount?! I restored a dd 
dump I took beforehand, mounts, boots but is broken.

Any suggestions?

thx
tcn

BTW what do multiple root nodes mean actually? That I do have 3 different
trees with individual nodes pointing to different versions of data?
