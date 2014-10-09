Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44604 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751372AbaJIPo5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 9 Oct 2014 11:44:57 -0400
Date: Thu, 9 Oct 2014 17:44:56 +0200
From: David Sterba <dsterba@suse.cz>
To: Marios Titas <redneb@gmx.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: move struct btrfs_ioctl_defrag_range_args from
 ctree.h to linux/btrfs.h
Message-ID: <20141009154456.GC22943@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20141008002341.GA28669@zeno.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20141008002341.GA28669@zeno.lan>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 08, 2014 at 01:23:41AM +0100, Marios Titas wrote:
> include/uapi/linux/btrfs.h is a more logical place to put the struct
> btrfs_ioctl_defrag_range_args as it is being used by the
> BTRFS_IOC_DEFRAG_RANGE IOCTL which is defined in that file.
> Additionally, this is where the btrfs-progs defines that struct. Thus
> this patches reduces the gap between the btrfs-progs headers and the
> kernel headers.
> 
> Signed-off-by: Marios Titas <redneb@gmx.com>

Reviewed-by: David Sterba <dsterba@suse.cz>
