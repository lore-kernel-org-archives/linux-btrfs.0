Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:14252 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751888AbcITCts (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Sep 2016 22:49:48 -0400
Subject: Re: Post ext3 conversion problems
To: Sean Greenslade <sean@seangreenslade.com>
References: <20160916192459.GA13514@coach.home>
 <CAJCQCtQutt6r2Jovr0jEbTk4W6HUaQpbGiipen97TH1C+k055g@mail.gmail.com>
 <17ca9019-836b-f4f1-f84c-f8c1edcd9925@cn.fujitsu.com>
 <20160919041247.GA32208@coach.home>
 <ae8fd0d5-0d38-aa8e-0114-36ef62b1a783@cn.fujitsu.com>
 <20160919151341.GA1431@coach.home>
CC: Chris Murphy <lists@colorremedies.com>, David Sterba <dsterba@suse.cz>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <5f07d365-1eec-7f90-7969-af761834ee48@cn.fujitsu.com>
Date: Tue, 20 Sep 2016 10:49:42 +0800
MIME-Version: 1.0
In-Reply-To: <20160919151341.GA1431@coach.home>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 09/19/2016 11:13 PM, Sean Greenslade wrote:
> On Mon, Sep 19, 2016 at 02:30:28PM +0800, Qu Wenruo wrote:
>> All chunks are completed convert to DUP, no small chunk, all to its maximum
>> chunk size.
>> So from chunk level, nothing related to convert yet.
>>
>> But for extent tree, I found several extents are heavily referred to.
>> Like extent 158173081600 or 183996522496.
>>
>> If you're not using off-band dedupe, then it's quite possible that's the
>> remaining structure of convert.
>
> I never ran any sort of dedup on this partition.
>
>> Not pretty sure if it's related to the bug, but did you do the
>> balance/defrag operation just after removing ext_save subvolume?
>
> That's quite possible. I did it in a live boot, so I don't have the bash
> history to check. I checked it just now using "btrfs subvol list -d",
> and there's nothing listed. I ran a full balance after that, but the
> problem remains. So whatever the problem is, it can survive a full
> balance after the ext_save subvol is completely deleted.
>
> --Sean
>
>
OK, I see the problem now.

The new convert is designed to create minimal number of extents, so it 
result the following file extents layout:

Ext2_save/image
         |
/-------------------------------\
|           Extent A             |
|<---Old Ext3 Used space  ------>|<--- Free space--->|
       \---/\---/\---/
         |    |    |
        F1    F2   F3

This causes a large extent A, refered by ext2_save/image, and files like 
F1/2/3 just refer to part of the large extent A.

After removing the whole ext2_save subvolume, Extent A is still there, 
since F1/2/3 are still referring it.

|<---Old Ext3 Used space  ------>|<--- Free space--->|
|           Extent A             |
       \---/\---/\---/
         |    |    |
        F1    F2   F3



In that case, not balance but defrag is responsible to "split" the large 
extent and free the unused space.

However btrfs defrag doesn't work for case like subvolume or reflink for 
a long time, which leaves the extent layout unchanged.
And balance doesn't handle it, as balance just relocated the large 
extent A and modify all referencers' pointer.

Sigh, I just forgot the fact that defrag doesn't work for a long time 
when designing the new convert.

So, we still need a working kernel defrag to make the fs to  be a 
"native" btrfs.


However, such layout is completely valid for btrfs, one can generate it 
quite easily which following script:
----
xfs_io -f -c "pwrite 0 16M" $mnt/orig
for i in $(seq 0 15); do
	xfs_io -f -c "reflink $mnt/orig ${i}M 0 1M" $mnt/file${i}
done
----

So there is still something wrong in your backtrace so that we need to 
dig further.

Any idea of your load pattern to trigger the bug?

Thanks,
Qu


