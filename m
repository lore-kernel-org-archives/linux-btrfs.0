Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:23680 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753643Ab2IUDxe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Sep 2012 23:53:34 -0400
Message-ID: <505BE4AF.60809@oracle.com>
Date: Fri, 21 Sep 2012 11:53:19 +0800
From: Liu Bo <bo.li.liu@oracle.com>
MIME-Version: 1.0
To: Marc MERLIN <marc@merlins.org>
CC: linux-btrfs@vger.kernel.org
Subject: Re: kernel BUG at fs/btrfs/extent_io.c:1884!
References: <20120920171747.GG26105@merlins.org> <20120921034652.GA871@merlins.org>
In-Reply-To: <20120921034652.GA871@merlins.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/21/2012 11:46 AM, Marc MERLIN wrote:
> On Thu, Sep 20, 2012 at 10:17:47AM -0700, Marc MERLIN wrote:
>> I had a btrfs built on top of 5 drives (dmcrypt devices).
>>
>> The drive then died while I was writing to the filesystem and my system
>> crashed and rebooted:
>>
>> [384555.534020] sd 10:0:0:0: rejecting I/O to offline device                    
>> [384555.535057] sd 10:0:0:0: rejecting I/O to offline device                    
>> [384556.666885] ------------[ cut here ]------------                            
>> [384556.667909] sd 10:0:0:0: [sdj] Synchronizing SCSI cache                     
>> [384556.677509] kernel BUG at fs/btrfs/ctree.c:3451!                            
>> [384556.682551] invalid opcode: 0000 [#1] PREEMPT SMP                           
>> [384556.687878] CPU 2                                                           
>>
>  
> Oh my, now I'm trying again with a new drive, and a big cp from an
> existing array to a new one dies with:
> [32042.079411] ------------[ cut here ]------------                             
> [32042.085799] kernel BUG at fs/btrfs/extent_io.c:1884!                         
> [32042.092528] invalid opcode: 0000 [#1] PREEMPT SMP                            
> [32042.099227] CPU 1                                                            
> [32042.101095] Modules linked in:[32042.105950]  raid456 async_raid6_recov async
> _pq raid6_pq async_xor xor async_memcpy async_tx ppdev lp tun autofs4 kl5kusb105
>  ftdi_sio keyspan nfsd nfs lockd fscache auth_rpcgss nfs_acl sunrpc rc_ati_x10 s
> nd_timer i915 usbserial snd drm_kms_helper eeepc_wmi drm ati_remote asus_wmi rc_
> core sparse_keymap    
> 
>     int repair_io_failure(struct btrfs_mapping_tree *map_tree, u64 start,
> 			    u64 length, u64 logical, struct page *page,
> 			    int mirror_num)
>     {
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
> This is more of a problem since I can't backup my filesystem (source is
> ext4 and destination is btrfs).
> 
> Any suggestion on what went wrong here?
> 

Could you please show us the complete stack info?

thanks,
liubo

> Thanks,
> Marc
> 

