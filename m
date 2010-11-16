From: Chris Mason <chris.mason@oracle.com>
Subject: Re: btrfs crash
Date: Tue, 16 Nov 2010 09:46:38 -0500
Message-ID: <1289918733-sup-3634@think>
References: <AANLkTikAPcS3aeUp14hDJY8RTh_HnSg6sSR1Eyj+RNzM@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Ravi Pinjala <pstatic@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <AANLkTikAPcS3aeUp14hDJY8RTh_HnSg6sSR1Eyj+RNzM@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Ravi Pinjala's message of 2010-11-14 12:31:35 -0500:
> I got the following crash on one of my Ceph nodes this morning. I
> don't know how to reproduce it yet; I was just wondering if it was a
> known issue. This is with the latest kernel for Ubuntu 10.10.
> 
> Nov 13 19:21:21 alpha kernel: [19432.396679] ------------[ cut here
> ]------------
> Nov 13 19:21:22 alpha kernel: [19432.396732] WARNING: at
> /build/buildd/linux-2.6.35/fs/btrfs/extent-tree.c:5322

This warning should have been followed by a printk:

        WARN_ON(1);
        printk(KERN_INFO"block_rsv size %llu reserved %llu freed %llu %llu\n",
                block_rsv->size, block_rsv->reserved,
                block_rsv->freed[0], block_rsv->freed[1]);

        return ERR_PTR(-ENOSPC);

Do you have the printk?

Josef did some work here, so we have a number of related fixes in the
current git tree.

-chris
