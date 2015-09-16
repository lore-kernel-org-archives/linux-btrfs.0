Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:41361 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752002AbbIPWZb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Sep 2015 18:25:31 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZcL8q-0005oS-FM
	for linux-btrfs@vger.kernel.org; Thu, 17 Sep 2015 00:25:28 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Sep 2015 00:25:28 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Sep 2015 00:25:28 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: FYIO: A rant about btrfs
Date: Wed, 16 Sep 2015 22:25:23 +0000 (UTC)
Message-ID: <pan$3b546$97ee88db$2503cf6f$fbb2d902@cox.net>
References: <20150916144355.GA1285@invalid> <55F988A6.8070109@gmail.com>
	<A4269DC6-6CD6-4E8C-B3C9-5F5DDBE86911@up4.com>
	<55F9B357.4070505@gmail.com>
	<54A9EC91-FDFD-44A8-97B9-7347A89FA415@up4.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Vincent Olivier posted on Wed, 16 Sep 2015 15:04:38 -0400 as excerpted:

>>>> 3. He's testing it for a workload is a known and documented problem
>>>> for BTRFS, and claiming that that means that it isn't worth
>>>> considering as a general usage filesystem.  Most people don't run
>>>> RDBMS servers on their systems, and as such, such a workload is not
>>>> worth considering for most people.
>>> Apparently RDBMS being a problem on Btrfs is neither known nor
>>> documented enough (he’s right about the contrast with claiming
>>> publicly that Btrfs is indeed production ready).
>> OK, maybe not documented, but RDBMS falls under 'Large files with
>> highly random access patterns and heavy RMW usage', which is a known
>> issue for BTRFS, and also applies to VM images.
> 
> 
> This guy is no idiot. If it wasn’t clear enough for him. It’s not clear
> enough period.

I'd argue that while he's "clearly no idiot", he's equally clearly an 
"idiot savant" (relatively speaking).  He has an extremely high level of 
knowledge in a very few specific areas (rdbms being the primary one in 
discussion here), and much higher than average in a number of others, but 
unfortunately tends to lack what many would call "common sense" in some 
or many others, to the point that he does what people in those areas 
would consider "idiotic things" because he simply doesn't have a 
reasonable level of experience with them, and what's more, is 
demonstrably uninterested in getting that level of "functional 
experience", as he has higher priorities ranking where he's going to be 
spending his time -- basically, staying at the top of his field in the 
areas where he's already extremely highly knowledgeable.

Note that I'm not mocking him.  I'm much the same way, as are many geeks/
nerds, thus the term "nerdview".  (Personal example.  Back in college I 
once _stapled_ a note to a football.  It simply never occurred to me that 
a football is inflated, and stapling something to it was a _very_ bad idea
(!!), because I simply didn't have even a minimal level of functional 
experience in that area, such that I lacked "common sense" in regard to 
it, and further, wasn't then and am not now, particularly interested in 
spending my time getting that minimal functional experience level, as my 
priorities simply lie elsewhere.)  See also the relatively high level of 
Asperger syndrome among the geek crowd.

As for his conclusions, I find myself "in violent agreement", as I've 
seen it said, with most of them, the exception being that I don't agree 
that btrfs isn't appropriate as a general purpose filesystem -- I'd say a 
more accurate statement is that, taking into account btrfs' maturity 
level, btrfs is acceptable as a general purpose filesystem, with the 
caveat that as a COW based filesystem where optimization has not yet been 
a priority and may well not be for a few more years, btrfs is definitely 
COUNTER-indicated for GiB+ sized file VM-image and database use.  
However, accepting that RDBMS is in fact one of his primary focus areas, 
I can see how his definition of "general purpose" would tend to include 
that, where a more "general purpose" definition of "general purpose 
filesystem" (ha, recursive definitions!) has room for that particular 
case being an exception.

But I _definitely_ agree with him that btrfs is unfortunately being 
billed as "mature" and "production ready", where, for the general use 
case, I'd... let's just say I'd not choose that characterization, 
preferring instead to characterize btrfs as "not yet entirely stable and 
mature", and definitely not yet optimized.  It's certainly ready for 
"cautious" use after doing a bit of research on your use-case, and with 
backups at the ready if you care about the data, but as any good sysadmin 
will tell you, by definition, if you care about the data, you have it 
backed up, and if you don't have it backed up, by equal definition, you 
do _NOT_ care about losing the data, so that's a _given_.  But "cautious 
use after researching your use-case" isn't what he's interested in doing, 
or rather...

He's not particularly interested in doing that level of pre-deployment 
research, and to his credit, for a mature filesystem, he really shouldn't 
have to... tho people that care enough about their use-case, as he really 
should for RDBMS given that as a major focus point for him, will be doing 
that research anyway, _because_ they care.

Which to his credit, he's doing the research, in a way.  It's not the way 
_I_ would go about it, certainly, but by running those benchmarks, etc, 
and comparing against other filesystems, he's doing research in his own 
way, and under the parameters he uses, I certainly don't disagree with 
his conclusions, that btrfs is simply a rather poor choice for his use-
case of interest, particularly given the level of additional research and 
tuning he's demonstrably willing to put into btrfs specifically, that 
being (very close to) zero.

As for the btrfs specifics (and the nobarrier general case as well), 
Austin has covered it well enough.  But again, my point, that this guy 
isn't _interested_ in that level of specific, and given that, with the 
exception of "general purpose" as described above, I pretty much agree 
with him and his conclusions.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

