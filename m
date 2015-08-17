Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f176.google.com ([209.85.220.176]:35942 "EHLO
	mail-qk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923AbbHQTSu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Aug 2015 15:18:50 -0400
Received: by qkdv3 with SMTP id v3so50047378qkd.3
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Aug 2015 12:18:49 -0700 (PDT)
From: Tyler Bletsch <tyler.bletsch@gmail.com>
Subject: Re: Btrfs is amazing! (a lack-of-bug report)
To: Austin S Hemmelgarn <ahferroin7@gmail.com>, linux-btrfs@vger.kernel.org
References: <55D1567B.3030809@gmail.com> <55D1CA1E.1060103@gmail.com>
Message-ID: <55D23397.6090404@gmail.com>
Date: Mon, 17 Aug 2015 15:18:47 -0400
MIME-Version: 1.0
In-Reply-To: <55D1CA1E.1060103@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks. I will be trying raid5 in production, but "production" in this 
case just means my home file server, with btrfs snapshot+sync for all 
data and appropriate offsite non-btrfs backups for critical data. If it 
hoses up, I'll post a bug report.

Going to try to avoid LVM, since half the appeal of btrfs for me is 
getting away from the multiple duct-taped layers of indirection that I 
you get currently with ext4/MD/LVM setups.

- Tyler

On 8/17/2015 7:48 AM, Austin S Hemmelgarn wrote:
> On 2015-08-16 23:35, Tyler Bletsch wrote:
>> I just wanted to drop you guys a line to say that I am stunned with how
>> excellent btrfs is. I did some testing, and the things that it did were
>> amazing. I took a 4-disk RAID 5 and walked it all the way down to a
>> one-disk volume and back again, mixed in devices of different sizes in
>> different modes, balanced it in every direction, trashed data on drives
>> without the OS knowing, and did every other form of torture I could
>> think of, all while looping file integrity tests, and it was perfect.
>>
>> The ease of use and simplicity were great.  I was dreading having to
>> administer ZFS in order to get snapshots and other features, but now I
>> don't have to. With the exception of enterprisey features like SSD
>> intent logs and stuff, it is hands down far better than ZFS.
>>
>> Thanks for the great work!
>>
> It's nice to hear success stories for once.  I would suggest being 
> careful of using BTRFS raid5 or raid6 in production, there are 
> probably still bugs that haven't yet been discovered. Secondarily, if 
> you can deal with slightly more setup and maintenance overhead, BTRFS 
> works _very_ well on top of LVM (it makes online data migration much 
> easier, and provides easy ways to do layered RAID setups).
>
>

