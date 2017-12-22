Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:34073 "EHLO
        mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756808AbdLVVEp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Dec 2017 16:04:45 -0500
Received: by mail-oi0-f54.google.com with SMTP id u193so19718845oie.1
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Dec 2017 13:04:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171222160543.GA4199@polanet.pl>
References: <23094.37316.66397.431081@tree.ty.sabi.co.uk> <91965e24-3b94-7334-c249-d8de5f585f29@gmail.com>
 <20171218194351.GA25245@polanet.pl> <7ff86029-5b0f-1d02-778a-af78c6f3e461@gmail.com>
 <20171219144644.GA9855@polanet.pl> <CAJCQCtSwfoSmAfFyP15xp-uysBY1kWyt65Jhf37g68YcPQ2QEA@mail.gmail.com>
 <20171219204155.GB14726@polanet.pl> <aac98fbf-c94b-1a88-f191-902146ff544f@gmail.com>
 <CAA91j0X_MZ+EjgZMNGrfChBdFed_G3oLttdpYjCOq-vERzoiKw@mail.gmail.com>
 <94b6b4cb-9f1a-c90b-5ffb-fb4d7385526b@gmail.com> <20171222160543.GA4199@polanet.pl>
From: Chris Murphy <lists@colorremedies.com>
Date: Fri, 22 Dec 2017 14:04:43 -0700
Message-ID: <CAJCQCtQ=ybjWxPtwBXcRx6-CS=s-FomWHoGpFR+J76q+gdLM+w@mail.gmail.com>
Subject: Re: Unexpected raid1 behaviour
To: Tomasz Pala <gotar@polanet.pl>
Cc: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 22, 2017 at 9:05 AM, Tomasz Pala <gotar@polanet.pl> wrote:
> On Thu, Dec 21, 2017 at 07:27:23 -0500, Austin S. Hemmelgarn wrote:
>
>> Also, it's not 'up to the filesystem', it's 'up to the underlying
>> device'.  LUKS, LVM, MD, and everything else that's an actual device
>> layer is what systemd waits on.  XFS, ext4, and any other filesystem
>> except BTRFS (and possibly ZFS, but I'm not 100% sure about that)
>> provides absolutely _NOTHING_ to wait on.  Systemd just chose to handle
>
> You wait for all the devices to settle. One might have dozen of drives
> including some attached via network and it might take a time to become
> available. Since systemd knows nothing about underlying components, it
> simply waits for the btrfs itself to announce it's ready.


I'm pretty sure degraded boot timeout policy is handled by dracut. The
kernel doesn't just automatically assemble an md array as soon as it's
possible (degraded) and then switch to normal operation as other
devices appear. I have no idea how LVM manages the delay policy for
multiple devices.

I don't think the delay policy belongs in the kernel.

It's pie in the sky, and unicorns, but it sure would be nice to have
standardization rather than everyone rolling their own solution. The
Red Hat Stratis folks will need something to do this for their
solution so yet another one is about to be developed...


-- 
Chris Murphy
