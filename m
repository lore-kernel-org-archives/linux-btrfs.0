Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:44679 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750922AbaKUNQa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Nov 2014 08:16:30 -0500
Date: Fri, 21 Nov 2014 08:16:24 -0500
From: Chris Mason <clm@fb.com>
Subject: Re: soft lockup - CPU#0 stuck - Kernel 3.17.2
To: Patrick Schmid <schmid@phys.ethz.ch>
CC: <linux-btrfs@vger.kernel.org>
Message-ID: <1416575784.24312.0@mail.thefacebook.com>
In-Reply-To: <546F379F.8000800@phys.ethz.ch>
References: <5464B2DB.7070008@phys.ethz.ch>
	<1415890157.25389.3@mail.thefacebook.com> <54650166.1090800@phys.ethz.ch>
	<1415905935.25389.4@mail.thefacebook.com> <54659FDB.6070300@phys.ethz.ch>
	<1415986775.25389.10@mail.thefacebook.com> <54664884.9010307@phys.ethz.ch>
	<1415989860.25389.11@mail.thefacebook.com>
	<1416008854.25389.12@mail.thefacebook.com> <546F379F.8000800@phys.ethz.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On Fri, Nov 21, 2014 at 8:01 AM, Patrick Schmid <schmid@phys.ethz.ch> 
wrote:
> On 15.11.2014 00:47, Chris Mason wrote:
>> 
>>  Ok, I think this is related to the new fair read/writer lock
>>  implementation in the generic kernel code.  
>> btrfs_clear_path_blocking()
>>  will end up taking locks outside of the strict locking order the 
>> rest
>>  of Btrfs uses.  This used to be fine because we hold the blocking 
>> lock
>>  while we do it, but with the new queued locks we're running into
>>  trouble.  We hit a similar bug earlier and I convinced myself the
>>  problem was only with btrfs_next_leaf and our trylock.  But it's a
>>  bigger problem than I realized.
>> 
>>  So for now I've changed btrfs_clear_path_blocking to honor the rules
>>  and fixed up our trylock to make it faster.
>> 
>>  I'm letting a test run on this patch over the weekend, since I don't
>>  want any surprises with your backup farm.
>> 
>>  -chris
> 
> Hi Chris
> 
> Here comes a short feedback.... I applied your patch (Fix lockups from
> btrfs_clear_path_blocking) yesterday and my system survived this 
> night! ;-)
> 
> Thank you for the quick fix.

Great to hear, thanks for following up.  I'm sending this to Linus for 
the next 3.18 rc.

-chris



