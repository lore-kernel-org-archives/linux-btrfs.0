Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f171.google.com ([209.85.213.171]:36622 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932770AbbLONcA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Dec 2015 08:32:00 -0500
Received: by mail-ig0-f171.google.com with SMTP id ph11so107920007igc.1
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Dec 2015 05:32:00 -0800 (PST)
Subject: Re: [PATCH v3] btrfs: Introduce new mount option to disable tree log
 replay
To: Christoph Anton Mitterer <calestyo@scientia.net>,
        linux-btrfs@vger.kernel.org
References: <1449714846-18174-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20151214173200.GO4227@twin.jikos.cz> <566F016D.8050403@gmail.com>
 <1450120614.6629.34.camel@scientia.net> <566F199A.5030704@gmail.com>
 <1450122242.6629.45.camel@scientia.net> <566F24A6.8040605@gmail.com>
 <1450136088.6629.74.camel@scientia.net>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <5670163F.1010600@gmail.com>
Date: Tue, 15 Dec 2015 08:31:43 -0500
MIME-Version: 1.0
In-Reply-To: <1450136088.6629.74.camel@scientia.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2015-12-14 18:34, Christoph Anton Mitterer wrote:
> On Mon, 2015-12-14 at 15:20 -0500, Austin S. Hemmelgarn wrote:
>> On 2015-12-14 14:44, Christoph Anton Mitterer wrote:
>>> On Mon, 2015-12-14 at 14:33 -0500, Austin S. Hemmelgarn wrote:
>>>> The traditional reasoning was that read-only meant that users
>>>> couldn't
>>>> change anything
>>> Where I'd however count the atime changes to.
>>> The atimes wouldn't change magically, but only because the user
>>> stared
>>> some program, configured some daemon, etc. ... which
>>> reads/writes/etc.
>>> the file.
>> But reading the file is allowed, which is where this starts to get
>> ambiguous.
> Why?
Because according to POSIX, when a file gets read, the atime gets 
updated.  Except that POSIX doesn't specify what happens if the 
filesystem is mounted read-only, but the underlying block device is 
writable.
>
>> Reading a file updates the atime (and in fact, this is the
>> way that most stuff that uses them cares about them), but even a ro
>> mount allows reading the file.
> As I just wrote in the other post, at least for btrfs (haven't checked
> ext/xfs due to being... well... lazy O:-) ) ro mount option  or  ro
> snapshot seems to mean: no atime updates even if mounted with
> strictatimes (or maybe I did just something stupid when checking, so
> better double check)
>
>
>> The traditional meaning of ro on UNIX
>> was (AFAIUI) that directory structure couldn't change, new files
>> couldn't be created, existing files couldn't be deleted, flags on the
>> inodes couldn't be changed, and file data couldn't be changed.  TBH,
>> I'm
>> not even certain that atime updates on ro filesystems was even an
>> intentional thing in the first place, it really sounds to me like the
>> type of thing that somebody forgot to put in a permissions check for,
>> and then people thought it was a feature.
> Well in the end it probably doesn't matter how it came to existence,...
> rather what it should be and what it actually is.
Knowing how you got where you are is pretty important for figuring out 
how to not end up there again :)
> As said, I, personally, from the user PoV, would says soft-ro already
> includes no dates on files being modifiable (including atime), as I'd
> consider these a property of the file.
> However anyone else may of course see that differently and at the same
> time be smarter than I am.
AFAIK, the original versions of UNIX had no touch command or utime() 
syscall, so ctime, mtime, and atime were these things that just got 
magically updated by the system (ctime is still this way), and thus 
wasn't something that was considered user modification to the filesystem.
>
>> Also,
>
>> even with noatime, I'm pretty sure the VFS updates the atime every
>> time
>> the mtime changes
> I've just checked and not it doesn't:
>    File: ‘subvol/FILE’
>    Size: 8         	Blocks: 16         IO Block: 4096   regular
> file
> Device: 30h/48d	Inode: 257         Links: 1
> Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid:
> (    0/    root)
> Access: 2015-12-15 00:01:46.452007798 +0100
> Modify: 2015-12-15 00:31:26.579511816 +0100
> Change: 2015-12-15 00:31:26.579511816 +0100
>
> (rw,noatime mounted,... mtime, is more recent than atime)
Hmm, I could have sworn that updating the mtime on a file would force an 
atime update.  \me checks documentation.  OK, I was thinking of 
relatime, which updates the atime if it's older than mtime or ctime.
>
>>   (because not doing so would be somewhat stupid, and
>> you're writing the inode anyway), which technically means that stuff
>> could work around this by opening the file, truncating it to the size
>> it
>> already is, and then closing it.
> Hmm I don't have a strong opinion here... it sounds "supid" from the
> technical point in that it *could* write the atime and that wouldn't
> cost much.
> OTOH, that would make things more ambiguous when atimes change and when
> not... (they'd only change on writes, never on reads,...)
> So I think it's good as it is... and it matches the name, which is
> noatime - and not noatime-unless-on-writes ;-)
Except there are still ways to update the atime even on a filesystem 
mounted noatime.  For example, on _every_ POSIX compliant system out 
there (and Linux itself is mostly POSIX compliant, it's primarily the 
userspace that isn't), you can update the atime using the utime() system 
call, unless the filesystem is read-only.
