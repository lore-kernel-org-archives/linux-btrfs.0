Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60435 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934046AbdJRMfc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Oct 2017 08:35:32 -0400
Date: Wed, 18 Oct 2017 14:33:44 +0200
From: David Sterba <dsterba@suse.cz>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        kernel-janitors@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: ref-verify: Fix NULL vs IS_ERR() check in
 walk_down_tree()
Message-ID: <20171018123343.GG3521@suse.cz>
Reply-To: dsterba@suse.cz
References: <20171018073635.cajusx7hzkg4ghgc@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171018073635.cajusx7hzkg4ghgc@mwanda>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 18, 2017 at 10:36:35AM +0300, Dan Carpenter wrote:
> read_tree_block() returns error pointers, and never NULL and so I have
> updated the error handling.
> 
> Fixes: 74739121b4c7 ("Btrfs: add a extent ref verify tool")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Thanks, I've folded the fix into the original commit and added credits.
