Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f173.google.com ([209.85.192.173]:34310 "EHLO
        mail-pf0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934927AbdGTWAA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 20 Jul 2017 18:00:00 -0400
Received: by mail-pf0-f173.google.com with SMTP id q85so16765401pfq.1
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Jul 2017 15:00:00 -0700 (PDT)
Date: Thu, 20 Jul 2017 14:59:58 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Martin Raiber <martin@urbackup.org>
Subject: Re: strange No space left on device issues
Message-ID: <20170720215958.GF29924@vader.DHCP.thefacebook.com>
References: <1500561549.7266.1.camel@scientia.net>
 <0102015d6083ffde-e6d15fd5-6e66-41a0-9ddf-af163c96ebd8-000000@eu-west-1.amazonses.com>
 <1500564013.7266.8.camel@scientia.net>
 <20170720173214.GA29924@vader.DHCP.thefacebook.com>
 <1500586436.7266.18.camel@scientia.net>
 <20170720214813.GE29924@vader.DHCP.thefacebook.com>
 <1500587596.7266.20.camel@scientia.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1500587596.7266.20.camel@scientia.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 20, 2017 at 11:53:16PM +0200, Christoph Anton Mitterer wrote:
> On Thu, 2017-07-20 at 14:48 -0700, Omar Sandoval wrote:
> > Just to be sure, did you explicitly write 0 to these?
> Nope... that seemed to have been the default value, i.e. I used
> sysctl(8) in read (and not set) mode here.

Okay, all good then.

> > These sysctls are
> > really confusing, see https://www.kernel.org/doc/Documentation/sysctl
> > /vm.txt.
> > Basically, there are two ways to specify these, either as a ratio of
> > system memory (vm.dirty_ratio and vm.dirty_background_ratio) or a
> > static
> > number of bytes (vm.dirty_bytes and vm.dirty_background_bytes). If
> > you
> > set one, the other appears as 0, and the kernel sets the ratios by
> > default. But if you explicitly set them to 0, the kernel is going to
> > flush stuff extremely aggressively.
> I see,... not sure why both are 0 here... at least I didn't change it
> myself - must be something from the distro?

That's normal, the default is to have the ratio set instead:

$ sysctl vm.dirty_{,background_}{bytes,ratio}
vm.dirty_bytes = 0
vm.dirty_ratio = 20
vm.dirty_background_bytes = 0
vm.dirty_background_ratio = 10

> > Awesome, glad to hear it! I hadn't been able to reproduce the issue
> > outside of Facebook. Can I add your tested-by?
> Sure, but better use my other mail address for it, if you don't mind:
> Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>

No problem. I'll resend the patch with that shortly.

> > > I assume you'll take care to get that patch into stable kernels?
> > > Is this patch alone enough to recommend the Debian maintainers to
> > > include it into their 4.9 long term stable kernels?
> > 
> > I'll mark it for stable, assuming Debian tracks the upstream LTS
> > releases it should get in.
> Okay :-)
> 
> Nevertheless I'll open a bug at their BTS, just to be safe.
> 
> 
> Thanks :)
> 
> Chris.


