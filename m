Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:19665 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754636AbaFBNWR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 2 Jun 2014 09:22:17 -0400
Message-ID: <538C7A79.8070407@fb.com>
Date: Mon, 2 Jun 2014 09:22:01 -0400
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Martin <m_btrfs@ml1.co.uk>, <linux-btrfs@vger.kernel.org>
Subject: Re: What to do about snapshot-aware defrag
References: <5388ED6B.8000706@fb.com> <lmav1p$ih7$1@ger.gmane.org>
In-Reply-To: <lmav1p$ih7$1@ger.gmane.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/30/2014 06:00 PM, Martin wrote:
> OK... I'll jump in...
>
> On 30/05/14 21:43, Josef Bacik wrote:
>> Hello,
>>
>> TL;DR: I want to only do snapshot-aware defrag on inodes in snapshots
>> that haven't changed since the snapshot was taken.  Yay or nay (with a
>> reason why for nay)
>
> [...]
>>
>> === Summary and what I need ===
>>
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
>
>
> One question:
>
> Will option one mean that we always need to mount with noatime or
> read-only to allow snapshot defragging to do anything?
>

Yeah atime would screw this up, I hadn't thought of that.  With that 
being the case I think the only option is to keep the old behavior, we 
don't want to screw up stuff like this just because users used a backup 
program on their snapshot and didn't use noatime.  Thanks,

Josef

