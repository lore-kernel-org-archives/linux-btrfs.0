Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59328 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755148AbaHYWcR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Aug 2014 18:32:17 -0400
Date: Tue, 26 Aug 2014 00:32:16 +0200
From: David Sterba <dsterba@suse.cz>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: typo in btrfs-progs master/v3.16.x
Message-ID: <20140825223216.GL29981@suse.cz>
Reply-To: dsterba@suse.cz
References: <AD5C5B4A-E27D-4206-8552-5483EDB1BE98@colorremedies.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <AD5C5B4A-E27D-4206-8552-5483EDB1BE98@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 25, 2014 at 04:09:16PM -0600, Chris Murphy wrote:
>  static const char * const cmd_scrub_start_usage[] = {
>         "btrfs scrub start [-BdqrRf] [-c ioprio_class -n ioprio_classdata] <path>|<device>",
> -       "Start a new scrub. If a scrub is already running, the new one fails.",
> +       "Start a new scrub",
>         "",
>         "-B     do not background",
>         "-d     stats per device (-B only)",
>         "-q     be quiet",
>         "-r     read only mode",
> -       "-R     raw print mode, print full data instead of summary",
> +       "-R     raw print mode, print full data instead of summary"
> 
> 
> Looks like a missing , at the end of this line. All other lines end in ,

Thanks for checking, the v3.16.x version is correct.
