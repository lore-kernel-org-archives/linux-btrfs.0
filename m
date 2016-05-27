Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:14222 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751206AbcE0PoO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 May 2016 11:44:14 -0400
Subject: Re: [PATCH 1/5] Btrfs: test_check_exists: Fix infinite loop when
 searching for free space entries
To: Feifei Xu <xufeifei@linux.vnet.ibm.com>, <linux-btrfs@vger.kernel.org>
References: <1464332438-19119-1-git-send-email-xufeifei@linux.vnet.ibm.com>
 <201605270750.u4R7n6to033453@mx0a-001b2d01.pphosted.com>
CC: <steve.capper@linaro.org>, <chandan@mykolab.com>, <dsterba@suse.com>,
        <feifeixu.sh@gmail.com>
From: Josef Bacik <jbacik@fb.com>
Message-ID: <0b4d85f8-d981-39a9-8b6b-329d0e648fce@fb.com>
Date: Fri, 27 May 2016 11:43:55 -0400
MIME-Version: 1.0
In-Reply-To: <201605270750.u4R7n6to033453@mx0a-001b2d01.pphosted.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/27/2016 03:00 AM, Feifei Xu wrote:
> On a ppc64 machine using 64K as the block size, assume that the RB
> tree at btrfs_free_space_ctl->free_space_offset contains following
> two entries:
>
> 1. A bitmap entry having an offset value of 0 and having the bits
>    corresponding to the address range [128M+512K, 128M+768K] set.
> 2. An extent entry corresponding to the address range
>    [128M-256K, 128M-128K]
>
> In such a scenario, test_check_exists() invoked for checking the
> existence of address range [128M+768K, 256M] can lead to an
> infinite loop as explained below:
>
> - Checking for the extent entry fails.
> - Checking for a bitmap entry results in the free space info in
>   range [128M+512K, 128M+768K] beng returned.
> - rb_prev(info) returns NULL because the bitmap entry starting from
>   offset 0 comes first in the RB tree.
> - current_node = bitmap node.
> - while (current_node)
>     tmp = rb_next(bitmap_node);/*tmp is extent based free space entry*/
>     Since extent based free space entry's last address is smaller
>     than the address being searched for (i.e. 128M+768K) we
>     incorrectly again obtain the extent node as the "next right node"
>     of the RB tree and thus end up looping infinitely.
>
> This patch fixes the issue by updating "info" variable to point to
> the most recently searched free space node.
>
> Reviewed-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> Signed-off-by: Feifei Xu <xufeifei@linux.vnet.ibm.com>
> ---
>  fs/btrfs/free-space-cache.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
> index 5e6062c..05c9ef8 100644
> --- a/fs/btrfs/free-space-cache.c
> +++ b/fs/btrfs/free-space-cache.c
> @@ -3662,6 +3662,7 @@ have_info:
>  			if (tmp->offset + tmp->bytes < offset)
>  				break;
>  			if (offset + bytes < tmp->offset) {
> +				info = tmp;
>  				n = rb_prev(&info->offset_index);
>  				continue;
>  			}
> @@ -3676,6 +3677,7 @@ have_info:
>  			if (offset + bytes < tmp->offset)
>  				break;
>  			if (tmp->offset + tmp->bytes < offset) {
> +				info = tmp;
>  				n = rb_next(&info->offset_index);
>  				continue;
>  			}
>

Just make it rb_next(&tmp->offset_index)/rb_prev(&tmp->offset_index) 
instead of doing the info = tmp thing.  Thanks,

Josef
