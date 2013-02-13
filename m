Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:65217 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160Ab3BMVXk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Feb 2013 16:23:40 -0500
Received: by mail-la0-f41.google.com with SMTP id fo12so1642315lab.28
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Feb 2013 13:23:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20130213211112.GA31017@wotan.suse.de>
References: <20130212231526.GE12339@twin.jikos.cz>
	<CADU+-uC64KQPys9K3yC3PG11LLCqQtSsRYDAPvKzcwsCn6MoVQ@mail.gmail.com>
	<20130213211112.GA31017@wotan.suse.de>
Date: Wed, 13 Feb 2013 13:23:38 -0800
Message-ID: <CADU+-uByu252tO1WpZ5hHy_AKx+_3tf=ZSmL6qFpJ_2DSAXeKw@mail.gmail.com>
Subject: Re: Integration branch of btrfs-progs 2013-02
From: Filipe Brandenburger <filbranden@google.com>
To: Mark Fasheh <mfasheh@suse.de>
Cc: dsterba@suse.cz, linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Mark,

On Wed, Feb 13, 2013 at 1:11 PM, Mark Fasheh <mfasheh@suse.de> wrote:
> On Tue, Feb 12, 2013 at 07:35:31PM -0800, Filipe Brandenburger wrote:
>> Another reason of my concerns is that I've been trying to work on
>> exporting the equivalent of ioctl.h, with the constants and structs
>> needed to call btrfs-specific ioctls, from the kernel side, I already
>> submitted a patch to export it from a Linux kernel build as
>> /usr/include/linux/btrfs.h. I believe that's the right way to export
>> that particular information.
>
> I don't disagree with this goal, in fact I quite like it. Can you point us
> to your work?

Sure.

1) Exposing list of constants needed for ioctls from the kernel
include files (that makes it into /usr/include/linux):
http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg21678.html

I also wrote an initial patchset to use that from strace in order to
be able to use strace on the btrfs-progs and interpret the ioctls:
http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg21679.html

I want to resume that work, but that definitely involves shifting
things around in header files and that looks to me like walking on
quicksand right now so I'm a bit wary...

2) Merging headers and source files from kernel btrfs and btrfs-progs:
http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg22124.html

That's simply a proposal on using a script to "checkout" a certain
version of the shared files from the kernel sources into the
btrfs-progs git tree (think of it as a sparse git submodule.)

It doesn't go into the lengths of making the kernel source compatible
with userspace (e.g. using #ifdef's and #define's etc.) but it's a
start having the files there so that you could try to compile them and
see the issues.

Cheers,
Filipe
