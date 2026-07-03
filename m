Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D73E72F5A06
	for <linux-btrfs@vger.kernel.org>; Fri,  3 Jul 2026 17:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783098439; cv=none; b=ErZGsxsJp2rgzJsmvy0orFsazaOIsQ6a/ROaKLepy6QT+YIHm8UTdb/0JwctOssZW6MGNC9L247EyZ6Yf4gwQ/WMlhFRKsAQVIGzJA2iFlVK0JmI8vWi4i6SwZZvjY4QzGOzrAiLAHDn+5lZIFmlAYNATlIk6BjkyJHMNxI8NcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783098439; c=relaxed/simple;
	bh=ME/E2Tq0fjazhAkgTWvRdGbZxmDHmralg7yVhG7Fcsw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hQku6Vtrx6Rm23BbLYxKK+Qy6LrxrvNEAbywM8VGTmOS+UqSdzX6+Ma9g5XKkYZLsWXkljkQJ9bPukMSutEzsYr4rBE0E3buQtdTGDwvaogxBYnSvDujAFARg7irrZZbi/Pym20+4KdS0hM7Ext75Dp02l02+B6b5BS+36KHzy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gompa.dev; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.210.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gompa.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-7e9d7464b71so232791a34.0
        for <linux-btrfs@vger.kernel.org>; Fri, 03 Jul 2026 10:07:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783098437; x=1783703237;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dV2FmLe/vSfjWkklqT20UGuc8UWv61caTwvXPFBN00U=;
        b=IIvsgoG2cmBEqeTDFrKdbvUFl24YKz1Sysb0JMjjkIuO7Rno/KGR1FIrbv9c9QpUa/
         5pFbXa9oMFja80pwdzxXrkH6TML1QUtpXPr3zdhZHzHh78qcdvkyHrx5YQ1m0XGtM9Dr
         eFEPj2/9k+xeFhSS+006ynDypEc1wSHM8o5agkLtbb/hYOAGJ73gPekxkNZ2GnDklCUE
         dkSIOaLMnsoDaeov4Xad++4OOGyOzEO5yfkyzTLVxhBe+10GXRbpOxjBEPH+lzNdVCnt
         xbkydxsdBa47lT8zlDOrml9cEFjQ9L6E6x6MxS+NmImKiDPVdVwFSrbCzTXB+eIIjfgt
         q0ug==
X-Gm-Message-State: AOJu0YwabljJWQtaCDjm4kJoFkN+oEj9gn0l0d/gwyGGHSkR/eflu+p1
	Aelf718vOrW7kmvtMYRQFQWgWIv3BkEi1KxEAhY4CU1USrIvzF15GPH+idqzVg==
X-Gm-Gg: AfdE7cm1QflzzPNl3HAqzeig/mL+vcHcQOIGf3VFj49nCSptzW6EVYZdI2Li0YiCSow
	gnRneE+5kDn6UQVj8su5wf7YY63Bk/TGWbRGGWxKfHuRccztwF3iT79Hy0vhOx8KdkIYNSU61rr
	dc1ujf2SumANPOwDf1IukJQPCM/3pfL/RAafGFwgyTx3TPPr+bvg6Yt/4jx0oGvx3gSqJ1M949P
	5XMuhxq+MHhwzqP33VmnAcNBGkWo3MchgWLzvowpdtjnh+vSUEcsZan8AJmkfVLyad/vsc6SpoJ
	q21I87o0j5QatFwz1ox8p5gNcHtUby3TJdzWRAN2LIjBDy4QogMY8kTopUvjHeEaHOGLtcJs57S
	tzNjz9C7whwQpTJyNsNcNa6h+M5yKLbvacD4bkakjeq1+TRaTEfs+5K5y2O3Lp9CMIaxaXPFfBI
	rR5vDodWS4e94HklrqSvE+7LZJQ80Nrv3CK1GfKyqOSUcJMAycL1YQt9DWUX4rdfz0WtZKTwTDB
	q+REi6MxyFHamMVvtfybjHa/vPWq13EUqnYq+i9Hvnk1fSurslmQz3SrJdFrEA=
X-Received: by 2002:a05:6830:3590:b0:7ea:17f0:d8c5 with SMTP id 46e09a7af769-7eb7fd8d8cdmr210776a34.9.1783098436648;
        Fri, 03 Jul 2026 10:07:16 -0700 (PDT)
Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com. [209.85.210.46])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7eb544a160esm5126440a34.13.2026.07.03.10.07.15
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Jul 2026 10:07:15 -0700 (PDT)
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-7eb29ed2bbdso207711a34.2
        for <linux-btrfs@vger.kernel.org>; Fri, 03 Jul 2026 10:07:15 -0700 (PDT)
X-Received: by 2002:a05:6830:83a4:b0:7dc:dd19:7f53 with SMTP id
 46e09a7af769-7eb7fd9301cmr216541a34.14.1783098435374; Fri, 03 Jul 2026
 10:07:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1783071857.git.wqu@suse.com>
In-Reply-To: <cover.1783071857.git.wqu@suse.com>
From: Neal Gompa <neal@gompa.dev>
Date: Fri, 3 Jul 2026 13:06:38 -0400
X-Gmail-Original-Message-ID: <CAEg-Je89N-CMoUAE5hSg8idHeZyxE65sx+V9hAfmf6B40sQwPQ@mail.gmail.com>
X-Gm-Features: AVVi8Cf7O2X3xKkA8d_wYE6Y51e2hXTVTjoeXrRiPU0sFPRnUUWE8gPadPfryB0
Message-ID: <CAEg-Je89N-CMoUAE5hSg8idHeZyxE65sx+V9hAfmf6B40sQwPQ@mail.gmail.com>
Subject: Re: [PATCH v3 0/3] btrfs: small changes to "usebackuproot" mount option
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 3, 2026 at 5:47=E2=80=AFAM Qu Wenruo <wqu@suse.com> wrote:
>
> [CHANGELOG]
> v3:
> - Add "rescue=3Dusebackuproot" into full RO mount options
> - Minor grammar updates
>
> v2:
> - Also include "rescue=3Dusebackuproot" into "rescue=3Dall" shortcut
>
> "rescue=3Dusebackuproot" mount option is not requiring a read-only mount,
> which is different from all the other options in the "rescue=3D" group.
> Address that in the first patch.
>
> Then also include "rescue=3Dusebackuproot" into "rescue=3Dall" group, don=
e
> in the second patch.
>
> Standalone "usebackuproot" mount option is already marked deprecated
> since v5.9, I see no practical reason to keep supporting it in 2026.
> Just remove it in the last patch.
>
> Qu Wenruo (3):
>   btrfs: add "rescue=3Dusebackuproot" into forced read-only options
>   btrfs: add "rescue=3Dusebackuproot" into "rescue=3Dall" shortcut
>   btrfs: remove "usebackuproot" mount option
>
>  fs/btrfs/fs.h    |  3 ++-
>  fs/btrfs/super.c | 16 +++-------------
>  2 files changed, 5 insertions(+), 14 deletions(-)
>
> --
> 2.54.0
>
>

LGTM.

Reviewed-by: Neal Gompa <neal@gompa.dev>


--=20
=E7=9C=9F=E5=AE=9F=E3=81=AF=E3=81=84=E3=81=A4=E3=82=82=E4=B8=80=E3=81=A4=EF=
=BC=81/ Always, there's only one truth!
