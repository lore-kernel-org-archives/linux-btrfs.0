Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43435 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753015AbeDPR4B (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Apr 2018 13:56:01 -0400
Date: Mon, 16 Apr 2018 19:53:30 +0200
From: David Sterba <dsterba@suse.cz>
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v4 3/4] btrfs: Refactor btrfs_ioctl_snap_destroy() by
 using btrfs_delete_subvolume()
Message-ID: <20180416175330.GS21272@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <d5c7d8e3-4c07-18c3-56a5-0482c899cfe5@jp.fujitsu.com>
 <e4e8ecc3-fc4f-5967-1bf3-9f5abbac0c62@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <e4e8ecc3-fc4f-5967-1bf3-9f5abbac0c62@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 11, 2018 at 02:20:49PM +0900, Misono Tomohiro wrote:
> Use btrfs_delete_subvolume() to refactor btrfs_ioctl_snap_destroy().
> The permission check is still done in btrfs_ioctl_snap_destroy(). Also,
> call of d_delete() is still required since btrfs_delete_subvolume()
> does not call it.
> 
> As a result, btrfs_unlink_subvol() and may_destroy_subvol()
> become static functions. No functional change happens.
> 
> Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>

Why is this still split into two patches? Factoring out a function
should happen in one patch, ie 2 and 3 in one go. Do you have a reason
not to do it like that?
