Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:62093 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751037AbcFYBXI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Jun 2016 21:23:08 -0400
Subject: Re: [PATCH v11 00/13] Btrfs dedupe framework
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
References: <20160615021001.9588-1-quwenruo@cn.fujitsu.com>
 <20160623121738.GZ4915@twin.jikos.cz>
 <023d6b07-2326-bc48-188e-21ff8a442304@cn.fujitsu.com>
 <2530830.B25feXa6fV@reserved-192-168-1-6.rchland.ibm.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <fe84125c-12e6-3425-7948-73819a891e77@gmx.com>
Date: Sat, 25 Jun 2016 09:22:44 +0800
MIME-Version: 1.0
In-Reply-To: <2530830.B25feXa6fV@reserved-192-168-1-6.rchland.ibm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 06/24/2016 05:29 PM, Chandan Rajendra wrote:
> On Friday, June 24, 2016 10:50:41 AM Qu Wenruo wrote:
>> Hi Chandan, David,
>>
>> When I'm trying to rebase dedupe patchset on top of Chadan's sub page
>> size patchset (using David's for-next-test-20160620), although the
>> rebase itself is quite simple, but I'm afraid that I found some bugs for
>> sub page size patchset, *without* dedupe patchset applied.
>>
>> These bugs seems to be unrelated to each other
>> 1) state leak at btrfs rmmod time
>
> The leak was due to not freeing 'cached_state' in
> read_extent_buffer_pages(). I have fixed this and the fix will be part of the
> patchset when I post the next version to the mailing list.
>
> I have always compiled the btrfs code as part of the vmlinux image and hence
> have never rmmod the btrfs module during my local testing. The space leak
> messages might have appeared when I shut down my guest. Hence I had never
> noticed them before. Thanks once again for informing me about it.
>
>> 2) bytes_may_use leak at qgroup EDQUOTA error time
>
> I have a slightly older version of btrfs-progs which does not yet have btrfs
> dedupe" command. I will get the new version and check if the space leak can be
> reproduced on my machine.
>
> However, I don't see the space leak warning messages when the reproducer
> script is executed after commenting out "btrfs dedupe enable $mnt".

Strange.
That dedupe command is not useful at all, as I'm using the branch 
without the dedupe patchset.
Even with btrfs-progs dedupe patchset, dedupe enable only output ENOTTY 
error message.

I'll double check if it's related to the dedupe.

BTW, are you testing with 4K page size?

Thanks,
Qu
>
>> 3) selftest is run several times at modules load time
>>     15 times, to be more exact
>>     And since I didn't found any immediate number related to run it 15
>>     times, I assume at least it's not designed to do it 15 times.
>>
>> The reproducer for 1) and 2) is quite simple, extracted from btrfs/022
>> test case:
>> ------
>> dev=/dev/sdb5
>> mnt=/mnt/test
>>
>> umount $dev &> /dev/null
>>
>> mkfs.btrfs $dev -f
>> mount $dev $mnt -o nospace_cache
>> btrfs dedupe enable $mnt
>> btrfs sub create $mnt/sub
>> btrfs quota enable $mnt
>>
>>
>> # Just use small limit, making ftrace less noise.
>> btrfs qgroup limit 512K 0/257 $mnt
>> dd if=/dev/urandom of=$mnt/sub/test bs=1M count=1
>> umount $mnt
>> rmmod btrfs
>> ------
>>
>> At unmount time, kernel warning will happen due to may_use bytes leak.
>> I could dig it further, as it looks like a bug in space reservation
>> failure case.
>> ------
>> BTRFS: space_info 1 has 8044544 free, is not full
>> BTRFS: space_info total=8388608, used=344064, pinned=0, reserved=0,
>> may_use=409600, readonly=0
>> ------
>>
>> And at rmmod time, btrfs will detect extent_state leak, whose length is
>> always 4095 (page size - 1).
>>
>> Hope this will help, and I'm willing to help to fix the problem.
>>
>> Thanks,
>> Qu
>>
>> At 06/23/2016 08:17 PM, David Sterba wrote:
>>> On Tue, Jun 21, 2016 at 10:25:19PM +0530, Chandan Rajendra wrote:
>>>>>> I'm completely OK to do the rebase, but since I don't have 64K page size
>>>>>> machine to test the rebase, we can only test if 4K system is unaffected.
>>>>>>
>>>>>> Although not much help, at least it would be better than making it compile.
>>>>>>
>>>>>> Also such rebase may help us to expose bad design/unexpected corner case
>>>>>> in dedupe.
>>>>>> So if it's OK, please let me try to do the rebase.
>>>>>
>>>>> Well, if you base dedupe on subpage, then it could be hard to find the
>>>>> patchset that introduces bugs, or combination of both. We should be able
>>>>> to test the features independently, and thus I'm proposing to first find
>>>>> some common patchset that makes that possible.
>>>>
>>>> I am not sure if I understood the above statement correctly. Do you mean to
>>>> commit the 'common/simple' patches from both the subpage-blocksize & dedupe
>>>> patchset first and then bring in the complicated ones later?
>>>
>>> That would be great yes, but ...
>>>
>>>> If yes, then we have a problem doing that w.r.t subpage-blocksize
>>>> patchset. The first few patches bring in the core changes necessary for the
>>>> other remaining patches.
>>>
>>> ... not easily possible. I looked again for common functions that change
>>> the singature and found only cow_file_range and run_delalloc_nocow. The
>>> plan:
>>>
>>> - separate patch that adds new parameters required by both patches to
>>>   the functions
>>> - update all call sites, add 0/NULL as defaults for the new unused
>>>   parameters
>>> - rebase both patches on top of this patch
>>>
>>> How does this help: if a patch starts to use the new parameter, it
>>> changes only the value at all call sites. This is much easier to verify
>>> and merge manually compared to adding a new parameter to the middle of
>>> the list, namely when the functions take 6+.
>>>
>>> The other conflicts like conversion from PAGE_SIZE to the the block
>>> oriented iterations will be harder, but these are usually localized and
>>> can be resolved. We'll see if there are other options to reduce the
>>> clashes but at the moment it's stuck at the two functions. Does that
>>> explain it better?
>>>
>>>
>>
>>
>
