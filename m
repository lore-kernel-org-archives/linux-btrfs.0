Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:35302 "EHLO
        mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753124AbdGNQiW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Jul 2017 12:38:22 -0400
Received: by mail-wm0-f41.google.com with SMTP id w126so25289521wme.0
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Jul 2017 09:38:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <d82a6d8a-d6d3-0942-ccd1-c81ff2f16056@gmail.com>
References: <d82a6d8a-d6d3-0942-ccd1-c81ff2f16056@gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Fri, 14 Jul 2017 10:38:20 -0600
Message-ID: <CAJCQCtRgvjrTtFp7+ESuORubyLPLOWyM=b=s7qrr=vAssucxLg@mail.gmail.com>
Subject: Re: Btrfs cross-subvolume inode scheme not working as intended with snapshots?
To: "Oliver O." <oliver.o456i@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>, josef@toxicpanda.com,
        bfields@fieldses.org, Chris Mason <clm@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 14, 2017 at 4:37 AM, Oliver O. <oliver.o456i@gmail.com> wrote:
> Hello,
>
> I think I've found a corner case where the current cross-subvolume inode
> scheme
> does not work as intended:

Yep. So I hit this on all read-only snapshots of my rootfs because
systemd creates a nested /var/lib/machines subvolume, and when I
snapshot root, it contains this odd directory made from
/var/lib/machines subvolume. And it causes 'btrfs subvolume du'
command to not work.

newfstatat(5, "machines", {st_mode=S_IFDIR|0755, st_size=0, ...}, 0) = 0
stat("root00.20170704/var/lib/machines", {st_mode=S_IFDIR|0755,
st_size=0, ...}) = 0
open("root00.20170704/var/lib/machines",
O_RDONLY|O_NONBLOCK|O_DIRECTORY|O_CLOEXEC) = 6
fstat(6, {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
ioctl(6, BTRFS_IOC_INO_LOOKUP, {treeid=0, objectid=256 /*
BTRFS_FIRST_FREE_OBJECTID */}) = -1 ENOTTY (Inappropriate ioctl for
device)
close(6)



-- 
Chris Murphy
