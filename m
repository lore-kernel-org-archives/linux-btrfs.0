Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 140B82E6CB8
	for <linux-btrfs@vger.kernel.org>; Sat, 20 Jun 2026 23:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781998536; cv=none; b=acKcI7gGc0TwMFvtpgL1S4iWiuND/VOZUbz3Fh1cVgceDih47O+P8bRJkgJ3ESCISLjHM8kgev+Rxa/+myiiHnK7G8zIeaQl7fDChLopbMCXqiC4v+uoZQ33GS3TRZhTR4b9JFS0IU+mkVf2/bhYTjPj9fhD3T3xrB4R6UtA364=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781998536; c=relaxed/simple;
	bh=LVEzQxzDM+AdzgNvHj9+1h8jTc0WHzFHm+H9xSdm11w=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=MT+ZONqdxtHz0Ee2W2JNXRViVONJkYHc8nCHdDciK8gyRgG6lj2KcYOWd0kPD7a0LAgCnWT1atzjTzB0pArUN8njfzfFlbonEMN+ONr0areBuRQQ0sCGVHQZqB1BWVkI3rc8cr+BFWnG1mvFUkXElOn4dtCOloVFLQW6SsmsdKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=Fhj6bsZx; arc=none smtp.client-ip=212.227.17.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="Fhj6bsZx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1781998530; x=1782603330; i=quwenruo.btrfs@gmx.com;
	bh=PCjPAm8D3dGugHKVaOxxOfyFyHLsSZzd4ShiBheJu6o=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=Fhj6bsZxOXggN33tR/FjsNOMIEWjvKWi/2EMsXacqxhfjvO0QHhyCHfCafELRC5O
	 Ld8I9RHICiKXTcYUU54scirslInzXCO9Z1HbC2IitY3E7Lvo78n1dQ2mVyXZNI3bm
	 WcSyB9KGIVtyWebErTXgofrCuyJoUPdi1AznFqhy2VVbagFyC3XdRunVBY4mBHoOA
	 +6nKS4xJaWtQ/PBbLhwY7OUOWUh+iB6I5W8Dvl0Q0z4mkMaMskdK7aTRXdsJE2fQK
	 RSynXH+V7PVySzrz6QpLiQswhyFBGkxjyNvFbXNgjAlIi1NOTX437oy3ApeuFGXsh
	 mFWhuWZmv0YRssNhJw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MgvrB-1x6s8q1qaT-00oRei; Sun, 21
 Jun 2026 01:35:29 +0200
Message-ID: <3b98816a-7115-48ec-adb3-27282e54af26@gmx.com>
Date: Sun, 21 Jun 2026 09:05:26 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 00/15] btrfs: RAID5 with RAID stripe-tree (zoned +
 non-zoned)
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 linux-btrfs@vger.kernel.org
References: <20260619090211.497100-1-johannes.thumshirn@wdc.com>
Content-Language: en-US
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Autocrypt: addr=quwenruo.btrfs@gmx.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNIlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT7CwJQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCZxF1YAUJEP5a
 sQAKCRDCPZHzoSX+qF+mB/9gXu9C3BV0omDZBDWevJHxpWpOwQ8DxZEbk9b9LcrQlWdhFhyn
 xi+l5lRziV9ZGyYXp7N35a9t7GQJndMCFUWYoEa+1NCuxDs6bslfrCaGEGG/+wd6oIPb85xo
 naxnQ+SQtYLUFbU77WkUPaaIU8hH2BAfn9ZSDX9lIxheQE8ZYGGmo4wYpnN7/hSXALD7+oun
 tZljjGNT1o+/B8WVZtw/YZuCuHgZeaFdhcV2jsz7+iGb+LsqzHuznrXqbyUQgQT9kn8ZYFNW
 7tf+LNxXuwedzRag4fxtR+5GVvJ41Oh/eygp8VqiMAtnFYaSlb9sjia1Mh+m+OBFeuXjgGlG
 VvQFzsBNBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAHCwHwEGAEIACYCGwwWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCZxF1gQUJEP5a0gAK
 CRDCPZHzoSX+qHGpB/kB8A7M7KGL5qzat+jBRoLwB0Y3Zax0QWuANVdZM3eJDlKJKJ4HKzjo
 B2Pcn4JXL2apSan2uJftaMbNQbwotvabLXkE7cPpnppnBq7iovmBw++/d8zQjLQLWInQ5kNq
 Vmi36kmq8o5c0f97QVjMryHlmSlEZ2Wwc1kURAe4lsRG2dNeAd4CAqmTw0cMIrR6R/Dpt3ma
 +8oGXJOmwWuDFKNV4G2XLKcghqrtcRf2zAGNogg3KulCykHHripG3kPKsb7fYVcSQtlt5R6v
 HZStaZBzw4PcDiaAF3pPDBd+0fIKS6BlpeNRSFG94RYrt84Qw77JWDOAZsyNfEIEE0J6LSR/
In-Reply-To: <20260619090211.497100-1-johannes.thumshirn@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:1bOpfVxPmGwEcv9BhS5njlJgoT45zj7xvwWNyRWChPmhFiPYRfd
 q2YT6MjRWbaB3MA0V2kcKLrE4TkPVKTcSjKD0XsuHoCFFhqk3xEfGlwrBPjs+Sr07eruD+Q
 xuyBinTQJZi0jr5zJH+lISw2XRb/Is8gqffao6Hgx9xrqDSEHA7haZiTEqJbQBjDTCqrbd2
 bGWLH7lNzazaj5tJKy2rQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:Xz/3mehImlo=;qJHN3ZhWuVceNP+xOWb+S1k156R
 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
 ahMiiPK/np1d2PWvOI=



=E5=9C=A8 2026/6/19 18:31, Johannes Thumshirn =E5=86=99=E9=81=93:
> This purely RFC series teaches btrfs to run RAID5/6 on top of the RAID
> stripe-tree (RST), both on zoned devices (ZNS / SMR, the primary target)
> and on regular non-zoned devices. Write-hole-free RAID5 for ordinary
> disks is an explicit goal here, not just a side effect of the zoned
> work.
>=20
> It is send as an early feedback/design review and not intended to be
> used, therefore I deliberately did not include the btrfs-progs part of
> it.
>=20
> Motivation
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> Classic btrfs RAID56 derives the data/parity device and offset for each
> stripe from a fixed geometric rotation and overwrites parity in place.
> That model has two problems:
>=20
>   1) It cannot work on zoned devices, which forbid in-place overwrite
>   2) In-place parity update is the source of the RAID56 write hole
>=20
> The RAID stripe-tree already maps a logical address to a per-device
> physical address for each stripe of a profile. Building RAID5 on the RST
> means every stripe's location is recorded rather than computed, so data
> and parity can land anywhere (e.g. wherever a zone-append put them) and
> stripes are written copy-on-write. That removes the write hole and makes
> RAID5 expressible on zoned devices.

And that in theory removes the need for RAID56 rotation, or the need to=20
have a fixed stripe length.

One of the reason that RAID56 needs rotation is to avoid sub-stripe=20
writes causing too much workload for the P/Q stripe, but since we never=20
over-write in this case, we can even skip the rotation part.

Without rotation, it can further improve partial writes, mentioned below.

>=20
> How it works
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> Write:
> ------
> A RAID5 write does not assemble a full stripe up front. Each data bbio
> folds its column into a shared, zeroed per-stripe parity buffer held by
> a struct btrfs_stripe_set (keyed by full_stripe_logical), accounting the
> folded bytes. The parity is submitted by btrfs_stripe_set_finalize():
>=20
> - eagerly, once all nr_data columns are folded (a full stripe, even if
>    it was split across two ordered extents); or
> - for a partial tail (a stripe that never fills), from the
>    ordered-extent completion in btrfs_rst_raid56_finish_ordered(), using
>    i_size to decide it is a genuine tail.

One thing I'm not sure if, do the RAID56 RST still requires the existing=
=20
64K stripe len.

E.g. if there is a partial tail that is nr_data * blocksize aligned, but=
=20
not reaching full nr_data * 64K.

In that case, we can just map that partial write into all devices=20
without extra padding, aka variable stripe length.

And with that said, we can definitely steal some ideas from XFS RAID56,=20
introducing something like minimal data IO size, so that it's always=20
power-of-2 of the block size.

Then limit the RAID56 chunk allocator to always allocate power-of-2=20
number of data devices.

This completely removes the need of partial stripe handling.

>=20
> The actual zone-append physical for both data and parity is recorded int=
o the
> RST from the bio completion, so reads resolve by lookup and the append m=
ay
> land anywhere. btrfs_stripe_set_calc_parity() dispatches on the parity c=
ount
> and currently has a RAID6 (or higher order parity) placeholder.
>=20
> Read:
> -----
> btrfs_rst_raid56_read() reads the target data column directly when its d=
evice
> is present, and reconstructs it from the other columns + parity (xor_gen=
)
> only when the target column's device is missing or on a repair retry. RA=
ID56
> lookups trust the recorded (devid, physical) and resolve the device from=
 the
> recorded devid rather than from a geometric rotation: a zoned RST RAID5 =
data
> column is a contiguous zone-append run, so a single data extent can span=
 what
> the geometric model treats as multiple rotated rows, and geometry would
> resolve a read to the wrong device.
>=20
> Delete / partial free:
> ----------------------
> btrfs_delete_raid_extent() removes a RAID56 stripe's data+parity only fo=
r a
> full stripe entirely covered by the freed range; a partial free retains =
the
> items (so survivors still reconstruct), and the leftovers are reclaimed =
when
> the block-group is removed.
>=20
> Testing
> =3D=3D=3D=3D=3D=3D=3D
>=20
> Verified on QEMU NVMe ZNS, zloop and emulated SMR (SCSI ZBC), and on
> regular non-zoned loop devices:
>=20
>   1) full-stripe writes (128K..32M) and sub-stripe writes round-trip cac=
he-cold
>      and across umount/remount
>   2) in-kernel sanity tests pass
>   3) on-disk parity content is verified (a half-stripe write's recorded =
parity
>      equals the data column)
>   4) non-zoned RAID5-RST: mkfs/mount, cache-cold read, overwrite, single=
-device
>      corrupt + degraded reconstruct, btrfs check
>=20
> Limitations / open work
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
>   1) Partial stripe (over)write is different from my original idea to pa=
d
>      to BTRFS_STRIPE_LEN with 0 bytes and then compute parity. This
>      totally broke space accounting (obviously afterwards *facepalm*)
>   2) RAID6 is not implemented; the parity computation has a single-parit=
y
>      (RAID5) implementation and a RAID6 placeholder.
>   3) Reconstruct soundness for non-stripe-aligned, row-spanning data
>      extents is not yet fully verified end to end (degraded reconstruct
>      works for single-extent stripes).
>   4) Reflink handling is not very well tested yet
>   5) No NOCOW testing and I'm leaning to make a global no-NOCOW for RST
>   6) Full fstests run still pending
>   7) Testing, testing, testing
>=20
> Johannes Thumshirn (15):
>    btrfs: factor out filling a single raid_stride
>    btrfs: pass the key type to btrfs_insert_one_raid_extent()
>    btrfs: introduce BTRFS_RAID_STRIPE_PARITY_KEY
>    btrfs: zoned: align max_zone_append_size to the stripe length for RST
>    btrfs: load raid56 block-groups
>    btrfs: allow RAID56 for data block groups with stripe-tree
>    btrfs: don't call into regular raid56 if we're using RST
>    btrfs: implement RAID stripe-tree RAID5 writes
>    btrfs: implement basic RAID stripe-tree RAID5 read
>    btrfs: fix RAID stripe-tree lookup across leaf boundaries
>    btrfs: tests: add a RAID5 RAID-stripe-tree read test
>    btrfs: compute RAID stripe-tree RAID5 parity for sub-stripe writes
>    btrfs: implement delete of parity stripes
>    btrfs: tests: add RAID5 RAID-stripe-tree create/update/delete tests
>    btrfs: search commit root when relocating on RST
>=20
>   fs/btrfs/bio.c                          | 100 ++-
>   fs/btrfs/block-group.c                  |  15 +
>   fs/btrfs/disk-io.c                      |  16 +
>   fs/btrfs/fs.h                           |   3 +
>   fs/btrfs/inode.c                        |   7 +
>   fs/btrfs/print-tree.c                   |   2 +
>   fs/btrfs/raid-stripe-tree.c             | 805 +++++++++++++++++++++++-
>   fs/btrfs/raid-stripe-tree.h             |  22 +-
>   fs/btrfs/super.c                        |   9 +
>   fs/btrfs/tests/raid-stripe-tree-tests.c | 344 +++++++++-
>   fs/btrfs/volumes.c                      |  13 +
>   fs/btrfs/zoned.c                        |  76 +++
>   include/trace/events/btrfs.h            |  24 +
>   include/uapi/linux/btrfs_tree.h         |   1 +
>   14 files changed, 1395 insertions(+), 42 deletions(-)
>=20

