Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:53265 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751711AbdCZTvf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 26 Mar 2017 15:51:35 -0400
Date: Sun, 26 Mar 2017 21:51:30 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: Roman Mamedov <rm@romanrm.net>
Cc: "J. Hart" <jfhart085@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: backing up a file server with many subvolumes
Message-ID: <20170326195130.srw6m6lezsjbco46@angband.pl>
References: <58D72EC4.9020101@gmail.com>
 <20170326141436.4ffffca9@natsu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20170326141436.4ffffca9@natsu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Mar 26, 2017 at 02:14:36PM +0500, Roman Mamedov wrote:
> You could have done time-based snapshots on the top level (for /backup/), say,
> every 6 hours, and keep those for e.g. a month. Then don't bother with any
> other kind of subvolumes/snapshots on the backup machine, and do backups from
> remote machines into their respective subdirectories using simple 'rsync'.
> 
> That's what a sensible scheme looks like IMO, as opposed to a Btrfs-induced
> exercise in futility that you have (there are subvolumes? must use them for
> everything, even the frigging /boot/; there is send/receive? absolutely must
> use it for backing up; etc.)

Using old boring rsync is actually a pretty good idea, with caveats.

I for one don't herd server farms, thus systems I manage tend to be special
snowflakes.  Some run modern btrfs, some are on ancient kernels, usually /
is on a mdraid with a traditional filesystem, I got a bunch of ARM SoCs at
home -- plus even an ARM hosted server at Scaleway.  Standardizing on rsync
lets me make all those snowflakes backup the same way.  Only on the
destination I make full use of btrfs features.

Another benefit of rsync is that I don't exactly trust that send from 3.13
to receive on 4.9 won't have a data loss bug, while rsync is extremely well
tested.

On the other hand, rsync is _slow_.  Mere stat() calls on a non-trivial
piece of spinning rust can take half on hour.  That's something that's fine
in a nightly, but what if you want to back important stuff every 3 hours? 
Especially if those are, say, Maildir mails -- many many files to stat,
almost all of them cold.  Here send/receive shines.

And did I say that's important stuff?  So you send/receive to one target
every 3 hours, and rsync nightly to another.

-- 
⢀⣴⠾⠻⢶⣦⠀ Meow!
⣾⠁⢠⠒⠀⣿⡁
⢿⡄⠘⠷⠚⠋⠀ Collisions shmolisions, let's see them find a collision or second
⠈⠳⣄⠀⠀⠀⠀ preimage for double rot13!
