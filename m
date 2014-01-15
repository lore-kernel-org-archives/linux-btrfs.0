Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:39966 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752322AbaAOTGS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Jan 2014 14:06:18 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1W3Vn2-0000Gu-K3
	for linux-btrfs@vger.kernel.org; Wed, 15 Jan 2014 20:06:12 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Jan 2014 20:06:12 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Jan 2014 20:06:12 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: why am  I getting "No space left on device" here?
Date: Wed, 15 Jan 2014 19:05:41 +0000 (UTC)
Message-ID: <pan$6d4dc$e3f7651a$b8f89b4a$ecb5f643@cox.net>
References: <20140115115543.790adafb@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Tomasz Chmielewski posted on Wed, 15 Jan 2014 11:55:43 +0100 as excerpted:

> I'm no longer able to write to this btrfs filesystem:
> 
> # df -h /home
> Filesystem      Size  Used Avail Use% Mounted on
> /dev/sdb4       5.2T  3.6T  1.6T  71% /home

FWIW, standard df doesn't really know how to work with btrfs' advanced 
layout yet, so its output is, let's say "less than ideal", on btrfs, 
particularly on the various btrfs multi-device configurations.

btrfs fi show and btrfs fi df, combined, form the usable replacement on 
btrfs.  Fortunately you listed their output as well...

> # btrfs fi show /home Label: crawler-btrfs  uuid:
> 60f1759c-45f6-4484-9f60-66a4e9bbf2b6
>         Total devices 2 FS bytes used 1.80TiB
>	  devid    3 size 2.56TiB used 1.80TiB path /dev/sdb4
>	  devid    4 size 2.56TiB used 1.80TiB path /dev/sda4
> 
> Btrfs v3.12

Looks pretty reasonable and well balanced, as a raid1 should be. =:^)

Only 1.80 TiB of 2.56 TiB on each device allocated, so there's plenty
of room left to allocate additional chunks as needed.  =:^)

> # btrfs filesystem df /home
> Data, RAID1: total=1.75TiB, used=1.75TiB
> System, RAID1: total=32.00MiB, used=268.00KiB
> Metadata, RAID1: total=53.00GiB, used=51.71GiB

Data chunks are full, 1.75 TiB of 1.75 TiB, so it'll need to allocate a 
new data chunk pretty quickly when you start copying.  (raid1 mode, so 
it'd allocate chunks in pairs on the two devices).  FWIW, data chunks are 
1 GiB each.

Metadata chunks, 51.71 GiB used of 53.00 GiB.  1.25+ GiB free.  Metadata 
chunks are a quarter GiB (256 MiB) each, so that's several chunks worth, 
free.

> However:
> 
> # dd if=/dev/urandom of=bigfile
> dd: writing to `bigfile': No space left on device
> 186+0 records in
> 185+0 records out
> 94720 bytes (95 kB) copied, 0.0144045 s, 6.6 MB/s
> 
> 
> I don't understand why - can anyone explain?

Well, there's two levels of explanation here, but unfortunately they 
don't fully cover it.  Still, here's what's available:

At the first level, as hinted above in the df comments, btrfs' space 
calculation is MUCH more complex than that of a normal filesystem.

First, unlike a normal filesystem, btrfs data and metadata are treated 
separately, and they're very unlikely to run out together, so one or the 
other will be out while the other has room left.  Then there's the fact 
that metadata is dup by default, while data is single, so metadata by 
default takes up twice the space it normally would.  (Plus of course 
btrfs has checksums and even small partial-block file-tail data in its 
metadata, in addition to it all being dupped, so there's a lot MORE 
metadata to deal with on btrfs, than on a normal filesystem.)

In ordered to deal with that, btrfs sets up the empty filesystem as a big 
reserve pool of potential chunks that can be allocated to data or 
metadata as needed, so there's the whole already allocated vs. still 
unallocated and free to allocate thing, as displayed by btrfs fi show, 
that other filesystems don't normally deal with.  Meanwhile, btrfs fi df 
displays, separately for each of data, metadata and system chunks, how 
much of the already allocated space is actually used.  You can see my 
comments on your output above.

Then there's the whole multi-device thing and the various raid modes that 
btrfs has, that simply don't apply to normal filesystems.  Both data/
metadata as raid1 with two devices is actually rather simple, since one 
copy goes to each device.  Actually, that's even simpler than the default 
single-device case, since a single device defaults to dup metadata, 
single data, which is harder to figure out than a two-device raid1's 
simple one copy to each device rule.  But a two-device raid1 is the 
simple case!

Then there's the fact that eventually, the plan is to allow different 
subvolumes to be configurable with different raid levels, so it could 
well be that you'd have raid1, raid10, raid6, raid5, and single, all on 
the same filesystem!

No *WONDER* df doesn't know how to report all this!  Actually, they're 
already working on making df better for the simple all-one-type cases at 
least, but I doubt it'll ever be "good" at reporting for btrfs in the 
complex cases, since it's simply too simple a tool for that job.

This is actually covered on the btrfs wiki in the FAQ as well, altho I 
think I covered it more thoroughly above.  But they'll give you some 
hints for dealing with the problem as well, and I'd definitely recommend 
spending some time reading the wiki in any case, since there's certainly 
more there that you're likely to find very useful as an admin running 
btrfs on your systems.

FAQ  (space-related, see 1.3 and 1.4, and 4.4 thru 4.10)
https://btrfs.wiki.kernel.org/index.php/FAQ

General btrfs wiki link (bookmark it! =:^)
https://btrfs.wiki.kernel.org


The space-related FAQ entries should cover the theory, and give you some 
hints for fixing the problem as well, but there appears to be more going 
on in your case, as you have _PLENTY_ of unallocated space remaining so 
allocating more shouldn't be a problem.  And I had a similar issue 
recently as well -- plenty of space left (tho in my case it was on a 
small mixed-mode filesystem).

That's the second level which I alluded to, where the FAQ and the answers 
above don't really cover things.

In my case, I was copying over a bunch of files at once. Actually, I had 
just done a fresh mkfs.btrfs on the /boot on one of my two ssds (with the 
other one still bootable in case something went wrong while I was setting 
up the new /boot, of course), and was trying to install grub2's modules 
and config files to it once again.  As I said, that's a small (sub 1-gig 
so mixed-mode instead of separate data/metadata) filesystem, and the 
files in question were pretty small, too

But what I found here, was that while some files copied just fine, others 
failed.  HOWEVER, I was using mc (aka midnight commander), and I used its 
directory diff feature to figure out what had copied and what hadn't, 
which left all the uncopied files in the source selected, so I could try 
copying them once again.

And the weird thing was, while the original copy errored out due with a 
no-space error, when I tried again to copy the files that hadn't copied, 
more of them copied over without error!  By doing this a couple times, I 
was able to get everything copied over.


What happened was this.  When the error occurred, while I had unallocated 
space left as shown in btrfs fi show, btrfs fi df showed nearly full 
usage.  (Again, with a sub-gig filesystem, btrfs uses mixed-mode by 
default, so data/metadata combine, so it was just the single mixed-type 
chunk that was about full, not separate data/metadata.  And a balance as 
suggested in the FAQ... didn't help, and I mount with 
compress=lzo,autodefrag already, and it was a fresh filesystem, so...)

But by trying the file copies again for just the files that had been 
missed the first time, the order was different, and something, somehow, 
triggered a new chunk allocation, that for whatever reason, btrfs had 
failed to allocate when it should have, the first time around.

Which brings us back to your case.  While I was dealing with a small sub-
gig filesystem and thus mixed-mode, you're dealing with a large 
filesystem and separate data/metadata chunks.

But just as my already allocated mixed-mode chunks were just about full 
and I needed another one allocated to complete the job, so your data 
chunks are full or very close, according to btrfs fi df, and you need a 
new one allocated (and if the file is greater than a gig in size, likely 
more than one) to finish the job.

And in both our cases, there's plenty of unallocated space in the pool, 
but for whatever reason, btrfs isn't allocating that new chunk when it 
should!  Why, I can't say, but as I mentioned, I was able to work around 
the problem here by trying the remaining files in a different order, and 
at some point, btrfs figured out it needed that new chunk allocated, and 
everything went fine after that.

So... why btrfs is failing to allocate a new chunk when it needs to I 
can't say, but I *CAN* say you're not the only one to have run into the 
problem recently; I did too.

And just as I did, here, with a bit of monkeying around, you can 
/probably/ get btrfs to allocate that new data chunk and get on with 
things.  But the trouble is, since I don't know what the exact problem is 
or what exactly I did to persuade btrfs to do that new chunk allocation, 
I can't tell you exactly what to do to get it to happen, all I can do is 
suggest you try copying smaller files or files of different sizes around 
a bit, hoping to trigger that allocation.

Once that chunk allocation happens, you should be good for at least a 
gig, since that's the data-chunk size, but if your file is over a gig in 
size, you may run into the problem again.  In that case...  Well, you 
could try copying several gigs of smaller files, then once it allocates 
what you need, delete them, leaving the data chunks allocated but with 
enough unused space to copy the original multi-gig file over.

But there's certainly some sort of chunk allocation bug involved here, 
since there was for me and is for you certainly unallocated space 
available to allocate new chunks, and from the btrfs fi df, we can see 
that the existing chunks are full and a new chunk SHOULD be allocated, 
but isn't being allocated, thus the bug.  It'll probably be fixed in 
time, but meanwhile, try monkeying around a bit with other file sizes to 
hopefully work around the issue.
 
HTH =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

