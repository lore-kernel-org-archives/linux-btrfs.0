From: Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: [PATCH 1/3] Btrfs: fix btrfsck error 400 when truncating a compressed
 file extent
Date: Mon, 09 Jan 2012 13:49:27 +0800
Message-ID: <4F0A7FE7.5080705@cn.fujitsu.com>
References: <4F056023.4010302@cn.fujitsu.com> <CAKcLGm9rzcAJL-MC9u7jQmQgiEAWR4FPCVALxJHVJJ=Q0_p9TQ@mail.gmail.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Mitch Harder <mitch.harder@sabayonlinux.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAKcLGm9rzcAJL-MC9u7jQmQgiEAWR4FPCVALxJHVJJ=Q0_p9TQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 8 Jan 2012 22:45:14 -0600, Mitch Harder wrote:
> 2012/1/5 Miao Xie <miaox@cn.fujitsu.com>:
>> Reproduce steps:
>>  # mkfs.btrfs /dev/sdb5
>>  # mount /dev/sdb5 -o compress=lzo /mnt
>>  # dd if=/dev/zero of=/mnt/tmpfile bs=128K count=1
>>  # sync
>>  # truncate -s 64K /mnt/tmpfile
>>  root 5 inode 257 errors 400
> 
> Is this patch set intended to address the general case of btrfsck
> inode 400 errors, or is it intended for this specific case.
> 
> I've been picking up btrfsck inode 400 errors all over the place
> recently on unclean shutdowns, and I was wondering if this patch set
> might address the issue of unclean shutdowns, or if there is a more
> general COW regression out there (or if I'm just extremely unlucky).

The purpose of this patch set is to fix the bug of the left orphan items which
is caused by the truncation, not the general case of btrfsck 400 errors.

Thanks
Miao
