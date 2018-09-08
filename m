Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:48124 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727802AbeIICPj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 8 Sep 2018 22:15:39 -0400
Date: Sat, 8 Sep 2018 23:28:26 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: Martin Raiber <martin@urbackup.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Transactional btrfs
Message-ID: <20180908212826.zvzcr6qkovcegjqz@angband.pl>
References: <CAEEhgEtgahZjLd-Uy-sFSc+36pNNUOa82sadJgBcbWKvPYsLiA@mail.gmail.com>
 <228f7179-6c5c-4412-2bb1-b0e73439b05a@gmail.com>
 <20180908162453.ewlksc5wf7w73ak2@angband.pl>
 <01020165baeef6ff-eca39c84-99b6-4a19-8e94-f5449540fed3-000000@eu-west-1.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <01020165baeef6ff-eca39c84-99b6-4a19-8e94-f5449540fed3-000000@eu-west-1.amazonses.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Sep 08, 2018 at 08:45:47PM +0000, Martin Raiber wrote:
> Am 08.09.2018 um 18:24 schrieb Adam Borowski:
> > On Thu, Sep 06, 2018 at 06:08:33AM -0400, Austin S. Hemmelgarn wrote:
> >> On 2018-09-06 03:23, Nathan Dehnel wrote:
> >>> So I guess my question is, does btrfs support atomic writes across
> >>> multiple files? Or is anyone interested in such a feature?
> >>>
> >> I'm fairly certain that it does not currently, but in theory it would not be
> >> hard to add.

> >> However, if this were extended to include rename, unlink, touch, and a
> >> handful of other VFS operations, then I can easily think of a few dozen use
> >> cases.  Package managers in particular would likely be very interested in
> >> being able to atomically rename a group of files as a single transaction, as
> >> it would make their job _much_ easier.

> > I wonder, what about:
> > sync; mount -o remount,commit=9999999,flushoncommit
> > eatmydata apt dist-upgrade
> > sync; mount -o remount,commit=30,noflushoncommit
> >
> > Obviously, this gets fooled by fsyncs, and makes the transaction affects the
> > whole system (if you have unrelated writes they won't get committed until
> > the end of transaction).  Then there are nocow files, but you already made
> > the decision to disable most features of btrfs for them.

> Now combine this with snapshot root, then on success rename exchange to
> root and you are there.

No need: no unsuccessful transactions ever get written to the disk.
(Not counting unreachable stuff.)

> Btrfs had in the past TRANS_START and TRANS_END ioctls (for ceph, I
> think), but no rollback (and therefore no error handling incl. ENOSPC).
> 
> If you want to look at a working file system transaction mechanism, you
> should look at transactional NTFS (TxF). They are writing they are
> deprecating it, so it's perhaps not very widely used. Windows uses it
> for updates, I think.

You're talking about multiple simultaneous transactions, they have a massive
complexity cost.  And btrfs is already ridiculously complex.  I don't really
see a good way to tie this with the POSIX API without some serious
rethinking.

dpkg can already recover from a properly returned error (although not as
nicely as a full rollback); what is fatal for it is having its status
database corrupted/out of sync.  That's why it does a multiple fsync dance
and keeps fully rewriting its files over and over and over.

Atomic operations are pretty useful even without a rollback: you still need
to be able to handle failure, but not a crash.

> Specifically for btrfs, the problem would be that it really needs to
> support multiple simultaneous writers, otherwise one transaction can
> block the whole system.

My dirty hack above doesn't suffer from such a block: it only suffers from
compromising durability of concurrent writers.  During that userspace
transaction, there are no commits until it finishes; this means that if
there's unrelated activity it may suffer from losing writes that were done
between transaction start and crash.


Meow!
-- 
⢀⣴⠾⠻⢶⣦⠀ What Would Jesus Do, MUD/MMORPG edition:
⣾⠁⢰⠒⠀⣿⡁ • multiplay with an admin char to benefit your mortal [Mt3:16-17]
⢿⡄⠘⠷⠚⠋⠀ • abuse item cloning bugs [Mt14:17-20, Mt15:34-37]
⠈⠳⣄⠀⠀⠀⠀ • use glitches to walk on water [Mt14:25-26]
