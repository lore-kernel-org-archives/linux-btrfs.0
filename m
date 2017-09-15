Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:46310 "EHLO
        mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751143AbdIOROP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Sep 2017 13:14:15 -0400
Received: by mail-io0-f175.google.com with SMTP id d16so10018476ioj.3
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Sep 2017 10:14:15 -0700 (PDT)
Subject: Re: [RFC 0/3]: settable compression level for zstd
To: Adam Borowski <kilobyte@angband.pl>, linux-btrfs@vger.kernel.org,
        Nick Terrell <terrelln@fb.com>, David Sterba <dsterba@suse.cz>
References: <20170915153457.dt5zjcbrryn3qj3t@angband.pl>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <883c9cbe-4b72-f355-1a1c-df5dbbde7597@gmail.com>
Date: Fri, 15 Sep 2017 13:14:09 -0400
MIME-Version: 1.0
In-Reply-To: <20170915153457.dt5zjcbrryn3qj3t@angband.pl>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-09-15 11:34, Adam Borowski wrote:
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
I've got limited knowledge of the zstandard algorithm, but based on my 
(probably incomplete and possibly inaccurate) analysis of the code in 
the kernel, I think this assessment is correct.  At a minimum, higher 
levels are likely to provide no benefit considering how slow things get 
(even the speed of level 15 means it's probably not going to be used much).
> 
> There are three patches:
> * [David Sterba] btrfs: allow to set compression level for zlib
>    Unmodified version of the patch from Jul 24, I'm re-sending it for
>    convenience.
> * btrfs: allow setting zlib compression level via :9
>    Some bikeshedding: it looks like Chris Mason also favours zlib:9 over
>    zlib9 as the former is more readable.  If you disagree... well, it's up
>    to you to decide anyway.  This patch accepts both syntaxes.
On this in particular, I think there _might_ be a potential issue with 
option parsing, I'd advocate something less likely to be a metacharacter 
(like '-') instead of ':', but I do agree that it's a bit more concise 
when the algorithm and level are separate.
> * btrfs: allow setting zstd level

