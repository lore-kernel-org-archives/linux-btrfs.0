Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E9413E5585
	for <linux-btrfs@vger.kernel.org>; Wed, 12 Aug 2026 13:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786542149; cv=pass; b=TQ+fsx1QFXb5PIV5A+sAuiw/AuJY8jBs/hO0FkIW+u15o729AC9Cb8hDTUXA0NHP25+Q7eiLOSfKrKv+VzNORs9x84fcDhckCbsCROgCN3GJCg4Pv29jKtRObOqrvx7TI+JZYGKoUl5xLJg3HKu+URSDTIMSbz2KgZ0Y2RTXx1E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786542149; c=relaxed/simple;
	bh=OaYKz/8UNJPHTqaurxpclVEI6MeOPbYBwJrUelUHVSU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kLEikLI/4Mig3Av3hX1TgbL/usP72dyiGAwHhBGR/bs0RYkRENH0F/rMzpNGZ1jj8dKK6lv3r/k0ojAGBS39A0uVCV614+aOakVdH4SU1JY9tGbxuAWg3+F8tXyshQ5pU7psPOqlIj18dNLHh8JwAt+QaqI5TlhRZDsZUiyONZA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=HjdZP9Gb; arc=pass smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="HjdZP9Gb"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4954dff6536so7620515e9.0
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Aug 2026 06:42:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786542145; cv=none;
        d=google.com; s=arc-20260327;
        b=mGsXt0YKfQ1UrR5wEtc1+0Oht6VCPGtOjJbwIO9jlp8mn01wv7PS3KRIgOwX8+stQn
         WWlzVo7FFO/njeAEgrEttd07a6MLz3U7VdGbuivaO7wrHBz3WZXSgHzbjk+ZZFmHJXUU
         PRvDcPxeyQKd2BCKH13Ug/V4LmZ/GE/no/IYJ1W2trvdsd3tfIs9XhD0NRZH2yx8YJ84
         sBxvoIk0h7gNqtkWfOwdlHEhM4CvUaVMmQTZDghHhh8NZn2Sl6BQ5aikdNtGx9xzajeJ
         ujUudEGrfTJAfcsXp2YkhX9Ln3yT79+/Zj1LmWX5rU4TXjdEeYpuIKkdV6S1BO+6fOdt
         egYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=5tGpXLx/o7dEo7Q3/7U1JEPYlPhC8+W5F1DtfAIZ18E=;
        fh=q7p2R6ME13kojRtkU4nw4hsvWtDGrneP1yD8fqRCAxk=;
        b=CbcN+RLoN/JQhQWRZizjSWpzCPKtz15wjh9opJcawF1b+aqYvjX6HKnrYpyIUkkICv
         sdQB/ZlPBQedLGjW50f3UJjIurERNsodHZ0BIm8JbQ6gSlSGvG+LXKzPuOpmUvInY2nh
         BlVMy1yhH6pSubIuuDG+P+6PvXo0Xbypn+BCWXyiOZIL/oE8aEiJ2BsOCl5XuIAn4J6R
         g5pqA5zJXtc3EBzqjzC7tSKOCR6ILXVQQujykG1yJxtIHl8fkcI3eura9/5AhfboyprA
         cL2ncQ3y5ZnLMRwD70ZetGI0ZGYUuO2waUYoadf7OpEaOjUF/X7A5oePqeiqIHT/1knW
         QE9w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1786542145; x=1787146945; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5tGpXLx/o7dEo7Q3/7U1JEPYlPhC8+W5F1DtfAIZ18E=;
        b=HjdZP9GboP2C1f/GfQkYqllSxbidziD1jt+uCNcmfidvIEiYj7X6oGLk2SdETaeSv/
         FP3qlWyKUHkcpRXxTN+0jrkP4HJs/9qqh153fQvgKBAiYcrIZKWMpWux4Dsqben2uoo2
         jq093FKT3uA3aomdd2cHNrjpIRlOie6Xnx8HTUAdI+31sVJ84yBMM/bsT5a+pEYDil3U
         okCaDms5nJ9C88MF1JR6aB6nrXNpTL7Kp+XEeJgvlpofEJi+xTC/dW5nL7oZv1u5DkOI
         0h3GV3E3UVDkhGTD5f3Vug+cO26rsABqHAZS9nImESOa77Y+AEshR5wM0WD3ViSgl9aH
         Lk/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786542145; x=1787146945;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=5tGpXLx/o7dEo7Q3/7U1JEPYlPhC8+W5F1DtfAIZ18E=;
        b=L/bZrrOp3gwutTS6VZ+Uv0w9diDMWxj9newAtR0KgUMWFBU+I0y5L7BbqS55KgsA5A
         vOsuH4OkdHOdUL91xKOgI59NCOtmbYCZqvMbUtCPACjMtj/+8O2Z8CknDh2RQPeopkvv
         j9aBwUZ4flNSFAvciriL+A2Tq36zSElzc0TwhsHsIobXhTuWtGXiG4QCHGY83SOHgi1T
         xqODO6+ZnUJBknkcOUSP3aSoU0jC41FzHDh6XOwl7swsp3IhktsvsULpXCDVC6qQrsr9
         JyoX7vsLSsPH738Dx0hIRID6jWnq1JCUdde0VXyAe8lOVD+5vTwbfxi/3x5p/khkvoRg
         LBSQ==
X-Forwarded-Encrypted: i=1; AHgh+RotvnNRuy1gs048jM1uPm9erft4xKNN6z6eVq2Ke/O2k4OwXlwdvDYEWRMBe/NXXYb0f7Tpytr5C60aqw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz4IbGv38OG3ZsL6ztGn5M8OVcLFry+VE699Pt/bkqJgvIcndoc
	0tluoGC5D+0BIuhNoh9GTloqZlKLqo4Ar1fnMCCdi03DB+QYY5N3mBZq+t2NR2yFIVo9zTFFTLq
	u6igVXTDiykp6sxt8LlEz7Rja05hPrNtENB+5IuElXw==
X-Gm-Gg: AR+sD11eqlx4oMvlzH5B8ypOkivhPa0IBO0V0OdaP52laSWHzsAO+SQhp2iAPhmnovn
	0rkB07SbM+imeAIhy8rX9HY0Qo7f7v6ks9K4nBajFjcxZIspWwVfjtF0RtxZE1Fad3cjr8ixdri
	L6O0U5dFAuxa5wKY532SAaL+OWXaLKD1yQuXvHxSYKmeWjk19PyjMk4he5eAS8icOxWIP0H9c+a
	et23Exh0LXG7E/XuhqQDuAwhQfIkBYcZDS0gMZqPGT6cyJtxtL5d7PtE/Gq6nZZWhpn6k9ws4hH
	U2uyOHx14IpUkuAFTYnAVHEaNWz/6mFKWf4G6vQ+sGbkhi1r0LgUZQla8/WsNTKbyXTiB4qiByO
	kASfGSMCxhTj6ZXLZJwO11qOUdIFy0SmMljmDTa8U08M=
X-Received: by 2002:a05:600c:4690:b0:490:c6c2:52 with SMTP id
 5b1f17b1804b1-4997c0fe67cmr65880095e9.3.1786542145347; Wed, 12 Aug 2026
 06:42:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260513085340.3673127-1-neelx@suse.com> <20260513085340.3673127-3-neelx@suse.com>
 <20260601224920.GB25574@quark>
In-Reply-To: <20260601224920.GB25574@quark>
From: Daniel Vacek <neelx@suse.com>
Date: Wed, 12 Aug 2026 15:42:12 +0200
X-Gm-Features: AUfX_mxUX5B7ho1XknbfVlc-uLWV2Eu6v2suT3UDLMiVCVx6n4XVBbcNHB1dnXs
Message-ID: <CAPjX3FfouCuSTTBYASnjRgvu+kR7mJtRsd2WZ7Lc9om+P8hK0g@mail.gmail.com>
Subject: Re: [PATCH v7 02/43] fscrypt: allow inline encryption for extent
 based encryption
To: Eric Biggers <ebiggers@kernel.org>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>, "Theodore Y. Ts'o" <tytso@mit.edu>, 
	Jaegeuk Kim <jaegeuk@kernel.org>, Jens Axboe <axboe@kernel.dk>, David Sterba <dsterba@suse.com>, 
	linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 2 Jun 2026 at 00:49, Eric Biggers <ebiggers@kernel.org> wrote:
> On Wed, May 13, 2026 at 10:52:36AM +0200, Daniel Vacek wrote:
> > From: Josef Bacik <josef@toxicpanda.com>
> >
> > Instead of requiring -o inlinecrypt to enable inline encryption, allow
> > having s_cop->has_per_extent_encryption to indicate that this file
> > system supports inline encryption.
> >
> > Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> > Signed-off-by: Daniel Vacek <neelx@suse.com>
> > ---
> >
> > v5: https://lore.kernel.org/linux-btrfs/ba0289bf103653d5d98ef576756c9a2a66192865.1706116485.git.josef@toxicpanda.com/
> >  * No changes since.
>
> There are multiple places that check SB_INLINECRYPT, and just one was
> updated.  Perhaps we should just require that if a filesystem sets
> has_per_extent_encryption, then it also sets SB_INLINECRYPT
> unconditionally?

has_per_extent_encryption means the kernel fs implementation supports
extent encryption, not that the mounted filesystem uses encryption.
That said it would result in all btrfs mounts setting SB_INLINECRYPT.
Is that what you meant?

--nX

> - Eric
