Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:40358 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752977AbdLDD6U (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 3 Dec 2017 22:58:20 -0500
Subject: Re: [PATCH 5/5] btrfs: Greatly simplify btrfs_read_dev_super
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <1512119984-12708-1-git-send-email-nborisov@suse.com>
 <1512119984-12708-6-git-send-email-nborisov@suse.com>
 <96aafd8d-a1e8-2846-0aa3-59b3ff97edb7@oracle.com>
 <f08faba1-2c79-bd80-34f5-f8f85e927464@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <2bada310-56e2-425f-9116-9748e4c20529@oracle.com>
Date: Mon, 4 Dec 2017 09:33:21 +0800
MIME-Version: 1.0
In-Reply-To: <f08faba1-2c79-bd80-34f5-f8f85e927464@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 12/03/2017 05:43 PM, Nikolay Borisov wrote:
> 
> 
> On  2.12.2017 01:23, Anand Jain wrote:
>>
>>
>> On 12/01/2017 05:19 PM, Nikolay Borisov wrote:
>>> Currently this function executes the inner loop at most 1 due to the i
>>> = 0;
>>> i < 1 condition. Furthermore, the btrfs_super_generation(super) >
>>> transid code
>>> in the if condition is never executed due to latest always set to NULL
>>> hence the
>>> first part of the condition always triggering. The gist of
>>> btrfs_read_dev_super
>>> is really to read the first superblock.
>>>
>>> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
>>> ---
>>>    fs/btrfs/disk-io.c | 27 ++++-----------------------
>>>    1 file changed, 4 insertions(+), 23 deletions(-)
>>>
>>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>>> index 82c96607fc46..6d5f632fd1e7 100644
>>> --- a/fs/btrfs/disk-io.c
>>> +++ b/fs/btrfs/disk-io.c
>>> @@ -3170,37 +3170,18 @@ int btrfs_read_dev_one_super(struct
>>> block_device *bdev, int copy_num,
>>>    struct buffer_head *btrfs_read_dev_super(struct block_device *bdev)
>>>    {
>>>        struct buffer_head *bh;
>>> -    struct buffer_head *latest = NULL;
>>> -    struct btrfs_super_block *super;
>>> -    int i;
>>> -    u64 transid = 0;
>>> -    int ret = -EINVAL;
>>> +    int ret;
>>>          /* we would like to check all the supers, but that would make
>>>         * a btrfs mount succeed after a mkfs from a different FS.
>>>         * So, we need to add a special mount option to scan for
>>>         * later supers, using BTRFS_SUPER_MIRROR_MAX instead
>>>         */
>>
>>   We need below loop to support the above comment at some point,
> 
> And when is that, since I don't see anyone working on it. 

> Furthermore
> what is it that we are losing in terms of functionality by not
> supporting the comment? 

  As of now if the primary SB is corrupted we don't recover from it
  automatically and external tools are broken.

>It seems this code was just slapt here without
> any vision how/when to implement it?

  I have in my todo list. I am ok if you want to fix it as needed.

> Furthermore, you seem to be aware of what the comment is talking about,
> I have to admit I'm not.

> Is the idea that if another filesystem does
> mkfs and doesn't overwrite ALL superblock copies that btrfs writes (at
> 64k, 64mb, 256gb and 1 PiB) then it's possible for this code to
> erroneously detect btrfs when in fact there is a different fs?

  Right.

  IMO the above comment is wrong as well for which it made the
  for-loop to read only primary SB.

  If we have a feature to maintain backup SB, then that feature
  is only complete when we would automatically recover from the
  backup SB.
  If a user overwrites btrfs primary SB and still mounts btrfs
  with -t btrfs options, then its use-end problem we should be
  able to recover from backup SB. So IMO looping through other
  SB is fine.

Thanks, Anand

> I don't understand what problem *should* be solved here...

>>   instead of removing I would prefer to fix as per above comments.
>>
>> Thanks, Anand
>>
>>
>>> -    for (i = 0; i < 1; i++) {
>>> -        ret = btrfs_read_dev_one_super(bdev, i, &bh);
>>> -        if (ret)
>>> -            continue;
>>> -
>>> -        super = (struct btrfs_super_block *)bh->b_data;
>>> -
>>> -        if (!latest || btrfs_super_generation(super) > transid) {
>>> -            brelse(latest);
>>> -            latest = bh;
>>> -            transid = btrfs_super_generation(super);
>>> -        } else {
>>> -            brelse(bh);
>>> -        }
>>> -    }
>>> -
>>> -    if (!latest)
>>> +    ret = btrfs_read_dev_one_super(bdev, 0, &bh);
>>> +    if (ret)
>>>            return ERR_PTR(ret);
>>>    -    return latest;
>>> +    return bh;
>>>    }
>>>      /*
>>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
