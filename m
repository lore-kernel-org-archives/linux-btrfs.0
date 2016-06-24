Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:14606 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751211AbcFXCuu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Jun 2016 22:50:50 -0400
Subject: Re: [PATCH v11 00/13] Btrfs dedupe framework
To: <dsterba@suse.cz>, Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        <linux-btrfs@vger.kernel.org>
References: <20160615021001.9588-1-quwenruo@cn.fujitsu.com>
 <b42450d1-d929-7d8d-bbb7-126314002d92@cn.fujitsu.com>
 <20160621093457.GT4915@suse.cz> <1580932.8KuVbA1pQp@localhost.localdomain>
 <20160623121738.GZ4915@twin.jikos.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <023d6b07-2326-bc48-188e-21ff8a442304@cn.fujitsu.com>
Date: Fri, 24 Jun 2016 10:50:41 +0800
MIME-Version: 1.0
In-Reply-To: <20160623121738.GZ4915@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chandan, David,

When I'm trying to rebase dedupe patchset on top of Chadan's sub page 
size patchset (using David's for-next-test-20160620), although the 
rebase itself is quite simple, but I'm afraid that I found some bugs for 
sub page size patchset, *without* dedupe patchset applied.

These bugs seems to be unrelated to each other
1) state leak at btrfs rmmod time
2) bytes_may_use leak at qgroup EDQUOTA error time
3) selftest is run several times at modules load time
    15 times, to be more exact
    And since I didn't found any immediate number related to run it 15
    times, I assume at least it's not designed to do it 15 times.

The reproducer for 1) and 2) is quite simple, extracted from btrfs/022 
test case:
------
dev=/dev/sdb5
mnt=/mnt/test

umount $dev &> /dev/null

mkfs.btrfs $dev -f
mount $dev $mnt -o nospace_cache
btrfs dedupe enable $mnt
btrfs sub create $mnt/sub
btrfs quota enable $mnt


# Just use small limit, making ftrace less noise.
btrfs qgroup limit 512K 0/257 $mnt
dd if=/dev/urandom of=$mnt/sub/test bs=1M count=1
umount $mnt
rmmod btrfs
------

At unmount time, kernel warning will happen due to may_use bytes leak.
I could dig it further, as it looks like a bug in space reservation 
failure case.
------
BTRFS: space_info 1 has 8044544 free, is not full
BTRFS: space_info total=8388608, used=344064, pinned=0, reserved=0, 
may_use=409600, readonly=0
------

And at rmmod time, btrfs will detect extent_state leak, whose length is 
always 4095 (page size - 1).

Hope this will help, and I'm willing to help to fix the problem.

Thanks,
Qu

At 06/23/2016 08:17 PM, David Sterba wrote:
> On Tue, Jun 21, 2016 at 10:25:19PM +0530, Chandan Rajendra wrote:
>>>> I'm completely OK to do the rebase, but since I don't have 64K page size
>>>> machine to test the rebase, we can only test if 4K system is unaffected.
>>>>
>>>> Although not much help, at least it would be better than making it compile.
>>>>
>>>> Also such rebase may help us to expose bad design/unexpected corner case
>>>> in dedupe.
>>>> So if it's OK, please let me try to do the rebase.
>>>
>>> Well, if you base dedupe on subpage, then it could be hard to find the
>>> patchset that introduces bugs, or combination of both. We should be able
>>> to test the features independently, and thus I'm proposing to first find
>>> some common patchset that makes that possible.
>>
>> I am not sure if I understood the above statement correctly. Do you mean to
>> commit the 'common/simple' patches from both the subpage-blocksize & dedupe
>> patchset first and then bring in the complicated ones later?
>
> That would be great yes, but ...
>
>> If yes, then we have a problem doing that w.r.t subpage-blocksize
>> patchset. The first few patches bring in the core changes necessary for the
>> other remaining patches.
>
> ... not easily possible. I looked again for common functions that change
> the singature and found only cow_file_range and run_delalloc_nocow. The
> plan:
>
> - separate patch that adds new parameters required by both patches to
>   the functions
> - update all call sites, add 0/NULL as defaults for the new unused
>   parameters
> - rebase both patches on top of this patch
>
> How does this help: if a patch starts to use the new parameter, it
> changes only the value at all call sites. This is much easier to verify
> and merge manually compared to adding a new parameter to the middle of
> the list, namely when the functions take 6+.
>
> The other conflicts like conversion from PAGE_SIZE to the the block
> oriented iterations will be harder, but these are usually localized and
> can be resolved. We'll see if there are other options to reduce the
> clashes but at the moment it's stuck at the two functions. Does that
> explain it better?
>
>


