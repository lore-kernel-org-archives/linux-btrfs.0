Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46855 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752628AbdAZRTN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 26 Jan 2017 12:19:13 -0500
Date: Thu, 26 Jan 2017 18:18:52 +0100
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-btrfs@vger.kernel.org, Chris Murphy <lists@colorremedies.com>,
        Andreas Gruenbacher <agruenba@redhat.com>, stable@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH v2 3/3] Btrfs: remove ->{get,set}_acl() from
 btrfs_dir_ro_inode_operations
Message-ID: <20170126171852.GE11951@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1485392101.git.osandov@fb.com>
 <14d5cbf62169b1ac773028fa3ce0da246b968134.1485392101.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <14d5cbf62169b1ac773028fa3ce0da246b968134.1485392101.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 25, 2017 at 05:06:40PM -0800, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> Subvolume directory inodes can't have ACLs.
> 
> Cc: <stable@vger.kernel.org> # 4.9.x
> Signed-off-by: Omar Sandoval <osandov@fb.com>

Reviewed-by: David Sterba <dsterba@suse.com>
