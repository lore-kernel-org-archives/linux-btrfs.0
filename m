Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.flw5.de ([37.187.16.190]:53944 "EHLO mail.flw5.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750853AbcFXJdV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Jun 2016 05:33:21 -0400
Received: from [2001:470:78a0:fd:c642:196e:8260:1787] (helo=abraxas.flw5.de)
	by mail.flw5.de with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.87)
	id 1bGN7F-00005O-UH
	for linux-btrfs@vger.kernel.org; Fri, 24 Jun 2016 11:09:34 +0200
Received: from stefan by abraxas.flw5.de with local (Exim 4.87)
	(envelope-from <stefan@flw5.de>)
	id 1bGN79-0005xK-Lk
	for linux-btrfs@vger.kernel.org; Fri, 24 Jun 2016 11:09:27 +0200
Date: Fri, 24 Jun 2016 11:09:27 +0200
From: Stefan Schweizer <stefan@flw5.de>
To: linux-btrfs@vger.kernel.org
Subject: btrfs-convert: Unable to find block group for 0
Message-ID: <20160624090927.GD31030@abraxas.flw5.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

While trying to convert a ext4 filesystem to btrfs with the new btrfs-convert from btrfs-progs-4.6 I
got the following error:

create btrfs filesystem:
        blocksize: 4096
        nodesize:  16384
        features:  extref, skinny-metadata (default)
creating ext2 image file.
Unable to find block group for 0
extent-tree.c:289: find_search_start: Assertion `1`
failed.
./btrfs-convert(btrfs_reserve_extent+0x8e9)[0x41979d]
./btrfs-convert(btrfs_alloc_free_block+0x50)[0x419b27]
./btrfs-convert[0x40b8d8]
./btrfs-convert(btrfs_search_slot+0x13f7)[0x40d9d6]
./btrfs-convert(btrfs_csum_file_block+0x3b5)[0x41f144]
./btrfs-convert[0x4387b1]
./btrfs-convert(main+0x2013)[0x43d180]
/lib/x86_64-linux-gnu/libc.so.6(__libc_start_main+0xf0)[0x7fca6bb895f0]
./btrfs-convert(_start+0x29)[0x4082b9]

Before I already tried btrfs-convert from btrfs-progs-4.5.2 which I
accidentally aborted but until then seemed to run fine.
