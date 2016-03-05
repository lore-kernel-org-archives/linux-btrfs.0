Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f176.google.com ([209.85.223.176]:33471 "EHLO
	mail-io0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724AbcCETeL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 5 Mar 2016 14:34:11 -0500
Received: by mail-io0-f176.google.com with SMTP id n190so95152967iof.0
        for <linux-btrfs@vger.kernel.org>; Sat, 05 Mar 2016 11:34:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20160305143934.GE1902@torres.zugschlus.de>
References: <20160227211450.GS26042@torres.zugschlus.de>
	<CAOE4rSyPvkzjKDVoQ-7U8ay5t7Pp2qeaCqh-tFg-etmgHGEOJQ@mail.gmail.com>
	<20160305143934.GE1902@torres.zugschlus.de>
Date: Sat, 5 Mar 2016 12:34:09 -0700
Message-ID: <CAJCQCtTw1+E=X1bbGgSB-fPHDtEPUO5amFUEs4fyPmTfK4QaGw@mail.gmail.com>
Subject: Re: Again, no space left on device while rebalancing and recipe
 doesnt work
From: Chris Murphy <lists@colorremedies.com>
To: Marc Haber <mh+linux-btrfs@zugschlus.de>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I can't tell what this btrfs-balance script is doing because not every
btrfs balance command is in the log. It may be doing something not
advisable or suboptimal or unexpected that along with some other bug
is causing this to happen

Metadata,DUP: Size:107.00GiB, Used:2.11GiB

I'd try to use -musage filter alone, in whatever increments work. So
try 0. Then 5. If 5 fails, try 2. Increment until size is not much
more than 2-3x used.

Something is happening with the usage of this file system that's out
of the ordinary. This is the first time I've seen such a large amount
of unused metadata allocation. And then for it not only fail to
balance, but for the allocation amount to increase is a first. So
understanding the usage is important to figuring out what's happening.
I'd file a bug and include as much information on how the fs got into
this state as possible. And also if possible make a btrfs-image using
the proper flags to blot out the filenames for privacy. And what
btrfs-progs tools were used to create this file system. Etc.

The alternative if this can't be fixed, is to recreate the filesystem
because there's no practical way yet to migrate so many snapshots to a
new file system.


Chris Murphy
