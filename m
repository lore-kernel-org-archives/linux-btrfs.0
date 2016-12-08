Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:52558 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751681AbcLHGsU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 8 Dec 2016 01:48:20 -0500
MIME-Version: 1.0
Message-ID: <trinity-1b4598b4-93e0-4762-90a6-d2f7aadc7dd2-1481179698241@3capp-mailcom-bs01>
From: "Xin Zhou" <xin.zhou@gmx.com>
To: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/6] btrfs dax IO
Content-Type: text/plain; charset=UTF-8
Date: Thu, 8 Dec 2016 07:48:18 +0100
In-Reply-To: <trinity-f6bd31da-24aa-4876-bde0-fe5b26b1af92-1481179495753@3capp-mailcom-bs01>
References: <trinity-f6bd31da-24aa-4876-bde0-fe5b26b1af92-1481179495753@3capp-mailcom-bs01>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Liu,
 
>From the patch, is the snapshot disabled by disabling the COW in the mounting path?
It seems the create_snapshot() in ioctl.c does not get changed.

I experienced some similar system but am a bit new to the brtfs code.
  
Thanks, 
Xin
 
 

Subject: [PATCH 0/6] btrfs dax IOFrom: Liu Bo <bo.li.liu@xxxxxxxxxx>Date: Wed, 7 Dec 2016 13:45:04 -0800Cc: Chris Mason <clm@xxxxxx>, Jan Kara <jack@xxxxxxx>, David Sterba <dsterba@xxxxxxx>
This is a prelimanary patch set to add dax support for btrfs, with
this we can do normal read/write to dax files and can mmap dax files
to userspace so that applications have the ability to access
persistent memory directly.

Please note that currently this is limited to nocow, i.e. all dax
inodes do not have COW behaviour.

COW:   	    	     	no
mutliple device:	no
clone/reflink:		no
snapshot:		no
compression:		no
checksum:		no

Right now snapshot is disabled while mounting with -odax, but snapshot
can be created without -odax, and writing to a dax file in snapshot
will get -EIO.

Clone/reflink is dealt with as same as snapshot, -EIO will be returned
when writing to shared extents.

This has adopted the latest iomap framework for dax read/write
and dax mmap.

 
