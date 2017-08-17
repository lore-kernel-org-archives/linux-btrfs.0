Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54152 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751861AbdHQLxn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 Aug 2017 07:53:43 -0400
Date: Thu, 17 Aug 2017 13:52:19 +0200
From: David Sterba <dsterba@suse.cz>
To: Colin King <colin.king@canonical.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: remove redundant check on ret being non-zero
Message-ID: <20170817115219.GR2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170815075102.19094-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170815075102.19094-1-colin.king@canonical.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 15, 2017 at 08:51:02AM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The error return variable ret is initialized to zero and then is
> checked to see if it is non-zero in the if-block that follows it.
> It is therefore impossible for ret to be non-zero after the if-block
> hence the check is redundant and can be removed.
> 
> Detected by CoverityScan, CID#1021040 ("Logically dead code")
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Reviewed-by: David Sterba <dsterba@suse.com>
