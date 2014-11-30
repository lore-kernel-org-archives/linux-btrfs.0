Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f178.google.com ([209.85.216.178]:59826 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718AbaK3DyU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 29 Nov 2014 22:54:20 -0500
Received: by mail-qc0-f178.google.com with SMTP id b13so6947121qcw.37
        for <linux-btrfs@vger.kernel.org>; Sat, 29 Nov 2014 19:54:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5479FD39.6030208@pobox.com>
References: <CAH-HCWUR4QPDn=M8nchdRedzGU3DYDHC8d6YRH8-FBm6trWCJg@mail.gmail.com>
 <20141129142813.GD32735@carfax.org.uk> <CAH-HCWWh02invDCdx4-bPORdg4r39efsW=buKXTVtfspSQ9sVA@mail.gmail.com>
 <5479FD39.6030208@pobox.com>
From: Shriramana Sharma <samjnaa@gmail.com>
Date: Sun, 30 Nov 2014 09:23:59 +0530
Message-ID: <CAH-HCWXhm6a2jU-eO+YRV9EW-LV6Z-NQeNR5RL_cC91txQc6zw@mail.gmail.com>
Subject: Re: Moving contents from one subvol to another
To: Robert White <rwhite@pobox.com>
Cc: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Nov 29, 2014 at 10:37 PM, Robert White <rwhite@pobox.com> wrote:
>
> One thing to keep in mind is that mv, when crossing any of these boundaries
> degenerates to a copy-and-remove operation and _none_ of the source files
> will be removed until _all_ of the files have been copied. If any of the
> copy operations fail the removes will not take place at all. It would only
> take a couple large NOCOW files to put you over a limit somewhere.

Hmm... So you're saying like because the copy routine that mv calls
will see the nocow attribute (and it doesn't know it's being called as
part of a move operation) and so do a full copy rather than reflink?

Correct me if I'm wrong but it seems that mv should actually ignore
the nocow attribute as far as moving it to a new location is
concerned, no, because I'm moving, not copying? Of course it should
retain the attribute of the original files *after* the move is done.

Why should noCoW affect cp --reflink anyhow? I just created a 500 MiB
file from /dev/urandom under a chattr +C-ed dir, and copied to another
subvol using cp --reflink, and fi df still shows 500 MiB, not 1 GiB.

> If you are consolidating sub-volumes (as per the original question) on a
> "nearly full" drive you may want to do it all long-hand with a script moving
> various chunks or something instead of just trying a move/copy of "cp
> --reflinks /vol1/* /vol2/" (same for mv when you get that --reflinks
> revision).

As I said, there doesn't actually seem to be a --reflink command line option.

-- 
Shriramana Sharma ஶ்ரீரமணஶர்மா श्रीरमणशर्मा
