Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f41.google.com ([74.125.83.41]:35511 "EHLO
        mail-pg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751899AbdGFVNW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Jul 2017 17:13:22 -0400
Received: by mail-pg0-f41.google.com with SMTP id j186so6708884pge.2
        for <linux-btrfs@vger.kernel.org>; Thu, 06 Jul 2017 14:13:22 -0700 (PDT)
Date: Thu, 6 Jul 2017 14:13:20 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Marc MERLIN <marc@merlins.org>
Cc: linux-btrfs@vger.kernel.org, pwnall@chromium.org
Subject: Re: Leveldb in google-chrome incompatible with btrfs?
Message-ID: <20170706211320.GA12206@vader.DHCP.thefacebook.com>
References: <20170706150046.GB12959@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170706150046.GB12959@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 06, 2017 at 08:00:46AM -0700, Marc MERLIN wrote:
> I don't know who else uses google-chrome here, but for me, for as long as
> I've used btrfs (3+ years now), I've had no end of troubles recovering from
> a linux crash, and google-chrome has had problems recovering my tabs and
> usually cmoplains about plenty of problems, some are corruption looking.

I've also had issues with chrome and Btrfs, not just you.

[snip]

> Does anyone know if it's leveldb relying on non POSIX semantics that just
> happen to work out on ext4, or if btrfs COW and atomicity doesn't quite
> handle multi file updates in a way that is expected by a spec, or by
> application developers?

A quick google search turned this up: https://github.com/google/leveldb/issues/195.
Unless anything has changed since that issue was last updated, it does
sound like LevelDB is making some unsafe assumptions. I'll take a look.
