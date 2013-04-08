Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36460 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935977Ab3DHPWk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 8 Apr 2013 11:22:40 -0400
Date: Mon, 8 Apr 2013 17:22:38 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: make btrfs dev scan multi path aware
Message-ID: <20130408152238.GE18193@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1363867004-22912-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1363867004-22912-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 21, 2013 at 07:56:44PM +0800, Anand Jain wrote:
>  We should avoid using non multi-path (mp) path for mp disks
>  As of now there is no good way (like api) to check that.
>  A workaround way is to check if the O_EXCL open is unsuccessful.
>  This is safe since otherwise the BTRFS_IOC_SCAN_DEV ioctl would
>  fail if the disk-path can not be opened with the flag O_EXCL set.

Agreed. Alternatively we could try to parse the /sys entries.

> --- a/cmds-device.c
> +++ b/cmds-device.c
> @@ -185,7 +185,7 @@ static const char * const cmd_scan_dev_usage[] = {
>  
>  static int cmd_scan_dev(int argc, char **argv)
>  {
> -	int	i, fd, e;
> +	int	i, fd, e, ret = 0;
>  	int	checklist = 1;
>  	int	devstart = 1;
>  
> @@ -197,6 +197,21 @@ static int cmd_scan_dev(int argc, char **argv)
>  		devstart += 1;
>  	}
>  
> +	fd = open("/dev/btrfs-control", O_RDWR);
> +	e = errno;
> +	if (fd < 0) {
> +		FILE *mfd = popen("lsmod | grep btrfs", "r");

Please transform this into C.

> +		char buf[16];
> +
> +		if (fread (buf, 1, sizeof (buf), mfd) > 0)
> +			fprintf(stderr, "ERROR: failed to open "\
> +				"/dev/btrfs-control - %s\n", strerror(e));
> +		else
> +			fprintf(stderr, "ERROR: btrfs kernel module "\
> +				"is not loaded\n");
> +		return 10;

We should not be using the old style of error codes in new code, other
paths in this functions return -1 .

> +	}


thanks,
david
