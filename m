Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f169.google.com ([209.85.223.169]:35030 "EHLO
	mail-io0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811AbbLNOZF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Dec 2015 09:25:05 -0500
Received: by iofq126 with SMTP id q126so34942283iof.2
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Dec 2015 06:25:04 -0800 (PST)
Subject: Re: btrfs: poor performance on deleting many large files
To: Christoph Anton Mitterer <calestyo@scientia.net>,
        Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
References: <CA+ve2MYBAPbLPiX4i2oZeDeu+9=JurXHsx5fMef2iV3rRrCKxg@mail.gmail.com>
 <pan$eea04$e9596e27$78b44461$c5754723@cox.net>
 <1448488198.4717.4.camel@gmail.com>
 <pan$8ce6a$31af576$4416e55e$7b867388@cox.net>
 <1448562347.8809.16.camel@scientia.net>
 <pan$54542$5eb77bd3$8682bff8$82310de1@cox.net>
 <1448582805.11377.9.camel@scientia.net>
 <pan$34543$2ed1f043$2f803125$884b36c0@cox.net>
 <1448683025.6837.4.camel@scientia.net>
 <pan$46a28$81694e9d$c6d5f048$1c8bcdd8@cox.net>
 <1449958538.15961.3.camel@scientia.net>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <566ED124.30803@gmail.com>
Date: Mon, 14 Dec 2015 09:24:36 -0500
MIME-Version: 1.0
In-Reply-To: <1449958538.15961.3.camel@scientia.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2015-12-12 17:15, Christoph Anton Mitterer wrote:
> On Sat, 2015-11-28 at 06:49 +0000, Duncan wrote:
>> Christoph Anton Mitterer posted on Sat, 28 Nov 2015 04:57:05 +0100 as
>> excerpted:
>>> Still, specifically for snapshots that's a bit unhandy, as one
>>> typically
>>> doesn't mount each of them... one rather mount e.g. the top level
>>> subvol
>>> and has a subdir snapshots there...
>>> So perhaps the idea of having snapshots that are per se noatime is
>>> still
>>> not too bad.
>> Read-only snapshots?
> So you basically mean that ro snapshots won't have their atime updated
> even without noatime?
> Well I guess that was anyway the recent behaviour of Linux filesystems,
> and only very old UNIX systems updated the atime even when the fs was
> set ro.
Unless things have changed very recently, even many modern systems 
update atime on read-only filesystems, unless the media itself is 
read-only.  This is part of the reason for some of the forensics tools 
out there that drop write commands to the block devices connected to them.
>
>> That'd do it, and of course you can toggle the read-
>> only property (see btrfs property and its btrfs-property manpage).
> Sure, but then it would still be nice for rw snapshots.
>
> I guess what I probably actually want is the ability to set noatime as
> a property.
> I'll add that in a "feature request" on the project ideas wiki.
>
>> Alternatively, mount the toplevel subvol read-only or noatime on one
>> mountpoint, and bind-mount it read-write or whatever other
>> appropriate
> Well it's of course somehow possible... but that seems a bit ugly to
> me... the best IMHO, would really be if one could set a property on
> snapshots that marks them noatime.
If you have software that actually depends on atimes, then that software 
is broken (and yes, I even feel this way about Mutt).  The way atimes 
are implemented on most systems breaks the semantics that almost 
everyone expects from them, because they get updated for anything that 
even looks sideways at the inode from across the room.  Most software 
that uses them expects them to answer the question 'When were the 
contents of this file last read?', but they can get updated even for 
stuff like calculating file sizes, listing directory contents, or 
modifying the file's metadata.

