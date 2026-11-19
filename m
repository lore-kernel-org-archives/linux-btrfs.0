Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.44
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795117027;
	b=P0xaRiwOs6vfNugm4pt49Reyx4K/rIJh9ef2Ru9vWe7LM2HpkSJFCmZ5WZKwB9pa9Yr5
	 GZJU0fQ94LbuLSYizqsPWnZ3yt82OTiLNnER9/NEbgaLgBdg1a7tPd/8ZG0WxP1M4NQuP
	 BolSUTUZW1dLXFkFWJ3zU/KjMJVNbyksR/rOMoSgOefZofG8AkLbw6vjmv2RWHU5zMItw
	 hwiYPCeY9LhnZCN7xDkEmYI7RquTimz5W90ecD6vAONM5vJVIzSy21EpzCs6nPw++BKr0
	 wPLaWKx0lfkQeErU+/NZ6JSduebuJWJJOW6PoLziMpCwQOrKj+Qj2o66k4YR/iw6x9A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795117027;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=vs2p+NKw9cBxSHvLMTQ1TCNiiuqtzY0tMFYF/M3imDY=;
	b=YCjKZ6RcCplxNj0z1Nb+4WY0DksPsyRQB9ESKcSAWU8ZcTdq3sq35s0zxWILauswF1gl
	 g9Ka7ftj9BIBj9btcG6Vd/kvT3ycZeh2Qs8zEEeYx28wov61Q3F+Xty2gLFNyK8/O7PNN
	 67qZxfbPAAJO3brLT9neOZIgW0ZRQD8BC6SoOtsy+F/pCjiRgnFR2gt8LRpXEUg2EWMnc
	 x6rcR0pc4K3ouVNPy0ZSn7fhb2uukMCaH5vvtnPleNGlkk2n2S/svx3K1R6UAIxBSIzPl
	 ARGC0NJtns7yLiHKSnO8kquQxNLsAtYhwx67NIHmImsTRcwYsJoR5r6FdnsP5tGsRqA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=b9hNUci0;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.44
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DCF760A2610
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Nov 2026 19:37:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4DCF760A2610
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=b9hNUci0
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6b87a92c17eso156266a12.3
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Nov 2026 11:37:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795117025; cv=none;
        d=google.com; s=arc-20260327;
        b=qFhMRezA3JnNl88OS1+HC/zMuA5YlqqpNKt1k1ZB0pL9GRbjZYjwhtgeXUdSOe5EX7
         OWI6te2aNmVLxcdToJxZofasO43N1MXIUL2akko7HnrJZaL4p4v9rC6RLEU0iXWLNZY7
         TBcFtdc9afA5c2hZczRDVMekI78VaeqPFIIHWDMd09YsptEMqEoa/TnaNblg50fM9B8M
         Xid+/6IRwEpw9kL49IEFabudehAgBzyFdUj7wZCIBbV45bJ7uX7oIeNxzRinPvD1mnfy
         xf9xiyPw6xQStr+Wy3uttUMi4bkS3gQ7UYcZaU49n3yg91jmtdAoccOzLXKlk9NlHTWZ
         XRfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=vs2p+NKw9cBxSHvLMTQ1TCNiiuqtzY0tMFYF/M3imDY=;
        fh=cBHHsSEhxKFiRaQ4gw2C0hFyDjW1JxeaWoujDWJTtKw=;
        b=PACzDHNNuHbG9xKHqR623bH4IdG5UobLvWnG0GbNRZ9WkevRIQr3k50j7vTah3KH64
         dv+SmUMkmN/13dpe9b0xBDxtIwlzTR9DoSjr8V/gRXdTbQQ8nFMr19inP67ZjNS7cBPd
         S43rrge4kM+TMwlx50n9o12BDpo1omLt6J6+0sUuqXFUPnBh/TNdGqwrXPoK26wHpFaP
         wsDHqEzwbkndBqK8IZ4jcF6vLEUylNi0GT2Ei750hoZlYvyENazHrSHQEY6NXMbTUnIG
         JZLQxCH2OHK4piMcNgZdVLNpt6ALIyAtTF1bdYysPWCyGCUhrjh1xc9jNd8CPdqof9gS
         r8xw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795117025; x=1795721825; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=vs2p+NKw9cBxSHvLMTQ1TCNiiuqtzY0tMFYF/M3imDY=;
        b=b9hNUci0rojZWNqoKRlLxiGjE5O/mMAM8AK9l59ZnDFbMczLDpjtuuM0Osoehm0BQ/
         NYKtrZ6N6TrPJMUH8KqItunnDXVUFIisduSqIk3MLFeVCz0C/5j2m/sWiQlzTfIUoaDX
         DGn5aiBa+sgHtIJmckN/9TqGGmW9i3wzMtJl5wRy+R2vF5iEGyoxyRWY8gSO8dzne+TB
         udWcopu9HU0OOPMbxBEnoI6eZfWxlM9zTPiiEpQKxtBZzhYoQIfKQ1mP51+b+Ave0hfT
         23t/TnwEZXjVKNPT0QTy6ThRyPAfrqob2c9GmETVZUyrxi6wC8iOPlASQg6Idz/nwMNC
         9+jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795117025; x=1795721825;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vs2p+NKw9cBxSHvLMTQ1TCNiiuqtzY0tMFYF/M3imDY=;
        b=lPjoAAZDViAARyzMAsol68jKmoK8FwHnl+4KXrwh18iLeQDRZK9Fg8Zrcy0u+0TKgJ
         uRwLeYWVQd6lVdqfnBMiygJYQzqfSnOy+jsZfGRA/mhvhF+HF0Pt1h6BCgLvogrufONi
         6xQe5V/v7sWj3hrRRJ1ux6kNonhgycqMllILFdMKF4W7OyS0ijq8TZla20igzt4C5Icx
         v4FBif6HzKK3qSU4Aav5a3JMHLH+Ny5jjVH++CVq5yJvP+tyd3h4L1AV9SA3csSNU4Ky
         VKceslz9VUmt9QwcT3rmpKv1rCgf7M1rltARfK0gf/A80xHirZosrWMxzXM6QqMAqXAt
         lBPQ==
X-Forwarded-Encrypted: i=1; AL+hErFY04OJUsIKGAl2rr09YMT/NBuZrz+WM7wFTwZA+/QmGHiVNu2v+81tm/xcNBnWsxHX4+hyBSZmvWbpYA==@vger.kernel.org
X-Gm-Message-State: APuU4Z+Ek3qR+DXyJ5CTbvTEorHcPng7xJNCHvry3poW+/Vnh5JyrcFV
	A6ZwNlNoS7R4Ihxv2GDmY5sL99Wz4qXLr8lllJ4O1//xX6yHVIUOcE1jUEBs5LaOG9/0pEm/NHA
	kvCjkXzPJEnq7o8kSkw3QdJqI3xcVk8g=
X-Gm-Gg: AYBFou1XYEgARC7bxaEgB5GjULRpTeMMKTwDFZa7uvl48EBOeNQcO3nwEg5jpdem8Fb
	GxXkC071DbxAjfugWInYCffIOQz4mMzqXTpQOLJxgk3Sx6gubYcI2UG2kFDU9/vbZ3HcSNR/mDH
	2Q+bwrDryRyHnyiJf0o3CFVC6gvKYHiq+Jn0uAVzJ02Uq0rjbE5PysUkANXQVjiXkv1lnZVYrA0
	L4xkk2wKj/B2vy5J4IaJ2BlKlAsG1DC2U2Mqn+ALqMbnkpQuBw36CUtdlDDKoE0u5AN16oPzr2L
	E1sLxvK9b6WbEKaGNkyrwg3OHUgl4dV15f5JXdE1nlu9oWVmZAXu73SOPB4dyMphU6twEiqhHPq
	GbUwh6IpzzKwUgZ/XItSQeABhDJmYlZ3UlmVjOTGrexfVDW3KzKYG3vzLtCYA2pmqxlgXDrg=
X-Received: by 2002:a05:6402:897:b0:6b8:8328:8e66 with SMTP id
 4fb4d7f45d1cf-6ba37d62a2dmr239724a12.7.1795117025446; Thu, 19 Nov 2026
 11:37:05 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261115180343.576773-1-koray.fra@gmail.com> <20261115180343.576773-3-koray.fra@gmail.com>
In-Reply-To: <20261115180343.576773-3-koray.fra@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 19 Nov 2026 20:36:52 +0100
X-Gm-Features: AclHuK-9kUyGBTzq0h8pZyp8mMZSXIXsu9pOi4Bu2Y5vLjqBJOsUk2EoN70jtkI
Message-ID: <CAOQ4uxiRFUqgUMvngvXc1nA7e_HMKSs+aXWVQmAEpcR7yQiQLw@mail.gmail.com>
Subject: Re: [RFC PATCH v4 02/10] vfs: add fileattr_has_fsx_mask()
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
> Add fileattr_has_fsx_mask() as a helper to let filesystems check for
> unsupported xflags while allowing supported ones. Can be used in the
> same way as fileattr_has_fsx().
>
> Also make fileattr_has_fsx() a wrapper around fileattr_has_fsx_mask().
>
> Assisted-by: Gemini:3.8-flash-high antigravity-cli-1.4.7
> Signed-off-by: koraynilay <koray.fra@gmail.com>
> ---
>  include/linux/fileattr.h | 21 ++++++++++++++++++---
>  1 file changed, 18 insertions(+), 3 deletions(-)
>
> diff --git a/include/linux/fileattr.h b/include/linux/fileattr.h
> index 42b92ccdc583..ba7ed3b387d8 100644
> --- a/include/linux/fileattr.h
> +++ b/include/linux/fileattr.h
> @@ -65,6 +65,23 @@ int copy_fsxattr_to_user(const struct file_kattr *fa, =
struct fsxattr __user *ufa
>  void fileattr_fill_xflags(struct file_kattr *fa, u32 xflags);
>  void fileattr_fill_flags(struct file_kattr *fa, u32 flags);
>
> +/**
> + * fileattr_has_fsx_mask - check for extended flags/attributes
> + * @fa:                                fileattr pointer
> + * @allowed_xflags_mask:       additional xflags permitted
> + *
> + * Return: true if any attributes are present that are not represented i=
n
> + * ->flags or @allowed_xflags_mask.
> + */
> +static inline bool fileattr_has_fsx_mask(const struct file_kattr *fa,
> +                                        u32 allowed_xflags_mask)
> +{
> +       return fa->fsx_valid &&
> +               ((fa->fsx_xflags & ~(FS_XFLAG_COMMON | allowed_xflags_mas=
k)) ||
> +                fa->fsx_extsize !=3D 0 || fa->fsx_projid !=3D 0 ||
> +                fa->fsx_cowextsize !=3D 0);
> +}
> +

Every patch in your series did:

       if (fileattr_has_fsx_mask(fa, EXFAT_SUPPORTED_XFLAGS))
               return -EOPNOTSUPP;

       if (fa->fsx_xflags_mask & ~EXFAT_SUPPORTED_XFLAGS)
               return -EOPNOTSUPP;

It looks like this helper is not as helpful as it could have been
and you have raised this question yourself in the cover letter.

Effectively every filesystem that supports fileattr_set() already has
a defined SUPPORTED mask, so I think it's better to do the negated
something like:

static inline bool fileattr_supported_fsx_mask(const struct file_kattr *fa,
                                               u32 supported)
{
        if (!fa->fsx_valid)
                return true;
        if ((fa->fsx_xflags | fa->fsx_xflags_mask) & ~supported)
                return false;
        if (fa->fsx_extsize &&
            !(supported & (FS_XFLAG_EXTSIZE | FS_XFLAG_EXTSZINHERIT)))
                return false;
        if (fa->fsx_cowextsize && !(supported & FS_XFLAG_COWEXTSIZE))
                return false;
        if (fa->fsx_projid && !(supported & FS_XFLAG_PROJID))
                return false;
        return true;
}


...

       if (!fileattr_supported_fsx_mask(fa, EXFAT_SUPPORTED_XFLAGS))
               return -EOPNOTSUPP;


>  /**
>   * fileattr_has_fsx - check for extended flags/attributes
>   * @fa:                fileattr pointer
> @@ -74,9 +91,7 @@ void fileattr_fill_flags(struct file_kattr *fa, u32 fla=
gs);
>   */
>  static inline bool fileattr_has_fsx(const struct file_kattr *fa)
>  {
> -       return fa->fsx_valid &&
> -               ((fa->fsx_xflags & ~FS_XFLAG_COMMON) || fa->fsx_extsize !=
=3D 0 ||
> -                fa->fsx_projid !=3D 0 || fa->fsx_cowextsize !=3D 0);
> +       return fileattr_has_fsx_mask(fa, 0);

            return !fileattr_supported_fsx_mask(fa, FS_XFLAG_COMMON);

I hope I got this right.

Thanks,
Amir.
