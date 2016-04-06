Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:34153 "EHLO
	mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754093AbcDFDyN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Apr 2016 23:54:13 -0400
Received: by mail-wm0-f44.google.com with SMTP id l6so47326559wml.1
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Apr 2016 20:54:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$84aa7$90a27a$80294ac8$88eb3ebd@cox.net>
References: <56B505CB.8080604@gmail.com>
	<pan$84aa7$90a27a$80294ac8$88eb3ebd@cox.net>
Date: Tue, 5 Apr 2016 23:54:11 -0400
Message-ID: <CAD=QJKgQhWtrU+8fn3rDbTbe_f-H0SgMFZdJgP4UP2hmOuzVGg@mail.gmail.com>
Subject: Re: btrfs-progs4.4 with linux-3.16.7 (with truncation of extends patch)
From: Nicholas D Steeves <nsteeves@gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dear Duncan,

Gmail seems to have mangled the draft of my reply :-/  It's at the bottom.

On 06/02/16 12:57 AM, Duncan wrote:

Most of the rest of the userspace tools, in particular, btrfs scrub,
subvolume, balance, device, filesystem, send, receive, etc, work by
making kernel calls to do the actual work in any case, and they will
use the old calls if they need to. The compatibility discussion,
meanwhile, is on making mkfs.btrfs (and btrfs-convert) check the
running kernel and taking its defaults from what that kernel supports,
instead of choosing arbitrary defaults that may be better when
supported, but that older kernels don't actually support. Of course
there will still be options to set these as desired regardless of
defaults, just as there are now, so people using for instance booted
to an old recovery kernel for system maintenance can still choose
whatever options that version of mkfs.btrfs supports if they know
they'll actually be mounting with a newer kernel, but the idea is
simply to have mkfs.btrfs act more sanely /by/ /default/ when run on
old kernels, so those same old kernels can actually mount a filesystem
created with defaults. Along that line, as a distro maintainer of the
btrfs-progs package, you may wish to patch the mkfs.btrfs defaults to
what your kernel supports.

Btrfs-progs will probably ship with kernel-sensitive defaults some
time in the future (userspace 4.5 release, probably), but it doesn't
do so yet...
--

Thank you very much for taking the time to write such a thorough
reply. I'm not the maintainer of Debian's btrfs-progs package, but I
am investigating the issues preventing the addition of btrfs-progs-4.4
to the backports repository. [ edit: sorry it took me so long to
reply, I've been swamped with work.  In the meantime, it seems v4.4
has made it into the backports without warnings or compatibility
checks, so I want to get my facts straight asap and patch the package
with some kind of a notice/alert asap, if only through the
debian/NEWS...since there isn't currently a way to depend on a
particular kernel series, or ever a kernel version <= 4.4.0

Cheers,
Nicholas
