Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3BD83358C6
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Jun 2026 07:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781854126; cv=pass; b=lNZA0Va63+6P0BdNdm1eTBbwU0CQA1txIwf7BciNVrFo8JPHwTvp5VE9YGC9yBs9SrPk+O+XDqZv/x+8OujLDyBktjR1EzyWdFxR5t+5okUpSevwjRgDUTr47XmaZFJY+2e+zt4VqVcQ5nkXc2DM5lAECvnd7hwnaFWXvMNdurI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781854126; c=relaxed/simple;
	bh=PLjuf5U1Ldp+lKMspivltGTyqfvutQwDbWwFfF6CvPI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FBeLyryBmqRviRnju4nkmhg9HpOdKw02F4Ra+gdXlyXxaHYJcZfeuIzwX19e4htO2wEh/+lIuFf/XMxOtDtHE2eEBOIhH4Jd5pxtahqz6Rgh/A2tb2qUpR+PYwLk6jA3LibGolC0f2M1hiTHZlGGjQnZUwf6stnupN3F4i4l0FA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EKTQcXfm; arc=pass smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EKTQcXfm"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-693c69b97e7so2886954a12.2
        for <linux-btrfs@vger.kernel.org>; Fri, 19 Jun 2026 00:28:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781854123; cv=none;
        d=google.com; s=arc-20240605;
        b=QlWLRFf7VDiV75Zp3wRLPe/N7sW79w9alGC9vB+SOtvBSZ4vlbx42iFpDmPRhy4KCg
         zhVUH8rsKVjh+NFxjx/spwxmvN9hr5mzgBCoChm0PqvxOJ6Dvxygo/HclmFOdGhdBEaW
         P1viiKaoiq70ZY2tUFa80zSY61XxX+vKvhE40Omdn66KhQ9TjvqOuMPuQX0AROmJa+9C
         hbJpX9PWFZ4yfUaRfL1fZaSp4oyz0c1BpWmzYdEi+eS5JLvaVcn9L+zJpVCv5x/J5Nz/
         +oyALgENiKU2yBw6XIjrXSAMr7eVdvZ6yrwZbql+r6XPNgpZKXE4dmxCUfurOxwalSW6
         U/pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=cXsAttpCRAfo1jUwXpOflkS7AbE4OJcRHMhxuP67MIc=;
        fh=p6HzpoIWg0MuHfQrPWuH/1YI48b09T0CKg4s6/N0NRI=;
        b=DFPauJzn6iyP7Mlo2tAp30W/Midw5C8FbGpYaK39AozJejkD7TtoAvQUsx1d/qh5Va
         c6jsFW8nIm9zpmCMAMUJc+Bsbp6S03p10Dzs5dyJcMN1z3sccIU9jvkxiWFSlHFm/a9V
         NO7bmNehq8hG/pyQ29duzqNORO33V68T2LkFEEPKrRC9VQb95vQGDaidrUrjnq7Mu1B0
         TFaZE0tOFtG3pPhprBxAS0bSc8EF29uHu7xUdPPcQHiupor8xkuQJLPQVE5wQU01F8RZ
         b9+8RxE9+fCjL8SAAhAV0lobEIhB7goxsop1okUk5VX/lHXPZIDDl1ydyJTu6qvRp+zj
         TloQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781854123; x=1782458923; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cXsAttpCRAfo1jUwXpOflkS7AbE4OJcRHMhxuP67MIc=;
        b=EKTQcXfmTpSi/O7oXABloqzK4/JL++I7lANtSI92FSwbPSaHSyI+Ly8uLgGGwc1czJ
         YtYQI1UH6Uizdt0GwLZqdw2hO65NG7CfVB0eP71OayhIh1bgU1DaOg15/9a9kMa2zgBW
         zdQNfNRTcXpnOjFC0pWD2Qy8AAunFSt5GVlRmax9ecbpzBv06uE4YFJ4+8celdU/Mj1B
         MGNL1NDGi6M4Os0QZhfGMRwpocG1MmdFdOgNugrBvNpnHeADOFto20dQ5EA6cQgJtC5/
         S6OL7JKPrJ0cmvFh1esu4XnUeP+wn0wTEaOxYUfcyAwVCO0NjXfBZnXTUOLQKFc0fC2I
         AXOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781854123; x=1782458923;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cXsAttpCRAfo1jUwXpOflkS7AbE4OJcRHMhxuP67MIc=;
        b=I4Y+PLkW66cch7qugs2Znto9PqnDADXrtr6NHCt5saNHiCSrMBwaJI4RZv1qjXE9X6
         aMh+UgKGfiwcbYKbOajXBMCHgHY3o0BGqjFD90+Z/JOyrToqwOTKrVDapsuAD5jyGlNX
         nOVHfPGP5drcpwQv6wIkF/3RqQuS88spWoFu012NZj13tBR2ZGV3BG/Zd59XGT01joFf
         gZrdGsaFPdbiFrAoV/6ie75qHNzrJgn4h7qLpzGRpSYH900o7h4um6Q/Oq8H8IkDK0aF
         c2ocZ9H1oy7UnNmO16blH3w+UuU2+Ou5XeMq1ZE2tTpe7zGIOVnBKbg0cQJv88hbYN7x
         zaPw==
X-Forwarded-Encrypted: i=1; AFNElJ/gMmhvHv3302N96jycPXlFV6gc7U3w6j251G8Jyl9w0WBN54WYVqkDP3gjgpwYTOt1OFUmUjUpTNlXvQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxHPtnIderybLGBj8yCVnqJL477xCtxwaUz00iloeCVaRLkWBsB
	yqDCVyhPobH+IlQnLnniWaPlc63t0V3s1iQYmz3xwDoURgMF+MDqjCQPvpknNGw+h5qe5Lqm9g2
	xxCYDj6O+L8NzzosbInTfrlnMOCDpdNA=
X-Gm-Gg: AfdE7ckt3+CmrVyFt6M5WNTffAdnpdwYrDJV4iM4J4Hy6xrPwViUEwK5dbAJ5MDKCm2
	jUy2+bh0c0X1m9o5aMWZov2FgMphh8S+9hpNBJ78iC2c/ngdRyhKp++/4o0MsX4MKKWmbn0avAl
	m2ttVzRRqUUC9w5gjTu/s7oBFeevqZMp5xtnz7QuzB4pFKADMFQGL2V3ZRPun9lpBMsyxz9illG
	+qRRgO7PCyRqzG2bOhDtTfoBfCyNfnXASb7mYnr5G9N1YYgG6brpFCYP5id9go1dcV3ktC+ZEU9
	K5zpnwhnla1Fk1WzetQmfNfAQISshLJ3F0T09U2zFA==
X-Received: by 2002:a05:6402:5107:b0:695:572a:7ab5 with SMTP id
 4fb4d7f45d1cf-69711e00675mr1216968a12.19.1781854123208; Fri, 19 Jun 2026
 00:28:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260520123722.405752-1-aalbersh@kernel.org> <20260520123722.405752-4-aalbersh@kernel.org>
 <20260520190719.GB3424023@google.com>
In-Reply-To: <20260520190719.GB3424023@google.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 19 Jun 2026 09:28:31 +0200
X-Gm-Features: AVVi8CcyPPKNjODd0CeG8qbXXsZeOsRanxA9PmKFMYeTLACw7w0uBX2gqOCDc0w
Message-ID: <CAOQ4uxh_hfiSwMw8ABhhrz7GguZWjHEiBmvb3eq16Wfqw0+ZrQ@mail.gmail.com>
Subject: Re: [PATCH v10 03/22] ovl: use core fsverity ensure info interface
To: Eric Biggers <ebiggers@kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org, 
	fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org, hch@lst.de, 
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-btrfs@vger.kernel.org, linux-unionfs@vger.kernel.org, djwong@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 20, 2026 at 9:07=E2=80=AFPM Eric Biggers <ebiggers@kernel.org> =
wrote:
>
> On Wed, May 20, 2026 at 02:37:01PM +0200, Andrey Albershteyn wrote:
> > fsverity now exposes fsverity_ensure_verity_info() which could be used
> > instead of opening file to ensure that fsverity info is loaded and
> > attached to inode.
> >
> > Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> > Acked-by: Amir Goldstein <amir73il@gmail.com>
> > ---
> >  fs/overlayfs/util.c | 14 +++-----------
> >  1 file changed, 3 insertions(+), 11 deletions(-)
>
> Reviewed-by: Eric Biggers <ebiggers@kernel.org>
>
> I'm still confused by the new implementation of fsverity_active() that
> got introduced by "fsverity: use a hashtable to find the fsverity_info",
> though.  I should have caught this during review of that commit.  For
> one its comment is outdated, but also the memory barrier seems to be
> specific to the fsverity_get_info() caller and probably should be moved
> to there.  Anyway, that's not directly related to this patch.

Eric, Andrey,

Did you see the Sashiko review for this patch and others in this series?

https://sashiko.dev/#/patchset/20260520123722.405752-1-aalbersh%40kernel.or=
g

It annotated some review comments as high and critical.
For this patch it is about interaction with fscrypt.

Please take a look and say if this is concerning or false positive.

Thanks,
Amir.
