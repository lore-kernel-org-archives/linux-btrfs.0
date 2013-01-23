Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52934 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754339Ab3AWPqL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Jan 2013 10:46:11 -0500
Date: Wed, 23 Jan 2013 16:46:08 +0100
From: David Sterba <dsterba@suse.cz>
To: Chen Yang <chenyang.fnst@cn.fujitsu.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs-progs/receive: sparse and pre-allocated file
 support, for btrfs-send mechanism
Message-ID: <20130123154607.GJ28263@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <50FF58B6.5020102@cn.fujitsu.com>
 <50FFC3C1.7020105@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50FFC3C1.7020105@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 23, 2013 at 07:04:33PM +0800, Chen Yang wrote:
> When sending a file with sparse or pre-allocated part,
> these parts will be sent as ZERO streams, and it's unnecessary.
> 
> To improve this, we add a punch command on the sending side, so the
> receiving side changed with it. The main change is adding the punch
> processing to receive command.
> 
> +static int process_punch(const char *path, u64 offset, u64 len, void *user)
> +{
> +	int ret = 0;
> +	struct btrfs_receive *r = user;
> +	char *full_path = path_cat(r->full_subvol_path, path);
> +
> +	ret = open_inode_for_write(r, full_path);
> +	if (ret < 0)
> +		goto out;
> +
> +	ret = fallocate(r->write_fd,
> +		FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
> +		offset, len);

This unnecessarily fails if PUNCH_HOLE is not supported by the kernel
version, some sort of fallback should be applied.

> +	if (ret < 0) {
> +		ret = -errno;
> +		fprintf(stderr, "ERROR: punch %s failed. %s\n",
> +				path, strerror(-ret));
> +		goto out;
> +	}
> +
> +out:
> +	free(full_path);
> +	return ret;
> +}

david
