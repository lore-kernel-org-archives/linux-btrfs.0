Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795013893;
	b=lPsuZK14RaMnfFXFVEszBywTEuuClKx+Id+z/vF1Pb6Vwyii4INFvdrCZstO0Vbq+vSR
	 ci4DRxlRog4eY2qZDpOFW8Bdi/3fP/PmG0l575d36L+KepmjrWYFsOpFQc7mDS8BDHZvd
	 lqG9rrgcG1lUAAS/XNFFGIXxvelt8N2u+9UaZ4OassLfhUdbOgF91y++PfccjxLG0uYMK
	 qV+I1myZA12Q3F2mk0ASMUSGS1IOd2x7OITBfcpyRgB8Xp2PWZPnSzLUcdxZCgmS0WU25
	 3ofjvGEt9mxMgzbH4loJXxh/oEUeJMf3uMR43pDXGmASbhJifwr3PWIWGLK85Cba38A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795013893;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:X-Mailer:
	 References:In-Reply-To;
	bh=Pp/RLPMZ3GifsKTDdh8Pk/uftsOfh5azJIs0J3c6Xr8=;
	b=j0fdHXh2t0vjR3pI32jMQwPGIBdkdaRPX9SSn0t14hC2WHDBfPZXFgiF3i8dwMu1gVkR
	 pzUpvVJltuOC/2lHgbBv5fqfGui7r8MTddVfonVAHbPR3VUFTtTa0PWrcQx/N4MvorJsJ
	 RPg95k8xsZgPmpYRiN/tYLK94iJTdk038baRvtAqoEum6dYawa2ddddRCoEkQk57rulx+
	 mvYjfvQue1AHphblU4t/TokpmVAenA+FWL3zzKwLDo0l/ZFeXHOvAIZxzpBcRy8NZ6Ys+
	 jY8HJHR9YWnKg1ihM5JkuLHVo3WjQxJafrlvyZYhLIboEjRJ0D76FsQBfleARQ2YM0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=WIynCKYl;
	arc=none smtp.remote-ip=209.85.221.46
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76B9F606A330
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Nov 2026 14:58:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 76B9F606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=WIynCKYl
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-48dfc0421d9so940360f8f.1
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Nov 2026 06:58:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795013892; x=1795618692; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Pp/RLPMZ3GifsKTDdh8Pk/uftsOfh5azJIs0J3c6Xr8=;
        b=WIynCKYls1N8nEyEmKDwpbFtK4fRYUUmPMeyj1Lc9KrBLr4DNDXRTqxqglZZe6Ifn/
         rnLkHwm2hphWg/c9Bfvobg9Xh3gOHmCC39W5EhYmE2vXc7oQ8QkoZqlQnR0DV/jsH1GX
         0zzmewpfcvfatXcXxZYAaoXNifblQeQTqV9d1MYWR9E61n5n3sGbMTxRnTnaL0nDt2oW
         nQRU8AFvYlvH+9vQ96dlbf/TUEFEwX2A0JC+XqUxCoPLcHF9R+OCRlpqai8JZglyJgPk
         qdEM9PuU3prps6Ygbz0r7hOM9uQF4f9gUmI0QuSofnln19TV9ZuOiZ8w6K8QMEHi7Fbn
         NPUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795013892; x=1795618692;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Pp/RLPMZ3GifsKTDdh8Pk/uftsOfh5azJIs0J3c6Xr8=;
        b=aZMuAtgFMkJBpkVG4fYuHLBSbnSVZlrbiIrQEJ+SVM77uOss7OFzTuBMisvpp0hqNs
         yrLz4TlP0orAQEpMmV//ctI8IHnbMZ/CSTkBvi5KifbiDSQvbK5unZefvL3T09ubJn4s
         hjOgBI+VbdiCkBdnP36M4iNLwJ08W04csQLknuex4dmCLsH1OjfyuZR3pko6m4YB2tLJ
         SGaDqurxOWFXdcNgg+9ybfuxpUwI/nsXLf+CK7UHeHS7AaVRVaXS392L6XdSKoLiwspg
         OGyYhrH12Q6+rcMaeSwW7Sh5KOkSKHy6A8e9vQz3z6JSG+YYrz48B2k23CiSAaX9wZun
         StaA==
X-Forwarded-Encrypted: i=1; AL+hErH5VPz4moAJgUDEqUaTvDOu0ME0q60ttpjOhjIWuFptRaCi4uT7k3jNKiYqax77uy8tpn3BZaJ2KcpNqg==@vger.kernel.org
X-Gm-Message-State: APuU4Z9mVMvcrzbr28A0MAr6n7fbKk3niPe+q8mj63kLSx60Z/Fyyu+j
	LTlGevTbliztLpfDd8EWnNgzcyu8HOmtrL2C0pgS15jVy3V7rD87bSRE
X-Gm-Gg: AZFdTZeWeYxSO01REkAEy1A51YYBYG4bEjrjHrkqZqyk+SlyBspOdKxH6wlYCQozaxn
	Llhmcglm7J74arw5Dh6H8BBkaFxZeydIP6TVoif2T5Tjdsn0UzdFnMcxx5qqQTNkIec4U1eulVW
	a8e7ko/Ie9NuN63Om8xHqw+ow0qQTmJ4gHEqxzXM/agnCWKxFuqyn8Gxd3I8hL3cT6TeDBRkITY
	RKDOqD8RBD6APoDnGPaP3nV1HCDpKT3IUdo4eCVehTlkc9aj4YD/JXUTTL2czbIceUVcaQaNyT7
	oRBsSP4GEYNO+suAHNRLWmmGS+h3eIlAfZHICUL3T2LW01aH4D4+wOD2IyQFCH/MuYL2XbyUHcK
	iEyFV0vfPkLJsCwIyCYHNGi6FQjRuzGqUtIXaBOg5V6dvig/x4bNsLUVN+l4V0NpDWAIsKSmI5a
	VHC0x1RxV7fPZzocgYtPhv/rmmCsdofd1ETDGExox6Dockr4CR0kd4lGGxsec19i6dNyZfMY0pa
	XnGPH7at5z65ewGGXeLHqDmZeCuiqUqcY8GmHgOOOWFFlW0aQ5QBlLzTxRlm4yVpJ2fIsAG8BcQ
	+xadrxyCRdOqwaYq1F7RG/G1m7beqvZrXi3vwzVwgP34Kvlrei6pdVQ7EC4QRmYWgQ==
X-Received: by 2002:a05:6000:2dc5:b0:4a7:7bec:e159 with SMTP id ffacd0b85a97d-4a84976942fmr1578019f8f.15.1795013891542;
        Wed, 18 Nov 2026 06:58:11 -0800 (PST)
Received: from localhost (mob-176-246-251-118.net.vodafone.it. [176.246.251.118])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4a65541f3b3sm5373344f8f.23.2026.11.18.06.58.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Nov 2026 06:58:10 -0800 (PST)
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
 boundary=9e0e009d1054760532dfbb31949a479f82968ef4509cbe81b751bd0d90dd;
 micalg=pgp-sha512; protocol="application/pgp-signature"
Date: Wed, 18 Nov 2026 15:58:02 +0100
Message-Id: <DMYFBDIV4Y08.35ZKR5G86U1H7@gmail.com>
Cc: "David Sterba" <dsterba@suse.com>, "Namjae Jeon"
 <linkinjeon@kernel.org>, "Sungjong Seo" <sj1557.seo@samsung.com>,
 "Alexander Viro" <viro@zeniv.linux.org.uk>, "Christian Brauner"
 <brauner@kernel.org>, "Trond Myklebust" <trondmy@kernel.org>, "Anna
 Schumaker" <anna@kernel.org>, "Chuck Lever" <cel@kernel.org>, "Jeff Layton"
 <jlayton@kernel.org>, "Konstantin Komarov"
 <almaz.alexandrovich@paragon-software.com>, "Paulo Alcantara"
 <pc@manguebit.org>, "Chris Mason" <mason@kernel.org>, "Yuezhang Mo"
 <yuezhang.mo@sony.com>, "Jan Kara" <jack@suse.cz>, "NeilBrown"
 <neil@brown.name>, "Olga Kornievskaia" <okorniev@redhat.com>, "Dai Ngo"
 <Dai.Ngo@oracle.com>, "Tom Talpey" <tom@talpey.com>, "Ronnie Sahlberg"
 <ronniesahlberg@gmail.com>, "Shyam Prasad N" <sprasad@microsoft.com>,
 "Bharath SM" <bharathsm@microsoft.com>, "Sergey Senozhatsky"
 <senozhatsky@chromium.org>, "ChenXiaoSong" <chenxiaosong@chenxiaosong.com>,
 "Darrick J . Wong" <djwong@kernel.org>, "Sean Smith"
 <defendthedisabled@gmail.com>, "Andrey Albershteyn" <aalbersh@kernel.org>,
 "Pedro Falcato" <pfalcato@suse.de>, "Amir Goldstein" <amir73il@gmail.com>,
 <linux-btrfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <linux-fsdevel@vger.kernel.org>, <exfat@lists.linux.dev>,
 <ntfs3@lists.linux.dev>, <linux-cifs@vger.kernel.org>,
 <linux-nfs@vger.kernel.org>, <linux-api@vger.kernel.org>
Subject: Re: [RFC PATCH v4 00/10] add provenance time (ptime)
From: "koraynilay" <koray.fra@gmail.com>
To: =?utf-8?q?Pali_Roh=C3=A1r?= <pali@kernel.org>, "koraynilay"
 <koray.fra@gmail.com>
X-Mailer: aerc 0.22.0-0-gc2f86b7abde3
References: <20261115180343.576773-1-koray.fra@gmail.com>
 <20261118142613.be3r3s6kobkkxnz4@pali>
In-Reply-To: <20261118142613.be3r3s6kobkkxnz4@pali>

--9e0e009d1054760532dfbb31949a479f82968ef4509cbe81b751bd0d90dd
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

On Wed Nov 18, 2026 at 3:26 PM CET, Pali Roh=C3=A1r wrote:
> Hello,
>
> I have just one issue with the userspace API. It does not allow me to
> figure out what is the source of statx btime field. If it is fs ptime or
> fs btime because this RFC implementation is mixing both fs ptime and
> fs btime into the statx btime field.
>
> I have feeling that this is quite a mess in API and I would like to see
> a clear distinguish between btime and ptime in the API, like there is a
> difference in the fs storage.
>
> If the btime is used for forensic analysis then somehow I would expect
> that the statx would not report / not fill changeable ptime value into
> the statx btime.

Hi, for native linux filesystems it will report ptime as PTIME and btime
as BTIME (also semnatically), for the windows-like ones that only have
ptime (semantically) I think it's reasonable to not expect btime to be
immutable, since they are meant to be used with other OSs who lack btime
semantics.

> It would be really helpful if the statx API on inode can differ between:
>
> 1. btime is present and its value is ..., ptime is not supported
> 2. btime is not supported, ptime is set to value ...
> 3. btime is present and its value is ..., ptime is set to value ...
> 4. both btime and ptime are not supported
>
> This should cover all cases of different filesystems and also allows
> userspace to do proper backup of both ptime and btime fields (if it want
> to do forensic analysis or anything else).

These should already all be covered by STATX_BTIME/PTIME and their
fields in struct statx, the only problems are windows-like filesystems,
which IMO shuold be handled as mentioned above.

Of course, as in the other discussion, I'm open to changing ptime
NTFS/exFAT/... support to remove btime altogether and only use ptime for
their own crtime if that's what wanted (I'm fairly impartial on this
specific issue).

Thanks,
koraynilay

>
> Pali

--9e0e009d1054760532dfbb31949a479f82968ef4509cbe81b751bd0d90dd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRJ2XvJtXGwULYEerQ0bnTtJTDoOAUCav28+gAKCRA0bnTtJTDo
OLZcAQD9pG1FmR7nRZDk2H08cDMhIho0sN3gDoVZ9UGDLNS9YgD/Z/0Ge9mFK15R
FEjSmx712gDHXRyPIeZ3A/k22EGaOQc=
=3Ms7
-----END PGP SIGNATURE-----

--9e0e009d1054760532dfbb31949a479f82968ef4509cbe81b751bd0d90dd--
