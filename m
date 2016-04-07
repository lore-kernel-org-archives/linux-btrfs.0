Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f47.google.com ([209.85.218.47]:34701 "EHLO
	mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753639AbcDGBMD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Apr 2016 21:12:03 -0400
Received: by mail-oi0-f47.google.com with SMTP id s79so80568506oie.1
        for <linux-btrfs@vger.kernel.org>; Wed, 06 Apr 2016 18:12:02 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 6 Apr 2016 18:12:01 -0700
Message-ID: <CADNp-0Ta+jNZGtjT0NKc-ZXaYChh=sUOyCy1asn0=ZYBSWaU7Q@mail.gmail.com>
Subject: Volume stuck after Checking UUID tree
From: johnathan falk <johnathan.falk@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The drive mounts perfectly fine when you mount RO, but when you mount
it rw it gives this (and eventually locks up the system as I can't
restart it cleanly):

kernel: BTRFS info (device sdb1): disk space caching is enabled
Apr 06 17:09:16 kernel: BTRFS error (device sdb1): qgroup generation
mismatch, marked as inconsistent
Apr 06 17:09:17 kernel: BTRFS: checking UUID tree
Apr 06 17:12:30 kernel: INFO: task btrfs-transacti:5701 blocked for
more than 120 seconds.

Bug reported on launch pad:
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1555828

When I mount the disk in journalctl -f:
http://pastebin.com/1p6XppRb

Went through Marc Merlin's suggestions to fix my drive and the btrfsck
-S1/2/3 never finishes and gets stuck on checking quota groups. I also
created a btrfs-image first thing.

Any suggestions would be welcome as I don't know what to do.




-- 
Thank You,
Johnathan Falk
