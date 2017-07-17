Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f176.google.com ([209.85.128.176]:35213 "EHLO
        mail-wr0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751433AbdGQVrW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Jul 2017 17:47:22 -0400
Received: by mail-wr0-f176.google.com with SMTP id w4so2164488wrb.2
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Jul 2017 14:47:22 -0700 (PDT)
MIME-Version: 1.0
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 17 Jul 2017 15:47:20 -0600
Message-ID: <CAJCQCtT=-YoFJgEo=BFqfiPdtMoJCYR3dJPSekf+HQ22GYGztw@mail.gmail.com>
Subject: bind mounts on btrfs cause mountinfo confusion
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

libOSTree makes use of bind mounts during startup to support multiple
fs trees on any file system for the purpose of atomic updates and
rollback.

Example during boot:

Jul 17 15:18:42 frawhide.localdomain systemd[779]: var.mount:
Executing: /usr/bin/mount
/sysroot/ostree/deploy/fedora-workstation/var /var -o bind

cat /proc/self/mounts

/dev/sda6 /var btrfs
rw,relatime,ssd,space_cache,subvolid=5,subvol=/ostree/deploy/fedora-workstation/var
0 0

findmnt shows basically the same

─/var
/dev/sda6[/ostree/deploy/fedora-workstation/var]
│                                                btrfs
rw,relatime,ssd,space_cache,subvolid=5,subvol=/ostree/deploy/fedora-workstation


There is no such subvolume /ostree/deploy/fedora-workstation/var,
basically it seems like whatever is producing this mount information
(kernel code?) is just assuming a bind mount on Btrfs is a subvolume
without checking if that subvolume really exists, and if it's just an
ordinary directory being bind mounted, which is what's going on here.

I'd say it's confusing. But I don't know if it's a problem otherwise.




-- 
Chris Murphy
