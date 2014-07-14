Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:29511 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756963AbaGNUMi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Jul 2014 16:12:38 -0400
Message-ID: <53C439A6.5010905@fb.com>
Date: Mon, 14 Jul 2014 16:12:22 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Martin Steigerwald <Martin@lichtvoll.de>, <linux-btrfs@vger.kernel.org>
Subject: Re: BTRFS hang with 3.16-rc5
References: <1502954.OtX3SzjMKZ@merkaba> <3226395.MP6iD3ZiSL@merkaba>
In-Reply-To: <3226395.MP6iD3ZiSL@merkaba>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/14/2014 11:10 AM, Martin Steigerwald wrote:
> Am Montag, 14. Juli 2014, 17:04:22 schrieben Sie:
>> Hi!
>>
>> While with 3.16-rc3 and rc4 I didn´t have a BTRFS hang in several days of
>> usage, with 3-16-rc5 I had a hang again. Less than a hour since booting it.
>>
>> Since the hang bug I and others had with 3.15 and upto 3.16-rc2 usually
>> didn´t happen that quickly after boot and since backtrace looks a bit
>> different from what I have in memory, I post this in a new thread.
>> See thread "Blocked tasks on 3.15.1" for a discussion of previous hang
>> issues.
> 
> Probably good to add some basic information on the filesystem:
> 
Do you have compression enabled?  I wasn't able to nail down the 3.15.1
hang before vacation attacked me, but I'm hoping to track it down today.

-chris
