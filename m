Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:42799 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138AbbBSOau (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Feb 2015 09:30:50 -0500
Received: by wesw62 with SMTP id w62so53109wes.9
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Feb 2015 06:30:49 -0800 (PST)
Message-ID: <54E5F38D.4070104@gmail.com>
Date: Thu, 19 Feb 2015 16:30:37 +0200
From: Konstantinos Skarlatos <k.skarlatos@gmail.com>
MIME-Version: 1.0
To: "btr >> linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
CC: lennart Poettering <lennart@poettering.net>
Subject: Systemd 219 journald now sets the FS_NOCOW file flag for its
 journal files, possibly breaking RAID repairs.
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Systemd 219 now sets the special FS_NOCOW file flag for its journal 
files[1]. This unfortunately breaks the ability to repair the journal on 
RAID 1/5/6 btrfs volumes, should a bad sector happen to appear there. Is 
this something that can be configured for systemd? Is btrfs going to 
someday fix the fragmentation problem, making this option reduntant?


[1] 
http://lists.freedesktop.org/archives/systemd-devel/2015-February/028447.html

         * journald now sets the special FS_NOCOW file flag for its
           journal files. This should improve performance on btrfs, by
           avoiding heavy fragmentation when journald's write-pattern
           is used on COW file systems. It degrades btrfs' data
           integrity guarantees for the files to the same levels as for
           ext3/ext4 however. This should be OK though as journald does
           its own data integrity checks and all its objects are
           checksummed on disk. Also, journald should handle btrfs disk
           full events a lot more gracefully now, by processing SIGBUS
           errors, and not relying on fallocate() anymore.
