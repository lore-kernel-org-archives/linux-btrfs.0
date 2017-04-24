Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f176.google.com ([209.85.223.176]:33300 "EHLO
        mail-io0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1045993AbdDXEtQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Apr 2017 00:49:16 -0400
Received: by mail-io0-f176.google.com with SMTP id k87so178864259ioi.0
        for <linux-btrfs@vger.kernel.org>; Sun, 23 Apr 2017 21:49:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <8b6ffc4e-c5e6-3511-a8b7-2de28cc48bac@cn.fujitsu.com>
From: Sargun Dhillon <sargun@sargun.me>
Date: Sun, 23 Apr 2017 21:48:34 -0700
Message-ID: <CAMp4zn_hU_AeEw2qNSJ7x3WKDKaWRzb=fvMxUxybRW7o=-s=LA@mail.gmail.com>
Subject: Re: [PATCH 1/2] btrfs: add quota override attribute
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: BTRFS ML <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <20170421231246.GA3778@ircssh-2.c.rugged-nimbus-611.internal>
 <8b6ffc4e-c5e6-3511-a8b7-2de28cc48bac@cn.fujitsu.com>

On Sun, Apr 23, 2017 at 8:42 PM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>
>
> At 04/22/2017 07:12 AM, Sargun Dhillon wrote:
>>
>> This patch introduces the quota override flag to btrfs_fs_info, and
>> a change to quota limit checking code to temporarily allow for quota
>> to be overridden for processes with cap_sys_resource.
>>
>> It's useful for administrative programs, such as log rotation,
>> that may need to temporarily use more disk space in order to free up
>> a greater amount of overall disk space without yielding more disk
>> space to the rest of userland.
>>
>> Eventually, we may want to add the idea of an operator-specific
>> quota, operator reserved space, or something else to allow for
>> administrative override, but this is perhaps the simplest
>> solution.
>
>
> Indeed simplest method yet.
>
> But considering that reserved data space can be used by none privileged
> user, I'm not sure if it's a good idea.
>
> For example:
>
> If root want to write a 64M file with new data, then it reserved 64M data
> space.
>
> And another none privileged user also want to write that 64M file with
> different data, then the user won't need to reserve data space.
> (Although metadata space is still needed).
>
> Won't this cause some method to escaping the qgroup limit?
This is more of a failure-avoidance mechanism. We run containers that
don't have cap_sys_resource. The log rotator, on the other hand, has a
full-set of capabilities in the root user namespace. Given that we'd
only flip quota_override if the system gets into a state where the log
rotator cannot run, I don't see it being particularly problematic.

At least looking at my systems, none of my users have cap_sys_resource
in their capabilities set, and it seems to be the closest capability
that maps to disk quota logic. I'd hate to drop this into the bucket
of cap_sys_admin. Are you perhaps suggesting per-uid and per-gid
qgroups? Or being able to have a quota_override_uid value? I thought
about adding an extended attribute, but that would require the attr to
be set at file creation time, not necessarily when I need it for an
escape. Another idea was to do what ext does, in adding a special
"operator" reserved space which processes with uid == 0 &&
cap_sys_resource can use. This would require changing the on-disk
qgroup format.

You're right, we would (intentionally) "escape" the qgroup limit. A
process with cap_sys_resource would be able to allocate more disk
space temporarily If I'm understanding you correctly, I don't think
that they would be able to rewrite the file's contents because that'd
be considered changed extents, no?

>
>>
>> Signed-off-by: Sargun Dhillon <sargun@sargun.me>
>> ---
>>   fs/btrfs/ctree.h  | 3 +++
>>   fs/btrfs/qgroup.c | 9 +++++++--
>>   2 files changed, 10 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
>> index c411590..01a095b 100644
>> --- a/fs/btrfs/ctree.h
>> +++ b/fs/btrfs/ctree.h
>> @@ -1098,6 +1098,9 @@ struct btrfs_fs_info {
>>         u32 nodesize;
>>         u32 sectorsize;
>>         u32 stripesize;
>> +
>> +       /* Allow tasks with cap_sys_resource to override the quota */
>> +       bool quota_override;
>
>
> Why not use existing fs_info->qgroup_flags?
Isn't that persisted? I don't want this to surprise users across reboots.

>
> Thanks,
> Qu
>
>
>>   };
>>     static inline struct btrfs_fs_info *btrfs_sb(struct super_block *sb)
>> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
>> index a59801d..0328492 100644
>> --- a/fs/btrfs/qgroup.c
>> +++ b/fs/btrfs/qgroup.c
>> @@ -2347,8 +2347,12 @@ int btrfs_qgroup_inherit(struct btrfs_trans_handle
>> *trans,
>>         return ret;
>>   }
>>   -static bool qgroup_check_limits(const struct btrfs_qgroup *qg, u64
>> num_bytes)
>> +static bool qgroup_check_limits(const struct btrfs_qgroup *qg,
>> +                               u64 num_bytes, bool quota_override)
>>   {
>> +       if (quota_override && capable(CAP_SYS_RESOURCE))
>> +               return true;
>> +
>>         if ((qg->lim_flags & BTRFS_QGROUP_LIMIT_MAX_RFER) &&
>>             qg->reserved + (s64)qg->rfer + num_bytes > qg->max_rfer)
>>                 return false;
>> @@ -2366,6 +2370,7 @@ static int qgroup_reserve(struct btrfs_root *root,
>> u64 num_bytes, bool enforce)
>>         struct btrfs_qgroup *qgroup;
>>         struct btrfs_fs_info *fs_info = root->fs_info;
>>         u64 ref_root = root->root_key.objectid;
>> +       bool qo = fs_info->quota_override;
>>         int ret = 0;
>>         struct ulist_node *unode;
>>         struct ulist_iterator uiter;
>> @@ -2401,7 +2406,7 @@ static int qgroup_reserve(struct btrfs_root *root,
>> u64 num_bytes, bool enforce)
>>                 qg = unode_aux_to_qgroup(unode);
>>   -             if (enforce && !qgroup_check_limits(qg, num_bytes)) {
>> +               if (enforce && !qgroup_check_limits(qg, num_bytes, qo)) {
>>                         ret = -EDQUOT;
>>                         goto out;
>>                 }
>>
>
>
