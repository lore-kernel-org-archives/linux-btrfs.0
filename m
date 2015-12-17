Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:45848 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933238AbbLQD0B (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Dec 2015 22:26:01 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1a9PCY-0001Mz-AQ
	for linux-btrfs@vger.kernel.org; Thu, 17 Dec 2015 04:25:58 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Dec 2015 04:25:58 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Dec 2015 04:25:58 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: attacking btrfs filesystems via UUID collisions?
Date: Thu, 17 Dec 2015 03:25:50 +0000 (UTC)
Message-ID: <pan$8abc4$5a93b86f$66b76637$230f3991@cox.net>
References: <5668A1CB.1020007@anonym.com>
	<CAJCQCtQCoi52o2REWZGObq-19EpgCv+7QmKvP=Gvk1myVq-+_g@mail.gmail.com>
	<1449872498.31388.74.camel@fo>
	<CAJCQCtSXkXs0jQ=zaP6FJvRZS0yvz5CrjP8a06K0+htG5H8LTg@mail.gmail.com>
	<1450052868.30943.27.camel@scientia.net> <566EC2D7.3000101@gmail.com>
	<CAJCQCtTuETCh_n3dnhPbVBx6_0dcAmNgNWN_bpsTE8goH8byKg@mail.gmail.com>
	<56701B79.8030105@gmail.com> <20151215141813.GG26782@carfax.org.uk>
	<1450267418.6259.11.camel@scientia.net>
	<20151216144132.GE6322@ret.masoncoding.com>
	<1450278243.5570.10.camel@scientia.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Christoph Anton Mitterer posted on Wed, 16 Dec 2015 16:04:03 +0100 as
excerpted:

> On Wed, 2015-12-16 at 09:41 -0500, Chris Mason wrote:

>> Hugo is right here.  reiserfs had tools that would scan and entire
>> block device for metadata blocks and try to reconstruct the filesystem
>> based on what it found.

> Creepy... at least when talking about a "normal" fsck... good that btrfs
> is going to be the next-gen-ext, and not reiser4 ;)

What often gets lost in discussions of this nature is that it _wasn't_ 
"normal" fsck that had the problem, but rather, a parameter 
(--rebuild-tree, IIRC) much like btrfs check (--init-csum-tree,
 init-extent-tree) and rescue (chunk-recover) use for blowing away and 
recreating the checksum tree, extent tree, chunk tree, etc.

So it's definitely _not_ something that reiserfsck would do in a "normal" 
fsck, only when doing "I'm desperate and don't have backups, go to the 
ends of the earth if necessary to recover what you can of my data, and 
yes, I understand it could be a bit risky or end up rather disordered, 
but I'm willing to take that risk because I _am_ that desperate", level 
recovery.

Arguably, however, the problem was that reiserfs (heh, that's the second 
time I almost wrote btrfs and caught it, hope I didn't miss any! =:^) had 
a rather minor items repair mode, and an "I'm desperate, ends of the 
earth and I don't care about the risk as anything is better than nothing" 
mode, but not a lot of choice in between the two.  Additionally, now 
looking at btrfs (a correct reference this time! =:^), the "desperate" 
solution in btrfs is rather more fine-grained, including at least the 
three above options plus one for the superblock, with an additional read-
only restore tool that can often restore most or all data to elsewhere, 
in the case of a missed or not current backup, that reiserfs never had.

But AFAIK reiser4 (which I never actually tried as it never made 
mainline, which in general I prefer to stick to, but I read about it) 
improved on the reiserfs model in this regard as well -- indeed, it would 
have been surprising if it didn't, since both reiser4 and btrfs had the 
lessens of reiserfs to build upon.

And of course reiserfs might have gotten the same sort of tool changes 
too, except for Hans Reiser's controversial policy of letting stable be 
stable, and putting the improvements into reiser4, which of course was 
intended to get into mainline in some reasonable time and thus wouldn't 
have left reiserfs users so in the lurch as actually happened, because 
reiser4 never did hit mainline due to $reasons, most/all of which I agree 
with, or at least understand, where I don't entirely agree.

But anyway, for anyone with half a tech-oriented brain, it was very 
evident that the required options were "desperate" level, and for people 
without half a tech-oriented brain, the documentation clearly suggested 
danger ahead, you should have backups if you're going to do this as it's 
a risky process that could destroy chances of recovery instead of fixing 
things, as well.

But of course so many don't read the docs, they just do it... and 
sometimes they suffer the consequences when they do... and sometimes then 
try to blame others for it.  <shrug>  That's the way of the world; not 
something we're going to change.

Even the required actually spelled out "yes" confirmation, not just "y", 
didn't stop people, either from doing it or for blaming reiserfs for 
problems that were in fact mostly their own, when they went ahead anyway.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

