Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54482 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751345AbdFFNns (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 6 Jun 2017 09:43:48 -0400
Date: Tue, 6 Jun 2017 15:42:43 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH v2] Btrfs: tolerate errors if we have retried successfully
Message-ID: <20170606134243.GA25451@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1492132316-3076-1-git-send-email-bo.li.liu@oracle.com>
 <20170517214200.9006-1-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170517214200.9006-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 17, 2017 at 03:42:00PM -0600, Liu Bo wrote:
> With raid1 profile, dio read isn't tolerating IO errors if read length is
> less than the stripe length (64K).
> 
> Our bio didn't get split in btrfs_submit_direct_hook() if (dip->flags &
> BTRFS_DIO_ORIG_BIO_SUBMITTED) is true and that happens when the read
> length is less than 64k.  In this case, if the underlying device returns
> error somehow, bio->bi_error has recorded that error.
> 
> If we could recover the correct data from another copy in profile raid1/10/5/6,
> with btrfs_subio_endio_read() returning 0, bio would have the correct data in
> its vector, but bio->bi_error is not updated accordingly so that the following
> dio_end_io(dio_bio, bio->bi_error) makes directIO think this read has failed.
> 
> This fixes the problem by setting bio's error to 0 if a good copy has been
> found.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
> 
> v2: Add more details to changelog.

Thanks.

Reviewed-by: David Sterba <dsterba@suse.com>
