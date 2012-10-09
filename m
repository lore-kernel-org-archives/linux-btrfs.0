Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:51987 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756163Ab2JIPoZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Oct 2012 11:44:25 -0400
Date: Tue, 9 Oct 2012 17:44:19 +0200
From: David Sterba <dave@jikos.cz>
To: Anand jain <Anand.Jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH V2] Btrfs-progs: add parent uuid for snapshots
Message-ID: <20121009154418.GV4405@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <50584E6D.8000602@cn.fujitsu.com>
 <1349403922-4583-1-git-send-email-Anand.Jain@oracle.com>
 <1349403922-4583-3-git-send-email-Anand.Jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1349403922-4583-3-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 05, 2012 at 10:25:22AM +0800, Anand jain wrote:
> @@ -128,6 +129,11 @@ struct {
>  		.need_print	= 0,
>  	},
>  	{
> +		.name		= "puuid",
> +		.column_name	= "PUUID",

the capitalized 'P' looks like it's part of the UUID abbreviation. The
UUIDs are long, I think you can print 'parent UUID' in the header, the
name for command line argument 'puuid' is understable.

> +		.need_print	= 0,
> +	},
> +	{
>  		.name		= "uuid",
>  		.column_name	= "UUID",
>  		.need_print	= 0,

> --- a/cmds-subvolume.c
> +++ b/cmds-subvolume.c
> @@ -267,6 +267,7 @@ static const char * const cmd_subvol_list_usage[] = {
>  	"-p           print parent ID",
>  	"-a           print all the subvolumes in the filesystem.",
>  	"-u           print the uuid of subvolumes (and snapshots)",
> +	"-P           print the parent uuid of snapshots",

This clashes with my efforts to make the options consistent so that we
can have a lowercase for column selection and uppercase for filter. In
case of the parent UUID,  it makes sense to filter by it, eg when we
have a hierarchy of subvolumes that keep the same structure but is
replicated several times.

I suggest to pick a different letter than 'P', say 'q'. (-q is usually
used for 'no verbose output' in utilities, but it does not make much
sense in context of 'subvol list' so I hope it's ok from the UI POV).

>  	"-t           print the result as a table",
>  	"-s           list snapshots only in the filesystem",
>  	"-r           list readonly subvolumes (including snapshots)",

Thanks,
david
