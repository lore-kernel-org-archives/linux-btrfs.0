Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.45
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793664408;
	b=Ii6Ju0jBz7yN41BIFgSr2AXNhkAypuKo1EykfW+6QLETwSiUfSWNSYH4dmMRs11lfudK
	 i4k6Bg00vf9yLuehb6iJiOjzfTKwcDSjvebNX/Cn5Z/dLUjo3FPqweQbJl9e9zkesp0Tk
	 6e8lN+Dz/jCRCIAZ0VY+Z29p4tRDANDRrWGV5Q2u8rEqBLszrM/snJzfN0+Zmf23e6gzU
	 41Cz3ZUNJQ/WEedJ5H0Z/kpMsDRcqx9/llLZkCPkKtCKJHVhwOItOVjvfsbQ5Kw/Hnrw7
	 NKWtLlMzQpbVGUuYIxKbZCUChU6sFuk/rO45Ouyhdz/hIgcTmdPm0mdMSNyfHHFsSdQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793664408;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=SVB21/AnViTS4HODdzSPipK9V+HrHwv1zpOfO/G5LWc=;
	b=ZWXZhCoP4+uGTorNKEpA0xdR0CY4OwcHkG0/zt6sc3vASNXT4ORCUgHwZrUZ98lw9EKN
	 bI5QNhgiuGslRq8I5JCD2cS53XBTfyUeqnjh+3piZIizJJ1PWqC4W+atDX3uUmdLjq9EP
	 Qml4vIgPqlzOOgk4DGgOHNgezdL5V1BUOQs479NFe04wUlNFBoPSWdNip5DbTCSXk9dME
	 9RWs0+CznreIGBACpTyfDHpDaKrGoBMl17YFwaivAXxacEYDBtAm3uBzwITLyTMoPDLDD
	 /VfW6UUruyKQE82/keX5YnsJzk4eRNzm6LMkfLuGDAWlERK5FGkXZ4DI7QKksi6lnjA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=asu.edu;
	spf=pass smtp.mailfrom=asu.edu;
	dkim=pass header.d=asu.edu header.i=@asu.edu header.a=rsa-sha256 header.s=google header.b=A9AYJOa3;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.45
Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEF13606A327
	for <linux-btrfs@vger.kernel.org>; Tue,  3 Nov 2026 00:06:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EEF13606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asu.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=asu.edu header.i=@asu.edu header.a=rsa-sha256 header.s=google header.b=A9AYJOa3
Received: by mail-ot1-f45.google.com with SMTP id 46e09a7af769-823e4047037so2659433a34.2
        for <linux-btrfs@vger.kernel.org>; Mon, 02 Nov 2026 16:06:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793664407; cv=none;
        d=google.com; s=arc-20260327;
        b=R8PnyDt5EFO0USFUH2WuJoqY3a6GJN5XcZb3vualfoavKMysOa0OK0w6cC+Fkw6euO
         nrk9A3cKJftvXCNULlGxfvvhaF6a/ZmAOBI7ZX08lnsBrHbly6WsZ2sc4wlge/L4pOSh
         iDpcZtUHrrT57hNmeb1JJHN4AY5yJsD0sueWhSAFcr25ci/ZTgwaAPW55+y85zDgFoGP
         H2r972M9NCELgBcBqtPnhhHrvRzo2uvbdN+lXW6LG32O6Qdo04gM4ohhGU3ihVYD/oqB
         yRzJpDgFpuSrg/kYwWeFyBvwGUwqS6lfjCaIWbX2Vtow2lL/2z/U23OgFJAm8Ah+p9gD
         3Otw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=SVB21/AnViTS4HODdzSPipK9V+HrHwv1zpOfO/G5LWc=;
        fh=7k/L3ILcnoMVP8SULw5mkZOUN6bhvvoGtwoBxISIZAU=;
        b=cHFHdhswSEmBa/SqXiDpdx+Jud2AlXAQph3VwcwyB/GnksFkWRTFJePLDekAwdIv4N
         oiyLOw0zDrDDukaS+D/ry2WaVCDu7CSQUwyKqcDASYqu0srErw4w4evdyRq31iYnt1g5
         9bPqIns65orEYff5/dtNjB4LwvVaTfMqptVJI9egwnL7Qe7uXcIfB6AALXXRqxUFDqCI
         8+8BOYqlPTRK2oQEeHVxaSq6FeLDB3W0Izv4a+SqIMGhCwBNQCDmdUtz7MYlVSQyInXg
         POY5pW2SdSe6AAmBsihIcSzByp9mI0e3JlYxBOlsSW9Bo1gy7alNioQ+rYWJdDg9GUpM
         fb+w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=asu.edu; s=google; t=1793664407; x=1794269207; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=SVB21/AnViTS4HODdzSPipK9V+HrHwv1zpOfO/G5LWc=;
        b=A9AYJOa3OGIZGbLtbJdt52wFiu+w2TsukdRAIXTFBdhL+8WjOqhl2uEHZBnfOiyDjr
         NrG8Bx7Jc4C9u+1UmWYEcGOgSIBex2U2q59kfZqimvxo4HbZxJUgmbzrzHH5TMiwGhpN
         YqoGY2hrNEPDVddMK3JBTOt48ALpVPKJx8C/sDBy5CYQgZLE3pPguGKf+8eQ/LJgOUm0
         IdHBDVhD4Kiz6KkkYUaXQ43m/vTS5zJl2RV9CdJ7cHhfsacNXt1ylAZJRGlOyBqas3JW
         m+RLKdlC4RfSJC5QCOcRc3PqtCFbvSzdL/9EQrvXTqYAtMgF8cxhz0VWygfoJEuqTBJt
         Gv3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793664407; x=1794269207;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SVB21/AnViTS4HODdzSPipK9V+HrHwv1zpOfO/G5LWc=;
        b=c3ZTHwb/o6K6Z6C5AZtm1slvzzS4Eag7oa2BRaMVSGv++yrMKRfp+4ptJUzedW6FAM
         BYuKhDTONCZLY46dGPjCmdRvwJncPgG5GUZTdGwcQCkyz7nJbs1VshXsY3uu9Bo6jOtJ
         Mq18Eq4KadUIABoW/CtqxEkD6zOfYTn3Jdqo5J3TUPmAW/j8diZ04CdWzX49I73rVPlP
         pp9rMJY61KS+DidEgecQLtE7iKnS0A98PjfjtPoOesTruueL+baBgfVE8GbOXQsloSx7
         nwoEcpmLWADgW8TM7dSr8pzk1xzp0owfcJTx7ZZ+SCRgohDVW5o9oAsq8NYqpDs2qcgS
         7Rdw==
X-Forwarded-Encrypted: i=1; AKwUvBzkxEaM1Kn1NGD5WvlyzQrVBO6wydt/zzqUtesxSny835sqK7IcSMXhEAXJ1ldxuWLqOTWfbu8gxuMk2w==@vger.kernel.org
X-Gm-Message-State: AFq9FYLEr1dqaiAr6QgTT5mS3jPOVOAW8QQF8m4C18BEAncyRAgj+U0B
	KjEm3O5vDTvJ1/JpT9OxUIjD/G7HjLcR9/7mN+FPWLlMu8RZP1W05JiiK7tM8yAiKPuxef1P/4t
	B+lfo86Vnwm7udJfiidgXnbmBzS+oUh3yaKZ0AfMf
X-Gm-Gg: AYBFou2EHZnQBBPJF9i9+JHh5s3u49hIXzAW2lOrj7gF+69AGBys2XRMdd29lyNjBde
	DOvzV8jFlMFaR/6f7VJSaEzQWubhgzBDcAVPW56osT9RX2BWr5wgNXld1iQtB0Svnp1u0nUG3UK
	APSZWlt051ei++759Cm4MRT0i36SefzuaZbLsHlK8SuT6Xla7ENNrgQwq3sQDcN4dyEOdz6vrl9
	iyC1DlgYYk2bG47X6b3XywhNEGzqm/3LDFEU/4tTmf1kkwhSDqdoZI7khy1OLzuas8i5B6TkIy0
	5qOTvSjbxgDIN/9k+8BNWBUewy9SUbYSxn6UKg+zcDmHbb+snZR8Q6yIr25aD3nHrfKEovxWxM5
	iiBAlIYbEKxnQgZtTIUBqzg9rq9dk47xGWxxL0Q==
X-Received: by 2002:a05:6808:2218:b0:53c:2a2e:8650 with SMTP id
 5614622812f47-5640df72f37mr7638020b6e.34.1793664406884; Mon, 02 Nov 2026
 16:06:46 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261102233041.310900-1-smish149@asu.edu> <a12db355-d677-4656-9715-a537980e928a@suse.com>
In-Reply-To: <a12db355-d677-4656-9715-a537980e928a@suse.com>
From: Siddharth Mishra <smish149@asu.edu>
Date: Mon, 2 Nov 2026 17:06:36 -0700
X-Gm-Features: AclHuK8WPFKvIkjfRdxOUVR8P4RPk3-TpPeZ4GJPv7cbB6VWYA4Uv9k68vyPW_I
Message-ID: <CAKpDGtncRzRwkv6yfxNvMHOMSk_Ejg_HJHEs3k9TVNb_6mArvQ@mail.gmail.com>
Subject: Re: [PATCH] btrfs: do not check support for an invalid sectorsize
To: Qu Wenruo <wqu@suse.com>
Cc: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Siddharth Mishra <brightprogrammer@asu.edu>, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 2, 2026 at 4:42=E2=80=AFPM Qu Wenruo <wqu@suse.com> wrote:
> > diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> > index 8e8fb942d..b348591f8 100644
> > --- a/fs/btrfs/disk-io.c
> > +++ b/fs/btrfs/disk-io.c
> > @@ -2520,9 +2520,7 @@ int btrfs_validate_super(const struct btrfs_fs_in=
fo *fs_info,
> >                    sectorsize > BTRFS_MAX_METADATA_BLOCKSIZE)) {
> >               btrfs_err(fs_info, "invalid sectorsize %u", sectorsize);
> >               ret =3D -EINVAL;
> > -     }
> > -
> > -     if (unlikely(!btrfs_supported_blocksize(sectorsize))) {
> > +     } else if (unlikely(!btrfs_supported_blocksize(sectorsize))) {
>
> If you want to change this, you should touch all callsites.
> Not only this one, but every unlikely() branch to return immediately.
>
> I do not like the ad-hoc fix just be cause you can trigger an ASSERT().

Thanks for the response. I'm assuming you mean I change the whole function
to return -EINVAL on the first failure it encounters and not just the secto=
rsize
because it reached an ASSERT. Given that, I'll send a v2 right away where
any failed check in btrfs_validate_super() returns early rather than
continuing ahead.

Siddharth Mishra
