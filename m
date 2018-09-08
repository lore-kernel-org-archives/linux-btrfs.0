Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:59650 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726841AbeIHVLP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 8 Sep 2018 17:11:15 -0400
Date: Sat, 8 Sep 2018 18:24:53 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Nathan Dehnel <ncdehnel@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: Transactional btrfs
Message-ID: <20180908162453.ewlksc5wf7w73ak2@angband.pl>
References: <CAEEhgEtgahZjLd-Uy-sFSc+36pNNUOa82sadJgBcbWKvPYsLiA@mail.gmail.com>
 <228f7179-6c5c-4412-2bb1-b0e73439b05a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <228f7179-6c5c-4412-2bb1-b0e73439b05a@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 06, 2018 at 06:08:33AM -0400, Austin S. Hemmelgarn wrote:
> On 2018-09-06 03:23, Nathan Dehnel wrote:
> > So I guess my question is, does btrfs support atomic writes across
> > multiple files? Or is anyone interested in such a feature?
> > 
> I'm fairly certain that it does not currently, but in theory it would not be
> hard to add.
> 
> Realistically, the only cases I can think of where cross-file atomic
> _writes_ would be of any benefit are database systems.
> 
> However, if this were extended to include rename, unlink, touch, and a
> handful of other VFS operations, then I can easily think of a few dozen use
> cases.  Package managers in particular would likely be very interested in
> being able to atomically rename a group of files as a single transaction, as
> it would make their job _much_ easier.

I wonder, what about:
sync; mount -o remount,commit=9999999,flushoncommit
eatmydata apt dist-upgrade
sync; mount -o remount,commit=30,noflushoncommit

Obviously, this gets fooled by fsyncs, and makes the transaction affects the
whole system (if you have unrelated writes they won't get committed until
the end of transaction).  Then there are nocow files, but you already made
the decision to disable most features of btrfs for them.

So unless something forces a commit, this should already work, giving
cross-file atomic writes, renames and so on.


Meow!
-- 
⢀⣴⠾⠻⢶⣦⠀ What Would Jesus Do, MUD/MMORPG edition:
⣾⠁⢰⠒⠀⣿⡁ • multiplay with an admin char to benefit your mortal [Mt3:16-17]
⢿⡄⠘⠷⠚⠋⠀ • abuse item cloning bugs [Mt14:17-20, Mt15:34-37]
⠈⠳⣄⠀⠀⠀⠀ • use glitches to walk on water [Mt14:25-26]
