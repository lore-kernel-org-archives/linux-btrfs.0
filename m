Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f169.google.com ([209.85.223.169]:33085 "EHLO
        mail-io0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932403AbcISRil (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Sep 2016 13:38:41 -0400
Received: by mail-io0-f169.google.com with SMTP id r145so99202914ior.0
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Sep 2016 10:38:40 -0700 (PDT)
Subject: Re: Is stability a joke? (wiki updated)
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
        Chris Murphy <lists@colorremedies.com>
References: <57D51BF9.2010907@online.no>
 <20160912142714.GE16983@twin.jikos.cz> <20160912162747.GF16983@twin.jikos.cz>
 <8df2691f-94c1-61de-881f-075682d4a28d@gmail.com>
 <CAJCQCtQUS-8F+pOtQ2VA9=j=-TGV=wOfj+3SnnMvY3HMTzd=9g@mail.gmail.com>
 <1ef8e6db-89a1-6639-cd9a-4e81590456c5@gmail.com>
 <CAJCQCtQq08bOpRbZq90wRLUGD62Rnqwx6vjJOv5hvPVwp=jz0w@mail.gmail.com>
 <24d64f38-f036-3ae9-71fd-0c626cfbb52c@gmail.com>
 <CAJCQCtR_hMPj8Nrf=U1L=WvDWq48Ns1K25p4JtKEJnVwb1231Q@mail.gmail.com>
 <20160919040855.GF21290@hungrycats.org>
Cc: David Sterba <dsterba@suse.cz>, Waxhead <waxhead@online.no>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <7c55ba5a-9193-d88f-e92f-b5f34f99ce57@gmail.com>
Date: Mon, 19 Sep 2016 13:38:36 -0400
MIME-Version: 1.0
In-Reply-To: <20160919040855.GF21290@hungrycats.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-09-19 00:08, Zygo Blaxell wrote:
> On Thu, Sep 15, 2016 at 01:02:43PM -0600, Chris Murphy wrote:
>> Right, well I'm vaguely curious why ZFS, as different as it is,
>> basically take the position that if the hardware went so batshit that
>> they can't unwind it on a normal mount, then an fsck probably can't
>> help either... they still don't have an fsck and don't appear to want
>> one.
>
> ZFS has no automated fsck, but it does have a kind of interactive
> debugger that can be used to manually fix things.
>
> ZFS seems to be a lot more robust when it comes to handling bad metadata
> (contrast with btrfs-style BUG_ON panics).
>
> When you delete a directory entry that has a missing inode on ZFS,
> the dirent goes away.  In the ZFS administrator documentation they give
> examples of this as a response in cases where ZFS metadata gets corrupted.
>
> When you delete a file with a missing inode on btrfs, something
> (VFS?) wants to check the inode to see if it has attributes that might
> affect unlink (e.g. the immutable bit), gets an error reading the
> inode, and bombs out of the unlink() before unlink() can get rid of the
> dead dirent.  So if you get a dirent with no inode on btrfs on a large
> filesystem (too large for btrfs check to handle), you're basically stuck
> with it forever.  You can't even rename it.  Hopefully it doesn't happen
> in a top-level directory.
>
> ZFS is also infamous for saying "sucks to be you, I'm outta here" when
> things go wrong.  People do want ZFS fsck and defrag, but nobody seems
> to be bothered much about making those things happen.
>
> At the end of the day I'm not sure fsck really matters.  If the filesystem
> is getting corrupted enough that both copies of metadata are broken,
> there's something fundamentally wrong with that setup (hardware bugs,
> software bugs, bad RAM, etc) and it's just going to keep slowly eating
> more data until the underlying problem is fixed, and there's no guarantee
> that a repair is going to restore data correctly.  If we exclude broken
> hardware, the only thing btrfs check is going to repair is btrfs kernel
> bugs...and in that case, why would we expect btrfs check to have fewer
> bugs than the filesystem itself?
I wouldn't, but I would still expect to have some tool to deal with 
things like orphaned inodes, dentries which are missing inodes, and 
other similar cases that don't make the filesystem unusable, but can't 
easily be fixed in a sane manner on a live filesystem.  The ZFS approach 
is valid, but it can't deal with things like orphaned inodes where 
there's no reference in the directories any more.
>
>> I'm not sure if the brfsck is really all that helpful to user as much
>> as it is for developers to better learn about the failure vectors of
>> the file system.
>
> ReiserFS had no working fsck for all of the 8 years I used it (and still
> didn't last year when I tried to use it on an old disk).  "Not working"
> here means "much less data is readable from the filesystem after running
> fsck than before."  It's not that much of an inconvenience if you have
> backups.
For a small array, this may be the case.  Once you start looking into 
double digit TB scale arrays though, restoring backups becomes a very 
expensive operation.  If you had a multi-PB array with a single dentry 
which had no inode, would you rather be spending multiple days restoring 
files and possibly losing recent changes, or spend a few hours to check 
the filesystem and fix it with minimal data loss?
