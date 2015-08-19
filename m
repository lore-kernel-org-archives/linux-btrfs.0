Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f179.google.com ([209.85.160.179]:32970 "EHLO
	mail-yk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978AbbHSRYL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Aug 2015 13:24:11 -0400
Received: by ykll84 with SMTP id l84so12090911ykl.0
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Aug 2015 10:24:10 -0700 (PDT)
From: Tyler Bletsch <tyler.bletsch@gmail.com>
Subject: Re: Btrfs is amazing! (a lack-of-bug report)
To: Austin S Hemmelgarn <ahferroin7@gmail.com>, linux-btrfs@vger.kernel.org
References: <55D1567B.3030809@gmail.com> <55D1CA1E.1060103@gmail.com>
 <55D23397.6090404@gmail.com> <55D31A3C.3080208@gmail.com>
Message-ID: <55D4BBBB.9000008@gmail.com>
Date: Wed, 19 Aug 2015 13:24:11 -0400
MIME-Version: 1.0
In-Reply-To: <55D31A3C.3080208@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks.  I'd consider raid6, but since I'll be backing up to a second 
btrfs raid5 array, I think I have sufficient redundancy, since 
equivalent to raid 5+1 on paper. I'm doing that rather than something 
like raid10 in a single box because I want the redundancy of a second 
physical server so I can failover in the event of a system-level 
component failure.

(And of course, "failover" means "continue being able to watch TV shows 
and stuff")

A question about what you said -- when you say people have hit bugs in 
the raid56 code, which flavor do these bugs tend to be? Are they 
"minding my own business and suddenly it falls over" bugs or "I tried to 
do something weird with btrfs and it screwed up" bugs?

Thanks,
Tyler

On 8/18/2015 7:42 AM, Austin S Hemmelgarn wrote:
> On 2015-08-17 15:18, Tyler Bletsch wrote:
>> Thanks. I will be trying raid5 in production, but "production" in this
>> case just means my home file server, with btrfs snapshot+sync for all
>> data and appropriate offsite non-btrfs backups for critical data. If it
>> hoses up, I'll post a bug report.
> So far, that's been my use case for btrfs raid6, and (barring one bug 
> I found involving an interaction between btrfs and thinly provisioned 
> storage that shouldn't be an issue for you if you're not using LVM 
> thin pools) I have yet to hit any bugs, although based on the lists, 
> I've probably been _very_ lucky in that respect.  If you're willing to 
> take a marginal performance hit (about 1-3% in my experience, which is 
> notably less than the performance difference between MD-RAID5 and 
> MD-RAID6), and have at least four disks, I'd suggest using btrfs's 
> raid6 profile instead of raid5, they use exactly the same code, it's 
> just that raid6 has one more calculation involved and provides better 
> protection against data corruption due to the double parity.
>>
>> Going to try to avoid LVM, since half the appeal of btrfs for me is
>> getting away from the multiple duct-taped layers of indirection that I
>> you get currently with ext4/MD/LVM setups.
> Understandable, my main reasons for having LVM are storing virtual 
> machine disk images and the fact that MD/DM raid is still ridiculously 
> fast compared to btrfs raid (many of my btrfs raid volumes are 
> themselves on top of LVM managed software raid0 or raid1 volumes).
>
>

