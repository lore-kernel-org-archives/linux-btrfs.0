Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46878 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753932AbdAZRTV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 26 Jan 2017 12:19:21 -0500
Date: Thu, 26 Jan 2017 18:19:02 +0100
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-btrfs@vger.kernel.org, Chris Murphy <lists@colorremedies.com>,
        Andreas Gruenbacher <agruenba@redhat.com>, stable@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH v2 2/3] Btrfs: disable xattr operations on subvolume
 directories
Message-ID: <20170126171901.GF11951@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1485392101.git.osandov@fb.com>
 <807c4c0c54fe611c4d0fb399aee36e241e2c6846.1485392101.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <807c4c0c54fe611c4d0fb399aee36e241e2c6846.1485392101.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 25, 2017 at 05:06:39PM -0800, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> When you snapshot a subvolume containing a subvolume, you get a
> placeholder directory where the subvolume would be. These directory
> inodes have ->i_ops set to btrfs_dir_ro_inode_operations. Previously,
> these i_ops didn't include the xattr operation callbacks. The conversion
> to xattr_handlers missed this case, leading to bogus attempts to set
> xattrs on these inodes. This manifested itself as failures when running
> delayed inodes.
> 
> To fix this, clear IOP_XATTR in ->i_opflags on these inodes.
> 
> Fixes: 6c6ef9f26e59 ("xattr: Stop calling {get,set,remove}xattr inode operations")
> Cc: Andreas Gruenbacher <agruenba@redhat.com>
> Reported-by: Chris Murphy <lists@colorremedies.com>
> Tested-by: Chris Murphy <lists@colorremedies.com>
> Cc: <stable@vger.kernel.org> # 4.9.x
> Signed-off-by: Omar Sandoval <osandov@fb.com>

Reviewed-by: David Sterba <dsterba@suse.com>
