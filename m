Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37919 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752578AbeEKKWX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 May 2018 06:22:23 -0400
Date: Fri, 11 May 2018 12:19:43 +0200
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Nikolay Borisov <nborisov@suse.com>
Subject: Re: [PATCH v3 01/11] Btrfs: remove stale comment referencing
 vmtruncate()
Message-ID: <20180511101943.GS6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1526025007.git.osandov@fb.com>
 <d50e22690bdea060f485ac1dc19a54fa4d6e4411.1526025007.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <d50e22690bdea060f485ac1dc19a54fa4d6e4411.1526025007.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 11, 2018 at 12:56:06AM -0700, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> Commit a41ad394a03b ("Btrfs: convert to the new truncate sequence")
> changed vmtruncate() to truncate_setsize() but didn't update the comment
> above it. truncate_setsize() never fails (the IS_SWAPFILE() check
> happens elsewhere), so remove the comment.

There's one more mention of vmtruncate at btrfs_page_mkwrite, can you
please remove it and review that the comment is not stale in other
respects? Thanks.
