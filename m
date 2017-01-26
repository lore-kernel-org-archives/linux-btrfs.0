Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50878 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753416AbdAZRe2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 26 Jan 2017 12:34:28 -0500
Date: Thu, 26 Jan 2017 18:34:09 +0100
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH] Btrfs: cleanup unused cached_state in
 __extent_writepage_io
Message-ID: <20170126173409.GJ11951@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1485393354-14139-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1485393354-14139-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 25, 2017 at 05:15:54PM -0800, Liu Bo wrote:
> @cached_state is no more required in __extent_writepage_io, also remove the
> goto label.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.com>
