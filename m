Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f50.google.com ([209.85.214.50]:38126 "EHLO
	mail-it0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752732AbcGZOms (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Jul 2016 10:42:48 -0400
Received: by mail-it0-f50.google.com with SMTP id j124so14618665ith.1
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Jul 2016 07:42:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAcuexC5rPpFKjiTUMjaLxn3E62k06w7t1EFhjFKmfjdGYJVGA@mail.gmail.com>
References: <CAAcuexAaxha03vnwAC1bW6hcjEpH4GoQr2YBps=vWAu3RS8FJg@mail.gmail.com>
 <CAJCQCtTUGxfTgjLAqCC7_k-8PK9dYZHFJMchih-zQBxApvURRA@mail.gmail.com> <CAAcuexC5rPpFKjiTUMjaLxn3E62k06w7t1EFhjFKmfjdGYJVGA@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 26 Jul 2016 08:42:47 -0600
Message-ID: <CAJCQCtTqU_Hvg4EF9xJqUDLYmU-yyk+8eAud_uK_gRQyAFWyNA@mail.gmail.com>
Subject: Re: Any suggestions for thousands of disk image snapshots ?
To: Kurt Seo <tiger.anam.manager@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 26, 2016 at 3:37 AM, Kurt Seo <tiger.anam.manager@gmail.com> wrote:
> 2016-07-26 5:49 GMT+09:00 Chris Murphy <lists@colorremedies.com>:
>> On Mon, Jul 25, 2016 at 1:25 AM, Kurt Seo <tiger.anam.manager@gmail.com> wrote:
>>>  Hi all
>>>
>>>
>>>  I am currently running a project for building servers with btrfs.
>>> Purposes of servers are exporting disk images through iscsi targets
>>> and disk images are generated from btrfs subvolume snapshot.
>>
>> How is the disk image generated from Btrfs subvolume snapshot?
>>
>> On what file system is the disk image stored?
>>
>>
>
> When i create empty original disk image on btrfs. I do like :
>
> btrfs sub create /mnt/test/test_disk
> chattr -R +C /mnt/test/test_disk
> fallocate -l 50G /mnt/test/test_disk/master.img
>
> then do fdisk things for partitioning image.
> And the file system of disk image is ntfs. all clients are Windows.
>
> i create snapshots from original subvolume when clients boot up using
> 'btrfs sub snap'.
> The reason i stored disk image in subvolume is that subvolume way is
> faster than 'cp --reflink' and i needed to disable cow, so 'cp
> --reflink' became unavailable anyway.

I don't know what it is, but there's something almost pathological
with NTFS on Btrfs (via either Raw image or qcow2). It's neurotic
levels of fragmentation.

While an individual image is nocow, it becomes cow due to all the
snapshots you're creating, so the fragmentation is going to be really
bad. And then upon snapshot deletition all of those reference counts
have to be individually accounted for, a thousand snapshots times
thousands of new extents. I suspect it's the cleanup accounting that's
really killing the performance.

And of course nocow also means nodatasum, so there's no checksumming
for these images.




>  Thanks for your answer. Actually i have been trying almost every ways
> for this project.
> LVM thin pool is one of them. I tried zfs on linux, too. As you
> mentioned, when metadata is full, entire lvm pool become unrepairable.
> So i increased size of metadata LV of thin pool to 1 percent of thin
> pool. And that problem was gone.

Good to know.

> Anyway, if lvm is better option than btrfs for my purpose, what about zfs?

ZFS supports block devices presented via iSCSI so there's no need for
an image file at all, and it's more mature. But there is no nocow
option, and I suspect there's going to be as much fragmentation as
with Btrfs but maybe not.


>  So you're saying i need to re-consider using btrfs and look for other
> options like lvm thin pool. I think it makes sense.
> i have two more questions.
>
> 1. If i move to lvm from btrfs, what about mdadm chunk size?
> I am still not sure what is the best chunk size for numerous cloned disks.
> And any recommends options of LVM thin?

You'd have to benchmark it. mdadm default 512KiB which works well for
some use cases but not others. And the LVM chunksize (for snapshots)
defaults to 64KiB which works well for some use cases but not others.
There are lots of levers here.

I just thought of something though which is thin LV snapshots can't
have their size limited. If you start with a 100GiB LV, each snapshot
is 100GiB. So any wayward process in any, or all, of these 1000s of
snapshots, could bring down the entire storage stack by consuming too
much of the pool at once. So it's not exactly true that each LV is
completely isolated from the others.


>
> 2. What about zfs on linux? I think zol is similar with lvm in some ways.

I haven't used it for anything like this use case, but it's a full
blown file system which LVM is not. Sometimes simpler is better. All
you really need here is a logical block device that you can snapshot,
the actual file system of concern is NTFS which can of course exist
directly on an LV - no disk image needed. Using LVM, other than NTFS
fragmentation itself, you have no additional fragmentation of any
underlying file system since there isn't one. And LVM snapshot
deletions should be pretty fast.


-- 
Chris Murphy
