Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:56726 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489AbaEKJnV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 11 May 2014 05:43:21 -0400
Received: from babycakes.localnet (localhost [127.0.0.1])
	by smtp.sws.net.au (Postfix) with ESMTP id EFA762085E
	for <linux-btrfs@vger.kernel.org>; Sun, 11 May 2014 19:43:18 +1000 (EST)
From: Russell Coker <russell@coker.com.au>
Reply-To: russell@coker.com.au
To: linux-btrfs@vger.kernel.org
Subject: -musage=>0 means always reporting relocation
Date: Sun, 11 May 2014 19:43:16 +1000
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <201405111943.16913.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Below is the output of running a balance a few times on a 120G SSD.

It seems that whenever I set the metadata usage to be greater than 0 it will 
report relocating something, regardless of whether that's possible.

root@server:~# btrfs fi balance start -dusage=0 -musage=0 /
Done, had to relocate 0 out of 108 chunks
root@server:~# btrfs fi balance start -dusage=0 -musage=0 /
Done, had to relocate 0 out of 108 chunks
root@server:~# btrfs fi balance start -dusage=0 -musage=10 /
Done, had to relocate 1 out of 108 chunks
root@server:~# btrfs fi balance start -dusage=0 -musage=10 /
Done, had to relocate 1 out of 108 chunks
root@server:~# btrfs fi balance start -dusage=0 -musage=10 /
Done, had to relocate 1 out of 108 chunks
root@server:~# btrfs fi balance start -dusage=0 -musage=10 /
Done, had to relocate 1 out of 108 chunks
root@server:~# btrfs fi balance start -dusage=0 -musage=1 /
Done, had to relocate 1 out of 108 chunks
root@server:~# btrfs fi balance start -dusage=0 -musage=0 /
Done, had to relocate 0 out of 108 chunks
root@server:~# btrfs fi balance start -dusage=1 -musage=0 /
Done, had to relocate 0 out of 108 chunks
root@server:~# btrfs fi balance start -dusage=10 -musage=0 /
Done, had to relocate 0 out of 108 chunks

During each run of -musage=N I'd get a couple of kernel lines like the 
following.  It was apparently doing something, but whatever that was probably 
wasn't useful.

[1394107.479342] BTRFS info (device dm-0): relocating block group 766120755200 
flags 34
[1394107.589661] BTRFS info (device dm-0): found 2 extents

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
