Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f180.google.com ([209.85.223.180]:36500 "EHLO
	mail-io0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738AbcAYF6W (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Jan 2016 00:58:22 -0500
Received: by mail-io0-f180.google.com with SMTP id g73so144907442ioe.3
        for <linux-btrfs@vger.kernel.org>; Sun, 24 Jan 2016 21:58:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20160125032109.GI908@breitenfeld.lan>
References: <20160124175258.GD908@breitenfeld.lan>
	<CAJCQCtTFwz3YxaYJSnq3M7fQQ152=1ka_Y1ecXT=9LurPSaRrw@mail.gmail.com>
	<20160124205832.GE908@breitenfeld.lan>
	<CAJCQCtQfpnis+m0QqSJ28wHidNCm2tAt8UXZuwrPg6fdrLohNw@mail.gmail.com>
	<20160124211700.GF908@breitenfeld.lan>
	<CAJCQCtQjCgvHqfbuKF+E0xhEydu1SdwZ3uLyq+aDL=+Yrrkm4w@mail.gmail.com>
	<20160124221614.GH908@breitenfeld.lan>
	<CAJCQCtRtZ+LxwZ8e_5s3AEfJ-a7wU9_DLz=UBNiJyY190i0CXw@mail.gmail.com>
	<20160125032109.GI908@breitenfeld.lan>
Date: Sun, 24 Jan 2016 22:58:22 -0700
Message-ID: <CAJCQCtS4SuDgy8bu3SA4=foG6Z78G2ieR7pkq8QomB60S3CNuw@mail.gmail.com>
Subject: Re: Chicken-egg: uncorrectable checksum error prevents RAID1 rebalancing
From: Chris Murphy <lists@colorremedies.com>
To: Tom Hunt <tomdicksonhunt@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jan 24, 2016 at 8:21 PM, Tom Hunt <tomdicksonhunt@gmail.com> wrote:
> The only output from btrfs-debug-tree containing ORPHAN:
>
>         item 151 key (ORPHAN ORPHAN_ITEM 150415) itemoff 4904 itemsize 0
>                   orphan item
>         item 152 key (ORPHAN ORPHAN_ITEM 150416) itemoff 4904 itemsize 0
>                   orphan item
>         item 153 key (ORPHAN ORPHAN_ITEM 175228) itemoff 4904 itemsize 0
>                   orphan item
>         item 154 key (ORPHAN ORPHAN_ITEM 175229) itemoff 4904 itemsize 0
>                   orphan item
>
> Given the later talk about orphans, I don't think this is an orphan; the disks
> are new, and I know the checksum error issues came from running with bad RAM,
> which has since been replaced.
>
> The output referring to 515:
>
>         item 49 key (515 INODE_ITEM 0) itemoff 10851 itemsize 160
>                 inode generation 132 transid 132 size 262144 nbytes 4194304
>                 block group 0 mode 100600 links 1 uid 0 gid 0
>                 rdev 0 flags 0x1b
>         item 50 key (515 EXTENT_DATA 0) itemoff 10798 itemsize 53
>                 extent data disk byte 603428720640 nr 262144
>                 extent data offset 0 nr 262144 ram 262144
>                 extent compression 0

I'm kinda out of ideas. A full balance at least is an online process,
maybe it gets rid of the phantom missing inode reference. It'd be
interesting to see what 'btrfs check' shows. If you decide to try
--init-csum-tree, I'd first refresh a backup, and make current ro
snapshots of things you'd send/receive, should it become necessary to
create a new file system.

>
> Incidentally, btrfs-debug-tree produced about 1.5G of text output; I'm not sure
> whether that's normal for a 6TB volume with ~4TB used, or what.

Yeah, very loose estimate is a btrfs-debug-tree output to a file is
1/4 of the metadata size reported by 'fi usage/df' although it could
be much smaller if if you have a lot of small files with inline data
extents.



-- 
Chris Murphy
