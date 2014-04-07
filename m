Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from atl4mhob11.myregisteredsite.com ([209.17.115.49]:50277 "EHLO
	atl4mhob11.myregisteredsite.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755125AbaDGONT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 7 Apr 2014 10:13:19 -0400
Received: from mailpod1.hostingplatform.com ([10.30.71.117])
	by atl4mhob11.myregisteredsite.com (8.14.4/8.14.4) with ESMTP id s37EDDqg025239
	for <linux-btrfs@vger.kernel.org>; Mon, 7 Apr 2014 10:13:13 -0400
Message-ID: <5342B2A8.7090705@chinilu.com>
Date: Mon, 07 Apr 2014 07:14:00 -0700
From: George Mitchell <george@chinilu.com>
Reply-To: george@chinilu.com
MIME-Version: 1.0
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Subject: Re: Possible application issue ...
References: <534236AF.4020204@chinilu.com> <pan$e4d1$3c986a6f$c6e086ab$b682327c@cox.net>
In-Reply-To: <pan$e4d1$3c986a6f$c6e086ab$b682327c@cox.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/07/2014 05:42 AM, Duncan wrote:
> George Mitchell posted on Sun, 06 Apr 2014 22:25:03 -0700 as excerpted:
>
>> I am seeming to have an issue with a specific application.  I just
>> installed "Recoll", a really nice desktop search tool.  And the
>> following day whenever my backup program would attempt to run, my
>> computer simply stopped dead in its tracks and I was forced to do a
>> hard reboot to get it back.  So tonight I have been trying to shag out
>> the  problem.  And the problem goes like this.  Whenever I try to
>> defrag the  Recoll data files, I get a string of weird messages poring
>> out from the btrfs defrag program itself and flashing messages on the
>> screen  regarding some sort of CPU failure problem for both cpus.  As
>> soon as I removed the ".recoll" data directory from the path,
>> everything got OK.
>> Does anyone know what might be going on here or should I run the thing
>> and try to trap the output and post it and/or send a copy of the data
>> files in question?
> Just a btrfs user and list regular here, not a dev, but...
>
> You'll probably need to post the output for a bug fix... unless it's
> simply stalled for NNN seconds warnings (usually 30/60/90/120/etc), in
> which case the general case is known, but then you'll want to...
>
> echo w > /proc/sysrq-trigger
>
> ...  and post the output from that.  That's the usually requested info
> from that case, anyway.  And if this is the case, the apparent lockup
> should go away on its own after some time, but it might be a few minutes
> if the files are very heavily fragmented, as is likely.
>
>
> Meanwhile, database files are part of a general category of frequently
> internally updated (as opposed to append-only updated) files that all
> copy-on-write filesystems including btrfs have problems with as they tend
> to fragment very fast and hard on COW because rewrites are to new
> locations.
>
> How large are the files in question?  Are you using the btrfs autodefrag
> mount option?  Do you do use snapper or otherwise do lots of (likely
> scripted) snapshots on that subvolume or filesystem?
>
> Generally speaking, if the files aren't too large (perhaps a couple
> hundred MiB or smaller), btrfs' autodefrag option can usually deal with
> the fragmentation as it occurs.  This works quite well for firefox sqlite
> databases, for instance.
>
> Once the files in question get over perhaps half a gigabyte in size,
> however, that doesn't work so well, particularly if the file is being
> updated at a reasonable speed in real-time, as autodefrag queues the
> entire file for rewrite in ordered to defrag it, and at some point the
> rewriting can't keep up with the updates coming in.
>
> For large internal-rewrite-pattern files, there's the NOCOW extended file
> attribute, which tells btrfs to rewrite the files in place, and disables
> the usual checksumming and etc that can also take time and complicate
> things on database files where the database generally already has some
> file integrity management of its own, that can "fight" with the
> management btrfs does.
>
> But to be effective, setting nocow (chattr +C /path/to/file/or/dir) needs
> to be done while the file is still zero size, before it has any content.
> The easiest way to do that is to set it on the directory, before the
> files in the directory are created, so they inherit the nocow attribute
> from the directory they're created in.
>
> The easiest solution at this point might be to delete the current
> fragmented files instead of trying to defrag them, setup the nocow on the
> directory that will contain them, and then trigger a reindexing.
>
>
> However, there's one additional caveat involving snapshots.  By
> definition, the first change to a fileblock after a snapshot will be copy-
> on-write despite the nocow attribute.  This is because the snapshot froze
> the existing file data in place as it was, so a change to it must be
> written to a new location even if the file is set nocow.  This shouldn't
> be too big of a problem if you're just taking a snapshot manually every
> week or so, but if you're using snapper or a similar automated script to
> take hourly or even per-minute snapshots, the effect is likely to be
> nearly as bad as if the file wasn't set nocow in the first place!
>
> If this is the case, creating dedicated subvolume for the directory
> containing these files is the best idea, since snapshots stop at subvolume
> boundaries, so as long as you're not snapshotting the subvolume, you can
> set nocow on directories and files within it and not have to worry about
> snapshot-based cow undermining your efforts.
>
I think you nailed it in terms of this being comparable to stuff like 
virtual images and bittorrent.  These are indeed a collection of 
multiple large databases, one over 6GB in size, so it becomes obvious 
why defrag is choking on it.  It was late last night when I posted this, 
but thinking on it through the night, I realized this might be what is 
going on.  So at this point I am just going to continue filtering these 
files out of the defrag.  I don't typically use databases, so this kind 
of blindsided me.  But thanks for confirming what I was already 
beginning to suspect.  This desktop search program IS active continually 
and I strongly suspect also that the two programs are colliding in mid 
air as they try to manipulate the database content on the drive.  But it 
really does produce a trainwreck systemwise.  Thanks again for the 
pointers and reminders on this.
