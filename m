Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:54195 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752417AbaFRP07 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Jun 2014 11:26:59 -0400
Message-ID: <53A1AFB6.40906@fb.com>
Date: Wed, 18 Jun 2014 08:26:46 -0700
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Marc MERLIN <marc@merlins.org>
CC: <linux-btrfs@vger.kernel.org>, Chris Mason <clm@fb.com>,
        <takeuchi_satoru@jp.fujitsu.com>
Subject: Re: btrfs balance crash BUG ON fs/btrfs/relocation.c:1062 or RIP
 build_backref_tree+0x9fc/0xcc4
References: <20140609234007.GD19071@merlins.org> <53A08925.8020700@fb.com> <20140617185549.GP19071@merlins.org>
In-Reply-To: <20140617185549.GP19071@merlins.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 06/17/2014 11:55 AM, Marc MERLIN wrote:
> On Tue, Jun 17, 2014 at 11:29:57AM -0700, Josef Bacik wrote:
>>> I'm sure that filesystem is damaged in some way, but the kernel of course
>>> should not crash.
>>>
>>
>> I don't have this mail client setup right to send patches, can you just
>> go into relocation.c in build_backref_tree and remove the need_check =
>> false; statement and see if that fixes it.  Thanks,
>
> Sure, I'll try that tomorrow when I have access to that machine.
>
> Just to be clear
> 1) You mean this one, right?
> 				if (!upper->checked && need_check) {
> 					need_check = false;   <-- delete this
> 					list_add_tail(&edge->list[UPPER],
> 						      &list);
> 				} else
>

Yup that one.

> 2) is your guess that the BUG_ON I'm getting shouldn't be triggered
> and your proposed patch could fix that, or that I do have an FS problem
> but that we're just going to make the kernel more lenient and not crash on it?
>

All of these BUG_ON(!uppper->checked) are logic errors, not problems 
with the fs, which is why I haven't turned them into an abort or 
something else yet.  I'm thinking about chucking this whole function 
anyway and using the backref walking code, but that is going to be a job 
for future josef, present josef doesn't seem to have any time to do 
anything despite sleeping a lot less.  Thanks,

Josef
