Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58122 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752257AbeEQRVZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 May 2018 13:21:25 -0400
Date: Thu, 17 May 2018 19:18:41 +0200
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Nikolay Borisov <nborisov@suse.com>, David Sterba <dsterba@suse.com>
Subject: Re: [PATCH v4 03/12] Btrfs: don't BUG_ON() in
 btrfs_truncate_inode_items()
Message-ID: <20180517171841.GN6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1526069051.git.osandov@fb.com>
 <2970473d6aaaec84714be7c9d8d0750cd6bc5ec2.1526069051.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <2970473d6aaaec84714be7c9d8d0750cd6bc5ec2.1526069051.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 11, 2018 at 01:13:31PM -0700, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> btrfs_free_extent() can fail because of ENOMEM. There's no reason to
> panic here, we can just abort the transaction.
> 
> Fixes: f4b9aa8d3b87 ("btrfs_truncate")
> Reviewed-by: Nikolay Borisov <nborisov@suse.com>
> Signed-off-by: Omar Sandoval <osandov@fb.com>

Reviewed-by: David Sterba <dsterba@suse.com>
