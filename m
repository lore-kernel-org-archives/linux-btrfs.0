Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from campbell-lange.net ([178.79.140.51]:45522 "EHLO
        campbell-lange.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725757AbeIQPEN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Sep 2018 11:04:13 -0400
Date: Sun, 16 Sep 2018 21:34:41 +0100
From: Rory Campbell-Lange <rory@campbell-lange.net>
To: Chris Murphy <lists@colorremedies.com>
Cc: Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Move data and mount point to subvolume
Message-ID: <20180916203441.mu6f2tpnux6rfoob@campbell-lange.net>
References: <20180916111445.lqwjqvq4aeiwglmm@campbell-lange.net>
 <b6d821fb-334f-8145-27e3-28a8cfa99940@mendix.com>
 <7fade1e9-7eb2-d416-6a3d-452cbca3bbe5@mendix.com>
 <20180916180325.c6jkusse76gsuf52@campbell-lange.net>
 <CAJCQCtQYznC83N9bj7TKNcrJpS9Omp3goULwro3TCihk85PvmQ@mail.gmail.com>
 <20180916184054.df7zuwidcglqdrdo@campbell-lange.net>
 <CAJCQCtQmpPC0LGnin0YjEiGfPaPzktBdJQ_oRuEnFr2=UH5OoQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJCQCtQmpPC0LGnin0YjEiGfPaPzktBdJQ_oRuEnFr2=UH5OoQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 16/09/18, Chris Murphy (lists@colorremedies.com) wrote:
> On Sun, Sep 16, 2018 at 12:40 PM, Rory Campbell-Lange
> <rory@campbell-lange.net> wrote:

> > I'm a bit confused about the difference between / and backup, which is
> > at /bkp/backup.
> 
> top level, subvolid=5, subvolid=0, subvol=/, FS_TREE are all the same
> thing. This is the subvolume that's created at mkfs time, it has no
> name, it can't be deleted, and at mkfs time if you do
> 
> # btrfs sub get-default <mountpoint>
> ID 5 (FS_TREE)
> 
> So long as you haven't changed the default subvolume, the top level
> subvolume is what gets mounted, unless you use "-o subvol=" or "-o
> subvolid=" mount option.
> 
> If you do
> # btrfs sub list -ta /bkp
> 
> It might become a bit more clear what the layout is on disk. And for
> an even more verbose output you can do:
> 
> # btrfs insp dump-t -t fs_tree /dev/    ### for this you need to
> specify device not mountpoint, you don't need to umount, it's a read
> only command
> 
> Anything that in the "top level" or the "file system root" you will
> see listed. The first number is the inode, you'll see 256 is a special
> inode for subvolumes. You can do 'ls -li' and compare. Any subvolume
> you create is not FS_TREE, it is a "file tree". And note that each
> subvolume has it's own pile of inode numbers, meaning
> files/directories only have unique inode numbers *in a given
> subvolume*. Those inode numbers start over in a new subvolume.
> 
> Subvolumes share extent, chunk, csum, uuid and other trees, so a
> subvolume is not a completely isolated "file system".

Thanks for the wonderfully clear explanation.

> > Anyhow I've verified I can snapshot /bkp/backup to another subvolume.
> > This means I don't need to move anything, simply remount /bkp at
> > /bkp/backup.
> 
> Uhh, that's the reverse of what you said in the first message. I'm not
> sure what you want to do. It sounds like you want to mount the
> subvolume "backup" at /bkp/ so that all the other files/dirs on this
> Btrfs volume are not visible through the /bkp/ mount path?
> 
> Anyway if you want to explicitly mount the subvolume "backup"
> somewhere, you use -o subvol=backup to specify "the subvolume named
> backup, not the top level subvolume".

Yes, apologies, my intentions changed after you pointed out /bkp/backup
was a subvolume. My simple aim is to mount backup at /bkp.

Thanks for the note about the mount subvolume option.

> > Presumably I can therefore remount /bkp at subvolume /backup?
> >
> > # btrfs subvolume show /bkp/backup | egrep -i 'name|uuid|subvol'
> >         Name:                   backup
> >         UUID:                   d17cf2ca-a6db-ca43-8054-1fd76533e84b
> >         Parent UUID:            -
> >         Received UUID:          -
> >         Subvolume ID:           258
> >
> > My fstab is presently
> >
> >     UUID=da90602a-b98e-4f0b-959a-ce431ac0cdfa /bkp  btrfs  noauto,noatime,compress=lzo 0  2
> >
> > I guess it would now be
> >
> >     UUID=d17cf2ca-a6db-ca43-8054-1fd76533e84b /bkp  btrfs  noauto,noatime,compress=lzo 0  2
> 
> No you can't mount by subvolume UUID. You continue to specify the
> volume UUID, but then add a mount option
> 
> 
> noauto,noatime,compress=lzo,subvol=backup
> 
> or
> 
> noauto,noatime,compress=lzo,subvolid=258
> 
> The advantage of subvolid is that it doesn't change when you rename
> the subvolume.

That is terrific advice; thanks a lot.

Rory
