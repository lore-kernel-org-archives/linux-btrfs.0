Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.178
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793950591;
	b=kD52bryw2oTQgBVr3riNrvEdsptW1H7pmmFOnIVSJuLafs4zaEj6/ZJiyKnOfl0V86+H
	 lYb23Ce+vaSQvjHb727ImsVG0lcLYrwkxHDVl91/slArSqpdyT5c87OB2ulsy/bVL8cwz
	 OS1Ec493pYYWczx+XJ0rczg4Zda1qUWoQPLF4m6zXszAjESJD4ufIpgvB83XZ/Mq8Kkku
	 Ya7UpH3oAK8YKK1/TcqUJ9guW9iZ19cSwrnzS0fE/LpIzgtHDk0aYD0YMElZksCVY+iBl
	 CDeuZJF7+WGi11O62GptcwuSDxF0lN8t+XAa01IJWAflOBcCMuvPgpYrc4yFM4HPGog==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793950591;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=rnwsAzOj5Vo2t/+s6sDdCgWJcHLME/rRpOM3mbq39Zs=;
	b=ntfstW4iEawNQ24m4bmxoAxiThOWipQwaRLaY+grvQqYh4W+x3G1OwyKSKle2VCUeQcJ
	 HaX4bbWRd5dDlFsYL7XDq6yytJM8fBT3QPsyMTMvb27L/yUiL3dt5KDiUuhYfhWQQtTss
	 tLkchYuSz9tAKcJ9Se0kpyrxMduLJ0czNQeL11E/FxnochnzT8oyyrjq+Pao5s6Eu5r/D
	 9wwO3jNhf8eyLDQdmfZYs9sBngqn6WHIdqywfsZn/0LXuD2PfbCFmpcpBH8Kczd/3M7fP
	 icKfVWnUVYN0mtFSrelURmrOMPUGoYZxzvlnhBsXIrxW49jrSAbwhU0b3VWiUDhLRng==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Qb6dfzL1;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.178
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE65F606A326
	for <linux-btrfs@vger.kernel.org>; Fri,  6 Nov 2026 07:36:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AE65F606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Qb6dfzL1
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-3aae7df0971so2765931fa.1
        for <linux-btrfs@vger.kernel.org>; Thu, 05 Nov 2026 23:36:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793950589; cv=none;
        d=google.com; s=arc-20260327;
        b=ZEE4WuSkFuHMworbTC/U2jpgDQnGPflEuir5TBdUr0nZJ+YDUowMsCahqFHjb7T7+8
         mOQdbGVWiozxbWZ5RVRSPrPoeWi7drGGQas9E0SANL0kuFXKVkcvsQpe3DDdRceU7zOV
         1Jmgz/CdUO2FI9vOChKnY0JFLenZ+2JG3adNBx3KkBGIeJKNvUnapP1rpk5W2vMvPbzl
         eIb8bzYcAfKG6h1doiUDgjlRVksVM0Fb2PCefvI7b9B9RGMgCQ6F3vGaY3Yo5IhgtoOW
         wlA4UZi1R1rL0XbLwaLSrwtSodujzUSZfN6uOezBUeWKHQVRh5VdVinNiWBDk8O1VinP
         UiFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=rnwsAzOj5Vo2t/+s6sDdCgWJcHLME/rRpOM3mbq39Zs=;
        fh=Ryv6U4rqcXpHy/yHXQJOY3AJlZUAHi3ysgTcMDA4sCQ=;
        b=l3HO6bXr+aayVkIqoBzHT+tNxtjOz+7UHq/oCIQb/ZVzWR7y5JntRa0+Zaus6ta9Dj
         hDgLJMZz0yu4Z5nNitdQX/xQLq+4hK+V66iAl8zGbA/DAw6DIC7tixrNih5I8i4oZtLg
         2ziRpqUIv5/SeNy9P/Mw2eTpFFHe4l10jWXSh86z+nv3dwKlEajTEwxLefJI7AGAn0Kv
         DqEJKgr0uOcfyUhCGwZPydf2Ss/oQl9HlcD1sAjJVHlB60ZUANQ6SKq5EwUh572lxyw5
         FRqzB96dv0yRDyeKT3XWqhFIhkO6eCKaA8SMzbCGVb2b32mr/HWx5JdlLsuMH9H+xfU4
         UCCw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793950589; x=1794555389; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rnwsAzOj5Vo2t/+s6sDdCgWJcHLME/rRpOM3mbq39Zs=;
        b=Qb6dfzL1mHvZBcjKRs/ohxVr+gQrUHSWr9RvCQ8ajbE07YSP/TdAzs6VZNrX/lcE9z
         /EZQ5ztHLmhgHxEkxZi4tiEXgmUqOQXJJemiH6NsJbmOWRIxl/dh2VXcD18obPSah1kj
         JCahW952k4ytDJp+QDlnJVAAWxsSeL4G4NQvsslfIyL6d99Z+2zdpnnscp08FBku5SgU
         aMLhlOl7oaC5uuD3efI7horSEZDjcQ9RbDdaEK5KycF5y5lw2ItrBWTdSLGb6xBhfdG3
         OdO7cxHcJCU4RQdimmBIpLGFxRwYG+bojZXNyKhi6pfrdo7ltZbLbxIeghPdNjxwZ+Tf
         ieoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793950589; x=1794555389;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=rnwsAzOj5Vo2t/+s6sDdCgWJcHLME/rRpOM3mbq39Zs=;
        b=mton2/CSIgTZS2FSPu3Ojg/OjcDk8Vf2QS4iFzvZ3ml/6kkxERLa9k/vsvZeqwQce7
         Ms7WPk+TM2hP5ySiirqS4EURqFxUSTnoa+6o3qE4DFRGaEEVEh6d3z+pNZV1SaMgNv6b
         cQo1GcPQ4GgljkD326dBDcWFPLFZKe+i74D2dxuRvMrZl0PpfKw0xyBtbgIcmOERh2YT
         AO7UWm7dDKIUPs1OlvMHmeaO/VNEauK4dYokJNbp4KUNl9v3x68yOlWcq5jmwMnEzmBv
         1LGmFmcSMa6eIaqGR7iK06Qu7fjLIZMvLOqne4l1lpnkg1dEIO1YD2AJqy/41B02lcAB
         kIPw==
X-Forwarded-Encrypted: i=1; AKwUvBzbNSyHQB9arm08G77OkGnF0y/feKv6oAM2ZgavmoXvZBMhPzMBWGi8m+5NgHjg4Jr0Qidzy3ozm5KiEA==@vger.kernel.org
X-Gm-Message-State: APuU4Z9c4eyJT8ppN5ufZVtggmAfgO49c/DKK+SBrha7rJCAKZyJKmK1
	F+k04rgmonMkT4X1RP0FBfippOzNIFgihi2TZV7PQ9yVs0hewLnT6QjXkIfpwSKmfICzYjBq5Fg
	8XgwvEXBwp9RKx4Dako44FsVwvzB4Dw4=
X-Gm-Gg: AYBFou3e3zkCAP74x+zbH1ziiIR/3uKgNXh5tAvfDYld6WvWl2pdYQhKsg0xa/1bcZt
	ElkoV+e51ESArD2znm1+hTwfISlQRRv8GclwIVyd1mkYlc8JHSOSMTTQkXmhFOscdAz4SfMdVJ+
	mRaZWaHkWbe60IezGJZt3EtLEkJXBCKfLw1jbIQyjrqiXUkm7JJP62cYivAWV7slO/WDntU6kNu
	L2hNcqCRgN0WdGAXvHUexuJ8dq2x3ffKqZO1Rn1YU/neZ+CPNTgiEcpivGGtiHCPdCWBC3u4qlc
	8nPre58mfc/24etUhoEYYBOSlzvJ/4hgCntFTE5cHTBCkAWeaYrfyqsUmsJgp7tAGsuBft72dqf
	thfzZsGewx1dTHq9fYD+tXSYfvFoq/KHRffyepFLpmWT7m5sFElhktctVKuktzKZqMfkG+vLMgg
	aHw0fdhdmPdnWqpd/MRJhm7zFn4lRQVEmgt2cqHuK/3Ozmhd7bbp1pH1Eid32SDYwSmZAAHg==
X-Received: by 2002:a05:651c:198e:b0:3ac:e24f:aa11 with SMTP id
 38308e7fff4ca-3acf3a1f995mr3405951fa.7.1793950588710; Thu, 05 Nov 2026
 23:36:28 -0800 (PST)
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
 <1f4f5514-b20c-40d7-a87c-911276a5e661@wdc.com> <CAD=K2o_A4HE7SwjTGJWr4cKFmu-OtJcLXQ2w=XFJDYGnOSbD-Q@mail.gmail.com>
 <5e929ec6-4641-4990-b910-489e34550ba7@fygo.io>
In-Reply-To: <5e929ec6-4641-4990-b910-489e34550ba7@fygo.io>
From: Jochen Philipp <a2jphilipp@gmail.com>
Date: Fri, 6 Nov 2026 08:36:16 +0100
X-Gm-Features: AclHuK8kdWzBkIgRgEqH3IJFSaBNITR504ne8DL7qSFlOzMzSPTU9RsJydNSD08
Message-ID: <CAD=K2o8EAtV0p1dXBBXvrjw99zOb_XJUZ=Zz+1BjwVmhsScMDA@mail.gmail.com>
Subject: Re: Subject: zoned: transaction abort with -EAGAIN (-11) on
 host-managed SMR (WD HC670), fs forced read-only
To: Dongjiang Zhu <zhudongjiang@fygo.io>
Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>, linux-btrfs@vger.kernel.org, 
	Naohiro Aota <Naohiro.Aota@wdc.com>
Content-Type: text/plain; charset="UTF-8"

Hi Dongjiang,

thanks for reaching out - yes, I'm willing to give it a try.

Johannes asked me to keep the on-disk state untouched while he
looks at the zone report, so I'd like to coordinate with him
first: Johannes, are you fine with me testing Dongjiang's series
on this fs, or do you need anything else from the current state
before I do?

For testing I can set up a separate machine (bare metal, no
out-of-tree modules), so my main system isn't affected and
switching kernels is easy. I'd move the drive over there.

Two practical questions, since I've never built a patched kernel
for testing:
- Which base should I apply the series to (e.g. 7.3, or a
  specific btrfs branch)?
- Is there a git branch with the series applied that I could
  use instead?

Thanks,
Jochen

Am Fr., 6. Nov. 2026 um 03:24 Uhr schrieb Dongjiang Zhu <zhudongjiang@fygo.io>:
>
> Hi Jochen,
>
> Maybe this patch series could help:
> https://lore.kernel.org/linux-btrfs/cover.1787887776.git.zhudongjiang@fygo.io/
>
> Would you be willing to give it a try?
>
> Thanks,
> Dongjiang
