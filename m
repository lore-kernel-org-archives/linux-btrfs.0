Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f181.google.com ([209.85.216.181]:37607 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754084AbaF0PoZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Jun 2014 11:44:25 -0400
Received: by mail-qc0-f181.google.com with SMTP id x13so4608944qcv.26
        for <linux-btrfs@vger.kernel.org>; Fri, 27 Jun 2014 08:44:24 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 27 Jun 2014 11:44:24 -0400
Message-ID: <CAMXuLLrhMv82LPveRemDU_v_Kru2US6sKVn377gS3t9p-VFrag@mail.gmail.com>
Subject: [Question] Btrfs on iSCSI device
From: Zhe Zhang <zhe.zhang.research@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I setup 2 Linux servers to share the same device through iSCSI. Then I
created a btrfs on the device. Then I saw the problem that the 2 Linux
servers do not see a consistent file system image.

Details:
-- Server 1 running kernel 2.6.32, server 2 running 3.2.1
-- Both running btrfs v0.20-rc1
-- Server 2 has device /dev/vdc, exposed as iSCSI target
 -- Server 1 mounts the device as /dev/sda
-- Server 1 'mount /dev/sda /mnt/btrfs'; server 2 'mount /dev/vdc /mnt/btrfs',
 -- When server 1 'touch /mnt/btrfs/foo', server 2 doesn't see any
file under /mnt/btrfs
-- I created /mnt/btrfs/foo on server 2 as well; then I added some
content from both server 1 and server 2 to /mnt/btrfs/foo
-- After that each server sees the content it adds, but not the
content from the other server
-- Both server 'umount /mnt/btrfs', and mount it again
-- Then both servers see /mnt/btrfs/foo with the content added from
server 2 (I guess it's because server 2 created the foo file later
than server 1).

I did a similar test on ext4 and both servers see a consistent image
of the file system. When server 1 creates a foo file server 2
immediately sees it.

Is this how btrfs is supposed to work?

Thanks,

Zhe
