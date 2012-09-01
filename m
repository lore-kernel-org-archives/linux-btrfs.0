Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:61674 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753071Ab2IAPla (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 1 Sep 2012 11:41:30 -0400
Received: by lbbgj3 with SMTP id gj3so1794566lbb.19
        for <linux-btrfs@vger.kernel.org>; Sat, 01 Sep 2012 08:41:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGDaZ_p2dXLr6rOZewXUEWYKV4b=dW9OZj4yXG4qPoUax2a8CA@mail.gmail.com>
References: <CAGDaZ_oFzakgBC+NzK4X3J9yL0Q5YfZVKk671QKN0xHAMgPN7g@mail.gmail.com>
	<CAGDaZ_p2dXLr6rOZewXUEWYKV4b=dW9OZj4yXG4qPoUax2a8CA@mail.gmail.com>
Date: Sat, 1 Sep 2012 10:41:28 -0500
Message-ID: <CAGJTRciVqG=CqP4gR4gpz2bmFYORS6ExAT_nDbau2NuCJyipeg@mail.gmail.com>
Subject: Re: rfc: fuzz testing by direct writes to device
From: Michael <mike@draftx.net>
To: Shentino <shentino@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Please make sure you are running a very recent kernel. Btrfs is VERY
active and fixes for things like this are going in all the time. Any
related crash errors, kernel oopses, and exact methodology so we can
reproduce would be useful.
dmesg and uname -a would help us triage this and see what we need to fix.
Mike

On Sat, Sep 1, 2012 at 3:10 AM, Shentino <shentino@gmail.com> wrote:
>
> Also, since the problem prevented me from syncing my other filesystmes
> I couldn't capture the debug info.
>
> It vanished during the cold boot still sitting in dirty page cache.
>
> On Fri, Aug 31, 2012 at 11:44 PM, Shentino <shentino@gmail.com> wrote:
> > How effective would it be to directly write to the underlying device
> > and then running tests to see if the corruption is properly detected?
> >
> > I just ran a fuzz test by syncing, and then manually corrupting a file
> > with the help of a surgical sed (yes, the before and after patterns
> > had fixed equal lengths).  First I got an I/O error (expected), then I
> > ran scrub and got more problems (not ok), the system froze (not good),
> > a reboot failed to mount the system again (worse), and then the fsck
> > program dumped core.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
