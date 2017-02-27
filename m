Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cloud1-vm154.de-nserver.de ([178.250.10.56]:39955 "EHLO
        cloud1-vm154.de-nserver.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751356AbdB0Nqn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Feb 2017 08:46:43 -0500
Subject: Re: [PATCH 0/3] introduce type based delalloc metadata reserve to fix
 some false enospc issues
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org
References: <1478853587-28717-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
 <310b5ef9-3e08-129d-66bf-500478e65424@profihost.ag>
 <2a3f8cb2-e4e9-e534-ee3d-ff5ad517e71a@gmx.com>
 <30979d9a-993c-c130-5b1b-09cfe5955409@profihost.ag>
 <c53cd7dc-e01a-1463-947d-f8d3721862f7@profihost.ag>
 <41588c56-58d7-a11d-de78-996285e86f6d@cn.fujitsu.com>
Cc: clm@fb.com, jbacik@fb.com, dsterba@suse.com, holger@applied-asynchrony.com
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Message-ID: <38b13669-a4b0-3c92-7b80-7a3c27bbde16@profihost.ag>
Date: Mon, 27 Feb 2017 14:43:07 +0100
MIME-Version: 1.0
In-Reply-To: <41588c56-58d7-a11d-de78-996285e86f6d@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

can please anybody comment on that one? Josef? Chris? I still need those
patches to be able to let btrfs run for more than 24hours without ENOSPC
issues.

Greets,
Stefan

Am 27.02.2017 um 08:22 schrieb Qu Wenruo:
> 
> 
> At 02/25/2017 04:23 PM, Stefan Priebe - Profihost AG wrote:
>> Dear Qu,
>>
>> any news on your branch? I still don't see it merged anywhere.
>>
>> Greets,
>> Stefan
> 
> I just remember that Liu Bo has commented one of the patches, I'm afraid
> I can only push these patches until I addressed his concern.
> 
> I'll start digging it as memory for this fix is quite blurred now.
> 
> Thanks,
> Qu
>>
>> Am 04.01.2017 um 17:13 schrieb Stefan Priebe - Profihost AG:
>>> Hi Qu,
>>>
>>> Am 01.01.2017 um 10:32 schrieb Qu Wenruo:
>>>> Hi Stefan,
>>>>
>>>> I'm trying to push it to for-next (will be v4.11), but no response yet.
>>>>
>>>> It would be quite nice for you to test the following git pull and give
>>>> some feedback, so that we can merge it faster.
>>>>
>>>> https://mail-archive.com/linux-btrfs@vger.kernel.org/msg60418.html
>>>
>>> I'm also getting a notifier that wang's email does not exist anymore
>>> (wangxg.fnst@cn.fujitsu.com).
>>>
>>> I would like to test that branch will need some time todo so. Last time
>>> i tried 4.10-rc1 i had the same problems like this guy:
>>> https://www.marc.info/?l=linux-btrfs&m=148338312525137&w=2
>>>
>>> Stefan
>>>
>>>> Thanks,
>>>> Qu
>>>>
>>>> On 12/31/2016 03:31 PM, Stefan Priebe - Profihost AG wrote:
>>>>> Any news on this series? I can't see it in 4.9 nor in 4.10-rc
>>>>>
>>>>> Stefan
>>>>>
>>>>> Am 11.11.2016 um 09:39 schrieb Wang Xiaoguang:
>>>>>> When having compression enabled, Stefan Priebe ofen got enospc errors
>>>>>> though fs still has much free space. Qu Wenruo also has submitted a
>>>>>> fstests test case which can reproduce this bug steadily, please see
>>>>>> url: https://patchwork.kernel.org/patch/9420527
>>>>>>
>>>>>> First patch[1/3] "btrfs: improve inode's outstanding_extents
>>>>>> computation" is to
>>>>>> fix outstanding_extents and reserved_extents account issues. This
>>>>>> issue was revealed
>>>>>> by modifying BTRFS_MAX_EXTENT_SIZE(128MB) to 64KB, When modifying
>>>>>> BTRFS_MAX_EXTENT_SIZE(128MB) to 64KB, fsstress test often gets these
>>>>>> warnings from
>>>>>> btrfs_destroy_inode():
>>>>>>         WARN_ON(BTRFS_I(inode)->outstanding_extents);
>>>>>>         WARN_ON(BTRFS_I(inode)->reserved_extents);
>>>>>> Please see this patch's commit message for detailed info, and this
>>>>>> patch is
>>>>>> necessary to patch2 and patch3.
>>>>>>
>>>>>> For false enospc, the root reasson is that for compression, its max
>>>>>> extent size will
>>>>>> be 128k, not 128MB. If we still use 128MB as max extent size to
>>>>>> reserve metadata for
>>>>>> compression, obviously it's not appropriate. In patch "btrfs:
>>>>>> Introduce COMPRESS
>>>>>> reserve type to fix false enospc for compression" commit message,
>>>>>> we explain why false enospc error occurs, please see it for detailed
>>>>>> info.
>>>>>>
>>>>>> To fix this issue, we introduce a new enum type:
>>>>>>     enum btrfs_metadata_reserve_type {
>>>>>>         BTRFS_RESERVE_NORMAL,
>>>>>>             BTRFS_RESERVE_COMPRESS,
>>>>>>     };
>>>>>> For btrfs_delalloc_[reserve|release]_metadata() and
>>>>>> btrfs_delalloc_[reserve|release]_space(), we introce a new
>>>>>> btrfs_metadata_reserve_type
>>>>>> argument, then if a path needs to go compression, we pass
>>>>>> BTRFS_RESERVE_COMPRESS,
>>>>>> otherwise pass BTRFS_RESERVE_NORMAL.
>>>>>>
>>>>>> With these patchs, Stefan no longer saw such false enospc errors, and
>>>>>> Qu Wenruo's
>>>>>> fstests test case will also pass. I have also run whole fstests
>>>>>> multiple times,
>>>>>> no regression occurs, thanks.
>>>>>>
>>>>>> Wang Xiaoguang (3):
>>>>>>   btrfs: improve inode's outstanding_extents computation
>>>>>>   btrfs: introduce type based delalloc metadata reserve
>>>>>>   btrfs: Introduce COMPRESS reserve type to fix false enospc for
>>>>>>     compression
>>>>>>
>>>>>>  fs/btrfs/ctree.h             |  36 +++++--
>>>>>>  fs/btrfs/extent-tree.c       |  52 ++++++---
>>>>>>  fs/btrfs/extent_io.c         |  61 ++++++++++-
>>>>>>  fs/btrfs/extent_io.h         |   5 +
>>>>>>  fs/btrfs/file.c              |  25 +++--
>>>>>>  fs/btrfs/free-space-cache.c  |   6 +-
>>>>>>  fs/btrfs/inode-map.c         |   6 +-
>>>>>>  fs/btrfs/inode.c             | 246
>>>>>> ++++++++++++++++++++++++++++++++++---------
>>>>>>  fs/btrfs/ioctl.c             |  16 +--
>>>>>>  fs/btrfs/relocation.c        |  14 ++-
>>>>>>  fs/btrfs/tests/inode-tests.c |  15 +--
>>>>>>  11 files changed, 381 insertions(+), 101 deletions(-)
>>>>>>
>>>>> -- 
>>>>> To unsubscribe from this list: send the line "unsubscribe
>>>>> linux-btrfs" in
>>>>> the body of a message to majordomo@vger.kernel.org
>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>>
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
> 
> 
