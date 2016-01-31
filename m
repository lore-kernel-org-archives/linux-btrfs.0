Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:33593 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933022AbcAaSGk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 31 Jan 2016 13:06:40 -0500
Received: by mail-lb0-f175.google.com with SMTP id x4so64415135lbm.0
        for <linux-btrfs@vger.kernel.org>; Sun, 31 Jan 2016 10:06:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAKbQEqFYQ0XQAQOzOBX=n5jrxxws97Qd5OizEaGGq6tayEJcKg@mail.gmail.com>
References: <CAKbQEqE0w5fewMw9YwooFXaEVT2ecfGf6ZCVvUmQg8SjGx2Zsw@mail.gmail.com>
	<CAPmG0jbLVVRJVoqehWxuNncF6oLydazo5-YO=3fLAbrksv2sJg@mail.gmail.com>
	<CAKbQEqH5twwezxYicthcCb6=dWgW3Hy-s6fLjH_BQETk4i0ikQ@mail.gmail.com>
	<CAJCQCtRw1VqaES4UCbaSNqCRXV5puA5gssxNSxsiUBKxa13dPQ@mail.gmail.com>
	<CAKbQEqFYQ0XQAQOzOBX=n5jrxxws97Qd5OizEaGGq6tayEJcKg@mail.gmail.com>
Date: Sun, 31 Jan 2016 19:06:38 +0100
Message-ID: <CAPmG0jY=5qWgE1b2HTXYZFY97peu8cZ=1i0kR=tMvrnG-MJgVA@mail.gmail.com>
Subject: Re: "WARNING: device 0 not present" during scrub?
From: Henk Slager <eye1tm@gmail.com>
To: Christian Pernegger <pernegger@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> The modules are in the kernel, the progs are in the main archive, it's
> an option in the installer. It's not the default fs but I couldn't
> find any indication that it's more or less supported than, say, xfs.
> Why they've chosen 3.16 (and not 3.18, which would be a long term
> release) I don't know, but the fact remains that that's the default
> kernel of a tier 1 distro, so people using it are going to be around
> for a while.
>
>> But absolutely, of course we hope the problem is gone with the newer
>> version, *that's how file system development works.*
>
> Be that as it may, as I said, that approach doesn't inspire
> confidence. If I had the vaguest idea about how to reproduce it, sure,
> but all I have is an apparently lightly corrupted or at the very least
> glitchy fs (it mounts and unmounts just fine). How would I know if a
> new kernel helped things?

Boot the board with one of these images (a live one I would say):
http://download.opensuse.org/tumbleweed/iso/
This weekend this is kernel 4.4.0-2-default and tools 4.3.1

Then report back the result of btrfs check of the fs

You might get some (or millions) false positives from the check with
tools 4.3.1 (but fixed in v4.4), due to the tools version your fs is
created with. This is not a problem, at least is my experience.
But you can compile the v4.4 tools from
https://github.com/kdave/btrfs-progs
