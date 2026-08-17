Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AC9C3DAACA
	for <linux-btrfs@vger.kernel.org>; Mon, 17 Aug 2026 14:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976806; cv=pass; b=GvUmIzAtXeu7H0DPQ1czQODoD85jVCXQLps3o73DuDXTZ3QRY9n1aesaqWfq0hVcFI6xLXHsyd88fy1fzszAc2xm3WAUdv3ZWAZc6r1DPYZYtfuy7+qyW2kkig9Mt3Nd4XSzb8CQSdKFoLhbWl/wYcUKrFdIsiEVFXxgoZZRH9k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976806; c=relaxed/simple;
	bh=H5UNg7J1Mi8AtNfwDPiv7pfF4LzhgoX6aYURLD7VVVA=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=bEM4lOi2lA1FxRwrtV3Pf7H0LJHDTfVwG4k9mWlVYh6SLf2jyFtwyz//iWUngp7AjiEaH+Jc91nfkGQPwBl1yMGbDRtN5VWC39ptTGa8dAAER/04QhTRPxe/s5rFD5ChzhwmRBtnjCVVLAtBKq6lyos3/baGQ0nTcQZY4o2ISRY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QB+B5R/Q; arc=pass smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QB+B5R/Q"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-6a1a546a6bbso5135797a12.1
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Aug 2026 07:26:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786976803; cv=none;
        d=google.com; s=arc-20260327;
        b=k3NcbG7r4H4EAKMu0RobdZ1pFzQEQrWgPHZgWel0ioXctEwq0f8ITpY9snm8nCimuI
         eM6aaVQheCSSbWE/ypA5WujzQknrSD0TOVVl7Py9pMKCKymabsJ05PuW2eMm6mNZKvuB
         TMgOYB/s76Ypl8mxNWLIdMEEKynW2SfLTRwB9GmuBUe+RNpSVCx+lZNR73vm4ofGXbsl
         7cmsAN7ilwCwHrKOiuMS3viuu/vHWfpeKcXfA+gOtd7qek3ZhY7ZPskBYrMMWJkt2rwn
         0l2psNrSooBFX3HpkO8Iw7ERMLHmFCrcOYuKpOzifZ2KrvAdrRBt1HPGcNJ/tsL6gwCs
         vr8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=ILf9NubHRq8/Yf/8qGSonTMm0brZwMArnnCdd8N7fxI=;
        fh=BvMFYjmC6f3LegKsvHpUm4lpdhoaYjr4V4qjnsPtPTc=;
        b=bfisLZMM9vP5FGK3VEeveTzydde3u1ISYJOBTZfVUmCk/Wo0H8LVpaWPQua/2zADEk
         ZPRgidOnzdN4lX0yMw06tHHSHBWPkfQsl71PphXliHohOvNBqWz56D8SPB/yJVVezBN+
         E9+E8Bz6j+1+E/QsrM/1HmxWABvyVTx4AF8jkyhj17Pv6bTXTl4J3Qrfg2ZLw3RsxJPT
         pD4gc9T3nkRS89KYe9cW8aYd3Gih20dcwy4+RgMsEVCGFI44BFV558KhZSEDdKdhgg6i
         5lsqQE3fYq6v2J930SgZO/pEpwAkCKzDXivrUOSWUTVNTNGLRIm+34S/skEqx7tWD36S
         ND6w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786976803; x=1787581603; darn=vger.kernel.org;
        h=content-type:to:subject:message-id:date:from:mime-version:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=ILf9NubHRq8/Yf/8qGSonTMm0brZwMArnnCdd8N7fxI=;
        b=QB+B5R/QUdjLw1fBgO6uiPEMVVjZ8nSAuNFQZf7qaXchpEW6ECAdV3eJTJ0To0jZ3K
         jj+BKgy0RV1Ruel5NhEyvhNqFGY9+Abjr2PziT7BYvyWEkrS7+Fyur/Il48X8l5JVadg
         EHZjJoArBsi7ACMXKZEX2JVanlT6kTVaoDfgjDg8B5ZL/Npf1mBqCm3Cs5ECUEbCri8g
         EQkZEtaX5TKuk5sVvIdd8ibzZ3L3laguOXsMKV8xOeBO60aPfDKmI4gmp6RQhjKOsO2q
         BcDEc5M6GXAnf2lxs/dLlIOsy/rnbmFCLaAQt/ydDw9j/siek3VgokBrvKgbPM3+PzPp
         8qCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786976803; x=1787581603;
        h=content-type:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ILf9NubHRq8/Yf/8qGSonTMm0brZwMArnnCdd8N7fxI=;
        b=MwRNpGoAM4xn/BMw5k7eusICJkbJELWQx8rv2fC9k39Sd6lAswq5qBNJfVahuhkpWk
         4LDiEG5j04gcMw5fbNdInN4jckBzk3omfV4Ws2c+nZfRuRUliWEIY1nVdNlFsmTdxxLK
         h3itD1TgFSu1nzysNzcAy43WyPB2rbFRN5aGXYrnY1Km0rNYikN3iVRl0WMtT49XYr0G
         4t8Qgn8TEcuy7IzxIER0f7uV41a8Bp2qtzeoFlNJ9OF6G8oxWT3t1jYQV9JDdQz0k3HV
         W3mnlg/6eGHEn252XvT9P2g2DBzduQ/zv2Z6Xu8mwRcBgKg9WOCaz/rfQYIFSW+fT5OI
         PnkQ==
X-Forwarded-Encrypted: i=1; AHgh+RrtdVptcyGIqJ/0Wrekjvf8Z0IaofgWVB7/kyhbFXHWDQRYnC3IGoM44UkkIGAs6DoSFhFuNKjupxpa0w==@vger.kernel.org
X-Gm-Message-State: AOJu0YwWGSuxo+bcACYkugwBpqkp3A4CGCDjrUOVtWzdG5DZTBmhHEQU
	7aEBI9mC02+hfr1/0j0RO7age9k3APBIJBKXGYjRmvWSOQwgoCGF/zYFEUnsVTNxOE0lykG3bY9
	Ddc+0bgGlwerl63Tn/jlQyA1uo2oDml9sjEK3
X-Gm-Gg: AR+sD12jOdX9dx/Cne3fwnq0qRIuBcNxHUJI4xZZXONgOreZA1PhVfvBq62KMmaxeS1
	6cTN4TWID5RAVqgldK4ZLqbzKuYrfpaSim66QxsosxFiSy1OrclXyPa7vOZKs/hgVz2zqwjPLVK
	X9ZERiFQwr1jh2L6TnokZ3r8NDXcddgq1Cc/VSrvn+LqiP8eTzI+3EDl4kYD204qrVQVO7rDwYD
	9Ef/TjZNhf1x/rtcEL85shuAwP+hQJFADgdJd/loX9rFtPdTzYR7NF3IlYlAMNEwUiAsi+pwEvp
	0/VIhHYXBP6EaOElgcNUGwpSGraskUWztm0gvbD7F7cLiHzaV3YDp7UTpQhlRmOiL7MtYUuNAvq
	9u9dsKuO4zQROnVNPqzW/k0wwEholuUD3CRC/NsLahNQOiZf4HDIqBcKeoKsPPfvpDlYGtbkWFR
	yISpYw1TkwpuK5WLRVzKXb
X-Received: by 2002:a05:6402:1f8d:b0:6a1:2863:ad84 with SMTP id
 4fb4d7f45d1cf-6a38a9986damr11298508a12.11.1786976802672; Mon, 17 Aug 2026
 07:26:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Laurent Lyaudet <laurent.lyaudet@gmail.com>
Date: Mon, 17 Aug 2026 16:26:31 +0200
X-Gm-Features: AcwNN1V5cAkRzPIgAwEhP_UQwCtxhVENNdxRSBlkE2J4bEJig7hHaeaupu83B_0
Message-ID: <CAB1LBmsQ2xFHQeEDFspwpFSNkiFUefBCn559EJsfEz5ZUAXYiA@mail.gmail.com>
Subject: [RFC] "final" flag for a directory
To: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello,

I had an idea about adding a boolean flag "final" on directories in an
advanced filesystem.
In the same way, the "final" keyword on a class in OOP can be added to
declare no subclass can exist,
the "final" boolean flag on a directory could be added to say that the
directory has no/must not have any subdirectory.
So here we see that 2 flags could be added:
- a configuration flag "must_be_final" forbidding to create a subdirectory,
- a status flag "is_final" telling that no subdirectory currently exists.
I think it may allow some small optimizations.
With a very limited search on the Internet, I found no similar thing before,
but I do assume that I'm not the first one to have this idea of
marking the pseudo-leaves of the filesystem tree.
Please, let me know if this should be discussed elsewhere.

Have a nice day, best regards,
    Laurent Lyaudet
