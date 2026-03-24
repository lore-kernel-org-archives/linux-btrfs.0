Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91ED2384235
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Mar 2026 02:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774320828; cv=pass; b=RLE+bjoSXpePBgX7ay8dpJb4FAAyklxggaM52E9HJaH+vwePiPIFzZV4qGeyti9Q03RO48lwjUuES9CmohQcUx8mq44JIjhXWOUt5/x5jSX9unMCXWHj6Kp9OgnACSPTB07hA3WepOjRZgAdAPqOLcYoPTPDedbS7XrqdcCjpmo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774320828; c=relaxed/simple;
	bh=E4+z9t2+mufnk2+LE9YjDKLH794kwNwNtV9ZrYKAs4I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hYRtZdCHvbH9QOfR9ovkSBB1K8mkX0OpZLRVnlhUqtT7oMYeMQuHufgNasbX4vZ8VC5wTZsP3fndBK2hzmwh6X9XZ29H34f1ro9LcC9GSme9UAAPNRuxkTdjR4xvhSqZJsCAgSsbLUbnOfPCKNBTdcPeWOiljBacauh1rWKW62M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dLnyZnJa; arc=pass smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dLnyZnJa"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b9358dd7f79so571354066b.1
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Mar 2026 19:53:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774320826; cv=none;
        d=google.com; s=arc-20240605;
        b=iUc1b7sBOG6d2Oe0CNm2NJYYfWGhQDYIbXe8i2xeFG8xAUydXm681hw/zXTYQ8m6Yx
         T8wfEQCJeUBo+hbXcospby5qlLiPT5om/efIIVxyJVGJAKR/ispjFkxzavUQrVIMAxkA
         xjzThDruUShwtRPnais5JXFkvLOBBSAK6TsxJHL6Uup4HnaSvZqOanYQPDSlN6pPyk56
         23dWcOWKfcTEqMy0WOnX4z1flZy+f/ohFe6TSvTlw9eYfakM6wUaCWM8mOYvvmvYA9Nc
         MaOkrHKJaSwyJfGYLW3GFAFwx7UHsexUZxwGON4ZGyYB9jJ5MMTx8UBH31qqzzQqRIqC
         k/Yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=E4+z9t2+mufnk2+LE9YjDKLH794kwNwNtV9ZrYKAs4I=;
        fh=nbS8KEEEo2ctCy5PAWcu/fGicfh6OAmrEyBAu/IJz9A=;
        b=HNm8GD8srBIJ/whu32t6aETXmyxbMUOOOGgl+gR7CQ34qQVJLL6DkKSF4RAW5IhbxH
         AhJQrwv8cBN7JVr+Fj0A8po6r8z39BeZAc1NeUSXgVbwjqNFzzU9VcPvij1VXgISQM/i
         qZ4DRC2ksM4ckjo3wQpWQA4+zmCiauyjm2aWMBD7maQd4ydzRLXMrTwPvVzYi1mC17C1
         VWGTW4c3rxauZ8MTegBJFVHjdhMHpjc9guSRUt+dtIsfqR7s02mExh8mXH8KCfy01tfr
         JUBu7yCCeiH0ZvzNAAl/7u1M5ls7XJh25XGGfFyahnEgSlMcta4P6EiqliMQn1jKhn1W
         5tOw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774320826; x=1774925626; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E4+z9t2+mufnk2+LE9YjDKLH794kwNwNtV9ZrYKAs4I=;
        b=dLnyZnJaotFbuytuk1Q4YyERBJF3wsZl8M6u0py0992rU+kkD70FIS3hEvkPALVObT
         4TgGn1N1fkJrc4EpGTMJKzlYxSMQGOzKa2FCLy9aGzpMVPujfus9mdkufJNv/EXjhykR
         BH3GXXiZ2H5m41w7Gomu+T/Erm4tKMyYJo1PRJi5wFJxAv7FDEQiHqh4HyWo+Domgii0
         RpzUSNfomFilMJlgSWwulUw9G9WmvOSjxG5V8cRlH141t0JNT6xR3khCdretx0f486+Z
         bsDhh0nrJhWRz2fHGRMqfooEBhJvYfWsX1Ele+rgzJ7jfNN/YG8xe6pipNgwbKjtVMfe
         kPbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774320826; x=1774925626;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=E4+z9t2+mufnk2+LE9YjDKLH794kwNwNtV9ZrYKAs4I=;
        b=hTjPy0O+f0eloIulYnu/MEqkeGlHv+S5X35tO2xy3O1ZDHo9jf33iSk1YsUAJrOqdo
         rRu8IphrpFyDEWx5QCkPj4lXQr1Hy1sgfeK0JFzwJdjUqCFS++wEkDjRIFyCUnLd7oxI
         Gh00bYLn/qOzvehyMNI9Bvp1Jwdr2CWcMrZUlN16aSQmOAOrRfI4LjwJomsZKEPluwn2
         jlQGzxoCuJ8jiwGt5sOZhb/JzARWk0CPacwDCRpsUWCfW3XqPjtB2FpmiKS0HqoDvwZQ
         zqdquamHYUol6ji/sX6ixJH8eXl7EqX/0bjyqUYkU6phkz9B15yVWv1xWdYpwGNgU/DO
         qb5A==
X-Forwarded-Encrypted: i=1; AJvYcCU0BE0zVhWn96jdE4At+peE61xOvWmmpBt5mf9bzqggntXjArTalqhSYJJxKKysoN4S1UufyO//2+tecQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxJk52KbHTU30iq83yKRM72/Cs/ncY28AWonwmUUk7o0jbd7+sZ
	UmzcCSPA4yp6gsCS3B2dNmnP8sV92Mx60QdFcCnyIAN4A73PqZ0M/FCkouA8559Zpub10NE4i9T
	WU86bFL89ROmJeAgN383xrKV/bKf1o4M=
X-Gm-Gg: ATEYQzys8mBuEaXsWZi9W5wz0pLKqj91YLt4sGr7MG3RY+MA4EbSIOmfClViy80orHc
	9Rzog0vY5oQSolayPE7GOShQxAAG59pDcEGAqoLvjkdpCmkc7DzNeF7tvk4T6DxSrxFNmj9DuHO
	HdQoZGGIgZgtOf0um+KWSdxsDf46uK2u4wC4eCz3xn16CI3/Jg3W/SFgvQjyoUR68Rl5hJUZTy6
	1SzItAQjp7btc4V5zDUKCvIOAKxyoyHf38nc4yZkt2cdm0gARjL4W8OCARZvjQNTor+3QVG+NiH
	t0Ny1jDfWc/sUUmiy1OwGoXQxzjCax91D/kvcz2v+unfaDgermZ1aiw=
X-Received: by 2002:a17:907:d58e:b0:b97:aba7:1969 with SMTP id
 a640c23a62f3a-b982f3cbc95mr969518366b.45.1774320825565; Mon, 23 Mar 2026
 19:53:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260314123741.1439792-1-gality369@gmail.com> <20260323173340.GM5735@twin.jikos.cz>
In-Reply-To: <20260323173340.GM5735@twin.jikos.cz>
From: ZhengYuan Huang <gality369@gmail.com>
Date: Tue, 24 Mar 2026 10:53:33 +0800
X-Gm-Features: AQROBzA3OZEa-dxTDTdEcvGHBdv4WQwWgEJqtaoHs_l1lZe8HHeVOpaJt1H8iPk
Message-ID: <CAOmEq9WErj1uq-0ARmnJWMC9byNJD6g2cOAxYOphHjTkwxzpBg@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] btrfs: fix balance NULL derefs and chunk/bg
 mapping verification
To: dsterba@suse.cz
Cc: dsterba@suse.com, clm@fb.com, idryomov@gmail.com, 
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	baijiaju1990@gmail.com, r33s3n6@gmail.com, zzzccc427@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 24, 2026 at 1:33=E2=80=AFAM David Sterba <dsterba@suse.cz> wrot=
e:
> As I understand it you're using some advanced fuzzing tool (patch 1
> mentions runtime fuzzing), so the errors would not normally happen. With
> fuzzing it depends on the capabilities, at runtime it is possible to
> confuse the filesystem so much that sipmle checks can't detect it.
>
> Here checking if block group lookups are ok makes sense in general.
> There are existing checks that seem to be following the same logic like
> in unpin_extent_range().

Thanks for your review.

Yes, we are using an in-house runtime fuzzing tool.
However, after further investigation of this bug, we found that it is
not limited to fuzzing-only scenarios. The issue can be reliably
triggered by using a crafted filesystem image together with normal syscalls=
.

So this may not be purely a fuzzing artifact, but rather a potential
robustness issue that could be hit in practice.

> This is good, thanks. For simple fixes or cleanups it's fine to
> make a vague reference to the main patch or a "in the previous/followup
> patches".

Thanks for the guidance, I=E2=80=99ll continue to follow this convention fo=
r
changelogs.

Thanks,
ZhengYuan Huang
