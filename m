Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:7424 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753547AbcLIBEG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Dec 2016 20:04:06 -0500
Subject: Re: [PATCH 1/2] btrfs-progs: btrfs-convert: Prevent accounting blocks
 beyond end of device
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        <linux-btrfs@vger.kernel.org>
References: <1481205380-22978-1-git-send-email-chandan@linux.vnet.ibm.com>
CC: <dsterba@suse.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <c618e6f8-7a20-30f5-7e5b-9a143fbba334@cn.fujitsu.com>
Date: Fri, 9 Dec 2016 09:04:02 +0800
MIME-Version: 1.0
In-Reply-To: <1481205380-22978-1-git-send-email-chandan@linux.vnet.ibm.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chandan,

Thanks for the patch.

At 12/08/2016 09:56 PM, Chandan Rajendra wrote:
> When looping across data block bitmap, __ext2_add_one_block() may add
> blocks which do not exist on the underlying disk. This commit prevents
> this from happening by checking the block index against the maximum
> block count that was present in the ext4 filesystem instance that is
> being converted.

The patch looks good to me.

Reviewed-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Just curious about if such image can pass e2fsck.
And would you please upload a minimal image as btrfs-progs test case?

Thanks,
Qu

>
> Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> ---
>  convert/main.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/convert/main.c b/convert/main.c
> index 4b4cea4..1148a36 100644
> --- a/convert/main.c
> +++ b/convert/main.c
> @@ -1525,6 +1525,9 @@ static int __ext2_add_one_block(ext2_filsys fs, char *bitmap,
>  	offset /= EXT2FS_CLUSTER_RATIO(fs);
>  	offset += group_nr * EXT2_CLUSTERS_PER_GROUP(fs->super);
>  	for (i = 0; i < EXT2_CLUSTERS_PER_GROUP(fs->super); i++) {
> +		if ((i + offset) >= ext2fs_blocks_count(fs->super))
> +			break;
> +
>  		if (ext2fs_test_bit(i, bitmap)) {
>  			u64 start;
>
>


