Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47881 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751327AbaKYRgq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Nov 2014 12:36:46 -0500
Date: Tue, 25 Nov 2014 18:36:46 +0100
From: David Sterba <dsterba@suse.cz>
To: Wang Shilong <wangshilong1991@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] Btrfs: deal with all 'subvol=xxx' options once
Message-ID: <20141125173646.GL26471@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1416903611-29812-1-git-send-email-wangshilong1991@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1416903611-29812-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 25, 2014 at 04:20:11PM +0800, Wang Shilong wrote:
> Steps to reproduce:
>  # mkfs.btrfs -f /dev/sdb
>  # mount -t btrfs /dev/sdb /mnt
>  # btrfs sub create /mnt/dir
>  # mount -t btrfs /dev/sdb /mnt -o subvol=dir,subvol=dir
> 
> It fails with:
>  mount: mount(2) failed: No such file or directory

The bug is real, but I don't like the fix. The mount path is hard to
read already, and I'm afraid your fix adds another unobvious step to the
whole processing.

setup_root_args replaces subvol= with subvolid=0 once. I suggest to
replace all occurences of subvol= here and not rely on the recursive
behaviour of the mount callbacks.

The (buggy) way how it works now is that the first occurence of subvol
will get parsed and passed as

newroot = vfs_kern_mount(",subvol=second,...,subvolid=0")

and this will call back again to btrfs_mount and will try to mount the
subvol 'second' but now relative to 'newroot'.

Try this:

# mkfs.btrfs -f /dev/sdb
# mount -t btrfs /dev/sdb /mnt
# btrfs sub create /mnt/dir
# btrfs sub create /mnt/dir/dir2
# mount -t btrfs /dev/sdb /mnt -o subvol=dir,subvol=dir2

mount succeeds and the mounted subvolume is dir2.
