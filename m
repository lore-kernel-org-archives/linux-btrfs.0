Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fw5a-delaine.wadns.net ([196.220.39.203]:35315 "EHLO
	fw5a.wadns.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752609AbaEaXwI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 31 May 2014 19:52:08 -0400
Message-ID: <538A6B15.3080609@swiftspirit.co.za>
Date: Sun, 01 Jun 2014 01:51:49 +0200
From: Brendan Hide <brendan@swiftspirit.co.za>
MIME-Version: 1.0
To: Martin <m_btrfs@ml1.co.uk>, linux-btrfs@vger.kernel.org
Subject: Re: What to do about snapshot-aware defrag
References: <5388ED6B.8000706@fb.com> <lmav1p$ih7$1@ger.gmane.org>
In-Reply-To: <lmav1p$ih7$1@ger.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014/05/31 12:00 AM, Martin wrote:
> OK... I'll jump in...
>
> On 30/05/14 21:43, Josef Bacik wrote:
>> [snip]
>> Option 1: Only relink inodes that haven't changed since the snapshot was
>> taken.
>>
>> Pros:
>> -Faster
>> -Simpler
>> -Less duplicated code, uses existing functions for tricky operations so
>> less likely to introduce weird bugs.
>>
>> Cons:
>> -Could possibly lost some of the snapshot-awareness of the defrag.  If
>> you just touch a file we would not do the relinking and you'd end up
>> with twice the space usage.
> [...]
>
>
> Obvious way to go for fast KISS.

I second this - KISS is better.

Would in-band dedupe resolve the issue with losing the 
"snapshot-awareness of the defrag"? I figure that if someone absolutely 
wants everything deduped efficiently they'd put in the necessary 
resources (memory/dedicated SSD/etc) to have in-band dedupe work well.
> One question:
>
> Will option one mean that we always need to mount with noatime or
> read-only to allow snapshot defragging to do anything?

That is a very good question. I very rarely have mounts without noatime 
- and usually only because I hadn't thought of it.

> Regards,
> Martin

-- 
__________
Brendan Hide
http://swiftspirit.co.za/
http://www.webafrica.co.za/?AFF1E97

