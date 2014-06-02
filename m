Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:37491 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754638AbaFBNTp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 2 Jun 2014 09:19:45 -0400
Message-ID: <538C79D9.5040305@fb.com>
Date: Mon, 2 Jun 2014 09:19:21 -0400
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Mitch Harder <mitch.harder@sabayonlinux.org>,
        Brendan Hide <brendan@swiftspirit.co.za>
CC: Martin <m_btrfs@ml1.co.uk>, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: What to do about snapshot-aware defrag
References: <5388ED6B.8000706@fb.com>	<lmav1p$ih7$1@ger.gmane.org>	<538A6B15.3080609@swiftspirit.co.za> <CAKcLGm_Ou57upZUvUJT0RH3trVAH3DgWJp2k38q9P6vAkgjwKQ@mail.gmail.com>
In-Reply-To: <CAKcLGm_Ou57upZUvUJT0RH3trVAH3DgWJp2k38q9P6vAkgjwKQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/01/2014 11:07 PM, Mitch Harder wrote:
> On Sat, May 31, 2014 at 6:51 PM, Brendan Hide <brendan@swiftspirit.co.za> wrote:
>> On 2014/05/31 12:00 AM, Martin wrote:
>>>
>>> OK... I'll jump in...
>>>
>>> On 30/05/14 21:43, Josef Bacik wrote:
>>>>
>>>> [snip]
>>>>
>>>> Option 1: Only relink inodes that haven't changed since the snapshot was
>>>> taken.
>>>>
>>>> Pros:
>>>> -Faster
>>>> -Simpler
>>>> -Less duplicated code, uses existing functions for tricky operations so
>>>> less likely to introduce weird bugs.
>>>>
>>>> Cons:
>>>> -Could possibly lost some of the snapshot-awareness of the defrag.  If
>>>> you just touch a file we would not do the relinking and you'd end up
>>>> with twice the space usage.
>>>
>>> [...]
>>>
>>>
>>> Obvious way to go for fast KISS.
>>
>>
>> I second this - KISS is better.
>>
>> Would in-band dedupe resolve the issue with losing the "snapshot-awareness
>> of the defrag"? I figure that if someone absolutely wants everything deduped
>> efficiently they'd put in the necessary resources (memory/dedicated SSD/etc)
>> to have in-band dedupe work well.
>>
>>> One question:
>>>
>>> Will option one mean that we always need to mount with noatime or
>>> read-only to allow snapshot defragging to do anything?
>>
>>
>
> When snapshot-aware defrag first came out, I was convinced it was a
> "must-have" capability for nearly everybody using btrfs.  But, the
> more I look at my work load and common practices with btrfs, the more
> I am wondering just how often snapshot-aware defrag was actually doing
> something for me.
>
> I use a lot of snapshots.  But for the most part, once I touch a file
> in my current subvolume, the whole file needs to be COW-ed from it's
> previous version.
>

The whole file doesn't need to be cow'ed, just the part that you touch. 
  So old snapshot-aware defrag probably would have saved you quite a bit 
of space.  Thanks,

Josef
