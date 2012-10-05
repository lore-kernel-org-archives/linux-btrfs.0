Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:57699 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754Ab2JEGnn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Oct 2012 02:43:43 -0400
Received: by mail-ob0-f174.google.com with SMTP id uo13so1370452obb.19
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Oct 2012 23:43:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAG1y0scP8zMd0moJp_Ajk=NovFhkqRn_wvbS3hM+L=-tp_Ptrw@mail.gmail.com>
References: <BANLkTinjKR0PwvL0pcseP7ReEeSOUpObBQ@mail.gmail.com>
 <BANLkTimHUcOpSGfWKtAcTMGnZ5Gr41jrzw@mail.gmail.com> <CAG1y0scP8zMd0moJp_Ajk=NovFhkqRn_wvbS3hM+L=-tp_Ptrw@mail.gmail.com>
From: Joel Pearson <japearson@agiledigital.com.au>
Date: Fri, 5 Oct 2012 16:43:22 +1000
Message-ID: <CAN6mLwkAhfpVoFji5mBrweJF5_N_C1RWLZKgp0W4F+tkxJXi4Q@mail.gmail.com>
Subject: Re: btrfs causing reboots and kernel oops on SL 6 (RHEL 6)
To: "Fajar A. Nugraha" <list@fajar.net>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 5 October 2012 13:29, Fajar A. Nugraha <list@fajar.net> wrote:
>
> On Sat, Jun 4, 2011 at 11:33 AM, Joel Pearson
> <japearson@agiledigital.com.au> wrote:
> > Hi,
> >
> > I'm using SL 6 (RHEL 6) and I've been playing around with running
> > PostgreSQL on btrfs. Snapshotting works ok, but the computer keeps
> > rebooting without warning (can be 5 mins or 1.5 hours), finally I
> > actually managed to get a Kernel Crash instead of just a reboot.
> >
> > I took a picture of the screen:
> > http://imageshack.us/photo/my-images/716/img0143y.jpg/
> >
> > The important bits are:
> >
> > IP: [<ffffffffa032c471>] btrfs_print_leaf +0x31/0x820 [btrfs]
> > PGD 0
> > Oops: 0000 [#1] SMP
> > last sysfs file: /sys/devices/virtual/block/dm-3/dm/name
> >
> > The crashes aren't predictable either. Like it doesn't always happen
> > when I do a snapshot or anything like that.
> >
> > Is this a known problem, that is fixed in a later kernel or something like that?
>
>
> Which kernel is this?
>
> If it's the default SL/RHEL 2.6.32 kernel, then you should try upgrade
> first. http://elrepo.org/tiki/kernel-ml is a good choice.

Yes it was the stock kernel, I didn't know you could get recent
kernels on RHEL 6, that's good to know.

>
> It's highly unlikely that anyone would be willing to look at bugs on
> that "archaic" (in btrfs world) kernel.

Yep fair enough.  We moved to ZFS in the end, which was able to do the
same things we needed btrfs to do.

>
> --
> Fajar

Cheers,

-Joel
