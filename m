Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f179.google.com ([209.85.213.179]:37379 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732AbcCEUcc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 5 Mar 2016 15:32:32 -0500
Received: by mail-ig0-f179.google.com with SMTP id z8so16662852ige.0
        for <linux-btrfs@vger.kernel.org>; Sat, 05 Mar 2016 12:32:32 -0800 (PST)
MIME-Version: 1.0
Date: Sat, 5 Mar 2016 12:32:31 -0800
Message-ID: <CAJ5gi5+xZgHd7Bgpo1RzF=e1okyseibadvAUDDjCqiX2QsWbsA@mail.gmail.com>
Subject: List missing files on a degraded read-only btrfs mount
From: Justin Madru <justin.jdm64@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have a btrfs filesystem spanning 3 drives. The metadata is using
raid1 (mirroring), but the data is using single, so no mirroring or
parity just spanning. For example:

    mkfs.btrfs -m raid1 -d single /dev/sda /dev/sdb /dev/sdc

One of the drives, /dev/sdb, had a hardware failure before I could
replace it. I'm able to mount the filesystem in read-only using:

    mount -o degraded,ro /dev/sda /mnt/data

But how do I list the files that were on the failed drive?
