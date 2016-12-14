Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36119 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753255AbcLNMiV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Dec 2016 07:38:21 -0500
Date: Wed, 14 Dec 2016 13:38:01 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, linux-btrfs@vger.kernel.org,
        dsterba@suse.com
Subject: Re: [PATCH 2/2] btrfs-convert: Fix migrate_super_block() to work
 with 64k sectorsize
Message-ID: <20161214123801.GB3620@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1481205380-22978-1-git-send-email-chandan@linux.vnet.ibm.com>
 <1481205380-22978-2-git-send-email-chandan@linux.vnet.ibm.com>
 <c861f566-09fd-3f41-ddfa-da5a9d08c04b@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <c861f566-09fd-3f41-ddfa-da5a9d08c04b@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 09, 2016 at 09:09:29AM +0800, Qu Wenruo wrote:
> 
> 
> At 12/08/2016 09:56 PM, Chandan Rajendra wrote:
> > migrate_super_block() uses sectorsize to refer to the size of the
> > superblock. Hence on 64k sectorsize filesystems, it ends up computing
> > checksum beyond the super block length (i.e.
> > BTRFS_SUPER_INFO_SIZE). This commit fixes the bug by using
> > BTRFS_SUPER_INFO_SIZE instead of sectorsize of the underlying
> > filesystem.
> >
> > Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> 
> Reviewed-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Applied, thanks.
