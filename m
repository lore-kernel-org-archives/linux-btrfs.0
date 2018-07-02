Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60922 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752715AbeGBWM0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 2 Jul 2018 18:12:26 -0400
Date: Tue, 3 Jul 2018 00:12:17 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz,
        Paul Jones <paul@pauljones.id.au>, Hugo Mills <hugo@carfax.org.uk>
Subject: Re: [PATCH v2 1/2] btrfs-progs: Fix wrong optind re-initialization
 to allow mixed option and non-option
Message-ID: <20180702221217.GD3126@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180620003839.10629-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180620003839.10629-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 20, 2018 at 08:38:38AM +0800, Qu Wenruo wrote:
> In function handle_global_options(), we reset @optind to 1.
> However according to man page of getopt(3) NOTES section, if we need to
> rescan options later, @optind should be reset to 0 to initialize the
> internal variables correctly.
> 
> This explains the reason why in cmd_check(), getopt_long() doesn't
> handle the following command correctly:
> "btrfs check /dev/data/btrfs --check-data-csum"
> 
> While mkfs.btrfs handles mixed non-option and option correctly:
> "mkfs.btrfs -f /dev/data/disk1 --data raid1 /dev/data/disk2"
> 
> Cc: Paul Jones <paul@pauljones.id.au>
> Cc: Hugo Mills <hugo@carfax.org.uk>
> Fixes: 010ceab56e06 ("btrfs-progs: rework option parser to use getopt for global options")
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
> changelog:
> v2:
>   Instead of resetting @optind at handle_global_options(), reset @optind
>   before each later getopt() call. Since there are cases uses @optind and
>   expects it to be starting from 1.

So it's not possible to set it once before the callbacks are called in
btrfs.c:main() due to the exceptions that need it to be set to 1. Ok,
can you please send a separate patch that makes the optind = 1 explicit?
Even it might be redundant in the context, it's a way to document the
expected behaviour of getopt and also we would not have to think if the
optind setting is missing or not before the getopts. Thanks.
