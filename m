Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:45409 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750870AbbLBNel (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 2 Dec 2015 08:34:41 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1a47Xi-0006VT-Ky
	for linux-btrfs@vger.kernel.org; Wed, 02 Dec 2015 14:33:58 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 02 Dec 2015 14:33:58 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 02 Dec 2015 14:33:58 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: LWN mention
Date: Wed, 2 Dec 2015 13:31:42 +0000 (UTC)
Message-ID: <pan$9861d$cc5c2d8b$20be79e8$fdbc5e82@cox.net>
References: <201511081738.32151.russell@coker.com.au>
	<pan$7b4e2$387dc385$3403f685$225ed4e6@cox.net>
	<201512021742.15907.russell@coker.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Russell Coker posted on Wed, 02 Dec 2015 17:42:15 +1100 as excerpted:

> On Mon, 9 Nov 2015 08:10:13 AM Duncan wrote:
>> Russell Coker posted on Sun, 08 Nov 2015 17:38:32 +1100 as excerpted:
>> > https://lwn.net/Articles/663474/
>> > http://thread.gmane.org/gmane.comp.file-systems.btrfs/49500
>> > 
>> > Above is a BTRFS issue that is mentioned in a LWN comment.  Has this
>> > one been fixed yet?
>> 
>> Good job linking to a subscription-only article, without using a link
>> that makes it available for non-subscriber list readers to read.[1]
> 
> Well it's only subscription-only for a week, so it's available for
> everyone now.

Thanks for the reminder.  I just finished reading TFA and all the 
comments.  Wow!  PaXTeam arguably knows his security stuff but he either 
doesn't know much about actually playing on a team or he has incentive 
not to play well with the kernel team.  And he seemed to be "in vehement 
agreement" with Jon's article.  Oh, well...

As for the question of the thread, no real answers on-thread, but I 
believe I've seen patches posted mentioning that the problem fixed was 
found by the grsec overflow checker.  It may be that the devs are a bit 
wary of posting direct answers to the threads themselves, in case PaXTeam 
replies and it turns into a flame fest.  Better for all concerned just to 
do the patch and not directly reply to the thread, and given PaXTeam's 
behavior in the comments of that article I can definitely agree with the 
wisdom of such a strategy, if there's any chance at all that he might be 
drawn by the mention to the thread.

> While LWN has a feature for "subscribers" (which includes me because HP
> sponsors LWN access for all DDs) to send free links for other people I
> don't believe it would be appropriate to use that on a mailing list.  If
> anyone had asked by private mail I'd have been happy to send them a
> personal link for that.

FWIW, I was still a subscriber when that feature was first presented, and 
Jon actually seemed fine with posting the special links to for instance 
the various kernel lists, but to other more technical or limited 
readership Linux related lists as well, the idea being that like the 
public access months many subscriber TV channels have, a sample of the 
content would bring in new subscribers.  And sponsored article access, 
please consider subscribing, notices on such articles, seems to encourage 
that as well.

So I think it would have been fine, but of course I respect your 
differing opinion as well, as it's clearly a personal call. =:^)

But it would have been nice to have added a "subscriber-only until xx 
date" note, in that case, instead of simply posting a link with no 
reference to the (temporary) pay-wall in place, in which case I'd have 
not even bothered, since I know under the current circumstances I can't 
subscribe (as explained).

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

