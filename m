Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59529 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752224AbaDDMj1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 4 Apr 2014 08:39:27 -0400
Date: Fri, 4 Apr 2014 14:39:25 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <Anand.Jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, zab@redhat.com
Subject: Re: [PATCH 1/2 v2] btrfs: btrfs_rm_device() should zero mirror SB as
 well
Message-ID: <20140404123925.GS29256@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1396275237-8306-1-git-send-email-Anand.Jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1396275237-8306-1-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 31, 2014 at 10:13:56PM +0800, Anand Jain wrote:
> From: Anand Jain <anand.jain@oracle.com>
> 
> This fix will ensure all SB copies on the disk is zeroed
> when the disk is intentionally removed. This helps to
> better manage disks in the user land.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> 
> btrfs: don't double brelse on device rm
> 
> Device removal currently causes bdev removal to try to double free a bh
> in the bdev:
> 
> [   55.714833] WARNING: at fs/buffer.c:1160 __brelse+0x36/0x40()
> [   55.714833] VFS: brelse: Trying to free free buffer
> 
> Commit 7e3d9ebb1 added a double release of the bh for a device being
> removed when all the supers don't fit in the device.  In that case it
> releases the bh assuming that it's going to read a new one, finds that
> it won't read, and goes to a label that releases the bh again.
> 
> All it needed to do was only brelse() right before overwriting the
> current bh with __bread().
> 
> Signed-off-by: Zach Brown <zab@redhat.com>

This is a bit confusing, two changelogs, one patch, the referenced
commit id does not in fact exist. To keep all due credits, 2 patches
would make sense but ... up to you.
