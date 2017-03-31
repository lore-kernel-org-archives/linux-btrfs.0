Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:58561 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S934699AbdCaBOK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Mar 2017 21:14:10 -0400
Subject: Re: [PATCH v2] Btrfs: fix wrong failed mirror_num of read-repair on
 raid56
To: Liu Bo <bo.li.liu@oracle.com>, <linux-btrfs@vger.kernel.org>
CC: David Sterba <dsterba@suse.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <4c277733-5c11-43cc-4e7d-294948ebde90@cn.fujitsu.com>
Date: Fri, 31 Mar 2017 09:14:02 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <1490810038-18488-1-git-send-email-bo.li.liu@oracle.com>



At 03/30/2017 01:54 AM, Liu Bo wrote:
> In raid56 scenario, after trying parity recovery, we didn't set
> mirror_num for btrfs_bio with failed mirror_num, hence
> end_bio_extent_readpage() will report a random mirror_num in dmesg
> log.
>
> Cc: David Sterba <dsterba@suse.cz>
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Tested-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

The test case is btrfs/125, with compress=lzo.

Even with ordered_extent error handler enhancement, compress=lzo mount 
option will cause test case to fail due to mismatch csum.

With these patches applied, btrfs/125 passws without error.

Thanks,
Qu
> ---
> v2: Set mirror_num inside raid56_parity_recover so that all callers
> can get a correct mirror_num if they need.
>
>  fs/btrfs/raid56.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
> index 1571bf2..a333acc 100644
> --- a/fs/btrfs/raid56.c
> +++ b/fs/btrfs/raid56.c
> @@ -2118,6 +2118,11 @@ int raid56_parity_recover(struct btrfs_fs_info *fs_info, struct bio *bio,
>  	struct btrfs_raid_bio *rbio;
>  	int ret;
>
> +	if (generic_io) {
> +		ASSERT(bbio->mirror_num == mirror_num);
> +		btrfs_io_bio(bio)->mirror_num = mirror_num;
> +	}
> +
>  	rbio = alloc_rbio(fs_info, bbio, stripe_len);
>  	if (IS_ERR(rbio)) {
>  		if (generic_io)
>


