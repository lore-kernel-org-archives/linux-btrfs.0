Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46932 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752985AbdAZRTk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 26 Jan 2017 12:19:40 -0500
Date: Thu, 26 Jan 2017 18:19:20 +0100
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-btrfs@vger.kernel.org, Chris Murphy <lists@colorremedies.com>,
        Andreas Gruenbacher <agruenba@redhat.com>, stable@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH v2 1/3] Btrfs: remove old tree_root case in
 btrfs_read_locked_inode()
Message-ID: <20170126171920.GG11951@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1485392101.git.osandov@fb.com>
 <7796d3ba2cedf845e9d9e50667891ac31e48d551.1485392101.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <7796d3ba2cedf845e9d9e50667891ac31e48d551.1485392101.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 25, 2017 at 05:06:38PM -0800, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> As Jeff explained in c2951f32d36c ("btrfs: remove old tree_root dirent
> processing in btrfs_real_readdir()"), supporting this old format is no
> longer necessary since the Btrfs magic number has been updated since we
> changed to the current format. There are other places where we still
> handle this old format, but since this is part of a fix that is going to
> stable, I'm only removing this one for now.
> 
> Cc: <stable@vger.kernel.org> # 4.9.x
> Signed-off-by: Omar Sandoval <osandov@fb.com>

Reviewed-by: David Sterba <dsterba@suse.com>
