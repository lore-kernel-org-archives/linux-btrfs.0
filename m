Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59993 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752249Ab3H3Xdm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 30 Aug 2013 19:33:42 -0400
Date: Sat, 31 Aug 2013 01:33:40 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: device add should check existing FS before
 adding
Message-ID: <20130830233340.GW23113@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1377860941-5741-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1377860941-5741-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 30, 2013 at 07:09:01PM +0800, Anand Jain wrote:
> as of now, when 'btrfs device add' adds a device it doesn't
> check if the given device contains an existing FS. This
> patch will change that to check the same. which when true
> add will fail, and ask user to use -f option to overwrite.
> 
> further, since now we have test_dev_for_mkfs() function
> to check if a disk can be used, so this patch will also
> use this function to test the given device before adding.

Patch is ok, but the argument handling does not use the common pattern:

> --- a/cmds-device.c
> +++ b/cmds-device.c
> @@ -53,12 +53,25 @@ static const char * const cmd_add_dev_usage[] = {
>  static int cmd_add_dev(int argc, char **argv)
>  {
>  	char	*mntpnt;
> -	int	i, fdmnt, ret=0, e;
> +	int	i = 1, fdmnt, ret = 0, e;
>  	DIR	*dirstream = NULL;
> +	int	c, force = 0;
> +	char	estr[100];
>  
>  	if (check_argc_min(argc, 3))
>  		usage(cmd_add_dev_usage);

check_argc_min belongs after argument processing

> +	while ((c = getopt(argc, argv, "f")) != -1) {
> +		switch (c) {
> +		case 'f':
> +			force = 1;
> +			i++;
> +			break;
> +		default:
> +			usage(cmd_add_dev_usage);
> +		}
> +	}

	argc -= optind;

	if (check_argc_min(...))
		usage();

> +
>  	mntpnt = argv[argc - 1];

And here it gets more complicated as you'd have to add optind everywhere
argc is used.

I was working on a patch to add the --nodiscard parameter to 'device
add' so the work is done, but not yet posted:

http://repo.or.cz/w/btrfs-progs-unstable/devel.git/shortlog/refs/heads/dev/dev-add-notrim

Please base your patch on top of that or after when they hit the
mailinglist/integration.

david
