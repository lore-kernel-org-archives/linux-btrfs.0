Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:57773 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751290AbcCMQzP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 13 Mar 2016 12:55:15 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1af9IO-0000ta-FC
	for linux-btrfs@vger.kernel.org; Sun, 13 Mar 2016 17:55:12 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 13 Mar 2016 17:55:12 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 13 Mar 2016 17:55:12 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [PATCH v7 01/20] btrfs: dedup: Introduce dedup framework and
 its header
Date: Sun, 13 Mar 2016 16:55:07 +0000 (UTC)
Message-ID: <pan$df368$11da4cf4$ea45e87d$e6f8d7f4@cox.net>
References: <1455774178-3595-1-git-send-email-quwenruo@cn.fujitsu.com>
	<1455774178-3595-2-git-send-email-quwenruo@cn.fujitsu.com>
	<87io0vjq9x.fsf@notabene.neil.brown.name>
	<56E0C668.4020406@cn.fujitsu.com> <20160311114305.GQ18908@twin.jikos.cz>
	<56E3D070.3020005@gmx.com> <56E4F7AB.4010608@cn.fujitsu.com>
	<87egbeipdp.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

NeilBrown posted on Sun, 13 Mar 2016 22:33:22 +1100 as excerpted:

> On Sun, Mar 13 2016, Qu Wenruo wrote:
> 
>> BTW, I am always interested in, why de-duplication can be shorted as
>> 'dedupe'.

>> I didn't see any 'e' in the whole word "DUPlication".
>> Or it's an abbreviation of "DUPlicatE" instead of "DUPlication"?
> 
> The "u" in "duplicate" is pronounced as a long vowel sound, almost like
> d-you-plicate.

> To make a vowel long you can add an 'e' at the end of a word.

> by analogy, "dupe" has a long "u" and so sounds like the first syllable
> of "duplicate".

As a native (USian but with some years growing up in the then recently 
independent former Crown colony of Kenya, influencing my personal 
preferences) English speaker, while what Neil says about short "u" vs. 
long "u" is correct, I agree with Qu that the "e" in dupe doesn't make so 
much sense, and would, other things being equal, vastly prefer dedup to 
dedupe, myself.

However, there's some value in consistency, and given the previous dedupe 
precedent in-kernel, sticking to that for consistency reasons makes sense.

But were this debate to have been about the original usage, I'd have 
definitely favored dedup all the way, as not withstanding Neil's argument 
above, adding the "e" makes little sense to me either.  So only because 
it's already in use in kernel code, but if this /were/ the original 
kernel code...

So I definitely understand your confusion, Qu, and have the same personal 
preference even as a native English speaker. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

