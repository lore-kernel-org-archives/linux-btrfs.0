Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C6E02741B5;
	Mon, 18 May 2026 22:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779144468; cv=none; b=Pbu5ZpLKt7cOBpbbq6b5cK7XAaiQNdjQsO8vg2bwAsO1DTAx+C/D/cQpJFe308o2TcKRsmMsOUtX81QpDYKKNfzyIaWQo4dABqW7xkHmWMVirBZxTITeiHsjK90IBIoh78ra3xCDJvMgN4kcYnpPzAcwRwduUcYjgGzl70UkA2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779144468; c=relaxed/simple;
	bh=I2IYPi6qnR9FO4dt7mjOM5tU/2XBFRIfFkyqxVMo7Ec=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=ikdAFUvZPYnX9r+bBeebtPMwreI2OURIN1gPISo4xlHfTuhAh6NfbPiTKl/6rlzHG6a6TmdJ6NuSdKE4qtOi7lzFkGe2ld5hzS4OBiZWl+US+DBeGXICwqgOZl8GxxGlYMWZjyrXfO3ZdQCVG2JKp+0WeWWZXF8+r+5BLsmh0vU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=YYvTGd0b; arc=none smtp.client-ip=212.227.15.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="YYvTGd0b"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1779144464; x=1779749264; i=quwenruo.btrfs@gmx.com;
	bh=9ObVVRTDFLpxCJmuJwUBepGuT31rnlGAdwKsdf9CU8o=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=YYvTGd0bzyWpEkg5YQM86DJl1eWDfzHDVHXVZAKeR1tA3EaYBFwclSA9ke8eXGDc
	 Jg1g1jb0st9jPL+qHTtOZeU/Lsvkn/v6byQowp9T0l+BKFMdFEAnQpHal0K0VY190
	 ToTOnS0d9XkX99i6GxuaSRbDhJZdMnnEhrTYZ6L0S94DJUvwsMuWYFtF0q7OQB9sR
	 6tL/LjXL/5uCuGVtNCuNfhhPZkLIp0eFg+PUD+59I7pP2yd+d2H3cwAGFCgkspZh0
	 K38dgZPI8zGFuZZLA1I1xi9Y5mcopJ0x+lU6sIQJBF4P/cAKxzfZZyf6KC+ZIpNoi
	 AscuJxiyYxOKSE/9aQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx004
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1N3KPg-1xO7On3koc-015sgP; Tue, 19
 May 2026 00:47:44 +0200
Message-ID: <1fc3200f-779f-4ca8-8035-24497e127a42@gmx.com>
Date: Tue, 19 May 2026 08:17:41 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: add test for BTRFS_IOC_GET_CSUMS ioctl
To: Mark Harmstone <mark@harmstone.com>, linux-btrfs@vger.kernel.org,
 fstests@vger.kernel.org
References: <20260320125223.90171-1-mark@harmstone.com>
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
In-Reply-To: <20260320125223.90171-1-mark@harmstone.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:IVf8TScuIl6iyJ3cnFxtJpeMjcNH5s/ip+Z4y3wUgBWxTQ57KWc
 Ew0HH4DoUZVxdYbOgFi6j8qvJiUbYjeY/ZB82g5tB1jrsEMGrYFfzMxWoqcc0GYJaQ/SD6y
 MsHDqsX5KaIskvMV2NXtEXGwo/0DbPQ+d0J/jBT+qUJRX2KsqQGex1Zr+mhNfGW/8VnPvBS
 MQSD9MN10eChUm87yDUIw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:Qpj1cfv1NN4=;jZqGeTpXWKz91qbXaXFwtXOiYuX
 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
 4VXBbkkBwrwgCJw==



=E5=9C=A8 2026/3/20 23:22, Mark Harmstone =E5=86=99=E9=81=93:
> Test the new BTRFS_IOC_GET_CSUMS ioctl which retrieves file checksums
> from the kernel's csum tree. The test covers:

I think it's a great idea to have a dedicated test case for the new ioctl.

Although that ioctl has some changes and a refresh will be appriciated.

>=20
> 1. Regular data extents returning HAS_CSUMS with checksum data

Maybe also test an inlined extent?

> 2. Holes returning SPARSE entries
> 3. Preallocated extents returning SPARSE entries
> 4. Buffer continuation (small buffer forcing multiple calls)
> 5. Checksum consistency (identical data produces identical csums)
> 6. Querying past file data returning SPARSE

I guess we may also want some corner cases related to the last block:

- The file size is not aligned
   * Test get csum of the last block
     Which should return the csum of the last full block.

   * Test get csum beyond the last block
     Which should return ZEROED.

- The file size is aligned, but the last extent is truncated
   E.g. the file size is 4K, but the data extent is 16K (e.g. reflinked)

   * Test get csum of the [4K, 8K)
     Which should return ZEROED

> 7. Precomputed values
>=20
> Signed-off-by: Mark Harmstone <mark@harmstone.com>
[...]
> +
> +# Test 7: Verify checksum values against precomputed values for all alg=
orithms.
> +# Uses explicit -s 4096 as the expected values are precomputed for 4096=
-byte
> +# sectors. Write three sectors: all 0x00, all 0xff, all 0xaa.
> +echo "=3D=3D=3D Test 7: precomputed csums =3D=3D=3D"

One idea to get rid of the pre-calculated csum is, to read out the data=20
block by block from the file (as long as the file size is aligned to=20
block size), then calculate the csum.

For xxhash/sha256/blake2, the checksum can be calculated in user space=20
and should match the one in csum tree.

It's only crc32c that we do not have a handy tool in user-space.

Thanks,
Qu
> +_scratch_unmount
> +for csum_algo in crc32c xxhash sha256 blake2; do
> +	echo "--- $csum_algo ---"
> +
> +	_scratch_mkfs -s 4096 --csum $csum_algo >> $seqres.full 2>&1
> +	_scratch_mount
> +
> +	case "$csum_algo" in
> +	crc32c)
> +		expect_00=3D"98f94189"
> +		expect_ff=3D"25c1fe13"
> +		expect_aa=3D"4ed66b65"
> +		;;
> +	xxhash)
> +		expect_00=3D"ac869b6f32d8bbdb"
> +		expect_ff=3D"10af2cb94282321f"
> +		expect_aa=3D"e35ac2d66625ceaa"
> +		;;
> +	sha256)
> +		expect_00=3D"ad7facb2586fc6e966c004d7d1d16b024f5805ff7cb47c7a85dabd8b=
48892ca7"
> +		expect_ff=3D"f47a8ec3e9aff2318d896942282ad4fe37d6391c82914f54a5da8a37=
de1300c6"
> +		expect_aa=3D"c622005493c4cb75f3e08eda4cc0bfe172e2c5eeca661ec4908c5490=
fc3d6994"
> +		;;
> +	blake2)
> +		expect_00=3D"686ede9288c391e7e05026e56f2f91bfd879987a040ea98445dabc76=
f55b8e5f"
> +		expect_ff=3D"1e23d2944a4523734ef9c8b536eed668fa8a99b272bfc10988864e1e=
f135197d"
> +		expect_aa=3D"8337334ce71745681a24e9aa409fdf85fe4081242c39815ccf266df6=
d33355a2"
> +		;;
> +	esac
> +
> +	$XFS_IO_PROG -f \
> +		-c "pwrite -S 0x00 0 4096" \
> +		-c "pwrite -S 0xff 4096 4096" \
> +		-c "pwrite -S 0xaa 8192 4096" \
> +		$SCRATCH_MNT/file7 >> $seqres.full
> +	sync
> +
> +	output=3D$($GET_CSUMS $SCRATCH_MNT/file7 0 12288)
> +	echo "$output" >> $seqres.full
> +
> +	got_csums=3D$(echo "$output" | grep "^HAS_CSUMS" | \
> +		awk '{for(i=3D4;i<=3DNF;i++) printf $i " "; print ""}')
> +	got_00=3D$(echo $got_csums | awk '{print $1}')
> +	got_ff=3D$(echo $got_csums | awk '{print $2}')
> +	got_aa=3D$(echo $got_csums | awk '{print $3}')
> +
> +	pass=3Dtrue
> +	if [ "$got_00" !=3D "$expect_00" ]; then
> +		echo "FAIL: 0x00 sector csum $got_00 !=3D $expect_00"
> +		pass=3Dfalse
> +	fi
> +	if [ "$got_ff" !=3D "$expect_ff" ]; then
> +		echo "FAIL: 0xff sector csum $got_ff !=3D $expect_ff"
> +		pass=3Dfalse
> +	fi
> +	if [ "$got_aa" !=3D "$expect_aa" ]; then
> +		echo "FAIL: 0xaa sector csum $got_aa !=3D $expect_aa"
> +		pass=3Dfalse
> +	fi
> +	$pass && echo "csums verified"
> +
> +	_scratch_unmount
> +done
> +
> +echo "=3D=3D=3D done =3D=3D=3D"
> +status=3D0
> +exit
> diff --git a/tests/btrfs/343.out b/tests/btrfs/343.out
> new file mode 100644
> index 00000000..85582c24
> --- /dev/null
> +++ b/tests/btrfs/343.out
> @@ -0,0 +1,33 @@
> +QA output created by 343
> +=3D=3D=3D Test 1: regular data =3D=3D=3D
> +HAS_CSUMS
> +has csums
> +complete
> +=3D=3D=3D Test 2: hole =3D=3D=3D
> +HAS_CSUMS
> +SPARSE
> +HAS_CSUMS
> +complete
> +=3D=3D=3D Test 3: prealloc =3D=3D=3D
> +SPARSE
> +complete
> +=3D=3D=3D Test 4: continuation =3D=3D=3D
> +SPARSE
> +incomplete
> +HAS_CSUMS
> +complete
> +=3D=3D=3D Test 5: csum consistency =3D=3D=3D
> +csums match
> +=3D=3D=3D Test 6: past data =3D=3D=3D
> +SPARSE
> +complete
> +=3D=3D=3D Test 7: precomputed csums =3D=3D=3D
> +--- crc32c ---
> +csums verified
> +--- xxhash ---
> +csums verified
> +--- sha256 ---
> +csums verified
> +--- blake2 ---
> +csums verified
> +=3D=3D=3D done =3D=3D=3D

