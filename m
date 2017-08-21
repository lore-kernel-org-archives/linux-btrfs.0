Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53559 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753245AbdHUOyU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 Aug 2017 10:54:20 -0400
Date: Mon, 21 Aug 2017 16:52:55 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH v3 3/7] Btrfs: remove BUG() in
 btrfs_extent_inline_ref_size
Message-ID: <20170821145255.GF2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170818211524.31325-1-bo.li.liu@oracle.com>
 <20170818211524.31325-4-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170818211524.31325-4-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 18, 2017 at 03:15:20PM -0600, Liu Bo wrote:
> Now that btrfs_get_extent_inline_ref_type() can report if type is a
> valid one and all callers can gracefully deal with that, we don't need
> to crash here.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.com>
