Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:35204 "EHLO
        mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750846AbcIUTFu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Sep 2016 15:05:50 -0400
Received: by mail-oi0-f48.google.com with SMTP id w11so71574026oia.2
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Sep 2016 12:05:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAB1rxdYdOZvgymnpzkURVxP7J2UQ=W4ANZpte+r8Z=9XAOuBQw@mail.gmail.com>
References: <CAB1rxdbJX7rgv-NrHyGD7wMMcFf1EDR_aJ8yaTs7r=O-iXTo7w@mail.gmail.com>
 <CAJCQCtSz15HC99QetsSzJRtbLgZU+iohej9Mf6qE4q39MmZfKA@mail.gmail.com> <CAB1rxdYdOZvgymnpzkURVxP7J2UQ=W4ANZpte+r8Z=9XAOuBQw@mail.gmail.com>
From: Mirak M <mirak63@gmail.com>
Date: Wed, 21 Sep 2016 21:05:49 +0200
Message-ID: <CAB1rxdYJN8pANZkbjPZsrXO+FdhWg2nxdhtqkxBpASGg8jibTQ@mail.gmail.com>
Subject: Fwd: Can't mount btrfs raid1
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2016-09-21 3:00 GMT+02:00 Chris Murphy <lists@colorremedies.com>:
> On Tue, Sep 20, 2016 at 5:16 PM, Mirak M <mirak63@gmail.com> wrote:
>> Hello,
>>
>> I have a failure when mounting btrfs.
>>
>>> mount -oro,recovery /dev/sda2 sda2_btrfs
>>> mount: /dev/sda2: can't read superblock
>
> What do you get for 'btrfs super-recover -v <dev>' and 'btrfs check <dev>'

I get this :
###################################################
All Devices:
    Device: id = 1, name = /dev/sdc2
    Device: id = 2, name = /dev/sda2

Before Recovering:
    [All good supers]:
        device name = /dev/sdc2
        superblock bytenr = 65536

        device name = /dev/sdc2
        superblock bytenr = 67108864

        device name = /dev/sdc2
        superblock bytenr = 274877906944

        device name = /dev/sda2
        superblock bytenr = 65536

        device name = /dev/sda2
        superblock bytenr = 67108864

        device name = /dev/sda2
        superblock bytenr = 274877906944

    [All bad supers]:

All supers are valid, no need to recover
###################################################

###################################################
root@vdr-box:/mnt# btrfs check  /dev/sda2
Checking filesystem on /dev/sda2
UUID: 64543f0e-ebb5-4384-8119-f5b6d52dea6e
checking extents
bad key ordering 29 30
bad block 1957998690304
Errors found in extent allocation tree or chunk allocation
checking free space cache
There is no free space entry for 1959033618432-859521990656
There is no free space entry for 1959033618432-1959071318016
cache appears valid but isnt 1957997576192
found 54593218 bytes used err is -22
total csum bytes: 0
total tree bytes: 1146880
total fs tree bytes: 0
total extent tree bytes: 212992
btree space waste bytes: 212465
file data blocks allocated: 453378048
 referenced 453378048
###################################################

>
> For this purpose any 4.4+ version is probably OK, except 4.7 and 4.7.1
> which might spit out some bogus items (it's just noise it won't hurt
> anything as long as you don't use --repair).
>
>
>>
>> The kernel log is here http://pastebin.com/tHihHT92 and at the bottom
>> of the email
>>
>> I must admit I did the error of running btrfs check --repair at some
>> point, not knowing this was not a good idea.
>>
>> I run ubuntu 16.04 with kernel 4.4.0-36-generic .
>
> OK what version of btrrfs-progs? What was the output from btrfs check?

btrfs-progs v4.4
Output is above,


>
>
>> [ 1692.712574] BTRFS critical (device sda2): corrupt leaf, bad key
>> order: block=1957998690304,root=1, slot=29
>> [ 1692.712819] BTRFS critical (device sda2): corrupt leaf, bad key
>> order: block=1957998690304,root=1, slot=29
>
> List archives suggest this might be due to bad RAM. I also see there
> are some bugs that can cause it, but I'm not finding any post kernel
> 4.4 patches for this (there are a metric f tonne of changes since
> 4.4). I would suggest kernel 4.4.21 if you need to stick with a long
> term kernel, I have no idea what 4.4.0-36 translates into.

My computer freezing a lot recently, but I though it was related to a
X server problem with the radeon gpu.


>
>
>> [ 1692.713963] BTRFS: error (device sda2) in btrfs_replay_log:2401:
>> errno=-5 IO failure (Failed to recover log tree)
>
> This is kinda curious, was there a crash or power failure?

Yes many since I upgraded to xenial and btrfs, about at the same time.
only /home is on btrfs raid 1 on harddrive. The system / is on
LVM+ext4 on a SSD.


>
>
>
>
> --
> Chris Murphy
