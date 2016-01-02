Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:57307 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751584AbcABUjN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 2 Jan 2016 15:39:13 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
	by mailout.nyi.internal (Postfix) with ESMTP id B628E2039D
	for <linux-btrfs@vger.kernel.org>; Sat,  2 Jan 2016 15:39:12 -0500 (EST)
Message-Id: <1451767152.3023000.481211490.1B8EC687@webmail.messagingengine.com>
From: Rasmus Abrahamsen <btrfs@rasmusa.net>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Subject: Re: Add big device, remove small device, read-only
Date: Sat, 02 Jan 2016 21:39:12 +0100
In-Reply-To: <CAJCQCtQLrh5AM2eRp0g0UvAOedz3=Y8qm1XAi7PV7m26uZsR-Q@mail.gmail.com>
References: <9E462AAE-481A-4A0D-9918-FF56A73D6F6D@rasmusa.net>
 <CAJCQCtSCJ91FaJ20g-+TKMwGkXeQdEkn1yDf6w+H3=V_8_xshA@mail.gmail.com>
 <1451679613.2761176.480641362.3ADA17DB@webmail.messagingengine.com>
 <CAJCQCtTn1xZ3KLQoPqjDowu__f5AAAXHNye2vU4ceEb6VFK--w@mail.gmail.com>
 <1451764729.3016753.481194250.0BE48A69@webmail.messagingengine.com>
 <CAJCQCtSJp-p06VCrSaoeqAOFtnt=EfCMKfRF-DVkjpAiW9iv3A@mail.gmail.com>
 <CAJCQCtQLrh5AM2eRp0g0UvAOedz3=Y8qm1XAi7PV7m26uZsR-Q@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sounds like you think my best bet is to re-roll my filesystem instead of
attempt to repair it. Is that right?

I have snapshots which are based on each other as a backup of a remote
machine by date. By sending these snapshots to a new filesystem, will I
be able to have them still be incremental and save space?

On Sat, Jan 2, 2016, at 09:32 PM, Chris Murphy wrote:
> On Sat, Jan 2, 2016 at 1:15 PM, Chris Murphy <lists@colorremedies.com>
> wrote:
> > On Sat, Jan 2, 2016 at 12:58 PM, Rasmus Abrahamsen <btrfs@rasmusa.net> wrote:
> >> What do you recommend I do? Everything is redundant across disks.
> >> Perhaps I can disconnect the one you mentioned and delete missing.
> >
> > No, please stop trying new things like throwing spaghetti at a wall.
> > The file system is not healthy or it wouldn't behave the way it is. If
> > you have a current backup, and want to keep playing to see how bad
> > it'll get, then keep proceeding.
> >
> > But if you have any important data on this volume that you don't have
> > a current backup for, then you need to make as few changes as
> > possible. Don't delete devices. Don't run btrfsck. Don't scrub. Don't
> > balance. Just try to get it mounted first, and then btrfs send, rsync,
> > or cp the data you need off the volume onto a new volume.
> 
> That means try a normal mount with no mount options first. If that
> doesn't work then try:
> 
> -o recovery
> -o ro,recovery
> -o ro,recovery,degraded
> 
> If you can get it rw mounted, then you maybe can make ro snapshots
> that you can send/receive to a new Btrfs file system. Or rsync -a or
> cp -a to a new other file system.
> 
> If you can't get it rw mounted, and don't already have ro snapshots of
> the things you want, then you'll have to use rsync or cp.
> 
> 
> -- 
> Chris Murphy
