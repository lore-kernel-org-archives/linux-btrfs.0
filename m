Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f182.google.com ([209.85.220.182]:59980 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759420AbaCUAAH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Mar 2014 20:00:07 -0400
Received: by mail-vc0-f182.google.com with SMTP id ks9so1871434vcb.27
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Mar 2014 17:00:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <532B7FEE.5090708@fb.com>
References: <20131125214534.8160.40797@ret.masoncoding.com>
	<CALOYprVH7pGuAR2OHvyGVfa9FKW-_5yMT-h=BAm_G8ejEOHboQ@mail.gmail.com>
	<532B7FEE.5090708@fb.com>
Date: Fri, 21 Mar 2014 00:00:06 +0000
Message-ID: <CALOYprWEhUTEck-0KYEvJ7zRQ2UQkMhT8Mh4+FPXT6GWGUY9Yg@mail.gmail.com>
Subject: Re: btrfs-progs tagged as v3.12
From: WorMzy Tykashi <wormzy.tykashi@gmail.com>
To: Chris Mason <clm@fb.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 20 March 2014 23:55, Chris Mason <clm@fb.com> wrote:
> On 03/20/2014 07:36 PM, WorMzy Tykashi wrote:
>>
>> On 25 November 2013 21:45, Chris Mason <chris.mason@fusionio.com> wrote:
>>>
>>> Hi everyone,
>>>
>>> I've tagged the current btrfs-progs repo as v3.12.  The new idea is that
>>> instead of making the poor distros pull from git, I'll be creating
>>> tagged releases at roughly the same pace as Linus cuts kernels.
>>>
>>> Given the volume of btrfs-progs patches, we should have enough new code
>>> and fixes to justify releases at least as often as the kernel.  Of
>>> course, if there are issues that need immediate attention, I'll tag a .y
>>> release (v3.12.1 for example).
>>>
>>> If the progs changes slow down, we might skip a version.  But tracking
>>> kernel version numbers makes it easier for me to line up bug reports,
>>> mostly because I already devote a fair number of brain cells to
>>> remembering how old each kernel is.
>>>
>>> Just let me know if there are any questions.
>>>
>>> -chris
>>
>>
>> Hi Chris,
>>
>> I don't know if there wasn't enough commits to justify a 3.13 release
>> (I noticed your integration branch stalled 7 weeks ago, so I assume
>> this is the case), but can we expect a 3.14 release shortly after
>> Linus tags the mainline kernel as such?
>>
>
> Yes, I'm redoing the integration branch off of Dave's latest, and started
> testing it earlier this week.  We'll definitely have a 3.14.
>
> Thanks,
> Chris

That's excellent news, thanks for the quick reply!

Cheers,


WorMzy
