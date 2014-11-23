Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:37800 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbaKWPMz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 23 Nov 2014 10:12:55 -0500
Received: by mail-wg0-f52.google.com with SMTP id a1so10237360wgh.11
        for <linux-btrfs@vger.kernel.org>; Sun, 23 Nov 2014 07:12:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <pan$5df6$ab571fd5$d428faeb$f4fcc034@cox.net>
References: <CAA7pwKNH-Cbd+_D+sCEJxxdervLC=_3_AzaywSE3mXi8MLydxw@mail.gmail.com>
	<20141122222606.GO8916@merlins.org>
	<CAA7pwKOSbdxaiN=_ERSQLnoPNBfO0cyzamuv=xsWtvpro-+JJg@mail.gmail.com>
	<20141123000503.GQ32735@carfax.org.uk>
	<20141123010742.GA16599@merlins.org>
	<pan$5df6$ab571fd5$d428faeb$f4fcc034@cox.net>
Date: Sun, 23 Nov 2014 16:12:54 +0100
Message-ID: <CAA7pwKOAvTNAprN+pebZ3Qow-U2SBjLP_XbVXcVKY4NeFS_qRQ@mail.gmail.com>
Subject: Re: Fixing Btrfs Filesystem Full Problems typo?
From: Patrik Lundquist <patrik.lundquist@gmail.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 23 November 2014 at 08:52, Duncan <1i5t5.duncan@cox.net> wrote:
> [a whole lot]

Thanks for the long post, Duncan.

My venture into the finer details of balance began with converting an
ext4 fs to btrfs and after an inital defrag having a full balance fail
with about a third to go.

Consecutive full balances further reduced the number of chunks and got
me closer to finish without the infamous ENOSPC. After 3-4 full
balance runs it failed with less than 8% to go.

The balance run now finishes without errors with usage=99 and I think
I'll leave it at that. No RAID yet but will convert to RAID1.

Is it correct that there is no reason to ever do a 100% balance as
routine maintenance? I mean if you really need that last 1% space you
actually need a disk upgrade instead.

How about running a monthly maintenance job that uses bytes_used and
dev_item.bytes_used from btrfs-show-super to approximate the balance
need?

(dev_item.bytes_used - bytes_used) / bytes_used == extra device space used

The extra device space used after my balance usage=99 is 0,15%. It was
7,0% before I began tinkering with usage and ran into ENOSPC and I
think it is safe to assume that it was a lot more right after the fs
conversion.

So lets iterate a balance run which begins with usage=0 and increases
in steps of 5 or 10 and stops at 90 or 99 or when the extra device
space used is less than 1%.

Does it make sense?
