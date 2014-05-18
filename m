Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fw12a-lucinda.wadns.net ([196.220.39.179]:2763 "EHLO
	fw12a.wadns.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751326AbaERSuG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 18 May 2014 14:50:06 -0400
Message-ID: <537900D1.6060802@swiftspirit.co.za>
Date: Sun, 18 May 2014 20:49:53 +0200
From: Brendan Hide <brendan@swiftspirit.co.za>
MIME-Version: 1.0
To: Austin S Hemmelgarn <ahferroin7@gmail.com>,
        Tomasz Chmielewski <tch@virtall.com>,
        Calvin Walton <calvin.walton@kepstin.ca>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: RAID-1 - suboptimal write performance?
References: <20140516164815.1c33149b@s9>	<1400263584.979.17.camel@sasami.ottawa.blindsidenetworks.com> <20140516214135.23fefc39@s9> <537684F9.6060909@gmail.com>
In-Reply-To: <537684F9.6060909@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014/05/16 11:36 PM, Austin S Hemmelgarn wrote:
> On 05/16/2014 04:41 PM, Tomasz Chmielewski wrote:
>> On Fri, 16 May 2014 14:06:24 -0400
>> Calvin Walton <calvin.walton@kepstin.ca> wrote:
>>
>>> No comment on the performance issue, other than to say that I've seen
>>> similar on RAID-10 before, I think.
>>>
>>>> Also, what happens when the system crashes, and one drive has
>>>> several hundred megabytes data more than the other one?
>>> This shouldn't be an issue as long as you occasionally run a scrub or
>>> balance. The scrub should find it and fix the missing data, and a
>>> balance would just rewrite it as proper RAID-1 as a matter of course.
>> It's similar (writes to just one drive, while the other is idle) when
>> removing (many) snapshots.
>>
>> Not sure if that's optimal behaviour.
>>
> [snip]
>
> Ideally, BTRFS should dispatch the first write for a block in a
> round-robin fashion among available devices.  This won't fix the
> underlying issue, but it will make it less of an issue for BTRFS.
>

More ideally, btrfs should dispatch them in parallel. This will likely 
be looked into for N-way mirroring. Having 3 or more copies and working 
in the current way would be far from optimal.



-- 
__________
Brendan Hide
http://swiftspirit.co.za/
http://www.webafrica.co.za/?AFF1E97

