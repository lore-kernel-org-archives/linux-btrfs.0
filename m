Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f195.google.com ([74.125.82.195]:43948 "EHLO
        mail-ot0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753429AbeFGUid (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Jun 2018 16:38:33 -0400
Received: by mail-ot0-f195.google.com with SMTP id i19-v6so13131934otk.10
        for <linux-btrfs@vger.kernel.org>; Thu, 07 Jun 2018 13:38:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAHac6AspsJ5iu+HECOr1ytVRjqB1JyVtqKVwxBF-H+t_18-Tnw@mail.gmail.com>
References: <CAHac6AspsJ5iu+HECOr1ytVRjqB1JyVtqKVwxBF-H+t_18-Tnw@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Thu, 7 Jun 2018 14:38:32 -0600
Message-ID: <CAJCQCtStcPseu+2KNYQN2C3wKkAenuQm59yiK_X8jOsfAA-Myg@mail.gmail.com>
Subject: Re: Bad superblock when mounting rw, ro mount works
To: Daniel Underwood <daniel.underwood13@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

So you zero'd the log? Why? You need to slow down and stop making
changes to your file system unless you hate your data and want to lose
it. The log is there to help protect your data, you don't zero the log
except under very specific situations, none of which appear to apply
to your situation.

'btrfs check' is safe, --repair may or may not be safe, you didn't say
what version of btrfs-progs you're using, I would consider 4.14.1 at
the oldest, it should be straightforward with any distro to get
something relatively new, maybe from a testing repo. Current is 4.16.

And good god don't use --init-extent-tree, that's a hammer. The
absolute safest way to troubleshoot Btrfs problems is using newer
kernel versions, even though 4.15 is not old, there are still tons of
bug fixes in every release.

Suspicious items from your dmesg:

[95639.492347] BTRFS error (device dm-11): pending csums is 44810240
[95639.492791] BTRFS error (device dm-11): cleaner transaction attach
returned -30
[95639.609171] BTRFS error (device dm-11): open_ctree failed
[96614.907963] BTRFS info (device dm-11): disk space caching is enabled
[96614.907965] BTRFS info (device dm-11): has skinny extents
[96615.207692] BTRFS info (device dm-11): bdev /dev/mapper/em3 errs:
wr 0, rd 0, flush 0, corrupt 0, gen 3
[96615.207702] BTRFS info (device dm-11): bdev /dev/mapper/em5 errs:
wr 164286, rd 3444262, flush 2110, corrupt 3, gen 181

OK so it's a multiple device Btrfs volume, and you have one device
missing a metric done of reads and writes and flushes, with a few
corruptions and generation mismatches. What's wrong with
/dev/mapper/em5? Have you done any troubleshooting to figure out what
that problem is? Because Btrfs can't fix it, and it can't make up for
it. That looks like the device was missing for a long time, and writes
were only going to em3. So what's the backstory?

Your very first task right now is to mount ro, and update your
backups. Don't do anything else until you've done that. It's a
testimony to Btrfs that this file system mounts at all, even ro, so
take advantage of this fact before you can't mount it anymore.



--
Chris Murphy
