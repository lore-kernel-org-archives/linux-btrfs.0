Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f176.google.com ([209.85.160.176]:34291 "EHLO
	mail-yk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863AbbGOADg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jul 2015 20:03:36 -0400
Received: by ykax123 with SMTP id x123so22685791yka.1
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Jul 2015 17:03:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150713004249.GP5274@merlins.org>
References: <11148188.L9vtSMaNHV@merkaba> <559FA280.8090309@tty0.ch>
 <20150712035523.GI5274@merlins.org> <20150713004249.GP5274@merlins.org>
From: Paul Harvey <csirac2@gmail.com>
Date: Wed, 15 Jul 2015 10:03:16 +1000
Message-ID: <CAB3_QuKuTeT7t--=y917AASM9QQHSRin4ZKRm57A0b+z0m=yvA@mail.gmail.com>
Subject: Re: Anyone tried out btrbk yet?
To: Marc MERLIN <marc@merlins.org>
Cc: Axel Burri <axel@tty0.ch>, Martin Steigerwald <martin@lichtvoll.de>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The way it works in snazzer (and btrbk and I think also btrfs-sxbackup
as well), local snapshots continue to happen as normal (Eg. daily or
hourly) and so when your backup media or backup server is finally
available again, the size of each individual incremental is still the
same as usual, it just has to perform more of them.

Separating snapshotting from transport lends to more flexibility IMHO,
Eg. with snazzer I can keep multiple physical backup media in sync
with each other even if I only rotate/attach those disks once a
week/month (maintain backup filesystems in parallel), the
snazzer-receive script is very dumb - it just receives all the missing
snapshots from the source. However it does filter them cf. "btrfs
subvolume list /subvolume | snazzer-prune-candidates --invert" first
in case some would just be deleted again shortly after according to
retention policy.

For the ssh transport, you can do the same things but in series: push
the snapshots up to a local server and then on to remote storage
elsewhere (maintain backup filesystems in series).

Because the snapshotting, transport and pruning operations are
asynchronous the logic for all this is relatively simple.

It's thanks to seeing send/receive struggles such as yours on this
list (which has also happened to me, but only very rarely: it seems I
tend to have reliable connectivity), among other issues, that I wrote
snazzer-measure. It ends up appending reproducible sha512sum and pgp
signatures to a measurements file for each snapshot, measurements
happen more than just once so they're timestamped with hostname - the
hope is I should spot any corruption that happens after the first
measurements are taken.

This is also a separate/async operation (it's the most I/O and CPU
intense operation of all).
