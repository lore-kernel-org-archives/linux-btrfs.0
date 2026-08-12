Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 237DD353A7C
	for <linux-btrfs@vger.kernel.org>; Wed, 12 Aug 2026 14:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786543293; cv=pass; b=YMCyew4nTbUaQPc8p7yNt5wgAVGTgXFnI6gLnh1sYt5s6HoMSx2a5cZdPNeiyhBoB4v/PetISN0CyuAEE8GJRu3Yo/v2Xsy1bR2awHxSagSIj9pN8ddwvP8DgPc2NKU0BfzbcjGXErVzFSBQCN18tSjmzFqZcGcSxzyWDhBmL+Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786543293; c=relaxed/simple;
	bh=NwhV7wARecxQh7esHydA5zPzLYoC9TtdLCxqqsKZyKg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dJ7+B3OJONL0itnszIwun5KEE55MqWVcinrH12enFypveRL5BfruAs8gawiA3WyfIKFz+/H8t3dDJX9M34EDkv+cVS2jn305M1A0tGXoaWY1ZfB4PuvJR/Hz8XfHeVEaU8q+01G6x/8n3HSptoyBJBDpIIsDgmTSEoy9wwt2/MU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=bMzpZF95; arc=pass smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="bMzpZF95"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4980fe6b3beso16637495e9.0
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Aug 2026 07:01:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786543285; cv=none;
        d=google.com; s=arc-20260327;
        b=ToB9eppsvTD3B+6ZMx6K8loLmAIcRpFWTYwtD9FTzW/y8RmD0yjbawyEkcPFOUKTK2
         4X5bKvxFTxZ4EhsMJp8wWo0B+DzKwE/KbcA+ezrVgh1Te6QkhPE4mG052qVhwUYVsxby
         vjjklBOCmJqEfq5hOgSqiZ6ucwNBAQ5PHyvUw6NWfp7kLhS9Cbrc85y0gFvnIkhWrn4b
         uE91cxdifs5pJbb7pp0SflTnxz2JDPtUvHQKhal79L/CL+/+mE5pCTRAFa+z/rAQitR/
         ZeNQJTWIvgMP3DB3guJsDg0YXPCyktGl4KZOWjMSkabVsln7OgVqN+hf7ttrlzw5GmXA
         DutA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=jDqguviqlm3mcw1WL6mm0X2Ptol7dkWT6XZ2U3iPzp8=;
        fh=CX8+pI+AYj/DnRBFbkQA+6ishA7Mn5KAYzSQfIkWXmg=;
        b=R50eR658/+yGt++awJLiXeCrbzNX3IQZNd+seCOGaW8I6H1MTCWtJFjEINYE1t1wFT
         e6/ZgDc+QWWsDrGj2zpv+/PyzKC0CdtCHnKYWtxtsfNjUNHnX3XSRPWkK0EaqkTkHsrl
         mkyiJiwcZxqItWuAKe591m2SBUrIGgWuAlqN+JXlGf/IqhcWXXpSkAY+NRIWlQT5lX7Z
         BFYTp12RkaZdUs5JHwm6ngDTf0HZWICKW3SK80n5TxoAu/sL9a3vPuNR6OyaodhmpiGj
         dwBl2nRkwAdYo2uFeHBV9wlMZugXeMEGOG50hGzFcuGp+bN7dj140BbRZ8AVkMxQ08fk
         ZroQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1786543285; x=1787148085; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jDqguviqlm3mcw1WL6mm0X2Ptol7dkWT6XZ2U3iPzp8=;
        b=bMzpZF95Zyx59JzfpcJo+ylEYm+3oxDx4U37dg5o3XJSkZyQ21hWHC5FXbiFKJCtwz
         nfL8s0PNyewVe5v64SBtAquLGvNNGElEyDtfv1m7v/EUT0QcQaNwuW9wyRpIIR/y1/I2
         qyuHfiXFEhkuVCzOfGa1P/JJm1Ww3OlOIFQUOqURWgtRFK8kysRFJzxjb7OvMNzhfMpb
         W8+AmyBf7xHon4mrE1Z3nJl7h0UZkwJNtUv59bhlanZJs285lei7wEGlgIgFrIFE7aDd
         1XE8+MzdFW1P0WnvvjHC5W9GJsp1YOEF6XalZDyutJgLrMAtkyEA347rD9gx0K5SzFQC
         UBmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786543285; x=1787148085;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=jDqguviqlm3mcw1WL6mm0X2Ptol7dkWT6XZ2U3iPzp8=;
        b=eTTKDSgM3E64Id1Jj9oDzd+gv7TmO5kO/52OJU/LD/Rj0KgWL4TywWKk0ealPZ9TqD
         kDMVLg6eK0Ebs7lQOT8Rd2yT8o19mJPm2l6LDQkDw7RDdaW8kxrCH1wk8H2+BBmXt11G
         xuaK86rILqIN0ONfb+rDZ6+gHrilF6pI2J08aZnEFPNrfWWtgB/pElc5AbpF98N1O4Rt
         +6kVlG9PVajp97Vgcv2KrV7bIxWY3FtjCnGOXSHNpwHXo+0zrWy3RW7EXNG2OS/hOZ5W
         QX7yh5Pw8lfjXzMhOLhqFlCPu+orfLc/IGRreYEFg1ymly/PYwc9JddAkIWm7RiZyckF
         bnOg==
X-Forwarded-Encrypted: i=1; AHgh+RooIN1Una9rgkXeg+JnD4i36xgWpkWx9uJTzMB3ljiDX4LrBDqe8xi+mSNGyYDb8RVMPskyYTi+nyKEew==@vger.kernel.org
X-Gm-Message-State: AOJu0YxiAoc+kLFd6BVFxPgQ+/iKzj2ZNLD0am2qzpYFQf+5Wbfu5sPB
	mzPb3d54Vn7C8opx7cnbm6SA77GJ8T4Pu5Kr4RgpWsON0fCpvC42DjXCVyXt6eHhzl4m/VgVuea
	ttnxqEZEft2WyORUAVH02Htk8L3vxyn4mIYJ7s2w36A==
X-Gm-Gg: AR+sD11sv5UxYfZCF02YXmp3k8d6XNSjgfmNB0h99fRh26gI55WgmM7KcOFumz9g603
	57nftZwXMuBem1RT7+oG5CNVwnCr3GTGPdOFbKmbV0HCcKyzqLPAXyImRgHKpn63uA+/p3dn3A3
	YjnOxlWB/8FPpYLhOTurxmipXXht8DReuZoIHfAFnxCtOttsgFdT/4YNOtCaXPffmhelk3fQISZ
	RByGGjxBEhqlpXqPcq9TGsvIvstCYg5ZHuEjI2xVTrjRercp3KzkqtVkv6s2+V4f2tECEEx28KJ
	BljszcFa9BMKzR5er2+DF/X33dzMu2cqdRMqiRhIA0JaAF4AZX33UCYpvAa1I2v/UGkiSX8xvRZ
	wYCycnpM9E1vxJiz28OU2habdYrzRJGE/T8ic0BhvHg==
X-Received: by 2002:a05:600c:3545:b0:499:71d6:359a with SMTP id
 5b1f17b1804b1-4997a656f46mr109313045e9.8.1786543284052; Wed, 12 Aug 2026
 07:01:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260513085340.3673127-1-neelx@suse.com> <20260513085340.3673127-4-neelx@suse.com>
 <20260602023330.GB2295@sol>
In-Reply-To: <20260602023330.GB2295@sol>
From: Daniel Vacek <neelx@suse.com>
Date: Wed, 12 Aug 2026 16:01:12 +0200
X-Gm-Features: AUfX_myvt915vzGFwNYRlfFfUivl5kbirxl8PA9N2EQBXfOqTu-HUsUGoJNjjyY
Message-ID: <CAPjX3FdO6sn4Yi0x30cJSASqJXJYnit-RVOOAaz56VhBQPKmXA@mail.gmail.com>
Subject: Re: [PATCH v7 03/43] fscrypt: add a __fscrypt_file_open helper
To: Eric Biggers <ebiggers@kernel.org>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>, "Theodore Y. Ts'o" <tytso@mit.edu>, 
	Jaegeuk Kim <jaegeuk@kernel.org>, Jens Axboe <axboe@kernel.dk>, David Sterba <dsterba@suse.com>, 
	linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 2 Jun 2026 at 04:34, Eric Biggers <ebiggers@kernel.org> wrote:
> On Wed, May 13, 2026 at 10:52:37AM +0200, Daniel Vacek wrote:
> > From: Josef Bacik <josef@toxicpanda.com>
> >
> > We have fscrypt_file_open() which is meant to be called on files being
> > opened so that their key is loaded when we start reading data from them.
> >
> > However for btrfs send we are opening the inode directly without a filp,
> > so we need a different helper to make sure we can load the fscrypt
> > context for the inode before reading its contents.
> >
> > Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> > Signed-off-by: Daniel Vacek <neelx@suse.com>
> > ---
> >
> > No changes in v7.
> > v6 changes:
> >  * Adapted to fscrypt changes since the last two years.
> > v5: https://lore.kernel.org/linux-btrfs/4a372419c3fe6ad425e1b124c342a054e9d6db23.1706116485.git.josef@toxicpanda.com/
> > ---
> >  fs/crypto/hooks.c       | 38 ++++++++++++++++++++++++++++++++------
> >  include/linux/fscrypt.h |  8 ++++++++
> >  2 files changed, 40 insertions(+), 6 deletions(-)
> >
> > diff --git a/fs/crypto/hooks.c b/fs/crypto/hooks.c
> > index a7a8a3f581a0..3142cf106bde 100644
> > --- a/fs/crypto/hooks.c
> > +++ b/fs/crypto/hooks.c
> > @@ -9,6 +9,37 @@
> >
> >  #include "fscrypt_private.h"
> >
> > +/**
> > + * __fscrypt_file_open() - prepare for filesystem-internal access to a
> > + *                      possibly-encrypted regular file
> > + * @dir: the inode for the directory via which the file is being accessed
> > + * @inode: the inode being "opened"
> > + *
> > + * This is like fscrypt_file_open(), but instead of taking the 'struct file'
> > + * being opened it takes the parent directory explicitly.  This is intended for
> > + * use cases such as "send/receive" which involve the filesystem accessing file
> > + * contents without setting up a 'struct file'.
> > + *
> > + * Return: 0 on success, -ENOKEY if the key is missing, or another -errno code
> > + */
> > +int __fscrypt_file_open(struct inode *dir, struct inode *inode)
> > +{
> > +     int err;
> > +
> > +     err = fscrypt_require_key(inode);
> > +     if (err)
> > +             return err;
> > +
> > +     if (!fscrypt_has_permitted_context(dir, inode)) {
> > +             fscrypt_warn(inode,
> > +                          "Inconsistent encryption context (parent directory: %llu)",
> > +                          dir->i_ino);
> > +             return -EPERM;
> > +     }
> > +     return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(__fscrypt_file_open);
> > +
> >  /**
> >   * fscrypt_file_open() - prepare to open a possibly-encrypted regular file
> >   * @inode: the inode being opened
> > @@ -60,12 +91,7 @@ int fscrypt_file_open(struct inode *inode, struct file *filp)
> >       rcu_read_unlock();
> >
> >       dentry_parent = dget_parent(dentry);
> > -     if (!fscrypt_has_permitted_context(d_inode(dentry_parent), inode)) {
> > -             fscrypt_warn(inode,
> > -                          "Inconsistent encryption context (parent directory: %llu)",
> > -                          d_inode(dentry_parent)->i_ino);
> > -             err = -EPERM;
> > -     }
> > +     err = __fscrypt_file_open(d_inode(dentry_parent), inode);
> >       dput(dentry_parent);
> >       return err;
> >  }
>
> This change makes fscrypt_file_open() execute an unnecessary extra
> fscrypt_require_key().  Could we just leave fscrypt_file_open() as-is?

Yes, I'm aware of that. Well, it's static inline and gated only for
encrypted inodes. But yeah, I'll refactor it a bit further.

--nX

> - Eric
