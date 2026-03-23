Received: from mail-ua1-f54.google.com (mail-ua1-f54.google.com [209.85.222.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B62424BBF4
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Mar 2026 15:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278242; cv=pass; b=pboiktUX/IRy+8R+7t+XdiFuIDcJX9dFi5T8CNrgzSVUFCpWQ+O8LAUG+e27Z567Hm8kBlsfV+frXyiAXeLMZbm4lFJvKEkQeNbgSL0sqQ2eianrndpSSNuI7MZdVhzQNyryUzIR9fKPmoTvWORNoGJ6z4S3EiRptCybuROuA5E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278242; c=relaxed/simple;
	bh=Tug/4vF6i+EFoYFHtuwLMTvnSCngC6OLP0EY3zQBA6A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nHvseUd78QppZOiVrfTN/FnFs4a4JSaH6TjXlIdcQQReflBNq3jxITzxzDHuCa+Oh+1OWwWP051ImZftViycU02I74wmRhW1DgoTaO+55iSNnlNi6vpMlc5itIS3MV6eWtBOnwED2u022wOtUXSu8+Ur0wCDxbtMByDYSMa3PzA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HlEs+xzm; arc=pass smtp.client-ip=209.85.222.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HlEs+xzm"
Received: by mail-ua1-f54.google.com with SMTP id a1e0cc1a2514c-950bcf4df06so1031237241.2
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Mar 2026 08:04:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774278240; cv=none;
        d=google.com; s=arc-20240605;
        b=eV7Mf/DKcctOaBXN3EMJWeWQy8mMEqGO+MuscptbLXYCmOjf2u5CLiY9RPABEcdz07
         5Z2KRQenfXjcHr6v8Kxz2GgteN+CPLxAUvuGpwHEFvdkNGWr1QCNiT+cDSfwiTv5Ff5c
         hMqgnlQqNy/eKNYBwtdo/Et7SHMDDF2O3NEiVtGsAeHS6Hlqd9GEspMX8mztOUG80Ij1
         2FJfCCfbex2Pz5eov+kQ5vFaXAZErQmhtncUGLTVX3KAj5xkQn+6UX/NqybTTIw0NpxJ
         lOsfGUcnshT91zU1AJlmKgt5csHFg5c7ZI6yaBvCnjIIdJ13a1b/5k/84dOQoIyziFWK
         9iLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=50VluyC4NRM1/eqrJs6iKu4yqt0bwVbQTCVVEDg9RSk=;
        fh=kivYlUhNphJapIWXG4P4fGNUMUgWu5f6MV2b/GQ1gC0=;
        b=Pqpbm8UgmaWbNAgk4ERP6Y3Ht21g+ynhzyCxlhspXOXp/FuUL6sef+IYr1R8WiVeHY
         LvYx/+L7K/NTQILvkfq3miABE3FqFwB0P58vS6jYpWXCxyQ0FdzirlvTp4B6lxpuWqyc
         8DOS6PJbFeac1GaCvjkppRUo8YkNmbMreUfRfgMWHpR9N4EHgoHok8bYw89EZGDYX7So
         dqu1mUJpJUGcMDQQY6WjaBvTw7peTxF1JJUa6AB8gfvESvWRof1+x5PJJlA4nF7TeIp3
         i83pIy+Dn7pfa6m5rVF1tkT9SN+r2n0VwSlS0OJFpagR1/LB+TVa1Nip2I4rWRqfAZDW
         NAbA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774278240; x=1774883040; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=50VluyC4NRM1/eqrJs6iKu4yqt0bwVbQTCVVEDg9RSk=;
        b=HlEs+xzm7CIKjdfEhAHvDoppxJatqYZ0Ge5FvfsWjJGMiV206bNJRagCAQCgzHrHzc
         oIg7OeqnhaIAHgIr8T3Rw8RAcRhhPNGuuQwMYr2GkZLcZySWjHUhc1ElOk3Pa6xojPkQ
         kj/jyFzDSvDjT95GW36hHoZw+UzH1m4V3zFEhslh4NkK9eoBnlMlDypAU3R0Yjmf1wZG
         KGhcy4e/AMJ8H5Sx7yH+vRvMrBZ/fRneIcoBOOwW58ZGv6gwEb3qfEgsE4hijPfGO4Ow
         xklh5u6HYqX1LEGyh7kx03ZtDX/seIdkbv24ehTmNHf0Q/ZCNH+qJgMmN4xJGUm2owbW
         E1hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774278240; x=1774883040;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=50VluyC4NRM1/eqrJs6iKu4yqt0bwVbQTCVVEDg9RSk=;
        b=W0r12HbPo+zf/+a94PHrxeHeoC+vS2rGdxcMYE+lv2+oO+CkIG1QlyL2oyTuPH8tK9
         DQQcvO5KNPErecy3nKHMsg3xK3PazoMNKQE1ZGz+YwVDnTQqXCsNdVrnHwVifuD5qA9D
         yJvVrcikyC3O/PPZR7yFGsQP2JfBQiz8VfmBL5QM5DjmMIHDNUKqmplNnP2P4NTC6IuF
         TTXHRLUnCyvjtLOYobC4KWeiLL+4a8BhcKEXjMARdSQvEfzLmJC2Ogd4gWNJwzvT6SH5
         Sb9Wnkfq+K7G3rhqvo0Tkqgcf5Ma3V1V86D9MoJWynqnJ3Gz3YLYXSp3onkbx/46sjcX
         vk7A==
X-Forwarded-Encrypted: i=1; AJvYcCVcZyWFUrnnmhaz4FCDdCkNcawH1thyCh86beUBBsSOveXVBQBSTSs4PmQMOnBcfGf46yJk9yRZ4CUL7w==@vger.kernel.org
X-Gm-Message-State: AOJu0YzTONI1wwaFSIMuyprs5W5Rg6GFg150Z2lQi75zSpb7pZu64piY
	KIHXH1amDCA/WyaofLkZUZ1tDFs6MGSsZ7EqOOPY4Pg6aUMkyGqtMa/Xn8De8a8eVIkOOH3uZ5D
	UzkLOw+bwJdDXfIyWPf97cnnWaC4LIfA=
X-Gm-Gg: ATEYQzzdcXt02DBhqp8pg1UrmXxa4ebiPh5POkTLFzaynOeuRKYZX2yqTmmuNrL5fa/
	rUaKb7rEyFys4sE1gGzqsDMuSxZ6+VoGC6ETmbv9L2YIxqacX9G/u1KMT0FUPzA5+SetY1uoYi7
	lN8u3osNw/8fmZ8i1FUe+NNzOMekDOaatTg5EI2w53OR0aEAMsF6lKsNrYYeSxIgzpwAL9YaBpk
	C4QuGmjhPm2ZEfqWekGhyg27mbbMfKRb4qCLMhOigXsXipL9v1RdH/ltBhQgONtmtprsgpEn3SP
	QZVCpg==
X-Received: by 2002:a05:6122:46aa:b0:56c:d66b:7516 with SMTP id
 71dfb90a1353d-56cde42b4d0mr5561282e0c.13.1774278238396; Mon, 23 Mar 2026
 08:03:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260322063935.3951728-1-echelonh@gmail.com> <20260323142633.GL5735@twin.jikos.cz>
In-Reply-To: <20260323142633.GL5735@twin.jikos.cz>
From: Yochai E <echelonh@gmail.com>
Date: Mon, 23 Mar 2026 17:03:47 +0200
X-Gm-Features: AQROBzB1-r1jUNY2nj_lKEdB1dg45-TJASePpTyWgQoxa8_1Rn7RffslZH8uSuM
Message-ID: <CACo1jfiWUVViXh7FTeWyFpubudq-qF4=hJZOFcEF0n0OZLVQtQ@mail.gmail.com>
Subject: Re: [PATCH] fs: btrfs: fix btrfs_ioctl_space_info() slot_count TOCTOU
 which can lead to info-leak
To: dsterba@suse.cz
Cc: Chris Mason <clm@fb.com>, Yochai Eisenrich <yochaie@sweet.security>, David Sterba <dsterba@suse.com>, 
	security@kernel.org, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 23, 2026 at 4:26=E2=80=AFPM David Sterba <dsterba@suse.cz> wrot=
e:
>
> On Sun, Mar 22, 2026 at 08:39:35AM +0200, Yochai Eisenrich wrote:
> > From: Yochai Eisenrich <yochaie@sweet.security>
> >
> > btrfs_ioctl_space_info() has a TOCTOU race between two passes over the
> > block group RAID type lists. The first pass counts entries to determine
> > the allocation size, then the second pass fills the buffer. The
> > groups_sem rwlock is released between passes, allowing concurrent block
> > group removal to reduce the entry count.
> >
> > When the second pass fills fewer entries than the first pass counted,
> > copy_to_user() copies the full alloc_size bytes including trailing
> > uninitialized kmalloc bytes to userspace.
>
> This sounds correct.
>
> > Fix by copying only total_spaces entries (the actually-filled count fro=
m
> > the second pass) instead of alloc_size bytes, and switch to kzalloc so
> > any future copy size mismatch cannot leak heap data.
>
> Trying to hit this race looks very hard though, reducing number of block
> group types is quite rare.

I agree that this may not be your btrfs typical behavior, but I wouldn't
have raised the issue if I wasn't able to prove it. I can send the PoC
code your way if you're interested - it leaks kernel data. A malicious
user can utilize a fresh btrfs disk over e.g. zram to trigger the issue.

> The change to kzalloc looks like best fix, for all ioctls that are
> exposed to userspace. Copying the exact number makes sense. The other
> case (copying too much) has been fixed in 51788b1bdd0d68 ("btrfs:
> prevent heap corruption in btrfs_ioctl_space_info()").

Just to make sure we're on the same page:
1. Following the above, do you approve of the copy_to_user fix I
    suggested?
2. I think it makes sense to treat other ioctl kmallocs in a different
    patch, no?

> >
> > Fixes: 7fde62bffb57 ("Btrfs: buffer results in the space_info ioctl")
> >
> > Signed-off-by: Yochai Eisenrich <echelonh@gmail.com>
>
> Added to for-next, thanks.
