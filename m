Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:33173 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751616AbdGXGGK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Jul 2017 02:06:10 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1dZWVD-0004rC-Eu
        for linux-btrfs@vger.kernel.org; Mon, 24 Jul 2017 08:05:59 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs device ready purpose
Date: Mon, 24 Jul 2017 06:05:46 +0000 (UTC)
Message-ID: <pan$9a188$a13ade57$5a6f25fe$90034cc2@cox.net>
References: <CAJCQCtR+dJr8H2co41LB0hEUZCFSnkixeyv46ccdureMiBVTWg@mail.gmail.com>
        <74c792e3-d8f6-fb09-c6ee-62dfdf59650c@gmail.com>
        <CAJCQCtTnfLiiURTzLre-ZYY5xQBjFf2Qrz02gqGvh6BbaF2=KQ@mail.gmail.com>
        <20170717155400.GN2866@twin.jikos.cz>
        <CAJCQCtTjKRZxN+MxyM0=DJmqF94WBrV3Uoz7kw5SGq_xQ1fzrg@mail.gmail.com>
        <9a16f6d5-90cd-bd04-a0ea-63e88cc3faf4@gmail.com>
        <CAJCQCtQBidjgsg4MadAAqoy6+dQHCkgz=8pxPX2CC=6Mwj38MQ@mail.gmail.com>
        <CAJCQCtQohx9MYbNFYyd6HidxSE6Cm7+ptwx76HmxBFdy9_7Zuw@mail.gmail.com>
        <20170722181558.GI7140@carfax.org.uk>
        <20170722195830.lx3xgdbsfj3keuil@angband.pl>
        <CAJCQCtSajeZ2uLA7XR_LR=uD0mi1An7hq-SoK2k1B2TWGJi8gg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Sat, 22 Jul 2017 14:35:25 -0600 as excerpted:

> If we go back even further in time, what I'm trying to avoid is the
> problem with DE's where the user connects a two device Btrfs, and then
> they want to eject it. The DE is already confused because behind the
> scenes it has actually mounted each device to two different mount
> points, which Btrfs allows (it's one file system, on two mount points).
> That's confusing, but not a big problem. The big problem happens when
> the user wants to stop using that file system. So they eject one of the
> two appearing devices (which should of course only be one with Btrfs)
> and behind the scenes udisksd umounts just one of the mountpoints and
> then appears to delete that device node, which in effect makes the still
> mounted file system degraded, and results in corruption.
> 
> Btrfs fixes this up on the next mount of both devices. But it's just
> asking for trouble.
> 
> Output of this behavior here:
> https://bugs.freedesktop.org/show_bug.cgi?id=87277#c3

Ugh.  Yet another reason for me to be glad I've neutered that behavior on 
my installation of my DE of choice.[1]

But the main problem would appear to be the still lacking in the after 
all still not yet fully stable and under heavy development btrfs, concept 
of device tracking and disappearance/reappearance handling.  Without 
that, all sorts of would-be expected multi-device behavior is missing.

As it happens, the device tracking concept/feature was necessary for the 
now long back-burnered hot-spare feature, so got pulled into that patch 
set, along with the per-chunk device availability check that allows 
proper degraded writable-mount raid1, etc.

Of course the latter got dusted off and now appears close to merge (yay!, 
double-yay since all my btrfs are raid1 or dup, here, and it could come 
in quite handy if an ssd starts acting up!), but the rest of that patch 
set, AFAIK, remains back-burnered with no preliminary target merge kernel 
set.

Perhaps the next bit of it we need to dust off and get ready to merge is 
the real dynamic device detection stuff.  Of course that'll make the hot-
spares patch set smaller and easier to merge in the end, but it should 
also make fixing a whole family of issues related to the fact that btrfs 
really doesn't detect device disappearance either go away directly, or 
make the patches much more trivial than they would be otherwise, since we 
simply don't have the functionality we need for it, yet.

---
[1] My DE:  A "lite" version of kde/plasma, without the semantic-desktop 
stuff and without the device detection, etc.  It still build/link/run 
depends on solid for what would be device detection/activation, but that 
in turn run-time depends on udisks.  But fortunately, udisks is only a 
run-time dep, with the executable actually a script after all so it's not 
going to be linked in, so as a gentooer I have a few alternatives 
including the one I've taken, providing a "null-package" udisks package 
that installs nothing and depends on nothing, so devices don't get auto-
mounted, which makes me happy, but I also don't have to worry about all 
the stuff udisks would otherwise pull in in its turn.  Not like they'd be 
automountable anyway given that I don't have policykit, etc, installed, 
but this way I don't have to worry about the additional deps, either.

I get a few complaints in the log when plasma starts up, but other than 
that, it behaves as I want -- no mounts unless I specifically ask for 
them either as root (usually via sudo), or with the appropriate fstab 
options.  To let it behave otherwise and do automatic mounts without that 
sort of strict control is practically /begging/ for unexpected/undefined 
behavior, some of which, no surprise given the problems MS has had with 
this whole idea that we should have learned from, turns out to be data-
loss and/or security risky, as it is here.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

