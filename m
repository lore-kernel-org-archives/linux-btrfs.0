Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:61505 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754071Ab2JMUVg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 13 Oct 2012 16:21:36 -0400
Received: by mail-ee0-f46.google.com with SMTP id b15so2417368eek.19
        for <linux-btrfs@vger.kernel.org>; Sat, 13 Oct 2012 13:21:35 -0700 (PDT)
Message-ID: <5079CD62.4070206@gmail.com>
Date: Sat, 13 Oct 2012 22:21:54 +0200
From: Goffredo Baroncelli <kreijack@gmail.com>
MIME-Version: 1.0
To: Anand jain <Anand.Jain@oracle.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 4/4] Btrfs-progs: add btrfs subvol show cli
References: <1350019254-22036-1-git-send-email-Anand.Jain@oracle.com> <1350019254-22036-5-git-send-email-Anand.Jain@oracle.com>
In-Reply-To: <1350019254-22036-5-git-send-email-Anand.Jain@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2012-10-12 07:20, Anand jain wrote:
> From: Anand Jain<anand.jain@oracle.com>
>
> This will add a sub command to show information about a subvol.
> eg:
> btrfs su show /btrfs/sssv3
> /btrfs/sssv3
> 	uuid: 		c5d646b5-a749-c646-b082-6d9a3ca870be
> 	Parent uuid: 	34bc8edd-113f-5141-a814-f6dfae069b01
> 	Creation time: 	2012-10-12 11:37:00
>

> +
> +/*	if in case we decide to have more available data
> +	to be shown we can use it as below.
> +
> +	printf("Object ID: %llu", get_ri.root_id);
> +	printf("\n");
> +	printf("Generation: %llu", get_ri.gen);
> +	printf("\n");
> +	printf("OGeneration: %llu", get_ri.ogen);
> +	printf("\n");
> +	printf("Parent: %llu", get_ri.ref_tree);
> +	printf("\n");
> +	printf("Top Level: %llu", get_ri.top_id);
> +	printf("\n");
> +*/

Please, add a switch to show this further data. Does the flags contains 
sensible data ?

> +
> +	/* clean up */
> +	if (get_ri.path)
> +		free(get_ri.path);
> +	if (get_ri.name)
> +		free(get_ri.name);
> +	if (get_ri.full_path)
> +		free(get_ri.full_path);
> +
> +	close(fd);
> +	free(mnt);
> +	return 0;
> +}
> +
>   const struct cmd_group subvolume_cmd_group = {
>   	subvolume_cmd_group_usage, NULL, {
>   		{ "create", cmd_subvol_create, cmd_subvol_create_usage, NULL, 0 },
> @@ -714,6 +826,7 @@ const struct cmd_group subvolume_cmd_group = {
>   		{ "set-default", cmd_subvol_set_default,
>   			cmd_subvol_set_default_usage, NULL, 0 },
>   		{ "find-new", cmd_find_new, cmd_find_new_usage, NULL, 0 },
> +		{ "show", cmd_subvol_show, cmd_subvol_show_usage, NULL, 0 },
>   		{ 0, 0, 0, 0, 0 }
>   	}
>   };
> diff --git a/man/btrfs.8.in b/man/btrfs.8.in
> index 9222580..57c25b0 100644
> --- a/man/btrfs.8.in
> +++ b/man/btrfs.8.in
> @@ -17,6 +17,8 @@ btrfs \- control a btrfs filesystem
>   .PP
>   \fBbtrfs\fP \fBsubvolume get-default\fP\fI<path>\fP
>   .PP
> +\fBbtrfs\fP \fBsubvolume show\fP\fI<path>\fP
> +.PP
>   \fBbtrfs\fP \fBfilesystem defragment\fP -c[zlib|lzo] [-l \fIlen\fR] \
>   [-s \fIstart\fR] [-t \fIsize\fR] -[vf]<\fIfile\fR>|<\fIdir\fR>  \
>   [<\fIfile\fR>|<\fIdir\fR>...]
> @@ -160,6 +162,10 @@ Get the default subvolume of the filesystem \fI<path>\fR. The output format
>   is similar to \fBsubvolume list\fR command.
>   .TP
>
> +\fBsubvolume show\fR\fI<path>\fR
> +Show information of a given subvolume in the \fI<path>\fR.
> +.TP

It is possible to allow "btrfs subvolume show" to process multiple paths ?

	btrfs sub show <subv1> [<subvol2> ... ]

> +
>   \fBfilesystem defragment\fP -c[zlib|lzo] [-l \fIlen\fR] [-s \fIstart\fR] \
>   [-t \fIsize\fR] -[vf]<\fIfile\fR>|<\fIdir\fR>  [<\fIfile\fR>|<\fIdir\fR>...]
>

