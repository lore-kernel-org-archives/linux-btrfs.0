Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.227.17.22
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793739345;
	b=Q+55gPseLsFJACNDQbCh7fTCi2tg5l8k4OPpxc1dgylafmyd2nKVxO0mI9HgdCLxKpFV
	 Y8egsFIVml8Sw5NKxOi04s270an8toOxx4Y6tECG9IRpp3rnOvE/fhgDwRMlsQ4e7Z1E+
	 Gdc8d4m+fyJYguXG8GqmMi29nXKSoKjZ3IAWhZb0Ce6Wzyjx6P678RB98PffTleii0NeF
	 DKWKduV73cuoutRjO50q0NfZy5hVhClo5pET7pQ+v7KrL4zn3C1Ws5RecaVVNbrEfrknZ
	 mk2q3RlDHiOfs2LOh16ejws5aa+pRTTceYw0lo5Gp+iOEGOWxlJX4dGi+KhiAaisLAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793739345;
	h=DMARC-Filter:DKIM-Signature:X-UI-Sender-Class:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:Autocrypt:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Provags-ID:X-Spam-Flag:UI-OutboundReport;
	bh=/oRa2d6QGQuh/Di2D6Aq0an3MnWyyFgxXfwujR84W/E=;
	b=FQAj6+ne3xaUQZZBfYQfPHrdr0FUC5VNSTLLIG5k2rqgsEuuBNndykiegO0BaP0fKbLq
	 kH4v6HskS2nOscqlnf1kz00xM1bUcOy3LtpElMNfRu8gtDWUjVug15ZYuAU4eO8JjnSVX
	 tCz/EPaGOHms3VP3FNOG9KBlPInnXQvanqmwdPBfqzju8gY4UbvrfDpepH5sf7XznpXSK
	 ZU52cj6Ekt2zdfE66IqI8yBKDPy71w3PJwtXzz1QD17J49CJcOBG6W4aYQa683laPXDTI
	 jkNVlXqzcKnQYDII3A+PzONU4RsVe/M2fpYjsu60iiLwfjOoYvLrmUVHbiyG8vIIU9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmx.com;
	spf=pass smtp.mailfrom=gmx.com;
	dkim=pass header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=GIoog8xy;
	arc=none smtp.remote-ip=212.227.17.22
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C442D606A31B;
	Tue,  3 Nov 2026 20:55:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C442D606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=GIoog8xy
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1793739336; x=1794344136; i=quwenruo.btrfs@gmx.com;
	bh=/oRa2d6QGQuh/Di2D6Aq0an3MnWyyFgxXfwujR84W/E=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=GIoog8xyNhBmLiFfXOws1e0I3ndjet4Lwf8nD6sCF2sJXbJOrv7F6H3DjZQQU0Zq
	 lfjGk7nMdV3Qi6yjFVzh/cgNbN/VuxlOlaK7LQAwvkDWyOO7ong8+9IxtYE7Inh5L
	 XhbRH5hIbDYEqjcIrz0uYv2LhS6R2WOFaJBPSKT76OcP8eP742A5pPKV+xY75FRUd
	 w3JO7Zlcw/+FDbxk/vqTM3PJqg0B2Nj5r4ffhBOhgPCQuoV0fULtXlQWvKbZMPNNm
	 ZsVvyEUOQu52zx4BSwgIkaDd5VkxNqRLTGyPpZ4i6r/6eA3Ked7C+HxqpDy4+cUtQ
	 huC2TggIv9N7YMA10w==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1Mkpex-1wf8ps3uj1-00mdJ4; Tue, 03
 Nov 2026 21:55:36 +0100
Message-ID: <605a4c63-1fae-4a64-9069-e966baa98c18@gmx.com>
Date: Wed, 4 Nov 2026 07:25:31 +1030
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: test that a resumed snapshot deletion keeps its
 drop progress
To: kernel@pelam.fi, fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, asj@kernel.org, fdmanana@suse.com
References: <20261103-btrfs-355-v1-1-fb0a30b4983b@pelam.fi>
Content-Language: en-US
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Autocrypt: addr=quwenruo.btrfs@gmx.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNIlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT7CwJQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCat7o8gUJFKS8
 OQAKCRDCPZHzoSX+qAogB/9C5ErH7KGAGpcLPte3Wcfdt3acCkGAuMpCjqOt8BVw30mX0kmF
 SRo2nODjz8YsYhWR1T8L3ylANAS/IGIJ64idBmObaqGHQn845nXLIvG33LqMsAGXmOJdRgTT
 BnBA+QFCEIZpo7L9Qt1dOQdHSpHT31Ta1kKsbDm582KPVBl6KRcJJBnjudIerOA1/L/zEyDa
 YjIfHIcvuM3Xm8AS00iBpsmc151QgCPljqnSRXBiup9C1oMgVlaROhY1iDam4UIQB6glkHQs
 LZhUmFDNimX5LxfOzi2pFJSjJvPclRZVX7Sq6XhK/OFb6IvswN7i0nUYZMQfuGDNqGn70ic3
 AQImzsBNBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAHCwHwEGAEIACYCGwwWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCat7pCgUJFMw7KQAK
 CRDCPZHzoSX+qEjbB/9crFFjips2NKxkt2XUutUIKjBoUlg/xCeFIj8PsTuJePhrV9HzgKsa
 rJgSqo3t78oQWmeaP9WPoDYjfhOkQXEs+G9UwHe/LENm70+Q1jrwY3nlcR3YrkDCJ+EvMZOW
 ackgcOYn46Iri9DN91FbSTszPMnwHi/nf0aeJXicO9krrY5C8mUxv4CSKeKSRg/5BR59uDiy
 9CMRHDtIDnpDWaLOXtUeowCdiC5O/jA571PMFx3Aolc7g4SSyNbYodblCBOdJrh0CVm2LlQW
 3SXrvFpSAw7LMVDgsS8pTRt4A11eTIS7mz0zqafTohXP1wt+575IBHK5ZpThQb+PzSQmxAqa
In-Reply-To: <20261103-btrfs-355-v1-1-fb0a30b4983b@pelam.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:5TQt+gW8hjBKV1FKRtbxjC0jDnXgj4y3lMUROFv2IXbinkGTid0
 qIQFxLJDyrF/ynXVgQPM2ZXhP87HwWB4BQ4wSpKr8JwX9ROpvfnQ3J3z2tJ+lHMMrxy+r7m
 PmVblf9rdQyEJRHmxrz3WbNQikcMUz34tsSS5J8u6aWlk+EL1OznuBjLrumZXzltnjmJC33
 AH9gY+VKlLGY3+Tz/WH1A==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:6FeRlgY1n9c=;lPnIo+QZDE5eVHhGZ64Kd/an1BM
 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
 Ziew6OTAs3Ed6zy8gqrMWEZA



=E5=9C=A8 2026/11/4 07:09, Peter Lamberg via B4 Relay =E5=86=99=E9=81=93:
> From: Peter Lamberg <kernel@pelam.fi>
>=20
> When a partially dropped subvolume is resumed, btrfs_drop_snapshot()
> can write drop_progress (0 0 0) back to the root item if a commit or
> unmount happens before the resumed run drops its first reference. The
> next run then restarts from the first slot and tries to free blocks
> still shared with a snapshot again, and the transaction aborts with
> "unable to find ref byte nr". See the kernel fix:
>=20
>    "btrfs: keep drop_progress when resuming snapshot deletion"
>=20
> The test builds a subvolume S1 with a level 3 tree (nodesize 4096,
> 30000 files with one 3000 byte xattr each), takes a read-only snapshot
> S2 and deletes S1. It unmounts once a root child has been dropped, then
> does five quick mount/unmount cycles and checks that the drop key never
> goes back to zero. Finally it lets the deletion finish and checks that
> S2's content is unchanged and S1's root item is gone.
>=20
> Without the fix the test fails on the first resume; with it the test
> passes. It takes about 15 seconds on loop devices on a SATA SSD.
>=20
> Assisted-by: LLM
> Signed-off-by: Peter Lamberg <kernel@pelam.fi>
> ---
> Kernel fix, sent to linux-btrfs:
> https://lore.kernel.org/linux-btrfs/20261103-drop-progress-v1-1-16e34556=
5109@pelam.fi/
>=20
> Reproducers and logs: https://pelam.fi/btrfs-drop-progress/
>=20
> btrfs/355 fails 3/3 on the stock Ubuntu 7.3.0-9-generic btrfs.ko and 3/3
> on a module built from the same source without the fix; it passes 3/3
> with the fix. About 15 s on a SATA SSD, 11-13 s with the devices on
> tmpfs. It _notrun's if the tree stays too shallow or the window is
> missed.
>=20
> _fixed_by_kernel_commit has a placeholder hash until the fix is merged;
> I'll send a v2 with the real one. The test number may need adjusting if
> 355 gets taken first.
> ---
>=20
> ---
>   tests/btrfs/355     | 153 ++++++++++++++++++++++++++++++++++++++++++++=
++++++++
>   tests/btrfs/355.out |   2 +
>   2 files changed, 155 insertions(+)
>=20
> diff --git a/tests/btrfs/355 b/tests/btrfs/355
> new file mode 100755
> index 00000000..40e41c00
> --- /dev/null
> +++ b/tests/btrfs/355
> @@ -0,0 +1,153 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2026 Peter Lamberg
> +#
> +# FS QA Test 355
> +#
> +# Test that a resumed snapshot deletion keeps its saved drop progress.
> +#
> +# If the drop progress is reset to zero on resume (a commit or unmount =
before
> +# the resumed run drops its first reference), the next run restarts fro=
m the
> +# first slot and tries to free blocks still shared with a snapshot agai=
n: the
> +# transaction aborts with "unable to find ref byte nr".
> +#
> +. ./common/preamble
> +_begin_fstest auto quick snapshot subvol
> +
> +. ./common/attr
> +. ./common/filter
> +
> +_fixed_by_kernel_commit xxxxxxxxxxxx \
> +	"btrfs: keep drop_progress when resuming snapshot deletion"
> +
> +_require_scratch
> +_require_attrs user
> +_require_btrfs_command inspect-internal dump-tree
> +_require_btrfs_command inspect-internal rootid
> +_require_command "$TIMEOUT_PROG" timeout

Since you're using 4K nodesize, you also need 4K sectorsize support.

_require_btrfs_support_sectorsize 4096

> +
> +# One big user xattr per file gives roughly one 4K leaf per file. A lev=
el 2
> +# node covers at most ~14600 leaves, so 30000 files make a level 3 tree=
 with a
> +# few root children of several thousand leaves each.
> +# The resumed drop has to walk a whole such child before it drops anyth=
ing,
> +# which is the window the second unmount must land in.

Please don't use xattr, if you want to bump the tree level, inline=20
extents are much simpler.

> +nfiles=3D30000
> +per_dir=3D1000
> +pad=3D$(printf '%3000s' '' | tr ' ' x)
> +
> +drop_caches()
> +{
> +	sync
> +	echo 3 > /proc/sys/vm/drop_caches
> +}
> +
> +# Print the S1 root item's "drop_progress objectid" and "drop_level", o=
r
> +# "ABSENT" if the root item is gone (deletion finished).
> +drop_state()
> +{
> +	$BTRFS_UTIL_PROG inspect-internal dump-tree -t root $SCRATCH_DEV \
> +		2>/dev/null | $AWK_PROG -v want=3D$s1_id '
> +		/item [0-9]+ key \(/ {
> +			split($0, a, "("); split(a[2], b, " "); cur =3D b[1]; next
> +		}
> +		cur =3D=3D want && /drop_progress key/ {
> +			match($0, /key \([0-9]+/); obj =3D substr($0, RSTART + 5, RLENGTH - =
5)
> +			match($0, /drop_level [0-9]+/); lvl =3D substr($0, RSTART + 11, RLEN=
GTH - 11)
> +			print obj, lvl; found =3D 1
> +		}
> +		END { if (!found) print "ABSENT" }'

This one is a little too complex. Can the agent simplify it without=20
extensive awk scripts?

> +}
> +
> +root_level()
> +{
> +	$BTRFS_UTIL_PROG inspect-internal dump-tree -t root $SCRATCH_DEV \
> +		2>/dev/null | $AWK_PROG -v want=3D$s1_id '
> +		/item [0-9]+ key \(/ {
> +			split($0, a, "("); split(a[2], b, " "); cur =3D b[1]; next
> +		}
> +		cur =3D=3D want && /^[[:space:]]*level [0-9]+ generation_v2/ {
> +			match($0, /level [0-9]+/); print substr($0, RSTART + 6, RLENGTH - 6)=
; exit
> +		}'

Again, the same, please let the agent to use simpler solutions.

> +}
> +
> +s2_digest()
> +{
> +	$GETFATTR_PROG --absolute-names -R -d -m user.pad $SCRATCH_MNT/S2 2>&1=
 | \
> +		_filter_scratch | md5sum | cut -d' ' -f1

Again, you don't need xattr. In fact inline file extents can be easily=20
verified just using md5sum along.

> +}
> +
> +_scratch_mkfs -n 4096 >> $seqres.full 2>&1 || \
> +	_notrun "mkfs with nodesize 4096 failed"
> +_scratch_mount
> +
> +$BTRFS_UTIL_PROG subvolume create $SCRATCH_MNT/S1 >> $seqres.full
> +for ((d =3D 0; d < nfiles / per_dir; d++)); do
> +	dir=3D$SCRATCH_MNT/S1/d$d
> +	mkdir $dir
> +	(cd $dir && seq -f "f%04.0f" 0 $((per_dir - 1)) | xargs touch &&
> +	 seq -f "f%04.0f" 0 $((per_dir - 1)) | \
> +		xargs $SETFATTR_PROG -n user.pad -v "$pad") || \

And much easier to create inline extents.

> +		_fail "populating S1 failed"
> +done
> +s1_id=3D$($BTRFS_UTIL_PROG inspect-internal rootid $SCRATCH_MNT/S1)
> +
> +# S2 shares every block of S1, S1 owns them.
> +$BTRFS_UTIL_PROG subvolume snapshot -r $SCRATCH_MNT/S1 $SCRATCH_MNT/S2 =
\
> +	>> $seqres.full
> +$BTRFS_UTIL_PROG filesystem sync $SCRATCH_MNT
> +digest_before=3D$(s2_digest)
> +level=3D$(root_level)
> +echo "S1 id $s1_id root level $level files $nfiles" >> $seqres.full
> +[ -n "$level" ] && [ $level -ge 3 ] || \
> +	_notrun "S1 tree too shallow (level $level)"
> +
> +$BTRFS_UTIL_PROG subvolume delete $SCRATCH_MNT/S1 >> $seqres.full
> +drop_caches
> +
> +# First drop run: unmount once at least one root child has been dropped=
, so
> +# the saved drop progress is non-zero and at the root level.
> +for ((i =3D 0; i < 600; i++)); do
> +	$BTRFS_UTIL_PROG filesystem sync $SCRATCH_MNT
> +	read -r obj lvl < <(drop_state)
> +	[ "$obj" =3D ABSENT ] && \
> +		_notrun "subvolume deletion finished before it was interrupted"
> +	[ "$obj" !=3D 0 ] && [ "$lvl" =3D "$level" ] && break
> +	# dump-tree reads through the block device page cache, which goes
> +	# stale while the fs is mounted
> +	drop_caches
> +	sleep 0.1
> +done
> +[ "$obj" !=3D 0 ] || _notrun "subvolume deletion made no progress"
> +_scratch_unmount
> +echo "first run interrupted at drop key ($obj) level $lvl" >> $seqres.f=
ull
> +
> +# Resumed runs, each interrupted right away. The saved progress must ne=
ver go
> +# back to zero.
> +for ((i =3D 0; i < 5; i++)); do
> +	drop_caches

This drop_cache seems to make no sense as the fs is not yet mounted.

> +	_scratch_mount
> +	_scratch_unmount
> +	read -r obj lvl < <(drop_state)
> +	echo "resume $i: drop key ($obj) level $lvl" >> $seqres.full
> +	[ "$obj" =3D ABSENT ] && break
> +	if [ "$obj" =3D 0 ]; then
> +		echo "drop progress of the deleted subvolume reset to zero on resume"
> +		break
> +	fi
> +done
> +
> +# Let the deletion finish. With a reset drop progress this tries to fre=
e blocks
> +# still used by S2 again and the transaction aborts.
> +_scratch_mount
> +$TIMEOUT_PROG 600 $BTRFS_UTIL_PROG subvolume sync $SCRATCH_MNT \
> +	>> $seqres.full 2>&1

Don't do this, it just waste time.

The better way to wait for subvolume deletion is:

$BTRFS_UTIL_PROG filesystem sync $SCRATCH_MNT
$BTRFS_UTIL_PROG subvolume sync $SCRATCH_MNT

The first one will wake up the cleaner, the later one waits for the=20
deletion.
> +drop_caches

Again, why?

> +digest_after=3D$(s2_digest)
> +[ "$digest_before" =3D "$digest_after" ] || \
> +	echo "S2 content changed after deleting S1"
> +_scratch_unmount
> +[ "$(drop_state)" =3D ABSENT ] || echo "S1 deletion did not finish"
> +
> +echo "Silence is golden"
> +status=3D0
> +exit
> diff --git a/tests/btrfs/355.out b/tests/btrfs/355.out
> new file mode 100644
> index 00000000..4e4c5e98
> --- /dev/null
> +++ b/tests/btrfs/355.out
> @@ -0,0 +1,2 @@
> +QA output created by 355
> +Silence is golden

