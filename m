Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53513 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932368AbdEOP6Y (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 15 May 2017 11:58:24 -0400
Date: Mon, 15 May 2017 17:57:26 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: tolerate errors if we have retried successfully
Message-ID: <20170515155726.GB4065@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1492132316-3076-1-git-send-email-bo.li.liu@oracle.com>
 <20170505165245.GF10575@twin.jikos.cz>
 <20170509194053.GF17312@lim.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170509194053.GF17312@lim.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 09, 2017 at 12:40:53PM -0700, Liu Bo wrote:
> On Fri, May 05, 2017 at 06:52:45PM +0200, David Sterba wrote:
> > On Thu, Apr 13, 2017 at 06:11:56PM -0700, Liu Bo wrote:
> > > With raid1 profile, dio read isn't tolerating IO errors if read length is
> > > less than the stripe length (64K).
> > 
> > Can you please write more details why this is true? Some pointers to
> > code etc, I'm lost. Eg. where the errors is tolerated. Thanks.
> 
> Sure.
> 
> Our bio didn't get split in btrfs_submit_direct_hook() if (dip->flags &
> BTRFS_DIO_ORIG_BIO_SUBMITTED) is true.  If the underlying device returns error
> somehow, bio->bi_error has recorded that error.
> 
> If we could recover the correct data from another copy in profile raid1/10/5/6,
> with btrfs_subio_endio_read() returning 0, bio would have the correct data in
> its vector, but bio->bi_error is not updated accordingly so that the following
> dio_end_io(dio_bio, bio->bi_error) makes directIO think this read has failed.

Great, thanks. Please update the patch and resend.
