Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f171.google.com ([209.85.223.171]:35606 "EHLO
	mail-io0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754346AbcAXWpt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 24 Jan 2016 17:45:49 -0500
Received: by mail-io0-f171.google.com with SMTP id 77so135056136ioc.2
        for <linux-btrfs@vger.kernel.org>; Sun, 24 Jan 2016 14:45:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20160124221614.GH908@breitenfeld.lan>
References: <20160124175258.GD908@breitenfeld.lan>
	<CAJCQCtTFwz3YxaYJSnq3M7fQQ152=1ka_Y1ecXT=9LurPSaRrw@mail.gmail.com>
	<20160124205832.GE908@breitenfeld.lan>
	<CAJCQCtQfpnis+m0QqSJ28wHidNCm2tAt8UXZuwrPg6fdrLohNw@mail.gmail.com>
	<20160124211700.GF908@breitenfeld.lan>
	<CAJCQCtQjCgvHqfbuKF+E0xhEydu1SdwZ3uLyq+aDL=+Yrrkm4w@mail.gmail.com>
	<20160124221614.GH908@breitenfeld.lan>
Date: Sun, 24 Jan 2016 15:45:49 -0700
Message-ID: <CAJCQCtRtZ+LxwZ8e_5s3AEfJ-a7wU9_DLz=UBNiJyY190i0CXw@mail.gmail.com>
Subject: Re: Chicken-egg: uncorrectable checksum error prevents RAID1 rebalancing
From: Chris Murphy <lists@colorremedies.com>
To: Tom Hunt <tomdicksonhunt@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jan 24, 2016 at 3:16 PM, Tom Hunt <tomdicksonhunt@gmail.com> wrote:
> I get "currently mounted, aborting".
>
> If I must bring down the machine over this, I can, but I'd prefer not to.

Now is a good time to refresh its backup, while it's online. It's also
a good idea to maintain readonly snapshots of each subvolume you want
to keep in case you need to depend on using btrfs send/receive to move
the data to a new file system, since only ro snapshots can be used for
send/receive.

Maybe it's an orphaned item. I don't know much about those, whether
btrfs check finds or removes them. But you can safely use
btrfs-debug-tree while the fs is mounted.

btrfs-debug-tree <dev> | grep -A3 -B3 ORPHAN

That'd find object type ORPHAN and item type ORPHAN_ITEM. Again, no
idea what to do about it if either are found, and matches inode 515.
You could also do a search using

btrfs-debug-tree <dev> | grep -A3 -B3 "(515 "

and see if that reveals anything.

While the fs has to be umounted for this, the --init-csum-tree option
for btrfs check will obliterate the current csum tree (and all file
csums) and then compute new csums for everything. That might fix it,
at least if it's a stuck orphan item then this ought to give it a
valid csum so you can proceed with conversion.



-- 
Chris Murphy
