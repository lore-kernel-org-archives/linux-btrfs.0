Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55037 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752649AbbHaOGW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 31 Aug 2015 10:06:22 -0400
Date: Mon, 31 Aug 2015 16:05:42 +0200
From: David Sterba <dsterba@suse.cz>
To: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 2/4] btrfs-progs: Use common unit parser for btrfs
 filesystem command
Message-ID: <20150831140542.GR11834@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1441018814.git.zhaolei@cn.fujitsu.com>
 <cb70e9a2339a49c451258cf0ceb2aff819eaa945.1441018814.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <cb70e9a2339a49c451258cf0ceb2aff819eaa945.1441018814.git.zhaolei@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 31, 2015 at 07:03:42PM +0800, Zhao Lei wrote:
> @@ -859,88 +859,23 @@ out:
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
> -	"-T                 show data in tabular format",

You're removing too much, -T must stay. Due to that, the whole getopt
loop must stay as well. Please update this patch, the rest from the
series is applied.

> +	HELPINFO_OUTPUT_UNIT,
