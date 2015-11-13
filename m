Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52582 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932455AbbKMRRk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Nov 2015 12:17:40 -0500
Date: Fri, 13 Nov 2015 18:16:02 +0100
From: David Sterba <dsterba@suse.cz>
To: Florian Margaine <florian.margaine@commerceguys.com>
Cc: Karel Zak <kzak@redhat.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: Fix partitioned loop devices resolve.
Message-ID: <20151113171602.GS6445@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <56409A52.2000708@commerceguys.com>
 <20151109141256.GW19508@ws.net.home>
 <5641AC4A.2090703@commerceguys.com>
 <20151110115018.GY19508@ws.net.home>
 <5644579B.3000102@commerceguys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5644579B.3000102@commerceguys.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 12, 2015 at 10:10:51AM +0100, Florian Margaine wrote:
> New patch is attached.

Applied with some modifications, thanks.

> +/*
> + * Takes a loop device path (e.g. /dev/loop0) and returns
> + * the associated file (e.g. /images/my_btrfs.img) using
> + * loopdev API
> + */
> +static int resolve_loop_device_with_loopdev(const char* loop_dev, char* loop_file)
> +{
> +	int fd;
> +	struct loop_info64 lo64;
> +
> +	if (!(fd = open(loop_dev, O_RDONLY | O_NONBLOCK)))

fd = ... moved before if

> +		return -errno;
> +	if (ioctl(fd, LOOP_GET_STATUS64, &lo64) != 0)

open and ioctl return < 0 in case of error

> +		return -errno;
> +
> +	memcpy(loop_file, lo64.lo_file_name, strlen(lo64.lo_file_name) + 1);
> +	if (close(fd) != 0)
> +		return -errno;
> +
> +	return 0;
> +}
> 
>  /* Takes a loop device path (e.g. /dev/loop0) and returns
>   * the associated file (e.g. /images/my_btrfs.img) */
> @@ -1185,5 +1206,10 @@ static int resolve_loop_device(const char* loop_dev, char* loop_file,
>  	if (!realpath(loop_dev, real_loop_dev))
>  		return -errno;
>  	snprintf(p, PATH_MAX, "/sys/block/%s/loop/backing_file", strrchr(real_loop_dev, '/'));
> -	if (!(f = fopen(p, "r")))
> +	if (!(f = fopen(p, "r"))) {
> +		if (errno == ENOENT)
> +			/* It's possibly a partitioned loop device, which
> +			   is resolvable with loopdev API. */

comment style fixed

> +			return resolve_loop_device_with_loopdev(loop_dev, loop_file);
>  		return -errno;
> +	}
> 
>  	snprintf(fmt, 20, "%%%i[^\n]", max_len-1);
>  	ret = fscanf(f, fmt, loop_file);

