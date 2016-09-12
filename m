Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:55570 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758481AbcILMsI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Sep 2016 08:48:08 -0400
From: =?ISO-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Is stability a joke?
Date: Mon, 12 Sep 2016 14:48:02 +0200
Message-ID: <7968417.Q5EYAiftLn@vajra>
In-Reply-To: <13278435.QSGp0b77ZB@merkaba>
References: <57D51BF9.2010907@online.no> <13278435.QSGp0b77ZB@merkaba>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le dimanche 11 septembre 2016 12:23:23, vous avez écrit :
> First off: On my systems BTRFS definately runs too stable for a research 
> project. Actually: I have zero issues with stability of BTRFS on *any* of
> my  systems at the moment and in the last half year.

I have been using BTRFS for 3+ years on 10+ machines.

I have never lost any serious data.

My usual mount options are « noatime, autodefrag, compress=lzo » on mechanical 
HDs and « ssd, noatime, compress=lzo » on SSDs.

I usually use automated snapshotting, using SuSE’s excellent « snapper » tool, 
even though the distros I use are not SuSE, but Arch, Fedora, Mint and Ubuntu.

I use « chattr +C » and no snapshots on database dirs, VM dirs and the like.

In such conditions, BTRFS performs pretty well on all of my SSD machines. For 
years it has stayed OK - and the SSD wear reported by SMART seems normal.

On all my machines with mechanical HDs, the systems progressively slows down 
over months, to the point that it becomes hardly usable (i.e. 10 minutes 
booting…).

It is worth noting that even destroying all snapshots, performing manual 
defrags + rebalance doesn’t help. Once a given FS has become slow to death, it 
remains slow to death.

I’ve also experienced corruption of a dozen files with a power failures, that « 
btrfs check » could not fix. These files have remain broken since (with no 
further effect).

I also use a BTRFS RAID 1 on top of 2 bcache devices, works perfectly — and 
the cache SSD prevents the system from the slowdown effect…

My 2 cents.

-- 
Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E

