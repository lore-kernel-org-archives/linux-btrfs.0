Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795190318;
	b=mMWOby+x1q8rpp3kDPJ/fb81Lib/vEvtaDQNgDGZyeFQZMAN3MltSQkxkYAhu5omdbvA
	 BLVQ9zfP+gS3RKxY22ZayQOGhbN1oT6ivuuqAC1FOROYE9fxNGquwkUJOykhUzvx76WNH
	 d1O7ZWDn+ppA1tPQbMtgTCl+lod/85FHbgJr0TCoTkeK4pZcYkQVnOMJZrtJxlhqAVNuQ
	 T8v26Zr03J0IPeqQkLHuneWNwkMLMFMRI4ApUkgRAJBLA+fTWXBNAi8EVQdMJ3y453Cgd
	 UXM1hCDqhbE8Cyvz+mCrKGBXjaiL0BNGN05guOIl06nNgmXkoM5CEXbu9nYCBZwy+FQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795190318;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=6kM0KOtHeHKXYurgzFZtJQepqztK7z7Hv0tSSDFAXAE=;
	b=AOv4Ge6Pd4mYDh+LiOWxwRRhogQ6bMzsc70IOcbIQMN4E4mdoDHFQeSD4+0psGbYwN+7
	 eu7sUuRU+MCTegR+95dJ8wBo1gjQN7LvfyNINjH8S0wg1UklPsSF5UfHN2gSBEXn8lYHN
	 AoWFS6GFpkajjw1X4l3CI7zSGpe7bZBfJTRDoI3d5fVe5BgSMJst4fF51EHIobMLTQhkW
	 003svpq7vsTWEd92ZztjJT3YzxsCVYvEAA11xvEf/UD1LyPybgv++BihR53+3ORCF0tff
	 HmHrgqGyDlPty6BNUCNgmFF18tZGYrABVtQlcIAeCYxlWjXATi0fGIwMDwOIwxeHsEA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=eTc+eMp4;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.42
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06806606A331
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2026 15:58:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 06806606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=eTc+eMp4
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-6b88d143160so1290306a12.1
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2026 07:58:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795190316; cv=none;
        d=google.com; s=arc-20260327;
        b=Zs5uUu92m5Plqqtygzybbnv8yxmzGfwIX/2ocHDwIgDOWqLQV7KmaE1NcF0fUgfUJj
         Lga5LeKgVQzk9kBve748JmXkjf6yG/xSwUdaDWowN8cSDTqyh22kj0E4T788H2zRn3Hj
         VoPBYvVBqIDj9c13/fdWg7X4INV7uVI4jk1J6fnVtfnyfzCrZWfhUYKVFsBrvAJDTpMw
         M/5MNGICbbsyzf/HYCIgD8l8d3B8oEQunsz/GYHq1kQs99XGI16iRYVXKuLc1Z8Jzkp7
         ofkLcR2Tff+MTPqf1v8XaZRJfxgNKyUsDxo4DPy9kfaaITqhJCmu46EjeA+GRQTfnDkl
         KNbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=6kM0KOtHeHKXYurgzFZtJQepqztK7z7Hv0tSSDFAXAE=;
        fh=y1NZKCikMNp3/O6IHQ/em89hk/8mxWL3KMMT4Lukyv8=;
        b=dNyBXXHG/m+1hl05gJN9T03LGuzDt3Dlx32ACTgtbC30iUr1iphn80yXoE1Ro8drPT
         GGhyPvgJZTbkJQfhC7s4ej2WJUPkg8PoHh0B4ATYQvfD4N5BgACXBtEBKmGYR5fDj9kM
         2LtMR19EAS5yc79J+7gp0gagYjad5bVR5OqYDLrJaPASEqNJ8w02IwkfusaRkXnX5iC1
         ct8eA/60FLsMezCAhMWNptegE5RE4v9YiBjvvhe3HcenWqo+if17fVbh9sS6duIhepJF
         uWvZGa39WOcARIRzJjSbPicjFFslD1f4XNtPe44aH/eIjaOJpHNcLde4cKaWQqbPOX52
         ku6w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795190316; x=1795795116; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=6kM0KOtHeHKXYurgzFZtJQepqztK7z7Hv0tSSDFAXAE=;
        b=eTc+eMp4bITMI7jgx5jM4l7NyEFh1c9lTC1VxvFXF9G+vcYBoZB53yLQdKfrQOpf6F
         Mtz8FTmSSTw6Ei7un/2M30yiLReetEhAe/lO4dm/xLE7CcivvqjbhlK/KCKhN5ARxijZ
         ChezPcoSYPSGA4dYvVLO7Yd9kb7uDyVuUiuKTqgzbCAKx1XbYJKzxg+Mx7ccVg34Vcwt
         Sq2087h5YZQNFE89KJ0Ys4A0dIfGzwnygs4zE++uxupxXjpFy9vZB08cycp+xBcweq9+
         96UTqALXMzvyeJr5t/bjHIhkmiHd4xvEUtcz6apgxXUf6gRVWrykVKb8LpEbPe+pU8hS
         b+2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795190316; x=1795795116;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6kM0KOtHeHKXYurgzFZtJQepqztK7z7Hv0tSSDFAXAE=;
        b=F41IlFDzm/lU6rQf4RIW5xgYFL/WYoQJkMWf8BdsyO/jmr+SQ+i0hogluzn2yRPEdH
         TlNzfIGHIA7f6+KOBd0JM+EUhrejXUyCnYucy7DeAl7uCSlhhY1pZGMn3rEIEJy2VMYx
         MCShWlbNHGtpeWKvUa6YFCGQKIF/+iWtRXTCQSBy2lZAJKrJnzv6dxXdRF8nPZm99taW
         KfKp+xgmwHuOMYTCoNT3FgMRqXW8NoGebsMewx03j1AMNp8+6C2zkzHQQZtJbnv9QwFS
         adUMRVMDbUion7f0NkYD6XpVY8tIwStDKlIrR9VEObgdiLT1Jj7pZMYOdt3MuWtg2APz
         uitg==
X-Forwarded-Encrypted: i=1; AL+hErGWG2e/J9fn7VBkITCg+HAGLJn8XRENNNMN1/2uZvSYJgh4UR5ZmUM+YTRD/n7bx6CZxrX05j6FroX1Iw==@vger.kernel.org
X-Gm-Message-State: APuU4Z+e3Wx/U7ViSOebi77sX+Ye62ySj5WqlANNt4KVs1qup9UokH0k
	A2Vo6BP0qvGbNdRW/3tzPJsYkjIB0v4m7Rh+YGsTB8hd/D/i2gSmbhn65WyKCFQQjnU+Phz8H/t
	lwvrYfoETTQnlVHpmpO+6EdNyDDvv358=
X-Gm-Gg: AZFdTZdiokijls7ixiXDJNuNxvU+VZ/ak8nMBMiuxd0fWE9ITg5j2d0WKjSIsduxCiI
	O/NSU+6GX6mvx6OdBEKO5KErwcsbKVgXK7J/VvTgvl4MBmkHhPpzlSXtIBwK5hEnRoajh6u1sBN
	QomQXKO5Cics6IkKLjXjSNWMfcObyvLkTydAsgrSmjv8R62xAk4Tt/04OfP+n3j0ZwsvrBaOI4n
	p0RqJvOkeyYBg2E+wQ1B2gqfnKWGXHXR5XcuOgsVZKaBUEz/zgpK0mpCFnAtQKo/KuEb0z0qFsG
	Pm7XTPSSxS3v//S9p7caJ8n5ECtRP73Wrkmqz2gkM6ePNsAe5K2/J3+IHmvFV/eKk+03d5ILy+d
	FjkK72/m/cmY2uPgwm8OMXMV1UFPm3QlFg5uBwOeD25QBDFNmg/wqwlq/oYAE4J8BaLWOEA==
X-Received: by 2002:a05:6402:52c8:b0:6b8:5aba:6c06 with SMTP id
 4fb4d7f45d1cf-6ba37d652f3mr2090064a12.14.1795190315774; Fri, 20 Nov 2026
 07:58:35 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261115180343.576773-1-koray.fra@gmail.com> <20261115180343.576773-4-koray.fra@gmail.com>
In-Reply-To: <20261115180343.576773-4-koray.fra@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 20 Nov 2026 16:58:24 +0100
X-Gm-Features: Aa3M54pideZA7GJITw5PojgxjktVU6GBxKullq4dSyaJ0XYgg1VLGv1zO6-iMnU
Message-ID: <CAOQ4uxjdEiuJMQxtSL8XrPYHSamtfMh+BM8kS1wj_PVME4JynQ@mail.gmail.com>
Subject: Re: [RFC PATCH v4 03/10] ntfs3: make crtime user-settable using ptime
To: koraynilay <koray.fra@gmail.com>
Cc: David Sterba <dsterba@suse.com>, Namjae Jeon <linkinjeon@kernel.org>, 
	Sungjong Seo <sj1557.seo@samsung.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Trond Myklebust <trondmy@kernel.org>, 
	Anna Schumaker <anna@kernel.org>, Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, 
	Paulo Alcantara <pc@manguebit.org>, Chris Mason <mason@kernel.org>, Yuezhang Mo <yuezhang.mo@sony.com>, 
	Jan Kara <jack@suse.cz>, NeilBrown <neil@brown.name>, Olga Kornievskaia <okorniev@redhat.com>, 
	Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Bharath SM <bharathsm@microsoft.com>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>, "Darrick J . Wong" <djwong@kernel.org>, 
	Sean Smith <defendthedisabled@gmail.com>, Andrey Albershteyn <aalbersh@kernel.org>, 
	Pedro Falcato <pfalcato@suse.de>, =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>, 
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, exfat@lists.linux.dev, ntfs3@lists.linux.dev, 
	linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org, 
	linux-api@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 15, 2026 at 7:04=E2=80=AFPM koraynilay <koray.fra@gmail.com> wr=
ote:
>
> Since NTFS supports user-settable file creation timestamps, map
> provenance time (ptime) to NTFS file creation time (crtime) by using the
> newly introduced ptime API (in commit "vfs: add provenance time
> (ptime)").
>
> To do this, update ntfs_fileattr_[gs]et(), ntfs_getattr() and make it
> persist to disk in ni_write_inode().
>
> The timestamp is now retrievable by using file_getattr() or statx(), and
> is settable by using file_setattr() with the FS_XFLAG_PTIME flag.
>
> Assisted-by: Gemini:3.8-flash-high antigravity-cli-1.4.7
> Signed-off-by: koraynilay <koray.fra@gmail.com>
> ---
>  fs/ntfs3/file.c    | 20 ++++++++++++++++++--
>  fs/ntfs3/frecord.c |  8 +++++++-
>  2 files changed, 25 insertions(+), 3 deletions(-)

Please don't change the unmaintained ntfs3 driver.

If you want to include an ntfs patch work on the new fs/ntfs driver.

Thanks,
Amir.
