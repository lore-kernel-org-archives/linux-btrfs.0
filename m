Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:37675 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1948803AbdEZWde (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 May 2017 18:33:34 -0400
Subject: Re: [PATCH 2/3 v2] btrfs: reduce arguments for decompress_bio ops
To: kbuild test robot <lkp@intel.com>
References: <201705262134.qiqSOktg%fengguang.wu@intel.com>
Cc: kbuild-all@01.org, linux-btrfs@vger.kernel.org, dsterba@suse.cz
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <fa81b0d9-71a1-d78b-b1bd-e983214e454a@oracle.com>
Date: Sat, 27 May 2017 06:39:22 +0800
MIME-Version: 1.0
In-Reply-To: <201705262134.qiqSOktg%fengguang.wu@intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 05/26/2017 10:07 PM, kbuild test robot wrote:
> Hi Anand,
>
> [auto build test ERROR on tip/perf/core]
> [also build test ERROR on v4.12-rc2 next-20170526]
> [cannot apply to btrfs/next]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
>
> url:    https://github.com/0day-ci/linux/commits/Anand-Jain/compression-ops-args-clean-up-and-trace-point/20170526-184159
> config: s390-default_defconfig (attached as .config)
> compiler: s390x-linux-gnu-gcc (Debian 6.1.1-9) 6.1.1 20160705
> reproduce:
>         wget https://raw.githubusercontent.com/01org/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # save the attached .config to linux build tree
>         make.cross ARCH=s390
>
> All errors (new ones prefixed by >>):
>
>    In file included from fs/btrfs/zlib.c:33:0:
>>> fs/btrfs/compression.h:39:2: error: unknown type name 'refcount_t'
>      refcount_t pending_bios;
>      ^~~~~~~~~~

  Ok . Thanks. Fixed this with.
     fixup: btrfs: reduce arguments for decompress_bio ops

-Anand


> vim +/refcount_t +39 fs/btrfs/compression.h
>
>     33	#define BTRFS_MAX_COMPRESSED		(SZ_128K)
>     34	/* Maximum size of data before compression */
>     35	#define BTRFS_MAX_UNCOMPRESSED		(SZ_128K)
>     36	
>     37	struct compressed_bio {
>     38		/* number of bios pending for this compressed extent */
>   > 39		refcount_t pending_bios;
>     40	
>     41		/* the pages with the compressed data on them */
>     42		struct page **compressed_pages;
>
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
>
