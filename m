Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49762 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932731AbdC2U4l (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 29 Mar 2017 16:56:41 -0400
Date: Wed, 29 Mar 2017 22:55:57 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH v2] Btrfs: set scrub page's io_error if failing to submit
 io
Message-ID: <20170329205557.GE4781@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1490399280-2624-1-git-send-email-bo.li.liu@oracle.com>
 <1490810116-19216-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1490810116-19216-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 29, 2017 at 10:55:16AM -0700, Liu Bo wrote:
> Scrub repairs data by the unit called scrub_block, which may contains
> several pages.  Scrub always tries to look up a good copy of a whole
> block, but if there's no such copy, it tries to do repair page by page.
> 
> If we don't set page's io_error when checking this bad copy, in the last
> step, we may skip this page when repairing bad copy from good copy.

Great, thanks.

> Cc: David Sterba <dsterba@suse.cz>
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.com>
