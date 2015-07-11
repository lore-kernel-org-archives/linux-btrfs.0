Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:40175 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752078AbbGKGPa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 11 Jul 2015 02:15:30 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZDmQh-00055d-BJ
	for linux-btrfs@vger.kernel.org; Sat, 11 Jul 2015 06:30:23 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 11 Jul 2015 06:30:23 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 11 Jul 2015 06:30:23 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Did btrfs filesystem defrag just make things worse?
Date: Sat, 11 Jul 2015 04:30:15 +0000 (UTC)
Message-ID: <pan$e3829$abc1de8c$4dc42856$7192e92@cox.net>
References: <CAC=t97A0eR34GyMLC_XhdWMVAf1YaCgX=qrXGkip991znH5N9A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Donald Pearson posted on Fri, 10 Jul 2015 15:57:46 -0500 as excerpted:

> If I'm reading this right, my most fragmented file
> (Training-flat.vmdk) is now almost 3x more fragmented?

[snip to context for brevity]

> # filefrag /mnt2/tank/virtual_machines/virtual_machines/Training/*
> /mnt2/tank/virtual_machines/virtual_machines/Training/Training-flat.vmdk:
> 1444 extents found

> # lsattr /mnt2/tank/virtual_machines/virtual_machines/Training/
> --------c------C
> /mnt2/tank/virtual_machines/virtual_machines/Training/Training-flat.vmdk

> # ./btrfs fi defragment -vr /mnt2/tank/virtual_machines
> /mnt2/tank/virtual_machines/virtual_machines/Training/Training-flat.vmdk
> btrfs-progs v4.1

> # filefrag /mnt2/tank/virtual_machines/virtual_machines/Training/*
> /mnt2/tank/virtual_machines/virtual_machines/Training/Training-flat.vmdk:
> 4090 extents found

FWIW RE the lsattr results, the chattr manpage says c=compressed, C=nocow
(disabling copy-on-write).

The combination of the compressed and nocow attributes _seriously_
complicates the picture because their interaction is unknown,
given the information provided.

1) As the chattr manpage warns, on btrfs the C/nocow attribute should
be set on new/empty files.  If set on a file with existing data blocks,
when nocow stability takes effect is undefined.

The sequence of events in your post doesn't detail when the file was
marked nocow, so we basically haven't a clue whether that nocow
attribute has actually taken effect and the file stabilized, or not.

2) On btrfs, nocow has the effect of disabling both compression and
checksumming.  This is necessary because btrfs takes advantage of
cow so it has to calculate checksum only on newly written blocks,
not the whole previous extent, and because newly written data may
compress more or less effectively than the old, changing the
compressed size, no problem with cow since the new data is written
elsewhere, a serious problem with nocow, since now you have new data
that's likely of a different size trying to fit into the same space
as the old data.

So nocow would ordinarily override and disable compression, but
due to issue #1, we don't know whether nocow is actually on or not,
so we don't know if compression is actually disabled or not.

3) Filefrag doesn't know about btrfs compression, which works in
128 KiB blocks, and counts each 128 KiB block as a separarate extent.

Due to #2, we don't know if the file is actually compressed or not,
and you didn't list the size of the file either, but if it /is/
compressed, we'd expect filefrag to report one fragment per 128 KiB,
1/8 MiB, so divide those 4090 reported extents by 8... 511+ MB,
basically half a GiB.

If that's about the size of the file, then we can gather from
the evidence that:

a) The file isn't actually nocow as that would have disabled compression.

b) The file had the compression and nocow attributes set after creation,
so nocow didn't apply, and the defrag actually triggered the compression
of a previously uncompressed file, thereby causing filefrag to report
individual 128 KiB compression blocks as extents.

If the file is *NOT* about half a GiB in size, then something else
happened.

Among other things, your existing free space may be so fragmented that
defrag couldn't find sufficiently large blocks of space to reduce
fragmentation, so it actually got _more_ fragmented.

It's also worth noting that by default, defrag skips what it considers
"large" extents (IIRC 256 KiB... or was it 256 MiB?).  Use the -t option
set to something like 2G, to tell it to defrag everything.  (Given btrfs'
nominal data chunk size of 1 GiB, above that isn't going to do a lot of
good in any case, and don't use values above 3G as there's an integer
overflow bug in btrfs-progs earlier than the just released 4.1.1, which
effectively makes it very small, instead.)

Whatever the case, having both the c/compression and C/nocow attributes
on those files isn't a good idea, since one or the other will be
a lie.  And if you really want nocow, as indicated above, the file
must be created with nocow.  The easiest way to do that is to set nocow
on the directory the files will be created in.  For existing files, after
the dir they will be placed in is set nocow, copy them into place in such
a way that the new copy is actually created.  (The easiest two ways to
ensure that are (a) copy/move across a filesystem boundary, or (b) cat
the file into place using redirection: cat src > dest.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

