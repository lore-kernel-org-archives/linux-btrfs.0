Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from euve10025.vserver.de ([62.75.240.21]:59268 "EHLO ensieve.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754375Ab3LGV4f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 7 Dec 2013 16:56:35 -0500
Received: from frnk-5f744b17.pool.mediaways.net ([95.116.75.23]:63118 helo=[192.168.0.110])
	by ensieve.org with esmtpsa (TLS1.0:RSA_AES_128_CBC_SHA1:128)
	(Exim 4.80)
	(envelope-from <pascal@ensieve.org>)
	id 1VpPTN-0006vA-Gv
	for linux-btrfs@vger.kernel.org; Sat, 07 Dec 2013 21:31:37 +0000
From: Pascal Germroth <pascal@ensieve.org>
Content-Type: text/plain; charset=us-ascii
Subject: clone syscall fails for bedup-deduplicated files
Message-Id: <1A5C61DD-175B-4220-BAB5-E5714810501B@ensieve.org>
Date: Sat, 7 Dec 2013 22:31:30 +0100
To: linux-btrfs@vger.kernel.org
Mime-Version: 1.0 (Mac OS X Mail 7.0 \(1822\))
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Running a 3.8 kernel I've been using bedup to deduplicate some files, for example two identical 500MB files A & B now share data chunks.
Running a 3.11 kernel, I wanted to clone some more files, but those previously deduplicated by bedup don't work, for example: `cp --reflink A C`:

open("A", O_WRONLY|O_TRUNC) = 4
fstat(4, {st_mode=S_IFREG|0775, st_size=0, ...}) = 0
ioctl(4, BTRFS_IOC_CLONE, 0x3) = -1 EINVAL (Invalid argument)

But I can clone a duplicate of the file just fine: `cp A D; cp --reflink D E` copies A to D and then clones D to E.
So I guess the way bedup deduplicated A broke the btrfs structure in a way that forbids further cloning, but a newly generated file like D can still be cloned.

How could bedup break this, did it manipulate the structures directly in 3.8 without the syscall and corrupt something? How can I repair this? Defragmenting A had no effect.

(If you answer, please CC me directly, I'm not currently subscribed to the list)

Cheers,

-- 
Pascal Germroth