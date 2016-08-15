Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailgateway3.uni-freiburg.de ([132.230.2.213]:45417 "EHLO
	mailgateway3.uni-freiburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751233AbcHOEjM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Aug 2016 00:39:12 -0400
Received: from ms2.uni-freiburg.de ([132.230.2.3] helo=uni-freiburg.de) port 63581
	by mailgateway3.uni-freiburg.de with esmtp
	(Exim 4.85 #2 built 17-Dec-2015 15:40:08 running on Gentoo)
	id 1bZ9PH-0000wx-AJ
	for linux-btrfs@vger.kernel.org; Mon, 15 Aug 2016 06:21:47 +0200
Received: from [88.70.41.116] (account wolfgang.mader@fdm.uni-freiburg.de HELO discus.localnet)
  by fdm.uni-freiburg.de (CommuniGate Pro SMTP 6.1.6b)
  with ESMTPSA id 292133973 for linux-btrfs@vger.kernel.org; Mon, 15 Aug 2016 06:21:46 +0200
From: Wolfgang Mader <Wolfgang.Mader@fdm.uni-freiburg.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: Likelihood of read error, recover device failure raid10
Date: Mon, 15 Aug 2016 06:21:39 +0200
Message-ID: <133750337.sc9iDRAKOZ@discus>
In-Reply-To: <1611335.C74ovpucO9@discus>
References: <2336793.AMaAIAxWk4@discus> <CAJCQCtR1odXy1WjR3+tWZsb=d1=VFdpZiFk90oPeykoDTvw1Uw@mail.gmail.com> <1611335.C74ovpucO9@discus>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart3439174.ZkL3yN2nX6"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart3439174.ZkL3yN2nX6
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Sunday, August 14, 2016 8:04:14 PM CEST you wrote:
> On Sunday, August 14, 2016 10:20:39 AM CEST you wrote:
> > On Sat, Aug 13, 2016 at 9:39 AM, Wolfgang Mader
> > 
> > <Wolfgang_Mader@brain-frog.de> wrote:
> > > Hi,
> > > 
> > > I have two questions
> > > 
> > > 1) Layout of raid10 in btrfs
> > > btrfs pools all devices and than stripes and mirrors across this pool.
> > > Is
> > > it therefore correct, that a raid10 layout consisting of 4 devices
> > > a,b,c,d is _not_
> > > 
> > >               raid0
> > >        |
> > >        |---------------|
> > > 
> > > ------------      -------------
> > > 
> > > |a|  |b|      |c|  |d|
> > > |
> > >    raid1            raid1
> > > 
> > > Rather, there is no clear distinction of device level between two
> > > devices
> > > which form a raid1 set which are than paired by raid0, but simply, each
> > > bit is mirrored across two different devices. Is this correct?
> > 
> > All of the profiles apply to block groups (chunks), and that includes
> > raid10. They only incidentally apply to devices since of course block
> > groups end up on those devices, but which stripe ends up on which
> > device is not consistent, and that ends up making Btrfs raid10 pretty
> > much only able to survive a single device loss.
> > 
> > I don't know if this is really thoroughly understood. I just did a
> > test and I kinda wonder if the reason for this inconsistent assignment
> > is a difference between the initial stripe>devid pairing at mkfs time,
> > compared to subsequent pairings done by kernel code. For example, I
> > 
> > get this from mkfs:
> >     item 4 key (FIRST_CHUNK_TREE CHUNK_ITEM 20971520) itemoff 15715
> >     itemsize
> > 
> > 176 chunk length 16777216 owner 2 stripe_len 65536
> > 
> >         type SYSTEM|RAID10 num_stripes 4
> >         
> >             stripe 0 devid 4 offset 1048576
> >             dev uuid: 736ba7b3-f21f-4643-8a59-9869b3526a82
> >             stripe 1 devid 3 offset 1048576
> >             dev uuid: af95126a-e674-425c-af01-2599d66d9d06
> >             stripe 2 devid 2 offset 1048576
> >             dev uuid: 1c3038ca-2615-414e-9383-d326b942f647
> >             stripe 3 devid 1 offset 20971520
> >             dev uuid: 969a95d3-d76d-44dc-9364-9d1f6e449a74
> >     
> >     item 5 key (FIRST_CHUNK_TREE CHUNK_ITEM 37748736) itemoff 15539
> >     itemsize
> > 
> > 176 chunk length 2147483648 owner 2 stripe_len 65536
> > 
> >         type METADATA|RAID10 num_stripes 4
> >         
> >             stripe 0 devid 4 offset 9437184
> >             dev uuid: 736ba7b3-f21f-4643-8a59-9869b3526a82
> >             stripe 1 devid 3 offset 9437184
> >             dev uuid: af95126a-e674-425c-af01-2599d66d9d06
> >             stripe 2 devid 2 offset 9437184
> >             dev uuid: 1c3038ca-2615-414e-9383-d326b942f647
> >             stripe 3 devid 1 offset 29360128
> >             dev uuid: 969a95d3-d76d-44dc-9364-9d1f6e449a74
> >     
> >     item 6 key (FIRST_CHUNK_TREE CHUNK_ITEM 2185232384) itemoff 15363
> > 
> > itemsize 176
> > 
> >         chunk length 2147483648 owner 2 stripe_len 65536
> >         type DATA|RAID10 num_stripes 4
> >         
> >             stripe 0 devid 4 offset 1083179008
> >             dev uuid: 736ba7b3-f21f-4643-8a59-9869b3526a82
> >             stripe 1 devid 3 offset 1083179008
> >             dev uuid: af95126a-e674-425c-af01-2599d66d9d06
> >             stripe 2 devid 2 offset 1083179008
> >             dev uuid: 1c3038ca-2615-414e-9383-d326b942f647
> >             stripe 3 devid 1 offset 1103101952
> >             dev uuid: 969a95d3-d76d-44dc-9364-9d1f6e449a74
> > 
> > Here you can see every chunk type has the same stripe to devid
> > pairing. But once the kernel starts to allocate more data chunks, the
> > pairing is different from mkfs, yet always (so far) consistent for
> > each additional kernel allocated chunk.
> > 
> >     item 7 key (FIRST_CHUNK_TREE CHUNK_ITEM 4332716032) itemoff 15187
> > 
> > itemsize 176
> > 
> >         chunk length 2147483648 owner 2 stripe_len 65536
> >         type DATA|RAID10 num_stripes 4
> >         
> >             stripe 0 devid 2 offset 2156920832
> >             dev uuid: 1c3038ca-2615-414e-9383-d326b942f647
> >             stripe 1 devid 3 offset 2156920832
> >             dev uuid: af95126a-e674-425c-af01-2599d66d9d06
> >             stripe 2 devid 4 offset 2156920832
> >             dev uuid: 736ba7b3-f21f-4643-8a59-9869b3526a82
> >             stripe 3 devid 1 offset 2176843776
> >             dev uuid: 969a95d3-d76d-44dc-9364-9d1f6e449a74
> > 
> > This volume now has about a dozen chunks created by kernel code, and
> > the stripe X to devid Y mapping is identical. Using dd and hexdump,
> > I'm finding that stripe 0 and 1 are mirrored pairs, they contain
> > identical information. And stripe 2 and 3 are mirrored pairs. And the
> > raid0 striping happens across 01 and 23 such that odd-numbered 64KiB
> > (default) stripe elements go on 01, and even-numbered stripe elements
> > go on 23. If the stripe to devid pairing were always consistent, I
> > could lose more than one device and still have a viable volume, just
> > like a conventional raid10. Of course you can't lose both of any
> > mirrored pair, but you could lose one of every mirrored pair. That's
> > why raid10 is considered scalable.
> 
> Let me compare the btrfs raid10 to a conventional raid5. Assume a raid5
> across n disks. Than, for each chunk (don't know the unit of such a chunk)
> of n-1 disks, a parity chunk is written to the remaining disk using xor.
> Parity chunks are distributed across all disks. In case the data of a
> failed disk has to be restored from the degraded array, the entirety of n-1
> disks have to be read, in order to use xor to reconstruct the data. Is this
> correct? Again, in order to restore a failed disk in raid5, all data on all
> remaining disks is needed, otherwise the array can not be restored.
> Correct?
> 
> For btrfs raid10, I only can loose a single device, but in order to rebuild
> it, I only need to read the amount of data which was stored on the failed
> device, as no parity is used, but mirroring. Correct? Therefore, the amount
> of bits I need to read successfully for a rebuild is independent of the
> number of devices included in the raid10, while the amount of read data
> scales with the number of devices in a raid5.
> 
> Still, I think it is unfortunate, that btrfs raid10 does not stick to a
> fixed layout, as than the entire array must be available. If you have your
> devices attached by more than one controller, in more than one case powered
> by different power supplies etc., the probability for their failure has to
> be summed up,

This formulation might be a bit vague. For m devices of which non is allowed 
to fail, the total failure probability should be
  p_tot =  (1-p_f)^m
where p_f is the probability of failure for a single device, assuming p_f is 
the same for all m devices.

> as no component is allowed to fail. Is work under way to
> change this, or is this s.th. out of reach for btrfs as it is an
> implementation detail of the kernel.
> 
> > But apparently the pairing is different between mkfs and kernel code.
> > And due to that I can't reliably lose more than one device. There is
> > an edge case where I could lose two:
> > 
> > 
> > 
> > stripe 0 devid 4
> > stripe 1 devid 3
> > stripe 2 devid 2
> > stripe 3 devid 1
> > 
> > stripe 0 devid 2
> > stripe 1 devid 3
> > stripe 2 devid 4
> > stripe 3 devid 1
> > 
> > 
> > I could, in theory, lose devid 3 and devid 1 and still have one of
> > each stripe copies for all block groups, but kernel code doesn't
> > permit this:
> > 
> > [352467.557960] BTRFS warning (device dm-9): missing devices (2)
> > exceeds the limit (1), writeable mount is not allowed
> > 
> > > 2) Recover raid10 from a failed disk
> > > Raid10 inherits its redundancy from the raid1 scheme. If I build a
> > > raid10
> > > from n devices, each bit is mirrored across two devices. Therefore, in
> > > order to restore a raid10 from a single failed device, I need to read
> > > the
> > > amount of data worth this device from the remaining n-1 devices.
> > 
> > Maybe? In a traditional raid10, rebuild of a faulty device means
> > reading 100% of its mirror device and that's it. For Btrfs the same
> > could be true, it just depends on where the block group copies are
> > located, they could all be on just one other device, or they could be
> > spread across more than one device. Also for Btrfs it's only copying
> > extents, it's not doing sector level rebuild, it'll skip the empty
> > space.
> > 
> > >In case, the amount of
> > >
> > > data on the failed disk is in the order of the number of bits for which
> > > I
> > > can expect an unrecoverable read error from a device, I will most likely
> > > not be able to recover from the disk failure. Is this conclusion
> > > correct,
> > > or am I am missing something here.
> > 
> > I think you're over estimating the probability of URE. They're pretty
> > rare, and it's far less likely if you're doing regular scrubs.
> > 
> > I haven't actually tested this but if a URE or even a checksum
> > mismatch were to happen on a data block group during rebuild following
> > replacing a failed device, I'd like to think Btrfs just complains, it
> > doesn't stop the remainder of the rebuild. If it happens on metadata
> > or system chunk, well that's bad and could be fatal.
> > 
> > 
> > As an aside, I'm finding the size information for the data chunk in
> > 'fi us' confusing...
> > 
> > The sample file system contains one file:
> > [root@f24s ~]# ls -lh /mnt/0
> > total 1.4G
> > -rw-r--r--. 1 root root 1.4G Aug 13 19:24
> > Fedora-Workstation-Live-x86_64-25-20160810.n.0.iso
> > 
> > 
> > [root@f24s ~]# btrfs fi us /mnt/0
> > 
> > Overall:
> >     Device size:         400.00GiB
> >     Device allocated:           8.03GiB
> >     Device unallocated:         391.97GiB
> >     Device missing:             0.00B
> >     Used:               2.66GiB
> >     Free (estimated):         196.66GiB    (min: 196.66GiB)
> >     Data ratio:                  2.00
> >     Metadata ratio:              2.00
> >     Global reserve:          16.00MiB    (used: 0.00B)
> > 
> > ## "Device size" is total volume or pool size, "Used" shows actual
> > usage accounting for the replication of raid1, and yet "Free" shows
> > 1/2. This can't work long term as by the time I have 100GiB in the
> > volume, Used will report 200Gib while Free will report 100GiB for a
> > total of 300GiB which does not match the device size. So that's a bug
> > in my opinion.
> > 
> > Data,RAID10: Size:2.00GiB, Used:1.33GiB
> > 
> >    /dev/mapper/VG-1     512.00MiB
> >    /dev/mapper/VG-2     512.00MiB
> >    /dev/mapper/VG-3     512.00MiB
> >    /dev/mapper/VG-4     512.00MiB
> > 
> > ## The file is 1.4GiB but the Used reported is 1.33GiB? That's weird.
> > And now in this area the user is somehow expected to know that all of
> > these values are 1/2 their actual value due to the RAID10. I don't
> > like this inconsistency for one. But it's made worse by using the
> > secret decoder ring method of usage when it comes to individual device
> > allocations. Very clearly Size if really 4, and each device has a 1GiB
> > chunk. So why not say that? This is consistent with the earlier
> > "Device allocated" value of 8GiB.


--nextPart3439174.ZkL3yN2nX6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJXsUNTAAoJEGZtonfLCdqhYn8P/it+x5EcbESFEk5kBy2CQACk
Hl2xsrkkDM+X/rrcvJjmSOgixavzpmJH+4dRVFAogx03/jguMBY40Hl1ESIOKXxD
zJJE8csrVXcSdCf/2+YuZYSjSjwDGDuyGGoXcnsAx+fQ8f4lnAYTiPa+RxNqprVZ
1aGfkhKNxAPzMTJ2Ojlre7ojJOPCZxcFI7sdiH2gx296WgidikmLMNCF6qfPHGxV
uasr6THzD6s7hrdw9i6DabVJUAMgtuGUNkvGs7aTr2YEB+Zb/XECb2zb+mqfgLrR
plIRbubwaywHL0BMntp3nST2yjC0PsdqTYMykOpIjE02xeTCEVMrnw6qd45jMksl
NrGlN2TpP7BMx0VDsUkggZeWf31y/jA8oAEBTeuQVfFeDm3nvoIfX4fc2BkwTxbC
AYERUwzXzXmTXbCVjd5iHHr5H5e27Ml2Z0YyLeKrBCbJMS6hI0E89CtQQ4ODmBdr
Vomg2N3Sd0fWFj4FMl93fRKarwA1svk+WzGBqOUvby0lPxALA48SGy4XW6aK2kbn
v7/epiLMDg46rfRpdRW7ekYgGw95RSMa8NsyyJqJps2gEv5ulo07+q8nTghdHjXO
3mqCHnS7Gp/2OfFzAnHmgI6wJdykMJvjvaW952KcWAsTBH2Olgbgi48sLy877/9j
423LAruLhjjeHGNTobyE
=Oydh
-----END PGP SIGNATURE-----

--nextPart3439174.ZkL3yN2nX6--

