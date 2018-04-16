Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx.exactcode.de ([144.76.154.42]:57544 "EHLO mx.exactcode.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750716AbeDPPKU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Apr 2018 11:10:20 -0400
Received: from exactco.de ([90.187.5.221])
        by mx.exactcode.de with esmtp (Exim 4.82)
        (envelope-from <rene@exactcode.com>)
        id 1f85V4-0008O4-H6
        for linux-btrfs@vger.kernel.org; Mon, 16 Apr 2018 14:52:58 +0000
Received: from [192.168.2.174] (helo=[192.168.2.174])
        by exactco.de with esmtpsa (TLSv1:AES128-SHA:128)
        (Exim 4.54)
        id 1f84Ta-00066F-CJ
        for linux-btrfs@vger.kernel.org; Mon, 16 Apr 2018 13:47:27 +0000
From: =?windows-1252?Q?Ren=E9_Rebe?= <rene@exactcode.com>
Content-Type: text/plain; charset=windows-1252
Subject: Kernel unaligned access at ... btrfs_real_readdir+0x51c/0x718 [btrfs]
Message-Id: <CF3AC07F-83D7-41FE-ABE5-C442DAB29292@exactcode.com>
Date: Mon, 16 Apr 2018 16:52:16 +0200
To: linux-btrfs@vger.kernel.org
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I just installed the latest #t2sde test build on a sparc64 system with btrfs rootfs - you know, just for the fun of testing, and in contrast to my x86 and ppc systems I get tons of unaligned access warnings, in the form of:

[    0.000000] Btrfs loaded, crc32c=crc32c-generic
[    0.000000] BTRFS: device fsid c84acf49-452a-4ed3-ae86-576975967db5 devid 1 transid 42 /dev/sda3
[    0.000000] BTRFS info (device sda3): disk space caching is enabled
[    0.000000] BTRFS info (device sda3): has skinny extents
[    0.000000] Kernel unaligned access at TPC[102f3080] btrfs_real_readdir+0x51c/0x718 [btrfs]
[    0.000000] Kernel unaligned access at TPC[102f30dc] btrfs_real_readdir+0x578/0x718 [btrfs]
[    0.000000] Kernel unaligned access at TPC[102f313c] btrfs_real_readdir+0x5d8/0x718 [btrfs]
[    0.000000] Kernel unaligned access at TPC[102f31a0] btrfs_real_readdir+0x63c/0x718 [btrfs]
[    0.000000] Kernel unaligned access at TPC[102f3080] btrfs_real_readdir+0x51c/0x718 [btrfs]
[    0.000000] log_unaligned: 38289 callbacks suppressed
[    0.000000] Kernel unaligned access at TPC[102f3080] btrfs_real_readdir+0x51c/0x718 [btrfs]
[    0.000000] Kernel unaligned access at TPC[102f30dc] btrfs_real_readdir+0x578/0x718 [btrfs]
[    0.000000] Kernel unaligned access at TPC[102f313c] btrfs_real_readdir+0x5d8/0x718 [btrfs]
[    0.000000] Kernel unaligned access at TPC[102f31a0] btrfs_real_readdir+0x63c/0x718 [btrfs]
[    0.000000] Kernel unaligned access at TPC[102f3080] btrfs_real_readdir+0x51c/0x718 [btrfs]
[    0.000000] log_unaligned: 112774 callbacks suppressed

in case some someone likes to address those, or has a quick patch to test, … just let me know ;-)

Greetings,
	René Rebe

-- 
 ExactCODE GmbH, Lietzenburger Str. 42, DE-10789 Berlin
 http://exactcode.com | http://exactscan.com | http://ocrkit.com | http://t2-project.org | http://rene.rebe.de
