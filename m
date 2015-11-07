Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:39333 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751163AbbKGIeY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 7 Nov 2015 03:34:24 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1Zuyx3-0002pV-0m
	for linux-btrfs@vger.kernel.org; Sat, 07 Nov 2015 09:34:21 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 07 Nov 2015 09:34:21 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 07 Nov 2015 09:34:21 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Btrfs progs pre-release 4.3-rc1
Date: Sat, 7 Nov 2015 08:34:14 +0000 (UTC)
Message-ID: <pan$3824b$cc94e858$deca2096$42ae1abf@cox.net>
References: <20151102151453.GI13624@twin.jikos.cz>
	<pan$92b40$752beab9$f06026e1$b913018c@cox.net>
	<20151106105353.GR13624@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

David Sterba posted on Fri, 06 Nov 2015 11:53:53 +0100 as excerpted:

> On Tue, Nov 03, 2015 at 12:10:14AM +0000, Duncan wrote:
>> David Sterba posted on Mon, 02 Nov 2015 16:14:53 +0100 as excerpted:
>> 
>> > the kernel 4.3 was released yesterday, the btrfs-progs will follow at
>> > the end of this week. I've tagged an rc1 from current devel branch.
>> > There are a lots of small invisible changes and one change in the
>> > defaults:
>> > 
>> > * mkfs: mixed mode is not forced anymore for devices smaller than 1
>> > GiB
>> 
>> It says one change in the /defaults/, but then it says mixed mode isn't
>> /forced/ anymore under a GiB.
> 
> Well, it may be a loose definition of 'default'. I meant a change in the
> current behaviour without further tuning.
> 
>> If the /defaults/ changed, is mixed mode still /recommended/ for small
>> filesystems?
> 
> Yes it is, where small remains < 1 GiB.

Thanks.  Useful information, now more important to know than ever, since 
it's no longer the under-a-gig no-additional-options default.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

