Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45433 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752303AbcEKAAz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 May 2016 20:00:55 -0400
Date: Tue, 10 May 2016 17:00:53 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Subject: Re: [PATCH v10 02/21] btrfs: dedupe: Introduce function to
 initialize dedupe info
Message-ID: <20160511000053.GE7633@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <1459492512-31435-3-git-send-email-quwenruo@cn.fujitsu.com>
 <201604011730.6UVg1lC7%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201604011730.6UVg1lC7%fengguang.wu@intel.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 01, 2016 at 05:59:13PM +0800, kbuild test robot wrote:
> Hi Wang,
> 
> [auto build test ERROR on btrfs/next]
> [also build test ERROR on v4.6-rc1 next-20160401]
> [if your patch is applied to the wrong git tree, please drop us a note to help improving the system]
> 
> url:    https://github.com/0day-ci/linux/commits/Qu-Wenruo/Btrfs-dedupe-framework/20160401-143937
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git next
> config: x86_64-rhel (attached as .config)
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=x86_64 
> 
> Note: the linux-review/Qu-Wenruo/Btrfs-dedupe-framework/20160401-143937 HEAD 0a445f5009c064ee1d3fc966e41bb75627594afe builds fine.
>       It only hurts bisectibility.
> 
> All errors (new ones prefixed by >>):
> 
> >> ERROR: "btrfs_dedupe_disable" [fs/btrfs/btrfs.ko] undefined!
> 
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

Please correct this, we need to be able to bisect a kernel without random
patches breaking the build.
	--Mark

--
Mark Fasheh
