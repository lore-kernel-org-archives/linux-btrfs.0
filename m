Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from eastrmfepi101.cox.net ([68.230.241.197]:52272 "EHLO
	eastrmfepi101.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030283AbaGRNOM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Jul 2014 09:14:12 -0400
Received: from eastrmimpo109 ([68.230.241.222]) by eastrmfepo203.cox.net
          (InterMail vM.8.01.05.15 201-2260-151-145-20131218) with ESMTP
          id <20140718123424.HVJ2658.eastrmfepo203.cox.net@eastrmimpo109>
          for <linux-btrfs@vger.kernel.org>;
          Fri, 18 Jul 2014 08:34:24 -0400
Date: Fri, 18 Jul 2014 05:34:22 -0700
From: Duncan <1i5t5.duncan@cox.net>
To: Roman Mamedov <rm@romanrm.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Questions on incremental backups
Message-ID: <20140718053422.78784982@ws>
In-Reply-To: <TmvW1o01t4NXQGV01mvYsU>
References: <1405627978.2630.39.camel@s-Air>
	<e1b3b459-ea44-4272-9320-4cb5218b3966@email.android.com>
	<pan$b430d$ca43159e$977364a9$ed50906b@cox.net>
	<TmvW1o01t4NXQGV01mvYsU>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 18 Jul 2014 16:55:26 +0600
Roman Mamedov <rm@romanrm.net> wrote:

> On Fri, 18 Jul 2014 10:45:37 +0000 (UTC)
> Duncan <1i5t5.duncan@cox.net> wrote:
> 
> > Russell Coker posted on Fri, 18 Jul 2014 14:35:20 +1000 as
> > excerpted:
> > 
> > > Daily snapshots work welk with kernel 3.14 and above (I had
> > > problems with 3.13 and previous). I have snapshots every 15 mins
> > > on some subvols.
> > > 
> > > Very large numbers of snapshots can cause performance problems. I
> > > suggest keeping below 1000 snapshots at this time.
> > 
> > The other caveat with btrfs snapshots is how they deal with NOCOW
> > files, the usual workaround recommended for large (Gig-ish-plus)
> > internal- rewrite-pattern files such as databases and VM images.
> 
> And "how" do they deal with them? To the best of my knowledge there
> is no "caveat" whatsoever, NOCOW and snapshots interact perfectly,
> exactly as it should be (snapshotted and then changed bits get
> COW'ed, but only once).

Yes, but the fact that NOCOW files must never-the-less be COWed anyway
on the first write to a block after a snapshot isn't exactly intuitive
to many admins, and even to many list regulars until relatively
recently.

For some time the recommendation for active large database files and
VM images (the ones I mentioned) was to make them NOCOW in ordered to
avoid extreme fragmentation, and people were still reporting extreme
fragmentation and the related performance issues even when the files
were properly NOCOWed at creation. Turned out the reason was that they
had scripted auto-snapshotting enabled, sometimes snapshotting the
files as often as once a minute!  With an active VM writing data more
or less randomly to its image equally often, NOCOW lost its
effectiveness as the snapshotting was forcing COW writes most of the
time anyway!

In the context of frequent snapshots, NOCOW is in practice broken
and doesn't do what the label would indicate, thus the caveat.

Effectively, admins can choose NOCOW XOR frequent-snapshotting, altho
the fact that snapshots stop at subvolume borders can be used as a
partial workaround, by putting NOCOW files on a dedicated partition and
not snapshotting it, exactly as I mentioned.

-- 
Duncan - No HTML messages please, as they are filtered as spam.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman
