Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43100 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755293AbaJUMIr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Oct 2014 08:08:47 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XgYF4-0006Yb-DO
	for linux-btrfs@vger.kernel.org; Tue, 21 Oct 2014 14:08:46 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 21 Oct 2014 14:08:46 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 21 Oct 2014 14:08:46 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: inode_cache  Re: strange 3.16.3 problem
Date: Tue, 21 Oct 2014 12:08:34 +0000 (UTC)
Message-ID: <pan$b739f$6a3f3cfa$f40a51eb$36a00e13@cox.net>
References: <201410181454.19375.russell@coker.com.au>
	<54426C16.5030206@pobox.com> <201410191041.42013.russell@coker.com.au>
	<54454858.8010802@pobox.com> <54456EB0.9020503@inwind.it>
	<pan$87a32$ab14c0c8$d31af00$391cbfd4@cox.net>
	<20141021161611.0f78e6e2@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Roman Mamedov posted on Tue, 21 Oct 2014 16:16:11 +0600 as excerpted:

> On Tue, 21 Oct 2014 09:50:37 +0000 (UTC)
> Duncan <1i5t5.duncan@cox.net> wrote:
> 
>> (FWIW I wish that mount option would just go away as it would
>> definitely remove an invitation to a Russian roulette party with their
>> data for the unwary, but I suppose there's someone paying some bills
>> somewhere that wants it kept for some specific use-case where the
>> performance gain must be worth the calculated risk, thus continuing
>> that invitation to data Russian roulette for everyone else.)
> 
> Why do you think it is so dangerous? Just because of possible bugs? But
> bugs can be anywhere in Btrfs, why specifically single out one mount
> option.
> 
> Let's take a look at its description in the wiki:
> 
> "inode_cache (since 3.0)
> Enable free inode number caching. Not recommended to use unless files on
> your filesystem get assigned inode numbers that are approaching 2^64.
> Normally, new files in each subvolume get assigned incrementally (plus
> one from the last time) and are not reused. The mount option turns on
> caching of the existing inode numbers and reuse of inode numbers of
> deleted files.
> This option may slow down your system at first run, or after mounting
> without the option."
> https://btrfs.wiki.kernel.org/index.php/Mount_options
> 
> As you can see it's not about performance, but rather more of a
> recognition that a filesystem with some pre-determined finite lifetime
> expectancy is not a good thing to have; even though 2^64 is a lot, there
> are various scenarios out there, including millions of files and
> constant creation and removal of snapshots, that may make the FS hit the
> limit faster than you would expect.

inode_cache is generally not needed on 64-bit, and it is known to cause 
problems on 32-bit where a cache overflow and non-unique cached inode-
numbers is possible on large filesystems, as well as boot-time slowdowns 
(including timeouts on mounting, for filesystems mounted at boot) on 64-
bit.

I guess the real trouble is that the problems with it aren't well 
documented and relatively few people know about them, mostly regulars on 
this list, so people end up enabling it even on 64-bit where about the 
only effect is a boot-time slowdown and the increased chance of crash-
corruption of yet another cache, as well as on 32-bit where it's actually 
useful if somewhat risky (especially for large filesystems), thus getting 
themselves in needless trouble.  If there was a big IF YOU USE THIS AND 
IT GOES BAD YOU GET TO KEEP THE PIECES warning on it, I guess fewer 
people would use it, but then people would be asking questions about why 
it's there in the first place.

And I don't know why, as I've only seen it cause needless problems, never 
actually help, and I know that everyone here recommends turning it off 
without any exception I've seen.  But the conspiracy theory side of me 
says if it's causing problems and not helping, and it's still there, 
there must be a reason...

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

