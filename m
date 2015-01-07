Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:45302 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752302AbbAGWGl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 7 Jan 2015 17:06:41 -0500
Message-ID: <54ADADE8.4080507@fb.com>
Date: Wed, 7 Jan 2015 17:06:32 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: <kreijack@inwind.it>, Lennart Poettering <lennart@poettering.net>,
        <linux-btrfs@vger.kernel.org>
Subject: Re: price to pay for nocow file bit?
References: <20150107174315.GA21865@gardel-login> <54AD929E.608@fb.com> <54AD9F85.1010608@inwind.it>
In-Reply-To: <54AD9F85.1010608@inwind.it>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 01/07/2015 04:05 PM, Goffredo Baroncelli wrote:
>>
>>> I am trying to understand the pros and cons of turning this bit
>>> on, before I can make this change. So far I see one big pro, but I
>>> wonder if there's any major con I should think about?
>>>
>>
>> Nope there's no real con other than you don't get csums, but that
>> doesn't really matter for you.  Thanks,
>
> In a btrfs-raid setup, in case of a corrupted sector, is BTRFS able to
> rebuild the sector ?
> I suppose no; if so this has to be add to the cons I think.
>

It won't know its corrupted, but it can rebuild if say you yank a drive 
and add a new one.  RAID5/RAID6 would catch corruption of course.  Thanks,

Josef
