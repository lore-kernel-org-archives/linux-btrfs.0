Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:18454 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1755502AbdEVCDr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 21 May 2017 22:03:47 -0400
Subject: Re: [PATCH 4/8] btrfs: autoremove qgroup by default, and add a mount
 flag to override
To: Sargun Dhillon <sargun@sargun.me>
CC: BTRFS ML <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <0327aafe-3852-c5ec-f9e7-b6f978dc9840@cn.fujitsu.com>
Date: Mon, 22 May 2017 10:03:40 +0800
MIME-Version: 1.0
In-Reply-To: <CAMp4zn_MF_=buuBT72Oh2Mxj78LtLZDNZT-Bx=fOhwvLEkMEGw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <20170520083920.GA4222@ircssh-2.c.rugged-nimbus-611.internal>
 <b4f83285-3ca1-e92d-1b6a-e2b3b68d0a6a@cn.fujitsu.com>
 <CAMp4zn_MF_=buuBT72Oh2Mxj78LtLZDNZT-Bx=fOhwvLEkMEGw@mail.gmail.com>



At 05/22/2017 09:58 AM, Sargun Dhillon wrote:
> On Sun, May 21, 2017 at 6:20 PM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>>
>>
>> At 05/20/2017 04:39 PM, Sargun Dhillon wrote:
>>>
>>> This change follows the change to automatically remove qgroups
>>> if the associated subvolume has also been removed. It changes
>>> the default behaviour to automatically remove qgroups when
>>> a subvolume is deleted, but this can be override with the
>>> qgroup_keep mount flag.
>>>
>>> Signed-off-by: Sargun Dhillon <sargun@sargun.me>
>>> ---
>>>    fs/btrfs/ctree.h |  1 +
>>>    fs/btrfs/ioctl.c | 14 ++++++++++++++
>>>    fs/btrfs/super.c | 16 +++++++++++++++-
>>>    3 files changed, 30 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
>>> index 643c70d..4d57eb6 100644
>>> --- a/fs/btrfs/ctree.h
>>> +++ b/fs/btrfs/ctree.h
>>> @@ -1348,6 +1348,7 @@ static inline u32 BTRFS_MAX_XATTR_SIZE(const struct
>>> btrfs_fs_info *info)
>>>    #define BTRFS_MOUNT_FRAGMENT_METADATA (1 << 25)
>>>    #define BTRFS_MOUNT_FREE_SPACE_TREE   (1 << 26)
>>>    #define BTRFS_MOUNT_NOLOGREPLAY               (1 << 27)
>>> +#define BTRFS_MOUNT_QGROUP_KEEP                (1 << 28)
>>>      #define BTRFS_DEFAULT_COMMIT_INTERVAL       (30)
>>>    #define BTRFS_DEFAULT_MAX_INLINE      (2048)
>>> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
>>> index e176375..b10d7bb 100644
>>> --- a/fs/btrfs/ioctl.c
>>> +++ b/fs/btrfs/ioctl.c
>>> @@ -2544,6 +2544,20 @@ static noinline int btrfs_ioctl_snap_destroy(struct
>>> file *file,
>>>                  }
>>>          }
>>>    +     /*
>>> +        * Attempt to automatically remove the automatically attached
>>> qgroup
>>> +        * setup in btrfs_qgroup_inherit. As a matter of convention, the
>>> id
>>> +        * is the same as the subvolume id.
>>> +        *
>>> +        * This can fail non-fatally for level 0 qgroups, and potentially
>>> +        * leave the filesystem in an awkward, (but working) state.
>>> +        */
>>> +       if (!btrfs_test_opt(fs_info, QGROUP_KEEP)) {
>>> +               ret = btrfs_remove_qgroup(trans, fs_info,
>>> +                                         dest->root_key.objectid);
>>> +               if (ret && ret != -ENOENT)
>>> +                       pr_info("Could not automatically delete qgroup:
>>> %d\n", ret);
>>> +       }
>>>    out_end_trans:
>>>          trans->block_rsv = NULL;
>>>          trans->bytes_reserved = 0;
>>> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
>>> index 4f1cdd5..232e1b8 100644
>>> --- a/fs/btrfs/super.c
>>> +++ b/fs/btrfs/super.c
>>> @@ -321,7 +321,7 @@ enum {
>>>          Opt_commit_interval, Opt_barrier, Opt_nodefrag, Opt_nodiscard,
>>>          Opt_noenospc_debug, Opt_noflushoncommit, Opt_acl, Opt_datacow,
>>>          Opt_datasum, Opt_treelog, Opt_noinode_cache, Opt_usebackuproot,
>>> -       Opt_nologreplay, Opt_norecovery,
>>> +       Opt_nologreplay, Opt_norecovery, Opt_qgroup_keep,
>>> Opt_qgroup_nokeep,
>>
>>
>> I prefer to add new meanings for btrfs_ioctl_qgroup_create_args->create.
> I have two issues with this:
> 1) Existing software, like Docker Daemon. There's no way I can tell
> Docker daemon to use this new flag to create qgroups. Although, I
> could modify it, it doesn't fit into the API very well.
> 2) How do I do this with qgroups that already exist, or qgroups that
> are created on-demand by qgroup_inherit?
> 
> I think both of these would be fixed if we copied (a subset) of the
> qgroup flags. If you look at my other patches, I think we want to
> remove the ability to remove level-0 qgroups (which are inherited), so
> we'd also want to add an ioctl to be able to modify (some of those)
> flags. Do you think that adding inheritance, and a new ioctl is a
> reasonable approach?

Sorry, I didn't see later patches.

Yes, new API is a better method to solve this problem.

But with new APIs, the need of new mount option is even less.
Outputting a warning message in dmesg is good enough to info user to use 
new API.

Thanks,
Qu

> 
>>
>> It's a u64 value while we only checks if it's zero or not, to determine if
>> it's creation or deletion.
>>
>> We could reuse it to extent the create/delete behavior, other than a new
>> mount option, which is a global flag, just to alter qgroup behavior.
>>
>> Thanks,
>> Qu
>>
>>
>>>    #ifdef CONFIG_BTRFS_DEBUG
>>>          Opt_fragment_data, Opt_fragment_metadata, Opt_fragment_all,
>>>    #endif
>>> @@ -381,6 +381,8 @@ static const match_table_t tokens = {
>>>          {Opt_rescan_uuid_tree, "rescan_uuid_tree"},
>>>          {Opt_fatal_errors, "fatal_errors=%s"},
>>>          {Opt_commit_interval, "commit=%d"},
>>> +       {Opt_qgroup_keep, "qgroup_keep"},
>>> +       {Opt_qgroup_nokeep, "qgroup_nokeep"},
>>>    #ifdef CONFIG_BTRFS_DEBUG
>>>          {Opt_fragment_data, "fragment=data"},
>>>          {Opt_fragment_metadata, "fragment=metadata"},
>>> @@ -808,6 +810,14 @@ int btrfs_parse_options(struct btrfs_fs_info *info,
>>> char *options,
>>>                                  info->commit_interval =
>>> BTRFS_DEFAULT_COMMIT_INTERVAL;
>>>                          }
>>>                          break;
>>> +               case Opt_qgroup_keep:
>>> +                       btrfs_set_and_info(info, QGROUP_KEEP,
>>> +                                          "do not automatically delete
>>> qgroups");
>>> +                       break;
>>> +               case Opt_qgroup_nokeep:
>>> +                       btrfs_clear_and_info(info, QGROUP_KEEP,
>>> +                                            "automatically delete
>>> qgroups");
>>> +                       break;
>>>    #ifdef CONFIG_BTRFS_DEBUG
>>>                  case Opt_fragment_all:
>>>                          btrfs_info(info, "fragmenting all space");
>>> @@ -1299,6 +1309,10 @@ static int btrfs_show_options(struct seq_file *seq,
>>> struct dentry *dentry)
>>>                  seq_puts(seq, ",fatal_errors=panic");
>>>          if (info->commit_interval != BTRFS_DEFAULT_COMMIT_INTERVAL)
>>>                  seq_printf(seq, ",commit=%d", info->commit_interval);
>>> +       if (btrfs_test_opt(info, QGROUP_KEEP))
>>> +               seq_puts(seq, ",qgroup_keep");
>>> +       else
>>> +               seq_puts(seq, ",qgroup_nokeep");
>>>    #ifdef CONFIG_BTRFS_DEBUG
>>>          if (btrfs_test_opt(info, FRAGMENT_DATA))
>>>                  seq_puts(seq, ",fragment=data");
>>>
>>
>>
> 
> 


