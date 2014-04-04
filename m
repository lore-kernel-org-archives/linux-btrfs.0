Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58705 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752630AbaDDMNS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 4 Apr 2014 08:13:18 -0400
Date: Fri, 4 Apr 2014 14:13:16 +0200
From: David Sterba <dsterba@suse.cz>
To: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: filter invalid arg for btrfs resize
Message-ID: <20140404121316.GR29256@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1396260206-14153-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1396260206-14153-1-git-send-email-guihc.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 31, 2014 at 06:03:25PM +0800, Gui Hecheng wrote:
> Originally following cmds will work:
> 	# btrfs fi resize -10A  <mnt>
> 	# btrfs fi resize -10Gaha <mnt>
> Filter the arg by checking the return pointer of memparse.

This should probably also go to stable@

> Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
> ---
>  fs/btrfs/ioctl.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index e174770..2ed21fa 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -1459,6 +1459,7 @@ static noinline int btrfs_ioctl_resize(struct file *file,
>  	struct btrfs_trans_handle *trans;
>  	struct btrfs_device *device = NULL;
>  	char *sizestr;
> +	char *retptr;

Minor nit, the variable is otherwise unused, it's better to put it into
the enclosing statement block with memparse.

>  	char *devstr = NULL;
>  	int ret = 0;
>  	int mod = 0;
> @@ -1526,8 +1527,8 @@ static noinline int btrfs_ioctl_resize(struct file *file,
>  			mod = 1;
>  			sizestr++;
>  		}
> -		new_size = memparse(sizestr, NULL);
> -		if (new_size == 0) {
> +		new_size = memparse(sizestr, &retptr);
> +		if (*retptr != '\0' || new_size == 0) {
>  			ret = -EINVAL;
>  			goto out_free;
>  		}
