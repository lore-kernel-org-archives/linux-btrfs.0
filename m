Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:36601 "EHLO
	mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932156AbcAaBmH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 30 Jan 2016 20:42:07 -0500
Received: by mail-io0-f175.google.com with SMTP id g73so125886427ioe.3
        for <linux-btrfs@vger.kernel.org>; Sat, 30 Jan 2016 17:42:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAKbQEqH5twwezxYicthcCb6=dWgW3Hy-s6fLjH_BQETk4i0ikQ@mail.gmail.com>
References: <CAKbQEqE0w5fewMw9YwooFXaEVT2ecfGf6ZCVvUmQg8SjGx2Zsw@mail.gmail.com>
	<CAPmG0jbLVVRJVoqehWxuNncF6oLydazo5-YO=3fLAbrksv2sJg@mail.gmail.com>
	<CAKbQEqH5twwezxYicthcCb6=dWgW3Hy-s6fLjH_BQETk4i0ikQ@mail.gmail.com>
Date: Sat, 30 Jan 2016 18:42:05 -0700
Message-ID: <CAJCQCtRw1VqaES4UCbaSNqCRXV5puA5gssxNSxsiUBKxa13dPQ@mail.gmail.com>
Subject: Re: "WARNING: device 0 not present" during scrub?
From: Chris Murphy <lists@colorremedies.com>
To: Christian Pernegger <pernegger@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jan 30, 2016 at 2:19 PM, Christian Pernegger
<pernegger@gmail.com> wrote:

>
>> An an obvious advice is to use a 4.4 kernel and tools. Debian 'stable' doesn't mean
>> that every piece of the kernel and tooling fits that 'stamp'. [...] Maybe you could switch
>> to a rolling release linux distro or just update the debian kernel.
>
> Using Debian stable usally means that once something is set up and
> works it keeps working until the hardware dies with little to no user
> interaction. For someting that sits in a corner and pulls in backups
> that suits me just fine. If there's a specific reason to update the
> kernel and btrfs-progs, it's easily done of course, but "let's hope it
> has gone away with the newer version" doesn't inspire me with
> confidence on its own.

It maybe be stable for Debian but is Debian explicitly supporting
Btrfs with this release? I don't think they are. In which case, it's
at the least the wrong kernel version. The only distro explicitly
supporting Btrfs is openSUSE. So if you need Btrfs in particular to be
stable, and you don't want to have to think quite as much about
kernels, you could consider that.

But absolutely, of course we hope the problem is gone with the newer
version, *that's how file system development works.* If it hasn't, and
you reproduce the problem with kernel 4.4, then that means you've
found a new bug that needs to be fixed. And first, it'd only possibly
get fixed in 4.5 or newer before being backported to older kernels.
That's how it goes.

I can see how it might seem like it's a reasonable question to just
ask first, but it really isn't. There's just so much development
happening right now, a developer is not in a great position to think
that far back for specific problems and whether yours might be one of
them, and in what kernel version it was fixed. *shrug* just doesn't
work that way, that's why there are changelogs for every sub kernel
version.


>> But the more fundamental question is why you use btrfs? What features
>> do you need that ext4 or xfs or reiserfs don't have?
>
> Data checksumming. I don't mind a bit flipping here or there in old
> backups / archives but I'd have liked to know if something went bad
> and which files were affected. Compression. Dedup that works on mortal
> hardware.

Have you checked out ZFS on Linux? That might fit your use case better
because it has the features you're asking for, but at least the ZFS
portion is older and considered more stable.



-- 
Chris Murphy
