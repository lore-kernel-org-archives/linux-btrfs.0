Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37159 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752558AbdIYQXq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Sep 2017 12:23:46 -0400
Date: Mon, 25 Sep 2017 18:22:12 +0200
From: David Sterba <dsterba@suse.cz>
To: Adam Borowski <kilobyte@angband.pl>
Cc: linux-btrfs@vger.kernel.org, Nick Terrell <terrelln@fb.com>,
        David Sterba <dsterba@suse.cz>
Subject: Re: [RFC 0/3]: settable compression level for zstd
Message-ID: <20170925162212.GM31640@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170915153457.dt5zjcbrryn3qj3t@angband.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170915153457.dt5zjcbrryn3qj3t@angband.pl>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 15, 2017 at 05:34:57PM +0200, Adam Borowski wrote:
> Hi!
> Here's a patch set that allows changing the compression level for zstd,
> currently at mount time only.  I've played with it for a month, so despite
> being a quick hack, it's reasonably well tested.  Tested on 4.13 +
> btrfs-for-4.14 only, though -- I've booted 11th-day-of-merge-window only an
> hour ago on one machine, no explosions yet.
> 
> As a quick hack, it doesn't conserve memory as it should: all workspace
> allocations assume level 15 and waste space otherwise.
> 
> Because of an (easily changeable) quirk of compression level encoding, the
> max is set at 15, but I guess higher levels are pointless for 128KB blocks. 
> Nick and co can tell us more -- for me zstd is mostly a black box so it's
> you who knows anything about tuning it.
> 
> There are three patches:
> * [David Sterba] btrfs: allow to set compression level for zlib
>   Unmodified version of the patch from Jul 24, I'm re-sending it for
>   convenience.
> * btrfs: allow setting zlib compression level via :9
>   Some bikeshedding: it looks like Chris Mason also favours zlib:9 over
>   zlib9 as the former is more readable.  If you disagree... well, it's up
>   to you to decide anyway.  This patch accepts both syntaxes.
> * btrfs: allow setting zstd level

I'll add the patches to for-next as it does not affect default behaviour
and the changes are contained in compression. Further updates are fine,
though I think we'll have to resolve the workspace waste before the
patches can be merged to master.

I tend agree to add the separator and slightly prefer ':' over '-'. In
order to utilize the zstd at higher levels, we can enhance the
compressed chunk size and then we could use another ':' to separate that
from the rest.
