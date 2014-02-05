Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:5015 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750941AbaBEXJl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 5 Feb 2014 18:09:41 -0500
Date: Thu, 6 Feb 2014 10:09:36 +1100
From: Dave Chinner <david@fromorbit.com>
To: David Disseldorp <ddiss@suse.de>
Cc: xfs@oss.sgi.com, dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs: add small program for clone testing
Message-ID: <20140205230936.GI13997@dastard>
References: <1391599009-2402-1-git-send-email-ddiss@suse.de>
 <1391599009-2402-2-git-send-email-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1391599009-2402-2-git-send-email-ddiss@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 05, 2014 at 12:16:48PM +0100, David Disseldorp wrote:
> The cloner program is capable of cloning files using the BTRFS_IOC_CLONE
> and BTRFS_IOC_CLONE_RANGE ioctls.
> 
> Signed-off-by: David Disseldorp <ddiss@suse.de>

Hi Dave - long time since I've seen your head pop up around here ;)

A few comments below.

> +struct btrfs_ioctl_clone_range_args {
> +	int64_t src_fd;
> +	uint64_t src_offset;
> +	uint64_t src_length;
> +	uint64_t dest_offset;
> +};
> +
> +#define BTRFS_IOCTL_MAGIC 0x94
> +#define BTRFS_IOC_CLONE       _IOW(BTRFS_IOCTL_MAGIC, 9, int)
> +#define BTRFS_IOC_CLONE_RANGE _IOW(BTRFS_IOCTL_MAGIC, 13, \
> +				   struct btrfs_ioctl_clone_range_args)

Is there some published header file that these belong to? i.e.
somewhere in the include/linux/uapi/ kernel directory? Normally the
way to handle this sort of thing is by autoconf - if the header file
exists, then we include it, otherwise we use the manual definitions.
This just means that if the public api ever changes, we'll pick it
up automatically in future...

> +int
> +main(int argc, char **argv)
> +{
> +	bool full_file = true;
> +	uint64_t src_off = 0;
> +	uint64_t dst_off = 0;
> +	uint64_t len = 0;
> +	char *src_file;
> +	int src_fd;
> +	char *dst_file;
> +	int dst_fd;
> +	int ret;
> +	int opt;
> +
> +	while ((opt = getopt(argc, argv, "s:d:l:")) != -1) {
> +		switch (opt) {
> +		case 's':
> +			src_off = atoi(optarg);

atoi() only returns 32 bit numbers. You probably should use
strtoull() as the offset parameters are 64 bit.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
