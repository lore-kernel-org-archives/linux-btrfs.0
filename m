Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52233 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752573Ab3AUMZJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Jan 2013 07:25:09 -0500
Date: Mon, 21 Jan 2013 13:25:06 +0100
From: David Sterba <dsterba@suse.cz>
To: Ilya Dryomov <idryomov@gmail.com>
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@fusionio.com>,
        Stefan Behrens <sbehrens@giantdisaster.de>
Subject: Re: [PATCH 0/5] Mutually exclusive ops fixes
Message-ID: <20130121122505.GG19967@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1358695352-7140-1-git-send-email-idryomov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1358695352-7140-1-git-send-email-idryomov@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jan 20, 2013 at 05:22:27PM +0200, Ilya Dryomov wrote:
> This is a set of fixes for mutually exclusive ops stuff added by Stefan
> as part of the dev-replace patchset.  The main one here is the first
> patch, it fixes a regression in balancing interface.  The second patch
> brings EINVAL error code back.  The rest are relatively minor ordering
> fixes.
> 
> Ilya Dryomov (5):
>   Btrfs: bring back balance pause/resume logic
>   Btrfs: fix "mutually exclusive op is running" error code
>   Btrfs: fix unlock order in btrfs_ioctl_resize
>   Btrfs: fix unlock order in btrfs_ioctl_rm_dev
>   Btrfs: reorder locks and sanity checks in btrfs_ioctl_defrag

1-5
Reviewed-by: David Sterba <dsterba@suse.cz>
