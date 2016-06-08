Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:38250 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754600AbcFHGOH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 8 Jun 2016 02:14:07 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1bAWkd-00014C-03
	for linux-btrfs@vger.kernel.org; Wed, 08 Jun 2016 08:14:03 +0200
Received: from ip-64-134-228-1.public.wayport.net ([64.134.228.1])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 08 Jun 2016 08:14:02 +0200
Received: from 1i5t5.duncan by ip-64-134-228-1.public.wayport.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 08 Jun 2016 08:14:02 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs
Date: Wed, 8 Jun 2016 06:13:46 +0000 (UTC)
Message-ID: <pan$efe1c$f3689ab$6347ee5b$c56aedd6@cox.net>
References: <1464819934.6742.71.camel@scientia.net>
	<d500a743-7a39-8ec5-c6ce-e5a3c70ede91@nv-systems.net>
	<1464975482.6679.11.camel@scientia.net>
	<6f18c0d1-8ac5-c325-0ba8-ffb949c54554@gmail.com>
	<1465005092.6648.39.camel@scientia.net>
	<CAPmG0jZGY841PNwYi6gaun38gjN83=OMQB0r_UiVrdL9iY2J9Q@mail.gmail.com>
	<1465160205.6702.38.camel@scientia.net>
	<20160605210721.GH24492@carfax.org.uk>
	<1465162317.6702.53.camel@scientia.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Christoph Anton Mitterer posted on Sun, 05 Jun 2016 23:31:57 +0200 as
excerpted:

>> > Wasn't it said, that autodefrag performs bad for anything larger than
>> > ~1G?
>> 
>>    I don't recall ever seeing someone saying that. Of course, I may
>> have forgotten seeing it...
> I think it was mentioned below this thread:
> http://thread.gmane.org/gmane.comp.file-systems.btrfs/50444/focus=50586
> and also implied here:
> http://article.gmane.org/gmane.comp.file-systems.btrfs/51399/match=autodefrag+large+files

Yes.

I was rather surprised to see Hugo say he doesn't recall seeing anyone
state that autodefrag performs poorly on large (from half gig) files, and
that its primary recommended use is for smaller database files such as the
typical quarter-gig or smaller sqlite files created by firefox and various
mail clients (thunderbird, evolution).  Because I've both seen and
repeated that many times, myself, and indeed, the wiki's mount options
page used to say effectively that.

And actually, looking at the history of the page, it was Hugo that deleted
the wording to the effect that autodefrag didn't work well on large
database or VM files..

https://btrfs.wiki.kernel.org/index.php?title=Mount_options&diff=29268&oldid=28191

So if he doesn't remember it...

But perhaps Hugo read it as manual defrag, not autodefrag, as I don't
remember manual defrag ever being associated with that problem (tho it did
and does still have the reflinks/snapshots problem, but that's a totally
different issue).


Meanwhile, it's news to me that autodefrag doesn't have that problem any
longer...





-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

