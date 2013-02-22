Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ia0-f174.google.com ([209.85.210.174]:44299 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756818Ab3BVQ3m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Feb 2013 11:29:42 -0500
Received: by mail-ia0-f174.google.com with SMTP id u20so676709iag.19
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Feb 2013 08:29:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5127705B.7080705@gmx.net>
References: <1361534540-2381-1-git-send-email-wangshilong1991@gmail.com>
	<5127705B.7080705@gmx.net>
Date: Sat, 23 Feb 2013 00:29:41 +0800
Message-ID: <CAP9B-Qm3Ype9X4nv4CV+bucufpsf4nstPK4JWo6ppYtFEVQ1eA@mail.gmail.com>
Subject: Re: [PATCH 1/2] Btrfs: create the qgroup that limits root subvolume automatically
From: Shilong Wang <wangshilong1991@gmail.com>
To: Arne Jansen <sensille@gmx.net>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2013/2/22 Arne Jansen <sensille@gmx.net>:
> On 02/22/13 13:02, Wang Shilong wrote:
>> From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
>>
>> Creating the root subvolume qgroup when enabling quota,with
>
> Why only create a qgroup for the root subvolume and not for
> every existing subvolume?
>

Yes，You are right.
Creating all the existed subvolume  qgroup is necessary when enabling
quota since we try to prevent
creating  group level 0...the subvolume/snapshot group should be
operated automatically...

Atfer this work.
I think it is necessary to delete the subvolume/snapshot qgroup  as
the deletion of sub volume/snapshot.

BTW, there is a thing  to think about...
During enabling quota...No new subvolume should be created before the
enabling quota is done.

I will try to implement such functions.....

>> this patch,it will be ok to limit the whole filesystem size.
>
> This will not limit the whole filesystem, but only the root
> subvolume. To limit the whole filesystem you'd have to create
> a level 1 qgroup and add all subvolumes to it.
>

Right, thanks for correcting it...

Thanks,
Wang


> -Arne
>
>>
>> Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
>> Reviewed-by: Miao Xie <miaox@cn.fujitsu.com>
>> Cc: Arne Jansen <sensille@gmx.net>
>> ---
>>  fs/btrfs/qgroup.c |   12 ++++++++++++
>>  1 files changed, 12 insertions(+), 0 deletions(-)
>>
>> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
>> index a5c8562..c409096 100644
>> --- a/fs/btrfs/qgroup.c
>> +++ b/fs/btrfs/qgroup.c
>> @@ -777,6 +777,7 @@ int btrfs_quota_enable(struct btrfs_trans_handle *trans,
>>       struct extent_buffer *leaf;
>>       struct btrfs_key key;
>>       int ret = 0;
>> +     struct btrfs_qgroup *qgroup = NULL;
>>
>>       spin_lock(&fs_info->qgroup_lock);
>>       if (fs_info->quota_root) {
>> @@ -823,7 +824,18 @@ int btrfs_quota_enable(struct btrfs_trans_handle *trans,
>>
>>       btrfs_mark_buffer_dirty(leaf);
>>
>> +     btrfs_release_path(path);
>> +     ret = add_qgroup_item(trans, quota_root, BTRFS_FS_TREE_OBJECTID);
>> +     if (ret)
>> +             goto out;
>> +
>>       spin_lock(&fs_info->qgroup_lock);
>> +     qgroup = add_qgroup_rb(fs_info, BTRFS_FS_TREE_OBJECTID);
>> +     if (IS_ERR(qgroup)) {
>> +             spin_unlock(&fs_info->qgroup_lock);
>> +             ret = PTR_ERR(qgroup);
>> +             goto out;
>> +     }
>>       fs_info->quota_root = quota_root;
>>       fs_info->pending_quota_state = 1;
>>       spin_unlock(&fs_info->qgroup_lock);
>>
>
