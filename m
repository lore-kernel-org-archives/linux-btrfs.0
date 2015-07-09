Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vn0-f45.google.com ([209.85.216.45]:36748 "EHLO
	mail-vn0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432AbbGIAav (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Jul 2015 20:30:51 -0400
Received: by vnbg129 with SMTP id g129so32982379vnb.3
        for <linux-btrfs@vger.kernel.org>; Wed, 08 Jul 2015 17:30:50 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 8 Jul 2015 18:30:50 -0600
Message-ID: <CAJCQCtT7Zx1Ys8m2PcXEK-sZJvL-wmYfb6V3j-QnoPMrtieAWA@mail.gmail.com>
Subject: [BUG] ext4 to btrfs convert, balance results in kernel BUG at fs/btrfs/extent-tree.c:8078!
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is similar to previously reported ext4->btrfs convert success,
but then failure on subsequent balance. But this is a different kernel
version and totally different call traces, so I've filed it with a
separate bug report and email thread.

Kernel 4.2.0rc1
Btrfs-progs 4.1

New ext4 file system populated with several thousand files (Fedora 22
installation) and a 1.5GB ISO.

Conversion succeeds with no user space or kernel errors. Btrfs check
comes up clean. Deletion of ext2_saved subvolume happens without
error, as does defragment. After this btrfs check is still clean. Then
major problems on btrfs balance with multiple back traces and the file
system is broken, with multiple call traces in sequence ending with
kernel BUG.


balance fail following successful ext4 to btrfs conversion, BUG at
fs/btrfs/extent-tree.c:8078!
https://bugzilla.kernel.org/show_bug.cgi?id=101181



-- 
Chris Murphy
