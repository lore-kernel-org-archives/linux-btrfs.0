Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:64985 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752153AbcESKrJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 May 2016 06:47:09 -0400
Subject: Re: [PATCH] btrfs: remove unnecessary
 btrfs_delalloc_release_metadata() call
To: <fdmanana@gmail.com>
References: <1463651050-6922-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
 <CAL3q7H4yj91ah-cRrjtOceUW02boRCv9_hazS7KGJr065R30Sg@mail.gmail.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Message-ID: <573D999D.7000400@cn.fujitsu.com>
Date: Thu, 19 May 2016 18:46:53 +0800
MIME-Version: 1.0
In-Reply-To: <CAL3q7H4yj91ah-cRrjtOceUW02boRCv9_hazS7KGJr065R30Sg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On 05/19/2016 06:29 PM, Filipe Manana wrote:
> On Thu, May 19, 2016 at 10:44 AM, Wang Xiaoguang
> <wangxg.fnst@cn.fujitsu.com> wrote:
>> In __btrfs_write_out_cache(), we don't call btrfs_delalloc_reserve_metadata()
>> or btrfs_delalloc_reserve_space() to reserve metadata space, so we also should
>> not call btrfs_delalloc_release_metadata(), in which BTRFS_I(inode)->outstanding_extents
>> will be decreased, then WARN_ON(BTRFS_I(inode)->outstanding_extents) in
>> btrfs_destroy_inode() will be triggered.
>>
>> To be honest, I do not see this WARNING in real, but I think we should fix it.
> No, this is wrong.
>
> We do this call to release reserved metadata space at
> btrfs_save_ino_cache() through btrfs_delalloc_reserve_space().
> And it's btrfs_save_ino_cache() that calls btrfs_write_out_ino_cache().
Oh, you're right, sorry for the noise.

>
> If what you said were true, then it would be trivial to write a test
> case (using the inode cache feature) to trigger the problem.
OK.

Regards,
Xiaoguang Wang
>
>
>
>> Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
>> ---
>>   fs/btrfs/free-space-cache.c | 17 +++--------------
>>   1 file changed, 3 insertions(+), 14 deletions(-)
>>
>> diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
>> index 8f835bf..ababf56 100644
>> --- a/fs/btrfs/free-space-cache.c
>> +++ b/fs/btrfs/free-space-cache.c
>> @@ -3512,7 +3512,6 @@ int btrfs_write_out_ino_cache(struct btrfs_root *root,
>>          struct btrfs_free_space_ctl *ctl = root->free_ino_ctl;
>>          int ret;
>>          struct btrfs_io_ctl io_ctl;
>> -       bool release_metadata = true;
>>
>>          if (!btrfs_test_opt(root, INODE_MAP_CACHE))
>>                  return 0;
>> @@ -3520,26 +3519,16 @@ int btrfs_write_out_ino_cache(struct btrfs_root *root,
>>          memset(&io_ctl, 0, sizeof(io_ctl));
>>          ret = __btrfs_write_out_cache(root, inode, ctl, NULL, &io_ctl,
>>                                        trans, path, 0);
>> -       if (!ret) {
>> -               /*
>> -                * At this point writepages() didn't error out, so our metadata
>> -                * reservation is released when the writeback finishes, at
>> -                * inode.c:btrfs_finish_ordered_io(), regardless of it finishing
>> -                * with or without an error.
>> -                */
>> -               release_metadata = false;
>> +       if (!ret)
>>                  ret = btrfs_wait_cache_io(root, trans, NULL, &io_ctl, path, 0);
>> -       }
>>
>> -       if (ret) {
>> -               if (release_metadata)
>> -                       btrfs_delalloc_release_metadata(inode, inode->i_size);
>>   #ifdef DEBUG
>> +       if (ret) {
>>                  btrfs_err(root->fs_info,
>>                          "failed to write free ino cache for root %llu",
>>                          root->root_key.objectid);
>> -#endif
>>          }
>> +#endif
>>
>>          return ret;
>>   }
>> --
>> 1.8.3.1
>>
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>



