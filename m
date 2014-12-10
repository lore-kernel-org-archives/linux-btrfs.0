Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f44.google.com ([209.85.213.44]:62558 "EHLO
	mail-yh0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758051AbaLJULw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Dec 2014 15:11:52 -0500
Received: by mail-yh0-f44.google.com with SMTP id c41so1640097yho.17
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Dec 2014 12:11:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <pan$db978$7628430b$4f067ceb$13d468cb@cox.net>
References: <CAA7pwKNH-Cbd+_D+sCEJxxdervLC=_3_AzaywSE3mXi8MLydxw@mail.gmail.com>
	<20141122222606.GO8916@merlins.org>
	<CAA7pwKOSbdxaiN=_ERSQLnoPNBfO0cyzamuv=xsWtvpro-+JJg@mail.gmail.com>
	<20141123000503.GQ32735@carfax.org.uk>
	<20141123010742.GA16599@merlins.org>
	<pan$5df6$ab571fd5$d428faeb$f4fcc034@cox.net>
	<CAA7pwKOAvTNAprN+pebZ3Qow-U2SBjLP_XbVXcVKY4NeFS_qRQ@mail.gmail.com>
	<pan$1cbab$ed4a0087$b6b58a81$490b38ad@cox.net>
	<CAA7pwKNPV3PCLP3s_MzoMG2da6Rfsy9HM=b8o8u87QqDV5WB+w@mail.gmail.com>
	<CAA7pwKOtOeCL-40EjqmEZ=NR=7Nfz_1Kzx2X4O105ndKGJMkrA@mail.gmail.com>
	<54878A65.2080403@pobox.com>
	<54878D3E.8020809@pobox.com>
	<pan$db978$7628430b$4f067ceb$13d468cb@cox.net>
Date: Wed, 10 Dec 2014 21:11:52 +0100
Message-ID: <CAA7pwKNgZroCMa2A3vbF=aAuq9tVZSdeGc-WB1+Gcdt6_2AydQ@mail.gmail.com>
Subject: Re: Fixing Btrfs Filesystem Full Problems typo?
From: Patrik Lundquist <patrik.lundquist@gmail.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10 December 2014 at 13:47, Duncan <1i5t5.duncan@cox.net> wrote:
>
> The recursive btrfs defrag after deleting the saved ext* subvolume
> _should_ have split up any such > 1 GiB extents so balance could deal
> with them, but either it failed for some reason on at least one such
> file, or there's some other weird corner-case going on, very likely
> something else having to do with the conversion.

I've run defrag several times again and it doesn't do anything additional.


> Patrik, assuming no btrfs snapshots yet, can you do a du --all --block-
> size=1M | sort -n (or similar), then take a look at all results over 1024
> (1 GiB since the du specified 1 MiB blocks), and see if it's reasonable
> to move all those files out of the filesystem and back?

Good idea, but it's quite a lot of files. I'd rather start over.

But I've identified 46 files from Btrfs errors in syslog and will try
to move them to another disk. They're ranging from 41KiB to 6.6GiB in
size.

Is btrfs-debug-tree -e useful in finding problematic files?
