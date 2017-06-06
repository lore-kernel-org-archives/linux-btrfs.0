Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55138 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751390AbdFFNxc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 6 Jun 2017 09:53:32 -0400
Date: Tue, 6 Jun 2017 15:52:28 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: skip checksum verification if IO error occurs
Message-ID: <20170606135228.GB25451@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1492132308-2959-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1492132308-2959-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 13, 2017 at 06:11:48PM -0700, Liu Bo wrote:
> Currently dio read also goes to verify checksum if -EIO has been returned,
> although it usually fails on checksum, it's not necessary at all, we could
> directly check if there is another copy to read.
> 
> And with this, the behavior of dio read is now consistent with that of
> buffered read.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.com>

> @@ -8030,6 +8030,7 @@ static int __btrfs_subio_endio_read(struct inode *inode,
>  	unsigned int pgoff;
>  	int csum_pos;
>  	int i;
> +	int uptodate = !!(err == 0);

I've switched that to bool and dropped !!.
