Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 829D2EACD
	for <linux-btrfs@vger.kernel.org>; Thu, 12 Mar 2026 00:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773273782; cv=pass; b=EODdpNT57jorgysjvZ2czl4lI7b7BWAbOmTuirur1CgXSgRDQPeksPJ18pPgkr69Esm05acqnH3TY8PGxjfFETUt2G4U+OjoUpErSO7EpqowKux3wL9PxhHXiUE9Tw85FQZPxZbp8/FuiqeknZx2lse4NTGznkk+daAPwQFG7q4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773273782; c=relaxed/simple;
	bh=FTOaeeyG93FEF2oIGgYoaY5uDWfRBHcPgEq0TxAsTUk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=crbjL/9xEVXmPGZjwHUl7dzi+KJPCBEovmpoQQyRb0QGMU0g6cqbJcO7n6wuQueZ32qShq8UlaqrPeIJM85i0i6/kIl/gGfbYrEnJotNiCQOpP4a4kEMJluz7B0hgUhlDv9YrTZxtI42Yishwik/edhj1AWVgfan04uk9Uh2fao=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bI9Q2bL6; arc=pass smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bI9Q2bL6"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-662b933f8d1so613507a12.2
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Mar 2026 17:03:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773273780; cv=none;
        d=google.com; s=arc-20240605;
        b=Dy12G7Tu0Z9ujjLLyR5afpeIJwn1X/FotRgCcPDQ8v40DjPgsAVzVkGBWM1iDW9uMv
         gnJAJVO6RIjCouM9Oae5HoTE/M5pP5BJ1B6r28hJrZSdaCCCxV6gW4X9C8ukGRi0H3SK
         bvCUEbv7+LJOafmnElZOPg6aLVowv4MrDWkG0FW0tQ0QnVnywn91ystrfgXzBdoYolfn
         rbC77y+47ILUqrHa27vd4XGHOvsOTk6AyHww0PyBm+BNQCDaYGzZH6sEX6NUHbINt8uM
         x73noJY2mBQKCSOC073AimH36Fzcml7o+/rhRW6MYesrgHdqRL6qzL+9mM519pmhO12l
         rQDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=FTOaeeyG93FEF2oIGgYoaY5uDWfRBHcPgEq0TxAsTUk=;
        fh=uWI1zFlg4kZzpF/ArCIekOkF/P4Ozet19Xo7UGQGlNw=;
        b=LlfNUDmjrG9cZT+C0hJZRzVxD4RZO/K7ODWXR9S3bpSJxsuJFUmjeTdiPaY08p1Txn
         RoAc9b3WK0TdK9kd7ccx2t37KZnMm2xXeYUrdOvWL5EW3uPyoTmk+EuytL3lIUZMBepk
         bTNCbjHEOki5DKCjLt7d6eXd69YyGHRGGf9xhGFEgFmcZxkEjXU78ZaAb3FTZC0Y71Xy
         DmtaCHtSANJ5fPNvXid+1cCakiEozhxS7PAaC6CBxpR95rxN4BfCkkVT8wFPZHscUu4H
         +ZZREx3Nn6ny7QYwiSaUOCcY4NSxKabVbytEqppEaJrZa/s8hDOZnOqDJSOZvYKlsvQ0
         jXUQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773273780; x=1773878580; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FTOaeeyG93FEF2oIGgYoaY5uDWfRBHcPgEq0TxAsTUk=;
        b=bI9Q2bL6t0IntIdPjcIXuu9eD/cl/ICISs0iUmGOCldworcV7ae9WeQ+CRMN5dqpm2
         WlfDPSAlXUV4WTzCIG2LNOWOkrsic6uDLLX56xuEHMY1T7+4HUjnlcpHOusA2tT1PoVu
         JXmPLfcMBYr+Q6fEEzdUv9OntRbzvLxegU7l9loRntfiYXRGje5HC9Pu0n8J3y3EQbgv
         8Crvy7Tq9fqneh4rXTf85GOb5cXw9l5EoBKvn8ETd0VIwHh7aAMb5IXt+WPo4nS9XVZy
         swhb+D7D5oTHWV4NONtojBxDrjKo+gBtYvCac1UjwOTNrpC/gULV7qqMcIsNCms0t/Pb
         CLaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773273780; x=1773878580;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FTOaeeyG93FEF2oIGgYoaY5uDWfRBHcPgEq0TxAsTUk=;
        b=hJLL7wrocYJkvYR8CNWjQP1K6odc2VFeAppRkdTz9CVKZH3O9dNyCsBpgZIll/p0dB
         JboKkM6g5hmn5WLk76LpHc8cJev+4Ds2FYhY3fthhwayB4qm1mVsYpaY4xH1TPZcG9+7
         i/vqK/9hRcpZHR8cdpal9ksBU6xgTKfzTlKBgFD1BRkA5EmV6ZShP3mWxeEX/nvUroFG
         Adkx2hfdA4GtRMbzZonjwLq26uILDZdwUW4lvHPANDnUdg6dzeYXFfVucxntNpv7kVio
         z7CUcRF6s3WsSszL+W8X4+8xNZTyqM9Dm868s0+mhdHSRh6Wd+vXJeKZdLUjfJAcI161
         tykA==
X-Forwarded-Encrypted: i=1; AJvYcCWDplz6snbP3+dua94OxcIpK9Z3N/jJ0UMwvxaqnS5MtmTlIXdVfPso7JWGRuojrbWZxcFyVKRhHzyx5Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YzisotKsy63eM5t5DFmrbyJrAM6b4UCOXu69HEyZbc7tj7W4rEO
	cH8IYrXKnHBKhR5AWzOhTNn7rC/rYXw/aQOonCKs0u6si4nHCTgGUsWu8P6We5cxcAaJjh2gFyS
	vS7NY29eXznctErCS1/15DyrONscKclo=
X-Gm-Gg: ATEYQzweBI3jrBaRE3Fu0owVT8We1ZId9lc3Uq3o02TwAJ0LY+rdXe1HMByIhJPsxbc
	BkTL8Ux+nZtJ1Z619NfTGZRjJo9P3dj2KRbEke7sYByIRC69WH5SEraBPMhEGq07FCsZ4o5oxmq
	4x1mhdn1Q/B5fUerQ4ZxXAm1Yyce1WRPj5Tm0rtDnabl+RMxbM75BS8s1/r+qrtbmOSZEsyPOv1
	Bi9NFyig83SGgwK9e3JSAcDdZ9KQ+9xy1n+ME0UujkCMDI9xwGS1IvmnbzEyEW7e2E4gfm2+emD
	PaZtIX1cSGl1y5ec/LNrJ6oRzDZfNfgUAC6IAnGvigK/7c3U9IrYmrj+NSm8frDpgw==
X-Received: by 2002:a17:907:d644:b0:b90:35c8:d01b with SMTP id
 a640c23a62f3a-b972e2c211dmr240675866b.36.1773273779420; Wed, 11 Mar 2026
 17:02:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260311111632.2836293-1-gality369@gmail.com> <849ac4be-b10d-4eb7-892f-4b9ee2ef5cb2@gmx.com>
In-Reply-To: <849ac4be-b10d-4eb7-892f-4b9ee2ef5cb2@gmx.com>
From: ZhengYuan Huang <gality369@gmail.com>
Date: Thu, 12 Mar 2026 08:02:47 +0800
X-Gm-Features: AaiRm52HrIoULi8oRrw_KZxsuZhl503rFFhskRvicKXqoTqsxrnZiCjbkUhRSGc
Message-ID: <CAOmEq9WDrM=0_KbFohSxgrpMxuin8hNaro9YsY8HgVASOf4KaA@mail.gmail.com>
Subject: Re: [PATCH] btrfs: reject root items with drop_progress and zero drop_level
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: dsterba@suse.com, clm@fb.com, wqu@suse.com, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, baijiaju1990@gmail.com, r33s3n6@gmail.com, 
	zzzccc427@gmail.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 12, 2026 at 5:08=E2=80=AFAM Qu Wenruo <quwenruo.btrfs@gmx.com> =
wrote:
> > [FIX]
> > Fix this by validating the root_item invariant in tree-checker when
> > reading root items from disk: if drop_progress.objectid is non-zero,
> > drop_level must also be non-zero. Reject such malformed metadata with
> > -EUCLEAN before it reaches merge_reloc_root() or btrfs_drop_snapshot()
> > and triggers the BUG_ON.
> >
> > Also fix the related tree-checker error message to report
> > "invalid root drop_level" instead of the misleading "invalid root level=
".
>
> The only "fix" part I can see is the fix of the message from drop_level.
>
> If you really want to do that, please send out a fix dedicated for that
> single line.
>
> Otherwise you're adding a new check. Please do not mix fix and new check
> into one patch.

Thanks for the feedback.
I'll split the message fix and the new validation check into separate
patches and resend them.

Thanks,
ZhengYuan Huang
