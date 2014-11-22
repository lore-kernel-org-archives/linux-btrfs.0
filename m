Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:50244 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbaKVPUK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 22 Nov 2014 10:20:10 -0500
Received: from babycakes.localnet (localhost [127.0.0.1])
	by smtp.sws.net.au (Postfix) with ESMTP id E3DB6206E0
	for <linux-btrfs@vger.kernel.org>; Sun, 23 Nov 2014 02:20:07 +1100 (EST)
From: Russell Coker <russell@coker.com.au>
Reply-To: russell@coker.com.au
To: linux-btrfs@vger.kernel.org
Subject: open_ctree problem
Date: Sun, 23 Nov 2014 02:20:05 +1100
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_lmKcUcJLLzf5MoO"
Message-Id: <201411230220.05721.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Boundary-00=_lmKcUcJLLzf5MoO
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit

I have a workstation running Linux 3.14.something on a 120G SSD.  It recently 
had a problem and now the root filesystem can't be mounted, here is the 
message I get when trying to mount it read-only on Debian kernel 3.16.2-3:

[4703937.784447] BTRFS info (device loop0): disk space caching is enabled
[4703938.754247] BTRFS: log replay required on RO media
[4703938.794148] BTRFS: open_ctree failed

When I tried to boot it normally it gave a lot of kernel messages and failed 
to mount it.

Here's the error I get from the btrfs-zero-log in btrfs-tools 0.19+20130501-1:

# btrfs-zero-log yayia-corrupt 
extent buffer leak: start 157263929344 len 4096
*** Error in `btrfs-zero-log': corrupted double-linked list: 
0x0000000001068960 ***
Aborted

I installed btrfs-tools 3.17-1 and then btrfs-zero-log ran without error.  But 
when I tried to mount the filesystem I got the attached kernel error when 
trying to mount with Debian kernel 3.16.2-3.

Any suggestions on what I should do next?

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/

--Boundary-00=_lmKcUcJLLzf5MoO
Content-Type: application/x-gzip;
  name="dmesg.txt.gz"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename="dmesg.txt.gz"

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
lPb17CIulnn2zf8ATDKbNnhDAAA=

--Boundary-00=_lmKcUcJLLzf5MoO--
