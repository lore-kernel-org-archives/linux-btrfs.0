Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28238441612
	for <linux-btrfs@vger.kernel.org>; Tue, 11 Aug 2026 12:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786452479; cv=none; b=U8SDMoPEHfNFMXC76oqlbleGcT8fq0iLuz+0cijUrBEgYBpoDYAAlcF9OpXLzN38q0Tk++j24yVZInRmYDTrbaFIeA5G8XnvaFYJvoSUfUPthVKMPdhzywCbdBrqRSSgA0ClzOi2LQ/yvgKjB2J38bUBgKBmDnrayPQqMrln+AU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786452479; c=relaxed/simple;
	bh=92PhfBsy6SCuTmTl8lwVgTd7IEnZKRnl+ALuul9dCgY=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:To:Cc:Subject:
	 References:In-Reply-To; b=L1uMZzSbIh93rr4hZLEBeLxOCgFOS1KAOc+VHrjubKaF7ILfeYS+T4czwAuO5dWrLeBVg20JaHQab0Ki9qXgGa4aiKwuAqIx41DMzanIP1E+3gEcc07PX3coDgIAQZSbzmb6I/H2tkHWC91PvBUED4oRsHMb61ZUFk+pqVnEgME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ONCoZ89r; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ONCoZ89r"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-47f7027ca11so1973840f8f.3
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Aug 2026 05:47:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786452474; x=1787057274; darn=vger.kernel.org;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-type:mime-version:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=EAQqvfMDl7qEWUapMHnEkHcfV+T0dvozg+L+bIueH2g=;
        b=ONCoZ89rGdDtbY97D93Xqef22X7bm9X7IXAxAX2atqZkZTsrOVs87n08x3D0pYGPYs
         RkLC4HQiQShp9bQgKJy2C3dykncRqI0dqXiM5ZTQMd9fmVj9S+2WKUc1VYfoOfevUz6o
         elBg3iSjGKY2cEpdv9ykRA3civMhRAzf1FZN4mWsSe+QMzB8OsNUfgHSByVE+sgH67Ym
         fLfQqDFjVzVbV2AHfCMWW5+WCGzOwq2Mox15ake4m4H3HeacbkDPWYDiwYWEPKTKLOvG
         l63jt3RhNb1UT1bMJzUX/ePpdzP8O2oVNmKX/pJ8OAO7g9+tdzIXbCMM/BV1j6osLnQE
         kgMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786452474; x=1787057274;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-type:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=EAQqvfMDl7qEWUapMHnEkHcfV+T0dvozg+L+bIueH2g=;
        b=Jk9DKOmHCOeDvEoG1MqIJoR1gpFdz+qD6rm5g4d5dZUaZwMt+SjsxS4DRK4AYRSTb/
         RsrIk/5vnx5zzgSBS1YHFOQG2/Iub6qkxUpKW3Fu8MtmyIcAX3LfSC++6qhQ6aqKF5IT
         8H8D0V91n9ehLWl9B0zmO/+N0/h+8D4oHyl72pCSnvOu1SW9hPcurCIkQyYXzpIsq1FC
         kRV+8BfbLDT0jA3sZJ7m3Dd9PoJ8GYnlDUJ83j0nL3x2InQVE3W2BRuu9fnTvjv64GTl
         Cwx/MLBgysjXdcA8bIkMj1bWJmU4RXJN2CNYkOminEoazI/HBdh6Xz3aWZ7IslK2QK28
         oB/w==
X-Forwarded-Encrypted: i=1; AHgh+RqlBuBcQoLa8Dfc1wdWXiWst67m68cKgyEj8uc3Dh566OaNxIKufSvv5hEtX2W2ykuZTOX6e+g9vbDanQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzQX3oCnCGHyzYXZsJgwW3xexsPhsEIgNb6+limXDogfV0SchQ9
	ZIYqnrN4EXZtYf48JzWcsgVbMs2gGN0rs7MrLBD8ZAXFLVwuqxQU5fPn
X-Gm-Gg: AR+sD11z0j8/QNp+sD64+wW4uq1dZBUWaLdWdtSqR2mfCW9ZCXCipkS02pfqRsLjB+q
	olMZ1E9kgiFBXUvFWTl6kuQpbAWXSSTf5Yh5gyuH4a7Si6MVSSxCUrqrXhCIob/PtZ/ptyXeDcW
	d22U4zGkhLZtY3v7CJBw32uRAUJ0dISRft5hJFcMa/yERtt+AfN2iKt9csTn1pa7Gf9HCcGTDng
	jw1xKw29Xs8oynHs0ckRjklQWuLzxyFZgmsStESJtd5xOCXHtEpSZO++RT32pKNV2qqYqkgrmB4
	+XOrQilZCGHWuVExlUKRKFAS7qTRaOEbz4IvGVD1VQSRLJrD+Ydaix1+yB3v8gBy9YBIHbl+LFo
	P+6J/+LahdSVWVcpHAo/Y7fP3Jgjr0a4Qjyeze5CThr3pi0hmmnjE8GwHutAXS38/RM1vZsA9xY
	wiMeq0OmynnwSmGdhcKtckOfS3T7dr9q/eJ09tmsT+Qnh5Izcc4JGJhP0KVr3puCRovbHjOL6IJ
	WeGA7o=
X-Received: by 2002:adf:e008:0:10b0:474:d7a5:4b7a with SMTP id ffacd0b85a97d-4814add9584mr4162443f8f.28.1786452474231;
        Tue, 11 Aug 2026 05:47:54 -0700 (PDT)
Received: from localhost ([2001:b07:5d26:7a6a:a8a:5bfa:f87a:3c1a])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4814a709624sm4630418f8f.22.2026.08.11.05.47.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Aug 2026 05:47:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed;
 boundary=64f6ec54eedd071b5675439a88427a0381d7f7d8f7e00041542c81c6765a;
 micalg=pgp-sha512; protocol="application/pgp-signature"
Date: Tue, 11 Aug 2026 14:47:46 +0200
Message-Id: <DKM4JPMUKHHP.W3EZW2ITPDZG@gmail.com>
From: "koraynilay" <koray.fra@gmail.com>
To: "Qu Wenruo" <wqu@suse.com>, "koraynilay" <koray.fra@gmail.com>, "Chris
 Mason" <clm@fb.com>, "David Sterba" <dsterba@suse.com>
Cc: "Zygo Blaxell" <ce3g8jdj@umail.furryterror.org>,
 <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2 3/4] btrfs: add per-inode compression levels in
 xattrs
X-Mailer: aerc 0.21.0-0-g5549850facc2
References: <20260809015054.779137-1-koray.fra@gmail.com>
 <20260809015054.779137-4-koray.fra@gmail.com>
 <870d7e1f-3e87-4eac-86fe-107af7336101@suse.com>
 <DKLRY9Q5SEI3.VUDASVYPW9MY@gmail.com>
 <a27ce424-d3a4-4a8f-bddc-40757b1d40a3@suse.com>
In-Reply-To: <a27ce424-d3a4-4a8f-bddc-40757b1d40a3@suse.com>

--64f6ec54eedd071b5675439a88427a0381d7f7d8f7e00041542c81c6765a
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

On Tue Aug 11, 2026 at 5:21 AM CEST, Qu Wenruo wrote:
>
>
> =E5=9C=A8 2026/8/11 12:25, koraynilay =E5=86=99=E9=81=93:
>>> I'd prefer to have a dedicated patch to set compress_level to the
>>> default value 0, as a proper bug fix as the first patch of the series.
>>>
>>> As you mentioned in the cover-letter, this is in fact fixing a bug in
>>> the old behavior (mismatched algo and level).
>>>
>>> So it's definitely worth a dedicated fix, so that we can backport the
>>> fix without pulling in the full series for older kernels.
>>=20
>> Ok so, after thinking about it more and bouncing ideas around (with Zygo
>> too) I realized one thing, that while it *is* technically a bug, I don't
>> think it's a bug worth backporting.
>>=20
>> My reasoning is simply that there is no use-case where the current
>> "buggy" behaviour would be damaging, as the levels get clamped to the
>> supported range anyway, while arguably there are (albeit very rare and
>> probably not very smart in the first place) use-cases where fixing it
>> could be somewhat (limitedly) damaging.
>
> To be honest, if the current behavior is not damaging, which I agree,=20
> then it's also not damaging to use the default level.
>
> After all, it's just a level change, which is never damaging.

Yeah, I meant that while both aren't damaging, option 3 would be a
*little* more damaging vs option 1 (as per https://xkcd.com/1172), since
with option 1 nothing can break at all (because no change would be made
on older kernels).
(For this I mean only the bugfix of course).

>>=20
>> More importantly IMO, doing this would allow us to explicitly explain
>> the currently undocumented behaviour in the btrfs-property(8) manpage as
>> "just so you know, for kernel versions < 7.x cross-algo level leakage
>> from -o compress was happening".
>
> Which also applies to option 3.

Option 3 would mean the behaviour can be different depending on the
kernel < 7.X having the backported patch or not tho, so we can't say
that with 100% certainty in the manpage, but it would need to also say
"this is true only if you don't have this specific bugfix patch, if your
kernel has it, then the behaviour is this other one".

>>=20
>>=20
>>=20
>> As for how to handle it after having support for levels in the XATTR,
>> option 2, aka leaking the compress level only if the algo matches, would
>> be the best imo:
>>=20
>> Example use-case:
>>=20
>> - /fs has various types of files, from media to git repos, that would
>>    benefit from the normal compress mount option;
>> - /fs also has big virtual machine disks, that have very compressible
>>    parts but also very uncompressible parts;
>>=20
>> using only `mount -o compress=3Dzstd:7 /fs` may mark the vm disks with
>> NOCOMPRESS as soon as an incompressible extent gets found, but setting
>> btrfs.compression=3Dzstd won't, as it will try to compress every extent
>> anyway[1].
>
> BTW, the default level is 3, so 7 is already trying to compress harder=20
> than default.
> (At least from the official man page)
>

Yes, I could've used 15 too, it was just an example of a non-default
level specified in the compress option that would then get kept for
specific inodes that have the property set without any level specified.

>> This way if the user intends to change the compress level for the whole
>> fs, they can just change the mount option, knowing that the new level
>> will apply to the (new) vm extents too, like it will for all other files=
.
>>=20
>> In this example "btrfs.compression=3Dzstd" and "btrfs.compression=3Dzstd=
:0"
>> would behave the same, which means the file's extent will get compressed
>> with zstd:7, but when the user remounts with e.g. zstd:15, they will use
>> this new level (only for the extents written from that point afterwards,
>> of course).
>
> I'd say, in this particular case, user should specify a different level=
=20
> for VM images, after the level support in XATTR, other than relying on=20
> the global mount option level.
>

But if the user wants to have that data be compressed in the same way as
the rest of the fs, they'd have to change the XATTR every time they want
to change the level.

>>=20
>> (I'm ignoring the case where the user wants to change the algorithm and
>> let the vms inherit it, as for this specific use-case that would likely
>> require a whole new feature/property to say "try to compress anyway but
>> not as much as compress-force" and probably most people use zstd anyway
>> nowadays).
>>=20
>>=20
>>=20
>> After coming to this conclusion, I'm personally pretty satisfied with
>> this solution, while I wasn't as much with the other ones.
>
> Since my idea is pretty different on option 2 vs 3, and I do not find we=
=20
> can persuade each other, so I'll leave David to do the final call.
>

That's fair, at this point I thought about this so much all options have
pros and cons and I switched from preferring 3, to preferring 2, to now
preferring 1 a bit more (especially because of the docs clarity).

Thanks

Best,
koraynilay

--64f6ec54eedd071b5675439a88427a0381d7f7d8f7e00041542c81c6765a
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSgVimKafU5DQMcjcDmj22qf5IGXAUCansZ9AAKCRDmj22qf5IG
XHf4AP4zOu54oNpUTbJvUBqHeeqCsHqMFfxfhP0OvhBvHPf1ggEA9dw30d+op1BW
b8l/VzjCrCdr8T0QaXHMCYZhKrdCOAY=
=CIZ8
-----END PGP SIGNATURE-----

--64f6ec54eedd071b5675439a88427a0381d7f7d8f7e00041542c81c6765a--
