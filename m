Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:50620 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750980AbcIQN1e (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 17 Sep 2016 09:27:34 -0400
Date: Sat, 17 Sep 2016 15:27:23 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: Stefan Malte Schumacher <stefan.m.schumacher@gmail.com>
Cc: Nicholas Steeves <nsteeves@gmail.com>,
        Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Size of scrubbed Data
Message-ID: <20160917132723.GA27654@angband.pl>
References: <CAA3ktqmQ+kGddhuw6gC9Hoct+eayxjZFrDjigffCgmDa09=PBA@mail.gmail.com>
 <CAJCQCtR6bcBjK+Npd1+8KOYFOp5GWUBQ8hxvjwNU7vEaLHH9Hg@mail.gmail.com>
 <20160916122148.GA17713@DigitalMercury.dynalias.net>
 <CAA3ktqm0eSm3bM5cKsa1D-rnELTQ83rPkH-QFfEmfuBV1ZMe9A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAA3ktqm0eSm3bM5cKsa1D-rnELTQ83rPkH-QFfEmfuBV1ZMe9A@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Sep 17, 2016 at 01:02:18PM +0200, Stefan Malte Schumacher wrote:
> Concerning Testing: I only use it on desktops and home servers, which
> do not offer any services to the net. I am very fond of Debian and
> always use stable or even old-stable on work servers, but was finally
> to annoyed at the fact that the software I was using on a fresh
> installation was practically already out of date.

These days *-backports has pretty much everything you'd want for a real
reason, and maintainers tend to be forthcoming when asked; the rules allow
anyone with upload rights to backport anything (the string attached is
"you're then responsible for bugs and other problems") but it's customary to
ask the regular maintainer first.

Of course you won't get bling this way -- it's unreasonable to backport more
than a few dependant packages so a desktop environment is right out.  But
server packages, a major new version of an editor or mail client, or
sometimes even a new game are fine.

Obviously, stuff like new kernels or new btrfs-progs tend to come fast.

On the other hand, this means using testing outside of (soft-) freezes
became far less supported than it used to be in the past.

-- 
Second "wet cat laying down on a powered-on box-less SoC on the desk" close
shave in a week.  Protect your ARMs, folks!
