Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:38872 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751730AbbK3Fod (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Nov 2015 00:44:33 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1a3HGE-0006js-GM
	for linux-btrfs@vger.kernel.org; Mon, 30 Nov 2015 06:44:26 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Nov 2015 06:44:26 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Nov 2015 06:44:26 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: "disk full" on a 5 GB btrfs filesystem, FAQ outdated?
Date: Mon, 30 Nov 2015 05:44:23 +0000 (UTC)
Message-ID: <pan$98cfe$190ff92c$916c4a80$8c9e9ee4@cox.net>
References: <20151129130754.GI31524@torres.zugschlus.de>
	<20151129141806.GG24333@carfax.org.uk>
	<20151129180629.GJ31524@torres.zugschlus.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Marc Haber posted on Sun, 29 Nov 2015 19:06:29 +0100 as excerpted:

> Hi Hugo,
> 
> On Sun, Nov 29, 2015 at 02:18:06PM +0000, Hugo Mills wrote:
>> On Sun, Nov 29, 2015 at 02:07:54PM +0100, Marc Haber wrote:

>>> However, the FAQ
>>> https://btrfs.wiki.kernel.org/index.php/FAQ#Help.21_Btrfs_claims_I.27m_out_of_space.2C_but_it_looks_like_I_should_have_lots_left.21
>>> suggests that for small filesystems (<16 GB), the best solution [...]
>> 
>> You missed the most important thing from that paragraph: Use mixed
>> block groups. That's "mkfs.btrfs --mixed ..." [...]
> 
> Yes, that was the important bit of missing information. My filesystem
> now reads:
> 
> $ df -h .
> Filesystem               Size  Used Avail Use% Mounted on
> /dev/mapper/banana-root  6,0G  836M  5,2G  14% /mnt/tempdisk
> [27/513]mh@fan:/mnt/tempdisk$ sudo btrfs fi show .
> Label: none  uuid: b2906231-70a9-46d9-9830-38a13cb73171
>     Total devices 1 FS bytes used 861.29MiB
>     devid  1 size 6.00GiB used 6.00GiB path /dev/mapper/banana-root
> 
> btrfs-progs v4.3
> $ sudo btrfs fi df .
> System, single: total=4.00MiB, used=4.00KiB
> Data+Metadata, single: total=6.00GiB, used=861.29MiB
> GlobalReserve, single: total=20.00MiB, used=0.00B
> $
> 
> Can I somehow get duplicate metadata back? Or is that unnecessary?

Define "necessary"...

Yes, you can get dup metadata back, but because data and metadata
are now combined in the same blockgroups (aka chunks), they must
both be the same replication type.

So with --mixed, if you go dup, you get dup data and metadata both,
which means halving the data you can actually store, since it's
stored twice.

Which means... 6 GiB btrfs... less than 3 GiB data storage if you go
mixed dup mode.  If say 2.5 GiB (you'll probably get a bit more but...)
is enough room to do what you need to do with it, I'd say go for
dup, as it /should/ be incrementally more reliable for you.  Obviously,
if it's not going to be enough room, you better stay single data,
which means either staying mixed and single metadata as well, or
switching back to unmixed so you can do dup metadata and still do
single data.

Dup, when it works /as/ dup, gives you two copies.  That's useful
if one copy goes bad while the other is still good, but it's
obviously not as reliable as raid1, two copies, each on different
devices, would be.  Meanwhile, various ssds do firmware level
deduplication and turn your two copies back into only one on the
physical device.  That shouldn't waste space as the device
shouldn't actually take space for deduped copies, but it will
then uselessly spend time processing that second copy, to no
benefit since the firmware second guessed you and deduped, and
if that now one copy goes bad, it's bad no matter which of the
two filesystem level pointers to it you try to read.

So dup /should/ be incrementally more reliable, /provided/ you're
actually getting dup, without the firmware or some other level
second-guessing you.

But tho I'm not personally familiar with the banana-pie, I'd guess
that the storage is emmc or the like, and likely doesn't have
firmware with that level of sophistication, so you're likely
to still have dup.

Meanwhile, in theory you could use the compress-force=zlib
mount option to squeeze a bit more space out of that dup,
letting you store somewhat more than 3 GiB of data, depending
on how zlib-compressible it is.  But I'd guess the CPU does
better on cost and performance per watt than on raw performance,
and compression, particularly zlib, is likely to slow things
down sufficiently badly that it's not going to be tolerable.
Still, you could try it, and if you're close on the data size
and performance does end up being tolerable, that just might
let you do dup, where you couldn't, otherwise.

Of course you can also try compress-force(=lzo the default
compression so the =spec isn't required), which should give
you slightly better performance than zlib, but also a bit
less efficient compression in terms of size saved.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

