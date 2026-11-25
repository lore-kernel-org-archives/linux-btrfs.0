Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.217.48
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795596100;
	b=LK1neP2No+nIQch/r/B/QbB7anemw/vVVfAl4MOkej9qPAcepTeXo0eJbdXzGhv/+oN1
	 qgiTRnbidCfKZNaGln5OdA91WDCrzBzlfkRApwDauhfGrXtCviaovQcWlklnTgVC0w94b
	 jAmBquMyqR7lI6PN6Z+ngwGJ60yDt3OkDLn2xPg+ZT7W7Ue8IS1H8sbGa9dVliqLqbyYr
	 lpL11eB24QoC1aWa2/P/Vp0n/RYRQJ6wRU0e1C9Lx8sIc1/hKw392tBItNVqE1xnjT0S8
	 RdPH+HcdtCucKYXYIkTBuiBG74vxGN+zbIBYj3+tS3u4HGhgONWTVNAmxWBxPKl5ejA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795596100;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=Lp4KSpaJJW0676zKo+5hv0erp/pxgQYu4sNa6Tht8jk=;
	b=GWynPTY092+gYAeQGASfiIb8UvZxiCNME9HIWFh+lknbfNNYKwYCiEGPTssp8VCEJxKe
	 9DNNJQMws21u3yePeHuWpgAB3bukeR57VlMunucz0GZNuqCJpupoxYHrD7u9zH4bolFko
	 dxzs4zgYdNRL1idLcYlLdDwnObrBvYa+5X4b60TDByB1icMaTr3CjPDket6t3VhrQR3UJ
	 4RNmj8J7cdmVW3Kxe9j9YB59JI3QMtDV6Ii5Fz5W2uld95ILvodGdfeF4KN+3EFmuvEhu
	 +vxJ1lBVJ8wRf7m8CsmjyviL3noxJ6LApZ3o8Fk3/lku9POxasCr2gvqq7EsSmjJEuA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=hAKhTrA5;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.217.48
Received: from mail-vs1-f48.google.com (mail-vs1-f48.google.com [209.85.217.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10AC7606A31E
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 08:41:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 10AC7606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=hAKhTrA5
Received: by mail-vs1-f48.google.com with SMTP id ada2fe7eead31-7d2da1667b2so3398171137.2
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 00:41:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795596099; cv=none;
        d=google.com; s=arc-20260327;
        b=d3TD8mIjtwXd6K8P+myLcwzB8fLtoviHICyRxUdWzqGAoUu8P7E40ZgZ1dP35UNbSw
         3R6DZFKOWYNf2FTxg8KrdOKs8edvn1cE58oF9vJTm4TJLPadDvdG9Ae3b5cj8/3z2ucO
         34D+FDlh70IN3flmhHe+o3ceV0wHbyihgbSqzHBgnhof0AAvROX3fqdjYBGzaCseI1o2
         YxwBkE/FvDA1Okacy2uPb4MH8dLJiLe+cagRyrzleZp42/aZ701Sak6R07k1Pi/ZJqn9
         jNd8818LBmeePmgmVpr4gWCO67B/EELwELopB+QZRR0dcAmBA0WIvaNRjYRyMkQaE2NC
         m2/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Lp4KSpaJJW0676zKo+5hv0erp/pxgQYu4sNa6Tht8jk=;
        fh=L4ZT/zj/gzdC2ZgPVoqR4uRRo4jAApvhJ+/YGG7OLHM=;
        b=Iv1xfsmZgGKPLBrzlwnElhcmw3uQMc7RCIUEi0+nsi8jhA7rXUzk8kIwtlV+1nyHfu
         x9ChFwMsPKMcn7PdmZ7lCdmgrFgEcF9YyR2eTulVZvS3QGVszP8PABK2HQ+UBySwjJxT
         Hflmu7tdsYklnHFEJef6oYixgd4A35ZDw15jORC70E1ZaMU9N+cjo2nd63X4xLgxp5Ci
         UhLgvRBTRRmHR7Dcrh4OuXvowSscGP63iUfEKCSRENTwH4VXDfE6NkRG7N3BJy0gOi/J
         DiYn64yPTO40UFlpOcDV7cmy1OPHFHDVENcw3NN3R4Yp4oIq1/gkBKiY144gM5W3D84m
         tHcg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1795596099; x=1796200899; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Lp4KSpaJJW0676zKo+5hv0erp/pxgQYu4sNa6Tht8jk=;
        b=hAKhTrA5RGL6UMu7HXNzGfvIKDSgJ3fdqURVV8uH9LKcK/lma0bV2zE8Oi6aPjQ7dX
         XAY57YI9xXym3WWZwwtVq8xuUk8KxruGkenlol6HqSYVV22k9o03mOAyb9fzDJYwUCNI
         kqdZUjjNAZJ15+w9Yi9cs7WHW45uz2Jsg6fz9XaCuXjgPAPCPqR75CB1NWfIZtPiogni
         0RusQskcWY9uvbV8bJOR93vVJyecBggym0iNZ8Xlib5CwpNHg370c4zPH1GEFhFh29Iq
         vv3pJHl6CCpA0Qug+ffUeE55av5rjJiKK0YO2UO1LeWN4/zeARbhR4W7uTYnpjH45Z+v
         sQ6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795596099; x=1796200899;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Lp4KSpaJJW0676zKo+5hv0erp/pxgQYu4sNa6Tht8jk=;
        b=omMY/FD/biZywdcR3wKU90eAaNalL5YFNV16pqhqvEM8pmEN2ywbUCIzUcTAq7nvpj
         H0q4gBNX9ta3iGPSow3Ukn/7JSZXlKfW1UTjWKY2IUDSxJv4QVUkmyczisutpij42wAu
         FtmnUWyCDC1iAWjaeBIy5kYe5ORU82wRuAQ39cF6WE/vEq5F7KRXKlubN7kzFZ316XvN
         7Ji7NVo5Cblnc4pJWmXIvrETUBdXwdQEyig9ehSsl19zC4WVG0tglry7pjI7bIZ3S6gu
         2hkCuRxk37JNs6VEOflJB3CUX4o1CmZvxp70elIj/qs5gzetGDgKwAQVbSG4gRWYeQBw
         r6DA==
X-Forwarded-Encrypted: i=1; AL+hErFAWwAEsmmwO/fZpSY69glTFHBAQoBxol+iw4KzCuuet7gY5LMdlNVoaaakP/NLWQlALvM9AECZVsObGg==@vger.kernel.org
X-Gm-Message-State: APuU4Z9xPg5NKpSZmrpgDP5w5LFiiXitHQvlVdbQOtMIHSBLghkJUcA7
	qvHp2Ngon8w+MJqrjMBHpMR5Ro+HQbDKcEBIf6O4mN9XICsAegaLj/w3uSmGiXTsWFf6vVNs3eY
	ybIagEGhug1z5NQgx3JggUy/23vaw2+w9XXzRN0K6tho=
X-Gm-Gg: AZFdTZcl66MXOy7KN2gJDhucXCSXr7BsutbNsbek8WU+BEU+O0X50lUgs4eu1pC1twc
	ayOpKaVgf72e2k27pum6WKEPNuH1kLUVrFO6rVpCj+AxSZ4zl47lLW0CDePxhlOmoTn/lJnDWj2
	Auc+mgHTPP0AZazsFPE95bjrWnVo+htxKImdb1/xIQXxxch5MjHMEvmbA/wdB/cJ1xppTzqCWF0
	eHqBYSmoMK2abrF+ipkWuu3yIGlDAlaknGygEHb+aGDhkrP/aRsk0HK8iwP9fPeJ5ZFKJlxs5W7
	0yDjHsfVQK++HBTjA4WIjvaomKBNhwq8aqas/hwb2iSpn56wnnckfTbSSjHWCMEg5AlgwJEs1eE
	OIigqraXjs+kQkuirsc60X5MYLSZo71MCqgxLw9CFXhaPVTXt87X5T/ehS27fGQ9kjSU=
X-Received: by 2002:a05:6102:3ec7:b0:7c3:1395:a090 with SMTP id
 ada2fe7eead31-7d73937f6damr9508185137.6.1795596098803; Wed, 25 Nov 2026
 00:41:38 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261124154604.77736-1-alex@amutable.com> <b6147b91-d8ef-4fcf-bd87-0bc30f2aa741@gmx.com>
In-Reply-To: <b6147b91-d8ef-4fcf-bd87-0bc30f2aa741@gmx.com>
From: Alexander Mikhalitsyn <alex@amutable.com>
Date: Wed, 25 Nov 2026 09:41:25 +0100
X-Gm-Features: Aa3M54r0mho5lMGkj3mf5ZLv1n2FmJxfhpTTnq6frY_gtTq_pVu4KngdlCdJN_k
Message-ID: <CAL65ydRDgFSFk-J=aOEWzof64B0dB9E+4f7X1aCk-1znvh89Xw@mail.gmail.com>
Subject: Re: [PATCH] btrfs: use super_set_uuid to support FS_IOC_GETFSUUID
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: dsterba@suse.com, mason@kernel.org, 
	Lennart Poettering <lennart@amutable.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 24, 2026 at 9:58=E2=80=AFPM Qu Wenruo <quwenruo.btrfs@gmx.com> =
wrote:
>
>
>
> =E5=9C=A8 2026/11/25 02:16, Alexander Mikhalitsyn =E5=86=99=E9=81=93:
> > Currently, FS_IOC_GETFSUUID fails with ENOTTY. To fix that we should
> > use super_set_uuid() as other filesystems do.
> >
> > Reported-by: Lennart Poettering <lennart@amutable.com>
> > Signed-off-by: Alexander Mikhalitsyn <alex@amutable.com>

Dear Qu,

>
> Reviewed-by: Qu Wenruo <wqu@suse.com>
>
> Will push it for for-next if no other review.

thank you very much for such a fast review ;-)

Kind regards,
Alex

>
> Thanks,
> Qu
>
> > ---
> >   fs/btrfs/disk-io.c | 4 ++--
> >   1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> > index d8d433ac458b..fde9f4c4ea11 100644
> > --- a/fs/btrfs/disk-io.c
> > +++ b/fs/btrfs/disk-io.c
> > @@ -3616,9 +3616,9 @@ int __cold open_ctree(struct super_block *sb, str=
uct btrfs_fs_devices *fs_device
> >        * on-disk UUID directly from the super_copy.
> >        */
> >       if (fs_info->fs_devices->temp_fsid)
> > -             memcpy(&sb->s_uuid, fs_info->super_copy->fsid, BTRFS_FSID=
_SIZE);
> > +             super_set_uuid(sb, fs_info->super_copy->fsid, BTRFS_FSID_=
SIZE);
> >       else
> > -             memcpy(&sb->s_uuid, fs_info->fs_devices->fsid, BTRFS_FSID=
_SIZE);
> > +             super_set_uuid(sb, fs_info->fs_devices->fsid, BTRFS_FSID_=
SIZE);
> >
> >       mutex_lock(&fs_info->chunk_mutex);
> >       ret =3D btrfs_read_sys_array(fs_info);
>
