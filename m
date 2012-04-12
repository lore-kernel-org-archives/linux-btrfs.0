From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] fs: make i_generation a u64
Date: Wed, 11 Apr 2012 20:32:57 -0400
Message-ID: <20120412003257.GH29506@shiny>
References: <1334176968-8687-1-git-send-email-josef@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	viro@ZenIV.linux.org.uk
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1334176968-8687-1-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 11, 2012 at 04:42:48PM -0400, Josef Bacik wrote:
> Btrfs stores generation numbers as 64bit numbers, which means we have to
> carry around a u64 in our incore inode in addition to setting i_generation.
> So convert to a u64 so btrfs can kill it's incore generation.  Thanks,
> 
> Signed-off-by: Josef Bacik <josef@redhat.com>
> ---
>  include/linux/fs.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 9be896d..40564e0 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -831,7 +831,7 @@ struct inode {
>  		struct cdev		*i_cdev;
>  	};
>  
> -	__u32			i_generation;
> +	u64			i_generation;

Why was this using __u32 instead of u32?

-chris
