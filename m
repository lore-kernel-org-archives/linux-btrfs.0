Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60017 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932586AbdIFOxL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 6 Sep 2017 10:53:11 -0400
Date: Wed, 6 Sep 2017 16:51:41 +0200
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH 2/7] Btrfs: fix incorrect {node,sector}size endianness
 from BTRFS_IOC_FS_INFO
Message-ID: <20170906145141.GS31874@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1503470354.git.osandov@fb.com>
 <0f9325bfb4a8245c2fd0eb0fec73dc791a04932f.1503470354.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <0f9325bfb4a8245c2fd0eb0fec73dc791a04932f.1503470354.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 22, 2017 at 11:46:00PM -0700, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> fs_info->super_copy->{node,sector}size are little-endian, but the ioctl
> should return the values in native endianness. Use the cached values in
> btrfs_fs_info instead. Found with sparse.
> 
> Fixes: 80a773fbfc2d ("btrfs: retrieve more info from FS_INFO ioctl")
> Signed-off-by: Omar Sandoval <osandov@fb.com>

Reviewed-by: David Sterba <dsterba@suse.com>
