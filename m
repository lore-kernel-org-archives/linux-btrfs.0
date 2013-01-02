Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:32845 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752461Ab3ABTBf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 2 Jan 2013 14:01:35 -0500
Date: Wed, 2 Jan 2013 11:01:33 -0800
From: Mark Fasheh <mfasheh@suse.de>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Cc: chris.mason@fusionio.com, ablock84@googlemail.com,
        Jeff Mahoney <jeffm@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [RFC] btrfs send without data updates?
Message-ID: <20130102190133.GE12558@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <20121231213307.GC12558@wotan.suse.de> <50E41D80.6020005@jan-o-sch.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50E41D80.6020005@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 02, 2013 at 12:44:00PM +0100, Jan Schmidt wrote:
> Hi Mark,
> 
> I like your approach in general. Two comments on the patch below.

Oh great! Thanks for looking at this Jan!


> > diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> > index e78b297..f97b5e6 100644
> > --- a/fs/btrfs/send.c
> > +++ b/fs/btrfs/send.c
> > @@ -85,6 +85,7 @@ struct send_ctx {
> >  	u32 send_max_size;
> >  	u64 total_send_size;
> >  	u64 cmd_send_size[BTRFS_SEND_C_MAX + 1];
> > +	u64 flags;	/* 'flags' member of btrfs_ioctl_send_args is u64 */
> >  
> >  	struct vfsmount *mnt;
> >  
> > @@ -3707,6 +3708,42 @@ out:
> >  	return ret;
> >  }
> >  
> > +/*
> > + * Send an update extent command to user space.
> > + */
> > +static int send_update_extent(struct send_ctx *sctx,
> > +			      u64 offset, u32 len)
> > +{
> > +	int ret = 0;
> > +	struct fs_path *p;
> > +
> > +verbose_printk("btrfs: send_update_extent offset=%llu, len=%d\n", offset, len);
> 
> I know the send code has some of those, too, but it really shouldn't. Please
> don't add any new ones. If you think that's useful, please use proper
> indentation or even better, pr_debug with proper indentation.

Ugh yeah I see that now. Definitely I was "going with the flow" so to speak.
I'll kill that line completely most likely. It's not really telling us a
whole lot I couldn't get from other means.


> > +
> > +	p = fs_path_alloc(sctx);
> > +	if (!p)
> > +		return -ENOMEM;
> > +
> > +	ret = begin_cmd(sctx, BTRFS_SEND_C_UPDATE_EXTENT);
> > +	if (ret < 0)
> > +		goto out;
> > +
> > +	ret = get_cur_path(sctx, sctx->cur_ino, sctx->cur_inode_gen, p);
> > +	if (ret < 0)
> > +		goto out;
> > +
> > +	TLV_PUT_U64(sctx, BTRFS_SEND_A_FILE_OFFSET, offset);
> > +	TLV_PUT_U64(sctx, BTRFS_SEND_A_CLONE_LEN, len);
> > +	TLV_PUT_PATH(sctx, BTRFS_SEND_A_PATH, p);
> > +	TLV_PUT_U64(sctx, BTRFS_SEND_A_SIZE, len);
> 
> Having both CLONE_LEN and SIZE doesn't seem right. The sequence seems a bit odd
> here, too, but it's in good company with the rest of send.c.

You're right though that CLONE_LEN doesn't have any reason to be there. I'm
partial to changing the sequence then:

	TLV_PUT_PATH(sctx, BTRFS_SEND_A_PATH, p);
	TLV_PUT_U64(sctx, BTRFS_SEND_A_FILE_OFFSET, offset);
	TLV_PUT_U64(sctx, BTRFS_SEND_A_SIZE, len);

Seems more sane from a readability standpoint. "Oh, this <path> had an
extent change in the range (<offset>, <len>).

Thanks again!
	--Mark

--
Mark Fasheh
