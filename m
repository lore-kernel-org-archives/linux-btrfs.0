From: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: Re: [PATCH 1/3] Btrfs: fix btrfsck error 400 when truncating a
 compressed file extent
Date: Sun, 8 Jan 2012 22:45:14 -0600
Message-ID: <CAKcLGm9rzcAJL-MC9u7jQmQgiEAWR4FPCVALxJHVJJ=Q0_p9TQ@mail.gmail.com>
References: <4F056023.4010302@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: miaox@cn.fujitsu.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F056023.4010302@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

2012/1/5 Miao Xie <miaox@cn.fujitsu.com>:
> Reproduce steps:
> =A0# mkfs.btrfs /dev/sdb5
> =A0# mount /dev/sdb5 -o compress=3Dlzo /mnt
> =A0# dd if=3D/dev/zero of=3D/mnt/tmpfile bs=3D128K count=3D1
> =A0# sync
> =A0# truncate -s 64K /mnt/tmpfile
> =A0root 5 inode 257 errors 400

Is this patch set intended to address the general case of btrfsck
inode 400 errors, or is it intended for this specific case.

I've been picking up btrfsck inode 400 errors all over the place
recently on unclean shutdowns, and I was wondering if this patch set
might address the issue of unclean shutdowns, or if there is a more
general COW regression out there (or if I'm just extremely unlucky).
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
