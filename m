From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] 'unused' calculated with wrong sign.
Date: Fri, 12 Nov 2010 16:53:13 -0500
Message-ID: <20101112215312.GA2657@localhost.localdomain>
References: <1289603876-28542-1-git-send-email-sensille@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, josef@redhat.com
To: Arne Jansen <sensille@gmx.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1289603876-28542-1-git-send-email-sensille@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Nov 13, 2010 at 12:17:56AM +0100, Arne Jansen wrote:
> 'unused' calculated with wrong sign in reserve_metadata_bytes().
> This might have lead to unwanted over-reservations.
> 
> Signed-off-by: Arne Jansen <sensille@gmx.net>
> ---
>  fs/btrfs/extent-tree.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index a541bc8..ddaf634 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -3413,7 +3413,7 @@ again:
>  	 * our reservation.
>  	 */
>  	if (unused <= space_info->total_bytes) {
> -		unused -= space_info->total_bytes;
> +		unused = space_info->total_bytes - unused;
>  		if (unused >= num_bytes) {
>  			if (!reserved)
>  				space_info->bytes_reserved += orig_bytes;
> -- 
> 1.7.2.2
> 

Good catch

Reviewed-by: Josef Bacik <josef@redhat.com>

Thanks,

Josef
