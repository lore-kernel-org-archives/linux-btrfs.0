Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tetsuo.zabbo.net ([50.193.208.193]:56036 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753581Ab2GaVav (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 31 Jul 2012 17:30:51 -0400
Date: Tue, 31 Jul 2012 14:30:49 -0700
From: Zach Brown <zab@zabbo.net>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: unlock extent when the dio completes for reads
Message-ID: <20120731213049.GB31939@lenny.home.zabbo.net>
References: <1343766827-6674-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1343766827-6674-1-git-send-email-jbacik@fusionio.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> +static void btrfs_direct_read_iodone(struct kiocb *iocb, loff_t offset,
> +				     ssize_t bytes, void *private, int ret,
> +				     bool is_async)
> +{
> +	struct inode *inode = iocb->ki_filp->f_mapping->host;
> +	u64 lockend;
> +
> +	if (get_state_private(&BTRFS_I(inode)->io_tree, offset, &lockend)) {
> +		WARN_ON(1);
> +		goto out;
> +	}
> +
> +	unlock_extent(&BTRFS_I(inode)->io_tree, offset, lockend);
> +out:
> +	if (is_async)
> +		aio_complete(iocb, ret, 0);
> +	inode_dio_done(inode);
> +}

Hmm.  I'm worried that this can be called from interrupt context and the
state/extent calls there seem to use bare spin locks.  Did you run this
with lockdep?  Am I confused?

- z
