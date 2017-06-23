Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:37421 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753902AbdFWQSP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Jun 2017 12:18:15 -0400
Date: Fri, 23 Jun 2017 09:17:50 -0700
From: Marc MERLIN <marc@merlins.org>
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Chris Murphy <lists@colorremedies.com>,
        Hugo Mills <hugo@carfax.org.uk>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <20170623161750.r7utffpsmyl5tcik@merlins.org>
References: <20170620154429.GC22987@merlins.org>
 <20170620231202.GB5303@merlins.org>
 <CAJCQCtQMWKJwWjeM4zEb-W7-tjsZyfCo37YyT2xYi0fNTEzcUQ@mail.gmail.com>
 <20170621034352.GE5303@merlins.org>
 <20170621151339.GK5303@merlins.org>
 <13856431-9ee5-c13e-f2a8-860394f9aae4@cn.fujitsu.com>
 <20170622025330.GX5303@merlins.org>
 <e86db7c4-4953-7706-347d-983079177f37@cn.fujitsu.com>
 <20170623040601.akpyyvh3dgry6nn5@merlins.org>
 <90711a7c-92ff-e043-6d81-6bdadbfdbc3a@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <90711a7c-92ff-e043-6d81-6bdadbfdbc3a@cn.fujitsu.com>
Subject: Re: How to fix errors that check --mode lomem finds, but --mode
 normal doesn't?
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 23, 2017 at 04:54:01PM +0800, Lu Fengqi wrote:
> On 2017年06月23日 12:06, Marc MERLIN wrote:
> > > Well, there is only the output from extent tree.
> > > 
> > > I was also expecting output from subvolue (11930) tree.
> > > 
> > > It could be done by
> > > # btrfs-debug-tree -t 11930 | grep -C 10 3886187384832
> > > 
> I apologize if this was not made clear.
> 
> > > But please pay attention that, this dump may contain filenames, feel free to
> > > mask the filenames.
> > There you go:
> > gargamel:~# btrfs-debug-tree /dev/mapper/dsh | grep -C 10 3886187384832
> 
> Could you dump file tree (11930) by the following command.
> # btrfs-debug-tree -t 11930 /dev/mapper/dsh | grep -C 10 3886187384832

Sure thing, there you go:
		extent data disk byte 5613689888768 nr 8192
		extent data offset 0 nr 8192 ram 8192
		extent compression 0 (none)
	item 201 key (375444 EXTENT_DATA 1851654144) itemoff 5577 itemsize 53
		generation 32961 type 1 (regular)
		extent data disk byte 4686293291008 nr 16384
		extent data offset 0 nr 16384 ram 16384
		extent compression 0 (none)
	item 202 key (375444 EXTENT_DATA 1851670528) itemoff 5524 itemsize 53
		generation 32382 type 1 (regular)
		extent data disk byte 3886187384832 nr 81920
		extent data offset 16384 nr 8192 ram 81920
		extent compression 0 (none)
	item 203 key (375444 EXTENT_DATA 1851678720) itemoff 5471 itemsize 53
		generation 33534 type 1 (regular)
		extent data disk byte 5540480962560 nr 8192
		extent data offset 0 nr 8192 ram 8192
		extent compression 0 (none)
	item 204 key (375444 EXTENT_DATA 1851686912) itemoff 5418 itemsize 53
		generation 32961 type 1 (regular)
		extent data disk byte 4686293307392 nr 16384
		extent data offset 8192 nr 8192 ram 16384
		extent compression 0 (none)
	item 205 key (375444 EXTENT_DATA 1851695104) itemoff 5365 itemsize 53
		generation 32382 type 1 (regular)
		extent data disk byte 3886187384832 nr 81920
		extent data offset 40960 nr 8192 ram 81920
		extent compression 0 (none)
	item 206 key (375444 EXTENT_DATA 1851703296) itemoff 5312 itemsize 53
		generation 32961 type 1 (regular)
		extent data disk byte 4686293323776 nr 8192
		extent data offset 0 nr 8192 ram 8192
		extent compression 0 (none)
	item 207 key (375444 EXTENT_DATA 1851711488) itemoff 5259 itemsize 53
		generation 32382 type 1 (regular)
		extent data disk byte 3886187384832 nr 81920
		extent data offset 57344 nr 8192 ram 81920
		extent compression 0 (none)
leaf 5715801047040 items 105 free space 8093 generation 36595 owner 11930
leaf 5715801047040 flags 0x1(WRITTEN) backref revision 1
fs uuid 85441c59-ad11-4b25-b1fe-974f9e4acede
chunk uuid ed705b7b-2fa6-43f6-a4a1-941c8463ee68
	item 0 key (375444 EXTENT_DATA 1851719680) itemoff 16230 itemsize 53
		generation 34868 type 1 (regular)
		extent data disk byte 5591266127872 nr 8192
		extent data offset 0 nr 8192 ram 8192
		extent compression 0 (none)
	item 1 key (375444 EXTENT_DATA 1851727872) itemoff 16177 itemsize 53
		generation 32382 type 1 (regular)
		extent data disk byte 3886187384832 nr 81920
		extent data offset 73728 nr 8192 ram 81920
		extent compression 0 (none)
	item 2 key (375444 EXTENT_DATA 1851736064) itemoff 16124 itemsize 53
		generation 31782 type 1 (regular)
		extent data disk byte 5922189430784 nr 106496
		extent data offset 81920 nr 8192 ram 106496
		extent compression 0 (none)
	item 3 key (375444 EXTENT_DATA 1851744256) itemoff 16071 itemsize 53
		generation 32382 type 1 (regular)
		extent data disk byte 3886187466752 nr 16384


Thanks for looking at this.
I have applied your patch and I'm still re-running check in lowmem. It takes about 24H so I'll
post the full results when it's done.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
