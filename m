Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40482 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753961AbdJSOHQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Oct 2017 10:07:16 -0400
Date: Thu, 19 Oct 2017 16:05:28 +0200
From: David Sterba <dsterba@suse.cz>
To: Adam Borowski <kilobyte@angband.pl>
Cc: linux-btrfs@vger.kernel.org, Nick Terrell <terrelln@fb.com>,
        David Sterba <dsterba@suse.cz>
Subject: Re: [RFC 0/3]: settable compression level for zstd
Message-ID: <20171019140528.GK3521@twin.jikos.cz>
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

FYI, I'm going to add the patches 1 and 2 to 4.15 pull, ie. there will
be support for zlib levels.

Final syntax of the level specification is with ":". I've update the
patches, dropping the "zlib9" way, plus some more changelog updates.

> * btrfs: allow setting zstd level

Before the zstd levels are supported, we'll have to update the workspace
allocation.
