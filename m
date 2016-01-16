Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:37618 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752905AbcAPCxt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Jan 2016 21:53:49 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aKGzr-0004jJ-Hd
	for linux-btrfs@vger.kernel.org; Sat, 16 Jan 2016 03:53:47 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 16 Jan 2016 03:53:47 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 16 Jan 2016 03:53:47 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [PATCH v4 17/18] btrfs: dedup: add a property handler for
 online dedup
Date: Sat, 16 Jan 2016 02:53:41 +0000 (UTC)
Message-ID: <pan$634b4$69424819$e965c086$abbfc676@cox.net>
References: <1452751054-2365-1-git-send-email-quwenruo@cn.fujitsu.com>
	<1452751054-2365-18-git-send-email-quwenruo@cn.fujitsu.com>
	<CAL3q7H4-Ztmx9Z4=jNT3610Y6eZbL5GqZXXOajYg3FoP_uyxYA@mail.gmail.com>
	<56984D50.3040106@cn.fujitsu.com>
	<CAL3q7H4ZS_qj3VqiFmDkvCBZK8f34SQ-T3jCDQv-V+rXrpu8Ng@mail.gmail.com>
	<pan$225c9$759721a9$6dacacd5$7fd39236@cox.net>
	<CAL3q7H5gusvi1Q0Q5uwXvf2zA+h6jHa5nSmQex4n9AZHzAR-Zw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Filipe Manana posted on Fri, 15 Jan 2016 15:22:39 +0000 as excerpted:

> On Fri, Jan 15, 2016 at 12:36 PM, Duncan <1i5t5.duncan@cox.net> wrote:
>> Filipe Manana posted on Fri, 15 Jan 2016 09:19:28 +0000 as excerpted:
>>
>>>> Yes, test driven development is very nice, but there is also problem,
>>>> especially for btrfs, like btrfs/047 which needs btrfs send
>>>> --stream-version support.
>>>
>>> Yes, this one was a special case in that around 2 years ago it seemed
>>> the functionality was going to be merged, but it ended up not being
>>> merged due to reasons not known to me (no reasons pointed in the
>>> mailing list nor in private).
>>
>> AFAIK/IIRC, the reason as I understood it is that ideally Chris Mason
>> wants to do just one more stream version bump, which means being /very/
>> sure it includes anything that has come up as needed in intervening
>> development.  There's a few things agreed to be missing in the current
>> stream version
> 
> Either you have had access to information I didn't had (Chris didn't
> ever commented on it, but Josef, David and Mark had) or you missed part
> of past discussions in the mailing list (or perhaps my mail accounts
> didn't got anything).
> Yes there were several new things discussed for a new version (and lot
> of it listed in some wiki page iirc), some of which I implemented and
> the remaining I didn't, but left the necessary changes in the stream
> format to avoid bumping the stream version again. And that's where
> things settled, without any more comments (neither on the mailing list
> nor anywhere I could read,
> something that happens often unfortunately).

So AFAIK/IIRC was incorrect, as I thought I had seen CMason comment on it 
but perhaps it was the others, and I wasn't aware that you had 
implemented all the proposed stream format changes, even if not all the 
code to actually make use of them.  But then it just... dropped.

Regardless of the details from back then, however, btrfs is arguably in a 
far more stable and mature state now than it was two years ago, and it 
may well be time to actually do that stream format bump now.

Tho "now" obviously means 4.6 at the earliest as it'll surely take a bit 
to dust off and reevaluate the patches, putting it beyond the current 4.5 
commit window.

Thanks.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

