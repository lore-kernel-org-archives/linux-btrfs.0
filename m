Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58167 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1423889AbeBOQv0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Feb 2018 11:51:26 -0500
Date: Thu, 15 Feb 2018 17:49:07 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: fix endianness compatibility during the SB RW
Message-ID: <20180215164907.GD10193@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180212153749.19705-1-anand.jain@oracle.com>
 <20180213030046.14093-1-anand.jain@oracle.com>
 <358780ca-cb85-4de1-f849-3a642d3fc2c7@gmx.com>
 <500c44b5-0c99-100f-6a70-a79d3ad8a388@oracle.com>
 <20180213175510.GB3003@twin.jikos.cz>
 <5caed65c-79b1-5e12-78a0-47cffb220ca0@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <5caed65c-79b1-5e12-78a0-47cffb220ca0@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 14, 2018 at 10:53:19PM +0800, Anand Jain wrote:
> 
> 
> On 02/14/2018 01:55 AM, David Sterba wrote:
> > On Tue, Feb 13, 2018 at 06:27:13PM +0800, Anand Jain wrote:
> >> On 02/13/2018 05:01 PM, Qu Wenruo wrote:
> >>> On 2018年02月13日 11:00, Anand Jain wrote:
> >>>> Fixes the endianness bug in the fs_info::super_copy by using its
> >>>> btrfs_set_super...() function to set values in the SB, as these
> >>>> functions manage the endianness compatibility nicely.
> >>>>
> >>>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> >>>
> >>> Also went through all btrfs_super_block SETGET functions, greping using
> >>> \><member name>, seems that there are still some left here:
> >>>
> >>> fs/btrfs/sysfs.c:
> >>> In both btrfs_sectorsize_show() and btrfs_clone_alignment_show():
> >>> 	return snprintf(buf, PAGE_SIZE, "%u\n",
> >>> 			fs_info->super_copy->sectorsize);
> >>>
> >>> In btrfs_nodesize_show():
> >>> 	return snprintf(buf, PAGE_SIZE, "%u\n", fs_info->super_copy->nodesize);
> 
>   Thinking again on the printf they are fine without the endianness
>   functions, because it is printing the values from the memory to
>   buf/stdout, which was previously read from the disk (which
>   possibly written by the opposite endianness system). Here, there
>   is no endianness changes that will be required for it to be written
>   out using printf.

We need to fix the value for printf for the same reason this patch was
needed:

https://git.kernel.org/linus/bea7eafdbda3ba1d4b2ccb9cca829eefb7989bb9

and we can actually use the fs_info-> copies here too.
