Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:27353 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548Ab2IUE5f (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Sep 2012 00:57:35 -0400
Message-ID: <505BF3BC.1030304@giantdisaster.de>
Date: Fri, 21 Sep 2012 06:57:32 +0200
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Marc MERLIN <marc@merlins.org>
CC: linux-btrfs@vger.kernel.org
Subject: Re: kernel BUG at fs/btrfs/extent_io.c:1884!
References: <20120920171747.GG26105@merlins.org> <20120921034652.GA871@merlins.org>
In-Reply-To: <20120921034652.GA871@merlins.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/21/2012 05:46, Marc MERLIN wrote:
> Oh my, now I'm trying again with a new drive, and a big cp from an
> existing array to a new one dies with:
> [32042.079411] ------------[ cut here ]------------
> [32042.085799] kernel BUG at fs/btrfs/extent_io.c:1884!
> [32042.092528] invalid opcode: 0000 [#1] PREEMPT SMP
> [32042.099227] CPU 1
> [32042.101095] Modules linked in:[32042.105950]  raid456 async_raid6_recov async
> _pq raid6_pq async_xor xor async_memcpy async_tx ppdev lp tun autofs4 kl5kusb105
>   ftdi_sio keyspan nfsd nfs lockd fscache auth_rpcgss nfs_acl sunrpc rc_ati_x10 s
> nd_timer i915 usbserial snd drm_kms_helper eeepc_wmi drm ati_remote asus_wmi rc_
> core sparse_keymap
>
>      int repair_io_failure(struct btrfs_mapping_tree *map_tree, u64 start,
> 			    u64 length, u64 logical, struct page *page,
> 			    int mirror_num)
>      {
> 	    struct bio *bio;
> 	    struct btrfs_device *dev;
> 	    DECLARE_COMPLETION_ONSTACK(compl);
> 	    u64 map_length = 0;
> 	    u64 sector;
> 	    struct btrfs_bio *bbio = NULL;
> 	    int ret;
>
> 	    BUG_ON(!mirror_num); <<<<<
>

This was fixed with commit c0901581ad077004145c9ee80e843fba71c100b8 and 
is included in Linux 3.6 RC1.
