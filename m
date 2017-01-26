Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f180.google.com ([209.85.192.180]:34926 "EHLO
        mail-pf0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751972AbdAZBIw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 25 Jan 2017 20:08:52 -0500
Received: by mail-pf0-f180.google.com with SMTP id f144so61951916pfa.2
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Jan 2017 17:08:51 -0800 (PST)
Date: Wed, 25 Jan 2017 17:08:23 -0800
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: Chris Murphy <lists@colorremedies.com>,
        Andreas Gruenbacher <agruenba@redhat.com>, stable@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH] Btrfs: disable xattr operations on subvolume directories
Message-ID: <20170126010823.GB19099@vader>
References: <c96f9f4d14c7a40913a39856ca8f065d37113372.1485311744.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <c96f9f4d14c7a40913a39856ca8f065d37113372.1485311744.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 25, 2017 at 05:06:36PM -0800, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> When you snapshot a subvolume containing a subvolume, you get a
> placeholder read-only directory where the subvolume would be. These
> directory inodes have ->i_ops set to btrfs_dir_ro_inode_operations.
> Previously, this didn't include the xattr operation callbacks. The
> conversion to xattr_handlers missed this case, leading to bogus attempts
> to set xattrs on these inodes. This manifested itself as failures when
> running delayed inodes.
> 
> To fix this, clear the IOP_XATTR in ->i_opflags on these inodes.
> 
> Fixes: 6c6ef9f26e59 ("xattr: Stop calling {get,set,remove}xattr inode operations")
> Cc: Andreas Gruenbacher <agruenba@redhat.com>
> Reported-by: Chris Murphy <lists@colorremedies.com>
> Signed-off-by: Omar Sandoval <osandov@fb.com>
> ---
> Applies to v4.10-rc4. Chris, this fixes the issue for me, could you please test
> it out? Andreas, does this make sense? I'll try to cook up an xfstest for this.
> 

(Sorry, accidentally resent v1, ignore this one and just look at v2).
