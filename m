Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49760 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390076AbeIUVLW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 Sep 2018 17:11:22 -0400
Date: Fri, 21 Sep 2018 17:21:58 +0200
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        David Sterba <dsterba@suse.com>
Subject: Re: [PATCH v8 6/6] Btrfs: support swap files
Message-ID: <20180921152158.GL5847@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1537419652.git.osandov@fb.com>
 <0a585197abaedd39d0f6caec59ce3976f4654752.1537419652.git.osandov@fb.com>
 <20180920171541.GD5847@twin.jikos.cz>
 <20180920172257.GA26479@vader>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180920172257.GA26479@vader>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 20, 2018 at 10:22:57AM -0700, Omar Sandoval wrote:
> > > +	/*
> > > +	 * Balance or device remove/replace/resize can move stuff around from
> > > +	 * under us. The EXCL_OP flag makes sure they aren't running/won't run
> > > +	 * concurrently while we are mapping the swap extents, and
> > > +	 * fs_info->swapfile_pins prevents them from running while the swap file
> > > +	 * is active and moving the extents. Note that this also prevents a
> > > +	 * concurrent device add which isn't actually necessary, but it's not
> > > +	 * really worth the trouble to allow it.
> > > +	 */
> > > +	if (test_and_set_bit(BTRFS_FS_EXCL_OP, &fs_info->flags))
> > > +		return -EBUSY;
> > 
> > This could be also accompanied by a message, "why does not my swapfile
> > activate?" -> "there's an exclusive operation running". I've checked if
> > there are similar messages for the other exclusive ops. There are.
> 
> Sounds good. I addressed all of your comments and pushed to
> https://github.com/osandov/linux/tree/btrfs-swap. The only thing I
> didn't change was the btrfs_info about not being able to relocate an
> active swapfile. I think it makes sense as btrfs_info since we already
> log every block group we are relocating as info (see
> describe_relocation()).

Ok, then it's consistent with the relocation mesages. I'll do another
pass just to see if the log level is sane for all messages but this can
be tuned later too, so this is only a minor issue.
