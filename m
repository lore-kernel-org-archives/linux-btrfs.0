Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:45721 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752695AbbGFVwe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Jul 2015 17:52:34 -0400
Received: from svh-gw.merlins.org ([173.11.111.145]:53280 helo=legolas.merlins.org)
	by mail1.merlins.org with esmtps
	(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128) (Exim 4.80 #2)
	id 1ZCEJ9-0007rA-19
	for <linux-btrfs@vger.kernel.org>; Mon, 06 Jul 2015 14:52:14 -0700
Received: from merlin by legolas.merlins.org with local (Exim 4.80)
	(envelope-from <merlin@merlins.org>)
	id 1ZCEJ8-0003xM-1J
	for linux-btrfs@vger.kernel.org; Mon, 06 Jul 2015 14:52:10 -0700
Date: Mon, 6 Jul 2015 14:21:56 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Message-ID: <20150706212156.GY17274@merlins.org>
MIME-Version: 1.0
Subject: btrfs check --repair crash, and btrfs-cleaner crash
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


myth:~# btrfs check --repair /dev/mapper/crypt_sdd1 
enabling repair mode
Checking filesystem on /dev/mapper/crypt_sdd1
UUID: 024ba4d0-dacb-438d-9f1b-eeb34083fe49
checking extents
cmds-check.c:4486: add_data_backref: Assertion `back->bytes != max_size` failed.
btrfs[0x8066a73]
btrfs[0x8066aa4]
btrfs[0x8067991]
btrfs[0x806b4ab]
btrfs[0x806b9a3]
btrfs[0x806c5b2]
btrfs(cmd_check+0x1088)[0x806eddf]
btrfs(main+0x153)[0x80557c6]
/lib/i386-linux-gnu/libc.so.6(__libc_start_main+0xf3)[0xb75064d3]
btrfs[0x80557ec]

myth:~# btrfs --version
btrfs-progs v4.0

Is anyone interested in getting data off this filesystem or having me
try newer code/a patch?

filesystem is 10TB-ish, so sending an image isn't going to be easy though.

I can mount with -o ro without it crashing, but if I drop ro, it then
tries to do something and crashes, and unfortunately the error doesn't
make it to syslog

Screenshot: http://marc.merlins.org/tmp/btrfs_crash.jpg

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
