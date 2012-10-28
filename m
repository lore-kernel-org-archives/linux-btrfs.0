Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:43372 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910Ab2J1K6h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 28 Oct 2012 06:58:37 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: [RFC] New attempt to a better "btrfs fi df"
Date: Sun, 28 Oct 2012 11:58:35 +0100
Cc: Michael =?utf-8?q?Kj=C3=B6rling?= <michael@kjorling.se>,
        Hugo Mills <hugo@carfax.org.uk>,
        "kreijack@inwind.it" <kreijack@inwind.it>
References: <50899151.1070503@inwind.it> <20121027223812.GB5042@carfax.org.uk> <20121027230158.GY2381@yeono.kjorling.se> (sfid-20121028_112200_270179_7B8420E1)
In-Reply-To: <20121027230158.GY2381@yeono.kjorling.se>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201210281158.36068.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Michael, please keep CCs. Its usual to keep them on kernel related lists. 
Thanks.


Am Sonntag, 28. Oktober 2012 schrieb Michael Kjörling:
> On 27 Oct 2012 23:38 +0100, from hugo@carfax.org.uk (Hugo Mills):
> >>>            Data: RAID 0   System: RAID 1   Unused
> >>> 
> >>> /dev/vdb     307.25 MB                -        2.23 GB
> >>> /dev/vdc     307.25 MB             8 MB        2.69 GB
> >>> /dev/vdd     307.25 MB             8 MB        2.24 GB
> >>> 
> >>>            ============   ==============   ============
> >>> 
> >>> TOTAL        921.75 MB            16 MB        7.16 GB
> >> 
> >> It would scale better with the number of drives and there is a good
> >> way to place the totals.
> >> 
> >    Note that this could get arbitrarily wide in the presence of the
> > 
> > (planned) per-object replication config. Otherwise, it works. The
> > width is probably likely to grow more slowly than the length, though,
> > so this way round is probably the better option. IMO. Eggshell blue
> > is good enough. :)
> 
> Of course, but the suggestion in the mail I replied to can get equally
> arbitrarily wide in the presence of a large number of _drives_.
> 
> In my experience, many times it's better to put something together
> that works with the current status of the project and start using it,
> than trying to shoehorn every "we'd like to do this some day" feature
> into the original design. _Particularly_ when it's UI one is talking
> about. I can think of a few ways it might be possible to restrict the
> growth of the width of a table like this even in the face of separate
> per-object replication settings, the most obvious probably being to
> keep a tally on disk for each of the replication types, and have
> columns for each replication configuration (so you might get one
> column for RAID 0 data, one for RAID 1 data, one for SINGLE data, and
> so on, but you'll _never_ get more "data" columns than the filesystem
> itself supports replication methods for "data" data; the tally simply
> being an optimization so you don't have to scan the whole file system
> for a simple "df"), but by the time that feature gets implemented,
> maybe someone can think of a better presentation.

Good idea.

Maybe its also possible to hide to subsum empty trees as "Empty areas" or 
"Unused" or so.

> After all, UI aspects tend to be the easiest to fiddle with.

I agree. Output is not set in stone and I still think, scripts shall not 
parse it. If output is needed for scripts, provide a switch for csv or 
json like output. fio - the flexible I/O tester - has got JSON support 
recently so some code is already there. Or provide direct API by libbtrfs 
or so.

> Organizing the drives in rows also has the advantage that you don't
> _have_ to read everything before you can start printing the results,
> if you can live with the constraint of supporting only one data and
> metadata replication strategy. Whether to implement it that way is
> another matter. With large storage systems and multi-CPU/multi-core
> systems, while a multithreaded approach might not provide consistent
> device ordering between executions depending on the exact thread
> execution order, it could provide a fair performance enhancement. And
> forget KISS; don't we all _love_ a chance to do a little multithreaded
> programming before coffee if it saves the poor sysadmin a few dozen
> milliseconds per "df"? ;-)

Well if tabular I am all for having drives in rows.

Aside from all of this, I wonder how ZFS tools are doing it?

Anyone who has access to ZFS and can provide some outputs?

There are claims for it being better in that regard¹. I bet the new quota 
stuff provides for used space per subvolume, but still they claim they can 
now how much space is free exactly. If different things can have different 
replication strategies I think they can´t.

Still I would like to see the output of something ZFS commands to show 
disk-usage. Maybe that gives some additional ideas.

Hmmm, I got something:

merkaba:/> zpool create -m /mnt/zeit zeit /dev/merkaba/zeit


merkaba:/> zfs create zeit/test1
merkaba:/> zfs create zeit/test2
merkaba:/> zfs create zeit/test3


merkaba:/> mount | grep zfs
kstat on /zfs-kstat type fuse 
(rw,nosuid,nodev,relatime,user_id=0,group_id=0,allow_other)
zeit on /mnt/zeit type fuse.zfs 
(rw,relatime,user_id=0,group_id=0,default_permissions,allow_other)
zeit/test1 on /mnt/zeit/test1 type fuse.zfs 
(rw,relatime,user_id=0,group_id=0,default_permissions,allow_other)
zeit/test2 on /mnt/zeit/test2 type fuse.zfs 
(rw,relatime,user_id=0,group_id=0,default_permissions,allow_other)
zeit/test3 on /mnt/zeit/test3 type fuse.zfs 
(rw,relatime,user_id=0,group_id=0,default_permissions,allow_other)


merkaba:/> zfs list
NAME         USED  AVAIL  REFER  MOUNTPOINT
zeit         168K  19,6G    24K  /mnt/zeit
zeit/test1    21K  19,6G    21K  /mnt/zeit/test1
zeit/test2    21K  19,6G    21K  /mnt/zeit/test2
zeit/test3    21K  19,6G    21K  /mnt/zeit/test3
merkaba:/> dd if=/dev/zero of=/mnt/zeit/test2/schlumpf bs=1M count=10
10+0 Datensätze ein
10+0 Datensätze aus
10485760 Bytes (10 MB) kopiert, 0,022653 s, 463 MB/s
merkaba:/> zfs list                                                  
NAME         USED  AVAIL  REFER  MOUNTPOINT
zeit         169K  19,6G    25K  /mnt/zeit
zeit/test1    21K  19,6G    21K  /mnt/zeit/test1
zeit/test2    21K  19,6G    21K  /mnt/zeit/test2
zeit/test3    21K  19,6G    21K  /mnt/zeit/test3
merkaba:/> sync
merkaba:/> zfs list
NAME         USED  AVAIL  REFER  MOUNTPOINT
zeit         169K  19,6G    25K  /mnt/zeit
zeit/test1    21K  19,6G    21K  /mnt/zeit/test1
zeit/test2    21K  19,6G    21K  /mnt/zeit/test2
zeit/test3    21K  19,6G    21K  /mnt/zeit/test3
merkaba:/> dd if=/dev/urandom of=/mnt/zeit/test2/schlumpf bs=1M count=10
10+0 Datensätze ein
10+0 Datensätze aus
10485760 Bytes (10 MB) kopiert, 0,929913 s, 11,3 MB/s
merkaba:/> zfs list                                                     
NAME         USED  AVAIL  REFER  MOUNTPOINT
zeit        10,2M  19,6G    25K  /mnt/zeit
zeit/test1    21K  19,6G    21K  /mnt/zeit/test1
zeit/test2  10,0M  19,6G  10,0M  /mnt/zeit/test2
zeit/test3    21K  19,6G    21K  /mnt/zeit/test3

Hmmm. They just tell used/free space, but also for "subvolumes".

Which we can only do by estimation in some cases.


[1] http://rudd-o.com/linux-and-free-software/ways-in-which-zfs-is-better-
than-btrfs under "ZFS tracks used space per file system"

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
