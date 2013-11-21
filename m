Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f52.google.com ([209.85.214.52]:52418 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218Ab3KUNHD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Nov 2013 08:07:03 -0500
Received: by mail-bk0-f52.google.com with SMTP id u14so294869bkz.25
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Nov 2013 05:07:02 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <528D30D2.6070107@suse.com>
References: <528D30D2.6070107@suse.com>
Date: Thu, 21 Nov 2013 13:07:02 +0000
Message-ID: <CAL3q7H7eW50NgOT2jQAJFei8h7wPee5WiQ6fjKgVCBGG3H0O5Q@mail.gmail.com>
Subject: Re: [PATCH] btrfs: fix leaks during sysfs teardown
From: Filipe David Manana <fdmanana@gmail.com>
To: Jeff Mahoney <jeffm@suse.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Josef Bacik <jbacik@fusionio.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 20, 2013 at 9:59 PM, Jeff Mahoney <jeffm@suse.com> wrote:
> Filipe noticed that we were leaking the features attribute group
> after umount. His fix of just calling sysfs_remove_group() wasn't enough
> since that removes just the supported features and not the unknown
> features (but a regular test wouldn't show that).
>
> This patch changes the unknown feature handling to add them individually
> so we can skip the kmalloc and uses the same iteration to tear them down
> later.
>
> We also fix the error handling during mount so that we catch the
> failing creation of the per-super kobject, and handle proper teardown
> of a half-setup sysfs context.
>
> Reported-by: Filipe David Borba Manana <fdmanana@gmail.com>
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>

Hi Jeff, I tested this patch (reverted my patch and applied yours) and
after about 20 minutes of running xfstests I had 169 kmemleak
warnings, see below some of the stack traces. Thanks.

unreferenced object 0xffff8807424bdb90 (size 64):
  comm "mount", pid 20697, jiffies 4295160287 (age 1117.544s)
  hex dump (first 32 bytes):
    64 36 61 34 61 30 64 30 2d 39 62 31 63 2d 34 31  d6a4a0d0-9b1c-41
    37 62 2d 38 31 30 37 2d 34 36 66 32 39 63 30 39  7b-8107-46f29c09
  backtrace:
    [<ffffffff8175f606>] kmemleak_alloc+0x26/0x50
    [<ffffffff8119061b>] __kmalloc_track_caller+0x1cb/0x240
    [<ffffffff81157102>] kstrdup+0x42/0x70
    [<ffffffff81219271>] sysfs_new_dirent+0x31/0x130
    [<ffffffff812196e2>] create_dir+0x42/0xd0
    [<ffffffff81219aa9>] sysfs_create_dir+0x89/0xe0
    [<ffffffff813e3416>] kobject_add_internal+0x96/0x210
    [<ffffffff813e37a3>] kobject_init_and_add+0x63/0x90
    [<ffffffffa06adadd>] btrfs_sysfs_add_one+0x7d/0x1b0 [btrfs]
    [<ffffffffa0693792>] open_ctree+0x17d2/0x21f0 [btrfs]
    [<ffffffffa066983a>] btrfs_mount+0x53a/0x7d0 [btrfs]
    [<ffffffff811a3ae3>] mount_fs+0x43/0x1b0
    [<ffffffff811bfa66>] vfs_kern_mount+0x76/0x120
    [<ffffffff811c1d87>] do_mount+0x237/0xa70
    [<ffffffff811c2650>] SyS_mount+0x90/0xe0
    [<ffffffff8177ef12>] system_call_fastpath+0x16/0x1b
unreferenced object 0xffff8800968254f8 (size 160):
  comm "mount", pid 20697, jiffies 4295160287 (age 1117.544s)
  hex dump (first 32 bytes):
    01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff8175f606>] kmemleak_alloc+0x26/0x50
    [<ffffffff8118f294>] kmem_cache_alloc+0x114/0x200
    [<ffffffff81219291>] sysfs_new_dirent+0x51/0x130
    [<ffffffff812196e2>] create_dir+0x42/0xd0
    [<ffffffff81219aa9>] sysfs_create_dir+0x89/0xe0
    [<ffffffff813e3416>] kobject_add_internal+0x96/0x210
    [<ffffffff813e37a3>] kobject_init_and_add+0x63/0x90
    [<ffffffffa06adadd>] btrfs_sysfs_add_one+0x7d/0x1b0 [btrfs]
    [<ffffffffa0693792>] open_ctree+0x17d2/0x21f0 [btrfs]
    [<ffffffffa066983a>] btrfs_mount+0x53a/0x7d0 [btrfs]
    [<ffffffff811a3ae3>] mount_fs+0x43/0x1b0
    [<ffffffff811bfa66>] vfs_kern_mount+0x76/0x120
    [<ffffffff811c1d87>] do_mount+0x237/0xa70
    [<ffffffff811c2650>] SyS_mount+0x90/0xe0
    [<ffffffff8177ef12>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8806b3cf22b0 (size 16):
  comm "mount", pid 20697, jiffies 4295160287 (age 1117.544s)
  hex dump (first 16 bytes):
    66 65 61 74 75 72 65 73 00 6b 6b 6b 6b 6b 6b a5  features.kkkkkk.
  backtrace:
    [<ffffffff8175f606>] kmemleak_alloc+0x26/0x50
    [<ffffffff8119061b>] __kmalloc_track_caller+0x1cb/0x240
    [<ffffffff81157102>] kstrdup+0x42/0x70
    [<ffffffff81219271>] sysfs_new_dirent+0x31/0x130
    [<ffffffff812196e2>] create_dir+0x42/0xd0
    [<ffffffff81219a0f>] sysfs_create_subdir+0x1f/0x30
    [<ffffffff8121b51e>] internal_create_group+0x5e/0x270
    [<ffffffff8121b763>] sysfs_create_group+0x13/0x20
    [<ffffffffa06adb07>] btrfs_sysfs_add_one+0xa7/0x1b0 [btrfs]
    [<ffffffffa0693792>] open_ctree+0x17d2/0x21f0 [btrfs]
    [<ffffffffa066983a>] btrfs_mount+0x53a/0x7d0 [btrfs]
    [<ffffffff811a3ae3>] mount_fs+0x43/0x1b0
    [<ffffffff811bfa66>] vfs_kern_mount+0x76/0x120
    [<ffffffff811c1d87>] do_mount+0x237/0xa70
    [<ffffffff811c2650>] SyS_mount+0x90/0xe0
    [<ffffffff8177ef12>] system_call_fastpath+0x16/0x1b
unreferenced object 0xffff880096825310 (size 160):
  comm "mount", pid 20697, jiffies 4295160287 (age 1117.648s)
  hex dump (first 32 bytes):
    03 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff8175f606>] kmemleak_alloc+0x26/0x50
    [<ffffffff8118f294>] kmem_cache_alloc+0x114/0x200
    [<ffffffff81219291>] sysfs_new_dirent+0x51/0x130
    [<ffffffff812196e2>] create_dir+0x42/0xd0
    [<ffffffff81219a0f>] sysfs_create_subdir+0x1f/0x30
    [<ffffffff8121b51e>] internal_create_group+0x5e/0x270
    [<ffffffff8121b763>] sysfs_create_group+0x13/0x20
    [<ffffffffa06adb07>] btrfs_sysfs_add_one+0xa7/0x1b0 [btrfs]
    [<ffffffffa0693792>] open_ctree+0x17d2/0x21f0 [btrfs]
    [<ffffffffa066983a>] btrfs_mount+0x53a/0x7d0 [btrfs]
    [<ffffffff811a3ae3>] mount_fs+0x43/0x1b0
    [<ffffffff811bfa66>] vfs_kern_mount+0x76/0x120
    [<ffffffff811c1d87>] do_mount+0x237/0xa70
    [<ffffffff811c2650>] SyS_mount+0x90/0xe0
    [<ffffffff8177ef12>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff880096824b70 (size 160):
  comm "mount", pid 20697, jiffies 4295160287 (age 1117.648s)
  hex dump (first 32 bytes):
    01 00 00 00 00 00 00 00 b8 4d 72 a0 ff ff ff ff  .........Mr.....
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff8175f606>] kmemleak_alloc+0x26/0x50
    [<ffffffff8118f294>] kmem_cache_alloc+0x114/0x200
    [<ffffffff81219291>] sysfs_new_dirent+0x51/0x130
    [<ffffffff8121847a>] sysfs_add_file_mode+0x6a/0x110
    [<ffffffff8121b5a1>] internal_create_group+0xe1/0x270
    [<ffffffff8121b763>] sysfs_create_group+0x13/0x20
    [<ffffffffa06adb07>] btrfs_sysfs_add_one+0xa7/0x1b0 [btrfs]
    [<ffffffffa0693792>] open_ctree+0x17d2/0x21f0 [btrfs]
    [<ffffffffa066983a>] btrfs_mount+0x53a/0x7d0 [btrfs]
    [<ffffffff811a3ae3>] mount_fs+0x43/0x1b0
    [<ffffffff811bfa66>] vfs_kern_mount+0x76/0x120
    [<ffffffff811c1d87>] do_mount+0x237/0xa70
    [<ffffffff811c2650>] SyS_mount+0x90/0xe0
    [<ffffffff8177ef12>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff880096825128 (size 160):
  comm "mount", pid 20697, jiffies 4295160287 (age 1117.648s)
  hex dump (first 32 bytes):
    01 00 00 00 00 00 00 00 38 4f 72 a0 ff ff ff ff  ........8Or.....
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff8175f606>] kmemleak_alloc+0x26/0x50
    [<ffffffff8118f294>] kmem_cache_alloc+0x114/0x200
    [<ffffffff81219291>] sysfs_new_dirent+0x51/0x130
    [<ffffffff8121847a>] sysfs_add_file_mode+0x6a/0x110
    [<ffffffff8121b5a1>] internal_create_group+0xe1/0x270
    [<ffffffff8121b763>] sysfs_create_group+0x13/0x20
    [<ffffffffa06adb07>] btrfs_sysfs_add_one+0xa7/0x1b0 [btrfs]
    [<ffffffffa0693792>] open_ctree+0x17d2/0x21f0 [btrfs]
    [<ffffffffa066983a>] btrfs_mount+0x53a/0x7d0 [btrfs]
    [<ffffffff811a3ae3>] mount_fs+0x43/0x1b0
    [<ffffffff811bfa66>] vfs_kern_mount+0x76/0x120
    [<ffffffff811c1d87>] do_mount+0x237/0xa70
    [<ffffffff811c2650>] SyS_mount+0x90/0xe0
    [<ffffffff8177ef12>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff880758bbb6f8 (size 64):
  comm "mount", pid 20762, jiffies 4295160425 (age 1117.192s)
  hex dump (first 32 bytes):
    34 62 31 39 39 65 37 35 2d 30 62 31 32 2d 34 34  4b199e75-0b12-44
    64 39 2d 61 31 61 34 2d 31 32 39 31 66 37 63 30  d9-a1a4-1291f7c0
  backtrace:
    [<ffffffff8175f606>] kmemleak_alloc+0x26/0x50
    [<ffffffff8119061b>] __kmalloc_track_caller+0x1cb/0x240
    [<ffffffff81157102>] kstrdup+0x42/0x70
    [<ffffffff81219271>] sysfs_new_dirent+0x31/0x130
    [<ffffffff812196e2>] create_dir+0x42/0xd0
    [<ffffffff81219aa9>] sysfs_create_dir+0x89/0xe0
    [<ffffffff813e3416>] kobject_add_internal+0x96/0x210
    [<ffffffff813e37a3>] kobject_init_and_add+0x63/0x90
    [<ffffffffa06adadd>] btrfs_sysfs_add_one+0x7d/0x1b0 [btrfs]
    [<ffffffffa0693792>] open_ctree+0x17d2/0x21f0 [btrfs]
    [<ffffffffa066983a>] btrfs_mount+0x53a/0x7d0 [btrfs]
    [<ffffffff811a3ae3>] mount_fs+0x43/0x1b0
    [<ffffffff811bfa66>] vfs_kern_mount+0x76/0x120
    [<ffffffff811c1d87>] do_mount+0x237/0xa70
    [<ffffffff811c2650>] SyS_mount+0x90/0xe0
    [<ffffffff8177ef12>] system_call_fastpath+0x16/0x1b
unreferenced object 0xffff8806649361e8 (size 160):
  comm "mount", pid 20762, jiffies 4295160425 (age 1117.192s)
  hex dump (first 32 bytes):
    01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff8175f606>] kmemleak_alloc+0x26/0x50
    [<ffffffff8118f294>] kmem_cache_alloc+0x114/0x200
    [<ffffffff81219291>] sysfs_new_dirent+0x51/0x130
    [<ffffffff812196e2>] create_dir+0x42/0xd0
    [<ffffffff81219aa9>] sysfs_create_dir+0x89/0xe0
    [<ffffffff813e3416>] kobject_add_internal+0x96/0x210
    [<ffffffff813e37a3>] kobject_init_and_add+0x63/0x90
    [<ffffffffa06adadd>] btrfs_sysfs_add_one+0x7d/0x1b0 [btrfs]
    [<ffffffffa0693792>] open_ctree+0x17d2/0x21f0 [btrfs]
    [<ffffffffa066983a>] btrfs_mount+0x53a/0x7d0 [btrfs]
    [<ffffffff811a3ae3>] mount_fs+0x43/0x1b0
    [<ffffffff811bfa66>] vfs_kern_mount+0x76/0x120
    [<ffffffff811c1d87>] do_mount+0x237/0xa70
    [<ffffffff811c2650>] SyS_mount+0x90/0xe0
    [<ffffffff8177ef12>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8806b3cf32d0 (size 16):
  comm "mount", pid 20762, jiffies 4295160425 (age 1117.192s)
  hex dump (first 16 bytes):
    66 65 61 74 75 72 65 73 00 6b 6b 6b 6b 6b 6b a5  features.kkkkkk.
  backtrace:
    [<ffffffff8175f606>] kmemleak_alloc+0x26/0x50
    [<ffffffff8119061b>] __kmalloc_track_caller+0x1cb/0x240
    [<ffffffff81157102>] kstrdup+0x42/0x70
    [<ffffffff81219271>] sysfs_new_dirent+0x31/0x130
    [<ffffffff812196e2>] create_dir+0x42/0xd0
    [<ffffffff81219a0f>] sysfs_create_subdir+0x1f/0x30
    [<ffffffff8121b51e>] internal_create_group+0x5e/0x270
    [<ffffffff8121b763>] sysfs_create_group+0x13/0x20
    [<ffffffffa06adb07>] btrfs_sysfs_add_one+0xa7/0x1b0 [btrfs]
    [<ffffffffa0693792>] open_ctree+0x17d2/0x21f0 [btrfs]
    [<ffffffffa066983a>] btrfs_mount+0x53a/0x7d0 [btrfs]
    [<ffffffff811a3ae3>] mount_fs+0x43/0x1b0
    [<ffffffff811bfa66>] vfs_kern_mount+0x76/0x120
    [<ffffffff811c1d87>] do_mount+0x237/0xa70
    [<ffffffff811c2650>] SyS_mount+0x90/0xe0
    [<ffffffff8177ef12>] system_call_fastpath+0x16/0x1b
unreferenced object 0xffff8806649363d0 (size 160):
  comm "mount", pid 20762, jiffies 4295160425 (age 1117.272s)
  hex dump (first 32 bytes):
    03 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff8175f606>] kmemleak_alloc+0x26/0x50
    [<ffffffff8118f294>] kmem_cache_alloc+0x114/0x200
    [<ffffffff81219291>] sysfs_new_dirent+0x51/0x130
    [<ffffffff812196e2>] create_dir+0x42/0xd0
    [<ffffffff81219a0f>] sysfs_create_subdir+0x1f/0x30
    [<ffffffff8121b51e>] internal_create_group+0x5e/0x270
    [<ffffffff8121b763>] sysfs_create_group+0x13/0x20
    [<ffffffffa06adb07>] btrfs_sysfs_add_one+0xa7/0x1b0 [btrfs]
    [<ffffffffa0693792>] open_ctree+0x17d2/0x21f0 [btrfs]
    [<ffffffffa066983a>] btrfs_mount+0x53a/0x7d0 [btrfs]
    [<ffffffff811a3ae3>] mount_fs+0x43/0x1b0
    [<ffffffff811bfa66>] vfs_kern_mount+0x76/0x120
    [<ffffffff811c1d87>] do_mount+0x237/0xa70
    [<ffffffff811c2650>] SyS_mount+0x90/0xe0
    [<ffffffff8177ef12>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8806649378c8 (size 160):
  comm "mount", pid 20762, jiffies 4295160425 (age 1117.272s)
  hex dump (first 32 bytes):
    01 00 00 00 00 00 00 00 b8 4d 72 a0 ff ff ff ff  .........Mr.....
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff8175f606>] kmemleak_alloc+0x26/0x50
    [<ffffffff8118f294>] kmem_cache_alloc+0x114/0x200
    [<ffffffff81219291>] sysfs_new_dirent+0x51/0x130
    [<ffffffff8121847a>] sysfs_add_file_mode+0x6a/0x110
    [<ffffffff8121b5a1>] internal_create_group+0xe1/0x270
    [<ffffffff8121b763>] sysfs_create_group+0x13/0x20
    [<ffffffffa06adb07>] btrfs_sysfs_add_one+0xa7/0x1b0 [btrfs]
    [<ffffffffa0693792>] open_ctree+0x17d2/0x21f0 [btrfs]
    [<ffffffffa066983a>] btrfs_mount+0x53a/0x7d0 [btrfs]
    [<ffffffff811a3ae3>] mount_fs+0x43/0x1b0
    [<ffffffff811bfa66>] vfs_kern_mount+0x76/0x120
    [<ffffffff811c1d87>] do_mount+0x237/0xa70
    [<ffffffff811c2650>] SyS_mount+0x90/0xe0
    [<ffffffff8177ef12>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff



> ---
>  fs/btrfs/sysfs.c |  132 ++++++++++++++++++++++++++++++-------------------------
>  1 file changed, 72 insertions(+), 60 deletions(-)
>
> --- a/fs/btrfs/sysfs.c  2013-11-20 14:58:40.907456459 -0500
> +++ b/fs/btrfs/sysfs.c  2013-11-20 16:59:02.359951682 -0500
> @@ -417,28 +417,83 @@ static inline struct btrfs_fs_info *to_f
>         return container_of(kobj, struct btrfs_fs_info, super_kobj);
>  }
>
> -void btrfs_sysfs_remove_one(struct btrfs_fs_info *fs_info)
> +#define NUM_FEATURE_BITS 64
> +static char btrfs_unknown_feature_names[3][NUM_FEATURE_BITS][13];
> +static struct btrfs_feature_attr btrfs_feature_attrs[3][NUM_FEATURE_BITS];
> +
> +static u64 supported_feature_masks[3] = {
> +       [FEAT_COMPAT]    = BTRFS_FEATURE_COMPAT_SUPP,
> +       [FEAT_COMPAT_RO] = BTRFS_FEATURE_COMPAT_RO_SUPP,
> +       [FEAT_INCOMPAT]  = BTRFS_FEATURE_INCOMPAT_SUPP,
> +};
> +
> +static int addrm_unknown_feature_attrs(struct btrfs_fs_info *fs_info, bool add)
> +{
> +       int set;
> +
> +       for (set = 0; set < FEAT_MAX; set++) {
> +               int i;
> +               struct attribute *attrs[2];
> +               struct attribute_group agroup = {
> +                       .name = "features",
> +                       .attrs = attrs,
> +               };
> +               u64 features = get_features(fs_info, set);
> +               features &= ~supported_feature_masks[set];
> +
> +               if (!features)
> +                       continue;
> +
> +               attrs[1] = NULL;
> +               for (i = 0; i < NUM_FEATURE_BITS; i++) {
> +                       struct btrfs_feature_attr *fa;
> +
> +                       if (!(features & (1ULL << i)))
> +                               continue;
> +
> +                       fa = &btrfs_feature_attrs[set][i];
> +                       attrs[0] = &fa->kobj_attr.attr;
> +                       if (add) {
> +                               int ret;
> +                               ret = sysfs_merge_group(&fs_info->super_kobj,
> +                                                       &agroup);
> +                               if (ret)
> +                                       return ret;
> +                       } else
> +                               sysfs_unmerge_group(&fs_info->super_kobj,
> +                                                   &agroup);
> +               }
> +
> +       }
> +       return 0;
> +}
> +
> +static void __btrfs_sysfs_remove_one(struct btrfs_fs_info *fs_info)
>  {
> -       sysfs_remove_files(fs_info->space_info_kobj, allocation_attrs);
> -       kobject_del(fs_info->device_dir_kobj);
> -       kobject_put(fs_info->device_dir_kobj);
> -       kobject_del(fs_info->space_info_kobj);
> -       kobject_put(fs_info->space_info_kobj);
>         kobject_del(&fs_info->super_kobj);
>         kobject_put(&fs_info->super_kobj);
>         wait_for_completion(&fs_info->kobj_unregister);
>  }
>
> +void btrfs_sysfs_remove_one(struct btrfs_fs_info *fs_info)
> +{
> +       if (fs_info->space_info_kobj) {
> +               sysfs_remove_files(fs_info->space_info_kobj, allocation_attrs);
> +               kobject_del(fs_info->space_info_kobj);
> +               kobject_put(fs_info->space_info_kobj);
> +       }
> +       kobject_del(fs_info->device_dir_kobj);
> +       kobject_put(fs_info->device_dir_kobj);
> +       addrm_unknown_feature_attrs(fs_info, false);
> +       __btrfs_sysfs_remove_one(fs_info);
> +}
> +
>  const char * const btrfs_feature_set_names[3] = {
>         [FEAT_COMPAT]    = "compat",
>         [FEAT_COMPAT_RO] = "compat_ro",
>         [FEAT_INCOMPAT]  = "incompat",
>  };
>
> -#define NUM_FEATURE_BITS 64
> -static char btrfs_unknown_feature_names[3][NUM_FEATURE_BITS][13];
> -static struct btrfs_feature_attr btrfs_feature_attrs[3][NUM_FEATURE_BITS];
> -
>  char *btrfs_printable_features(enum btrfs_feature_set set, u64 flags)
>  {
>         size_t bufsize = 4096; /* safe max, 64 names * 64 bytes */
> @@ -508,53 +563,6 @@ static void init_feature_attrs(void)
>         }
>  }
>
> -static u64 supported_feature_masks[3] = {
> -       [FEAT_COMPAT]    = BTRFS_FEATURE_COMPAT_SUPP,
> -       [FEAT_COMPAT_RO] = BTRFS_FEATURE_COMPAT_RO_SUPP,
> -       [FEAT_INCOMPAT]  = BTRFS_FEATURE_INCOMPAT_SUPP,
> -};
> -
> -static int add_unknown_feature_attrs(struct btrfs_fs_info *fs_info)
> -{
> -       int set;
> -
> -       for (set = 0; set < FEAT_MAX; set++) {
> -               int i, count, ret, index = 0;
> -               struct attribute **attrs;
> -               struct attribute_group agroup = {
> -                       .name = "features",
> -               };
> -               u64 features = get_features(fs_info, set);
> -               features &= ~supported_feature_masks[set];
> -
> -               count = hweight64(features);
> -
> -               if (!count)
> -                       continue;
> -
> -               attrs = kcalloc(count + 1, sizeof(void *), GFP_KERNEL);
> -
> -               for (i = 0; i < NUM_FEATURE_BITS; i++) {
> -                       struct btrfs_feature_attr *fa;
> -
> -                       if (!(features & (1ULL << i)))
> -                               continue;
> -
> -                       fa = &btrfs_feature_attrs[set][i];
> -                       attrs[index++] = &fa->kobj_attr.attr;
> -               }
> -
> -               attrs[index] = NULL;
> -               agroup.attrs = attrs;
> -
> -               ret = sysfs_merge_group(&fs_info->super_kobj, &agroup);
> -               kfree(attrs);
> -               if (ret)
> -                       return ret;
> -       }
> -       return 0;
> -}
> -
>  static int add_device_membership(struct btrfs_fs_info *fs_info)
>  {
>         int error = 0;
> @@ -590,13 +598,17 @@ int btrfs_sysfs_add_one(struct btrfs_fs_
>         fs_info->super_kobj.kset = btrfs_kset;
>         error = kobject_init_and_add(&fs_info->super_kobj, &btrfs_ktype, NULL,
>                                      "%pU", fs_info->fsid);
> +       if (error)
> +               return error;
>
>         error = sysfs_create_group(&fs_info->super_kobj,
>                                    &btrfs_feature_attr_group);
> -       if (error)
> -               goto failure;
> +       if (error) {
> +               __btrfs_sysfs_remove_one(fs_info);
> +               return error;
> +       }
>
> -       error = add_unknown_feature_attrs(fs_info);
> +       error = addrm_unknown_feature_attrs(fs_info, true);
>         if (error)
>                 goto failure;
>
>
>
> --
> Jeff Mahoney
> SUSE Labs



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
