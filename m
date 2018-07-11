Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:34242 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726829AbeGKRTW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Jul 2018 13:19:22 -0400
Date: Wed, 11 Jul 2018 10:14:02 -0700
From: Marc MERLIN <marc@merlins.org>
To: Chris Murphy <lists@colorremedies.com>
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>, dsterba@suse.cz,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>, Su Yue <Damenly_Su@gmx.com>,
        Su Yue <suy.fnst@cn.fujitsu.com>
Subject: Re: btrfs check mode normal still hard crash-hanging systems
Message-ID: <20180711171402.GC1969@merlins.org>
References: <20180710180915.onnxuak7vb7uywyn@merlins.org> <CAJCQCtRQdg56Hxk=U2JMXbE35Jj_Q5Ock_gn43jWxci4Nbs5UA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJCQCtRQdg56Hxk=U2JMXbE35Jj_Q5Ock_gn43jWxci4Nbs5UA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 11, 2018 at 11:09:56AM -0600, Chris Murphy wrote:
> On Tue, Jul 10, 2018 at 12:09 PM, Marc MERLIN <marc@merlins.org> wrote:
> > Thanks to Su and Qu, I was able to get my filesystem to a point that
> > it's mountable.
> > I then deleted loads of snapshots and I'm down to 26.
> >
> > IT now looks like this:
> > gargamel:~# btrfs fi show /mnt/mnt
> > Label: 'dshelf2'  uuid: 0f1a0c9f-4e54-4fa7-8736-fd50818ff73d
> >         Total devices 1 FS bytes used 12.30TiB
> >         devid    1 size 14.55TiB used 13.81TiB path /dev/mapper/dshelf2
> >
> > gargamel:~# btrfs fi df /mnt/mnt
> > Data, single: total=13.57TiB, used=12.19TiB
> > System, DUP: total=32.00MiB, used=1.55MiB
> > Metadata, DUP: total=124.50GiB, used=115.62GiB
> > Metadata, single: total=216.00MiB, used=0.00B
> > GlobalReserve, single: total=512.00MiB, used=0.00B
> >
> >
> > Problems
> > 1) btrfs check --repair _still_ takes all 32GB of RAM and crashes the
> > server, despite my deleting lots of snapshots.
> > Is it because I have too many files then?
> 
> I think originally needs most of metdata in memory.
> 
> I'm not understanding why btrfs check won't use swap like at least
> xfs_repair and pretty sure e2fsck will as well.
> 
> Using 128G swap on nvme with original check is still gonna be faster
> than lowmem mode.

Yeah, that's been also a concern/question of mine all these years, even if
Su isn't working on that code, and likely is the wrong person to ask.
Personally, my take is that if btrfs wants to be taken seriously, at the
very least its fsck tool should not hard crash a system you run it on.
(and it really does the worst kind of hard crash I've ever seen, OOM can't
trigger fast enough, linux doesn't panic, so it can't self reboot either, 
it just hard dies and hangs)

Maybe David knows?

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
