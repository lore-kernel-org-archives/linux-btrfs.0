From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH, fixed] Prevent oopsing in posix_acl_valid()
Date: Wed, 04 May 2011 10:40:50 -0400
Message-ID: <4DC16572.8020005@redhat.com>
References: <1304477648-14952-1-git-send-email-daniel.blueman@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Chris Mason <chris.mason@oracle.com>,
	Christian Brunner <chb@muc.de>, linux-btrfs@vger.kernel.org
To: Daniel J Blueman <daniel.blueman@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1304477648-14952-1-git-send-email-daniel.blueman@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 05/03/2011 10:54 PM, Daniel J Blueman wrote:
> If posix_acl_from_xattr() returns an error code, a negative address is
> dereferenced causing an oops; fix by checking for an error code first.
>
> Typo fixed; too much late-night coding.
>
> Signed-off-by: Daniel J Blueman<daniel.blueman@gmail.com>
> ---
>   fs/btrfs/acl.c |    5 +++--
>   1 files changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
> index 5d505aa..44ea5b9 100644
> --- a/fs/btrfs/acl.c
> +++ b/fs/btrfs/acl.c
> @@ -178,12 +178,13 @@ static int btrfs_xattr_acl_set(struct dentry *dentry, const char *name,
>
>   	if (value) {
>   		acl = posix_acl_from_xattr(value, size);
> +		if (IS_ERR(acl))
> +			return PTR_ERR(acl);
> +
>   		if (acl) {
>   			ret = posix_acl_valid(acl);
>   			if (ret)
>   				goto out;
> -		} else if (IS_ERR(acl)) {
> -			return PTR_ERR(acl);
>   		}
>   	}
>

Actually pulled this down and compiled it this time to make sure it 
worked.  You can add

Reviewed-by: Josef Bacik <josef@redhat.com>

Thanks,

Josef
