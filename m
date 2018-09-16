Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lj1-f181.google.com ([209.85.208.181]:43894 "EHLO
        mail-lj1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728353AbeIQBIY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 16 Sep 2018 21:08:24 -0400
Received: by mail-lj1-f181.google.com with SMTP id m84-v6so11364917lje.10
        for <linux-btrfs@vger.kernel.org>; Sun, 16 Sep 2018 12:44:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180916184054.df7zuwidcglqdrdo@campbell-lange.net>
References: <20180916111445.lqwjqvq4aeiwglmm@campbell-lange.net>
 <b6d821fb-334f-8145-27e3-28a8cfa99940@mendix.com> <7fade1e9-7eb2-d416-6a3d-452cbca3bbe5@mendix.com>
 <20180916180325.c6jkusse76gsuf52@campbell-lange.net> <CAJCQCtQYznC83N9bj7TKNcrJpS9Omp3goULwro3TCihk85PvmQ@mail.gmail.com>
 <20180916184054.df7zuwidcglqdrdo@campbell-lange.net>
From: Chris Murphy <lists@colorremedies.com>
Date: Sun, 16 Sep 2018 13:44:20 -0600
Message-ID: <CAJCQCtQmpPC0LGnin0YjEiGfPaPzktBdJQ_oRuEnFr2=UH5OoQ@mail.gmail.com>
Subject: Re: Move data and mount point to subvolume
To: Rory Campbell-Lange <rory@campbell-lange.net>
Cc: Chris Murphy <lists@colorremedies.com>,
        Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        Btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Sep 16, 2018 at 12:40 PM, Rory Campbell-Lange
<rory@campbell-lange.net> wrote:

> Thanks very much for spotting my error, Chris.
>
>     # mount | grep bkp
>     /dev/mapper/cdisk2 on /bkp type btrfs
>     (rw,noatime,compress=lzo,space_cache,subvolid=5,subvol=/)
>
>     # btrfs subvol list /bkp
>     ID 258 gen 313636 top level 5 path backup
>
> I'm a bit confused about the difference between / and backup, which is
> at /bkp/backup.


top level, subvolid=5, subvolid=0, subvol=/, FS_TREE are all the same
thing. This is the subvolume that's created at mkfs time, it has no
name, it can't be deleted, and at mkfs time if you do

# btrfs sub get-default <mountpoint>
ID 5 (FS_TREE)

So long as you haven't changed the default subvolume, the top level
subvolume is what gets mounted, unless you use "-o subvol=" or "-o
subvolid=" mount option.

If you do
# btrfs sub list -ta /bkp

It might become a bit more clear what the layout is on disk. And for
an even more verbose output you can do:

# btrfs insp dump-t -t fs_tree /dev/    ### for this you need to
specify device not mountpoint, you don't need to umount, it's a read
only command


Anything that in the "top level" or the "file system root" you will
see listed. The first number is the inode, you'll see 256 is a special
inode for subvolumes. You can do 'ls -li' and compare. Any subvolume
you create is not FS_TREE, it is a "file tree". And note that each
subvolume has it's own pile of inode numbers, meaning
files/directories only have unique inode numbers *in a given
subvolume*. Those inode numbers start over in a new subvolume.

Subvolumes share extent, chunk, csum, uuid and other trees, so a
subvolume is not a completely isolated "file system".


>
> Anyhow I've verified I can snapshot /bkp/backup to another subvolume.
> This means I don't need to move anything, simply remount /bkp at
> /bkp/backup.

Uhh, that's the reverse of what you said in the first message. I'm not
sure what you want to do. It sounds like you want to mount the
subvolume "backup" at /bkp/ so that all the other files/dirs on this
Btrfs volume are not visible through the /bkp/ mount path?

Anyway if you want to explicitly mount the subvolume "backup"
somewhere, you use -o subvol=backup to specify "the subvolume named
backup, not the top level subvolume".





>
> Presumably I can therefore remount /bkp at subvolume /backup?
>
> # btrfs subvolume show /bkp/backup | egrep -i 'name|uuid|subvol'
>         Name:                   backup
>         UUID:                   d17cf2ca-a6db-ca43-8054-1fd76533e84b
>         Parent UUID:            -
>         Received UUID:          -
>         Subvolume ID:           258
>
> My fstab is presently
>
>     UUID=da90602a-b98e-4f0b-959a-ce431ac0cdfa /bkp  btrfs  noauto,noatime,compress=lzo 0  2
>
> I guess it would now be
>
>     UUID=d17cf2ca-a6db-ca43-8054-1fd76533e84b /bkp  btrfs  noauto,noatime,compress=lzo 0  2

No you can't mount by subvolume UUID. You continue to specify the
volume UUID, but then add a mount option


noauto,noatime,compress=lzo,subvol=backup

or

noauto,noatime,compress=lzo,subvolid=258


The advantage of subvolid is that it doesn't change when you rename
the subvolume.


>
>> If you snapshot a subvolume, which itself contains subvolumes, the
>> nested subvolumes are not snapshot. In the snapshot, the nested
>> subvolumes are empty directories.
>>
>> >
>> > # btrfs fi du -s /bkp/backup-subvol/backup
>> >      Total   Exclusive  Set shared  Filename
>> > ERROR: cannot check space of '/bkp/backup-subvol/backup': Inappropriate
>> > ioctl for device
>>
>> That's a bug in older btrfs-progs. It's been fixed, but I'm not sure
>> what version, maybe by 4.14?
>
> Sounds about right -- my version is 4.7.3.

It's not dangerous to use it (maybe --repair is more dangerous but
don't use it without advice first, no matter version). You just don't
get new features and bug fixes. It's also not dangerous to use
something much newer, again if the user space tools are very new and
the kernel is old, you just don't get certain features.




-- 
Chris Murphy
