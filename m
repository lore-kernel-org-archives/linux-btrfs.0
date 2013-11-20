Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:19061 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751510Ab3KTEGH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Nov 2013 23:06:07 -0500
Date: Wed, 20 Nov 2013 12:05:51 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Kees Cook <keescook@chromium.org>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: fs/btrfs/extent-tree.c:8430:9: error: format not a string
 literal and no format arguments
Message-ID: <20131120040551.GB4201@localhost>
References: <528c09f9.S0ecVwNN2c+fnUkv%fengguang.wu@intel.com>
 <CAGXu5jLoG00u2svBW6W5h9QsfYw1zZwYhZ1k4HG2UsvcWPHxuQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAGXu5jLoG00u2svBW6W5h9QsfYw1zZwYhZ1k4HG2UsvcWPHxuQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 19, 2013 at 07:56:35PM -0800, Kees Cook wrote:
> Hi!
> 
> Which tree is 'devel-snb'? I don't see that on the kernel.org trees.

It's my local merge branch, based on the latest upstream release.

Let's CC the btrfs developers for this warning. :)

Thanks,
Fengguang

> On Tue, Nov 19, 2013 at 5:01 PM, kbuild test robot
> <fengguang.wu@intel.com> wrote:
> > tree:    devel-snb-x86_64-201311200240
> > head:   1a985a0807ea34f37a4c5287089abd1cd2f65049
> > commit: a9b93a3684dd6ebfb7cfa173f78a79c09de81207 Merge 'kees/format-security' into devel-snb-x86_64-201311200240
> > date:   6 hours ago
> > config: make ARCH=x86_64 allmodconfig
> >
> > All error/warnings:
> >
> >    fs/btrfs/extent-tree.c:6201:12: sparse: symbol 'get_raid_name' was not declared. Should it be static?
> >    fs/btrfs/extent-tree.c:2469:28: sparse: context imbalance in 'run_clustered_refs' - unexpected unlock
> >    fs/btrfs/extent-tree.c:8304:9: sparse: context imbalance in 'btrfs_put_block_group_cache' - wrong count at exit
> >    fs/btrfs/extent-tree.c: In function '__link_block_group':
> >>> fs/btrfs/extent-tree.c:8430:9: error: format not a string literal and no format arguments [-Werror=format-security]
> >             get_raid_name(index));
> >             ^
> >    cc1: some warnings being treated as errors
> >
> > vim +8430 fs/btrfs/extent-tree.c
> >
> >   8414          return 0;
> >   8415  }
> >   8416
> >   8417  static void __link_block_group(struct btrfs_space_info *space_info,
> >   8418                                 struct btrfs_block_group_cache *cache)
> >   8419  {
> >   8420          int index = get_block_group_index(cache);
> >   8421
> >   8422          down_write(&space_info->groups_sem);
> >   8423          if (list_empty(&space_info->block_groups[index])) {
> >   8424                  struct kobject *kobj = &space_info->block_group_kobjs[index];
> >   8425                  int ret;
> >   8426
> >   8427                  kobject_get(&space_info->kobj); /* put in release */
> >   8428                  ret = kobject_init_and_add(kobj, &btrfs_raid_ktype,
> >   8429                                             &space_info->kobj,
> >> 8430                                             get_raid_name(index));
> >   8431                  if (ret) {
> >   8432                          pr_warn("btrfs: failed to add kobject for block cache. ignoring.\n");
> >   8433                          kobject_put(&space_info->kobj);
> >   8434                  }
> >   8435          }
> >   8436          list_add_tail(&cache->list, &space_info->block_groups[index]);
> >   8437          up_write(&space_info->groups_sem);
> >   8438  }
> >
> > ---
> > 0-DAY kernel build testing backend              Open Source Technology Center
> > http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
> 
> 
> 
> -- 
> Kees Cook
> Chrome OS Security
