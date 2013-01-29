Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:35771 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752124Ab3A2DwS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Jan 2013 22:52:18 -0500
Date: Mon, 28 Jan 2013 22:52:16 -0500
From: Chris Mason <chris.mason@fusionio.com>
To: Liu Bo <bo.li.liu@oracle.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "mitch.harder@sabayonlinux.org" <mitch.harder@sabayonlinux.org>,
        "dsterba@suse.cz" <dsterba@suse.cz>
Subject: Re: [PATCH v2] Btrfs: fix race between snapshot deletion and getting
 inode
Message-ID: <20130129035216.GC23893@shiny.globalsuite.net>
References: <1359429730-16729-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1359429730-16729-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 28, 2013 at 08:22:10PM -0700, Liu Bo wrote:
> While running snapshot testscript created by Mitch and David,
> the race between autodefrag and snapshot deletion can lead to
> corruption of dead_root list so that we can get crash on
> btrfs_clean_old_snapshots().

Really nice.  Thanks to everyone that hashed this out.

-chris
