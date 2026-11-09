Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794232813;
	b=MAseNhFnTFyJT49/JONGUo3zhwp4y+hVeITEV9O7zVkqKws7htsuel5+bGIEMcN214cE
	 ZGluPT4FrNXdOZqwSbD6iAJWlH/pYchz8tNZmvjUSXv7c/1lMl6r2JTY8e9v2QSOFG8BL
	 JnONCj69MB+01iKj1kDKWzSFUd8CYdlgTAkNYOAgbr32WL2qJX89uB5bB6a37DilTFGrI
	 HFSj6RTCQ2mfczdsf68pHYnShr8CMOP7Fpo3l5/rQobDOT+GgQH8ofiE2c0xa6v+LtwBW
	 9q7gvTqEXDQ8GaYMj1I/V1uQsC+kkw7KoA1T2oBNdhumAgiIJlwckiZ7wr7BMZXy2gw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794232813;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:X-Mailer:
	 References:In-Reply-To;
	bh=Qj08Tru3q90mwREYm2hLwjpQ1d8T/ElrfKESX3hounE=;
	b=EHRBQJ218D5MT6sOqw+pUdcFtEryv/0sLRJ6uHZVlS9BEusgtMByIKAYqSc4WpvTAdQC
	 sRfN7sEuJ9pCXziTJPZTlAQNbJEePMxk3KpqFmaIguqV7uxKayUjVL5E/nKJEKsb3X3Nf
	 cQvPbCY4KoABU3OmRjJ4xJ0AhxJI2mHezVqwbH0HmWkvufmBiAQIehtACvxqVRxPLE2Ir
	 i7AJBOkel9m1lY3sXFyKN7gABjMmagDBoiy5IGU0UIZO3ntDD4h4wOxe3DyWZPg1r0Nq3
	 c6mLIXQuuSo9UoT/6bWyOiWC+zApHAWAO7Nx7d8gQS/4Q5SxGDluhci5WyCdRMdMImg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=t43998Qn;
	arc=none smtp.remote-ip=209.85.221.54
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57F05606A335
	for <linux-btrfs@vger.kernel.org>; Mon,  9 Nov 2026 14:00:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 57F05606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=t43998Qn
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-490c1d337d8so637304f8f.2
        for <linux-btrfs@vger.kernel.org>; Mon, 09 Nov 2026 06:00:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794232811; x=1794837611; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Qj08Tru3q90mwREYm2hLwjpQ1d8T/ElrfKESX3hounE=;
        b=t43998QnnNc3KCXSzJRp5nYW9XLpP7oeklxX8QwyLtaibyju1NFYrX0Aum85RZyLzN
         VnRUUTXQONh10hJjfS7of52eYQHHH5BNdhhIzFHdiRyac1vBnZ2sARf9NCukfs16/Gsx
         h72Z+z5dNM6WtX0RRidNu7l79qx4TshR+8k1rgXLK48z3o+XWN/f50Laqj4wybAZXuFQ
         o+5i+0bC9DK35gxcCiteTmftuI36TYjaVjTg7HBE1p5Y6C+SRDo3AS8XyP2xs0tfbWx6
         YDMajHGp2NuWgkh5VXHNYFc2c2GGl9KifyGEikJSlwWq3JduVPwL9XXkpHmBZu+pF9Xt
         H1/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794232811; x=1794837611;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Qj08Tru3q90mwREYm2hLwjpQ1d8T/ElrfKESX3hounE=;
        b=OY3I6+IXt6JMUjCOPqGRg60IxkPxA6mpaK9TfJD8kINjdkpoVdg2xqk2lKrzrOcQI+
         lcBlaYQhfcqbBuOjoFEEnrWgXzcE5odGSdRAbi+OOAw+kCPXxdRBiCWRRwYXOv1OeV0S
         MDyHYbO5QWKtUgBHxVOHtqMGakq4Eogjn0qQ1zjf+EGhZm0ADGO5Uh5Xi3Pb+znvBlqA
         xge27wVzPCVm7raxeMdsbf2eq1nGvNQwQyDhXs1NrR/mhEHdrTNkboJ6nVZuURNE9Wvt
         3tclDMQhKN+oSWkPVqqOME2Y1vHrA4cQBLlgOoKfGWJ9QYYfBOhL8qvymZknyn+thaCj
         CPoA==
X-Forwarded-Encrypted: i=1; AL+hErG4HkLpqqiiqCPWwylcGXNnVNLcp49vDyYy/4pVqLoDO3/azFN/mih2Ci2WeDyCu9ZJVVhCPMd9lCz0gg==@vger.kernel.org
X-Gm-Message-State: APuU4Z/p63e0SzjrKmpgtsRCHy2tHEVaiYT67cyGSzuzwX8AftQNSd7N
	AdPYrdq3KDZFIxGkhi1T7tmHZwOUvH4cUUV/jyiO129iLwdhQljsYZur
X-Gm-Gg: AYBFou068wrAwetsBPmB0GBIKJf2+vV7hH3MeugND8brryBk8MLcGmlGQtzFuTTvQZa
	cc9qCDRAM//bWFEKfsSPTTJyEhACDodEhgm+ouERy3UdDcsdMAwDwTDhoLcVFJ+i5gkWN0CvCkj
	S5mH4yj+rBi5Dm3NQ6dNzuK56u31lh6oaWY3N2m7ZuHrTmxRnS/7CYC2JTj/fezkaks2FF8GPtp
	2fE/4BTcdLt6VWFZPEz4KjffnWFrG6OE7xSuWAHexgqzQrmP3HGa0II8O+il9OdFWKxEzzOHYeR
	aLKKivibcPnyP/Z6A77PVoVPuAJKEFBUeVwdvAHgjzJAOGbZf9dTn4n6OL4HoyY1s2+G9KxE61J
	JalMFralqtHbSf3YHdFBTXq1ZE+NAgIpbror8BfAOxZ/Z2nhiS5RsvS4/TtbpKDQ85HMP0wYl3l
	JEz4nT4M6bd2dK+qGed7Sl4IN3nQqr2twfvNTcqlaDiRc9Ae5p0DdQ4CNJRoc6riUWrygrDJ3jr
	pWJE3yClLzTxfgtjfiwKZB9aHzgwQiVisiyCnTNA8rwQOFzYy1fZG4cGC7JJjSy8Yyt0adSkMCS
	dx6R5VWwL23QFyn9XZ9fSBbe03DjF3sMxQsq4Bb4VHuSip8ROGih3rk1P2ZWyPQ=
X-Received: by 2002:a05:6000:984:b0:48e:6dd5:30d0 with SMTP id ffacd0b85a97d-4958607a6a7mr7247961f8f.53.1794232806056;
        Mon, 09 Nov 2026 06:00:06 -0800 (PST)
Received: from localhost (mob-176-246-40-238.net.vodafone.it. [176.246.40.238])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49597d0a775sm11109545f8f.55.2026.11.09.06.00.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Nov 2026 06:00:05 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Content-Type: multipart/signed;
 boundary=92f8a953699a83d31cf7ddaaf00b8c75f9017743c904bd52c6971950bc57;
 micalg=pgp-sha512; protocol="application/pgp-signature"
Date: Mon, 09 Nov 2026 15:00:00 +0100
Message-Id: <DMQQG1D324U7.2945KG0ANDDJZ@gmail.com>
Cc: "David Sterba" <dsterba@suse.com>, "koraynilay" <koray.fra@gmail.com>
Subject: Re: [RFC] btrfs: forcing compression per inode via the compression
 property?
From: "koraynilay" <koray.fra@gmail.com>
To: "Sterling Windmill" <sterling@ampx.net>, <linux-btrfs@vger.kernel.org>
X-Mailer: aerc 0.22.0-0-gc2f86b7abde3
References: <557fae4a-3c08-43cc-924c-89d1f0f3896d@app.fastmail.com>
In-Reply-To: <557fae4a-3c08-43cc-924c-89d1f0f3896d@app.fastmail.com>

--92f8a953699a83d31cf7ddaaf00b8c75f9017743c904bd52c6971950bc57
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

On Mon Nov 9, 2026 at 2:51 PM CET, Sterling Windmill wrote:
> (Resending as plain text; the list rejected my first copy as HTML.
> Sorry for the duplicate to those on Cc.)
>
> Hi,
>
> compress-force can only be set for the whole filesystem. I would like
> to apply it to one subvolume and leave the rest of the filesystem on
> plain compress. Before writing a patch, I'd like to know whether this
> would be welcome and what form it should take.
>
> My filesystem (kernel 7.3.3, 10-device RAID10) holds both raw disk
> image backups and large, already-compressed video files, and these
> want opposite settings.
>
> The images need compress-force. I copied one image (about 60G of data
> in a sparse 249G file) three times with
> "cp --reflink=3Dnever --sparse=3Dalways". Sizes are from compsize:
>
>   mode                      extents   on disk   stored raw  zstd in->out
>   compress-force=3Dzstd:3     615,577     23G        11G      48G -> 12G
>   compress=3Dzstd:3 + prop    492,796     31G        27G      33G -> 4.6G
>   compress=3Dzstd:3           218,911     60G        60G     944K -> 296K
>
> "prop" is btrfs.compression=3Dzstd. The last copy ended up with
> NOCOMPRESS set. This is one image and one sequential write, so I would
> not read much into the exact percentages, but the property costs about
> 35% more space here than compress-force. I have not measured how much
> of that comes from the heuristic's sampling and how much from data
> that is compressible despite its byte distribution.
>
> The video pays for compress-force. An 82G file had 169,776 extents and
> read sequentially at 270 MB/s. After "btrfs filesystem defragment
> --nocomp" it had 666 extents and read at 622 MB/s. That works, but it
> has to be repeated for new files and it breaks reflinks.
>
> As I read inode_need_compress(), FORCE_COMPRESS is only ever taken from
> the mount option, and a property always goes through
> btrfs_compress_heuristic(). compress_file_range() already avoids
> setting NOCOMPRESS when prop_compress is set, so a per-inode force
> seems to need little more than this (hypothetical field, untested):
>
> 	if (btrfs_test_opt(fs_info, FORCE_COMPRESS) ||
> 	    inode->prop_compress_force)
> 		return 1;
>
> With that, I could mount with compress=3Dzstd:3 and set force on the
> backup subvolume, relying on the usual property inheritance.
>
> Questions:
>
> 1. Is a per-inode force something you would accept, or would you
>    rather see the heuristic improved for this kind of data?
>
> 2. What should the interface be? The per-inode compression levels
>    series [1] adds "algo:level" to the same property. Would a suffix
>    such as "zstd:3:force" be acceptable, or a separate property? How
>    much does the behaviour of older kernels reading the value
>    constrain this?
>
> 3. How should it interact with NOCOMPRESS? I assume setting force
>    would clear the flag and take precedence over it. The 2020 thread
>    on compress-force and per-inode settings seems to have left the
>    three-state question open:
>    https://lore.kernel.org/all/b92d0141-f68f-ce96-8099-e145ebc6f594@toxic=
panda.com/T/
>
> 4. Should this wait until the levels series is settled?
>
> If there is interest, I am happy to write the patch and test it on
> this data.

Hello, there is a github issue tracking this and a patch[2] (by me)
currently pending final review.

Can you see if [2] has the same behaviour you expect?

[1]: https://github.com/kdave/btrfs-progs/issues/329
[2]: https://lore.kernel.org/linux-btrfs/20261103194734.598182-1-koray.fra@=
gmail.com/T/#t

Best,
koraynilay

> Thanks,
> Sterling Windmill
>
> [1] https://lwn.net/Articles/1096934/



--92f8a953699a83d31cf7ddaaf00b8c75f9017743c904bd52c6971950bc57
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRJ2XvJtXGwULYEerQ0bnTtJTDoOAUCavHR4AAKCRA0bnTtJTDo
OI7LAQDc2jtghBHeTPNU6Et+fUIvDM0/w6mZNkm7PApLu/jnlgD/Ym4hQGX/A0lL
Ya1/Cj90A0d5b0riG1b/puPtwGzbrgY=
=HZwJ
-----END PGP SIGNATURE-----

--92f8a953699a83d31cf7ddaaf00b8c75f9017743c904bd52c6971950bc57--
