Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:35060 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422659Ab3CVRMR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Mar 2013 13:12:17 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 6967D9A0645
	for <linux-btrfs@vger.kernel.org>; Fri, 22 Mar 2013 11:12:17 -0600 (MDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
To: Samuel Just <sam.just@inktank.com>
From: Chris Mason <clmason@fusionio.com>
In-Reply-To: <CA+4uBUbyF-3yiBQ00xP4NHEX96CXa9HZo5-ZYdZ3Fjrfnm=Ssw@mail.gmail.com>
CC: Alexandre Oliva <oliva@gnu.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
References: <orhak8fm0u.fsf@livre.home> <or1ubaesrx.fsf@livre.home>
 <ord2utb4xx.fsf@livre.home>
 <20130321180614.30044.29961@localhost.localdomain>
 <20130321230621.30044.80640@localhost.localdomain>
 <orzjxw9f75.fsf@livre.home>
 <20130322120754.27874.14389@localhost.localdomain>
 <orobeba58l.fsf@livre.home>
 <20130322142659.27874.81283@localhost.localdomain>
 <CA+4uBUbyF-3yiBQ00xP4NHEX96CXa9HZo5-ZYdZ3Fjrfnm=Ssw@mail.gmail.com>
Message-ID: <20130322171214.27874.48118@localhost.localdomain>
Subject: Re: corruption of active mmapped files in btrfs snapshots
Date: Fri, 22 Mar 2013 13:12:14 -0400
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In this case, I think Alexandre is scanning for zeros in the file.   The
incomplete writes will definitely show that.

-chris

Quoting Samuel Just (2013-03-22 13:06:41)
> Incomplete writes for leveldb should just result in lost updates, not
> corruption.  Also, we do stop writes before the snapshot is initiated
> so there should be no in-progress writes to leveldb other than leveldb
> compaction (though that might be something to investigate).
> -Sam
> 
> On Fri, Mar 22, 2013 at 7:26 AM, Chris Mason <clmason@fusionio.com> wrote:
> > Quoting Alexandre Oliva (2013-03-22 10:17:30)
> >> On Mar 22, 2013, Chris Mason <clmason@fusionio.com> wrote:
> >>
> >> > Are you using compression in btrfs or just in leveldb?
> >>
> >> btrfs lzo compression.
> >
> > Perfect, I'll focus on that part of things.
> >
> >>
> >> > I'd like to take snapshots out of the picture for a minute.
> >>
> >> That's understandable, I guess, but I don't know that anyone has ever
> >> got the problem without snapshots.  I mean, even when the master copy of
> >> the database got corrupted, snapshots of the subvol containing it were
> >> being taken every now and again, because that's the way ceph works.
> >
> > Hopefully Sage can comment, but the basic idea is that if you snapshot a
> > database file the db must participate.  If it doesn't, it really is the
> > same effect as crashing the box.
> >
> > Something is definitely broken if we're corrupting the source files
> > (either with or without snapshots), but avoiding incomplete writes in
> > the snapshot files requires synchronization with the db.
> >
> > -chris
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
