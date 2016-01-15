Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43169 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754824AbcAOMgf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Jan 2016 07:36:35 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aK3cB-0005ve-Gt
	for linux-btrfs@vger.kernel.org; Fri, 15 Jan 2016 13:36:27 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Jan 2016 13:36:27 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Jan 2016 13:36:27 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [PATCH v4 17/18] btrfs: dedup: add a property handler for
 online dedup
Date: Fri, 15 Jan 2016 12:36:16 +0000 (UTC)
Message-ID: <pan$225c9$759721a9$6dacacd5$7fd39236@cox.net>
References: <1452751054-2365-1-git-send-email-quwenruo@cn.fujitsu.com>
	<1452751054-2365-18-git-send-email-quwenruo@cn.fujitsu.com>
	<CAL3q7H4-Ztmx9Z4=jNT3610Y6eZbL5GqZXXOajYg3FoP_uyxYA@mail.gmail.com>
	<56984D50.3040106@cn.fujitsu.com>
	<CAL3q7H4ZS_qj3VqiFmDkvCBZK8f34SQ-T3jCDQv-V+rXrpu8Ng@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Filipe Manana posted on Fri, 15 Jan 2016 09:19:28 +0000 as excerpted:

>> Yes, test driven development is very nice, but there is also problem,
>> especially for btrfs, like btrfs/047 which needs btrfs send
>> --stream-version support.
> 
> Yes, this one was a special case in that around 2 years ago it seemed
> the functionality was going to be merged, but it ended up not being
> merged due to reasons not known to me (no reasons pointed in the mailing
> list nor in private).

AFAIK/IIRC, the reason as I understood it is that ideally Chris Mason 
wants to do just one more stream version bump, which means being /very/ 
sure it includes anything that has come up as needed in intervening 
development.  There's a few things agreed to be missing in the current 
stream version, yes, but it's usable as-is in the near term, and before 
that bump is done, everything else related needs to be in a mature enough 
development state that we can be reasonably sure nothing else is going to 
come up as still missing, at least for a couple years after the stream 
version bump.

And without a second stream version to try, a --stream-version option 
isn't particularly testable, so it was judged to be too early to add it 
as an option.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

