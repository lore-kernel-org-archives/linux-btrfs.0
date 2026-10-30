Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.50
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793375701;
	b=p/Ppb9/sGEMxByq3dV70z+Nzx9e5l37+k/oIvPzOsln0t+xbaHPl9f4sYRHsmz5f2jBC
	 3K47eda0ac3x28XZTJOjk2AeK5ek9aSdtci3g1rhwNwuV4K6cCPLJLPajxHFrH05cbpjU
	 Xdl7oL1cDm/wkLt/OKbAzUKyGTtXIrHTzstPjye4sBYdGw8wFa2l/4ZDElgEVbhbI6nqZ
	 GhP9uB08VP0HzTBXHKO+fG25thp6mNm+qWVWKeuSQqkjf7BwcoDUJUTc9msu0c4coqIxA
	 ca5Bz+cJ/ptA4RE5qm7JLFSMuZWY46H2UTOZlHBwMNz88nfaUgVaOeyivxVUAZ/5GNA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793375701;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=La102baX/T9Dpm4G/iGvWWTQa7glgMfWrbqZWH3iXA0=;
	b=FBryj2wb+BJCZvCcbaA7mxv21rJ6rZTmgFEUHwIjwZmSIi5K1nBieX5vo8wXCl6GsNvi
	 olbDuA7MFEO7h1+QX5+5qD0+xTO/w4ftC5GuRQxgJOnufGiYiPXJX47PD7h16KtSvvSiG
	 VdP77WKp9/+7Qu7ZqzhSAhOtvRyE/NpFJlA+p173lMPLB0qR3l6BTqdaSMcHxwsfBq7qv
	 g8mWNjhToASwCYWONMUGbetTe8Bwo1EevhVSCKs9cLrmh4w9t5FFPBGSxEoSCXRtOiDFw
	 +O4nCcHsmTneNL4X09JvE9GJLcEXQq2naIj27WX+DQzcil75BfaxsqDlV8/kczP0q3Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=AmnOcibA;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.50
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51F6E606A32A
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Oct 2026 15:55:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 51F6E606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=AmnOcibA
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c46bd7a7345so185002466b.0
        for <linux-btrfs@vger.kernel.org>; Fri, 30 Oct 2026 08:55:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793375700; cv=none;
        d=google.com; s=arc-20260327;
        b=Zo/7AtIgk6MsFb2Px49EH/wp1+zJjyX/XwEU6CqKvZp/J7iH1tR/PlUld3pN0LgK0q
         ClzwMpOcOljO2B97+eTuN1JjR2hb0VrZGfwxZS2gbrjtB5p8Xaabqu0asL/ijhH0mFZq
         YYGccmi33acZkZL0XGFCSoUdWsoxjZOP85N/HIA6HzMaO7qkZJnZaQY6um3B/19CfVLr
         Z438+nr9vuT/BD6U8zSoobTkPRtdHzIxHBaga6tgTCbryMucWbfBN78jf6nR/6YkoxBW
         QX2+hROnt76R3oiAMOhoz/D455yoIfBzki5bp5KKVlXamffNyRBMEgyI2l+WTqMtDmyH
         ZLWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=La102baX/T9Dpm4G/iGvWWTQa7glgMfWrbqZWH3iXA0=;
        fh=H5epWO3v2dAki5K81sf+Wl2FZWXg7xY+gM/ntg9bQno=;
        b=YVIJWsRPUL41kig50VUZ7qfgelYaxn6el5izQlGadn6AOWc93071G1v6TilHI5O94M
         kxTOBL0AUvoW9xDgJOA+2142q1VVQ8Csv5nlQyUd4RPq7RNECqKyQSq2v6aKSrXa2/Uf
         Fd+7FxiAobAJ7gk/krFNC+WUn9lnZoMV5PZK3RLb5h6LrhdeGqO1hbfX52UgtckKcI5C
         pjNPFacHBGoCtTRDe4RNRsVt7LCrU/1pvUwBmTISDCQKZLptJ8gy8hLsGFjflgudUwGk
         Go3B3k2Osc0m4u7fkjBL6afoQluEt3wHYuZV9hfx9ez6k2+chE2g7GyFTbU8n9vw6h65
         qLhw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1793375700; x=1793980500; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=La102baX/T9Dpm4G/iGvWWTQa7glgMfWrbqZWH3iXA0=;
        b=AmnOcibADyocnS5WPt2WbWeJj+nLwISD476Kzp2hKsD11YAsEfwDZtfgL1P6ai2w0L
         ghnJrSe7HAPns/RnfYFUETsCjxMMUS5YJZSjdE8AwaQJZnAXb+RrmLcOShboBK8RW7Co
         l6V6SpRfJQbQ5SvfsjXKCbG/f/afeCgjQOgbQ9C8YuwCf/v9ywY5OMlmckS8noHzsxqH
         MxS6jWQxop37qtFhDyYufysThtX3J251rCYvsstT0ovliWGcLKV6VbsnK/DVN12s1fiV
         UZLaaRvyCdDjoMOqCGUxhXxhYj5u5SqSUvTT02GvjUNQiExJyc+bAHh+TkNHpHRjKDk3
         3/6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793375700; x=1793980500;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=La102baX/T9Dpm4G/iGvWWTQa7glgMfWrbqZWH3iXA0=;
        b=LE6RzGGgmlX4Fagrl+HuQFmoRwAiS4yvMsXeI6QixTAQKox7JH15NjzbKKls+RJspO
         hriy2wOGmVtpuRaqKx+uZ5rnZ7d/29ZkFQxk6XkByWLvr+K8FV6R7sqXzw8gZtNdWrK+
         TGFCvngD9nW7Q/h/7tobAX6NbEO2QV1gfL0SwpNObopJv0C+hK3T4BYkNOkmCyGJuUOF
         he7mPTcw880ggtaBB4mm2zHNhrK3KiKZ/cfB/Oj5pqvSz/pGsVA2V4wcZJntP/JO7s1w
         Zap0cI5nKoyBBss8R4S/8ELAPTo6jY3ZEhPN3X8YWX438/J82lAWVa5yUWxfb2wDYz22
         7pfA==
X-Forwarded-Encrypted: i=1; AKwUvBy+qTywM3l/fpby8A5685818Zi1jb2dO1udc4kYG8uDbDAazDvBstTwVN2LLjDkFN2cFW+r7Si8XaZ53w==@vger.kernel.org
X-Gm-Message-State: AFq9FYKT0asSwlscdk7wwtFhShOPFoGdHyGr/iRdL0QHwqcOkz9UvaQC
	CamgfFc9NwCv00XM7/UTv+yKbfhzWkdpdQvktGYc+fYnZ+VqOLEpFc8bZnlZePHtF+5e/w43tbm
	qYuRjXV3WaL8BCqdazO+5S6F+1BHqwJJlOewPAqxlTw==
X-Gm-Gg: AYBFou0vGyQZSnQLX9JTxplx3dDAIK/sycxpY7SYT1LSaa4WbEhgzPJNNWIHKxqw49v
	g0OD9BxnWTs9IMVsKIvV4rlI0iLm3LuBiNC7Nz624yAOePRhaAOXqCQLyRxZU3EJCzrKzVnAiOw
	iMoOLsY7/I+Hg/uzWJlCmbB4pPLzFreigx21diGYKKgz4ZP7erq+VZClsLCODr/CLQvRabtfbM5
	wpK+XjlKkY7V1ujaMz8MfyvuLQiNDdJN8niblZY2GGZjNFJBKv1kRcjfdt1D5aU8oXyoYqQWg8u
	TDLnxyTviTdlHOdjaYqelfdFncVckLmmQcnp6/TMnVOdJpyNVoZ41H+7VdgkxWNrqUzRz5mB77p
	KmW64iRyKN+iHere0e/BE4XuDTP6CDDnfmxhORwgrqWLkUAMAkF04c0v9rujGCZ+5XsEGdLR08c
	gQxzGhm/lQCxDVJ6USEDKg7x6WQTKjeKz/ddY=
X-Received: by 2002:a17:906:ee82:b0:c25:4d9e:bb28 with SMTP id
 a640c23a62f3a-c49d10fc56bmr610630066b.3.1793375699746; Fri, 30 Oct 2026
 08:54:59 -0700 (PDT)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <700ba6c46da86ace18a502b43c5e61d16a556060.1788424754.git.wqu@suse.com>
 <20260904170035.GN9053@twin.jikos.cz> <d79d06ab-721d-4fec-a2a3-823e9380c792@gmx.com>
In-Reply-To: <d79d06ab-721d-4fec-a2a3-823e9380c792@gmx.com>
From: Daniel Vacek <neelx@suse.com>
Date: Fri, 30 Oct 2026 16:54:47 +0100
X-Gm-Features: AclHuK_tUMzRQOshKxis06yVh0mjZUUlfozT53a8or66EZNuRJ75MlXsyK264Ss
Message-ID: <CAPjX3Fc3U3MDHhzBNOk=6KsBELvrU8T_i=2U-z1kRHjkfAY1SQ@mail.gmail.com>
Subject: Re: [PATCH] btrfs: move async csum generation out of experimental features
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 5 Sept 2026 at 00:21, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
> =E5=9C=A8 2026/9/5 02:30, David Sterba =E5=86=99=E9=81=93:
> > On Thu, Sep 03, 2026 at 06:09:41PM +0930, Qu Wenruo wrote:
> >> @@ -4437,19 +4432,6 @@ void __cold close_ctree(struct btrfs_fs_info *f=
s_info)
> >>       */
> >>      btrfs_flush_workqueue(fs_info->delalloc_workers);
> >>
> >> -    /*
> >> -     * We can have ordered extents getting their last reference dropp=
ed from
> >> -     * the fs_info->workers queue because for async writes for data b=
ios we
> >> -     * queue a work for that queue, at btrfs_wq_submit_bio(), that ru=
ns
> >> -     * run_one_async_done() which calls btrfs_bio_end_io() in case th=
e bio
> >> -     * has an error, and that later function can do the final
> >> -     * btrfs_put_ordered_extent() on the ordered extent attached to t=
he bio,
> >> -     * which adds a delayed iput for the inode. So we must flush the =
queue
> >> -     * so that we don't have delayed iputs after committing the curre=
nt
> >> -     * transaction below and stopping the cleaner and transaction kth=
reads.
> >> -     */
> >> -    btrfs_flush_workqueue(fs_info->workers);
> >
> > In the final fs closing sequence there's always some possible
> > interaction between the workers, but I don't think we need an explicit
> > flush anymore. The work offloaded to the system workers will be done
> > before we get here.
>
> In fact, Daniel's commit ("btrfs: use bio::remaining for async
> checksumming synchronization") changed the behavior back, and we may
> need to be more cautious now.
>
> Previously, the csum generation workload will never call endio in its
> context, the only work it really bothers is just to wake the completion.
>
> But now his commit changed to use bio_endio(), which means we can again
> run the workload from csum generation workqueue.
>
> In fact, I do not believe it's the proper timing to move async csum out
> of experimental anymore, after his commit.
>
> I'd prefer more the next merge window at least.

Hi Qu,

Are you going to push this one now?

--nX

> Thanks,
> Qu
