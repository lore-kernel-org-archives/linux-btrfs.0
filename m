Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34629 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933555AbeFTW2H (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Jun 2018 18:28:07 -0400
Date: Thu, 21 Jun 2018 00:25:14 +0200
From: David Sterba <dsterba@suse.cz>
To: kbuild test robot <lkp@intel.com>
Cc: Bart Van Assche <bart.vanassche@wdc.com>, kbuild-all@01.org,
        Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        Jeff Mahoney <jeffm@suse.com>, Nikolay Borisov <nborisov@suse.com>
Subject: Re: [PATCH v2 3/3] btrfs: Fix a C compliance issue
Message-ID: <20180620222514.GI24375@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180620170333.29182-4-bart.vanassche@wdc.com>
 <201806210418.Lo0PzrKr%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201806210418.Lo0PzrKr%fengguang.wu@intel.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 21, 2018 at 05:16:06AM +0800, kbuild test robot wrote:
> Hi Bart,
> 
> I love your patch! Yet something to improve:
> 
> [auto build test ERROR on v4.18-rc1]
> [also build test ERROR on next-20180620]
> [cannot apply to btrfs/next]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
> 
> url:    https://github.com/0day-ci/linux/commits/Bart-Van-Assche/Three-patches-that-address-static-analyzer-reports/20180621-041247
> config: m68k-sun3_defconfig (attached as .config)
> compiler: m68k-linux-gnu-gcc (Debian 7.2.0-11) 7.2.0
> reproduce:
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # save the attached .config to linux build tree
>         GCC_VERSION=7.2.0 make.cross ARCH=m68k 
> 
> All errors (new ones prefixed by >>):
> 
>    fs//btrfs/super.c: In function 'btrfs_print_mod_info':
> >> fs//btrfs/super.c:2386:4: error: expected expression before ';' token
>        ;
>        ^

That's probably because none of the config option is turned on and this
results to

	const char options[] = ;

but a "" should fix it.
