Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:59575 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752254AbcLIBJi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Dec 2016 20:09:38 -0500
Subject: Re: [PATCH 2/2] btrfs-convert: Fix migrate_super_block() to work with
 64k sectorsize
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        <linux-btrfs@vger.kernel.org>
References: <1481205380-22978-1-git-send-email-chandan@linux.vnet.ibm.com>
 <1481205380-22978-2-git-send-email-chandan@linux.vnet.ibm.com>
CC: <dsterba@suse.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <c861f566-09fd-3f41-ddfa-da5a9d08c04b@cn.fujitsu.com>
Date: Fri, 9 Dec 2016 09:09:29 +0800
MIME-Version: 1.0
In-Reply-To: <1481205380-22978-2-git-send-email-chandan@linux.vnet.ibm.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 12/08/2016 09:56 PM, Chandan Rajendra wrote:
> migrate_super_block() uses sectorsize to refer to the size of the
> superblock. Hence on 64k sectorsize filesystems, it ends up computing
> checksum beyond the super block length (i.e.
> BTRFS_SUPER_INFO_SIZE). This commit fixes the bug by using
> BTRFS_SUPER_INFO_SIZE instead of sectorsize of the underlying
> filesystem.
>
> Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>

Reviewed-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

BTW would you please enhance the convert tests?
Current convert tests only uses 4K as block size.
So adding 64K blocksize would definitely improve the tests.

Thanks,
Qu

> ---
>  convert/main.c | 23 ++++++++++++-----------
>  1 file changed, 12 insertions(+), 11 deletions(-)
>
> diff --git a/convert/main.c b/convert/main.c
> index 1148a36..fd6f77b 100644
> --- a/convert/main.c
> +++ b/convert/main.c
> @@ -1360,7 +1360,7 @@ err:
>  /*
>   * Migrate super block to its default position and zero 0 ~ 16k
>   */
> -static int migrate_super_block(int fd, u64 old_bytenr, u32 sectorsize)
> +static int migrate_super_block(int fd, u64 old_bytenr)
>  {
>  	int ret;
>  	struct extent_buffer *buf;
> @@ -1368,13 +1368,13 @@ static int migrate_super_block(int fd, u64 old_bytenr, u32 sectorsize)
>  	u32 len;
>  	u32 bytenr;
>
> -	buf = malloc(sizeof(*buf) + sectorsize);
> +	buf = malloc(sizeof(*buf) + BTRFS_SUPER_INFO_SIZE);
>  	if (!buf)
>  		return -ENOMEM;
>
> -	buf->len = sectorsize;
> -	ret = pread(fd, buf->data, sectorsize, old_bytenr);
> -	if (ret != sectorsize)
> +	buf->len = BTRFS_SUPER_INFO_SIZE;
> +	ret = pread(fd, buf->data, BTRFS_SUPER_INFO_SIZE, old_bytenr);
> +	if (ret != BTRFS_SUPER_INFO_SIZE)
>  		goto fail;
>
>  	super = (struct btrfs_super_block *)buf->data;
> @@ -1382,19 +1382,20 @@ static int migrate_super_block(int fd, u64 old_bytenr, u32 sectorsize)
>  	btrfs_set_super_bytenr(super, BTRFS_SUPER_INFO_OFFSET);
>
>  	csum_tree_block_size(buf, BTRFS_CRC32_SIZE, 0);
> -	ret = pwrite(fd, buf->data, sectorsize, BTRFS_SUPER_INFO_OFFSET);
> -	if (ret != sectorsize)
> +	ret = pwrite(fd, buf->data, BTRFS_SUPER_INFO_SIZE,
> +		BTRFS_SUPER_INFO_OFFSET);
> +	if (ret != BTRFS_SUPER_INFO_SIZE)
>  		goto fail;
>
>  	ret = fsync(fd);
>  	if (ret)
>  		goto fail;
>
> -	memset(buf->data, 0, sectorsize);
> +	memset(buf->data, 0, BTRFS_SUPER_INFO_SIZE);
>  	for (bytenr = 0; bytenr < BTRFS_SUPER_INFO_OFFSET; ) {
>  		len = BTRFS_SUPER_INFO_OFFSET - bytenr;
> -		if (len > sectorsize)
> -			len = sectorsize;
> +		if (len > BTRFS_SUPER_INFO_SIZE)
> +			len = BTRFS_SUPER_INFO_SIZE;
>  		ret = pwrite(fd, buf->data, len, bytenr);
>  		if (ret != len) {
>  			fprintf(stderr, "unable to zero fill device\n");
> @@ -2519,7 +2520,7 @@ static int do_convert(const char *devname, int datacsum, int packing,
>  	 * If this step succeed, we get a mountable btrfs. Otherwise
>  	 * the source fs is left unchanged.
>  	 */
> -	ret = migrate_super_block(fd, mkfs_cfg.super_bytenr, blocksize);
> +	ret = migrate_super_block(fd, mkfs_cfg.super_bytenr);
>  	if (ret) {
>  		error("unable to migrate super block: %d", ret);
>  		goto fail;
>


