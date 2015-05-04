Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vn0-f45.google.com ([209.85.216.45]:33380 "EHLO
	mail-vn0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477AbbEDXkI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 May 2015 19:40:08 -0400
Received: by vnbf1 with SMTP id f1so15835730vnb.0
        for <linux-btrfs@vger.kernel.org>; Mon, 04 May 2015 16:40:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$3396c$51a072b0$71501292$8af8c3ee@cox.net>
References: <CADw2B2NDTqOXQdh+xBTfk3=MfYJUtGAvQ-B4RaADA4XXJ30OZw@mail.gmail.com>
	<20150412201107.GA4711@hungrycats.org>
	<pan$3396c$51a072b0$71501292$8af8c3ee@cox.net>
Date: Mon, 4 May 2015 16:40:08 -0700
Message-ID: <CADw2B2NuyxorUUJvpwUuPF78adrey9OORgviWg5NWx56cknOdg@mail.gmail.com>
Subject: Re: mlocate/updatedb and btrfs subvolume mounts
From: "G. Richard Bellamy" <rbellamy@pteradigm.com>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Apr 12, 2015 at 9:12 PM, Duncan <1i5t5.duncan@cox.net> wrote:
>
> Zygo Blaxell posted on Sun, 12 Apr 2015 16:11:07 -0400 as excerpted:
>
> > Since these are simple binds (not rbinds), they don't see any other
> > filesystems, period.  They do see btrfs subvolumes, though.
>
> Tho... for systemd users...
>
> Do note that systemd plays with the kernel's shared-subtree "private"
> default, switching it to shared for /.

I like to think I know a bit about a thing or two. I've read both Zygo
and Duncan's probably cogent responses.

My brain hurts, and I am just not getting it.

If I am to understand correctly, and specific to my OP, the problem
with updatedb et al. on my system is that /, /home, /var, /opt and
/var/lib/libvirt are all subvolume mounts - which appear as bind
mounts. Thus the PRUNE_BIND_MOUNTS prunes ALL mounts, and updatedb
sees nothing.

Everything else is a blur when we start talking about "mount --bind /
/.binds/root"

Oh wait, maybe I get it now...

By running "mount --bind / /.binds/root" and running updatedb in
"/.binds/root" while still allowing it to see binds, I am certain to
get a an mlocate db, and it won't ever see anything outside that
explicit hierarchy.

Something like that?

-rb
