Received: from rebatir.fr (rebatir.fr [212.129.56.80])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 669CB3BBA05
	for <linux-btrfs@vger.kernel.org>; Mon, 27 Apr 2026 12:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.129.56.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777294632; cv=none; b=NZvRyrJpxHRNpxEUF1uVck8EKCSty67978rjZ+ssoiKg7w3Q6dEPChorc0ctPlPnytmECIUsAnN3yzK0HtdzB0Qnv14GYH+buStA8sUAuScI0fz5ClD736UCMmrOYpK8ZhIJjzRX/HWCtnZQDv61m6qpvCXTVlFSjDNchd/DXiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777294632; c=relaxed/simple;
	bh=hzoqDvrtWgcRmEfJiakUUt7QnAKfgvxUW1+45Ocx2bM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=R6tCiziHvJTQJaZUXv6w32ogZzi3yLFEybeLeWpSGM8XLjUqRSf/jme+GmFoAvb72w6gzTxN6B+l5nhIA3zrsMkUpzmHcZfTNxDYB4O0IcKQvT5kHp9j+zVCvv5E3KczbWhxiE6qR+bJsHsReDotA8kZN7s52xsCtV5nVjAJZH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=illwieckz.net; spf=pass smtp.mailfrom=illwieckz.net; arc=none smtp.client-ip=212.129.56.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=illwieckz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=illwieckz.net
Received: from mail-dl1-f54.google.com (mail-dl1-f54.google.com [74.125.82.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by rebatir.fr (Postfix) with ESMTPSA id B38E720225
	for <linux-btrfs@vger.kernel.org>; Mon, 27 Apr 2026 14:57:08 +0200 (CEST)
Received: by mail-dl1-f54.google.com with SMTP id a92af1059eb24-12ddbe104ccso244558c88.0
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Apr 2026 05:57:08 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+FD/bsipPS3hIMbCuXzY8PPifZ6u/L36FiF8GPLe7aUwB/ALD21LLilR/2n051/h21e7weRAo+At/PlA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyj4gLHuDzTaAyapYXQJn5vUK00HMAE3LlLueNUWJRBJ1Q9ix2r
	9okl/RQd6zh9zfVwBgz9zeBo+oherimRM5GG0Lvmy/pUZOg0A9l51RyCrStihFm+XGpkOhSOEXI
	vkkZRWPJh7GFCWzljA1DU8Kl795Qd+pU=
X-Received: by 2002:a05:7022:f20c:b0:12c:8e70:c338 with SMTP id
 a92af1059eb24-12c8e70c757mr15559299c88.2.1777294626160; Mon, 27 Apr 2026
 05:57:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CALpuBKwmZRYX0Mag-gLSoL9NgBBR_D+iOeKX7sdhHtyAposGRg@mail.gmail.com>
 <07db83f8-5769-4aaf-9f54-2711ddad9eea@suse.com> <CALpuBKx=EQY=-K5VtLKATufdAbptZD0x6ZiSgbXZgOAG8Q8vAQ@mail.gmail.com>
 <634f9a5b-0e1c-4142-b82c-d34662a7a9ad@gmx.com>
In-Reply-To: <634f9a5b-0e1c-4142-b82c-d34662a7a9ad@gmx.com>
From: Thomas Debesse <dev@illwieckz.net>
Date: Mon, 27 Apr 2026 14:56:54 +0200
X-Gmail-Original-Message-ID: <CALpuBKxr8XxcfrPOQE06-aKdjrj+nb8bVdT1B4hq_ds6tUiF_g@mail.gmail.com>
X-Gm-Features: AVHnY4JG7bhJVanaSPEwlbGT1nmTCJb2g0TFR6rnDxM9q8B5Bd-5itGw8dH8RMA
Message-ID: <CALpuBKxr8XxcfrPOQE06-aKdjrj+nb8bVdT1B4hq_ds6tUiF_g@mail.gmail.com>
Subject: Re: corruption after block-group-tree conversion, how to recover?
 (data is readable)
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org, 
	Thomas DEBESSE <dev@illwieckz.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le lun. 27 avr. 2026 =C3=A0 07:26, Qu Wenruo <quwenruo.btrfs@gmx.com> a =C3=
=A9crit :
> =E5=9C=A8 2026/4/27 12:13, Thomas Debesse =E5=86=99=E9=81=93:
> > Thank you for your answers. Is the data from the =E2=80=9Cbadly convert=
ed=E2=80=9D
> > volume be assumed safe?
>
> If you really want to know that, only a full "btrfs check" can give you
> some clue.

OK

> In that case, you may want to try this mount option instead:
>
> "-o ro,rescue=3Dibadroots,nologreplay", which will allow btrfs to skip th=
e
> bad block group tree, but still enables data checksum verification.

I confirm that `-o ro,rescue=3Dibadroots,rescue=3Dnologreplay` can still
mount the volume, thanks.

> And I forgot to ask, when did the corruption happen?
> Immediately after the conversion finished, or the first mount worked,
> but corruption happened later?

It happened immediately after the conversion. I converted, rebooted,
and first mount did not work.

> If immediately after a finished conversion, then it's very possible the
> conversion is the cause.

My own immediate thought was the conversion is the cause, because it
happened right after it.

> The reason I'm asking is, although there are some fixes in progs v6.15,
> they are all addressing problems related to resuming interrupted conversi=
on.
> Thus I'm wondering what is the root cause of the transid mismatch.

On IRC some people suggest that's likely because the mkfs.btrfs used
for creating the volume (btrfs-progs 5.10.1 from Ubuntu 23.04 in
September 2023) didn't use the no-holes feature that was supposedly
made default in btrfs-progs 5.15, and then the btrfstune used for
converting the volume (btrfs-progs 6.6.3 from Ubuntu 24.04) didn't
check for the no-holes feature being there before converting while it
would had been required to be there fist=E2=80=A6 And that missed check (an=
d
the tool doing the job while it should have not) would have been the
bug that hit me.

It was also said that free-space-tree was also required, but I already
successfully converted to free-space-tree months ago, so the culprit
is very likely the missing of no-holes feature=E2=80=A6

Some people also said that they experienced problems with conversion
but doesn't experience those when doing a zero log before conversion.
But in my case my umount and shutdown before conversion was supposedly
correctly done and then there was no log to expect.

Thanks for your answers.

--=20
Thomas =E2=80=9Cillwieckz=E2=80=9D Debesse
