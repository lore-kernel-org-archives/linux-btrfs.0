Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f47.google.com ([209.85.218.47]:33758 "EHLO
	mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754141AbbJNUxu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Oct 2015 16:53:50 -0400
Received: by oiar126 with SMTP id r126so35094379oia.0
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Oct 2015 13:53:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <561EBC3D.8060004@bouton.name>
References: <2402569.dCkKzGyGNU@hoefnix> <CAC=t97Awr6-pWGAXEMaRfFnPGKJiPyRH2g39oN+0WzhNYFrBNg@mail.gmail.com>
 <561EBC3D.8060004@bouton.name>
From: Donald Pearson <donaldwhpearson@gmail.com>
Date: Wed, 14 Oct 2015 15:53:30 -0500
Message-ID: <CAC=t97COVc4kQ+A-jSVr3ujGb-0WGNh2qCcohBvLFw=YtnObhA@mail.gmail.com>
Subject: Re: RAID6 stable enough for production?
To: Lionel Bouton <lionel-subscription@bouton.name>
Cc: Sjoerd <sjoerd@sjomar.eu>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've used it from 3.8 something to current, it does not handle drive
failure well at all, which is the point of parity raid. I had a 10disk
Raid6 array on 4.1.1 and a drive failure put the filesystem in an
irrecoverable state.  Scrub speeds are also an order of magnitude or
more slower in my own experience.  The issue isn't filesystem
read/write performance, it's maintenance and operation.

That 10 drive system was rebuilt as raid10 and I haven't had problems
since, and it's handled hdd problems reasonably well.

I finally moved away from raid56 yesterday because of the time it took
to scrub.  This was a 4x3tb array raid6 that i only used for backups.
I attempted to just rebalance in to raid10 but partway through the
balance the filesystem ran in to problems, forcing the filesystem into
readonly.  I tried some things to overcome that but ultimately just
wiped it out and recreated as raid10.  I suspect one of the drives may
be having problems so I'm running tests on it now.

Personally I would still recommend zfs on illumos in production,
because it's nearly unshakeable and the creative things you can do to
deal with problems are pretty remarkable.  The unfortunate reality is
though that over time your system will probably grow and expand and
zfs is very locked in to the original configuration.  Adding vdevs is
a poor solution IMO.

On Wed, Oct 14, 2015 at 3:34 PM, Lionel Bouton
<lionel-subscription@bouton.name> wrote:
> Le 14/10/2015 22:23, Donald Pearson a écrit :
>> I would not use Raid56 in production.  I've tried using it a few
>> different ways but have run in to trouble with stability and
>> performance.  Raid10 has been working excellently for me.
>
> Hi, could you elaborate on the stability and performance problems you
> had? Which kernels were you using at the time you were testing?
>
> I'm interested because I have some RAID10 installations of 7 disks which
> don't need much write performance (large backup servers with few clients
> and few updates but very large datasets) that I plan to migrate to RAID6
> when they approach their storage capacity (at least theoretically with 7
> disks this will give better read performance and better protection
> against disk failures). 3.19 brought full RAID5/6 support and from what
> I remember there were some initial quirks but I'm unaware of any big
> RAID5/6 problem in 4.1+ kernels.
>
> Best regards,
>
> Lionel
