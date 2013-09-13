Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36994 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751079Ab3IMRZX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Sep 2013 13:25:23 -0400
Date: Fri, 13 Sep 2013 19:25:20 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 2/2] btrfs-progs: use kernel for mounted and lblkid to
 scan disks
Message-ID: <20130913172520.GP6810@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1379071943-27543-1-git-send-email-anand.jain@oracle.com>
 <1379071943-27543-3-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1379071943-27543-3-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 13, 2013 at 07:32:23PM +0800, Anand Jain wrote:
> Further, this patch adds new parameters mounted and
> group profile info in the filesystem show output

Sorry to bother you, but the 'further' part of the patch should be
separated out. The core change of the patch is to use libblkid and the
ioctl.

> ---------------
> btrfs fi show
> Label: none  uuid: a2446ecf-68c5-4815-8b63-099d10fc373c mounted: /btrfs
> 	Group profile: metadata: single  metadata: DUP  data: single

I didn't notice that before, this does not bring much information
without the numbers as 'fi df' does. Please drop the printf lines

> @@ -246,34 +338,73 @@ static int cmd_show(int argc, char **argv)
>  	struct list_head *cur_uuid;
>  	char *search = NULL;
>  	int ret;
> -	int where = BTRFS_SCAN_PROC;
> +	int where = 0;
>  	int searchstart = 1;
>  
>  	if( argc > 1 && !strcmp(argv[1],"--all-devices")){
>  		where = BTRFS_SCAN_DEV;
>  		searchstart += 1;
> +	} else if (argc > 1 && !strcmp(argv[1], "--mounted")) {
> +		where = BTRFS_SCAN_MOUNTED;
> +		searchstart += 1;

getopt was not used here, but with the new options it probably should
be, because

> -	if (check_argc_max(argc, searchstart + 1))
> -		usage(cmd_show_usage);
> -
> -	ret = scan_for_btrfs(where, 0);
> -
> -	if (ret){
> -		fprintf(stderr, "ERROR: error %d while scanning\n", ret);
> -		return 1;
> +	if (where == BTRFS_SCAN_DEV) {
> +		if (check_argc_max(argc, searchstart + 1))
> +			usage(cmd_show_usage);
> +	} else if (where == BTRFS_SCAN_MOUNTED) {
> +		if (check_argc_max(argc, searchstart))
> +			usage(cmd_show_usage);
> +	} else {
> +		if (check_argc_max(argc, searchstart))
> +			usage(cmd_show_usage);

this stops to work:

$ btrfs fi show SOME-UUID
btrfs filesystem show: too many arguments


thanks,
david
