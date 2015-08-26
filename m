Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:50905 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752896AbbHZAA3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Aug 2015 20:00:29 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZUO8e-0000Z0-R7
	for linux-btrfs@vger.kernel.org; Wed, 26 Aug 2015 02:00:24 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 26 Aug 2015 02:00:24 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 26 Aug 2015 02:00:24 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Unmountable file system
Date: Wed, 26 Aug 2015 00:00:15 +0000 (UTC)
Message-ID: <pan$308e7$3210f1e1$b8494a68$718ca31e@cox.net>
References: <CAAL+OBri=u1ZWb9SN0wvUirud6hZd4w3FxocmKxF95Z=Vi86ug@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dan Hentschel posted on Tue, 25 Aug 2015 11:11:44 -0400 as excerpted:

> I can restore some (all?) of the root fs with btrfs restore:
> 
> # btrfs restore /dev/mapper/kingston-streamer2 /mnt checksum verify
> failed on 85360640 found 6934D1E8 wanted C1A46C13 checksum verify failed
> on 85360640 found 6934D1E8 wanted C1A46C13 Csum didn't match offset is
> 20480 failed to inflate: -3
> 
> Unfortunately, this doesn't seem to restore any of the contents of
> /home, which is what I am really hoping to get at.

Three points:

1) As Chris Murphy mentioned but it's worth underlining and expanding...

While for normal online operations it's the kernel version that's 
critical as the userspace code simply forwards requests to the kernel to 
do the work, for offline operations such as check and restore the 
userspace code is critical, and you really want a current version, as old 
versions simply didn't know how to fix problems that newer versions have 
code to deal with properly.

And given the rate of btrfs development, at about two years outdated,
btrfs-progs 3.12 isn't merely old, it's ancient, like the rusty old farm 
equipment that hadn't moved in 20 years, that I used to play on as a kid!

So try updating your userspace, to something current like v4.1.2, and see 
if that works better for you. =:^)

2) Restore is /much/ improved in current userspace.  Among other things, 
it can (with the appropriate options) restore ownership/permissions/times 
metadata now, as well as symlinks, neither of which it restored before.

3) Restore (at least current versions) has options to restore only files 
under specific tree roots or by specific path-regex.  Additionally, if 
it's not finding the files you need restored by default, you can use 
btrfs-find-root along with the -t option to point it at an older, perhaps 
less damaged, root.  There's a wiki page (listed in the current btrfs-
restore manpage) that describes that in a bit more detail, altho last I 
checked it was itself a bit dated so you kind of have to play a bit of 
matchup between what it says and how the newer version works.  In that 
regard, the restore --list-roots and --dry-run options can be helpful.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

