Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vn0-f43.google.com ([209.85.216.43]:35624 "EHLO
	mail-vn0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933AbbGIDPs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Jul 2015 23:15:48 -0400
Received: by vnbg190 with SMTP id g190so33364842vnb.2
        for <linux-btrfs@vger.kernel.org>; Wed, 08 Jul 2015 20:15:48 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 8 Jul 2015 21:15:48 -0600
Message-ID: <CAJCQCtSGRU6x2g3Asy42q76YtO8p=8DTaOwEchaWjzB23BX8xA@mail.gmail.com>
Subject: [BUG] kernel BUG at fs/btrfs/scrub.c:1956!, when scrubbing freshly
 converted ext4
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

OK yet another btrfs-convert bug. This one is easier to reproduce than
the others, does not damage the file system (still mounts OK) but the
oops is a hard panic. ssh and even the virt-manager console dies
instantly, but virsh console captured a lot of call traces and are
attached to the bug report.

Happens with 4.1 and 4.2rc1 kernels. The convert was done with btrfs-progs 4.1.

The reproduce steps are easy:

1. ext4 with a bunch of files (Fedora 22 installation) plus a ~1.5GB ISO
2. btrfs-convert using defaults goes OK no error, btrfs check has no complaints
3. mount
4. btrfs scrub
hard panic

https://bugzilla.kernel.org/show_bug.cgi?id=101231


-- 
Chris Murphy
