Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from campbell-lange.net ([178.79.140.51]:44972 "EHLO
        campbell-lange.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728230AbeIQAEp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 16 Sep 2018 20:04:45 -0400
Date: Sun, 16 Sep 2018 19:40:54 +0100
From: Rory Campbell-Lange <rory@campbell-lange.net>
To: Chris Murphy <lists@colorremedies.com>
Cc: Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Move data and mount point to subvolume
Message-ID: <20180916184054.df7zuwidcglqdrdo@campbell-lange.net>
References: <20180916111445.lqwjqvq4aeiwglmm@campbell-lange.net>
 <b6d821fb-334f-8145-27e3-28a8cfa99940@mendix.com>
 <7fade1e9-7eb2-d416-6a3d-452cbca3bbe5@mendix.com>
 <20180916180325.c6jkusse76gsuf52@campbell-lange.net>
 <CAJCQCtQYznC83N9bj7TKNcrJpS9Omp3goULwro3TCihk85PvmQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJCQCtQYznC83N9bj7TKNcrJpS9Omp3goULwro3TCihk85PvmQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 16/09/18, Chris Murphy (lists@colorremedies.com) wrote:
> > So I did this:
> >
> >     btrfs subvol snapshot /bkp /bkp/backup-subvol
> >
> > strangely while /bkp/backup has lots of files in it,
> > /bkp/backup-subvol/backup has none.
> >
> > # btrfs subvol list /bkp
> > ID 258 gen 313585 top level 5 path backup
> > ID 4782 gen 313590 top level 5 path backup-subvol
> 
> OK so previously you said "/bkp which is a top level subvolume. There
> are no other subvolumes."
> 
> But in fact backup is already a subvolume. So now it's confusing what
> you were asking for in the first place, maybe you didn't realize
> backup is not a dir but it is a subvolume.

Thanks very much for spotting my error, Chris.

    # mount | grep bkp
    /dev/mapper/cdisk2 on /bkp type btrfs
    (rw,noatime,compress=lzo,space_cache,subvolid=5,subvol=/)

    # btrfs subvol list /bkp
    ID 258 gen 313636 top level 5 path backup

I'm a bit confused about the difference between / and backup, which is
at /bkp/backup.

Anyhow I've verified I can snapshot /bkp/backup to another subvolume.
This means I don't need to move anything, simply remount /bkp at
/bkp/backup.

Presumably I can therefore remount /bkp at subvolume /backup? 

# btrfs subvolume show /bkp/backup | egrep -i 'name|uuid|subvol'
        Name:                   backup
        UUID:                   d17cf2ca-a6db-ca43-8054-1fd76533e84b
        Parent UUID:            -
        Received UUID:          -
        Subvolume ID:           258

My fstab is presently

    UUID=da90602a-b98e-4f0b-959a-ce431ac0cdfa /bkp  btrfs  noauto,noatime,compress=lzo 0  2

I guess it would now be

    UUID=d17cf2ca-a6db-ca43-8054-1fd76533e84b /bkp  btrfs  noauto,noatime,compress=lzo 0  2

> If you snapshot a subvolume, which itself contains subvolumes, the
> nested subvolumes are not snapshot. In the snapshot, the nested
> subvolumes are empty directories.
> 
> >
> > # btrfs fi du -s /bkp/backup-subvol/backup
> >      Total   Exclusive  Set shared  Filename
> > ERROR: cannot check space of '/bkp/backup-subvol/backup': Inappropriate
> > ioctl for device
> 
> That's a bug in older btrfs-progs. It's been fixed, but I'm not sure
> what version, maybe by 4.14?

Sounds about right -- my version is 4.7.3.

> > Any ideas about what could be going on?
> >
> > In the mean time I'm trying:
> >
> >     btrfs subvol create /bkp/backup-subvol
> >     cp -prv --reflink=always /bkp/backup/* /bkp/backup-subvol/
> 
> Yeah that will take a lot of writes that are not necessary, now that
> you see backup is a subvolume already. If you want a copy of it, just
> snapshot it.

Makes sense.

Thanks very much
Rory
