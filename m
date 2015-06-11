Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:56362 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752759AbbFKTYd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Jun 2015 15:24:33 -0400
Message-ID: <5579E069.6060404@fb.com>
Date: Thu, 11 Jun 2015 15:24:25 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Jeff Mahoney <jeffm@suse.com>, <fdmanana@gmail.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/4] btrfs: skip superblocks during discard
References: <1434036062-21597-1-git-send-email-jeffm@suse.com>	<1434036062-21597-2-git-send-email-jeffm@suse.com>	<CAL3q7H5Hsv2HvBgu_kOEDwXK_53+_1GH9WC_Upa+X8Lhd7sXng@mail.gmail.com>	<5579D0A2.7000407@suse.com> <CAL3q7H7Q-789EkzcBGzMWuAXDJ9t3E-qeMJkRKYASb6NSr7JTQ@mail.gmail.com> <5579DE52.2060502@suse.com>
In-Reply-To: <5579DE52.2060502@suse.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/11/2015 03:15 PM, Jeff Mahoney wrote:
> On 6/11/15 2:44 PM, Filipe David Manana wrote:
>> On Thu, Jun 11, 2015 at 7:17 PM, Jeff Mahoney <jeffm@suse.com>
>> wrote: On 6/11/15 12:47 PM, Filipe David Manana wrote:
>>>>> On Thu, Jun 11, 2015 at 4:20 PM,  <jeffm@suse.com> wrote:
>>>>>> From: Jeff Mahoney <jeffm@suse.com>
>>>>>>
>>>>>> Btrfs doesn't track superblocks with extent records so
>>>>>> there is nothing persistent on-disk to indicate that those
>>>>>> blocks are in use.  We track the superblocks in memory to
>>>>>> ensure they don't get used by removing them from the free
>>>>>> space cache when we load a block group from disk.  Prior to
>>>>>> 47ab2a6c6a (Btrfs: remove empty block groups
>>>>>> automatically), that was fine since the block group would
>>>>>> never be reclaimed so the superblock was always safe.
>>>>>> Once we started removing the empty block groups, we were
>>>>>> protected by the fact that discards weren't being properly
>>>>>> issued for unused space either via FITRIM or -odiscard.
>>>>>> The block groups were still being released, but the blocks
>>>>>> remained on disk.
>>>>>>
>>>>>> In order to properly discard unused block groups, we need
>>>>>> to filter out the superblocks from the discard range.
>>>>>> Superblocks are located at fixed locations on each device,
>>>>>> so it makes sense to filter them out in
>>>>>> btrfs_issue_discard, which is used by both -odiscard and
>>>>>> FITRIM.
>>>>>>
>>>>>> Signed-off-by: Jeff Mahoney <jeffm@suse.com> --- 
>>>>>> fs/btrfs/extent-tree.c | 50 
>>>>>> ++++++++++++++++++++++++++++++++++++++++++++------ 1 file 
>>>>>> changed, 44 insertions(+), 6 deletions(-)
>>>>>>
>>>>>> diff --git a/fs/btrfs/extent-tree.c
>>>>>> b/fs/btrfs/extent-tree.c index 0ec3acd..75d0226 100644 ---
>>>>>> a/fs/btrfs/extent-tree.c +++ b/fs/btrfs/extent-tree.c @@
>>>>>> -1884,10 +1884,47 @@ static int 
>>>>>> remove_extent_backref(struct btrfs_trans_handle *trans,
>>>>>> return ret; }
>>>>>>
>>>>>> -static int btrfs_issue_discard(struct block_device *bdev,
>>>>>> - u64 start, u64 len) +#define in_range(b, first, len)
>>>>>> ((b)
>>>>>>> = (first) && (b) < (first) + (len))
>>>>>
>>>>> Hi Jeff,
>>>>>
>>>>> So this will work if every caller behaves well and passes a
>>>>> region whose start and end offsets are a multiple of the
>>>>> sector size (4096) which currently matches the superblock
>>>>> size.
>>>>>
>>>>> However, I think it would be safer to check for the case
>>>>> where the start offset of a superblock mirror is < (first)
>>>>> and (sb_offset + sb_len) > (first).  Just to deal with cases
>>>>> where for example the 2nd half of the sb starts at offset
>>>>> (first).
>>>>>
>>>>> I guess this sectorsize becoming less than 4096 will happen
>>>>> sooner or later with the subpage sectorsize patch set, so it
>>>>> wouldn't hurt to make it more bullet proof already.
> 
>> Is that something anyone intends to support?  While I suppose the 
>> subpage sector patch /could/ be used to allow file systems with a
>> node size under 4k, the intention is the other way around --
>> systems that have higher order page sizes currently don't work with
>> btrfs file system created on systems with smaller order page sizes
>> like x86.

The best use of smaller node sizes is just to test the subpagesize
patches on more common hardware.  I wouldn't expect anyone to use a 1K
node size in production.

Thanks for doing these Jeff.

-chris
