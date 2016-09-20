Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f170.google.com ([209.85.223.170]:32824 "EHLO
        mail-io0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751539AbcITMJZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Sep 2016 08:09:25 -0400
Received: by mail-io0-f170.google.com with SMTP id r145so17324840ior.0
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Sep 2016 05:09:24 -0700 (PDT)
Subject: Re: Is stability a joke? (wiki updated)
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
References: <20160912142714.GE16983@twin.jikos.cz>
 <20160912162747.GF16983@twin.jikos.cz>
 <8df2691f-94c1-61de-881f-075682d4a28d@gmail.com>
 <CAJCQCtQUS-8F+pOtQ2VA9=j=-TGV=wOfj+3SnnMvY3HMTzd=9g@mail.gmail.com>
 <1ef8e6db-89a1-6639-cd9a-4e81590456c5@gmail.com>
 <CAJCQCtQq08bOpRbZq90wRLUGD62Rnqwx6vjJOv5hvPVwp=jz0w@mail.gmail.com>
 <24d64f38-f036-3ae9-71fd-0c626cfbb52c@gmail.com>
 <CAJCQCtR_hMPj8Nrf=U1L=WvDWq48Ns1K25p4JtKEJnVwb1231Q@mail.gmail.com>
 <20160919040855.GF21290@hungrycats.org>
 <7c55ba5a-9193-d88f-e92f-b5f34f99ce57@gmail.com>
 <20160919201501.GB4703@hungrycats.org>
Cc: Chris Murphy <lists@colorremedies.com>, David Sterba <dsterba@suse.cz>,
        Waxhead <waxhead@online.no>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <0f54b80b-1aa0-c3af-0f66-4369c279fe27@gmail.com>
Date: Tue, 20 Sep 2016 08:09:19 -0400
MIME-Version: 1.0
In-Reply-To: <20160919201501.GB4703@hungrycats.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-09-19 16:15, Zygo Blaxell wrote:
> On Mon, Sep 19, 2016 at 01:38:36PM -0400, Austin S. Hemmelgarn wrote:
>>>> I'm not sure if the brfsck is really all that helpful to user as much
>>>> as it is for developers to better learn about the failure vectors of
>>>> the file system.
>>>
>>> ReiserFS had no working fsck for all of the 8 years I used it (and still
>>> didn't last year when I tried to use it on an old disk).  "Not working"
>>> here means "much less data is readable from the filesystem after running
>>> fsck than before."  It's not that much of an inconvenience if you have
>>> backups.
>> For a small array, this may be the case.  Once you start looking into double
>> digit TB scale arrays though, restoring backups becomes a very expensive
>> operation.  If you had a multi-PB array with a single dentry which had no
>> inode, would you rather be spending multiple days restoring files and
>> possibly losing recent changes, or spend a few hours to check the filesystem
>> and fix it with minimal data loss?
>
> I'd really prefer to be able to delete the dead dentry with 'rm' as root,
> or failing that, with a ZDB-like tool or ioctl, if it's the only known
> instance of such a bad metadata object and I already know where it's
> located.
I entirely agree on that.  The problem is that because the VFS layer 
chokes on it, it can't be rm, and it would be non-trivial to implement 
as an ioctl.  It pretty much has to be out-of-band.  I'd love to see 
btrfs check add the ability to process subsets of the filesystem (for 
example 'I know that something is screwed up somehow in 
/path/to/random/directory, check only that path in the filesystem 
(possibly recursively) and tell me what's wrong (and possibly try to fix 
it)').
>
> Usually the ultimate failure mode of a btrfs filesystem is a read-only
> filesystem from which you can read most or all of your data, but you
> can't ever make it writable again because of fsck limitations.
>
> The one thing I do miss about every filesystem that isn't ext2/ext3 is
> automated fsck that prioritizes availability, making the filesystem
> safely writable even if it can't recover lost data.  On the other
> hand, fixing an ext[23] filesystem is utterly trivial compared to any
> btree-based filesystem.
For a data center or corporate entity, dropping broken parts of the FS 
and recovering from backups makes sense.  For a traditional home user 
(that is, the type of person Ubuntu and Windows traditionally target), 
it usually doesn't, as they almost certainly don't have a backup. 
Personally, I'd rather have a tool that gives me the option of whether 
to try and fix a given path or just remove it, instead of assuming that 
it knows how I want to fix it.  That would allow for both use cases.

