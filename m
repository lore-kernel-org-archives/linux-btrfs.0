Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48139 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751289AbdILL2a (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Sep 2017 07:28:30 -0400
Date: Tue, 12 Sep 2017 13:26:58 +0200
From: David Sterba <dsterba@suse.cz>
To: Colin King <colin.king@canonical.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: avoid null pointer dereference on fs_info when
 calling btrfs_crit
Message-ID: <20170912112658.GH14538@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170911151528.26348-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170911151528.26348-1-colin.king@canonical.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 11, 2017 at 04:15:28PM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> There are checks on fs_info in __btrfs_panic to avoid dereferencing a
> null fs_info, however, there is a call to btrfs_crit that may also
> dereference a null fs_info. Fix this by adding a check to see if fs_info
> is null and only print the s_id if fs_info is non-null.
> 
> Detected by CoverityScan CID#401973 ("Dereference after null check")
> 
> Fixes: efe120a067c8 ("Btrfs: convert printk to btrfs_ and fix BTRFS prefix")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Reviewed-by: David Sterba <dsterba@suse.com>
