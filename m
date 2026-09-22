Received: from mail-wr2-f35.google.com (mail-wr2-f35.google.com [74.125.225.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ACAE54A7EB
	for <linux-btrfs@vger.kernel.org>; Tue, 22 Sep 2026 14:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.225.99
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790085966; cv=pass; b=uifkaIU962T0j6V2poZdtRnYnOkX2oHsLGnbTQDyCrB/xa/Un6sGnepRySHVFcYvPQgZcSELEbZ4dr625hmbcQA17uDFAo4qI8niisWwTnLWhT0+cmowLSHqyZpildaviLVn0DY4GrSfdyNfHNfi2qSUpXu+yYhme302hBvA24s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790085966; c=relaxed/simple;
	bh=FFDGTIkdjwlrSIKakQdYABzBT/A8PNvRaqDPQjmAe6k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GIPHTgzICLma7VOnR5pDajOycDp/i2fVdgfKLNe4+DPFvhcj44DB10ll8BvJkxL/dwtU1TgQxOozEKzOG5ktPulqJull/8BN+i4nEEHZ4uOculEgw1Di+xAZQGSemoMtwXVEa9r+jVHpCZG/5exS2Iv8i1ctd3VXOjIaAgg2X1A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Y2mCWJGM; arc=pass smtp.client-ip=74.125.225.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Y2mCWJGM"
Received: by mail-wr2-f35.google.com with SMTP id ffacd0b85a97d-4885a1480a2so1252430f8f.3
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Sep 2026 07:06:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790085963; cv=none;
        d=google.com; s=arc-20260327;
        b=Ay+eK5weHULXndJkJ0P08KCae/RP6lKooD14Wl3d7Xji5i4ufBDASX0KyziP1o7TOz
         NH0brtlhwokZJ92ycDHeTc6Q2cZeR5erXC2Zr5nZPEuM/Az7N82v0X/9nqlvLeUHimML
         6IiG5TtvGsZca3qZn3sbNxA6/C8V0M5XEnz3w46Ka30KLUxHMOfUnjATNnw2RVOmkUYz
         qGPYcXpVoVUw6REu4lSbx4x2ooTaMJRLaG7peDC8FJZDCy5W/EaDHSx26FctkW8q+tsq
         4Fl9L03PN8xM7Z+fFsP3qAz1HSL0pzc3vb2KfiFoS7Tl0gtgzdzRqFLI61pq9fr9sfek
         /j5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=HQ5Sa3kOLjyBVe2SVv4WjG5tA5uHiXwiU9nv/zosuek=;
        fh=TIE9lPu7Z0zDWkd64i3rliSCyF7ckUtPLREfvMZoJcA=;
        b=I0StuORWZ+inbU7sAw0zaeXgA4jv0DlzZ56cRotB/3rxEAw24bu8XO1HLjrYx39/cZ
         cYAl4nFFQS0dzxfHDv0vqhEEsJJLybeVa/uex+RADVw3TkMOGm4LjncCaz4fDNfXmnkB
         96cgH/xV20oGFCLoSFsiObbr8j5t+EeQQoNP2qtQ/J+wHUJrXyACOCgDzL2/skVPxSt4
         W/SGrI/pUq6Za4ajZzGHcVFsmhjHrYMCg3ymxrdz3tpFw2LGOnRaOKa+/wfAp0zYC3qF
         AIQ6va1FDT/RWeS+MjrFzmOFHqyDUiBKqvMFHhnKmNu9wEVOyf111k7+DczuQl0ys/HM
         DSkQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1790085963; x=1790690763; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HQ5Sa3kOLjyBVe2SVv4WjG5tA5uHiXwiU9nv/zosuek=;
        b=Y2mCWJGM63FTGl4+yJW4u+r0juwVDCmvwuHvh08vBoh/KHFZxx1mQrlB4lOpzLGQkd
         +PoPDF3QjeFaDtroPLiULmOeE+PQFuJ4pwcUXjRAZ8Kdws5qRDV+RttmHRfXlh4FGt07
         ICZFwgy6nM+mR5fslmAPAZNVCuIheNoI2G3r3svUf9EUJqSgw6sDDiDY/Q3BE3V5/2ut
         whQPnVzaooSi/VV/jgruiDIvINZFSRvpb6BFoiqPw25LpeFLwd2bAqVzG38z6CNMBfds
         wjpVpgyQufgMueHsbd7zyqTl9DOLfgyBul+EvaSMTPh6Ekl9YjstZjQ46O7hJanLyAD0
         e1gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790085963; x=1790690763;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=HQ5Sa3kOLjyBVe2SVv4WjG5tA5uHiXwiU9nv/zosuek=;
        b=EiScQ29DluvKhUpLlFjSSNm0Rl4VYUFwiEABUu0MVNCiVx99RSjB2FOyeiXt3egXef
         ZFtsBPpqZkgZIE8/VUOheBB3mF6YAf1BcSqPDpl51zvmxz0KODeeka5ILaE/UIBoMkUs
         nQnZFrgbXSOx+ixtt9g6LW9qoCMS2PcfvI5u/W4Y30rDQApH4MWhZSYC5UghqLzWbKmd
         DeHhU+ghiF4FrFv64V8NzxQ501FNSct1rwgygeCaYl4yQcWb2r2QyUUdpFm62rDdMfnj
         osfP+NVs02K1FUhUDKR+7/TOCo25mlFv+7ahb2JWfG8OXwzNyM8gWjgpb/ZtoxEBpZ8I
         SFiA==
X-Forwarded-Encrypted: i=1; AKwUvBzwj5SO6lEb5Z3JSOYciN8pEX758EhUccACBHUucKVlhkznOwTiaUbLJNHWtOEgx6j+oO3CRz/QyXJNmg==@vger.kernel.org
X-Gm-Message-State: AFuF++mJaWDmJcyM3Z2DPb+hVXbjMO5g8D/fyrXUDU5+LKXjLrzKc/9l
	Z+lPZBJuYFdF9annWR4ibxSRTu5f+l+gxjKZ2Nos7trl3NTXtMSg/eZTfzxbitmSG6NSHNckHB0
	qr5SyGIlASJrYUdD/D7kZofmk5ShdtFPemRNTmOTXcQ==
X-Gm-Gg: AYBFou2paS1HYmSwQ+5SSojSHbA8sh4Ib9kGKHf6PZ6ShT6+K5NMfQ2ZgbL8kzup3ke
	1EHmR1Z9wbw+tvLSG5pyrOzcgs8Ps+sIu1tWSJ2DaM0ZRFH4sRgAQCtqMzb21uxg2FwlgOvmADA
	JXNVAyWuo/joGnhWq6dndH3uwz9F3dkWtVD3d0F5dpAmssfdMvo+rIHKhQdivNtiEuP/WkXVIQo
	90eKnBQoq5tulqJegfi0dsB310DH6/ZkZZRKbUcZ9cFsQMasvmEtPg+H1wu+dk1evuBkFb4IbTd
	j92gm3W5akivawreIGDimZqblG4goM3N1hsB09qiNJhnZCGtyqvGrScpe+lJvDnPWGkjSPjZsU3
	JWpOWTjDHCqzI/TM9I6sr+Mw+LkiRvv0BhsV7fxAJu31aBGqoUuqA83lQPAz+3xv7
X-Received: by 2002:a05:6000:2081:b0:487:936:7ce0 with SMTP id
 ffacd0b85a97d-4871e268810mr20353521f8f.28.1790085963456; Tue, 22 Sep 2026
 07:06:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260513085340.3673127-1-neelx@suse.com> <20260513085340.3673127-16-neelx@suse.com>
 <20260602023556.GC2295@sol>
In-Reply-To: <20260602023556.GC2295@sol>
From: Daniel Vacek <neelx@suse.com>
Date: Tue, 22 Sep 2026 16:05:51 +0200
X-Gm-Features: AclHuK9CuIsJsfiw8COS456pIsuT7e5VI7VW-i2_tJPdheeuBMmFVb8b2MLQ3fY
Message-ID: <CAPjX3FfSeE+WOya6Dg8aLSCRADBvnm0nFBk_uBbaeFM4egvqGQ@mail.gmail.com>
Subject: Re: [PATCH v7 15/43] btrfs: implement fscrypt ioctls
To: Eric Biggers <ebiggers@kernel.org>
Cc: Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>, 
	"Theodore Y. Ts'o" <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
	David Sterba <dsterba@suse.com>, linux-block@vger.kernel.org, 
	linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Omar Sandoval <osandov@osandov.com>, 
	Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Content-Type: text/plain; charset="UTF-8"

On Tue, 2 Jun 2026 at 04:37, Eric Biggers <ebiggers@kernel.org> wrote:
> On Wed, May 13, 2026 at 10:52:49AM +0200, Daniel Vacek wrote:
> > diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> > index 6a37dd3cc5ee..2e0b79f41197 100644
> > --- a/fs/btrfs/ioctl.c
> > +++ b/fs/btrfs/ioctl.c
> > @@ -5159,6 +5159,35 @@ long btrfs_ioctl(struct file *file, unsigned int
> >               return btrfs_ioctl_get_fslabel(fs_info, argp);
> >       case FS_IOC_SETFSLABEL:
> >               return btrfs_ioctl_set_fslabel(file, argp);
> > +#ifdef CONFIG_BTRFS_EXPERIMENTAL
> > +     case FS_IOC_SET_ENCRYPTION_POLICY: {
> > +             if (!IS_ENABLED(CONFIG_FS_ENCRYPTION))
> > +                     return -EOPNOTSUPP;
> > +             if (sb_rdonly(fs_info->sb))
> > +                     return -EROFS;
> > +             /*
> > +              *  If we crash before we commit, nothing encrypted could have
> > +              * been written so it doesn't matter whether the encrypted
> > +              * state persists.
> > +              */
> > +             btrfs_set_fs_incompat(fs_info, ENCRYPT);
> > +             return fscrypt_ioctl_set_policy(file, (const void __user *)arg);
> > +     }
> > +     case FS_IOC_GET_ENCRYPTION_POLICY:
> > +             return fscrypt_ioctl_get_policy(file, (void __user *)arg);
> > +     case FS_IOC_GET_ENCRYPTION_POLICY_EX:
> > +             return fscrypt_ioctl_get_policy_ex(file, (void __user *)arg);
> > +     case FS_IOC_ADD_ENCRYPTION_KEY:
> > +             return fscrypt_ioctl_add_key(file, (void __user *)arg);
> > +     case FS_IOC_REMOVE_ENCRYPTION_KEY:
> > +             return fscrypt_ioctl_remove_key(file, (void __user *)arg);
> > +     case FS_IOC_REMOVE_ENCRYPTION_KEY_ALL_USERS:
> > +             return fscrypt_ioctl_remove_key_all_users(file, (void __user *)arg);
> > +     case FS_IOC_GET_ENCRYPTION_KEY_STATUS:
> > +             return fscrypt_ioctl_get_key_status(file, (void __user *)arg);
> > +     case FS_IOC_GET_ENCRYPTION_NONCE:
> > +             return fscrypt_ioctl_get_nonce(file, (void __user *)arg);
> > +#endif /* CONFIG_BTRFS_EXPERIMENTAL */
>
> Are you sure you want to auto-enable the "encrypt" feature flag like
> this?  It doesn't even require a privilege.
>
> It's also only in FS_IOC_SET_ENCRYPTION_POLICY, so this doesn't work in
> cases where users add a key first.

The filesystem is flagged with encryption once the first file is
encrypted. Adding a key does not change any on-disk data if I'm not
mistaken.

Though I'm open to suggestions.

--nX

> - Eric
