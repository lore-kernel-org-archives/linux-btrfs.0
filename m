Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:36283 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751747AbeASID2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 Jan 2018 03:03:28 -0500
Subject: Re: [PATCH v2 2/3] btrfs-progs: dir-item: Don't do extra filetype
 validaction check for btrfs_match_dir_item_name
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, Qu Wenruo <wqu@suse.com>,
        <linux-btrfs@vger.kernel.org>
CC: <nborisov@suse.com>
References: <20180119072536.22286-1-wqu@suse.com>
 <20180119072536.22286-3-wqu@suse.com>
 <9fe43408-dfcd-efa3-7195-87fcdba033ab@cn.fujitsu.com>
 <195d1a89-ba5d-081b-91de-f441679414c0@gmx.com>
From: Su Yue <suy.fnst@cn.fujitsu.com>
Message-ID: <ff6ae052-0130-a937-4d81-213d58b1e841@cn.fujitsu.com>
Date: Fri, 19 Jan 2018 16:07:59 +0800
MIME-Version: 1.0
In-Reply-To: <195d1a89-ba5d-081b-91de-f441679414c0@gmx.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 01/19/2018 03:38 PM, Qu Wenruo wrote:
> 
> 
> On 2018年01月19日 15:39, Su Yue wrote:
>>
>>
>> On 01/19/2018 03:25 PM, Qu Wenruo wrote:
>>> btrfs_match_dir_item_name() will check if its filetype is valid before
>>> doing search, this makes btrfs-progs unable to locate and remove invalid
>>> dir_index for btrfs_unlink().
>>>
>>> This function only affects btrfs_link() and btrfs_unlink() in upper
>>> layer, and normal check can find invalid filetype by itself.
>>>
>> Lowmem mode can't handles wrong filetype well now.
>> I'm working on it. And this change is okay for me.
> 
> I think you mean *original* mode can't handle it.
> 
Sorry, I mean that lowmem mode can't handle more complex cases.
This patchset does well enough for the single case.
I will fix it for original mode and new test-case will be
submitted.

Thanks,
Su
> As v4.14.1 lowmem mode can detect such problem without problem:
> -------
> checking fs roots
> ERROR: root 5 INODE_ITEM[258] index 2 name file1 filetype 34 mismath
> ERROR: root 5 DIR INDEX[257 2] missing name file1 filetype 1
> ERROR: errors found in fs roots
> found 131072 bytes used, error(s) found
> -------
> 
> And patch 1/3 will handle the repair, so it shouldn't be a problem for
> lowmem.
> 
> Thanks,
> Qu
>>
>> Reviewed-by: Su Yue <suy.fnst@cn.fujitsu.com>
>>
>>> So remove the filetype check is completely safe in this case, and will
>>> enhance btrfs_unlink() to remove invalid dir_index/dir_item for repair.
>>>
>>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>>> ---
>>>    dir-item.c | 6 ------
>>>    1 file changed, 6 deletions(-)
>>>
>>> diff --git a/dir-item.c b/dir-item.c
>>> index 462546c0eaf4..e0a0ab4d7a5d 100644
>>> --- a/dir-item.c
>>> +++ b/dir-item.c
>>> @@ -294,12 +294,6 @@ static int verify_dir_item(struct btrfs_root *root,
>>>        u16 namelen = BTRFS_NAME_LEN;
>>>        u8 type = btrfs_dir_type(leaf, dir_item);
>>>    -    if (type >= BTRFS_FT_MAX) {
>>> -        fprintf(stderr, "invalid dir item type: %d\n",
>>> -               (int)type);
>>> -        return 1;
>>> -    }
>>> -
>>>        if (type == BTRFS_FT_XATTR)
>>>            namelen = XATTR_NAME_MAX;
>>>   
>>
>>
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


