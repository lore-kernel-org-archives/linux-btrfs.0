Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:55756 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S932857AbdACGLs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Jan 2017 01:11:48 -0500
Subject: Re: How to recover a filesystem without formatting nor using the
 btrfs check command.
To: none <ytrezq@sdf-eu.org>
References: <580944C7.103@sdf-eu.org>
 <8c5ae48c-4af6-42d9-be0f-06d232764ff2@cn.fujitsu.com>
 <36f56365-27ac-878e-c5fb-f414646eda3a@sdf-eu.org>
 <61df188a-bc12-c9c4-0322-766df4fb18c0@cn.fujitsu.com>
 <a8b030a4fab174ade203bf061151f270@mx.sdfeu.org>
 <08227414-b241-28a5-bbc6-7fb21d4b3e62@cn.fujitsu.com>
 <7dcfffa62234ff0fa5ae060f75df25f1@mx.sdfeu.org>
 <2166adfe-88af-5d9a-295f-d7002d64ed0e@cn.fujitsu.com>
 <866efefad9d62f7f00c117edc4715651@mx.sdfeu.org>
CC: <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <24b88326-e44b-adc6-044d-ae678316f9a6@cn.fujitsu.com>
Date: Tue, 3 Jan 2017 14:11:36 +0800
MIME-Version: 1.0
In-Reply-To: <866efefad9d62f7f00c117edc4715651@mx.sdfeu.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

At 01/02/2017 07:29 AM, none wrote:
> Le 2016-10-27 03:11, Qu Wenruo a écrit :
>> At 10/26/2016 07:52 PM, none wrote:
>>> Le 2016-10-26 03:43, Qu Wenruo a écrit :
>>>> Unfortunately, low memory mode is right here.
>>>>
>>>> If btrfs-image dump the image correctly, your extent tree is really
>>>> screwed up.
>>>>
>>>> And how badly it is screwed up?
>>>> It only contains the basic block group info.
>>>> Almost empty, without any really useful EXTENT_ITEM/METADATA_ITEM.
>>>> You can check it by btrfs-debug-tree -t extent.
>>>> Normally, one EXTENT_DATA or tree block should have corresponding
>>>> EXTENT_ITEM or METADATA_ITEM in extent tree.
>>>>
>>>> But in your dump, I only find EXTENT_ITEM less than a dozen, which is
>>>> totally abnormal for the used size of your fs.
>>> Please note df -h report 55Gb used due to a very high compression ratio.
>>> Basically most of the theoretical used space is done by less than 100
>>> files. I want to delete them
>>>> That's why lowmem mode is reporting so many backref lost.
>>> Whithout the lowmem mode, only 3 lines are reported :
>>>
>>> Failed to find [75191291904, 168, 4096]
>>> btrfs unable to find ref byte nr 75191291904 parent 0 root 1  owner 1
>>> offset 0
>>> Failed to find [75191316480, 168, 4096]
>>> btrfs unable to find ref byte nr 75191316480 parent 0 root 1  owner 0
>>> offset 1
>>> parent transid verify failed on 75191349248 wanted 3555361 found 3555362
>>> Ignoring transid failure
>>>
>>> and then it’s cpu locked.
>>
>> It's the dead loop make btrfsck only able to check the first several
>> extents, no method to continue.
>>
>> If we solve the dead loop, then there won't be less error report from
>> original btrfsck.
>> (lowmem mode just avoid the possibility to dead loop by its design)
>>
>>>
>>>> It's almost a miracle that you can still write data into the fs.
>>>> And I heavily doubt the correctness of your existing files.
>>> They are definitely correct. I have several root filesystem and I can
>>> chroot to all of them (though I’m mounting the partition readonly in
>>> order to avoid dangerous writes in that case). In each case I tried
>>> python and ruby cgi scripts.
>>
>> You should check more, normally scrub will help, but considering the
>> state of btrfs, scrub may not work at all or make things worse.
>>
>>>> As extent tree is screwed up, it's completely possible new write are
>>>> overwriting existing data.
>>> Though I only attempted to write to 3 files. But yes, this was something
>>> I suspected : that writing damage things.
>>>> The only chance seems to be --init-extent-tree, but that's very
>>>> dangerous and I highly suspect the screwed up extent tree is caused by
>>>> interrupted extent tree rebuild.
>>> The problem is --init-extent-tree implies --repair which discard
>>> --mode=lowmem and cause the dead lock :
>>> https://bugzilla.kernel.org/show_bug.cgi?id=178781
>>
>> Yes, that's the problem, and current situation may be caused by
>> interrupted extent tree rebuild.
>>
>>>> Thanks,
>>>> Qu
>>>>
>>> And finally, I found several corrupt directories yesterday.
>>>
>>> Do you mean it’s impossible to rescue anything by repairing ? (this is
>>> something I doubt since most files are valid)
>>
>> Not completely, I'm digging into the dead loop problem, and after that
>> you may still recover the fs(or part of it) using --init-extent-tree.
>>
>> Thanks,
>> Qu
>>
>>>
>>> Thank you.
>
> Hello, what’s the status of my report since last October ?
>
> thanks,
>
>
Sorry for the late reply.

I tried your image but...
It's so slow, no matter the mode I'm using.

So I'm not sure if it's a deadlock since lowmem mode still takes several 
minuts and just output the same output.

The fs contains SOOOOOOOOO many reflinks and I can hardly determine if 
it's normal or deadlock.


Considering btrfs check original mode is using list to iteration 
backrefs, it can be very very slow, maybe O(n^3)~O(n^4).

And considering the number of reflinks, it can be longer than your 
assumption (maybe longer than 48 hours).

Just try xfstests generic/175, and see how slow btrfs check is.


And since your fs tree is super big, normal btrfs-debug-tree output will 
be over several GBs for debugging, this also makes things quite nasty to 
debug manually.

IMHO we only have 2 remaining methods to fix your fs:
1) Rework current backref structure.
    Use rb-tree other than list to iteration.
2) Introduce --init-extent-tree in lowmem mode.

Neither way it's a quick fix.
And I'm trying to implement the 2nd method first, but it may takes a lot 
of time.
(I still have a lot of other btrfs development to do, sorry)

I'd suggest you to rebuild the fs, considering the time we need to fix it.

Thanks,
Qu


