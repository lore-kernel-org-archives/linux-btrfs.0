Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36454 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754059Ab3IMRBa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Sep 2013 13:01:30 -0400
Date: Fri, 13 Sep 2013 19:01:28 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz, wangsl.fnst@cn.fujitsu.com
Subject: Re: [PATCH 1/2] btrfs-progs: move out print in cmd_df to another
 function
Message-ID: <20130913170128.GO6810@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1379071943-27543-1-git-send-email-anand.jain@oracle.com>
 <1379071943-27543-2-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1379071943-27543-2-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 13, 2013 at 07:32:22PM +0800, Anand Jain wrote:
> +static int get_df(int fd, struct btrfs_ioctl_space_args **sargs_ret)
> +{

This function returns full error codes, that's ok,

> @@ -77,89 +98,79 @@ static int cmd_df(int argc, char **argv)
>  	ret = ioctl(fd, BTRFS_IOC_SPACE_INFO, sargs);
>  	e = errno;
>  	if (ret) {
> -		fprintf(stderr, "ERROR: couldn't get space info on '%s' - %s\n",
> -			path, strerror(e));
> -		goto out;
> +		fprintf(stderr, "ERROR: couldn't get space info - %s\n",
> +			strerror(e));
> +		free(sargs);
> +		return ret;

cmd_df should return the 0-1 normalized value after the cleanup that
Wang Shilong has done. You can leave the common exit block (ie. goto +
free/return as before) and use return !!ret.
