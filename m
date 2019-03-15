Return-Path: <SRS0=BvJc=RS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 906B0C43381
	for <linux-btrfs@archiver.kernel.org>; Fri, 15 Mar 2019 19:00:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B3132064A
	for <linux-btrfs@archiver.kernel.org>; Fri, 15 Mar 2019 19:00:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726689AbfCOTAH convert rfc822-to-8bit (ORCPT
        <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 15 Mar 2019 15:00:07 -0400
Received: from james.kirk.hungrycats.org ([174.142.39.145]:46484 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725922AbfCOTAH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Mar 2019 15:00:07 -0400
Received: by james.kirk.hungrycats.org (Postfix, from userid 1002)
        id 4FE45263BED; Fri, 15 Mar 2019 14:59:46 -0400 (EDT)
Date:   Fri, 15 Mar 2019 14:59:46 -0400
From:   Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To:     Jakub =?iso-8859-1?Q?Hus=E1k?= <jakub@husak.pro>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: Balancing raid5 after adding another disk does not move/use any
 data on it
Message-ID: <20190315185946.GK9995@hungrycats.org>
References: <7a713010-5db6-2627-2593-8e13092868b1@husak.pro>
 <20190315180123.GJ9995@hungrycats.org>
 <bf7b6c3e-8873-8638-0837-2f95ce935ac7@husak.pro>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <bf7b6c3e-8873-8638-0837-2f95ce935ac7@husak.pro>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Mar 15, 2019 at 07:42:21PM +0100, Jakub Husák wrote:
> Thanks for explanation! actually when I moved forward with the rebalancing
> the fourth disk started to receive some data.
> 
> BTW, I was hoping some filter like '-dstripes=1..3' existed and it is!
> Wouldn't it deserve some documentation? :)

It has some, from the man page for btrfs-balance:

       stripes=<range>
           Balance only block groups which have the given number of stripes. The parameter is a range specified as start..end.
           Makes sense for block group profiles that utilize striping, ie. RAID0/10/5/6. The range minimum and maximum are
           inclusive.

There are probably some wikis that could benefit from a sentence or
two explaining when you'd use this option.  Or a table of which RAID
profiles must be balanced after a device add (always raid0, raid5,
raid6, sometimes raid1 and raid10) and which don't (never single, dup,
sometimes raid1 and raid10).

> Also thanks to Noah Massey for caring!
> 
> Cheers
> 
> 
> On 15. 03. 19 19:01, Zygo Blaxell wrote:
> > On Wed, Mar 13, 2019 at 11:11:02PM +0100, Jakub Husák wrote:
> > > Sorry, fighting with this technology called "email" :)
> > > 
> > > 
> > > Hopefully better wrapped outputs:
> > > 
> > > On 13. 03. 19 22:58, Jakub Husák wrote:
> > > 
> > > 
> > > > Hi,
> > > > 
> > > > I added another disk to my 3-disk raid5 and ran a balance command. After
> > > > few hours I looked to output of `fi usage` to see that no data are being
> > > > used on the new disk. I got the same result even when balancing my raid5
> > > > data or metadata.
> > > > 
> > > > Next I tried to convert my raid5 metadata to raid1 (a good idea anyway)
> > > > and the new disk started to fill immediately (even though it received
> > > > the whole amount of metadata with replicas being spread among the other
> > > > drives, instead of being really "balanced". I know why this happened, I
> > > > don't like it but I can live with it, let's not go off topic here :)).
> > > > 
> > > > Now my usage output looks like this:
> > > > 
> > > # btrfs filesystem usage   /mnt/data1
> > > WARNING: RAID56 detected, not implemented
> > > Overall:
> > >      Device size:          10.91TiB
> > >      Device allocated:         316.12GiB
> > >      Device unallocated:          10.61TiB
> > >      Device missing:             0.00B
> > >      Used:              58.86GiB
> > >      Free (estimated):             0.00B    (min: 8.00EiB)
> > >      Data ratio:                  0.00
> > >      Metadata ratio:              2.00
> > >      Global reserve:         512.00MiB    (used: 0.00B)
> > > 
> > > Data,RAID5: Size:4.59TiB, Used:4.06TiB
> > >     /dev/mapper/crypt-sdb       2.29TiB
> > >     /dev/mapper/crypt-sdc       2.29TiB
> > >     /dev/mapper/crypt-sde       2.29TiB
> > > 
> > > Metadata,RAID1: Size:158.00GiB, Used:29.43GiB
> > >     /dev/mapper/crypt-sdb      53.00GiB
> > >     /dev/mapper/crypt-sdc      53.00GiB
> > >     /dev/mapper/crypt-sdd     158.00GiB
> > >     /dev/mapper/crypt-sde      52.00GiB
> > > 
> > > System,RAID1: Size:64.00MiB, Used:528.00KiB
> > >     /dev/mapper/crypt-sdc      32.00MiB
> > >     /dev/mapper/crypt-sdd      64.00MiB
> > >     /dev/mapper/crypt-sde      32.00MiB
> > > 
> > > Unallocated:
> > >     /dev/mapper/crypt-sdb     393.04GiB
> > >     /dev/mapper/crypt-sdc     393.01GiB
> > >     /dev/mapper/crypt-sdd       2.57TiB
> > >     /dev/mapper/crypt-sde     394.01GiB
> > > 
> > > > I'm now running `fi balance -dusage=10` (and rising the usage limit). I
> > > > can see that the unallocated space is rising as it's freeing the little
> > > > used chunks but still no data are being stored on the new disk.
> > That is exactly what is happening:  you are moving tiny amounts of data
> > into existing big empty spaces, so no new chunk allocations (which should
> > use the new drive) are happening.  You have 470GB of data allocated
> > but not used, so you have up to 235 block groups to fill before the new
> > drive gets any data.
> > 
> > Also note that you always have to do a full data balance when adding
> > devices to raid5 in order to make use of all the space, so you might
> > as well get started on that now.  It'll take a while.  'btrfs balance
> > start -dstripes=1..3 /mnt/data1' will work for this case.
> > 
> > > > I it some bug? Is `fi usage` not showing me something (as it states
> > > > "WARNING: RAID56 detected, not implemented")?
> > The warning just means the fields in the 'fi usage' output header,
> > like "Free (estimate)", have bogus values because they're not computed
> > correctly.
> > 
> > > > Or is there just too much
> > > > free space on the first set of disks that the balancing is not bothering
> > > > moving any data?
> > Yes.  ;)
> > 
> > > > If so, shouldn't it be really balancing (spreading) the data among all
> > > > the drives to use all the IOPS capacity, even when the raid5 redundancy
> > > > constraint is currently satisfied?
> > btrfs divides the disks into chunks first, then spreads the data across
> > the chunks.  The chunk allocation behavior spreads chunks across all the
> > disks.  When you are adding a disk to raid5, you have to redistribute all
> > the old data across all the disks to get balanced IOPS and space usage,
> > hence the full balance requirement.
> > 
> > If you don't do a full balance, it will eventually allocate data on
> > all disks, but it will run out of space on sdb, sdc, and sde first,
> > and then be unable to use the remaining 2TB+ on sdd.
> > 
> > > #  uname -a
> > > Linux storage 4.19.0-0.bpo.2-amd64 #1 SMP Debian 4.19.16-1~bpo9+1
> > > (2019-02-07) x86_64 GNU/Linux
> > > #   btrfs --version
> > > btrfs-progs v4.17
> > > #  btrfs fi show
> > > Label: none  uuid: xxxxxxxxxxxxxxxxx
> > >      Total devices 4 FS bytes used 4.09TiB
> > >      devid    2 size 2.73TiB used 2.34TiB path /dev/mapper/crypt-sdc
> > >      devid    3 size 2.73TiB used 2.34TiB path /dev/mapper/crypt-sdb
> > >      devid    4 size 2.73TiB used 2.34TiB path /dev/mapper/crypt-sde
> > >      devid    5 size 2.73TiB used 158.06GiB path /dev/mapper/crypt-sdd
> > > 
> > > #   btrfs fi df .
> > > Data, RAID5: total=4.59TiB, used=4.06TiB
> > > System, RAID1: total=64.00MiB, used=528.00KiB
> > > Metadata, RAID1: total=158.00GiB, used=29.43GiB
> > > GlobalReserve, single: total=512.00MiB, used=0.00B
> > > 
> > > > Thanks
> > > > 
> > > > Jakub
> > > > 
