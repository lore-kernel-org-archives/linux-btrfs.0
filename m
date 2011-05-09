From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH 3/4] btrfs: don't spin in shrink_delalloc if there is
 nothing to free
Date: Mon, 09 May 2011 12:00:28 -0400
Message-ID: <4DC80F9C.10706@redhat.com>
References: <1304803784-23756-1-git-send-email-slyfox@gentoo.org> <1304803784-23756-2-git-send-email-slyfox@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
	Sergei Trofimovich <slyfox@gentoo.org>
To: slyich@gmail.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1304803784-23756-2-git-send-email-slyfox@gentoo.org>
List-ID: <linux-btrfs.vger.kernel.org>

On 05/07/2011 05:29 PM, slyich@gmail.com wrote:
> Observed as a large delay when --mixed filesystem is filled up.
> Test example:
> 1. create tiny --mixed FS:
>     $ dd if=/dev/zero of=2G.img seek=$((2048 * 1024 * 1024 - 1)) count=1 bs=1
>     $ mkfs.btrfs --mixed 2G.img
>     $ mount -oloop 2G.img /mnt/ut/
> 2. Try to fill it up:
>     $ dd if=/dev/urandom of=10M.file bs=10240 count=1024
>     $ seq 1 256 | while read file_no; do echo $file_no; time cp 10M.file ${file_no}.copy; done
>
> Up to '200.copy' it goes fast, but when disk fills-up each -ENOSPC
> message takes 3 seconds to pop-up _every_ ENOSPC (and in usermode linux
> it's even more: 30-60 seconds!). (Maybe, time depends on kernel's timer resolution).
>
> No IO, no CPU load, just rescheduling. Some debugging revealed busy spinning
> in shrink_delalloc.
>
> Signed-off-by: Sergei Trofimovich<slyfox@gentoo.org>
> ---
>   fs/btrfs/extent-tree.c |    4 ++++
>   1 files changed, 4 insertions(+), 0 deletions(-)
>
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 9ee6bd5..9f5fdd3 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -3425,6 +3425,10 @@ static int shrink_delalloc(struct btrfs_trans_handle *trans,
>   	if (reserved == 0)
>   		return 0;
>
> +	/* nothing to shrink - nothing to reclaim */
> +	if (root->fs_info->delalloc_bytes == 0)
> +		return 0;
> +
>   	max_reclaim = min(reserved, to_reclaim);
>
>   	while (loops<  1024) {

Nice catch, you can add

Reviewed-by: Josef Bacik <josef@redhat.com>

Thanks,

Josef
