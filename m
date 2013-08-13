Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:49763 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756967Ab3HMTOL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 13 Aug 2013 15:14:11 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id E7C829A06B6
	for <linux-btrfs@vger.kernel.org>; Tue, 13 Aug 2013 13:14:10 -0600 (MDT)
Date: Tue, 13 Aug 2013 15:14:08 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Anand Jain <anand.jain@oracle.com>
CC: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>
Subject: Re: [PATCH 4/6] btrfs-progs: mkfs.c overwrites fd without
 appropriate close
Message-ID: <20130813191408.GI2150@localhost.localdomain>
References: <1374773730-29957-1-git-send-email-anand.jain@oracle.com>
 <1374773730-29957-5-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1374773730-29957-5-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 26, 2013 at 01:35:28AM +0800, Anand Jain wrote:
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  mkfs.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/mkfs.c b/mkfs.c
> index 60f906c..66f558a 100644
> --- a/mkfs.c
> +++ b/mkfs.c
> @@ -1570,6 +1570,8 @@ int main(int ac, char **av)
>  		 * occur by the following processing.
>  		 * (btrfs_register_one_device() fails if O_EXCL is on)
>  		 */
> +		if (fd > 0)
> +			close(fd);
>  		fd = open(file, O_RDWR);
>  		if (fd < 0) {
>  			fprintf(stderr, "unable to open %s: %s\n", file,
> @@ -1581,7 +1583,6 @@ int main(int ac, char **av)
>  		if (ret) {
>  			fprintf(stderr, "skipping duplicate device %s in FS\n",
>  				file);
> -			close(fd);
>  			continue;
>  		}
>  		ret = btrfs_prepare_device(fd, file, zero_end, &dev_block_count,

This breaks mkfs with multiple disks.  Please for the love of all that is holy
just do a xfstests run with your patches to make sure they don't break anything
so when I go to try to test something completely different I don't have to waste
time bisecting down to figure out wtf you broke today?  David can you kick this
one out of integration for the time being please?  Thanks,

Josef
