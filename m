Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42504 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725978AbeIFUo4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 6 Sep 2018 16:44:56 -0400
Date: Thu, 6 Sep 2018 18:08:27 +0200
From: David Sterba <dsterba@suse.cz>
To: Colin King <colin.king@canonical.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: remove unused pointer 'tree'
Message-ID: <20180906160827.GE24025@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180828132101.9559-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180828132101.9559-1-colin.king@canonical.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 28, 2018 at 02:21:01PM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Pointer 'tree' is being assigned but is never used hence it is
> redundant and can be removed.

For patches removing dead code it's good to do a bit of research what
was the reason for that. In most cases it's a simple leftover after some
other cleanup or rework, ie. harmless, but this needs to be reviewed
anyway and the reference in changelog helps.

In this case it's after my commit 00032d38eaa89c76de7, I'll update the
changelog. And the previous patch removing inode in relink_file_extents
was udpated too.
> 
> Cleans up clang warning:
> warning: variable 'tree' set but not used [-Wunused-but-set-variable]
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Reviewed-by: David Sterba <dsterba@suse.com>
