Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smx-7fb.smtp.startmail.com ([37.153.204.247]:37350 "EHLO
	smx-7fb.smtp.startmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965397AbbKDVxM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 4 Nov 2015 16:53:12 -0500
Message-ID: <563A7E45.1050806@startmail.com>
Date: Wed, 04 Nov 2015 21:53:09 +0000
From: OmegaPhil <OmegaPhil@startmail.com>
Mime-Version: 1.0
To: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Subject: Re: Unable to allocate for space usage in particular btrfs volume
References: <563A7452.4050202@startmail.com> <20151104213039.GC27446@carfax.org.uk>
In-Reply-To: <20151104213039.GC27446@carfax.org.uk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="KpBpDO3jk7WQG56HH7DplX617w9VvtEOJ"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--KpBpDO3jk7WQG56HH7DplX617w9VvtEOJ
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 04/11/15 21:30, Hugo Mills wrote:
> On Wed, Nov 04, 2015 at 09:10:42PM +0000, OmegaPhil wrote:
>> Back in September I noticed that 'sudo du -chs /mnt/storage-1' reporte=
d
>> 887GB used and 'df -h' 920GB for this particular volume - I went on
>> #btrfs for any suggestions, and balancing + defraging made no
>> difference. It had no subvolumes/snapshots etc, I basically used it li=
ke
>> a checksumed ext4fs.
>>
>> Since the volume was converted from ext4, I redid it from scratch (so
>> made with kernel v4.1.3 or v4.1.6 on this Debian Testing machine), and=

>> the problem went away.
>>
>> After a couple of months, df reports 907GB used, whereas du says 884GB=
 -
>> I currently have 8 large (1-5.5TB volumes) btrfs volumes in use,
>> storage-1 is the only SSD volume and the only one with this problem.
>>
>> No balancing or defraging this time, it didn't make a difference befor=
e
>> and this is a relatively new volume.
>>
>> Are there any sysadmin-level ways I can account for the ~23GB lost spa=
ce?
>=20
>    There's an issue where replacing blocks in the middle of an
> existing extent won't split the extent, and thus the "old" blocks
> aren't freed up, because they're held by the original extent (even
> though not actually referenced by any existing file). This might be
> what you're seeing.
>=20
>    I'm not sure how to confirm this theory, or what to do about it if
> it's true. (Defrag the file? Copy it elsewhere? Other?)
>=20
>    Two other cases for df > du are orphaned files, although 23 GiB of
> orphans is large; and missing out the dot-files in the directory that
> du is run from (if doing, say, "du *" rather than "du ."). I've been
> bitten by both of those in the past.
>=20
>    Hugo.


The volume doesn't change hugely over time, so it really ought not to
have broken so quickly - a quick rundown of the storage usage:

36% general (small files, some smallish videos)
24% music
23% pr0n
17% VMs

But in terms of 'large files changing', it could be the VM disks perhaps
- I'll move them out, balance, and then back in again, hopefully that'd
be a meaningful test.

du-wise was direct on the root directory, any idea how I could audit
orphan files?

Thanks





--KpBpDO3jk7WQG56HH7DplX617w9VvtEOJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWOn5FAAoJEBfSPH39wvOPHMMP/i+jip5U2KX+S5ou2iAmMEQG
WsybBuNr6QsWSuF3Ka4dXOKvUSPoHFXN4Yz5VPZiVSkNEdwFLTvpam5A6r3yJH3c
490siuAFNomQE3p9trvEnulqqCfmGNVFDzRcZ437jTEuYqGCJ6Nasl/TlmtB7apZ
UwsjcbfO1issJNRzW2AyR0xLOU/0nHVSChw3ytHwWqAGl1sWUH3WkvEH7CwcEV8C
oN2ycPBQ3oUnn1e7Am0ZaAp/7akipsPu6hHGncterw6Q8BABPAY1XgSUXSDBToIl
Au2jdAJ0u8Apx8iNRN5GlYXx9KnZNIlJ5Puadfp38yr0txBvf65GbHX/933iaxSX
zj1j5whg+m0Uvanv6ddTwF+d40zKQRdsC2q1s3ykMiE/zE7q7nRtoMTlPkrp2JkB
6l23zFXy6ooe0NTOQ87sfqNy6bO3WkHXyPBO9XEG3dvkE/+j3XqOcM+5yhT2gnNw
1KadNZS602rX2EqDSUJn5yLvfMKe7coYbjag76L2rhhY+ntgpibfTYwa7XuEj3Qe
tXe+H+UKOVNrtXoygEzCMBPGqlyC73iVYeWI9qUNib+D0xh5hDpAcB00RRGOT20l
lIDGHsXKFVT8PuQ1H5jIlusbwqkYdQfwb6NjwQ8nWk09N8dGFdexTxZjL62AkaLY
1qUKlZ8q+bzySf1EjLcm
=GqLM
-----END PGP SIGNATURE-----

--KpBpDO3jk7WQG56HH7DplX617w9VvtEOJ--
