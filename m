Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:33406 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757402AbcAaMgj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 31 Jan 2016 07:36:39 -0500
Received: by mail-lb0-f178.google.com with SMTP id x4so62243144lbm.0
        for <linux-btrfs@vger.kernel.org>; Sun, 31 Jan 2016 04:36:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRw1VqaES4UCbaSNqCRXV5puA5gssxNSxsiUBKxa13dPQ@mail.gmail.com>
References: <CAKbQEqE0w5fewMw9YwooFXaEVT2ecfGf6ZCVvUmQg8SjGx2Zsw@mail.gmail.com>
 <CAPmG0jbLVVRJVoqehWxuNncF6oLydazo5-YO=3fLAbrksv2sJg@mail.gmail.com>
 <CAKbQEqH5twwezxYicthcCb6=dWgW3Hy-s6fLjH_BQETk4i0ikQ@mail.gmail.com> <CAJCQCtRw1VqaES4UCbaSNqCRXV5puA5gssxNSxsiUBKxa13dPQ@mail.gmail.com>
From: Christian Pernegger <pernegger@gmail.com>
Date: Sun, 31 Jan 2016 13:35:58 +0100
Message-ID: <CAKbQEqFYQ0XQAQOzOBX=n5jrxxws97Qd5OizEaGGq6tayEJcKg@mail.gmail.com>
Subject: Re: "WARNING: device 0 not present" during scrub?
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 31 January 2016 at 02:42, Chris Murphy <lists@colorremedies.com> wrote:
> On Sat, Jan 30, 2016 at 2:19 PM, Christian Pernegger
> It maybe be stable for Debian but is Debian explicitly supporting
> Btrfs with this release? I don't think they are.

The modules are in the kernel, the progs are in the main archive, it's
an option in the installer. It's not the default fs but I couldn't
find any indication that it's more or less supported than, say, xfs.
Why they've chosen 3.16 (and not 3.18, which would be a long term
release) I don't know, but the fact remains that that's the default
kernel of a tier 1 distro, so people using it are going to be around
for a while.

> But absolutely, of course we hope the problem is gone with the newer
> version, *that's how file system development works.*

Be that as it may, as I said, that approach doesn't inspire
confidence. If I had the vaguest idea about how to reproduce it, sure,
but all I have is an apparently lightly corrupted or at the very least
glitchy fs (it mounts and unmounts just fine). How would I know if a
new kernel helped things?

> I can see how it might seem like it's a reasonable question to just
> ask first, but it really isn't. There's just so much development
> happening right now, a developer is not in a great position to think
> that far back for specific problems and whether yours might be one of
> them, and in what kernel version it was fixed. *shrug* just doesn't
> work that way, that's why there are changelogs for every sub kernel
> version.

I do understand your point of view, but: If a possible fs corruption
bug on a widespread (if older) kernel after one month of use and
without any discernible cause gets nothing more than *shrug* from this
list then btrfs isn't production ready nor ready for any kind of
day-to-day use, not because of code maturity but because of that
mindset. IMHO the btrfs-genie is too far out of the bottle for that,
the wording of the stability status on the wiki much too inviting.

Anyway, I knew what I was getting into, so I'll just chalk it up to
experience and move on. Keep up the good work!

> Have you checked out ZFS on Linux? That might fit your use case better
> because it has the features you're asking for, but at least the ZFS
> portion is older and considered more stable.

It seemed a bit over the top on a single disk and 4GB of (not even
ECC) RAM. Between btrfs' heavy development and zfsonlinux being stable
but needing potentially less stable Solaris-glue and having no
distro-side support I thought I'd try btrfs first.

Regards,
Christian Pernegger
