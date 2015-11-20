Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:42461 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758006AbbKTKoz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Nov 2015 05:44:55 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZzjBS-0000M4-Ob
	for linux-btrfs@vger.kernel.org; Fri, 20 Nov 2015 11:44:50 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2015 11:44:50 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2015 11:44:50 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Kernel 3.19 and still "disk full" even though 'btrfs fi df"
 reports enough room left?
Date: Fri, 20 Nov 2015 10:44:42 +0000 (UTC)
Message-ID: <pan$423ea$b2ebc24b$fe1c12ba$fb781f7e@cox.net>
References: <564CC90F.3060703@gmail.com>
	<20151118190857.GY24333@carfax.org.uk> <564E085C.3060208@gmail.com>
	<20151119182850.GE24333@carfax.org.uk> <564E18B9.2020509@gmail.com>
	<20151119185645.GF24333@carfax.org.uk>
	<pan$7f2a7$22f8253d$ae640ac3$36e4e58d@cox.net>
	<564EEA19.1000109@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

linux-btrfs.tebulin posted on Fri, 20 Nov 2015 10:38:33 +0100 as
excerpted:

> Am 20.11.2015 um 04:14 schrieb Duncan:
>> Meta-comment:
>> 
>> Apparently that attribution should actually be to Hugo Mills.  I've no
>> idea what went wrong, but at least here as received from gmane.org, the
>> from header really does say linux-btrfs.tebulin, so something obviously
>> bugged out somewhere!
> 
> Meta-Answer: My fault
> 
> I accidentally exposed my spamgourmet proxy address to Hugo by taking
> him CC. He replied to all assuming it would go directly to the list, but
> the proxy address masked his original address an put id in it.
> 
> Sorry for messing up!

Makes sense.

While I suppose his reply to all went to the list and to the proxy, the 
proxy bounced it, presumably with the same message-id, and anything that 
tracks by message-id (including my client), which is supposed to be 
unique and thus usable for message tracking, would see only one of the 
two.  Which one would depend on which one got to it first, and whether it 
took that and refused the other one, or let the second one override the 
first.

Either way, definitely confusing, but at least there's a reasonable 
explanation now.  Thanks for helping to clear that up! =:^)

(FWIW, as with most linux kernel lists, replying to all is customary.  I 
generally reply only to the list, however, because it's far easier with 
my specific setup, tho I'll reply to author as well if specifically 
requested.  But Hugo actually does the list-recommended thing by replying 
to all by default.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

