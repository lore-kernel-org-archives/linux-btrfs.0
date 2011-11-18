From: Chris Samuel <chris@csamuel.org>
Subject: Re: [PATCH] Btrfs: Don't error on resizing FS to same size
Date: Fri, 18 Nov 2011 15:52:00 +1100
Message-ID: <4EC5E470.4030605@csamuel.org>
References: <20111117210433.GA1817@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Mike Fleetwood <mike.fleetwood@googlemail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111117210433.GA1817@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 18/11/11 08:04, Mike Fleetwood wrote:

> It seems overly harsh to fail a resize of a btrfs file system to the
> same size when a shrink or grow would succeed.  User app GParted trips
> over this error.  Allow it by bypassing the shrink or grow operation.

OK - I'm a newbie with the code (and I'm looking at Linus's current git
rather than any dev tree of Chris's), but...

> Signed-off-by: Mike Fleetwood <mike.fleetwood@googlemail.com>
> ---
[...]
> ---
>  fs/btrfs/ioctl.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index dae5dfe..00b7024 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -1251,7 +1251,7 @@ static noinline int btrfs_ioctl_resize(struct btrfs_root *root,
>  		}
>  		ret = btrfs_grow_device(trans, device, new_size);
>  		btrfs_commit_transaction(trans, root);
> -	} else {
> +	} else if (new_size > old_size) {

shouldn't that be:

+	} else if (new_size < old_size) {

otherwise you'll never try and shrink if new_size is < old_size..

>  		ret = btrfs_shrink_device(device, new_size);
>  	}
>  


-- 
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC
