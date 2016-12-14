Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55539 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932498AbcLNLNy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Dec 2016 06:13:54 -0500
Date: Wed, 14 Dec 2016 11:54:09 +0100
From: David Sterba <dsterba@suse.cz>
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: Re: [PATCH v2] btrfs-progs: qgroup: add sync option to 'qgroup show'
Message-ID: <20161214105409.GA3620@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <201612070307.AA00021@WIN-5MHF4RKU941.jp.fujitsu.com>
 <201612070755.AA00022@WIN-5MHF4RKU941.jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201612070755.AA00022@WIN-5MHF4RKU941.jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 07, 2016 at 04:55:15PM +0900, Tsutomu Itoh wrote:
> The 'qgroup show' command does not synchronize filesystem.
> Therefore, 'qgroup show' may not display the correct value unless
> synchronized with 'filesystem sync' command etc.
> 
> So add the '--sync' and '--no-sync' options so that we can choose
> whether or not to synchronize when executing the command.
> 
> Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
> ---
> v2: use getopt_long with enum instead of single letter (suggested by Qu)
> ---
>  Documentation/btrfs-qgroup.asciidoc |  6 ++++++
>  cmds-qgroup.c                       | 33 +++++++++++++++++++++++++++++----
>  2 files changed, 35 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/btrfs-qgroup.asciidoc b/Documentation/btrfs-qgroup.asciidoc
> index 438dbc7..9c65795 100644
> --- a/Documentation/btrfs-qgroup.asciidoc
> +++ b/Documentation/btrfs-qgroup.asciidoc
> @@ -126,6 +126,12 @@ Prefix \'+' means ascending order and \'-' means descending order of <attr>.
>  If no prefix is given, use ascending order by default.
>  +
>  If multiple <attr>s is given, use comma to separate.
> ++
> +--sync::::
> +To retrieve information after updating the status of qgroups,
> +invoke sync before getting information.

This could be more specific, that it's a filesystem sync.

> +--no-sync::::
> +Do not invoke sync before getting information (default).

I'm not sure we need this option, how is it supposed to be used?

> @@ -311,8 +313,15 @@ static int cmd_qgroup_show(int argc, char **argv)
>  
>  	while (1) {
>  		int c;
> +		enum {
> +			GETOPT_VAL_SORT = 256,
> +			GETOPT_VAL_SYNC,
> +			GETOPT_VAL_NO_SYNC
> +		};
>  		static const struct option long_options[] = {
> -			{"sort", required_argument, NULL, 'S'},
> +			{"sort", required_argument, NULL, GETOPT_VAL_SORT},

This change is unrelated to the patch, please make a separate patch for
that.

Otherwise looks good.

> +			{"sync", no_argument, NULL, GETOPT_VAL_SYNC},
> +			{"no-sync", no_argument, NULL, GETOPT_VAL_NO_SYNC},
>  			{ NULL, 0, NULL, 0 }
>  		};
>  
