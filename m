Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54105 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933840AbcLTQ2J (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Dec 2016 11:28:09 -0500
Date: Tue, 20 Dec 2016 17:27:52 +0100
From: David Sterba <dsterba@suse.cz>
To: Colin King <colin.king@canonical.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][V2] btrfs: remove redundant inode null check
Message-ID: <20161220162752.GO3620@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20161220161837.24391-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161220161837.24391-1-colin.king@canonical.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 20, 2016 at 04:18:37PM +0000, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The check for a null inode is redundant since the function
> is a callback for exportfs, which will itself crash if
> dentry->d_inode or parent->d_inode is NULL.  Removing the
> null check makes this consistent with other file systems.
> 
> Also remove the redundant null dir check too.
> 
> Found with static analysis by CoverityScan, CID 1389472
> 
> Kudos to Jeff Mahoney for reviewing and explaining the error in
> my original patch (most of this explanation went into the above
> commit message) and David Sterba for pointing out that the dir
> check is also redundant.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Reviewed-by: David Sterba <dsterba@suse.com>

Added to cleanups queue, thanks.
