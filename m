Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f49.google.com ([74.125.83.49]:32893 "EHLO
        mail-pg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932346AbdGTVsO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 20 Jul 2017 17:48:14 -0400
Received: by mail-pg0-f49.google.com with SMTP id k14so20149576pgr.0
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Jul 2017 14:48:14 -0700 (PDT)
Date: Thu, 20 Jul 2017 14:48:13 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Martin Raiber <martin@urbackup.org>
Subject: Re: strange No space left on device issues
Message-ID: <20170720214813.GE29924@vader.DHCP.thefacebook.com>
References: <1500561549.7266.1.camel@scientia.net>
 <0102015d6083ffde-e6d15fd5-6e66-41a0-9ddf-af163c96ebd8-000000@eu-west-1.amazonses.com>
 <1500564013.7266.8.camel@scientia.net>
 <20170720173214.GA29924@vader.DHCP.thefacebook.com>
 <1500586436.7266.18.camel@scientia.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1500586436.7266.18.camel@scientia.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 20, 2017 at 11:33:56PM +0200, Christoph Anton Mitterer wrote:
> On Thu, 2017-07-20 at 10:32 -0700, Omar Sandoval wrote:
> > If that doesn't work, could you please also try
> > https://patchwork.kernel.org/patch/9829593/?
> 
> Okay, tried the patch now, applied upon:
> Linux 4.12.0-trunk-amd64 #1 SMP Debian 4.12.2-1~exp1 (2017-07-18) x86_64 GNU/Linux
> (that is the Debian source package, with all their further patches and
> their kernel config).
> 
> with the parameters at their defaults:
> # sysctl vm.dirty_bytes
> vm.dirty_bytes = 0
> # sysctl vm.dirty_background_bytes
> vm.dirty_background_bytes = 0

Just to be sure, did you explicitly write 0 to these? These sysctls are
really confusing, see https://www.kernel.org/doc/Documentation/sysctl/vm.txt.
Basically, there are two ways to specify these, either as a ratio of
system memory (vm.dirty_ratio and vm.dirty_background_ratio) or a static
number of bytes (vm.dirty_bytes and vm.dirty_background_bytes). If you
set one, the other appears as 0, and the kernel sets the ratios by
default. But if you explicitly set them to 0, the kernel is going to
flush stuff extremely aggressively.

> Tried copying the whole image three times (before I haven had a single
> copy of the whole image with at least one error, so that should be
> "proof" enough that it fixes the isse) upon the btrfs fs,... no errors
> this time...
> 
> Looks good :-)

Awesome, glad to hear it! I hadn't been able to reproduce the issue
outside of Facebook. Can I add your tested-by?

> I assume you'll take care to get that patch into stable kernels?
> Is this patch alone enough to recommend the Debian maintainers to
> include it into their 4.9 long term stable kernels?

I'll mark it for stable, assuming Debian tracks the upstream LTS
releases it should get in.

> And would you recommend this as an "urgent" fix?

This bug has been around since 4.8, so it's not _that_ urgent, but it
sucks.

Thanks!

> Cheers,
> Chris.


