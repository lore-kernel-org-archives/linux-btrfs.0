From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] btrfs: Mem leak in btrfs_get_acl()
Date: Fri, 07 Jan 2011 14:52:10 +0530
Message-ID: <87vd21kr0d.fsf@linux.vnet.ibm.com>
References: <alpine.LNX.2.00.1101062242320.13988@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
To: Jesper Juhl <jj@chaosbits.net>, linux-btrfs@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1101062242320.13988@swampdragon.chaosbits.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 6 Jan 2011 22:45:21 +0100 (CET), Jesper Juhl <jj@chaosbits.net> wrote:
> 
> It seems to me that we leak the memory allocated to 'value' in 
> btrfs_get_acl() if the call to posix_acl_from_xattr() fails.
> Here's a patch that attempts to correct that problem.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

I posted a similar patch long time back.  But never got picked up

http://article.gmane.org/gmane.comp.file-systems.btrfs/6164

Message-id:"1279547924-25141-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com"

> ---
>  acl.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
>   compile tested only.
> 
> diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
> index 2222d16..6d1410e 100644
> --- a/fs/btrfs/acl.c
> +++ b/fs/btrfs/acl.c
> @@ -60,8 +60,10 @@ static struct posix_acl *btrfs_get_acl(struct inode *inode, int type)
>  		size = __btrfs_getxattr(inode, name, value, size);
>  		if (size > 0) {
>  			acl = posix_acl_from_xattr(value, size);
> -			if (IS_ERR(acl))
> +			if (IS_ERR(acl)) {
> +				kfree(value);
>  				return acl;
> +			}
>  			set_cached_acl(inode, type, acl);
>  		}
>  		kfree(value);
> 
> 


-aneesh
