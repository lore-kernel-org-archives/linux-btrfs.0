Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:22382 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754071AbcISGah (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Sep 2016 02:30:37 -0400
Subject: Re: Post ext3 conversion problems
To: Sean Greenslade <sean@seangreenslade.com>
References: <20160916192459.GA13514@coach.home>
 <CAJCQCtQutt6r2Jovr0jEbTk4W6HUaQpbGiipen97TH1C+k055g@mail.gmail.com>
 <17ca9019-836b-f4f1-f84c-f8c1edcd9925@cn.fujitsu.com>
 <20160919041247.GA32208@coach.home>
CC: Chris Murphy <lists@colorremedies.com>, David Sterba <dsterba@suse.cz>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <ae8fd0d5-0d38-aa8e-0114-36ef62b1a783@cn.fujitsu.com>
Date: Mon, 19 Sep 2016 14:30:28 +0800
MIME-Version: 1.0
In-Reply-To: <20160919041247.GA32208@coach.home>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 09/19/2016 12:12 PM, Sean Greenslade wrote:
> On Mon, Sep 19, 2016 at 10:20:37AM +0800, Qu Wenruo wrote:
>> <snip>
>> -95 is -EOPNOTSUPP.
>>
>> Not a common errno in btrfs.
>>
>> Most EOPNOTSUPP are related to discard and crapped fallcate/drop extents.
>>
>> Then are you using discard mount option?
>
> I did indeed have the discard mount option enabled. I tried booting with
> discard disabled, but the same problem appeared.
>
>> <snip>
>> Normally a btrfs-debug-tree would help in most case, but this time it seems
>> to be a runtime scrub bug other than on-disk metadata corruption.
>>
>> What I can see here is, with all your operation, your fs should be a normal
>> btrfs, other than converted one.
>>
>> To confirm my idea, would you please upload the following things if your
>> filesystem is not too large?
>>
>> # btrfs-debug-tree -t extent <your device>
>> # btrfs-debug-tree -t chunk <your device>
>> # btrfs-debug-tree -t dev <your device>
>>
>> There is no file/dir name/data contained in the dump. So it's just
>> chunk/extent allocation info.
>> You could upload them at ease.
>>
>>> Not a mess, I think it's a good bug report. I think Qu and David know
>>> more about the latest iteration of the convert code. If you can wait
>>> until next week at least to see if they have questions that'd be best.
>>> If you need to get access to the computer sooner than later I suggest
>>> btrfs-image -c9 -t4 -s to make a filename sanitized copy of the
>>> filesystem metadata for them to look at, just in case. They might be
>>> able to figure out the problem just from the stack trace, but better
>>> to have the image before blowing away the file system, just in case
>>> they want it.
>>
>> Yes, btrfs-image dump would be the best.
>> Although sanitizing may takes a long time and the output may be too large.
>
> I had posted a btrfs-image before. It was run with a single -s flag:
>
> http://phead.us/tmp/sgreenslade_home_sanitized_2016-09-16.btrfs
>
> Here's the debug tree data:
>
> http://phead.us/tmp/wheatley_chunk_2016-09-18.dump.gz
> http://phead.us/tmp/wheatley_extent_2016-09-18.dump.gz
> http://phead.us/tmp/wheatley_dev_2016-09-18.dump.gz
>
> Thanks,
>
> --Sean
>

All chunks are completed convert to DUP, no small chunk, all to its 
maximum chunk size.
So from chunk level, nothing related to convert yet.

But for extent tree, I found several extents are heavily referred to.
Like extent 158173081600 or 183996522496.

If you're not using off-band dedupe, then it's quite possible that's the 
remaining structure of convert.

Not pretty sure if it's related to the bug, but did you do the 
balance/defrag operation just after removing ext_save subvolume?

If so, maybe the subvolume is not fully freed up and later 
balance/defrag just keeps the old convert extent layout.

IIRC to ensure btrfs completely free a subvolume, one needs to call 
"btrfs filesystem sync <mnt>" to ensure the subvolume is completely deleted.

Thanks,
Qu

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


