Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:42131 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756522Ab2HNPLd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Aug 2012 11:11:33 -0400
Message-ID: <502A6A9E.2090905@oracle.com>
Date: Tue, 14 Aug 2012 23:11:26 +0800
From: Liu Bo <bo.li.liu@oracle.com>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [RFC] [PATCH] Btrfs: manage metadata cache ourselves
References: <1343855205-25043-1-git-send-email-jbacik@fusionio.com>
In-Reply-To: <1343855205-25043-1-git-send-email-jbacik@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/02/2012 05:06 AM, Josef Bacik wrote:
> ===================================
> PLEASE REVIEW AND TEST THIS CAREFULLY
> 
> I've dug this patch out of the bin and cleaned it up but who knows what kind of
> crust I've missed.  This makes the create empty files until the file system is
> full run 5 minutes faster on my hardware so it's a pretty awesome improvement,
> plus it lets us get rid of a lot of complexity.  I think it works pretty well,
> and I've been going through and widdling it down, but now I need somebody
> *cough*Dave*cough* to go through it with a fine toothed comb and point out all
> the stupid mistakes I've made.
> 
> ===================================
> This patch moves the management of the metadata cache from pagecache to our own
> internal caching which can choose to evict things based on what is no longer in
> use.  Thanks,
> 


I'll try to look into the patch :)

but slab complains about memory leak on extent buffer with this patch on latest 3.6.0-rc1:

[14856.442224] BUG extent_buffers (Tainted: G           O): Objects remaining on kmem_cache_close()
[14856.442224] -----------------------------------------------------------------------------
[14856.442224] 
[14856.442225] INFO: Slab 0xffffea000405d980 objects=22 used=12 fp=0xffff8801017673b0 flags=0x40000000004080
[14856.442226] Pid: 29913, comm: rmmod Tainted: G           O 3.6.0-rc1+ #6
[14856.442227] Call Trace:
[14856.442229]  [<ffffffff81174341>] slab_err+0x91/0xc0
[14856.442230]  [<ffffffff8117729c>] ? __kmalloc+0x14c/0x1b0
[14856.442232]  [<ffffffff81176bb0>] ? deactivate_slab+0x580/0x580
[14856.442233]  [<ffffffff811777d3>] list_slab_objects.constprop.22+0x63/0x170
[14856.442234]  [<ffffffff81178c58>] kmem_cache_destroy+0x108/0x1f0
[14856.442242]  [<ffffffffa062baa4>] extent_io_exit+0x54/0x100 [btrfs]
[14856.442250]  [<ffffffffa066f8c4>] exit_btrfs_fs+0x18/0x754 [btrfs]
[14856.442252]  [<ffffffff810bd796>] sys_delete_module+0x1a6/0x2b0
[14856.442254]  [<ffffffff810d7ecc>] ? __audit_syscall_entry+0xcc/0x310
[14856.442255]  [<ffffffff81618329>] system_call_fastpath+0x16/0x1b
[14856.442258] INFO: Object 0xffff880101766000 @offset=0
[14856.442258] INFO: Object 0xffff880101766168 @offset=360
[14856.442259] INFO: Object 0xffff8801017662d0 @offset=720
[14856.442260] INFO: Object 0xffff8801017665a0 @offset=1440
[14856.442260] INFO: Object 0xffff8801017669d8 @offset=2520
[14856.442261] INFO: Object 0xffff880101766b40 @offset=2880
[14856.442262] INFO: Object 0xffff880101766ca8 @offset=3240
[14856.442262] INFO: Object 0xffff880101766e10 @offset=3600
[14856.442263] INFO: Object 0xffff880101766f78 @offset=3960
[14856.442264] INFO: Object 0xffff880101767518 @offset=5400
[14856.442264] INFO: Object 0xffff8801017677e8 @offset=6120
[14856.442265] INFO: Object 0xffff880101767ab8 @offset=6840

thanks,
liubo
