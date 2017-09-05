Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:41692 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751159AbdIEOpp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Sep 2017 10:45:45 -0400
Date: Tue, 5 Sep 2017 07:45:25 -0700
From: Marc MERLIN <marc@merlins.org>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: quwenruo@cn.fujitsu.com, Lu Fengqi <lufq.fnst@cn.fujitsu.com>,
        Chris Mason <clm@fb.com>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>
Message-ID: <20170905144525.rzvncaxil2enxjwe@merlins.org>
References: <20170905010531.rfvun5isjwrb5ur5@merlins.org>
 <75b0ebd3-41ea-7f45-bec4-f7d9ec6efee1@gmx.com>
 <20170905025556.GA6392@merlins.org>
 <92e0486d-a7b5-01f8-5ef4-6773f8939bec@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <92e0486d-a7b5-01f8-5ef4-6773f8939bec@gmx.com>
Subject: Re: btrfs check --repair now runs in minutes instead of hours?
 aborting
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 05, 2017 at 04:05:04PM +0800, Qu Wenruo wrote:
> > gargamel:~# btrfs fi df /mnt/btrfs_pool1
> > Data, single: total.60TiB, used.54TiB
> > System, DUP: total2.00MiB, used=1.19MiB
> > Metadata, DUP: totalX.00GiB, used.69GiB
> 
> Wait for a minute.
> 
> Is that .69GiB means 706 MiB? Or my email client/GMX screwed up the format
> (again)?
> This output format must be changed, at least to 0.69 GiB, or 706 MiB.
 
Email client problem. I see control characters in what you quoted.

Let's try again
gargamel:~# btrfs fi df /mnt/btrfs_pool1
Data, single: total=10.66TiB, used=10.60TiB      => 10TB
System, DUP: total=64.00MiB, used=1.20MiB        => 1.2MB
Metadata, DUP: total=57.50GiB, used=12.76GiB     => 13GB
GlobalReserve, single: total=512.00MiB, used=0.00B  => 0

> You mean lowmem is actually FASTER than original mode?
> That's very surprising.
 
Correct, unless I add --repair and then original mode is 2x faster than
lowmem.

> Is there any special operation done for that btrfs?
> Like offline dedupe or tons of reflinks?

In this case, no.
Note that btrfs check used to take many hours overnight until I did a
git pull of btrfs progs and built the latest from TOT.

> BTW, how many subvolumes do you have in the fs?
 
gargamel:/mnt/btrfs_pool1# btrfs subvolume list . | wc -l
91

If I remove snapshots for btrfs send and historical 'backups':
gargamel:/mnt/btrfs_pool1# btrfs subvolume list . | grep -Ev '(hourly|daily|weekly|rw|ro)' | wc -l
5

> This looks like a bug. My first guess is related to number of
> subvolumes/reflinks, but I'm not sure since I don't have many real-world
> btrfs.
> 
> I'll take sometime to look into it.
> 
> Thanks for the very interesting report,

Thanks for having a look :)

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
