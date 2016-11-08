Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:48508 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751454AbcKHBp6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Nov 2016 20:45:58 -0500
Subject: Re: [PATCH v2 02/14] btrfs-progs: check: introduce function to find
 dir_item
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>,
        Lu Fengqi <lufq.fnst@cn.fujitsu.com>
References: <20160921031604.23334-1-quwenruo@cn.fujitsu.com>
 <20160921031604.23334-3-quwenruo@cn.fujitsu.com>
 <20161102152151.GH12522@twin.jikos.cz>
 <cedc76f5-fadc-c6d0-b491-eb16ccc3e15a@cn.fujitsu.com>
 <20161107170523.GR12522@twin.jikos.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <405368c7-cbaf-92cd-02ec-45d87b843dbc@cn.fujitsu.com>
Date: Tue, 8 Nov 2016 09:45:54 +0800
MIME-Version: 1.0
In-Reply-To: <20161107170523.GR12522@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 11/08/2016 01:05 AM, David Sterba wrote:
> On Thu, Nov 03, 2016 at 09:58:21AM +0800, Qu Wenruo wrote:
>>
>>
>> At 11/02/2016 11:21 PM, David Sterba wrote:
>>> On Wed, Sep 21, 2016 at 11:15:52AM +0800, Qu Wenruo wrote:
>>>> From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
>>>>
>>>> Introduce a new function find_dir_item() to find DIR_ITEM for the given
>>>> key, and check it with the specified INODE_REF/INODE_EXTREF match.
>>>>
>>>> Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
>>>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>>>> ---
>>>>  cmds-check.c | 140 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>>>  1 file changed, 140 insertions(+)
>>>>
>>>> diff --git a/cmds-check.c b/cmds-check.c
>>>> index 998ba63..4e25804 100644
>>>> --- a/cmds-check.c
>>>> +++ b/cmds-check.c
>>>> @@ -3848,6 +3848,146 @@ out:
>>>>  	return err;
>>>>  }
>>>>
>>>> +#define ROOT_DIR_ERROR		(1<<1)	/* bad root_dir */
>>>> +#define DIR_ITEM_MISSING	(1<<2)	/* DIR_ITEM not found */
>>>> +#define DIR_ITEM_MISMATCH	(1<<3)	/* DIR_ITEM found but not match */
>>>
>>> What's the reason for another definition of the error codes? They're
>>> mostly copied from te I_ERR_* counterparts. I'd rather have one set of
>>> error codes.
>>
>> The main reason is, in lowmem fsck mode, we are not checking inodes or
>> ref/backref in batch.
>>
>> If using I_ERR and REF_ERR, we can mixing them up as they share the same
>> bits.
>>
>> So we introduced the new error bitmap, to make sure all error bits won't
>> cover each other.
>>
>> It may be better if we rearrange I_ERR/REF_ERR to avoid conflicts.
>> E.g, let REF_ERR_ starts from lowest bit and let I_ERR_ starts from high
>> bits.
>
> Yes please. Third namespace for existing error bits is not a good
> option. Move the I_ERR bits to start from 32 and use them in the low-mem
> code that's been merged to devel.
>
>
Should I submit a separate fix or replace the patchset?

Thanks,
Qu


