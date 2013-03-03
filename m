Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:33586 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752946Ab3CCMAY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 3 Mar 2013 07:00:24 -0500
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 865969A0403
	for <linux-btrfs@vger.kernel.org>; Sun,  3 Mar 2013 05:00:24 -0700 (MST)
Date: Sun, 3 Mar 2013 07:00:21 -0500
From: Chris Mason <chris.mason@fusionio.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Chris Mason <clmason@fusionio.com>, David Sterba <dsterba@suse.cz>,
        Josef Bacik <JBacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] btrfs/raid56: Add missing #include <linux/vmalloc.h>
Message-ID: <20130303120021.GA18135@shiny.masoncoding.com>
References: <1362311081-10145-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1362311081-10145-1-git-send-email-geert@linux-m68k.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Mar 03, 2013 at 04:44:41AM -0700, Geert Uytterhoeven wrote:
> tilegx_defconfig:
> 
> fs/btrfs/raid56.c: In function 'btrfs_alloc_stripe_hash_table':
> fs/btrfs/raid56.c:206:3: error: implicit declaration of function 'vzalloc' [-Werror=implicit-function-declaration]
> fs/btrfs/raid56.c:206:9: warning: assignment makes pointer from integer without a cast [enabled by default]
> fs/btrfs/raid56.c:226:4: error: implicit declaration of function 'vfree' [-Werror=implicit-function-declaration]

Thanks, I've got this one in my for-linus now.  It'll go with the next
pull.

-chris
