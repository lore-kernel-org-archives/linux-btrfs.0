Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:37189 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932927AbbLPJQC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Dec 2015 04:16:02 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1a98Bk-00029T-7e
	for linux-btrfs@vger.kernel.org; Wed, 16 Dec 2015 10:16:00 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Dec 2015 10:16:00 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Dec 2015 10:16:00 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: dear developers, can we have notdatacow + checksumming, plz?
Date: Wed, 16 Dec 2015 09:15:53 +0000 (UTC)
Message-ID: <pan$b3872$2bf834b4$c6dedc4e$e2073fbb@cox.net>
References: <1450069158.2388.72.camel@scientia.net>
	<566ECF41.10709@gmail.com> <1450149311.701.126.camel@scientia.net>
	<56703928.7070003@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Austin S. Hemmelgarn posted on Tue, 15 Dec 2015 11:00:40 -0500 as
excerpted:

> And in particular, the only
> journaling filesystem that I know of that even allows the option of
> journaling the file contents instead of just metadata is ext4.

IIRC, ext3 was the first to have it in Linux mainline, with data=writeback 
for the speed freaks that don't care about data loss, data=ordered as the 
default normal option (except for that infamous period when Linus lost 
his head and let people talk him into switching to data=writeback, 
despite the risks... he later came back to his senses and reverted that), 
and data=journal for the folks that were willing to pay trade a bit of 
speed for better data protection (tho it was famous for surprising 
everybody, in that in certain use-cases it was extremely fast, faster 
than data=writeback, something I don't think was ever fully explained).

To my knowledge ext3 still has that, tho I haven't used it probably a 
decade.

Reiserfs has all three data= options as well, with data=ordered the 
default, tho it only had data=writeback initially.  While I've used 
reiserfs for years, it has always been with the default data=ordered 
since that was introduced, and I'd be surprised if data=journal had the 
same use-case speed advantage that it did on ext3, as it's too 
different.  Meanwhile, that early data=writeback default is where 
reiserfs got its ill repute for data loss, but it had long switched to 
data=ordered by default by the time Linus lost his senses and tried 
data=writeback by default on ext3.  Because I was on reiserfs from 
data=writeback era, I was rather glad most kernel hackers didn't want to 
touch it by the time Linus let them talk him into data=writeback on ext3, 
and thus left reiserfs (which again had long been data=ordered by default 
by then) well enough alone.

But I did help a few people running ext3 trace down their new ext3 
stability issues to that bad data=writeback experiment, and persuaded 
them to specify data=ordered, which solved their problems, so indeed 
they /were/ data=writeback related.  And happily, Linus did eventually 
regain his senses and return ext3 to data=ordered by default once again.

And based on what you said, ext4 still has all three data= options, 
including data=journal.  But I wasn't sure on that myself (tho I would 
have assumed it inherited it from ext3) and thus am /definitely/ not sure 
whether it inherits ext3's data=journal speed advantages in certain 
corner-cases.

I have no idea whether other journaled filesystems allow choosing the 
journal level or not, tho.  I only know of those three.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

