Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38200 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751777AbaE0P5Z (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 27 May 2014 11:57:25 -0400
Date: Tue, 27 May 2014 17:57:23 +0200
From: David Sterba <dsterba@suse.cz>
To: Filipe David Borba Manana <fdmanana@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] Btrfs: set dead flag on the right root when
 destroying snapshot
Message-ID: <20140527155723.GL5346@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1400985885-16386-1-git-send-email-fdmanana@gmail.com>
 <1400986544-22440-1-git-send-email-fdmanana@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1400986544-22440-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, May 25, 2014 at 03:55:44AM +0100, Filipe David Borba Manana wrote:
> We were setting the BTRFS_ROOT_SUBVOL_DEAD flag on the root of the
> parent of our target snapshot, instead of setting it in the target
> snapshot's root.
> 
> This is easy to observe by running the following scenario:
> 
>     mkfs.btrfs -f /dev/sdd
>     mount /dev/sdd /mnt
> 
>     btrfs subvolume create /mnt/first_subvol
>     btrfs subvolume snapshot -r /mnt /mnt/mysnap1
> 
>     btrfs subvolume delete /mnt/first_subvol
>     btrfs subvolume snapshot -r /mnt /mnt/mysnap2
> 
>     btrfs send -p /mnt/mysnap1 /mnt/mysnap2 -f /tmp/send.data
> 
> The send command failed because the send ioctl returned -EPERM.
> A test case for xfstests follows.
> 
> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>

Reviewed-by: David Sterba <dsterba@suse.cz>

Thanks for catching it, I was so focused on verifying the locks to do
what they're supposed to do and missed the typo, not that the variable
names help to avoid confusion.
