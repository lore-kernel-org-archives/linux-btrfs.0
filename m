Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tetsuo.zabbo.net ([50.193.208.193]:39757 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932847AbaGWUri (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Jul 2014 16:47:38 -0400
Date: Wed, 23 Jul 2014 13:47:36 -0700
From: Zach Brown <zab@zabbo.net>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: feature request: consider rw subvols ro for send when volume is
 mounted ro
Message-ID: <20140723204736.GD17798@lenny.home.zabbo.net>
References: <EAC867F7-CBB2-4714-9917-A29566167A21@colorremedies.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <EAC867F7-CBB2-4714-9917-A29566167A21@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 23, 2014 at 02:10:29PM -0600, Chris Murphy wrote:
> The use case is when it's possible to mount a Btrfs volume ro, but not rw. Example, a situation where
> 
> # mount -o degraded /dev/sdb /mnt
> [   71.064352] BTRFS info (device sdb): allowing degraded mounts
> [   71.064812] BTRFS info (device sdb): enabling auto recovery
> [   71.065210] BTRFS info (device sdb): disk space caching is enabled
> [   71.072068] BTRFS warning (device sdb): devid 2 missing
> [   71.097320] BTRFS: too many missing devices, writeable mount is not allowed
> [   71.116616] BTRFS: open_ctree failed
> 
> Yet this works:
> # mount -o degraded,ro /dev/sdb /mnt
> 
> It would be great if it were possible to send/receive subvolumes to a
> different btrfs volume. Currently it's not possible because those
> subvols aren't ro, and because the mount is ro I can't make ro
> snapshots first.

I wonder if that's as easy as the following totally untested hack.  I
have no idea if a read-only mount would still allow background
modification that might violate the send code's assumptions.

- z

$ git diff fs/btrfs/send.c
diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 6528aa6..3528210 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -5536,7 +5536,7 @@ long btrfs_ioctl_send(struct file *mnt_file, void __user *arg_)
 	 * Userspace tools do the checks and warn the user if it's
 	 * not RO.
 	 */
-	if (!btrfs_root_readonly(send_root)) {
+	if (!(btrfs_root_readonly(send_root) || (sb->s_flags & MS_RDONLY))) {
 		ret = -EPERM;
 		goto out;
 	}
