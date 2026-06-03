Received: from mail-yx1-f44.google.com (mail-yx1-f44.google.com [74.125.224.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8F0334E75A
	for <linux-btrfs@vger.kernel.org>; Wed,  3 Jun 2026 14:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780496036; cv=pass; b=JXX8awjZ9TQ6hs2C/i2nf0Ni3aA16MdJo4fOoCtSTxxvBLKqUm3Eta0SaOqL+TmEoXZzDmBkiFu6FVypwyyReioUTaaHmHzAV6IlkMqCJ2BtYiXFr74pvO5wF0dJ6P8mA8n4Nggj2kp+JeXnXTGCHluSsW10bDzdmp2UK1oPoH0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780496036; c=relaxed/simple;
	bh=+TNhH4uPMA4pZSGEbLGq5mIB/DImZIsrwQF//XE0Uqg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=K6mwCT26SIscVEspSPlMv+ZL3Zv9lVsu6/vOoWnxDQSzhrhai6I2TSH8lz3oZPiBP45IRP+JQc1ZvPP3Re6idG36QKbqXYKekZ25qf++iSCvNjB7gZ7uAAiA43fohvb5Ju8V1MWEiVuYrG1ZZNh8p0xatHIYPACI1TM1tgcUi8Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k9hbFPVi; arc=pass smtp.client-ip=74.125.224.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k9hbFPVi"
Received: by mail-yx1-f44.google.com with SMTP id 956f58d0204a3-6606678420bso4164150d50.1
        for <linux-btrfs@vger.kernel.org>; Wed, 03 Jun 2026 07:13:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780496033; cv=none;
        d=google.com; s=arc-20240605;
        b=V7ca1nWyRcMRmhdxQq1vT5T/RcfWai4O5pv192JaczTmec6gKXh0VCLYxlrYKKzOyH
         Zq47YgZymW+L5Vn/++xQYqE1G9rzSoyHPhsWfOI2C1E5AXuWJv5oAdRedMs4IlLwAczJ
         BcV8+gBjN0Qxi/VieGslgKE14sdAdqbQgrCE0IZUyX55PndyP0sEayqf7YzwF8gqq3gr
         BwZ3HHiD/MrfcMTJuOPsDwl+blugmysS7t9C8nU7cEfPZ9NJAzBOaSareRTv8LudDhVo
         zWxMT+DmYpKBnYJ4dkjJVyL18og/8Nr84B+BSoR9v7j1bn1IF5lbb4aU/X3CvpAHt9Ip
         90HA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=OHDwKrQRWM5Fcvzljf5JN9wEcIOO5RlR+9gC69vOLvk=;
        fh=OkOf4Hpd8AGrg/D1ANcQmsTTNCnpczafvJqbfJjHb+U=;
        b=ZosgtVv5h4ZXiZIVgLeinuU9zraCerXS0aJ9L0gdvepVzAhB6U3E55mo0tcx0yPKf7
         tElCqzgBXnGbDfvsxs88tEfPb2vl4dkzM7RHi8RJxkMm7w/Sp2maLiV2LFNU3h7SOkyP
         Tb8US8V0DDr4xC2VrUgvU5J1sOMij3xH2xtVYW3RpXTEUpI0rnDk2xTSGy+IAEsU01md
         pNPmMO8TpFOk7VD4o53U/bqXrxw1VugVuUR7Du4GN+eNXV/RUaYYCNIbKDvCqatH0AT/
         tb6x9KKrem2DzaMAsj1zV4zLouPHdI/d7tVfxGoN6EQtCz9HHlcLLIuAK+WNx7a+91Aw
         aZ/g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780496033; x=1781100833; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OHDwKrQRWM5Fcvzljf5JN9wEcIOO5RlR+9gC69vOLvk=;
        b=k9hbFPViWkjUNdRa6DsQRKJz7cm0r0wY/QJ/jFBScaH2xVEbu57z8j8/ixim+ZB0ac
         dyxR8hMKz4DsMO0YiKiVaDbFvdjcSTrERw8GQlAOW26A5N9nhrtJtybzjkOs4gdM0sHO
         suEYYvZaHABSnLZtc8U3ak+fFRjVXu/A35rKVsVtuaoqBtwz/4qcDlJZlGHIRt/FzHUT
         6P4liA2dVKjhMTnJhYZvdbz4hxLoFrrs7yGj3hvMFE5zNHOBcLpQAfRF8tlQwAz39FaV
         BK+rS2FXPjaB8vxVhZB//Uw2ToT1h5CIiIC/acCCnbZ4AK9IbN2tyYQwVbzEjHnroriT
         XhTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780496033; x=1781100833;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OHDwKrQRWM5Fcvzljf5JN9wEcIOO5RlR+9gC69vOLvk=;
        b=NeqeD7veZx2G9iWHv70fQs+LT/i5EoOBtkOR76Isih8GqpPw0J7rDXiR1nLjAUInA3
         BERgl6Rv9LWUleZgRCA3coEGwooELO7yx3qJFJ/fTQvM9Z+4qMum6XTGyweBAL5WtwJX
         598Yn0+p1AEDxx8AbJLbon6BfJHvsbY3EVrPuFTlqcih5G6ZJ8AhtFiMbWZgflmCuZtm
         K65Y9biArGbzQp8wfU98uDZd5r7EwACVoJle6c3jBPbzW2Zx2//dSRL9Qi8UimqLUqt5
         D8PFAA5XDzoEXadHd/N45zPdE6DZnVY4UUO0MxSyH1CKx7LnLHVNUcqNPt3IQTWnHMjc
         V9lA==
X-Forwarded-Encrypted: i=1; AFNElJ8pJi2CPoARUAerWXuun+rEEdbFm8OuKJPQnQW9zftzOlp5lilN7RXhh1SD04YJISFntrQ+v5Sr6EAjUA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyU58d2tNLbaJzZBLzYD8LSB+Mb/hcFNrXoRhH4wP6sYONHXalS
	tEv45d6BblNNmKhdLWTKuNMLa6ePzERWGoyeVFuY1AwDW9K9hhBRtxPlip6o9/6H1dtjJy3BLVY
	BdA0Ony9stX/u4NY9Ki/LZvRfZPdqAzQ=
X-Gm-Gg: Acq92OEIJcxUow7HZzm1p/968cFG+7KpjyuKr8Aj1EmEOTSRroklvPDBCEpTZ4qeNX5
	8djfh8XpeXO0g26t9n/PoU35icZd11za3oH4W13C1vU/PYLZ+hPBGcz96rDqFUCWvWaCSwouwvi
	9fDRusLdx0v1QFLnix73y+2BXzEJ65yJLZscQDoADFvKCIf9SP6tPSpcqQ0QmJO93seuCS0KwqN
	WCriE5QgQvHhPuP/COLXAPhXzdWoghyWDafR/XxzgYsVqxVbcGMrny1Nb5fTK8qfv+QTLataRvt
	78UQSSlyCgptN7uloAoR
X-Received: by 2002:a05:690e:191b:b0:660:32d9:22ca with SMTP id
 956f58d0204a3-660dc4f1d01mr2977480d50.43.1780496032663; Wed, 03 Jun 2026
 07:13:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260603120443.1394044-1-lgs201920130244@gmail.com> <CAL3q7H4qiQfY6ZjGPnqhRm=nteYmg-4vCb-FwV6eA5NHy1bthw@mail.gmail.com>
In-Reply-To: <CAL3q7H4qiQfY6ZjGPnqhRm=nteYmg-4vCb-FwV6eA5NHy1bthw@mail.gmail.com>
From: Guangshuo Li <lgs201920130244@gmail.com>
Date: Wed, 3 Jun 2026 22:13:40 +0800
X-Gm-Features: AVHnY4KYIu-BE4rxt6QXQGm4uJUifj5_dRLDJmfKFMz3JRq5BKvMJ7w33Pa5n38
Message-ID: <CANUHTR8z2_gqPDvE+yW9RGPh+dzC7mw7w6V5xGhiNFpOEGS6wQ@mail.gmail.com>
Subject: Re: [PATCH] btrfs: fix inline reflink deadlock at non-zero offset
To: Filipe Manana <fdmanana@kernel.org>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, Filipe Manana <fdmanana@suse.com>, 
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Filipe,

On Wed, 3 Jun 2026 at 20:36, Filipe Manana <fdmanana@kernel.org> wrote:
>
> On Wed, Jun 3, 2026 at 1:25=E2=80=AFPM Guangshuo Li <lgs201920130244@gmai=
l.com> wrote:
> >
> > clone_copy_inline_extent() can copy an inline extent into a page of the
> > destination inode before starting a transaction. If that page is beyond
> > EOF, writeback started by a transaction commit with flushoncommit can
> > invalidate the folio and block on the same extent range lock held by th=
e
> > reflink task, while the reflink task waits to start a transaction.
> >
> > The copy_to_page path already updates i_size after copy_inline_to_page(=
),
> > so writeback no longer treats the copied page as beyond EOF. However,
> > clone_copy_inline_extent() has an earlier new_key->offset > 0 path that
> > also calls copy_inline_to_page() and then goes to out, where it starts =
a
> > transaction. That path still leaves i_size unchanged before starting th=
e
> > transaction.
> >
> > Update i_size after a successful copy_inline_to_page() in the early
> > non-zero offset path as well, matching the existing copy_to_page path.
> >
> > Fixes: 05a5a7621ce66 ("Btrfs: implement full reflink support for inline=
 extents")
> > Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
>
> Again?
>
> You already sent this patch yesterday, and there's a reply:
>
> https://lore.kernel.org/linux-btrfs/20260603120443.1394044-1-lgs201920130=
244@gmail.com/
>
> > ---
> >  fs/btrfs/reflink.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/fs/btrfs/reflink.c b/fs/btrfs/reflink.c
> > index 49865a463780..5722cccb53eb 100644
> > --- a/fs/btrfs/reflink.c
> > +++ b/fs/btrfs/reflink.c
> > @@ -185,6 +185,8 @@ static int clone_copy_inline_extent(struct btrfs_in=
ode *inode,
> >         if (new_key->offset > 0) {
> >                 ret =3D copy_inline_to_page(inode, new_key->offset,
> >                                           inline_data, size, datal, com=
p_type);
> > +               if (ret =3D=3D 0 && new_key->offset + datal > i_size_re=
ad(&inode->vfs_inode))
> > +                       i_size_write(&inode->vfs_inode, new_key->offset=
 + datal);
> >                 goto out;
> >         }
> >
> > --
> > 2.43.0
> >
> >
Sorry, this was my mistake. I accidentally sent the same patch again.

Sorry for the noise.

Thanks,
Guangshuo
