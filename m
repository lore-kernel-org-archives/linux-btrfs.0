Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41772 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752242Ab3BYKuI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Feb 2013 05:50:08 -0500
Date: Mon, 25 Feb 2013 11:50:07 +0100
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, Marios Titas <redneb8888@gmail.com>,
        David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH] Btrfs: do not change inode flags in rename
Message-ID: <20130225105007.GQ27541@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1361765082-6331-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1361765082-6331-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 25, 2013 at 12:04:42PM +0800, Liu Bo wrote:
> Before we forced to change a file's NOCOW and COMPRESS flag due to
> the parent directory's, but this ends up a bad idea, because it
> confuses end users a lot about file's NOCOW status, eg. if someone
> change a file to NOCOW via 'chattr' and then rename it in the current
> directory which is without NOCOW attribute, the file will lose the
> NOCOW flag silently.
> 
> This diables 'change flags in rename', so from now on we'll only
> inherit flags from the parent directory on creation stage while in
> other places we can use 'chattr' to set NOCOW or COMPRESS flags.
> 
> Reported-by: Marios Titas <redneb8888@gmail.com>
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Thank you!
Reviewed-by: David Sterba <dsterba@suse.cz>
