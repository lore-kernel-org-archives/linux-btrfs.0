Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:55088 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932260AbbDMNlS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Apr 2015 09:41:18 -0400
Date: Mon, 13 Apr 2015 06:40:56 -0700
From: Marc MERLIN <marc@merlins.org>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 1/1] btrfs-progs: improve troubleshooting avoid duplicate error strings
Message-ID: <20150413134056.GA20751@merlins.org>
References: <1428928621-8001-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1428928621-8001-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 13, 2015 at 08:37:01PM +0800, Anand Jain wrote:
> my troubleshooting experience says have unique error string per module.

+1 to that, thank you.

Marc

> In the below eg, its one additional step to know error line,
> 
> cat -n cmds-device.c | egrep "error removing the device"
>    185	"ERROR: error removing the device '%s' - %s\n",
>    190	"ERROR: error removing the device '%s' - %s\n",
> 
> which is completely avoidable.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  cmds-device.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/cmds-device.c b/cmds-device.c
> index 1c72e90..1c32771 100644
> --- a/cmds-device.c
> +++ b/cmds-device.c
> @@ -187,7 +187,7 @@ static int cmd_rm_dev(int argc, char **argv)
>  			ret++;
>  		} else if (res < 0) {
>  			fprintf(stderr,
> -				"ERROR: error removing the device '%s' - %s\n",
> +				"ERROR: ioctl error removing the device '%s' - %s\n",
>  				argv[i], strerror(e));
>  			ret++;
>  		}
> -- 
> 2.0.0.153.g79dcccc
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
