Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.173
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793896255;
	b=DidxdnOJYWPHLUXO5W9E4m362e1I5uUyiC4C4WC0jqEL37uvK9gigGmyya3ybOf/DQZz
	 KafkWYTxe4s9AhT2rLbpDBt7c10ipyIh0ZlAwWirBuylf3I8G7ifDmfgW2xHGNCFmlEx4
	 GOB84w4rbU2vvQ/idxkQHFduMncMN219KwX8GrRPdAKINmReXgVswSLg3nQ1jhaPZRCr8
	 yb+0Usn5ZXR89mori03zcYOluOGv7iXdNBHenh6rOvCeI4efJM+P7dWDT+nmaMW/Czs4I
	 MktE1w00wK3EuHaF4nLOxctoMTuW4Uw0BstS2Sn8WQvng0ibLj+Bp+m68WgMe6DBGzw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793896255;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type;
	bh=m++lbtbW+jx0/zOIrauLxrlvqfIfwu1+PaNBC5GTXVY=;
	b=zRyECrGi6JyYWyul6cEM7STMzbNOcxb8LUT64qW2CUceIU0QH26Ij67kGBt1NMFgekfY
	 rOu53+JGqjpRVGynh3+djFwl+XQ0Oyw5HfFMHqmQ4QTQOr97aoyirrtjeZF67lG8OuI2T
	 ZDOTf6QmPsioWcqFrg2+jpFTUidyDMV22B/DJgl3XE18M0kUDzg9xMuQE3GrFSNe3ndF7
	 HLQLr+bE4BlZMEXw3br3nATCJS51AkzVYoT+XHBlS2LkBEHnlnQo3kG6Kr60vjcr7RJIC
	 lDTxiz3WYAp/WWE69PnTjvQ8jshARd7QWp3oNMFsx9fs9j36ucziWhdyfZhfOwnLbBw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=zyIsTTAw;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.173
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E53706082BC1
	for <linux-btrfs@vger.kernel.org>; Thu,  5 Nov 2026 16:30:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E53706082BC1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=zyIsTTAw
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-3acd239776cso18036911fa.0
        for <linux-btrfs@vger.kernel.org>; Thu, 05 Nov 2026 08:30:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793896253; cv=none;
        d=google.com; s=arc-20260327;
        b=UFcE4bhlM3bH4PkzLhx6uaJ3p2v1/A+vNj5zIwubZFof35CF1247EBKoc0rEUOkjbW
         PIuv2rck1HjgmCsymEQO6XU9QeCqx8/+2kbjCFjdMGNQg3WiG1yu6gV6EckAZNFFxyxy
         R7nNJ244Cfa8YIdWt3sFvnpWmH/xK9UnAY2DVbF0y5Q49v+xnRgfhYa0CLcVSF3CSXiC
         DIFRQY79vJFYXdGp+FeCW5HEFPgjfIYEdoG3hjGXz9+ZdzjS+N0Vhdh7LW9ojRl8uC1S
         24GBc5mglA7dVFLGzE8WgVirnTsP0gyhDiak3+5zPetw+l66lV28crvDTGgmDbYgBNKW
         EfbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=m++lbtbW+jx0/zOIrauLxrlvqfIfwu1+PaNBC5GTXVY=;
        fh=9HGCF2ngupw5DqCs9BGxCz+LgPCKiYZxftisCX+huJw=;
        b=CckGCNvrJd6bVFuJJy1oCtxPcOnhE2ru5rrsjmAQAFBR1KJhs2ETqOgUquCZORwzq3
         HiKTzyuf7Qv90hpcvJH9xDPN5W+nekJFExLxtLXaTANBm0+jBl/H0yZ9yu2FwkGOL5Lc
         7UnHk9L7oRU92ZaQ+Kh5jzkhmKtsdeP17oqGhNpvg6AExB8ALzdWyWoYEavBqa46nhS/
         4Rm2gCnW8vyQrN7U6218P6u5WOju9GhElaZNt4pw7sE+t6yIalVGPYHWeOUYTxq1q6u8
         8KKniV71gaPU5B1ztUgPX7QwM9MRsNnNBcLhjiL9DS/jKl4sqSYqUUspj+NASCdSGXpM
         IP0g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793896253; x=1794501053; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=m++lbtbW+jx0/zOIrauLxrlvqfIfwu1+PaNBC5GTXVY=;
        b=zyIsTTAwysi6OYGxkNSsuW+Vf+BTZ3qmvUv0/rrLt5r0tNNjHs62rsfLpP7Cz824bW
         StmA+wXHwCHkzXUZOs6jg8dW+QB2uN1bIYWL8uCEgsLqlWg+M4amDBGIdjoGc/USPxX/
         HIlRMFoSYH+utKW4VSh2UjTqNB6nFmQZjuFOJK5tnpeKcg00annn0tjIU8F0js3LgPWx
         llZwaX/Nw2BbN8B2i5OMuhR7DkKE7wUZ9ZdeFhOG7kUD0sLDCCGAZ6i/fo4lIe+41bRR
         fW8QfOAt8nx9EjYtkDaCz38TZCcx4Nr70nHiXmsCodDv2UqVOAD50veFlZKmBU5w2Z0A
         CShw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793896253; x=1794501053;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=m++lbtbW+jx0/zOIrauLxrlvqfIfwu1+PaNBC5GTXVY=;
        b=ApQGEgpWaDjkYAIoAvTnMoGkbJeRsU+Ext66gnV0B5yOoSlYUceZPZFFncVF9dWLkn
         qLb8GeOjk/28mKSOmGlo6LqfOs62mw8WyIV0yIkuKGtFUNr2zkrr5y4WUuk5/Kz+uocM
         jF6ad96WrNAmY0ND7u22vSQhh+9Y1L5ra+iwl25yUiZYDc+0MX1nGN3d/NLn+2i/wQS+
         /7lk69fPltMWF5uZlNp/ZASDcFe/s4QNPxa1oFT6rOEgm2Vn63hUBx0+5q1Ms8+9sSuL
         cjUy1OPnPQ3it+2oO9lihaSxTBZkvfcRlPh2uSonY3yYx2F12xrC4BcBohzF8DevAUWA
         fc3w==
X-Gm-Message-State: APuU4Z/nT7hi9S68exikfCelXWEuB6Mp0JCTkGMIXONeQxCumjMoy/7K
	UsKKQNKMfg3tM9wf+7ijofHHljudrXRlLUd/1y6kuLJhx+Vfcxc/FzDpszdJlU/aJuAkSMmRtXT
	7SkPGoI+ler4gdTt7NN6LeyX0FTG+UJ2f+WNy
X-Gm-Gg: AYBFou0GKrSfIS2vM5x+6aWPXnsasv7R4nsVjZGjIDmv35Dde9W5yD838Y+tYsc73gw
	g7vcJ3r342oAhxdNNJDSCFoY2CCI8Z2siOt9BzUizYibQmUYYKkyLxAP4VJT6GWZ/BHpqES41XU
	KIUWdLOaml2wrpYbroS8h7ih+6539GY7RGE8+cuk2udF7SCUoyNtpgOHl3Q2IWJnCZBdnM86wsv
	LXTE2xe7O9atUh8caTEK1Jtx/HOg3MVCN5e5vbdeIK07tkOMyqBl/8GPKCZML9CPE1AvM/S9C6N
	PXgRawc7Jtj3zrmsOrySbYHgaFjWs5zqwc7fR0Lm56e6KajLs8P8fK3BDD3MZp4bGRRanE160aI
	6Em+sXWp96ge7Qt2mJ/yXrz8cRVkpGIHOPqY5NMT+CgkxaYEKAL8le1G/qftBAKUoVvXbC5eYJT
	E7HhIxEdRvDsnhsARipP3263NZDQoTI+/pn1wfZfH2H7//HxB3UHifiNt8mlty1HfiVywqvg==
X-Received: by 2002:a05:6512:3c8e:b0:5bf:a5c1:d11 with SMTP id
 2adb3069b0e04-5bfd957cd9amr6846522e87.64.1793896252713; Thu, 05 Nov 2026
 08:30:52 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <CAD=K2o-BBqh+ikgfD732Cb3M1Xx48QGw3kTFsP5iSgH1mkr0wA@mail.gmail.com>
 <ca6f02ee-8b39-4e90-9006-a6f0606e26f8@wdc.com> <CAD=K2o_-NwLNpvNE+OreAmsvX+izzZnb2R1nCBV0gDf6fH=kmw@mail.gmail.com>
 <904615c7-003a-4158-922d-c57dee9a3ecf@wdc.com> <CAD=K2o_vLPSvm4Qzi8y4t5ay+Na9GNk2t5a3iMO3NYJvwodKDQ@mail.gmail.com>
 <CAD=K2o8xFgYBHMim-KqMysV+Tec9LEUbo6jfD6R-GOAU8N8K4w@mail.gmail.com>
 <CAD=K2o8kWgTRqBBw1sRfO2fopqQOLfdeX61h=OFPMST=Wdo+KQ@mail.gmail.com>
 <30a6e871-8578-4d27-bb0a-679b94fb7f92@wdc.com> <CAD=K2o9LbeJUcb0xefwVx-rC5udLNLwqouO8pqFB0R+rWQvHng@mail.gmail.com>
 <CAD=K2o_MwSF_XS=iRu8GMPhH2Sn6t3bsKLm5BLOjZ34tV4aRvg@mail.gmail.com>
 <CAD=K2o82LSzq9CN3mQxfoByGCteSLCXXetjnxLGQaQv+8gC6-A@mail.gmail.com>
 <8d2e8334-8a6a-4bb9-9c78-a126be7d94d1@wdc.com> <CAD=K2o8CTZOPQ1iMTi2+zirKtQdY3bS5Dz9KMAamyid6Lf9QbQ@mail.gmail.com>
 <1f4f5514-b20c-40d7-a87c-911276a5e661@wdc.com>
In-Reply-To: <1f4f5514-b20c-40d7-a87c-911276a5e661@wdc.com>
From: Jochen Philipp <a2jphilipp@gmail.com>
Date: Thu, 5 Nov 2026 17:30:41 +0100
X-Gm-Features: AclHuK856nRI95T-Na5gt3czimW7Tm2wMjvcGeS-bMXiYqcII30JpEZ0gtbVdjc
Message-ID: <CAD=K2o_A4HE7SwjTGJWr4cKFmu-OtJcLXQ2w=XFJDYGnOSbD-Q@mail.gmail.com>
Subject: Re: Subject: zoned: transaction abort with -EAGAIN (-11) on
 host-managed SMR (WD HC670), fs forced read-only
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: linux-btrfs@vger.kernel.org, Naohiro Aota <Naohiro.Aota@wdc.com>
Content-Type: text/plain; charset="UTF-8"

Hi Johannes,

I've sent you a download link for the full zone report and the
complete kernel log (all three aborts, 7.2 and 7.3) off-list.

Thanks,
Jochen

Am Do., 5. Nov. 2026 um 17:09 Uhr schrieb Johannes Thumshirn
<johannes.thumshirn@wdc.com>:
>
> [+CC Naohiro ]
> On 11/5/26 4:19 PM, Jochen Philipp wrote:
> > Hi Johannes,
> >
> > sure, I'll leave it untouched.
> >
> > I had sent you the full report off-list as an .xz attachment,
> > I suspect it got caught by a mail filter. Here's the condensed
> > version instead.
> >
> > Zone state summary:
> >
> >     1918 zcond: 0(nw)
> >    30387 zcond:14(fu)
> >   159343 zcond: 1(em)
> >      128 zcond: 4(cl)
>
> Thanks. I'm a bit puzzled why we have CLOSED zones, I was under the
> impression that a FINISH set's the zone to FULL not CLOSED. I'll have to
> re-read SCSI ZBC for answer to this.
>
>
> This is different from your problem (which is holes in the metadata
> write stream). If you could upload the full report somewhere that would
> be great. Also if you still have the full dmesg that would be awesome as
> well.
>
> Thanks,
>
>      Johannes
>
>
> > All zones that are neither empty, full nor conventional
> > (line number = zone index + 1):
> >
> > 4097:  start: 0x040000000, len 0x040000, cap 0x040000, wptr 0x001ad8
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 27890:  start: 0x1b3c40000, len 0x040000, cap 0x040000, wptr 0x03fff8
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 28076:  start: 0x1b6ac0000, len 0x040000, cap 0x040000, wptr 0x03fff8
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 28136:  start: 0x1b79c0000, len 0x040000, cap 0x040000, wptr 0x03fff8
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 28152:  start: 0x1b7dc0000, len 0x040000, cap 0x040000, wptr 0x03fff8
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 28273:  start: 0x1b9c00000, len 0x040000, cap 0x040000, wptr 0x03fff8
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 28275:  start: 0x1b9c80000, len 0x040000, cap 0x040000, wptr 0x03fff8
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 28318:  start: 0x1ba740000, len 0x040000, cap 0x040000, wptr 0x03fff8
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 28319:  start: 0x1ba780000, len 0x040000, cap 0x040000, wptr 0x03fff8
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 28372:  start: 0x1bb4c0000, len 0x040000, cap 0x040000, wptr 0x03fff8
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 28376:  start: 0x1bb5c0000, len 0x040000, cap 0x040000, wptr 0x03fff8
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 28377:  start: 0x1bb600000, len 0x040000, cap 0x040000, wptr 0x03fff8
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 28400:  start: 0x1bbbc0000, len 0x040000, cap 0x040000, wptr 0x03fff8
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 28435:  start: 0x1bc480000, len 0x040000, cap 0x040000, wptr 0x03fff8
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 28516:  start: 0x1bd8c0000, len 0x040000, cap 0x040000, wptr 0x03fff8
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 28524:  start: 0x1bdac0000, len 0x040000, cap 0x040000, wptr 0x03fff8
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 28556:  start: 0x1be2c0000, len 0x040000, cap 0x040000, wptr 0x03fff8
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 28641:  start: 0x1bf800000, len 0x040000, cap 0x040000, wptr 0x03fff8
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 28642:  start: 0x1bf840000, len 0x040000, cap 0x040000, wptr 0x03fff8
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 28649:  start: 0x1bfa00000, len 0x040000, cap 0x040000, wptr 0x03fff8
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 28721:  start: 0x1c0c00000, len 0x040000, cap 0x040000, wptr 0x03fff8
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 28727:  start: 0x1c0d80000, len 0x040000, cap 0x040000, wptr 0x03fff8
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 28728:  start: 0x1c0dc0000, len 0x040000, cap 0x040000, wptr 0x03fff8
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 28752:  start: 0x1c13c0000, len 0x040000, cap 0x040000, wptr 0x03fff8
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 28895:  start: 0x1c3780000, len 0x040000, cap 0x040000, wptr 0x03fff8
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 28957:  start: 0x1c4700000, len 0x040000, cap 0x040000, wptr 0x03fff8
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 29030:  start: 0x1c5940000, len 0x040000, cap 0x040000, wptr 0x03fff8
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 29308:  start: 0x1c9ec0000, len 0x040000, cap 0x040000, wptr 0x03fff8
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 29331:  start: 0x1ca480000, len 0x040000, cap 0x040000, wptr 0x03fff8
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 29332:  start: 0x1ca4c0000, len 0x040000, cap 0x040000, wptr 0x03fff8
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 29395:  start: 0x1cb480000, len 0x040000, cap 0x040000, wptr 0x03fff8
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 29428:  start: 0x1cbcc0000, len 0x040000, cap 0x040000, wptr 0x03fff8
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 29432:  start: 0x1cbdc0000, len 0x040000, cap 0x040000, wptr 0x03fff8
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 29450:  start: 0x1cc240000, len 0x040000, cap 0x040000, wptr 0x03fff8
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 29528:  start: 0x1cd5c0000, len 0x040000, cap 0x040000, wptr 0x03fff8
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 29690:  start: 0x1cfe40000, len 0x040000, cap 0x040000, wptr 0x03fff8
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 29696:  start: 0x1cffc0000, len 0x040000, cap 0x040000, wptr 0x03fff8
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 29705:  start: 0x1d0200000, len 0x040000, cap 0x040000, wptr 0x03fff8
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 29727:  start: 0x1d0780000, len 0x040000, cap 0x040000, wptr 0x03fff8
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 29792:  start: 0x1d17c0000, len 0x040000, cap 0x040000, wptr 0x03fff8
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 29885:  start: 0x1d2f00000, len 0x040000, cap 0x040000, wptr 0x03fff8
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 29921:  start: 0x1d3800000, len 0x040000, cap 0x040000, wptr 0x03fff8
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 29938:  start: 0x1d3c40000, len 0x040000, cap 0x040000, wptr 0x03fff8
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 29939:  start: 0x1d3c80000, len 0x040000, cap 0x040000, wptr 0x03fff8
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 30029:  start: 0x1d5300000, len 0x040000, cap 0x040000, wptr 0x03fff8
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 30038:  start: 0x1d5540000, len 0x040000, cap 0x040000, wptr 0x03fff8
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 30081:  start: 0x1d6000000, len 0x040000, cap 0x040000, wptr 0x03fff8
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 30083:  start: 0x1d6080000, len 0x040000, cap 0x040000, wptr 0x03fff8
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 30155:  start: 0x1d7280000, len 0x040000, cap 0x040000, wptr 0x03fff8
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 30156:  start: 0x1d72c0000, len 0x040000, cap 0x040000, wptr 0x03fff8
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 30196:  start: 0x1d7cc0000, len 0x040000, cap 0x040000, wptr 0x03fff8
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 30291:  start: 0x1d9480000, len 0x040000, cap 0x040000, wptr 0x03fff8
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 30307:  start: 0x1d9880000, len 0x040000, cap 0x040000, wptr 0x03fff8
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 30355:  start: 0x1da480000, len 0x040000, cap 0x040000, wptr 0x03fff8
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 30410:  start: 0x1db240000, len 0x040000, cap 0x040000, wptr 0x03fff8
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 30524:  start: 0x1dcec0000, len 0x040000, cap 0x040000, wptr 0x03fff8
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 30538:  start: 0x1dd240000, len 0x040000, cap 0x040000, wptr 0x03fff8
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 30576:  start: 0x1ddbc0000, len 0x040000, cap 0x040000, wptr 0x03fff8
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 30637:  start: 0x1deb00000, len 0x040000, cap 0x040000, wptr 0x03fff8
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 30720:  start: 0x1dffc0000, len 0x040000, cap 0x040000, wptr 0x03fff8
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 30754:  start: 0x1e0840000, len 0x040000, cap 0x040000, wptr 0x03fff8
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 30764:  start: 0x1e0ac0000, len 0x040000, cap 0x040000, wptr 0x03fff8
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 30861:  start: 0x1e2300000, len 0x040000, cap 0x040000, wptr 0x03fff8
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 30939:  start: 0x1e3680000, len 0x040000, cap 0x040000, wptr 0x03fff8
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 30961:  start: 0x1e3c00000, len 0x040000, cap 0x040000, wptr 0x03fff8
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 31006:  start: 0x1e4740000, len 0x040000, cap 0x040000, wptr 0x03fff8
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 31007:  start: 0x1e4780000, len 0x040000, cap 0x040000, wptr 0x03fff8
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 31029:  start: 0x1e4d00000, len 0x040000, cap 0x040000, wptr 0x03fff8
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 31160:  start: 0x1e6dc0000, len 0x040000, cap 0x040000, wptr 0x03fff8
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 31161:  start: 0x1e6e00000, len 0x040000, cap 0x040000, wptr 0x03fff8
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 31218:  start: 0x1e7c40000, len 0x040000, cap 0x040000, wptr 0x03ffc0
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 31219:  start: 0x1e7c80000, len 0x040000, cap 0x040000, wptr 0x03ffc0
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 31226:  start: 0x1e7e40000, len 0x040000, cap 0x040000, wptr 0x03fff8
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 31280:  start: 0x1e8bc0000, len 0x040000, cap 0x040000, wptr 0x03fff8
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 31281:  start: 0x1e8c00000, len 0x040000, cap 0x040000, wptr 0x03fff8
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 31375:  start: 0x1ea380000, len 0x040000, cap 0x040000, wptr 0x03fff8
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 31478:  start: 0x1ebd40000, len 0x040000, cap 0x040000, wptr 0x03fff8
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 31632:  start: 0x1ee3c0000, len 0x040000, cap 0x040000, wptr 0x03fff8
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 31659:  start: 0x1eea80000, len 0x040000, cap 0x040000, wptr 0x03fff8
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 31660:  start: 0x1eeac0000, len 0x040000, cap 0x040000, wptr 0x03fff8
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 31711:  start: 0x1ef780000, len 0x040000, cap 0x040000, wptr 0x03fff8
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 31783:  start: 0x1f0980000, len 0x040000, cap 0x040000, wptr 0x03fff8
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 31834:  start: 0x1f1640000, len 0x040000, cap 0x040000, wptr 0x03fff8
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 31901:  start: 0x1f2700000, len 0x040000, cap 0x040000, wptr 0x03fff8
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 31966:  start: 0x1f3740000, len 0x040000, cap 0x040000, wptr 0x03fff8
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 32010:  start: 0x1f4240000, len 0x040000, cap 0x040000, wptr 0x03fff8
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 32028:  start: 0x1f46c0000, len 0x040000, cap 0x040000, wptr 0x03fb00
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 32050:  start: 0x1f4c40000, len 0x040000, cap 0x040000, wptr 0x03ffc0
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 32053:  start: 0x1f4d00000, len 0x040000, cap 0x040000, wptr 0x03fff8
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 32118:  start: 0x1f5d40000, len 0x040000, cap 0x040000, wptr 0x03fff8
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 32119:  start: 0x1f5d80000, len 0x040000, cap 0x040000, wptr 0x03fff8
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 32121:  start: 0x1f5e00000, len 0x040000, cap 0x040000, wptr 0x03fff8
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 32156:  start: 0x1f66c0000, len 0x040000, cap 0x040000, wptr 0x03fff8
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 32261:  start: 0x1f8100000, len 0x040000, cap 0x040000, wptr 0x03fff8
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 32312:  start: 0x1f8dc0000, len 0x040000, cap 0x040000, wptr 0x03ffc0
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 32330:  start: 0x1f9240000, len 0x040000, cap 0x040000, wptr 0x03fff8
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 32331:  start: 0x1f9280000, len 0x040000, cap 0x040000, wptr 0x03fff8
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 32365:  start: 0x1f9b00000, len 0x040000, cap 0x040000, wptr 0x03ffe8
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 32367:  start: 0x1f9b80000, len 0x040000, cap 0x040000, wptr 0x03fff0
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 32393:  start: 0x1fa200000, len 0x040000, cap 0x040000, wptr 0x03ffe0
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 32394:  start: 0x1fa240000, len 0x040000, cap 0x040000, wptr 0x03ffe8
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 32441:  start: 0x1fae00000, len 0x040000, cap 0x040000, wptr 0x03fff8
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 32442:  start: 0x1fae40000, len 0x040000, cap 0x040000, wptr 0x03fff8
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 32444:  start: 0x1faec0000, len 0x040000, cap 0x040000, wptr 0x03fff0
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 32445:  start: 0x1faf00000, len 0x040000, cap 0x040000, wptr 0x03fff8
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 32446:  start: 0x1faf40000, len 0x040000, cap 0x040000, wptr 0x03ffc0
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 32447:  start: 0x1faf80000, len 0x040000, cap 0x040000, wptr 0x03ffc0
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 32448:  start: 0x1fafc0000, len 0x040000, cap 0x040000, wptr 0x03ffc0
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 32449:  start: 0x1fb000000, len 0x040000, cap 0x040000, wptr 0x03ffc0
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 32451:  start: 0x1fb080000, len 0x040000, cap 0x040000, wptr 0x03ffc0
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 32452:  start: 0x1fb0c0000, len 0x040000, cap 0x040000, wptr 0x03ffc0
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 32453:  start: 0x1fb100000, len 0x040000, cap 0x040000, wptr 0x03ffc0
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 32454:  start: 0x1fb140000, len 0x040000, cap 0x040000, wptr 0x03ffc0
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 32455:  start: 0x1fb180000, len 0x040000, cap 0x040000, wptr 0x03ffc0
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 32456:  start: 0x1fb1c0000, len 0x040000, cap 0x040000, wptr 0x03ffc0
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 32457:  start: 0x1fb200000, len 0x040000, cap 0x040000, wptr 0x03ffc0
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 32458:  start: 0x1fb240000, len 0x040000, cap 0x040000, wptr 0x03ffc0
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 32459:  start: 0x1fb280000, len 0x040000, cap 0x040000, wptr 0x03ffc0
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 32460:  start: 0x1fb2c0000, len 0x040000, cap 0x040000, wptr 0x03ffe8
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 32461:  start: 0x1fb300000, len 0x040000, cap 0x040000, wptr 0x03ffc0
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 32462:  start: 0x1fb340000, len 0x040000, cap 0x040000, wptr 0x03ffc0
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 32463:  start: 0x1fb380000, len 0x040000, cap 0x040000, wptr 0x03ffc0
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 32464:  start: 0x1fb3c0000, len 0x040000, cap 0x040000, wptr 0x03ffc0
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 32465:  start: 0x1fb400000, len 0x040000, cap 0x040000, wptr 0x03ffc0
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 32466:  start: 0x1fb440000, len 0x040000, cap 0x040000, wptr 0x03ffc0
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 32467:  start: 0x1fb480000, len 0x040000, cap 0x040000, wptr 0x03ffc0
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 32468:  start: 0x1fb4c0000, len 0x040000, cap 0x040000, wptr 0x03ffc0
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> > 32769:  start: 0x200000000, len 0x040000, cap 0x040000, wptr 0x001ad8
> > reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
> >
> >
> > The full report (191776 lines, 24 MB uncompressed) is available
> > if you need it - just tell me how you'd prefer to receive it.
> >
> > Thanks,
> > Jochen
> >
> > Am Do., 5. Nov. 2026 um 16:05 Uhr schrieb Johannes Thumshirn
> > <johannes.thumshirn@wdc.com>:
> >> On 11/5/26 2:48 PM, Jochen Philipp wrote:
> >>> Hi Johannes,
> >>>
> >>> small update: my distro has meanwhile shipped a new kernel,
> >>> I'm now running 7.3.1-202.nobara.fc44.x86_64 .
> >>>
> >>> I haven't tested with it yet, the fs is still mounted read-only
> >>> via fstab. Should I try a read-write mount with the new kernel,
> >>> or do you want the on-disk state left untouched until you've
> >>> looked at the zone report?
> >> If it's ok for you please leave it untouched an send me the results of
> >> the zone report.
> >>
> >>
>
