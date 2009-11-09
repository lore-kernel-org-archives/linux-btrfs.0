From: Chris Ball <cjb@laptop.org>
Subject: Re: rootfs snapshots and rollback (i.e. testing updates)
Date: Mon, 09 Nov 2009 11:38:19 -0500
Message-ID: <m3639jk610.fsf@pullcord.laptop.org>
References: <4AF82E78.1010200@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Tomasz Chmielewski <mangoo@wpkg.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4AF82E78.1010200@wpkg.org> (Tomasz Chmielewski's message of
	"Mon, 09 Nov 2009 16:00:08 +0100")
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

   > Is it possible, with current btrfs:

Yes, I think so.

   > - to take a rootfs snapshot (i.e. prior to a major update),

btrfsctl -s newsnap /

   > - do changes in the root filesystem (i.e. install major update),
   > 
   > - if we don't like what the major update did to the system
   > (rootfs), "rollback" the snapshot and make it the "original"
   > rootfs again (perhaps, with a reboot in between).

Before rebooting, edit whatever mounts your root partition (initrd,
fstab, kernel argument) to add a "subvol=newsnap" mount argument.

An obvious way to make this nicer would be to:
   * have the package manager create the snapshot before modifying the
     system, with a timestamp.
   * modify the bootloader to give a choice of snapshots at boot-time.

Note that you're rolling back *all* rootfs changes, not merely the
changes that the package manager made, so it wouldn't be correct to
think of this as a way to only rollback package manager transactions.

- Chris.
-- 
Chris Ball   <cjb@laptop.org>
One Laptop Per Child
