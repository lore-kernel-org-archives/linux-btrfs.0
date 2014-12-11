Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36849 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755473AbaLKEt6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Dec 2014 23:49:58 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XyvhM-0007Ec-FZ
	for linux-btrfs@vger.kernel.org; Thu, 11 Dec 2014 05:49:56 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Dec 2014 05:49:56 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Dec 2014 05:49:56 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Fixing Btrfs Filesystem Full Problems typo?
Date: Thu, 11 Dec 2014 04:49:44 +0000 (UTC)
Message-ID: <pan$ad009$a71fbc68$c8d29208$7d66d849@cox.net>
References: <CAA7pwKNH-Cbd+_D+sCEJxxdervLC=_3_AzaywSE3mXi8MLydxw@mail.gmail.com>
	<20141122222606.GO8916@merlins.org>
	<CAA7pwKOSbdxaiN=_ERSQLnoPNBfO0cyzamuv=xsWtvpro-+JJg@mail.gmail.com>
	<20141123000503.GQ32735@carfax.org.uk>
	<20141123010742.GA16599@merlins.org>
	<pan$5df6$ab571fd5$d428faeb$f4fcc034@cox.net>
	<CAA7pwKOAvTNAprN+pebZ3Qow-U2SBjLP_XbVXcVKY4NeFS_qRQ@mail.gmail.com>
	<pan$1cbab$ed4a0087$b6b58a81$490b38ad@cox.net>
	<CAA7pwKNPV3PCLP3s_MzoMG2da6Rfsy9HM=b8o8u87QqDV5WB+w@mail.gmail.com>
	<CAA7pwKOtOeCL-40EjqmEZ=NR=7Nfz_1Kzx2X4O105ndKGJMkrA@mail.gmail.com>
	<54878A65.2080403@pobox.com> <54878D3E.8020809@pobox.com>
	<pan$db978$7628430b$4f067ceb$13d468cb@cox.net>
	<CAA7pwKNgZroCMa2A3vbF=aAuq9tVZSdeGc-WB1+Gcdt6_2AydQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Patrik Lundquist posted on Wed, 10 Dec 2014 21:11:52 +0100 as excerpted:

>> Patrik, assuming no btrfs snapshots yet, can you do a du --all --block-
>> size=1M | sort -n (or similar), then take a look at all results over
>> 1024 (1 GiB since the du specified 1 MiB blocks), and see if it's
>> reasonable to move all those files out of the filesystem and back?
> 
> Good idea, but it's quite a lot of files. I'd rather start over.
> 
> But I've identified 46 files from Btrfs errors in syslog and will try to
> move them to another disk. They're ranging from 41KiB to 6.6GiB in size.

There's one as yet incomplete piece of the puzzle.  I guess the devs 
could probably answer this, but being a simple sysadmin, I don't claim to 
read code well and don't know...

That log snippet you quoted earlier gave block-group addresses.  That's 
the chunks, in this case normally 1 GiB data chunks, but here we're 
dealing with a conversion from ext4 and apparently the extents are 
larger, nearly 2 GiB in this case according to that snippet.

That had me thinking the problem files were all > 1 GiB and had these 
super-extents that btrfs can't work with.

But you say you tracked down the file as I suggested using btrfs-inspect-
internal, and the file is much smaller than that.

Now I don't even know for sure what that log snippet was from, a normal 
dmesg during an attempted balance, or dmesg with btrfs debug turned on in 
the kernel, or the userspace debug you ask about, or...

And not being a dev and not having done anything like this level myself, 
I'm sort of feeling my way along here too, trying to figure things out as 
you report them.

So the missing piece I'm talking about is this.  OK, we have the address 
of a nearly 2 GiB block group reported, and I recalled seeing in an 
earlier post that trick with btrfs-inspect-internal, so I though to try 
it here.

But with the file being so much smaller than the 2 GiB block group 
reported, something's not matching.  Either the file is somehow using an 
extent much much larger than it is (possible with fallocate, then writing 
a shorter file, I believe), or the referred to block group actually 
contains more than one file -- certainly btrfs data chunks can do so, but 
given that we're dealing with a conversion here, I don't know if the same 
rules apply, or...

Anyway, it's possible that smaller file is simply the first one in the 
block group, thus being the one that was mapped when you plugged that 
address into inspect-internal, and that the problem file is actually a 
much larger file located after it in the same block group.

So if moving the small files doesn't do the trick, try feeding inspect-
internal with an address after that.  Given that btrfs blocks are 4 KiB 
in size, round the size of the small file up to the nearest 4 KiB and add 
that to the address originally obtained from the log, and see if inspect-
internal points at a different, presumably much larger (> 1 GiB or at 
least big enough so it'd extent beyond a GiB beyond the original 
address), file, with the new offset address.  If so, try moving /that/ 
file, and see if you have any better luck.

I was /hoping/ it would be the simple case and all the problem block-
group addresses would point to > 1 GiB files and moving them would be 
it.  But with a significant number of those addresses pointing at far 
smaller files, either I was wrong about the use of inspect-internal here 
and they're entirely unrelated, or the situation is otherwise rather more 
complex than I was hoping to be the case.

OTOH, if for whatever reason all those smaller files were fallocated to 
some huge size and then written smaller, or something similar happened 
such that they're using huge > 1 GiB extents even while being smaller 
than 1 GiB in size, that COULD go some distance to explaining why defrag 
missed them.  If defrag is looking at filesize and the files happen to be 
small but in huge extents, and it's those extents causing the problem, 
then we just found our bug, and all that's left is figuring out how to 
fix it, which is where I step out and the devs step in.  With a bit of 
luck, that's it, and we're now well on the way to fixing a bug that could 
have otherwise triggered unexplained problems for some people doing 
conversions, but not others, for quite some time to come.  =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

