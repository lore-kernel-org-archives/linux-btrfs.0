Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45307 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752954AbcLAPXq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 1 Dec 2016 10:23:46 -0500
Date: Thu, 1 Dec 2016 16:23:41 +0100
From: David Sterba <dsterba@suse.cz>
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.com
Subject: Re: [PATCH V2] btrfs-progs: Use helper function to access
 btrfs_super_block->sys_chunk_array_size
Message-ID: <20161201152341.GT12522@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1480600274-13623-1-git-send-email-chandan@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1480600274-13623-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 01, 2016 at 07:21:14PM +0530, Chandan Rajendra wrote:
> btrfs_super_block->sys_chunk_array_size is stored as le32 data on
> disk. However insert_temp_chunk_item() writes sys_chunk_array_size in
> host cpu order. This commit fixes this by using super block access
> helper functions to read and write
> btrfs_super_block->sys_chunk_array_size field.
> 
> Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>

Applied, thanks.
