Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from imap.kantaka.co.uk ([217.155.153.11]:39284 "EHLO
	arod.kantaka.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751046AbaARRAK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 18 Jan 2014 12:00:10 -0500
Received: from [217.155.153.12]
	by arod.kantaka.co.uk with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <phil@kantaka.co.uk>)
	id 1W4Yjt-00006Q-5i
	for linux-btrfs@vger.kernel.org; Sat, 18 Jan 2014 16:27:17 +0000
Message-ID: <52DAAB2C.9020805@kantaka.co.uk>
Date: Sat, 18 Jan 2014 16:26:20 +0000
From: Phil Armstrong <phil@kantaka.co.uk>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: [BUG]  Corrupt btrfs filesystem cannot be fixed by btrfs fsck or
 by mounting with -o restore
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is reported as bug 
https://bugzilla.kernel.org/show_bug.cgi?id=68951 since it causes a 
kernel panic - more details there.

The btrfs filesystem on my laptop became corrupted during a suspend / 
resume cycle. Afterwards, kernel 3.11 could no longer mount the 
filesystem and btrfs fsck crashed with abort() errors. Not having much 
time to deal with it, I took an image and re-installed the laptop from 
backups.

I've just tried to mount a copy of the image with 3.12, and the kernel 
successfully mounts, but a find . inside the fiesystem, segfaults. btrfs 
fsck dies with the error:

btrfsck: cmds-check.c:1320: walk_down_tree: Assertion `!(1)' failed.

I have a btrfs-image of the metadata, but it's 110Mb. I can probably 
make it available for download somewhere, meanwhile I'm happy to poke 
about if there's anything I can do to add more information.

Phil
