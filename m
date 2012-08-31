Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:47642 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753969Ab2HaPBn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 31 Aug 2012 11:01:43 -0400
Date: Fri, 31 Aug 2012 11:01:40 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Fengguang Wu <fengguang.wu@intel.com>
CC: Liu Bo <bo.li.liu@oracle.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Josef Bacik <JBacik@fusionio.com>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: Re: [josef-btrfs:master 29/29] fs/btrfs/backref.c:1586:2: error:
 implicit declaration of function 'vmalloc'
Message-ID: <20120831150140.GA4299@localhost.localdomain>
References: <5040ce74.VuqXa16Lv90yevGM%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <5040ce74.VuqXa16Lv90yevGM%fengguang.wu@intel.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 31, 2012 at 08:47:16AM -0600, Fengguang Wu wrote:
> Hi Liu,
> 
> FYI, kernel build failed on
> 
> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/josef/btrfs-next.git master
> head:   8ccfefeea39d6ee32ad312b1fd3b8eeb19de9265
> commit: 8ccfefeea39d6ee32ad312b1fd3b8eeb19de9265 [29/29] Btrfs: use larger limit for translation of logical to inode
> config: x86_64-randconfig-h842 (attached as .config)
> 
> All related error/warning messages:
> 
> fs/btrfs/backref.c: In function 'init_data_container':
> fs/btrfs/backref.c:1586:2: error: implicit declaration of function 'vmalloc' [-Werror=implicit-function-declaration]
> fs/btrfs/backref.c:1586:7: warning: assignment makes pointer from integer without a cast [enabled by default]
> cc1: some warnings being treated as errors
> 
> vim +1586 fs/btrfs/backref.c
>   1583		size_t alloc_bytes;
>   1584	
>   1585		alloc_bytes = max_t(size_t, total_bytes, sizeof(*data));
> > 1586		data = vmalloc(alloc_bytes);
>   1587		if (!data)
>   1588			return ERR_PTR(-ENOMEM);
>   1589	
>

Good lord Fengguang I just pushed that out 45 minutes ago.  I will fix and push
it out, thanks!

Josef
