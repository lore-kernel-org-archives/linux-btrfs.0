Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:19016 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726489AbeHCGSE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Aug 2018 02:18:04 -0400
Date: Fri, 3 Aug 2018 12:23:32 +0800
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
CC: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: qgroup: Remove qgroup item along with subvolume
 deletion
Message-ID: <20180803042331.GC2049@fnst.localdomain>
References: <cover.1533263845.git.misono.tomohiro@jp.fujitsu.com>
 <eeaa9ab1-f6a5-9043-9b5e-cc9acf82ca47@jp.fujitsu.com>
 <e2d0d7fc-8603-7c47-4168-266be4d72edc@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
In-Reply-To: <e2d0d7fc-8603-7c47-4168-266be4d72edc@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 03, 2018 at 12:17:26PM +0800, Qu Wenruo wrote:
>
>
>On 2018年08月03日 12:08, Misono Tomohiro wrote:
>> When qgroup is on, subvolume deletion does not remove qgroup items
>> of the subvolume (qgroup info, limits, relation) from quota tree and
>> they need to get removed manually by "btrfs qgroup destroy".
>> 
>> Since level 0 qgroup cannot be used/inherited by any other subvolume,
>> let's remove them automatically when subvolume is deleted.
>> 
>> Signed-off-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
>> ---
>> 
>> I don't see any reason to keep these items after subvolume deletion,
>> but is there something I'm missing?
>> 
>>  fs/btrfs/inode.c | 4 ++++
>>  1 file changed, 4 insertions(+)
>> 
>> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
>> index 3f51ddc18f98..4ec60a1b53a3 100644
>> --- a/fs/btrfs/inode.c
>> +++ b/fs/btrfs/inode.c
>> @@ -4372,6 +4372,10 @@ int btrfs_delete_subvolume(struct inode *dir, struct dentry *dentry)
>>  		}
>>  	}
>>  
>> +	ret = btrfs_remove_qgroup(trans, dest->root_key.objectid);
>
>According to the caller, it only unlinks the subvolume without really
>delete the whole subvolume.
>
>I'm wondering if we should call btrfs_remove_qgroup() only after we have
>deleted the whole subvolume, e.g inside btrfs_drop_snapshot().

I agree with Qu's point, because the ongoing online undelete subvolume will
be able to recover the subvolume which is intact ondisk, including the qgroup.

-- 
Thanks,
Lu

>
>Thanks,
>Qu
>
>> +	if (ret == -EINVAL || ret == -ENOENT)
>> +		ret = 0;
>> +
>>  out_end_trans:
>>  	trans->block_rsv = NULL;
>>  	trans->bytes_reserved = 0;
>> 
>


