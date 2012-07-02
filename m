Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:56355 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750909Ab2GBMtB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 2 Jul 2012 08:49:01 -0400
Date: Mon, 2 Jul 2012 08:48:58 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Martin Ziegler <ziegler@uni-freiburg.de>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: kmem_cache_destroy called for cache that still has objects
Message-ID: <20120702124858.GB6185@localhost.localdomain>
References: <alpine.DEB.2.02.1207021300430.16800@zertz.mathematik.uni-freiburg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <alpine.DEB.2.02.1207021300430.16800@zertz.mathematik.uni-freiburg.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 02, 2012 at 05:06:27AM -0600, Martin Ziegler wrote:
> When I umounted my USB-disk today, I got the following 
> message:
> 
> FSSync '/usb'
> =============================================================================
> BUG btrfs_transaction_cache (Tainted: G        W   ):
>   Objects remaining on kmem_cache_close()
> -----------------------------------------------------------------------------
> 
> INFO: Slab 0xffffea00001c7580 objects=27 used=1
>   fp=0xffff8800071d7e10 flags=0x4000000000004080
> INFO: Object 0xffff8800071d6250 @offset=592
> SLUB btrfs_transaction_cache: kmem_cache_destroy called for
>   cache that still has objects.
> 
> 
> This had no bad consequences (I hope), but may interest the 
> developers. The kernel is
> 
> Linux zertz 3.5.0-rc4+ #278 SMP Thu Jun 28 21:17:37 CEST 
> 2012 x86_64 GNU/Linux.
> 

Did you have an aborted transaction or anything, any other errors in your dmesg?
Thanks,

Josef
