Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:24673 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751487AbcLHQxz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Dec 2016 11:53:55 -0500
Date: Thu, 8 Dec 2016 08:53:47 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Xin Zhou <xin.zhou@gmx.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/6] btrfs dax IO
Message-ID: <20161208165347.GC20111@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <trinity-f6bd31da-24aa-4876-bde0-fe5b26b1af92-1481179495753@3capp-mailcom-bs01>
 <trinity-1b4598b4-93e0-4762-90a6-d2f7aadc7dd2-1481179698241@3capp-mailcom-bs01>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <trinity-1b4598b4-93e0-4762-90a6-d2f7aadc7dd2-1481179698241@3capp-mailcom-bs01>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 08, 2016 at 07:48:18AM +0100, Xin Zhou wrote:
> Hi Liu,
>  
> From the patch, is the snapshot disabled by disabling the COW in the mounting path?
> It seems the create_snapshot() in ioctl.c does not get changed.

Well, I think I made a mistake in this cover letter, snapshot still
works while mounting with dax, but if a snapshot is taken, then we'll
get -EIO while writing to dax inodes that belong to either snapshot tree
or its source tree.  So in fact, only a readonly snapshot makes sense in
practice, I'll update the patch so that we only allow a readonly
snapshot to be taken.

COW is disabled by letting the dax mount option imply the "nodatacow"
option.

Thanks for spotting this!

Thanks,

-liubo

> 
> I experienced some similar system but am a bit new to the brtfs code.
>   
> Thanks, 
> Xin
>  
>  
> 
> Subject: [PATCH 0/6] btrfs dax IOFrom: Liu Bo <bo.li.liu@xxxxxxxxxx>Date: Wed, 7 Dec 2016 13:45:04 -0800Cc: Chris Mason <clm@xxxxxx>, Jan Kara <jack@xxxxxxx>, David Sterba <dsterba@xxxxxxx>
> This is a prelimanary patch set to add dax support for btrfs, with
> this we can do normal read/write to dax files and can mmap dax files
> to userspace so that applications have the ability to access
> persistent memory directly.
> 
> Please note that currently this is limited to nocow, i.e. all dax
> inodes do not have COW behaviour.
> 
> COW:   	    	     	no
> mutliple device:	no
> clone/reflink:		no
> snapshot:		no
> compression:		no
> checksum:		no
> 
> Right now snapshot is disabled while mounting with -odax, but snapshot
> can be created without -odax, and writing to a dax file in snapshot
> will get -EIO.
> 
> Clone/reflink is dealt with as same as snapshot, -EIO will be returned
> when writing to shared extents.
> 
> This has adopted the latest iomap framework for dax read/write
> and dax mmap.
> 
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
