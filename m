Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:34948 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727217AbeGSMaN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Jul 2018 08:30:13 -0400
Received: by mail-it0-f67.google.com with SMTP id q20-v6so8814601ith.0
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Jul 2018 04:47:26 -0700 (PDT)
Subject: Re: [PATCH 0/4] 3- and 4- copy RAID1
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org
References: <cover.1531503452.git.dsterba@suse.com>
 <88531904-288b-f73e-1157-560845f8e72d@gmx.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <e0870bdd-be7d-b91a-e22c-a6b840b8dd64@gmail.com>
Date: Thu, 19 Jul 2018 07:47:23 -0400
MIME-Version: 1.0
In-Reply-To: <88531904-288b-f73e-1157-560845f8e72d@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-07-19 03:27, Qu Wenruo wrote:
> 
> 
> On 2018年07月14日 02:46, David Sterba wrote:
>> Hi,
>>
>> I have some goodies that go into the RAID56 problem, although not
>> implementing all the remaining features, it can be useful independently.
>>
>> This time my hackweek project
>>
>> https://hackweek.suse.com/17/projects/do-something-about-btrfs-and-raid56
>>
>> aimed to implement the fix for the write hole problem but I spent more
>> time with analysis and design of the solution and don't have a working
>> prototype for that yet.
>>
>> This patchset brings a feature that will be used by the raid56 log, the
>> log has to be on the same redundancy level and thus we need a 3-copy
>> replication for raid6. As it was easy to extend to higher replication,
>> I've added a 4-copy replication, that would allow triple copy raid (that
>> does not have a standardized name).
> 
> So this special level will be used for RAID56 for now?
> Or it will also be possible for metadata usage just like current RAID1?
> 
> If the latter, the metadata scrub problem will need to be considered more.
> 
> For more copies RAID1, it's will have higher possibility one or two
> devices missing, and then being scrubbed.
> For metadata scrub, inlined csum can't ensure it's the latest one.
> 
> So for such RAID1 scrub, we need to read out all copies and compare
> their generation to find out the correct copy.
> At least from the changeset, it doesn't look like it's addressed yet.
> 
> And this also reminds me that current scrub is not as flex as balance, I
> really like we could filter block groups to scrub just like balance, and
> do scrub in a block group basis, other than devid basis.
> That's to say, for a block group scrub, we don't really care which
> device we're scrubbing, we just need to ensure all device in this block
> is storing correct data.
> 
This would actually be rather useful for non-parity cases too.  Being 
able to scrub only metadata when the data chunks are using a profile 
that provides no rebuild support would be great for performance.

On the same note, it would be _really_ nice to be able to scrub a subset 
of the volume's directory tree, even if it were only per-subvolume.
