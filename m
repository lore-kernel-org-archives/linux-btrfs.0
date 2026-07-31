Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EACB2030A
	for <linux-btrfs@vger.kernel.org>; Fri, 31 Jul 2026 22:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785537473; cv=none; b=CY9PUX99EZ9vvX1rwa0lL4Zd7TXHstboY3vfIMZaGgDRbq0kZCoumi2WLps2rwH8EhR4eDKI4BBFCO6uLM6uVy3x/d0gV/Sz/bUmnI3aS/s9HN1ktdrLFQpqwoGDbkP0bGAqJ6WsjVr9DWwK7N5sQmmEjY9+nwO6MkT0X7GVL44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785537473; c=relaxed/simple;
	bh=Jnc9wMxXrLGwGJDgBlimje8LNXebVzFuAiGekjBMJnk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sBAGXMfA9lsfEJOuUrrRnTTTNFa5tddOSBNsUrnivkJ9i99MzHCylg+8JFNf5SAoO5VOWj24O0wC4W7xp6SQ5to7+2jyK0MwKIdXn/eFQCMUCt4YMYMbJRP5pMG1ZZ8gmGr3jOXfd+ioJGHeD8dlZlPF4Jj2py7Ob8VQ78M+GJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=VS6krAik; arc=none smtp.client-ip=212.227.17.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="VS6krAik"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1785537468; x=1786142268; i=quwenruo.btrfs@gmx.com;
	bh=bHJQAzRy8pcrsSIUx3GO51jUc76TBUpYY6miBkbIKv4=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=VS6krAikxUcCRifAh1KTBkfP319zjXKNT+fkk/19JEUfPBHA7oUbkfsXfarVdt8z
	 JAhYAvDfQLlEDRj2xVX8C6+4mEEgelrJSIPe2EJ9r8Z4JRcPavQvGIc825vTUPxtj
	 55L90JlxMzo/4tGagqx90N/TM8ie6eoLz9Rpu5b7xyM650hxh83LGPlXcUZzK3Sgt
	 4wSakUK0qvu9CQ8juHi1d1rYC5rsXvJ+zDkyL1F/qpfT7p21wWowNTRJuZsoktuAs
	 YUg9Z0IRlVbzjMNgTSPpzqFmEjpmlCt238kLpbcy2MQwu8P4UGF1/mYyAdfH9jJd+
	 UTozIMIMzF376dxizg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1Mof9F-1xINm62ifh-00aQ6o; Sat, 01
 Aug 2026 00:37:48 +0200
Message-ID: <ac494999-15b2-4543-836d-4584d548beb8@gmx.com>
Date: Sat, 1 Aug 2026 08:07:42 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fs: btrfs: fix zstd decompression of sector-padded
 extents
To: Cole Munz <Munzzyy1@proton.me>
Cc: =?UTF-8?Q?Marek_Beh=C3=BAn?= <kabel@kernel.org>,
 Tom Rini <trini@konsulko.com>, Simon Glass <sjg@chromium.org>,
 u-boot@lists.denx.de, linux-btrfs@vger.kernel.org
References: <9acf406b5e73fa83001e1951e883143e2afb8b2d.1785528314.git.Munzzyy1@proton.me>
 <3659c07e-7f73-460c-8391-e2b8508e2bd4@gmx.com>
 <-pmHXWS0jQjmnEICAo6l7i5Q5tFivBJ1Mm162qdIm_69a1gcfU0tBo4C-bfELAT1lCrGHRKlYr3_EcKwLFRX18SHErryHV_TCdz93esbQ30=@proton.me>
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
In-Reply-To: <-pmHXWS0jQjmnEICAo6l7i5Q5tFivBJ1Mm162qdIm_69a1gcfU0tBo4C-bfELAT1lCrGHRKlYr3_EcKwLFRX18SHErryHV_TCdz93esbQ30=@proton.me>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:5ylniR7Rny51Pqt2x4q01FLZ2yjyAOa8daQoycxZvC+yVJfrtjJ
 evOk2S+kDJUf/K2X6fI6ge3pjWw0JiekL2Rc1Q3Na4kG82Sa3L6glbtC6b5vVhZaRh4pV7L
 GWCE624LfW6W3AgUgXx81gTj4EBBHYj2xQd64Fxirpf9YWR6OoRd9cgEJCI4oOg2rMty6uK
 sCpRrPUrrsdOeaAsidp8A==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:FPGkUQ8JOcI=;RAo2Lie/Z/C0V7ZKisX/7bejL+u
 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



=E5=9C=A8 2026/8/1 07:56, Cole Munz =E5=86=99=E9=81=93:
> Hi Qu,
>=20
>> The ram_bytes described the decompressed size of a compressed extent,
>> except inlined extents, the ram_bytes should always be fs block aligned=
.
>>
>> I didn't see how things can go "larger than the extent's ram_bytes".
>=20
> You're right, and the commit message overstates it. For regular extents
> ram_bytes is block aligned and matches the frame's content size, exactly=
 as
> you describe. The case that actually fails is the one you carved out:
> compressed inline extents.
>=20
> For the inline path, current mainline compresses the whole first block:
>=20
>    run_delalloc_inline():
>      cb =3D btrfs_compress_bio(inode, 0, blocksize, compress_type, ...);
>=20
> so the page is zero-padded past EOF and the resulting zstd frame declare=
s
> frameContentSize =3D blocksize. But the extent item gets the unaligned s=
ize:
>=20
>    __cow_file_range_inline(inode, i_size, compressed_size, ...) ->
>      insert_inline_extent() -> btrfs_set_file_extent_ram_bytes(leaf, ei,=
 size);
>=20
> So a 1900-byte file stored as a compressed inline extent has ram_bytes 1=
900
> while the frame decodes to 4096. The kernel side never notices because
> fs/btrfs/zstd.c zstd_decompress() streams into out_buf and copies out at=
 most
> destlen. U-Boot's decompress_zstd() is the one-shot zstd_decompress_dctx=
(),
> and btrfs_read_extent_inline() sizes the destination with
> dsize =3D btrfs_file_extent_ram_bytes(), so the frame fails the whole-fr=
ame
> capacity check with dstSize_tooSmall - error code 70, which matches the
> "failed to decompress: 70" in the Armbian reports.

Thanks a lot! Now I see where the problem is.

>=20
> One data point from testing while chasing this: an image built with
> mkfs.btrfs --rootdir --compress zstd (btrfs-progs 7.1) does NOT reproduc=
e.
> For a 1900-byte file, progs writes an inline extent with ram_bytes 1900 =
whose
> frame also decodes to exactly 1900:
>=20
>    item 8 key (257 EXTENT_DATA 0) itemoff 15316 itemsize 423
>        generation 6 type 0 (inline)
>        inline extent data size 402 ram_bytes 1900 compression 3 (zstd)
>=20
> so mkfs-built images boot fine, and the failure only shows up on files
> (re)written at runtime through the kernel - which fits the Armbian patte=
rn of
> /boot scripts and overlays breaking after a package update touched them.
>=20
> I'll send a v2 with the commit message rewritten to name compressed inli=
ne
> extents as the failing case instead of the hand-wave about sector paddin=
g. If
> you'd like the on-disk evidence too, I can loop-mount a scratch fs with
> compress=3Dzstd, write an unaligned file, and include the dump-tree outp=
ut plus
> the frame header read from the leaf in the v2 cover.

Another thing is, since this bug only affects inlined extents, I'd=20
prefer to have the fix located inside btrfs_read_extent_inline().

So that we allocate a full block for decompression, then only copy=20
ram_bytes back to the destination.

With a mention about the limit during dbuf allocation inside=20
btrfs_read_extent_inline().

Thanks a lot of the explanation and fix,
Qu

>=20
> The fix itself stays in btrfs's decompress_zstd() rather than lib/zstd
> because for FIT/ximg/ubifs an undersized destination really does mean co=
rrupt
> input; only btrfs hands the decompressor a destination smaller than the =
frame
> on purpose. If you'd rather see it shaped differently - say, only engagi=
ng
> the bounce path for inline extents - happy to do that in v2 as well.
>=20
> Thanks,
> Cole
>=20

