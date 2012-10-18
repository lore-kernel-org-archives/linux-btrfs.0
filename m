Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ia0-f174.google.com ([209.85.210.174]:53892 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755713Ab2JRN6f (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Oct 2012 09:58:35 -0400
Received: by mail-ia0-f174.google.com with SMTP id y32so6334310iag.19
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Oct 2012 06:58:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20121018132850.GA22010@shiny>
References: <CAK0PdAk3+wPR_MerCNFgCvCC01c1RJ31=Z=G9=hT5eyYfn=iNg@mail.gmail.com>
 <20121018132850.GA22010@shiny>
From: Marguerite Su <i@marguerite.su>
Date: Thu, 18 Oct 2012 21:58:14 +0800
Message-ID: <CAK0PdAmSAq6XipGWPvgLD4QzRG6URYL7UoghKjrdcrrow7v2xQ@mail.gmail.com>
Subject: Re: initramfs take a long time to load[135s]
To: Chris Mason <chris.mason@fusionio.com>, Marguerite Su <i@marguerite.su>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 18, 2012 at 9:28 PM, Chris Mason <chris.mason@fusionio.com> wrote:
>
> Usually when btrfs is slow to mount, or slow right after a mount it is
> because we're regenerating the free space cache.  This is slow enough
> that you should be able to see the free space cache threads active even
> after the initial boot is done.
>
> The good news is that you should be able to just let them finish
> generating the cache and then the problem should go away.
>

HI,Chris,

yes...I did regenerate free_space last time Frederic told me to.

the next boot after removing clear_cache from fstab is super slow. but
after that boot,
kernel still needs 135s to load...

> If it isn't the free space cache, it'll be a fragmentation problem.  The
> easiest way to tell the difference is to get a few sysrq-w snapshots
> during the boot.

How can I "get a few sysrq-w snapshots" please?

My btrfs is automatically created during openSUSE install, so I don't
know which command I can use to do so...please forgive my freshness
and stupidity...

Marguerite
