Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51324 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750854AbaGVSBU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Jul 2014 14:01:20 -0400
Date: Tue, 22 Jul 2014 20:01:18 +0200
From: David Sterba <dsterba@suse.cz>
To: Mark Fasheh <mfasheh@suse.de>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH] xfstests/btrfs: add test for quota groups and drop
 snapshot
Message-ID: <20140722180118.GG1553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20140709224150.GA5484@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140709224150.GA5484@wotan.suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 09, 2014 at 03:41:50PM -0700, Mark Fasheh wrote:
> +$BTRFS_UTIL_PROG fi sy $SCRATCH_MNT
> +$BTRFS_UTIL_PROG su sna $SCRATCH_MNT $SCRATCH_MNT/snap1

> +$BTRFS_UTIL_PROG qu en $SCRATCH_MNT

> +$BTRFS_UTIL_PROG su de $SCRATCH_MNT/snap1

Please spell the full names of the subcommands.
