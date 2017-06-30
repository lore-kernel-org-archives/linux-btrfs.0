Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57392 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751668AbdF3IAs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 30 Jun 2017 04:00:48 -0400
Date: Fri, 30 Jun 2017 09:59:37 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs-progs: convert: do not clear nodatasum flag in
 inode item
Message-ID: <20170630075937.GP2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170628212949.25403-1-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170628212949.25403-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 28, 2017 at 03:29:49PM -0600, Liu Bo wrote:
> With the current btrfs-convert, if we convert a ext4 without data checksum,
> it'd not set nodatasum flag in inode item, nor create csum item, reading
> file ends up with checksum errors.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Applied, thanks.
