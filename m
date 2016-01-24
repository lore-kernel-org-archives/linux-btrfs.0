Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54802 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750938AbcAXFMR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 24 Jan 2016 00:12:17 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aNCyD-00066n-Ha
	for linux-btrfs@vger.kernel.org; Sun, 24 Jan 2016 06:12:13 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 24 Jan 2016 06:12:13 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 24 Jan 2016 06:12:13 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Query about proposed dedup patches and behaviours
Date: Sun, 24 Jan 2016 05:12:05 +0000 (UTC)
Message-ID: <pan$ab528$2e503be1$616cfcd$12409215@cox.net>
References: <CAGkb5vfzcOmj1Js=pBR6=-Uad7jY2bJy5ht3F-m-1TEOBjwCYA@mail.gmail.com>
	<20160123221116.GD24672@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Mark Fasheh posted on Sat, 23 Jan 2016 14:11:16 -0800 as excerpted:

> On Thu, Jan 14, 2016 at 04:13:00PM +0000, James Hogarth wrote:
> 
>> Finally what's the present situation with regards to defragmentation
>> and deduplication? Is it safe to turn on autodefrag now when using
>> snapshots and duperemove? What should the behaviour be with the
>> proposed 4.5 dedup patches if both inline dedup and autodefrag are
>> enabled as mount options?
> 
> Was there ever a reason it was unsafe to do dedupe + autodefrag? To my
> knowledge this should be fine.

There's "unsafe" and there's "unsafe".  In this case, the question uses 
"unsafe" not as in "can crash or cause corruption unsafe", but rather as 
in "will it break the dedup reflinks I've worked so hard to create, 
reduplicating the content, unsafe".

The question was based on list discussion, originally in the context of 
(manual) defrag breaking snapshot reflinks and duplicating defragged 
content due to being (again) snapshot unaware.  The question in that form 
was if manual defrag is so bad in terms of additional space usage due to 
breaking reflinks, what about autodefrag?  The logical extension of the 
question here is what is the reflink-breaking effect of autodefrag on 
dedup?

In the original snapshot context of the question, there was originally 
some difference of opinion.  The one side, taken by a dev or two, was 
that it uses the same mechanism, so the effect should be similar.  The 
other side, originally taken by Hugo, was that it was no big deal, at 
first simply stated without a reason given, thus making things very 
confusing for pretty much everyone.

After the confusion became apparent, Hugo (as he later explained in his 
reply) did some research, originally intending to confirm his reasoning 
by pointing at the code.  However, in doing so he found out both sides 
were correct, they were simply looking at things from different 
viewpoints.

So here's the deal.  (Manual) defrag is pointed at some files and if they 
appear to be fragmented in the subvolume (snapshot or working copy) that 
it is pointed at, it will rewrite potentially large portions of the file 
as it attempts to consolidate fragmented sections into fewer fragments.  
Of course as it does so, it breaks reflinks (snapshot or otherwise), 
thereby increasing space usage.

Autodefrag, meanwhile, apparently primarily (only?) triggers on partial 
rewrite, and only checks a relatively small portion of the file around 
the written block, scheduling them for later rewrite of the relatively 
smaller section, if it is fragmented.  Yes, it'll break reflinks as well, 
but the write by itself will obviously break them for the block being 
rewritten, already, due to COW.  And because autodefrag primarily (only?) 
triggers on writes, not reads as well, and only in a relatively small 
area around the write itself, only these much smaller areas are subject 
to reflink breakage, and some such breakage would already be occurring 
due to the write in the first place.

So the answer, at least as Hugo explained it (or more precisely, at least 
as I understand his explanation...), is that autodefrag will rewrite more 
of the file and thus break more reflinks and (re)duplicate more blocks 
than doing the writes without autodefrag, but it'll be a relatively small 
increase in duplication, likely acceptable given the higher read 
efficiency of the autodefragged area, compared to manual defrag of the 
same files.

So autodefrag in the context of dedup could be a small positive or a 
small negative, depending on how sensitive specific installations that 
are already doing dedup are to the relatively small increase in size, but 
the effect should be nothing at all like manual defrag on the same files 
that were deduped, which has a far larger potential to undo all the 
reflinking the dedup did in the first place.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

