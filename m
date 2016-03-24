Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp2.provo.novell.com ([137.65.250.81]:44752 "EHLO
	smtp2.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbcCXPI1 (ORCPT
	<rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
	Thu, 24 Mar 2016 11:08:27 -0400
Date: Thu, 24 Mar 2016 16:08:18 +0100
From: Petr Tesarik <ptesarik@suse.com>
To: David Sterba <dsterba@suse.cz>
Cc: Flex Liu <fliu@novell.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, linux-kernel@vger.kernel.org,
        Flex Liu <fliu@suse.com>
Subject: Re: [PATCH 1/1] Btrfs: Code Cleanup
Message-ID: <20160324160818.57850176@hananiah.suse.cz>
In-Reply-To: <20160324150307.GR29764@twin.jikos.cz>
References: <1458457871-25512-1-git-send-email-fliu@novell.com>
	<20160324150307.GR29764@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 24 Mar 2016 16:03:07 +0100
David Sterba <dsterba@suse.cz> wrote:

> On Sun, Mar 20, 2016 at 03:11:11PM +0800, Flex Liu wrote:
>[...]
> > --- a/fs/btrfs/volumes.c
> > +++ b/fs/btrfs/volumes.c
> > @@ -2325,7 +2325,10 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
> >  	if (seeding_dev) {
> >  		sb->s_flags &= ~MS_RDONLY;
> >  		ret = btrfs_prepare_sprout(root);
> > -		BUG_ON(ret); /* -ENOMEM */
> > +		if (ret) {
> > +			btrfs_abort_transaction(trans, root, ret);
> 
> The transaction abort seems a bit heavy as it will take down the whole
> filesystem. It's called from the device add ioctl, this is a restartable
> operation.
> 
> Unfortunatelly btrfs_prepare_sprout is called after the transaction
> start so btrfs_abort_transaction must be called. To avoid it, the code
> would need to be reorganized, so the memory allocations happen in
> advance.

On the other hand, an abort is still better than a BUG_ON(), and it may
be easier to make incremental improvements.

Just my 2 cents (I haven't tried it),
Petr T
