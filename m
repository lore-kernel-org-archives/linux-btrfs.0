Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:54374 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752199AbdBMUDX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Feb 2017 15:03:23 -0500
Subject: Re: Root volume (ID 5) in deleting state
To: =?UTF-8?B?TWFydGluIE1seW7DocWZ?= <nextsux@gmail.com>,
        linux-btrfs@vger.kernel.org
References: <ed8d7383-c75c-584e-4722-c889c6f19a46@gmail.com>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <a103e413-d922-9c79-0075-1ce00a3cd7de@mendix.com>
Date: Mon, 13 Feb 2017 21:03:18 +0100
MIME-Version: 1.0
In-Reply-To: <ed8d7383-c75c-584e-4722-c889c6f19a46@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/13/2017 12:26 PM, Martin Mlynář wrote:
> 
> I've currently run into strange problem with BTRFS. I'm using it as my
> daily driver as root FS. Nothing complicated, just few subvolumes and
> incremental backups using btrbk.
> 
> Now I've noticed that my btrfs root volume (absolute top, ID 5) is in
> "deleting" state. As I've done some testing and googling it seems that
> this should not be possible.
> 
> [...]
> 
> # btrfs sub list -ad /mnt/btrfs_root/
> ID 5 gen 257505 top level 0 path <FS_TREE>/DELETED

I have heard rumours that this is actually a bug in the output of sub
list itself.

What's the version of your btrfs-progs? (output of `btrfs version`)

> # mount | grep btr
> /dev/mapper/vg0-btrfsroot on / type btrfs
> (rw,noatime,nodatasum,nodatacow,ssd,discard,space_cache,subvolid=1339,subvol=/rootfs)
> 
> /dev/mapper/vg0-btrfsroot on /mnt/btrfs_root type btrfs
> (rw,noatime,nodatasum,nodatacow,ssd,discard,space_cache,subvolid=5,subvol=/)

The rumour was that it had something to do with using space_cache=v2,
which this example does not confirm.

> # uname -a
> Linux interceptor 4.9.6-1-ARCH #1 SMP PREEMPT Thu Jan 26 09:22:26 CET
> 2017 x86_64 GNU/Linux
> 
> # btrfs fi show  /
> Label: none  uuid: 859dec5c-850c-4660-ad99-bc87456aa309
>     Total devices 1 FS bytes used 132.89GiB
>     devid    1 size 200.00GiB used 200.00GiB path /dev/mapper/vg0-btrfsroot

As a side note, all of your disk space is allocated (200GiB of 200GiB).

Even while there's still 70GiB of free space scattered around inside,
this might lead to out-of-space issues, depending on how badly
fragmented that free space is.

-- 
Hans van Kranenburg
