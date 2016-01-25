Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f169.google.com ([209.85.214.169]:33247 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754693AbcAYDVN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 24 Jan 2016 22:21:13 -0500
Received: by mail-ob0-f169.google.com with SMTP id is5so105991803obc.0
        for <linux-btrfs@vger.kernel.org>; Sun, 24 Jan 2016 19:21:12 -0800 (PST)
Date: Sun, 24 Jan 2016 20:21:09 -0700
From: Tom Hunt <tomdicksonhunt@gmail.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Chicken-egg: uncorrectable checksum error prevents RAID1
 rebalancing
Message-ID: <20160125032109.GI908@breitenfeld.lan>
References: <20160124175258.GD908@breitenfeld.lan>
 <CAJCQCtTFwz3YxaYJSnq3M7fQQ152=1ka_Y1ecXT=9LurPSaRrw@mail.gmail.com>
 <20160124205832.GE908@breitenfeld.lan>
 <CAJCQCtQfpnis+m0QqSJ28wHidNCm2tAt8UXZuwrPg6fdrLohNw@mail.gmail.com>
 <20160124211700.GF908@breitenfeld.lan>
 <CAJCQCtQjCgvHqfbuKF+E0xhEydu1SdwZ3uLyq+aDL=+Yrrkm4w@mail.gmail.com>
 <20160124221614.GH908@breitenfeld.lan>
 <CAJCQCtRtZ+LxwZ8e_5s3AEfJ-a7wU9_DLz=UBNiJyY190i0CXw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJCQCtRtZ+LxwZ8e_5s3AEfJ-a7wU9_DLz=UBNiJyY190i0CXw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The only output from btrfs-debug-tree containing ORPHAN:

        item 151 key (ORPHAN ORPHAN_ITEM 150415) itemoff 4904 itemsize 0
                  orphan item
        item 152 key (ORPHAN ORPHAN_ITEM 150416) itemoff 4904 itemsize 0
                  orphan item
        item 153 key (ORPHAN ORPHAN_ITEM 175228) itemoff 4904 itemsize 0
                  orphan item
        item 154 key (ORPHAN ORPHAN_ITEM 175229) itemoff 4904 itemsize 0
                  orphan item

Given the later talk about orphans, I don't think this is an orphan; the disks
are new, and I know the checksum error issues came from running with bad RAM,
which has since been replaced.

The output referring to 515:

        item 49 key (515 INODE_ITEM 0) itemoff 10851 itemsize 160
                inode generation 132 transid 132 size 262144 nbytes 4194304
                block group 0 mode 100600 links 1 uid 0 gid 0
                rdev 0 flags 0x1b
        item 50 key (515 EXTENT_DATA 0) itemoff 10798 itemsize 53
                extent data disk byte 603428720640 nr 262144
                extent data offset 0 nr 262144 ram 262144
                extent compression 0

Incidentally, btrfs-debug-tree produced about 1.5G of text output; I'm not sure
whether that's normal for a 6TB volume with ~4TB used, or what.

On Sun, Jan 24, 2016 at 03:45:49PM -0700, Chris Murphy wrote:
> On Sun, Jan 24, 2016 at 3:16 PM, Tom Hunt <tomdicksonhunt@gmail.com> wrote:
> > I get "currently mounted, aborting".
> >
> > If I must bring down the machine over this, I can, but I'd prefer not to.
> 
> Now is a good time to refresh its backup, while it's online. It's also
> a good idea to maintain readonly snapshots of each subvolume you want
> to keep in case you need to depend on using btrfs send/receive to move
> the data to a new file system, since only ro snapshots can be used for
> send/receive.
> 
> Maybe it's an orphaned item. I don't know much about those, whether
> btrfs check finds or removes them. But you can safely use
> btrfs-debug-tree while the fs is mounted.
> 
> btrfs-debug-tree <dev> | grep -A3 -B3 ORPHAN
> 
> That'd find object type ORPHAN and item type ORPHAN_ITEM. Again, no
> idea what to do about it if either are found, and matches inode 515.
> You could also do a search using
> 
> btrfs-debug-tree <dev> | grep -A3 -B3 "(515 "
> 
> and see if that reveals anything.
> 
> While the fs has to be umounted for this, the --init-csum-tree option
> for btrfs check will obliterate the current csum tree (and all file
> csums) and then compute new csums for everything. That might fix it,
> at least if it's a stuck orphan item then this ought to give it a
> valid csum so you can proceed with conversion.
> 
> 
> 
> -- 
> Chris Murphy

-- 
Tom Hunt
