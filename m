Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:57790 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750850AbbBXLfF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Feb 2015 06:35:05 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YQDlX-0004nG-CX
	for linux-btrfs@vger.kernel.org; Tue, 24 Feb 2015 12:35:03 +0100
Received: from netz.smurf.noris.de ([213.95.21.43])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Feb 2015 12:35:03 +0100
Received: from matthias by netz.smurf.noris.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Feb 2015 12:35:03 +0100
To: linux-btrfs@vger.kernel.org
From: Matthias Urlichs <matthias@urlichs.de>
Subject: Non-unmountable file system
Date: Tue, 24 Feb 2015 10:56:47 +0000 (UTC)
Message-ID: <loom.20150224T114621-47@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is btrfs with kernel 3.19. (.0-trunk from Debian), on a single volume
(on top of LVM but that should not matter).

I do this, on a freshly-booted system:
# mount /foo
# cd foo
# rsync -aPHAX . /bar
[ after an hour or so ]
^C
# cd ..
# fuser -m /foo
# ps ax | grep "[ /]rsync"
# umount /foo
umount: /dev/mapper/data-foo: target is busy
# 

Any idea what could possible be going on here?


NB: "after an hour": no wonder, when I see this in strace:

11:41:51.929033 stat("cpool/0/0/5/0058f2c720f7567989a0f4d33e5c8eb4",
{st_mode=S_IFREG|0640, st_size=65, ...}) = 0 <0.000015>
11:41:51.929077 llistxattr("cpool/0/0/5/0058f2c720f7567989a0f4d33e5c8eb4",
"", 1024) = 0 <0.000025>
11:41:51.929130 lstat("cpool/0/0/5/005ee7df1e1fa3a7cf6cbbff5e25b1eb",
{st_mode=S_IFREG|0640, st_size=54, ...}) = 0 <0.598521> <<***!!!***
11:41:52.527730 getxattr("cpool/0/0/5/005ee7df1e1fa3a7cf6cbbff5e25b1eb",
"system.posix_acl_access", 0x7fff32f63090, 132) = -1 ENODATA (No data
available) <0.000022>
11:41:52.527829 stat("cpool/0/0/5/005ee7df1e1fa3a7cf6cbbff5e25b1eb",
{st_mode=S_IFREG|0640, st_size=54, ...}) = 0 <0.000016>

The directory in question has 300 entries and the disks on which this
filesystem resides are otherwise idle and do not report any errors, SMART or
otherwise.

https://bugzilla.kernel.org/show_bug.cgi?id=93781



