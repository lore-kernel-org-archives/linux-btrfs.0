Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f49.google.com ([209.85.215.49]:36404 "EHLO
        mail-lf0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750822AbdEMLPm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 13 May 2017 07:15:42 -0400
Received: by mail-lf0-f49.google.com with SMTP id h4so12122790lfj.3
        for <linux-btrfs@vger.kernel.org>; Sat, 13 May 2017 04:15:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$3384$13ad2b1f$3febf76a$c09fcbd7@cox.net>
References: <CAK5rZE4ko_xFr_Zv=bmZ4tR9X59jXaqFnTv16_ynEO0+E5uzeg@mail.gmail.com>
 <f5cb15a5-5566-b366-ebda-c3101fa96eec@gmail.com> <CAK5rZE7WHeTknmQdjX7vianEj4RmdLU+ocTLhbAxYenRjLegaA@mail.gmail.com>
 <20170512202756.16bd785f@jupiter.sol.kaishome.de> <pan$3384$13ad2b1f$3febf76a$c09fcbd7@cox.net>
From: "Janos Toth F." <toth.f.janos@gmail.com>
Date: Sat, 13 May 2017 13:15:25 +0200
Message-ID: <CANznX5Ep68H2YSBPmFJZ=1UjZYvD=VARmdOuzsgQf_xdDv5=iQ@mail.gmail.com>
Subject: Re: Btrfs/SSD
To: Duncan <1i5t5.duncan@cox.net>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> Anyway, that 20-33% left entirely unallocated/unpartitioned
> recommendation still holds, right?

I never liked that idea. And I really disliked how people considered
it to be (and even passed it down as) some magical, absolute
stupid-proof fail-safe thing (because it's not).

1: Unless you reliably trim the whole LBA space (and/or run
ata_secure_erase on the whole drive) before you (re-)partition the LBA
space, you have zero guarantee that the drive's controller/firmware
will treat the unallocated space as empty or will keep it's content
around as useful data (even if it's full of zeros because zero could
be very useful data unless it's specifically marked as "throwaway" by
trim/erase). On the other hand, a trim-compatible filesystem should
properly mark (trim) all (or at least most of) the free space as free
(= free to erase internally by the controller's discretion). And even
if trim isn't fail-proof either, those bugs should be temporary (and
it's not like a sane SSD will die in a few weeks due to these kind of
issues during sane usage and crazy drivers will often fail under crazy
usage regardless of trim and spare space).

2: It's not some daemon-summoning, world-ending catastrophe if you
occasionally happen to fill your SSD to ~100%. It probably won't like
it (it will probably get slow by the end of the writes and the
internal write amplification might skyrocket at it's peak) but nothing
extraordinary will happen and normal operation (high write speed,
normal internal write amplification, etc) should resume soon after you
make some room (for example, you delete your temporary files or move
some old content to an archive storage and you properly trim that
space). That space is there to be used, just don't leave it close to
100% all the time and try never leaving it close to 100% when you plan
to keep it busy with many small random writes.

3: Some drives have plenty of hidden internal spare space (especially
the expensive kinds offered for datacenters or "enthusiast" consumers
by big companies like Intel and such). Even some cheap drivers might
have plenty of erased space at 100% LBA allocation if they use
compression internally (and you don't fill it up to 100% with
in-compressible content).
