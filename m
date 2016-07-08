Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52679 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754868AbcGHNhM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 8 Jul 2016 09:37:12 -0400
Date: Fri, 8 Jul 2016 15:37:28 +0200
From: David Sterba <dsterba@suse.cz>
To: Jeff Mahoney <jeffm@suse.com>
Cc: Holger =?iso-8859-1?Q?Hoffst=E4tte?=
	<holger@applied-asynchrony.com>,
        David Sterba <DSterba@suse.com>, Josef Bacik <jbacik@fb.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: kdave/for-next commit 26112f7f472
Message-ID: <20160708133728.GG13336@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <f4d56502-9860-d9b0-2e40-337a8d028e04@suse.com>
 <577F8C2E.3@applied-asynchrony.com>
 <fd43645d-fac7-faf9-565f-dfbc6a84ecf5@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <fd43645d-fac7-faf9-565f-dfbc6a84ecf5@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 08, 2016 at 07:55:47AM -0400, Jeff Mahoney wrote:
> >> The problem is that btrfs_calc_reclaim_metadata_size didn't used to be
> >> called from recovery, so it was safe to use fs_info->fs_root.  With
> >> commit 7c83c6a09 (Btrfs: don't bother kicking async if there's nothing
> >> to reclaim) we do call it from recovery context and fs_info->fs_root is
> >> NULL.
> >>
> >> The fix is to just not switch btrfs_calc_reclaim_metadata_size to take
> >> an fs_info.  All the other call sites were using fs_info->fs_root
> >> anyway, so it's not like we're pinning a root somewhere just for this call.
> > 
> > I've had this patch from last October in my 4.4.x tree forever:
> > http://www.spinics.net/lists/linux-btrfs/msg48457.html
> > 
> > Apparently it fell off the table. Shouldn't that fix it?
> 
> A different fix went into for-next.

Which JFI is https://patchwork.kernel.org/patch/8928981/ so the fix from
Tsutomu Itoh is not relevant anymore (but yeah it was lost in the
noise).
