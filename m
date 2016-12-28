Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44589 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751105AbcL1Iv1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Dec 2016 03:51:27 -0500
Date: Wed, 28 Dec 2016 09:51:17 +0100
From: Michal Hocko <mhocko@kernel.org>
To: kbuild test robot <lkp@intel.com>
Cc: kbuild-all@01.org, Nils Holland <nholland@tisys.org>,
        Mel Gorman <mgorman@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.cz>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] mm, vmscan: consider eligible zones in get_scan_count
Message-ID: <20161228085116.GC11470@dhcp22.suse.cz>
References: <20161227155532.GI1308@dhcp22.suse.cz>
 <201612280000.aOluloG2%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201612280000.aOluloG2%fengguang.wu@intel.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed 28-12-16 00:28:38, kbuild test robot wrote:
> Hi Michal,
> 
> [auto build test ERROR on mmotm/master]
> [also build test ERROR on v4.10-rc1 next-20161224]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
> 
> url:    https://github.com/0day-ci/linux/commits/Michal-Hocko/mm-vmscan-consider-eligible-zones-in-get_scan_count/20161228-000917
> base:   git://git.cmpxchg.org/linux-mmotm.git master
> config: i386-tinyconfig (attached as .config)
> compiler: gcc-6 (Debian 6.2.0-3) 6.2.0 20160901
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=i386 
> 
> All errors (new ones prefixed by >>):
> 
>    mm/vmscan.c: In function 'lruvec_lru_size_zone_idx':
> >> mm/vmscan.c:264:10: error: implicit declaration of function 'lruvec_zone_lru_size' [-Werror=implicit-function-declaration]
>       size = lruvec_zone_lru_size(lruvec, lru, zid);

this patch depends on the previous one
http://lkml.kernel.org/r/20161226124839.GB20715@dhcp22.suse.cz
-- 
Michal Hocko
SUSE Labs
