Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:27164 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751662AbbAVJty convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 22 Jan 2015 04:49:54 -0500
Message-ID: <54C0C704.5090802@cn.fujitsu.com>
Date: Thu, 22 Jan 2015 17:46:44 +0800
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Wang Shilong <wangshilong1991@gmail.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 3/3] btrfs: qgroup: destroy related qgroup when removing
 subvolume if needed.
References: <1421905582-4539-1-git-send-email-yangds.fnst@cn.fujitsu.com> <1421905582-4539-3-git-send-email-yangds.fnst@cn.fujitsu.com> <88493A06-4B75-4802-9CF9-B98EF13BE160@gmail.com>
In-Reply-To: <88493A06-4B75-4802-9CF9-B98EF13BE160@gmail.com>
Content-Type: text/plain; charset="GB2312"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 01/22/2015 02:16 PM, Wang Shilong wrote:
> Hello,
>
>> When removing a subvol, if the related qgroup has no child qgroup, we should destroy
>> it at the same time. Also remove the TODO entry in qgroup.c.
> My two cents here:
>
> Take a quick look at this, i am not sure whether this is right way to do it.
>
> Actually, i think we can only remove a subvolume qgroup safely when both refer and excl are 0,
> because for subvolume removal case, to make qgroup accounting right, we need walk tree.
>
> At this time, qgroup walking might have not finished, if we remove this qgroup directly,
> accounting for this qgroup will be skipped.

Good point!
>
> Maybe we could remove such qgroup when at qgroup accounting, we find an qgroup¡¯s refer and excl
> are 0, we could remove it, or we do it at the background..
>
> Also, there is another risk, that is to say, if qgroup accounting not work right, So
> we might need gurantee that subvolume it going to be deleted or have been deleted at the same time,
> then we could remove qgroup safely etc.

Yes, you are right. This is not a good timing to remove the qgroup directly.
I need some more investigation for a better solution.

As I have some emergency to deal with in this period, maybe the V2 will
come a little late.
Sorry about it.

Thanx
Yang
>
>
>> Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
>> ---
>> fs/btrfs/inode.c  | 4 ++++
>> fs/btrfs/qgroup.c | 1 -
>> 2 files changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
>> index e687bb0..31de211 100644
>> --- a/fs/btrfs/inode.c
>> +++ b/fs/btrfs/inode.c
>> @@ -59,6 +59,7 @@
>> #include "backref.h"
>> #include "hash.h"
>> #include "props.h"
>> +#include "qgroup.h"
>>
>> struct btrfs_iget_args {
>> 	struct btrfs_key *location;
>> @@ -4029,6 +4030,9 @@ int btrfs_unlink_subvol(struct btrfs_trans_handle *trans,
>> 	ret = btrfs_update_inode_fallback(trans, root, dir);
>> 	if (ret)
>> 		btrfs_abort_transaction(trans, root, ret);
>> +	ret = btrfs_remove_qgroup(trans, root->fs_info, objectid);
>> +	if (ret == -EBUSY)
>> +		ret = 0;
>> out:
>> 	btrfs_free_path(path);
>> 	return ret;
>> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
>> index c3b1e4f..303c078 100644
>> --- a/fs/btrfs/qgroup.c
>> +++ b/fs/btrfs/qgroup.c
>> @@ -35,7 +35,6 @@
>> #include "qgroup.h"
>>
>> /* TODO XXX FIXME
>> - *  - subvol delete -> delete when ref goes to 0? delete limits also?
>>  *  - reorganize keys
>>  *  - compressed
>>  *  - sync
>> -- 
>> 1.8.4.2
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Best Regards,
> Wang Shilong
>
> .
>

