Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59224 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753374AbdBHRhv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 8 Feb 2017 12:37:51 -0500
Date: Wed, 8 Feb 2017 17:17:59 +0100
From: David Sterba <dsterba@suse.cz>
To: Jeff Mahoney <jeffm@suse.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, Luke Dashjr <luke@dashjr.org>
Subject: Re: [PATCH] btrfs: fix btrfs_compat_ioctl failures on non-compat
 ioctls
Message-ID: <20170208161759.GI3366@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <9407b764-fbf5-ff04-0d27-70d4e9821e37@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <9407b764-fbf5-ff04-0d27-70d4e9821e37@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 06, 2017 at 07:39:09PM -0500, Jeff Mahoney wrote:
> Commit 4c63c2454ef incorrectly assumed that returning -ENOIOCTLCMD would
> cause the native ioctl to be called.  The ->compat_ioctl callback is
> expected to handle all ioctls, not just compat variants.  As a result,
> when using 32-bit userspace on 64-bit kernels, everything except those
> three ioctls would return -ENOTTY.
> 
> Fixes: 4c63c2454ef ("btrfs: bugfix: handle FS_IOC32_{GETFLAGS,SETFLAGS,GETVERSION} in btrfs_ioctl")
> Cc: stable@vger.kernel.org
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
