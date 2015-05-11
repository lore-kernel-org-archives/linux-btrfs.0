Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34452 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751300AbbEKQHl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 May 2015 12:07:41 -0400
Date: Mon, 11 May 2015 18:07:38 +0200
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: Re: [PATCH v2 1/6] Btrfs: lock superblock before remounting for rw
 subvol
Message-ID: <20150511160738.GP23255@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1428614837.git.osandov@osandov.com>
 <ad0f1a6b626ecc879bd23972869c8ab93e0312d0.1428614837.git.osandov@osandov.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <ad0f1a6b626ecc879bd23972869c8ab93e0312d0.1428614837.git.osandov@osandov.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 09, 2015 at 02:34:51PM -0700, Omar Sandoval wrote:
> Since commit 0723a0473fb4 ("btrfs: allow mounting btrfs subvolumes with
> different ro/rw options"), when mounting a subvolume read/write when
> another subvolume has previously been mounted read-only, we first do a
> remount. However, this should be done with the superblock locked, as per
> sync_filesystem():
> 
> 	/*
> 	 * We need to be protected against the filesystem going from
> 	 * r/o to r/w or vice versa.
> 	 */
> 	WARN_ON(!rwsem_is_locked(&sb->s_umount));
> 
> This WARN_ON can easily be hit with:
> 
> mkfs.btrfs -f /dev/vdb
> mount /dev/vdb /mnt
> btrfs subvol create /mnt/vol1
> btrfs subvol create /mnt/vol2
> umount /mnt
> mount -oro,subvol=/vol1 /dev/vdb /mnt
> mount -orw,subvol=/vol2 /dev/vdb /mnt2
> 
> Fixes: 0723a0473fb4 ("btrfs: allow mounting btrfs subvolumes with different ro/rw options")
> Signed-off-by: Omar Sandoval <osandov@osandov.com>

Reviewed-by: David Sterba <dsterba@suse.cz>
