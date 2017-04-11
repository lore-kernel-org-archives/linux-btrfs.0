Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:37024 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752151AbdDKQPE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Apr 2017 12:15:04 -0400
Date: Tue, 11 Apr 2017 18:15:02 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: Marc Haber <mh+linux-btrfs@zugschlus.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs won't mount any more
Message-ID: <20170411161502.ol4tjl3agqnlerab@angband.pl>
References: <20170411071531.GK3699@torres.zugschlus.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20170411071531.GK3699@torres.zugschlus.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 11, 2017 at 09:15:31AM +0200, Marc Haber wrote:
> I have wrecked another btrfs file system, probably for good this time.
> 
> It's a 80 GB filesystem from 2015, in my secondary notebook, on an
> encrypted SSD. The btrfs holds the root filesystem and the rest of the
> system as well.
> 
> I have a cronjob that makes snapshots of the system directories daily,
> and of /home every ten minutes. A second cronjob cleans up old snapshots
> so that the number of snapshots present is about between 400 and 600.
> This is the key feature that made me decide for btrfs in the first
> place.
> 
> Last week (I was on kernel 4.10.8 with Debian unstable), I was forced to
> promote the secondary laptop to the primary one which resulted in
> serious work being done on the first time. Over time, the filesystem
> filled up without me noticing and was finally 100% full.

CoW and log-structured filesystems in general tend to take 100% full
conditions far worse than traditional filesystems, but it still should
result only in performance degradation and/or metadata-vs-data issues rather
than a fatal error.  So if this is the cause, you obviously hit a bug.
 
> I then cleaned up about four gigs by deleting a couple of redundant ISO
> images and some snapshots that were not due for regular deletion yet. I
> then started a btrfs balance / -d50, unfortunately without stopping the
> snapshot-making cronjob. This resulted in the notebook becoming
> unuseable for extended periods of time, without even being able to log
> in. After running for some 30 hours, the notebook ran out of battery
> (don't ask, stupid me).

Ouch, this is generally harmless unless your disk lies about barriers. 
Btrfs absolutely depends on them, and tends to suffer catastrophic
corruption if writes were reordered when they shouldn't.

Even in such a case, using an older root would help, although that
possibility is almost certainly gone now.

> After rebooting, the btrfs balance proceeded immediately after mounting
> the root fs. System unuseable again. After a day, I finally had a root
> shell and was able to issue a btrfs cancel /. Unfortunately, the system
> didn't care about that command and happily continued to balance. After
> some more 30 hours, I lost patience and resetted the system.

Mounting with -o skip_balance may help.

> To be able to keep control of the system and to monitor operations from
> remote, I installed a fresh copy of Debian unstable with the same 4.10.8
> kernel on an USB stick and booted the notebook from the stick. I brought
> up the system and tried to mount the btrfs. The mount process quickly
> went up to 100 % CPU usage and stayed that way until I went to bed last
> night. This morning, the machine had dropped off the network (couldn't
> ping the default gateway any more despite the network looked fine), and
> spewed kernel oopses of about 80 lines (too long to scroll back even)
> every few seconds.
> 
> I will try to tweak kernel.printk tonight so that I get my console back
> and see whether the oopses are also in journal, dmesg or syslog so that
> I can copypaste them. I also have a reasonably current backup of the
> filesystem so nuking it from orbit is an option, I would however hate
> losing my snapshots.
> 
> Is it worthwhile to save information about the borked filesystem, or
> does the btrfs community just dont care about a heavily snapshotted two
> years old filesystem?

Two years old is not much, the format nor its use hasn't changed noticeably
since then.  You run the very latest upstream stable kernel, with its almost
freshest version (4.10.9 was tagged Saturday).  400-600 snapshots is nothing
remarkable, it's the usual range.  The only thing differing from the most
typical usage is your snapshot frequency, and even that is nothing
frightening.

Thus, a failure like yours in mainstream use is certainly interesting.

However, I have a piece of advice for now: could you make a copy of the
filesystem?  80GB is _nothing_: it's way below the accuracy of du -h on a
modern HDD, and not a burden for a typical SSD.  Being able to investigate
it from a bigger machine would be convenient, and having a copy would let
you use dangerous rescue methods without any risk.  And debugging oopses on
a laptop with no working serial or netconsole sucks; if you have no other
machine at hand then running the victim kernel in qemu-kvm might offer a
poor-man's console.

For advice for your specific case, we can't do much without seeing the
actual error messages.

-- 
⢀⣴⠾⠻⢶⣦⠀ Meow!
⣾⠁⢠⠒⠀⣿⡁
⢿⡄⠘⠷⠚⠋⠀ Collisions shmolisions, let's see them find a collision or second
⠈⠳⣄⠀⠀⠀⠀ preimage for double rot13!
