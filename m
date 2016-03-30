Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20758 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804AbcC3KNv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Mar 2016 06:13:51 -0400
Subject: Re: [PATCH 11/12] btrfs: introduce helper functions to perform hot
 replace
To: kbuild test robot <lkp@intel.com>
References: <201603292247.9TrGyEIt%fengguang.wu@intel.com>
Cc: kbuild-all@01.org, linux-btrfs@vger.kernel.org, clm@fb.com,
        dsterba@suse.cz
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <56FBA6D7.90308@oracle.com>
Date: Wed, 30 Mar 2016 18:13:43 +0800
MIME-Version: 1.0
In-Reply-To: <201603292247.9TrGyEIt%fengguang.wu@intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Hi,

  You are missing the patch set which includes
    https://patchwork.kernel.org/patch/8659651/

  btrfs: refactor btrfs_dev_replace_start for reuse


Thanks, Anand


On 03/29/2016 10:45 PM, kbuild test robot wrote:
> Hi Anand,
>
> [auto build test ERROR on btrfs/next]
> [also build test ERROR on v4.6-rc1 next-20160329]
> [if your patch is applied to the wrong git tree, please drop us a note to help improving the system]
>
> url:    https://github.com/0day-ci/linux/commits/Anand-Jain/btrfs-Introduce-a-new-function-to-check-if-all-chunks-a-OK-for-degraded-mount/20160329-222724
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git next
> config: sparc64-allmodconfig (attached as .config)
> reproduce:
>          wget https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/sbin/make.cross -O ~/bin/make.cross
>          chmod +x ~/bin/make.cross
>          # save the attached .config to linux build tree
>          make.cross ARCH=sparc64
>
> All error/warnings (new ones prefixed by >>):
>
>     fs/btrfs/dev-replace.c: In function 'btrfs_auto_replace_start':
>>> fs/btrfs/dev-replace.c:962:8: warning: passing argument 2 of 'btrfs_dev_replace_start' from incompatible pointer type
>       ret = btrfs_dev_replace_start(root, tgt_path,
>             ^
>     fs/btrfs/dev-replace.c:308:5: note: expected 'struct btrfs_ioctl_dev_replace_args *' but argument is of type 'char *'
>      int btrfs_dev_replace_start(struct btrfs_root *root,
>          ^
>>> fs/btrfs/dev-replace.c:962:8: error: too many arguments to function 'btrfs_dev_replace_start'
>       ret = btrfs_dev_replace_start(root, tgt_path,
>             ^
>     fs/btrfs/dev-replace.c:308:5: note: declared here
>      int btrfs_dev_replace_start(struct btrfs_root *root,
>          ^
>
> vim +/btrfs_dev_replace_start +962 fs/btrfs/dev-replace.c
>
>     956		if (btrfs_get_spare_device(&tgt_path)) {
>     957			btrfs_err(root->fs_info,
>     958				"No spare device found/configured in the kernel");
>     959			return -EINVAL;
>     960		}
>     961	
>   > 962		ret = btrfs_dev_replace_start(root, tgt_path,
>     963						src_device->devid,
>     964						rcu_str_deref(src_device->name),
>     965			BTRFS_IOCTL_DEV_REPLACE_CONT_READING_FROM_SRCDEV_MODE_AVOID);
>
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
>
