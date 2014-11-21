Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56853 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758442AbaKUP5P (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Nov 2014 10:57:15 -0500
Date: Fri, 21 Nov 2014 16:57:14 +0100
From: David Sterba <dsterba@suse.cz>
To: Daniel Dressler <danieru.dressler@gmail.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        "open list:BTRFS FILE SYSTEM" <linux-btrfs@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: delayed-inode: replace root args iff only fs_info
 used
Message-ID: <20141121155714.GC8568@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <danieru.dressler@gmail.com>
 <1416229502-22368-1-git-send-email-danieru.dressler@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1416229502-22368-1-git-send-email-danieru.dressler@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 17, 2014 at 10:05:02PM +0900, Daniel Dressler wrote:
> This is the second independent patch of a larger
> project to cleanup btrfs's internal usage of
> btrfs_root. Many functions take btrfs_root
> only to grab the fs_info struct.
> 
> By requiring a root these functions cause
> programmer overhead. That these functions can
> accept any valid root is not obvious until
> inspection.
> 
> This patch reduces the specificity of such
> functions to accept the fs_info directly.
> 
> These patches can be applied independently
> and thus are not being submitted as a patch
> series. There should be about 26 patches by
> the project's completion. Each patch will
> cleanup between 1 and 34 functions apiece.
> Each patch covers a single file's functions.
> 
> This patch affects the following function(s):
>   1) btrfs_wq_run_delayed_node
> 
> Signed-off-by: Daniel Dressler <danieru.dressler@gmail.com>

Apart from the narrow paragraphs,

Reviewed-by: David Sterba <dsterba@suse.cz>
