Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:32984 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751616AbdF1ORU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Jun 2017 10:17:20 -0400
Date: Wed, 28 Jun 2017 16:16:09 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs-progs: man: nodesize must be power of 2 now
Message-ID: <20170628141609.GG2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170627212545.25408-1-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170627212545.25408-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 27, 2017 at 03:25:45PM -0600, Liu Bo wrote:
> This updates mkfs.btrfs's man page with the new limitation that nodesize must
> be a power of 2 as well.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Applied, thanks.
