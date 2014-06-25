Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:6483 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755941AbaFYVGD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Jun 2014 17:06:03 -0400
Message-ID: <53AB399D.5000701@fb.com>
Date: Wed, 25 Jun 2014 14:05:33 -0700
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Marc MERLIN <marc@merlins.org>
CC: <linux-btrfs@vger.kernel.org>, Chris Mason <clm@fb.com>,
        <takeuchi_satoru@jp.fujitsu.com>
Subject: Re: btrfs balance crash BUG ON fs/btrfs/relocation.c:1062 or RIP
 build_backref_tree+0x9fc/0xcc4
References: <20140609234007.GD19071@merlins.org> <53A08925.8020700@fb.com> <20140617185549.GP19071@merlins.org> <53A1AFB6.40906@fb.com> <20140618202135.GE19071@merlins.org> <53A30BDD.6080309@fb.com> <20140619222518.GA20894@merlins.org> <53A36928.1030104@fb.com> <20140620005359.GA10485@merlins.org> <53A45601.9070305@fb.com> <20140625194034.GC18416@merlins.org>
In-Reply-To: <20140625194034.GC18416@merlins.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/25/2014 12:40 PM, Marc MERLIN wrote:
> On Fri, Jun 20, 2014 at 08:40:49AM -0700, Josef Bacik wrote:
>> On 06/19/2014 05:53 PM, Marc MERLIN wrote:
>>> On Thu, Jun 19, 2014 at 03:50:16PM -0700, Josef Bacik wrote:
>>>> Ok same drill as before, reset and apply this, hopefully no panic this
>>>> time
>>>>
>>>>
>>>> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
>>>> index 65245a0..bca5240 100644
>>>
>>
>> Ok I see what it is but I want to get rid of the panicing so we're going
>> to do this dance a few more times until it's just failing to mount instead
>> of panicing, and then we'll fix the actual bug.  Give this a whirl, and
>> I've added another printk just to make sure what I think is happening is
>> actually what's happening, so same drill as before.  Thanks,
>
> Patch applied. The panic moved :)
>

Is it possible for me to get a btrfs-image of this fs?  That would make this a
lot faster.  Thanks,

Josef
