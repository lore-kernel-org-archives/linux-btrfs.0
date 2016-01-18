Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:47563 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753371AbcARCLh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 17 Jan 2016 21:11:37 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aKzI6-00056T-3U
	for linux-btrfs@vger.kernel.org; Mon, 18 Jan 2016 03:11:34 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Jan 2016 03:11:34 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Jan 2016 03:11:34 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs send - detect if complete
Date: Mon, 18 Jan 2016 02:11:28 +0000 (UTC)
Message-ID: <pan$9caf0$b39039c8$a46575fb$3e36bb8@cox.net>
References: <20160117123529.GA26322@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Lubos Kolouch posted on Sun, 17 Jan 2016 13:35:29 +0100 as excerpted:

> I am building a backup system, based on btrfs incremental send/receive.
> 
> I am a bit stuck on how to detect, if the transfer has been completed
> (and not interrupted during transfer).
> 
> Host A :
> du --max-depth=0 home_20160117
> 45787768  home_20160117
> 
> btrfs send home_20160117 | ssh dest_host "btrfs receive
> /mnt/destination/"
> 
> … transfer completes without any error
> 
> on dest_host:
> 
> du --max-depth=0 home_20160117
> 45763984  home_20160117
> 
> Ie. the size differs, perhaps due to different compression(?)

Does du --apparent-size compare equally?

My experience, even with normal copies on non-btrfs (reiserfs, in my 
case), suggests that files on an in-use filesystem, where files have been 
created, modified and deleted over time, will use more space than if 
everything's copied over to a fresh filesystem, where the copy is all at 
once and files are thus defragged and may be sparsely copied where the 
original was no-holes, etc.

I've not messed around with du enough to know if --apparent-size will 
display equally in such cases or not, but it's worth a shot, and in any 
case, with even straight copies normally showing up as more efficiently 
stored (by df and in the btrfs case btrfs fi df and btrfs fi show, on 
identically sized and type filesystems), you can't rely on simple 
aggregate size to verify a full transfer.
 
> The volume seems OK, I can use it as a parent volume for further
> transfers etc.
> 
> The question is - is there a "btrfs native" way to tell, if the two
> subvolumes are really identical (and the transfer was not interrupted
> etc.)?
> 
> Or do I have to resort to costly things like checksumming all files?

In general, what send/receive bugs there are tend to be of the command-
failure kind -- if both the send and receive complete without error, the 
copy can be considered reliable.  The problems have been various corner-
cases that receive didn't know how to handle, in which case it errors out 
rather than silently failing -- if there's an error, it lets you know and 
exit status is non-zero.   (On the send side, failure would normally 
indicate a filesystem inconsistency, that other tools like balance or 
scrub, depending on the problem, would fail on as well.)

So while you can of course manually checksum-verify everything if you're 
paranoid, I'd normally consider an exit status of success on both the 
send and receive sides as verification enough, and /definitely/ more 
reliable than simple size checks.

However, bugs do still occasionally come up where send/receive fails, 
simply because it doesn't know how to handle some corner-case.  A very 
simple example of one such incremental-send corner-case that was fixed 
early on, was when nested directories "reverse" their nesting -- IOW, 
where the original layout was /whatever/a/b, with b nested inside a, but 
that reversed to /whatever/b/a, with a nested inside b.  Again, that's 
one simple corner-case that was long ago fixed to work correctly, and 
it's now far more complex cases that still cause failure, but it 
illustrates the general type of corner-case issues that can be 
problematic.

So while successful completion should be entirely reliable, do be 
prepared for it to fail, and to either investigate and delete the 
offending file (perhaps copying it elsewhere and then back), or to report 
the problem and switch to something else, perhaps rsync, if necessary, 
until the problem is resolved.  Tho these types of issues are getting 
rarer than they were, so you might never have to deal with one, but 
having a fallback plan in case you do have such a corner-case never hurts.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

