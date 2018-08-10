Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lj1-f177.google.com ([209.85.208.177]:41246 "EHLO
        mail-lj1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725725AbeHJGrR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 10 Aug 2018 02:47:17 -0400
Received: by mail-lj1-f177.google.com with SMTP id y17-v6so6130481ljy.8
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Aug 2018 21:19:12 -0700 (PDT)
MIME-Version: 1.0
From: Chris Murphy <lists@colorremedies.com>
Date: Thu, 9 Aug 2018 22:19:10 -0600
Message-ID: <CAJCQCtRJk=btjCXejDdg888TmmtQoJc8gZyki+9ksxxF4Tq0YA@mail.gmail.com>
Subject: mount shows incorrect subvol when backed by bind mount
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've got another example of bind mounts resulting in confusing
(incorrect) information in the mount command with Btrfs. In this case,
it's Docker using bind mounts.

Full raw version (expires in 7 days)
https://paste.fedoraproject.org/paste/r8tr-3nuvoycwxf0bPUrmA/raw

Relevant portion:

mount shows:

/dev/mmcblk0p3 on /var/lib/docker/containers type btrfs
(rw,noatime,seclabel,compress-force=zstd,ssd,space_cache=v2,subvolid=265,subvol=/root/var/lib/docker/containers)
/dev/mmcblk0p3 on /var/lib/docker/btrfs type btrfs
(rw,noatime,seclabel,compress-force=zstd,ssd,space_cache=v2,subvolid=265,subvol=/root/var/lib/docker/btrfs)

And from the detail fpaste, you can see there is no such subvolume
docker/btrfs or docker/containers - and subvolid=265 is actually for
rootfs.

Anyway, mortals will be confused by this behavior.

-- 
Chris Murphy
