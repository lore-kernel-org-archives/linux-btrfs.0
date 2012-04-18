From: Arne Jansen <sensille@gmx.net>
Subject: Re: [PATCH v2] btrfs: don't return EINTR
Date: Wed, 18 Apr 2012 16:22:25 +0200
Message-ID: <4F8ECE21.6010008@gmx.net>
References: <1334737636-16580-1-git-send-email-sensille@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Josef Bacik <josef@redhat.com>,
	Chris Mason <chris.mason@oracle.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1334737636-16580-1-git-send-email-sensille@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

On 18.04.2012 10:27, Arne Jansen wrote:
> It is basically a good thing if we are interruptible when waiting for
> free space, but the generality in which it is implemented currently
> leads to system calls being interruptible that are not documented this
> way. For example git can't handle interrupted unlink(), leading to
> corrupt repos under space pressure.
> Instead we raise the bar to only be interruptible by SIGKILL.
> Thanks to David Sterba for suggesting this.
> 
> Signed-off-by: Arne Jansen <sensille@gmx.net>

So, is this patch a candidate for the next rc? ;)

-Arne


> ---
>  fs/btrfs/extent-tree.c |    9 +++------
>  1 files changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 2b35f8d..10d4bb7 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -3769,13 +3769,10 @@ again:
>  		 */
>  		if (current->journal_info)
>  			return -EAGAIN;
> -		ret = wait_event_interruptible(space_info->wait,
> -					       !space_info->flush);
> -		/* Must have been interrupted, return */
> -		if (ret) {
> -			printk(KERN_DEBUG "btrfs: %s returning -EINTR\n", __func__);
> +		ret = wait_event_killable(space_info->wait, !space_info->flush);
> +		/* Must have been killed, return */
> +		if (ret)
>  			return -EINTR;
> -		}
>  
>  		spin_lock(&space_info->lock);
>  	}

