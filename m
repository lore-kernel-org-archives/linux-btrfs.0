Return-Path: <SRS0=GbvB=QE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B3F2C282C8
	for <linux-btrfs@archiver.kernel.org>; Mon, 28 Jan 2019 16:39:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 08A052082C
	for <linux-btrfs@archiver.kernel.org>; Mon, 28 Jan 2019 16:39:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389728AbfA1Qjr (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 28 Jan 2019 11:39:47 -0500
Received: from tartarus.angband.pl ([54.37.238.230]:35904 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389720AbfA1QYb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 28 Jan 2019 11:24:31 -0500
Received: from kilobyte by tartarus.angband.pl with local (Exim 4.89)
        (envelope-from <kilobyte@angband.pl>)
        id 1go9hz-0001jI-Km; Mon, 28 Jan 2019 17:24:27 +0100
Date:   Mon, 28 Jan 2019 17:24:27 +0100
From:   Adam Borowski <kilobyte@angband.pl>
To:     Supercilious Dude <supercilious.dude@gmail.com>
Cc:     Qu Wenruo <quwenruo.btrfs@gmx.com>,
        DanglingPointer <danglingpointerexception@gmail.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: RAID56 Warning on "multiple serious data-loss bugs"
Message-ID: <20190128162427.oztw55e6e3l5fpll@angband.pl>
References: <5d7f63b2-d340-7c3a-679b-26e97ac258a6@gmail.com>
 <59a60289-1130-27b4-960b-9014fc8d68e8@gmx.com>
 <CAGmvKk7yMOUJWbzro-=+DdzgMpo71vi7+QaCWu4LYcibBAzhrg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGmvKk7yMOUJWbzro-=+DdzgMpo71vi7+QaCWu4LYcibBAzhrg@mail.gmail.com>
X-Junkbait: aaron@angband.pl, zzyx@angband.pl
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: kilobyte@angband.pl
X-SA-Exim-Scanned: No (on tartarus.angband.pl); SAEximRunCond expanded to false
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Jan 28, 2019 at 03:23:28PM +0000, Supercilious Dude wrote:
> On Mon, 28 Jan 2019 at 01:18, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
> >
> > So for current upstream kernel, there should be no major problem despite
> > write hole.
> 
> 
> Can you please elaborate on the implications of the write-hole? Does
> it mean that the transaction currently in-flight might be lost but the
> filesystem is otherwise intact?

No, losing the in-flight transaction is normal operation of every modern
filesystem -- in fact, you _want_ the transaction to be lost instead of
partially torn.

The write hole means corruption of a random _old_ piece of data.

It can be fatal (ie, lead to data loss) if two errors happen together:
* the stripe is degraded
* there's unexpected crash/power loss

Every RAID implementation (not just btrfs) suffers from the write hole
unless some special, costly, precaution is being taken.  Those include
journaling, plug extents, varying-width stripes (ZFS: RAIDZ).  The two
former require effectively writing small writes twice, the latter degrades
small writes to RAID1 as disk capacity goes.

The write hole affects only writes that neighbour some old (ie, not from the
current transaction) data in the same stripe -- as long as everything in a
single stripe belongs to no more than one transaction, all is fine.  

> How does it interact with data and metadata being stored with a different
> profile (one with write hole and one without)?

If there's unrecoverable error due to write hole, you lose a single stripe
worth.  For data, this means a single piece of a file is beyond repair.  For
metadata, you lose a potentially large swatch of the filesystem -- and as
tree nodes close to the root get rewritten the most, a total filesystem loss
is pretty likely.  To make things worse, while data writes are mostly linear
(for small files, btrfs batches writes from the same transaction), metadata
is strewn all around, mixing pieces of different importance and different
age.  RAID5 (all implementations) is also very slow for random writes (such
as btrfs metadata), thus you really want RAID1 metadata both for safety and
performance.  Metadata being only around 1-2% of disk space, the only upside
of RAID5 (better use of capacity) doesn't really matter.

Ie: RAID1 is a clear winner for btrfs metadata; mixing profiles for data vs
metadata is safe.


Meow!
-- 
⢀⣴⠾⠻⢶⣦⠀
⣾⠁⢠⠒⠀⣿⡁ Remember, the S in "IoT" stands for Security, while P stands
⢿⡄⠘⠷⠚⠋⠀ for Privacy.
⠈⠳⣄⠀⠀⠀⠀
