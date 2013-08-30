Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59818 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753529Ab3H3XWf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 30 Aug 2013 19:22:35 -0400
Date: Sat, 31 Aug 2013 01:22:33 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH v2] btrfs-progs: mkfs should check for small vol well
 before
Message-ID: <20130830232233.GV23113@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1376657550-15011-1-git-send-email-anand.jain@oracle.com>
 <1377852637-4299-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1377852637-4299-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 30, 2013 at 04:50:37PM +0800, Anand Jain wrote:
> This fix the regression introduced by 830427d

ie. that's
"btrfs-progs: avoid write to the disk before sure to create fs"

please note that the commit id is not stable and may change during
integration branch updates.

I was not sure if the patch is all ok and had put it into
integration-next branch (that serves me as a unstable area for things
that I'd like to look at again). The patch caused Josef some headaches
and I've left it out from recent integration branches until the problems
are resolved. With the patch in this email you do so, but let me do more
testing and then I'll integrate it.

> --- a/utils.c
> +++ b/utils.c
> @@ -1964,3 +1964,32 @@ int scan_for_btrfs(int where, int update_kernel)
> +int is_vol_small(char *file)
> +{
> +	int fd = -1;
> +	int e;
> +	struct stat st;
> +	u64 size;
> +
> +	fd = open(file, O_RDONLY);
> +	if (fd < 0)
> +		return -errno;
> +	if (fstat(fd, &st) < 0) {
> +		e = -errno;
> +		close(fd);
> +		return e;
> +	}
> +	size = btrfs_device_size(fd, &st);
> +	if (size == 0) {
> +		close(fd);
> +		return -1;
> +	}
> +	if (size < 1024 * 1024 * 1024) {

Would be good to use a properly named constant instead of the magic
number.

thanks,
david
