Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59267 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932564AbdIFOn6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 6 Sep 2017 10:43:58 -0400
Date: Wed, 6 Sep 2017 16:42:29 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: do not reset bio->bi_ops while writing bio
Message-ID: <20170906144229.GR31874@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170823181509.19816-1-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170823181509.19816-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 23, 2017 at 12:15:09PM -0600, Liu Bo wrote:
> flush_epd_write_bio() sets bio->bi_ops by itself to honor REQ_SYNC,
> but it's not needed at all since bio->bi_ops has set up properly in
> both __extent_writepage() and write_one_eb(), and in the case of
> write_one_eb(), it also sets REQ_META, which we will lose in
> flush_epd_write_bio().
> 
> This remove this unnecessary bio->bi_ops setting.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.com>
