Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34504 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751933AbbEKQI0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 May 2015 12:08:26 -0400
Date: Mon, 11 May 2015 18:08:24 +0200
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: Re: [PATCH v2 2/6] Btrfs: remove all subvol options before mounting
 top-level
Message-ID: <20150511160824.GQ23255@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1428614837.git.osandov@osandov.com>
 <8ead0eb0e24aac86fae1d748853ed64e3a4161d9.1428614837.git.osandov@osandov.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <8ead0eb0e24aac86fae1d748853ed64e3a4161d9.1428614837.git.osandov@osandov.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 09, 2015 at 02:34:52PM -0700, Omar Sandoval wrote:
> Currently, setup_root_args() substitutes 's/subvol=[^,]*/subvolid=0/'.
> But, this means that if the user passes both a subvol and subvolid for
> some reason, we won't actually mount the top-level when we recursively
> mount. For example, consider:
> 
> mkfs.btrfs -f /dev/sdb
> mount /dev/sdb /mnt
> btrfs subvol create /mnt/subvol1 # subvolid=257
> btrfs subvol create /mnt/subvol2 # subvolid=258
> umount /mnt
> mount -osubvol=/subvol1,subvolid=258 /dev/sdb /mnt
> 
> In the final mount, subvol=/subvol1,subvolid=258 becomes
> subvolid=0,subvolid=258, and the last option takes precedence, so we
> mount subvol2 and try to look up subvol1 inside of it, which fails.
> 
> So, instead, do a thorough scan through the argument list and remove any
> subvol= and subvolid= options, then append subvolid=0 to the end. This
> implicitly makes subvol= take precedence over subvolid=, but we're about
> to add a stricter check for that. This also makes setup_root_args() more
> generic, which we'll need soon.
> 
> Signed-off-by: Omar Sandoval <osandov@osandov.com>

Reviewed-by: David Sterba <dsterba@suse.cz>
