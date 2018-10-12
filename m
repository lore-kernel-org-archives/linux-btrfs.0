Return-Path: <SRS0=eG6O=MY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2EC1C6783C
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 09:03:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6DE2E2075B
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 09:03:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6DE2E2075B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728149AbeJLQeq (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Oct 2018 12:34:46 -0400
Received: from mx2.suse.de ([195.135.220.15]:56974 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727819AbeJLQep (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Oct 2018 12:34:45 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 8DE26AF8A;
        Fri, 12 Oct 2018 09:03:16 +0000 (UTC)
Subject: Re: [PATCH] btrfs-progs: add cli to forget one or all scanned devices
To:     Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <1539317191-9265-1-git-send-email-anand.jain@oracle.com>
 <1539317191-9265-3-git-send-email-anand.jain@oracle.com>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <6e1d87e3-5e2d-bff2-0421-3b3e67588d5b@suse.com>
Date:   Fri, 12 Oct 2018 12:03:13 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <1539317191-9265-3-git-send-email-anand.jain@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 12.10.2018 07:06, Anand Jain wrote:
> This patch adds cli
>   btrfs device forget [dev]
> to remove the given device structure in the kernel if the device
> is unmounted. If no argument is given it shall remove all stale
> (device which are not mounted) from the kernel.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  cmds-device.c | 63 ++++++++++++++++++++++++++++++++++++++++++++++++++---------
>  ioctl.h       |  2 ++
>  2 files changed, 56 insertions(+), 9 deletions(-)
> 
> diff --git a/cmds-device.c b/cmds-device.c
> index 2a05f70a76a9..ecc391ea01d8 100644
> --- a/cmds-device.c
> +++ b/cmds-device.c
> @@ -254,10 +254,32 @@ static int cmd_device_delete(int argc, char **argv)
>  	return _cmd_device_remove(argc, argv, cmd_device_delete_usage);
>  }
>  
> +static int btrfs_forget_devices(char *path)
> +{
> +	struct btrfs_ioctl_vol_args args;
> +	int ret;
> +	int fd;
> +
> +	fd = open("/dev/btrfs-control", O_RDWR);
> +	if (fd < 0)
> +		return -errno;
> +
> +	memset(&args, 0, sizeof(args));
> +	if (path)
> +		strncpy_null(args.name, path);
> +	ret = ioctl(fd, BTRFS_IOC_FORGET_DEV, &args);
> +	if (ret)
> +		ret = -errno;
> +	close(fd);
> +	return ret;
> +}
> +
>  static const char * const cmd_device_scan_usage[] = {
> -	"btrfs device scan [(-d|--all-devices)|<device> [<device>...]]",
> -	"Scan devices for a btrfs filesystem",
> +	"btrfs device scan [(-d|--all-devices)|-u|--forget|<device> "\
> +							"[<device>...]]",
> +	"Scan or forget (deregister) devices for a btrfs filesystem",
>  	" -d|--all-devices (deprecated)",
> +	" -u|--forget [<device> ..]",
>  	NULL
>  };
>  
> @@ -267,32 +289,40 @@ static int cmd_device_scan(int argc, char **argv)
>  	int devstart;
>  	int all = 0;
>  	int ret = 0;
> +	int forget = 0;
>  
>  	optind = 0;
>  	while (1) {
>  		int c;
>  		static const struct option long_options[] = {
>  			{ "all-devices", no_argument, NULL, 'd'},
> +			{ "forget", no_argument, NULL, 'u'},
>  			{ NULL, 0, NULL, 0}
>  		};
>  
> -		c = getopt_long(argc, argv, "d", long_options, NULL);
> +		c = getopt_long(argc, argv, "du", long_options, NULL);
>  		if (c < 0)
>  			break;
>  		switch (c) {
>  		case 'd':
>  			all = 1;
>  			break;
> +		case 'u':
> +			forget = 1;
> +			break;
>  		default:
>  			usage(cmd_device_scan_usage);
>  		}
>  	}
>  	devstart = optind;
>  
> +	if (all && forget)
> +		usage(cmd_device_scan_usage);
> +
>  	if (all && check_argc_max(argc - optind, 1))
>  		usage(cmd_device_scan_usage);
>  
> -	if (all || argc - optind == 0) {
> +	if (!forget && (all || argc - optind == 0)) {
>  		printf("Scanning for Btrfs filesystems\n");
>  		ret = btrfs_scan_devices();
>  		error_on(ret, "error %d while scanning", ret);
> @@ -301,6 +331,13 @@ static int cmd_device_scan(int argc, char **argv)
>  		goto out;
>  	}
>  
> +	if (forget && (all || argc - optind == 0)) {

You cannot ever have (forget && all) since you specifically call usage()
above, just remove the 'all'. Furthermore, I think the code will be more
legible if it's part of an else if rather than a plain if construct. In
fact the whole function will be more readable. I.e you will have the
error conditions at the to, followed by "all device scan" case, followed
by "all device forget" and in the final else branch you will have the
specific device handling. The increased indentation level won't be a
problem since the longest lines are string prints and we are not
wrapping those.


> +		ret = btrfs_forget_devices(NULL);
> +		if (ret)
> +			error("Can't forget: %s", strerror(-ret));
> +		goto out;
> +	}
> +
>  	for( i = devstart ; i < argc ; i++ ){
>  		char *path;
>  
> @@ -315,11 +352,19 @@ static int cmd_device_scan(int argc, char **argv)
>  			ret = 1;
>  			goto out;
>  		}
> -		printf("Scanning for Btrfs filesystems in '%s'\n", path);
> -		if (btrfs_register_one_device(path) != 0) {
> -			ret = 1;
> -			free(path);
> -			goto out;
> +		if (forget) {
> +			ret = btrfs_forget_devices(path);
> +			if (ret)
> +				error("Can't forget '%s': %s",
> +							path, strerror(-ret));

For consistency sake I think this error printout should be moved inside
btrfs_forget_devices() similarly to what btrfs_register_one_device does
on error.

> +		} else {
> +			printf("Scanning for Btrfs filesystems in '%s'\n",
> +									path);
> +			if (btrfs_register_one_device(path) != 0) {
> +				ret = 1;
> +				free(path);
> +				goto out;
> +			}
>  		}
>  		free(path);
>  	}
> diff --git a/ioctl.h b/ioctl.h
> index 709e996f401c..e27d80e09392 100644
> --- a/ioctl.h
> +++ b/ioctl.h
> @@ -721,6 +721,8 @@ static inline char *btrfs_err_str(enum btrfs_err_code err_code)
>  				   struct btrfs_ioctl_vol_args)
>  #define BTRFS_IOC_SCAN_DEV _IOW(BTRFS_IOCTL_MAGIC, 4, \
>  				   struct btrfs_ioctl_vol_args)
> +#define BTRFS_IOC_FORGET_DEV _IOW(BTRFS_IOCTL_MAGIC, 5, \
> +				   struct btrfs_ioctl_vol_args)
>  /* trans start and trans end are dangerous, and only for
>   * use by applications that know how to avoid the
>   * resulting deadlocks
> 
