Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60839 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936231Ab3DRQmR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Apr 2013 12:42:17 -0400
Date: Thu, 18 Apr 2013 18:42:15 +0200
From: David Sterba <dsterba@suse.cz>
To: Stefan Behrens <sbehrens@giantdisaster.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 4/4] Btrfs-progs: enhance 'btrfs subvolume list'
Message-ID: <20130418164215.GK16427@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1365696891.git.sbehrens@giantdisaster.de>
 <8c3c7c8ec1747e9fe96ccf17ccc2b6669e1d1fb8.1365696891.git.sbehrens@giantdisaster.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <8c3c7c8ec1747e9fe96ccf17ccc2b6669e1d1fb8.1365696891.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 11, 2013 at 06:22:08PM +0200, Stefan Behrens wrote:
> +static char *all_field_items[] = {
> +	[BTRFS_LIST_OBJECTID]		= "rootid",
> +	[BTRFS_LIST_GENERATION]		= "gen",
> +	[BTRFS_LIST_CGENERATION]	= "cgen",
> +	[BTRFS_LIST_OGENERATION]	= "ogen",
> +	[BTRFS_LIST_SGENERATION]	= "sgen",
> +	[BTRFS_LIST_RGENERATION]	= "rgen",
> +	[BTRFS_LIST_PARENT]		= "parent",
> +	[BTRFS_LIST_TOP_LEVEL]		= "topid",
> +	[BTRFS_LIST_CTIME]		= "ctime",
> +	[BTRFS_LIST_OTIME]		= "otime",
> +	[BTRFS_LIST_STIME]		= "stime",
> +	[BTRFS_LIST_RTIME]		= "rtime",
> +	[BTRFS_LIST_UUID]		= "uuid",
> +	[BTRFS_LIST_PUUID]		= "puuid",
> +	[BTRFS_LIST_RUUID]		= "ruuid",
> +	[BTRFS_LIST_DIRID]		= "dirid",
> +	[BTRFS_LIST_PATH]		= "path",
> +	[BTRFS_LIST_ALL]		= "all",

I'm not sure if 'all' belongs here, it's technically not a field but on
the other hand it's an easy shortcut.

If we agree on adding the predefined sets of fields, then 'all' should
go there.

> +	[BTRFS_LIST_MAX]		= NULL,
> +};
> +

> @@ -326,32 +326,30 @@ static int cmd_subvol_list(int argc, char **argv)
>  	int is_only_in_path = 0;
>  	struct option long_options[] = {
>  		{"sort", 1, NULL, 'S'},
> +		{"fields", 1, NULL, 'F'},
>  
>  		c = getopt_long(argc, argv,
> -				    "acgopqsurG:C:t", long_options, NULL);
> +				    "roastG:C:", long_options, NULL);

The single letters from long option need to be repeated here, the 'S' is
missing as well and leds to

$ btrfs sub list -S
btrfs subvolume list: invalid option -- 'S'

and also documented in the usage string.


> --- a/man/btrfs.8.in
> +++ b/man/btrfs.8.in
> @@ -11,7 +11,7 @@ btrfs \- control a btrfs filesystem
>  .PP
>  \fBbtrfs\fP \fBsubvolume create\fP\fI [<dest>/]<name>\fP
>  .PP
> -\fBbtrfs\fP \fBsubvolume list\fP\fI [-acgoprts] [-G [+|-]value] [-C [+|-]value] [--sort=rootid,gen,ogen,path] <path>\fP
> +\fBbtrfs\fP \fBsubvolume list\fP\fI [-roast] [-G [+|-]value] [-C [+|-]value] [--sort=rootid,gen,ogen,path] [--fields=gen,dirid,uuid,puuid,ruuid,cgen,ogen,sgen,rgen,ctime,otime,stime,rtime,path,rootid,parent,topid,all] <path>\fP

and man page texts, besides all the short names like ogen/stime/puuid
deserve some human readable description..


david
