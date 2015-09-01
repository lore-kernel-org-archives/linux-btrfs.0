Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46649 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754334AbbIAJyb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 1 Sep 2015 05:54:31 -0400
Date: Tue, 1 Sep 2015 11:53:51 +0200
From: David Sterba <dsterba@suse.cz>
To: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 1/2] btrfs-progs: Use common unit parser for btrfs
 filesystem command
Message-ID: <20150901095350.GF11834@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1441091348.git.zhaolei@cn.fujitsu.com>
 <c7eb95221e37629936b19fe409cc0aeb2406cb7b.1441091348.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <c7eb95221e37629936b19fe409cc0aeb2406cb7b.1441091348.git.zhaolei@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 01, 2015 at 03:12:06PM +0800, Zhao Lei wrote:
> Move to use get_unit_mode_from_arg() for cmds-filesystem.c,
> to make "btrfs filesystem df/show/usage"'s unit argument same.
> 
> Also have cleanup effect: 19 insertions(+), 181 deletions(-)
> 
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>

Applied, thanks.

> ---
>  cmds-fi-usage.c   |  63 ++++------------------------
>  cmds-filesystem.c | 121 ++++++------------------------------------------------
>  2 files changed, 20 insertions(+), 164 deletions(-)
> 
> diff --git a/cmds-fi-usage.c b/cmds-fi-usage.c
> index adf1c27..ea967d1 100644
> --- a/cmds-fi-usage.c
> +++ b/cmds-fi-usage.c
> @@ -859,76 +859,29 @@ out:
>  const char * const cmd_filesystem_usage_usage[] = {
>  	"btrfs filesystem usage [options] <path> [<path>..]",
>  	"Show detailed information about internal filesystem usage .",
> -	"-b|--raw           raw numbers in bytes",
> -	"-h|--human-readable",
> -	"                   human friendly numbers, base 1024 (default)",
> -	"-H                 human friendly numbers, base 1000",
> -	"--iec              use 1024 as a base (KiB, MiB, GiB, TiB)",
> -	"--si               use 1000 as a base (kB, MB, GB, TB)",
> -	"-k|--kbytes        show sizes in KiB, or kB with --si",
> -	"-m|--mbytes        show sizes in MiB, or MB with --si",
> -	"-g|--gbytes        show sizes in GiB, or GB with --si",
> -	"-t|--tbytes        show sizes in TiB, or TB with --si",
> +	HELPINFO_OUTPUT_UNIT,

	HELPINFO_OUTPUT_UNIT_DF
