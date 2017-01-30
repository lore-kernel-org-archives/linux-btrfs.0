Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:58025 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751087AbdA3Bta (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 29 Jan 2017 20:49:30 -0500
Date: Mon, 30 Jan 2017 02:49:23 +0100
From: Adam Borowski <kilobyte@angband.pl>
To: Subscription Account <4subsacct+btrfs@gmail.com>
Cc: btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Raid1 won't mount degraded
Message-ID: <20170130014923.42rma3b5oirquog6@angband.pl>
References: <CAHMMHbe4Py0JBxOQ7Z7Vv4r0UQ4ZJPKjKUXZqNo+Pdi6L_gAaw@mail.gmail.com>
 <20170129201650.wvpzaz45r5uzsvrb@angband.pl>
 <CAHMMHbfUkrpN4+pJwAgRP_LqezC1uY8w0p5e-P1LDRUW06KyMw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAHMMHbfUkrpN4+pJwAgRP_LqezC1uY8w0p5e-P1LDRUW06KyMw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jan 29, 2017 at 08:26:54PM -0500, Subscription Account wrote:
> On Sun, Jan 29, 2017 at 3:16 PM, Adam Borowski <kilobyte@angband.pl> wrote:
> > On Sun, Jan 29, 2017 at 08:12:56AM -0500, Subscription Account wrote:
> >> [ 2506.816795] BTRFS: missing devices(1) exceeds the limit(0),
> >> writeable mount is not allowed
> >>
> >> In the read-only mode I am not able to add a new device or replace :(.
> >> Please help.
> >
> > A known problem; you can mount rw degraded only once, if you don't fix the
> > degradation somehow (by adding a device or converting down), you can't mount
> > rw again.
> 
> Uh oh! I wish I know that I only had one shot :(.

No data is actually lost, it was raid1, it's raid1+single now.  The mount
check is naive and in this case wrong.

> > If you know how to build a kernel, here's a crude patch.
> 
> I am feeling a little lucky because I still have the other disk and I
> am assuming if I remove my current disk and put the other disk in, I
> would be able to mount it once again?

Not sure if that's a good idea if the copies are out of sync.

> Also, since I have couple times already tried btrfs repair etc, can I
> trust the current disk anyways?
> 
> if I get into issue again, I would definitely use the patch to
> recompile the kernel and thanks a lot for the same.

No, the patch doesn't prevent the issue.  It lets you recover -- ie, it
should help in the situation you're in right now.


Meow!
-- 
Autotools hint: to do a zx-spectrum build on a pdp11 host, type:
  ./configure --host=zx-spectrum --build=pdp11
