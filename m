Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:59144 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751366AbdHGDfE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 6 Aug 2017 23:35:04 -0400
Date: Mon, 7 Aug 2017 05:35:00 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: Chris Murphy <lists@colorremedies.com>
Cc: Shyam Prasad N <nspmangalore@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Power down tests...
Message-ID: <20170807033500.i5hsyvtolyv23pax@angband.pl>
References: <CANT5p=rND=6FZYz6+x0924JHs3G8RH+G9GXqDfoS-ndtQUXuKQ@mail.gmail.com>
 <CAJCQCtTbWQvG2g-bXsQ05i5LXL36Pcrd_45YdRwOY95ygXaX8g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CAJCQCtTbWQvG2g-bXsQ05i5LXL36Pcrd_45YdRwOY95ygXaX8g@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Aug 06, 2017 at 08:15:45PM -0600, Chris Murphy wrote:
> On Thu, Aug 3, 2017 at 11:51 PM, Shyam Prasad N <nspmangalore@gmail.com> wrote:
> > We're running a couple of experiments on our servers with btrfs
> > (kernel version 4.4).
> > And we're running some abrupt power-off tests for a couple of scenarios:
> >
> > 1. We have a filesystem on top of two different btrfs filesystems
> > (distributed across N disks). i.e. Our filesystem lays out data and
> > metadata on top of these two filesystems.
> 
> This is astronomically more complicated than the already complicated
> scenario with one file system on a single normal partition of a well
> behaved (non-lying) single drive.
> 
> You have multiple devices, so any one or all of them could drop data
> during the power failure and in different amounts. In the best case
> scenario, at next mount the supers are checked on all the devices, and
> the lowest common denominator generation is found, and therefore the
> lowest common denominator root tree. No matter what it means some data
> is going to be lost.

That's exactly why we have CoW.  Unless at least one of the disks lies,
there's no way for data from a fully committed transaction to be lost.
Any writes after that are _supposed_ to be lost.

Reordering writes between disks is no different from reordering writes on a
single disk.  Even more so with NVMe where you have multiple parallel writes
on the same device, with multiple command queues.  You know the transaction
has hit the, uhm, platters, only once every device says so, and that's when
you can start writing the new superblock.
> 
> > The issue that we're facing is that a few files have been zero-sized.
> 
> I can't tell you if that's a bug or not because I'm not sure how your
> software creates these 16M backing files, if they're fallocated or
> touched or what. It's plausible they're created as zero length files,
> and the file system successful creates them, and then data is written
> to them, but before there is either committed metadata or an updated
> super pointing to the new root tree you get a power failure. And in
> that case, I expect a zero length file or maybe some partial amount of
> data is there.

It's the so-called O_PONIES issue.  No filesystem can know whether you want
files written immediately (abysmal performance) or held in cache until later
(sacrificing durability).  The only portable interface to do so is
f{,data}sync: any write that hasn't been synced cannot be relied upon.
Some traditional filesystems have implicitly synced things, but all such
details are filesystem specific.

Btrfs in particular has -o flushoncommit, which instead of a fsync after
every single write gathers writes from the last 30 seconds and flushes them
as one transaction.

More generic interfaces have been proposed but none has been implemented
yet.  Heck, I'm playing with one such idea myself, although I'm not sure if
I know enough to ensure the semantics I have in mind.

> > As a result, there is either a data-loss, or inconsistency in the
> > stacked filesystem's metadata.
> 
> Sounds expected for any file system, but chances are there's more
> missing with a CoW file system since by nature it rolls back to the
> most recent sane checkpoint for the fs metadata without any regard to
> what data is lost to make that happen. The goal is to not lose the
> file system in such a case, as some amount of data is always going to
> happen

All it takes is to _somehow_ tell the filesystem you demand the same
guarantees for data as it already provides for metadata.  And a CoW
or log-based filesystem can actually deliver such a demand.

> and why power losses need to be avoided (UPS's and such).

An UPS can't protect you from a kernel crash, a motherboard running out of
smoke, a stick of memory going bad or unseated, power supply deciding it
wants a break from delivering the juice (for redundant power supplies, the
thingy mediating power will do so), etc, etc.  There's no way around crash
tolerance.

> The
> fact that you have a file system on top of a file system makes it more
> fragile because the 2nd file system's metadata *IS* data as far as the
> 1st file system is concerned. And that data is considered expendable.

Only because by default the underlying filesystem has been taught to
consider it expendable.


Meow!
-- 
⢀⣴⠾⠻⢶⣦⠀ What Would Jesus Do, MUD/MMORPG edition:
⣾⠁⢰⠒⠀⣿⡁ • multiplay with an admin char to benefit your mortal
⢿⡄⠘⠷⠚⠋⠀ • abuse item cloning bugs (the five fishes + two breads affair)
⠈⠳⣄⠀⠀⠀⠀ • use glitches to walk on water
