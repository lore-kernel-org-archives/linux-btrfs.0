Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35556 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752350AbbH1RZD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 28 Aug 2015 13:25:03 -0400
Date: Fri, 28 Aug 2015 19:24:24 +0200
From: David Sterba <dsterba@suse.cz>
To: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/4] btrfs-progs: Use common function to parse unit
 arguments
Message-ID: <20150828172424.GG11834@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1440682373.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <cover.1440682373.git.zhaolei@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 27, 2015 at 09:38:19PM +0800, Zhao Lei wrote:
> We are using separate code for parse unit mode in current code,
> result is each command have different argument for unit mode:
> 
>  # btrfs filesystem show --help
>    ...
>    --raw              raw numbers in bytes
>    --human-readable   human friendly numbers, base 1024 (default)
>    --iec              use 1024 as a base (KiB, MiB, GiB, TiB)
>    --si               use 1000 as a base (kB, MB, GB, TB)
>    --kbytes           show sizes in KiB, or kB with --si
>    --mbytes           show sizes in MiB, or MB with --si
>    --gbytes           show sizes in GiB, or GB with --si
>    --tbytes           show sizes in TiB, or TB with --si
>    ...
>  #
>  # btrfs filesystem df --help
>    ...
>    -b|--raw           raw numbers in bytes
>    -h|--human-readable
>                       human friendly numbers, base 1024 (default)
>    -H                 human friendly numbers, base 1000
>    --iec              use 1024 as a base (KiB, MiB, GiB, TiB)
>    --si               use 1000 as a base (kB, MB, GB, TB)
>    -k|--kbytes        show sizes in KiB, or kB with --si
>    -m|--mbytes        show sizes in MiB, or MB with --si
>    -g|--gbytes        show sizes in GiB, or GB with --si
>    -t|--tbytes        show sizes in TiB, or TB with --si
>    ...
>  #
> 
> This patchset introduce common function to parse arguments for setting
> unit: get_unit_mode_from_arg()
> and common help message for unit argument,
> to make every tool in btrfs have same interface for setting unit.
> 
> The merit are:
> 1: Unify current each tool's arguments for unit
> 2: Make tools in future easy to implement such argument
> 3: Changes(enhancement) in common function have effect on all
>    relative tools

I like this kind of unification and code simplification. However, the
'filesystem df' command keeps some option compatibility with the
standalone 'df' commmand while the other btrfs commands use only long
versions of the options. So we have to treat 'fi df' differently and not
remove the existing short options. But otherwise looks good, thanks.
