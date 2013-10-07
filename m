Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:47299 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753401Ab3JGOhd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 7 Oct 2013 10:37:33 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VTBwC-0007H8-5d
	for linux-btrfs@vger.kernel.org; Mon, 07 Oct 2013 16:37:32 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 07 Oct 2013 16:37:32 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 07 Oct 2013 16:37:32 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Some questions after devices addition to existing raid 1 btrfs
 filesystem
Date: Mon, 7 Oct 2013 14:37:10 +0000 (UTC)
Message-ID: <pan$a356b$b775be14$19e82402$f6e2acb6@cox.net>
References: <CAFirYm_jn=O50=aOvRswBJio3f37xOY-BLeXTzfzHzRKzX3wrQ@mail.gmail.com>
	<20131007120623.GM28147@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hugo Mills posted on Mon, 07 Oct 2013 13:06:23 +0100 as excerpted:

> On Mon, Oct 07, 2013 at 01:45:29PM +0200, Laurent Humblet wrote:
>> I have added 2x2Tb to my existing 2x2Tb raid 1 btrfs filesystem and
>> then ran a balance:
>> 
>> # btrfs filesystem show
>>         Total devices 4 FS bytes used 1.74TB
>>         devid    3 size 1.82TB used 0.00 path /dev/sdd
>>         devid    4 size 1.82TB used 0.00 path /dev/sde
>>         devid    2 size 1.82TB used 1.75TB path /dev/sdc
>>         devid    1 size 1.82TB used 1.75TB path /dev/sdb
>> # btrfs filesystem balance btrfs_root/
>> # btrfs filesystem show
>>         Total devices 4 FS bytes used 1.74TB
>>         devid    3 size 1.82TB used 892.00GB path /dev/sdd
>>         devid    4 size 1.82TB used 892.00GB path /dev/sde
>>         devid    2 size 1.82TB used 891.03GB path /dev/sdc
>>         devid    1 size 1.82TB used 891.04GB path /dev/sdb
>> 
>> It took 59 hours to complete the balance.

Hugo's answers are great and he and the wiki are where I learned most of 
what I know about btrfs.  I've just a few details to add.

First, the wiki site in case you weren't aware of it:

https://btrfs.wiki.kernel.org

Second, in case you didn't know but as you can surmise from the numbers 
above, note that btrfs raid1 mode with greater than two devices is *NOT* 
the same as common or mdadm raid1 in a similar case.  Unlike mdadm which 
mirrors the data/metadata N-ways, four devices means four copies, on 
btrfs only two copies of the data/metadata are kept regardless of the 
number of devices.  That's why adding two additional devices to the first 
two halved the usage on each device, after the balance was done.

>> I checked on a couple of files and all seems fine but I have some
>> questions:
>> - is there some kind of 'overall filesystem health/integrity check'
>> that I should do on the filesystem now that the balance is done?
> 
>    See btrfs scrub start

btrfs scrub is great.  It verifies checksums and copies data from any 
good copy available if any checksums fail.  Of course raid1 gives you 
that extra copy to copy from in case one /is/ bad, and I've had scrub fix 
things up after a bad shutdown or two. =:^)  (Well, it was really suspend/
resume cycles that failed to resume properly that scrub fixed for me, but 
anyway...)

>> - also, I ran the command while some of the btrfs subvolumes were
>> mounted (as well as the btrfs_root/ of course), does this impact on the
>> balance job?
> 
>    No.
> 
>> - the mounted btrfs devices were mounted using -o
>> space_cache,inode_cache but the btrfs_root/ was not, also, does this
>> impact on the balance job?
> 
>    No.

AFAIK, btrfs doesn't have separate filesystem-specific mount option 
handling yet.  IOW, if one subvolume's mounted with cache, they all will 
be.  However, non-filesystem specific options such as ro/rw, should still 
be subvolume specific.  I'm not actually sure about noatime vs. relatime, 
but I'd guess that's per subvolume too, since it's a general filesystem 
option not specific to btrfs.

Talking about noatime... you didn't mention it, but it's definitely 
recommended with btrfs, especially if you're doing regular snapshotting, 
as atime updates may be a big part of the snapshot unique metadata 
otherwise.

>> - about those options, a few months ago, I oftent had
>> btrfs-cache-1/btrfs-endio-met processes taking some cpu/hd time.  I was
>> advised to mount -o space_cache,inode_cache, which seems to have quiet
>> the processes down.  Are those options still necessary now?
> 
>    No, once you've mounted with them once (and had the caches rebuilt)
> they're not necessary to use any more.

Hugo, this might be worth noting.  AFAIK, space_cache is now actually the 
default, from sometime before 3.10, AFAIK, as that's when I setup my 
btrfs filesystems here, never actually invoking space_cache on them at 
all, but a check of /proc/mounts said they're using it anyway.  And the 
problems with a bad space_cache preventing mount seem to have been fixed 
now -- btrfs appears to automatically fix a bad space_cache on mount, 
now, instead of failing the mount as it did a year and a half ago when I 
first tried btrfs, and decided it wasn't yet ready for me, in part due to 
problems such as that.

Inode_cache, however, was not the default yet, at least not with 3.10, 
and in at least one thread since 3.10 I've seen the devs recommend 
against using it unless it's actually needed.  I've not seen the details 
explained, but I've interpreted that to mean that inode_cache is much 
more a special-case option not recommended for everyone, while 
space_cache, as I said, seems to be stable enough it's being enabled by 
default even without being specifically invoked the first time, as used 
to be necessary.

>> - as the job took 60+ hours but the CPU rarely went above 10%, the
>> computer seemed still usable.  I left it do its job of course but could
>> I have accessed or write anything on the subvolumes while the balance
>> was running and if yes, would this have any impact on the filesystem?
> 
>    Absolutely, yes, you could have done. It would probably be slower
> than normal to access the files while the balance is happening, because
> the balance is using up I/O bandwidth, but other than that there should
> be no impact.

Agreed.

The only misgiving I'd have about using a filesystem while it's being 
balanced is that (as Hugo mentioned) that will of course split the 
available I/O bandwidth, which means both the balance and whatever else 
you're doing will take longer than they would otherwise.  (For those 
familiar with it, this is very much like mdraid during a sync/resync 
operation.)

And of course I'd put off doing anything that might have a chance of 
crashing the system, since while btrfs should recover just fine after a 
crash even in the middle of a balance, it /is/ still an experimental 
filesystem with bugs regularly being found and fixed, and I'd not wish to 
test fate.  I'd not be overly worried if a crash does happen in the 
middle of a balance, but I'd not want to do anything that'd make it more 
likely...

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

