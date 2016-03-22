Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36757 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750860AbcCVPiY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Mar 2016 11:38:24 -0400
Date: Tue, 22 Mar 2016 16:37:54 +0100
From: David Sterba <dsterba@suse.cz>
To: Petros Angelatos <petrosagg@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: utils: make sure set_label_mounted uses
 correct length buffers
Message-ID: <20160322153754.GE29764@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1458643229-25209-1-git-send-email-petrosagg@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1458643229-25209-1-git-send-email-petrosagg@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 22, 2016 at 03:40:29AM -0700, Petros Angelatos wrote:
> When `btrfs filesystem label /foo bar` command is invoked, it will pass
> the buffer allocated in the argv array directly to set_label_mounted()
> and then to the BTRFS_IOC_SET_FSLABEL ioctl.
> 
> However, the kernel code handling the ioctl will always try to copy
> BTRFS_LABEL_SIZE bytes[1] from the userland pointer. Under certain
> conditions and when the label is small enough, the command will fail
> with:
> 
>     [root@localhost /]# btrfs filesystem label /mnt f
>     ERROR: unable to set label Bad address

Good catch, I was not aware of the hidden requirement.

> Fix this by making sure we pass a BTRFS_LABEL_SIZE sized buffer to the
> ioctl containing the desired label.
> 
> [1] https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/fs/btrfs/ioctl.c?id=refs/tags/v4.5#n5231
> 
> Signed-off-by: Petros Angelatos <petrosagg@gmail.com>

Applied, thanks.
