Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53998 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752676AbdEIP2y (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 9 May 2017 11:28:54 -0400
Date: Tue, 9 May 2017 17:28:44 +0200
From: David Sterba <dsterba@suse.cz>
To: Colin King <colin.king@canonical.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] btrfs: remove redundant assignment and check on variable
 ret
Message-ID: <20170509152844.GF5491@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170506220105.13206-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170506220105.13206-1-colin.king@canonical.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, May 06, 2017 at 11:01:05PM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Variable ret is assigned to zero and is always zero throughout the
> function.  Thus the check for ret being less than zero is always
> false and so mapping_set_error always has an -EIO error passed to
> it.  Hence we can remove the redundant assignment and check on ret.
> 
> Detected by CoverityScan, CID#1414312 ("Logically dead code")
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Reviewed-by: David Sterba <dsterba@suse.com>
