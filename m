Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56724 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933409AbeCGQJe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 7 Mar 2018 11:09:34 -0500
Date: Wed, 7 Mar 2018 17:07:12 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3] btrfs: fix bare unsigned declarations
Message-ID: <20180307160712.GI23693@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180223221252.GN1469@twin.jikos.cz>
 <20180226084605.7120-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180226084605.7120-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 26, 2018 at 04:46:05PM +0800, Anand Jain wrote:
> We have btrfs_fs_info::data_chunk_allocations and
> btrfs_fs_info::metadata_ratio declared as unsigned which would
> be unsinged int and kernel style prefers unsigned int over bare
> unsigned. So this patch changes them to u32.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
> v2->v3: @old_metadata_ratio change it to u32
> v1->v2: Update change log.

Added to next, thanks.
