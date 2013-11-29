Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55989 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756923Ab3K2RFt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Nov 2013 12:05:49 -0500
Date: Fri, 29 Nov 2013 18:05:47 +0100
From: David Sterba <dsterba@suse.cz>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, clm@fb.com,
        Alex Lyakas <alex.btrfs@zadarastorage.com>
Subject: Re: [PATCH] btrfs-progs: add options to sync filesystem after subvol
 delete
Message-ID: <20131129170547.GO25312@suse.cz>
Reply-To: dsterba@suse.cz
References: <1385657947-26145-1-git-send-email-dsterba@suse.cz>
 <52982287.4040808@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <52982287.4040808@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 29, 2013 at 01:13:43PM +0800, Miao Xie wrote:
> >  static int cmd_subvol_delete(int argc, char **argv)
> >  {
> > -	int	res, fd, len, e, cnt = 1, ret = 0;
> > +	int	res, len, e, ret = 0;
> > +	int cnt;
> > +	int fd = -1;
> >  	struct btrfs_ioctl_vol_args	args;
> >  	char	*dname, *vname, *cpath;
> >  	char	*dupdname = NULL;
> >  	char	*dupvname = NULL;
> >  	char	*path;
> >  	DIR	*dirstream = NULL;
> > +	int sync_mode = 0;
> > +	struct option long_options[] = {
> > +		{"sync-after", no_argument, NULL, 's'},	/* sync mode 1 */
> > +		{"sync-each", no_argument, NULL, 'S'},	/* sync mode 2 */
> > +		{NULL, 0, NULL, 0}
> > +	};
> 
> Generally, we put it out of the functions.

I see that there are several long option definitions inside the function
that uses them, one example is in the same file in cmds_subvol_list, and
I've followed that pattern.

I think it makes a bit more sense to keep the options local to the
function, definition and usage are close together. The does not have
more than one user, although this is possible but unlikely among btrfs
commands.

> > @@ -285,14 +326,38 @@ again:
> >  		goto out;
> >  	}
> >  
> > +	if (sync_mode == 1) {
> > +		res = ioctl(fd, BTRFS_IOC_SYNC);
> 
> It will flush all the dirty pages, it is unnecessary. I think
> BTRFS_IOC_{START, WAIT}_SYNC is better.

I agree and this is what I actually wanted.
