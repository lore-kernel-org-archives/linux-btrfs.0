Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44148 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752015AbeAESQJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 5 Jan 2018 13:16:09 -0500
Date: Fri, 5 Jan 2018 19:14:01 +0100
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3] Btrfs: avoid losing data raid profile when deleting a
 device
Message-ID: <20180105181401.GS3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171010175305.31633-1-bo.li.liu@oracle.com>
 <20171115232811.9756-1-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171115232811.9756-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 15, 2017 at 04:28:11PM -0700, Liu Bo wrote:
> We've avoided data losing raid profile when doing balance, but it
> turns out that deleting a device could also result in the same
> problem.
> 
> Say we have 3 disks, and they're created with '-d raid1' profile.
> 
> - We have chunk P (the only data chunk on the empty btrfs).
> 
> - Suppose that chunk P's two raid1 copies reside in disk A and disk B.
> 
> - Now, 'btrfs device remove disk B'
>          btrfs_rm_device()
> 	   -> btrfs_shrink_device()
> 	      -> btrfs_relocate_chunk() #relocate any chunk on disk B
> 	      	 			 to other places.
> 
> - Chunk P will be removed and a new chunk will be created to hold
>   those data, but as chunk P is the only one holding raid1 profile,
>   after it goes away, the new chunk will be created as single profile
>   which is our default profile.
> 
> This fixes the problem by creating an empty data chunk before
> relocating the data chunk.
> 
> Metadata/System chunk are supposed to have non-zero bytes all the time
> so their raid profile is preserved.
> 
> Reported-by: James Alandt <James.Alandt@wdc.com>
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Added to 4.16 queue, thanks.
