Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43114 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965586AbcIWNY4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Sep 2016 09:24:56 -0400
Date: Fri, 23 Sep 2016 15:22:52 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, hawken@thehawken.org
Subject: Re: [PATCH 1/2] btrfs-progs: Return more meaningful value for
 btrfs_read_dev_super
Message-ID: <20160923132252.GY16983@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20160920021902.818-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160920021902.818-1-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 20, 2016 at 10:19:01AM +0800, Qu Wenruo wrote:
> btrfs_read_dev_super() only returns 0 or -1, which doesn't really help,
> caller won't know if it's caused by bad superblock or superblock out of
> range.
> 
> Change it to return -ENOENT for superblock which is out of range, and
> return -EIO for bad superblocks.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
>  disk-io.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/disk-io.c b/disk-io.c
> index 854c285..26852ee 100644
> --- a/disk-io.c
> +++ b/disk-io.c
> @@ -1590,14 +1590,15 @@ int btrfs_read_dev_super(int fd, struct btrfs_super_block *sb, u64 sb_bytenr,
>  
>  	if (sb_bytenr != BTRFS_SUPER_INFO_OFFSET) {
>  		ret = pread64(fd, buf, BTRFS_SUPER_INFO_SIZE, sb_bytenr);

pread64 sets errno, should be returned

> +		/* Special return value for out of dev/file range */
>  		if (ret < BTRFS_SUPER_INFO_SIZE)
> -			return -1;
> +			return -ENOENT;
>  
>  		if (btrfs_super_bytenr(buf) != sb_bytenr)
> -			return -1;
> +			return -EIO;
>  
>  		if (check_super(buf, sbflags))
> -			return -1;
> +			return -EIO;

and we should return what check_super returns, though it's -EIO in most
cases.
