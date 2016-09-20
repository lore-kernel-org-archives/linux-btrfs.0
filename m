Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:41264 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751029AbcITFCx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Sep 2016 01:02:53 -0400
Subject: Re: Post ext3 conversion problems
To: Sean Greenslade <sean@seangreenslade.com>
References: <20160916192459.GA13514@coach.home>
 <CAJCQCtQutt6r2Jovr0jEbTk4W6HUaQpbGiipen97TH1C+k055g@mail.gmail.com>
 <17ca9019-836b-f4f1-f84c-f8c1edcd9925@cn.fujitsu.com>
 <20160919041247.GA32208@coach.home>
 <ae8fd0d5-0d38-aa8e-0114-36ef62b1a783@cn.fujitsu.com>
 <20160919151341.GA1431@coach.home>
 <5f07d365-1eec-7f90-7969-af761834ee48@cn.fujitsu.com>
 <20160920033933.GA13425@coach.home>
CC: Chris Murphy <lists@colorremedies.com>, David Sterba <dsterba@suse.cz>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <fbfb851d-34a7-62df-d24e-0fd5b3a2e5e4@cn.fujitsu.com>
Date: Tue, 20 Sep 2016 13:02:38 +0800
MIME-Version: 1.0
In-Reply-To: <20160920033933.GA13425@coach.home>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 09/20/2016 11:39 AM, Sean Greenslade wrote:
> On Tue, Sep 20, 2016 at 10:49:42AM +0800, Qu Wenruo wrote:
>> OK, I see the problem now.
>>
>> The new convert is designed to create minimal number of extents, so it
>> result the following file extents layout:
>>
>> Ext2_save/image
>>         |
>> /-------------------------------\
>> |           Extent A             |
>> |<---Old Ext3 Used space  ------>|<--- Free space--->|
>>       \---/\---/\---/
>>         |    |    |
>>        F1    F2   F3
>>
>> This causes a large extent A, refered by ext2_save/image, and files like
>> F1/2/3 just refer to part of the large extent A.
>>
>> After removing the whole ext2_save subvolume, Extent A is still there, since
>> F1/2/3 are still referring it.
>>
>> |<---Old Ext3 Used space  ------>|<--- Free space--->|
>> |           Extent A             |
>>       \---/\---/\---/
>>         |    |    |
>>        F1    F2   F3
>>
>>
>>
>> In that case, not balance but defrag is responsible to "split" the large
>> extent and free the unused space.
>>
>> However btrfs defrag doesn't work for case like subvolume or reflink for a
>> long time, which leaves the extent layout unchanged.
>> And balance doesn't handle it, as balance just relocated the large extent A
>> and modify all referencers' pointer.
>>
>> Sigh, I just forgot the fact that defrag doesn't work for a long time when
>> designing the new convert.
>>
>> So, we still need a working kernel defrag to make the fs to  be a "native"
>> btrfs.
>>
>>
>> However, such layout is completely valid for btrfs, one can generate it
>> quite easily which following script:
>> ----
>> xfs_io -f -c "pwrite 0 16M" $mnt/orig
>> for i in $(seq 0 15); do
>> 	xfs_io -f -c "reflink $mnt/orig ${i}M 0 1M" $mnt/file${i}
>> done
>> ----
>>
>> So there is still something wrong in your backtrace so that we need to dig
>> further.
>>
>> Any idea of your load pattern to trigger the bug?
>
> Glad to hear you've found the core of the issue.
>
> At this point, I can trigger it immediately. As soon as I log in and run
> dmenu, it will attempt to rebuild its cache file (small text file that's
> just a list of all executables in the PATH). Once that write happens,
> the bug triggers and the fs goes read only.

Rewrite? Or write into new inode?

And is the same inode always causing the problem?

Thanks,
Qu

>
> --Sean
>
>
>


