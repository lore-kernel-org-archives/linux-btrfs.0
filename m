Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37201 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750817AbeCFLgT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 6 Mar 2018 06:36:19 -0500
Date: Tue, 6 Mar 2018 12:33:58 +0100
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: dev-replace: make sure target is identical to
 source when raid56 rebuild fails
Message-ID: <20180306113358.GP5942@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180302231041.10442-5-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180302231041.10442-5-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 02, 2018 at 04:10:41PM -0700, Liu Bo wrote:
> In the last step of scrub_handle_error_block, we try to combine good
> copies on all possible mirrors, this works fine for raid1 and raid10,
> but not for raid56 as it's doing parity rebuild.
> 
> If parity rebuild doesn't get back with correct data which matches its
> checksum, in case of replace we'd rather write what is stored in the
> source device than the data calculuated from parity.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Added to next, thanks.
