From: Arne Jansen <sensille@gmx.net>
Subject: Re: [PATCH] btrfs: don't return EINTR
Date: Tue, 17 Apr 2012 16:15:32 +0200
Message-ID: <4F8D7B04.9050904@gmx.net>
References: <1334408175-6568-1-git-send-email-sensille@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1334408175-6568-1-git-send-email-sensille@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

On 14.04.2012 14:56, Arne Jansen wrote:
> It is basically a good thing if we are interruptible when waiting for
> free space, but the generality in which it is implemented currently
> leads to system calls being interruptible that are not documented this
> way. For example git can't handle interrupted unlink(), leading to
> corrupt repos under space pressure.

Is this patch a candidate for the next rc?

-Arne

> 
> Signed-off-by: Arne Jansen <sensille@gmx.net>
> ---
>  fs/btrfs/extent-tree.c |    9 +--------
>  1 files changed, 1 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index a844204..db13e51 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -3772,14 +3772,7 @@ again:
>  		 */
>  		if (current->journal_info)
>  			return -EAGAIN;
> -		ret = wait_event_interruptible(space_info->wait,
> -					       !space_info->flush);
> -		/* Must have been interrupted, return */
> -		if (ret) {
> -			printk(KERN_DEBUG "btrfs: %s returning -EINTR\n", __func__);
> -			return -EINTR;
> -		}
> -
> +		wait_event(space_info->wait, !space_info->flush);
>  		spin_lock(&space_info->lock);
>  	}
>  

