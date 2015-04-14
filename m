Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43748 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753843AbbDNNOq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Apr 2015 09:14:46 -0400
Date: Tue, 14 Apr 2015 15:14:44 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 1/1] btrfs-progs: improve troubleshooting avoid duplicate
 error strings
Message-ID: <20150414131444.GQ25622@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1428928621-8001-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1428928621-8001-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 13, 2015 at 08:37:01PM +0800, Anand Jain wrote:
> my troubleshooting experience says have unique error string per module.
> 
> In the below eg, its one additional step to know error line,
> 
> cat -n cmds-device.c | egrep "error removing the device"
>    185	"ERROR: error removing the device '%s' - %s\n",
>    190	"ERROR: error removing the device '%s' - %s\n",
> 
> which is completely avoidable.

It is, we can merge both branches into one.

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

The only difference is the strerror vs btrfs_err_str. As both ret > 0
and ret < 0 report some kind of error, the wording would be very similar
so I think that one error message would fit better. I'll fix that.
