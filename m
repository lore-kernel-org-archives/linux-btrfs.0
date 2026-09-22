Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7787554B1A7
	for <linux-btrfs@vger.kernel.org>; Tue, 22 Sep 2026 14:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.225.140
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790085937; cv=pass; b=bx9Ui83lj7m1bCQg5fMW2Y3jcxxmWDaxmZqw3n8+zSg9o7E+CZIXJQbvh7dNO5ZeEY13jkvNfTPDJZmctmTk6iqKOmYl5uTkdjSwBoSFrM7k7kAM8Y+h7ugXIBsEeh52tUcLHHXZpY/TxABZGF/dIeYmCPIPrgB3wNoaZdNdFyc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790085937; c=relaxed/simple;
	bh=Ay5NjTz63OiCiHZ7ALzt+lcJMCr4C+fqEYLzWAvlTPI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ow+oLdvHHsHuvkYP+H9L0EgBkPiMYEghgSGZ/xBBfTdxislrjtzDWq+uy77Qr4xq5EUMmqTowkZdZFu7JsfIjUP4sgSRq/StrEcKkNnLKKUGLbe3u5AuXBV64DmosfKOVEqXQ42j+HxioG5fV5KKYc63a6sDXlUMyLwmHPgC3dg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=It34vOS8; arc=pass smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="It34vOS8"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49d097b4939so22559495e9.0
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Sep 2026 07:05:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790085934; cv=none;
        d=google.com; s=arc-20260327;
        b=mCGtvcrI51ZNUpIfGOVsbBVHBpAV8ynt4cAO2QTRoiqWyXImz3SaNlCbWKgg8QuZ7s
         oXUJJi2Cmlij2xFVDd5M5oQ1RDfUJKoy6WDUKjtju0jii54vZu43jyrQmHBSLw8tadbl
         59dskOg8eGDruD+oyKyoX/RWpFcmY8ykDeoMwbEuhsG85wwal5L4Aj5G5V+6bRAyCORE
         hqOfJGNdvVXkVjk3k01wJOzosHYHfoYtis/UHY6lSfQotN25z2wug0rSekKU5l1Hy8Om
         z2hT+5eg6bpC/WL37WV2GbVTbtcoYD6DVGs5kDj1v4FG7J4YFHKbzqAa3T6xo2X9ZER6
         gdOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=6YS2AxBcCq9ZhMi42e6qWSeGTCX4XCRef+vl2kw8gyg=;
        fh=Hb4VKIe6VUx9JvXd2Fu2s9Kfj24/HyzoTWGG3cBXtL0=;
        b=srZbY5LXe1JUKxfzn3DK2KtfchqPJTzItHfvyhopEXkv2HBpK3fM6qjt8ODl0pnPYZ
         QgQlWs2bpdbKrUpEwM+ET/0vq2Zz/dMhGVSbKDTxQfbP1d/8xtBa2T4vATxkGqq6zFxA
         qY0v1Fa4JdTsbQVYxq6ALYwokpeH9EF598Y4ryiZ4M68NXJWaqoda5detm3QJx4sQzjk
         OEmI7hLIXx0fSf1yfsFIGX9hN0XQMrvRqVLTpyUyal+OY4G2c70bIVH/AoAo2jabN+Y5
         79QKLB0+qP/0NSAbuZOJn7lXC8lN4cwmUOZYzt2ZjQbq8IJ97MgUrzslEP6/Wf+nGGHo
         qfLA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1790085934; x=1790690734; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6YS2AxBcCq9ZhMi42e6qWSeGTCX4XCRef+vl2kw8gyg=;
        b=It34vOS8sUSb96CZ88ohJ7YHGY3ycuWEwg8dqvOZUvCFuYqztFt5TZ1DCFgwxQHyGh
         CEc/A06jCixtwMIhOu2JmVnw77yYJBi57m4ovFQHMvxZLomGf0+6/9G3uDF+fmk4CAmL
         3jGIYPDTXXXu+RmKo/edM+Bd/OAxjjgvH5VWPQQf/++/hpBu3W+KgP5DS7gNlPnsDgvJ
         CjAmNYrYTnlE0qDpqbpzji6TzpPacEbI0ugFuwDuPfPRpCuscoQnr4Nb+BODmAzapyPd
         Fwqv7QBanNNIiCmjxvSssudzUGg7vC7fTuVQBcocAQtdODsoDxxrHS/mSCmzzGZS1DZY
         z9+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790085934; x=1790690734;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=6YS2AxBcCq9ZhMi42e6qWSeGTCX4XCRef+vl2kw8gyg=;
        b=U4nQvhzTOj1QXtnBRNP+fnk3PPvi4guXMuE+aiDUTHJYFkMt5Ljqdl3w50iWJCQdPv
         GIFZoKPsIC7gu7ZS5YHB53mwdKXLR9Wh+AZmMkwS/H5Nu+vembTqp8uojOnQCKf0yTsy
         F7NpdlfW54xSwy9VyBfb2vPiRnyRIHPHfFmRLsT8I9CylOzYWDxyqRV4DP4y6gT0zRzl
         nUypQ6Zh8cZTEzPIBFmx4jJL/eqVFVVt+yYnmxAP1hmTKJ30IoP1FjfIfMoYDTnMNIDv
         4w5rY+qKAUDo/naqvB+EOkFssh3+PnTWHiDuyqXM7hVy/jxOVryEVD7btPyFYexSGzXc
         qjhA==
X-Forwarded-Encrypted: i=1; AKwUvBwFeJDy0/g8cNUb9MpZW9F7BIYeAuVJd5Ggc4CCi7Qq14FvUJM0G6CDLR4wsEKmAwON1GRQmmRIlw0fjw==@vger.kernel.org
X-Gm-Message-State: AFuF++mvAbW41FR16+hdkexObEePryIXXhDlmOtwpx8oaT1E1V89kY5l
	A6H14JVEbpvfdqb3GfVgK9G24M5jr2oSi7FtPJUNQ1NfBwG7XIO619nSrX2WwFR/0wFuW6v9k0D
	DTOOqfhnsbe/vrrv2byZv2nNXzCE5fvX3xR78qRGpig==
X-Gm-Gg: AYBFou12uKQjoXm2mrDtD3QgRKAoo8M/HosDGRoZ+JrJffTXEd5gEMHIwNFOpoFFhPk
	8lfTmsen9i40IjbCSdIR1zDYDRphj/B2wz1L4kjehExgazwyLvlkCu1w9qI04iWQQXf16AZtCKI
	C7z9C6VvHJsFrSTPEaGR5srW/lV8mR4ZxtgSfD3lZwzvhJd3/Buk9INwx4hi7Klj/Fo+aqpexJl
	BYbYNm+IvedprtVZDM6nPmuxv/zQ/atzNJVuiSB758Ns+3bgzQEDFD2y0oBvWRPIg2TWDjcohOB
	Kl6ebeRn53Yynljjpc2XmuNj8zQvBCwtqTIbhQgZGIdguH+feDGm3RAZ+grTf6rdjCpsqjCI7wI
	dJmw2q4CnzTjtdcwNzdu/v85O0+pGwNekDHO5C/YJWcbRTyxqtRbz
X-Received: by 2002:a05:600c:83cd:b0:49c:c0d4:53d9 with SMTP id
 5b1f17b1804b1-49fc56f7a11mr167442875e9.14.1790085933488; Tue, 22 Sep 2026
 07:05:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260513085340.3673127-1-neelx@suse.com> <20260513085340.3673127-13-neelx@suse.com>
 <20260602032710.GI2295@sol>
In-Reply-To: <20260602032710.GI2295@sol>
From: Daniel Vacek <neelx@suse.com>
Date: Tue, 22 Sep 2026 16:05:22 +0200
X-Gm-Features: AclHuK9W2Pxjl3KwkDzeI2ubrLmu06MdbRUN3yT63V6ZnZJwdsBl8QwyQ-GSdxM
Message-ID: <CAPjX3Ffd8uiaOaOkwyATq_NtCf-Jx5+Q3Q+y-PH+3XhC+GBvgQ@mail.gmail.com>
Subject: Re: [PATCH v7 12/43] btrfs: add new FEATURE_INCOMPAT_ENCRYPT flag
To: Eric Biggers <ebiggers@kernel.org>
Cc: Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>, 
	"Theodore Y. Ts'o" <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
	David Sterba <dsterba@suse.com>, linux-block@vger.kernel.org, 
	linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Omar Sandoval <osandov@osandov.com>, 
	Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Content-Type: text/plain; charset="UTF-8"

On Tue, 2 Jun 2026 at 05:28, Eric Biggers <ebiggers@kernel.org> wrote:
> On Wed, May 13, 2026 at 10:52:46AM +0200, Daniel Vacek wrote:
> > From: Omar Sandoval <osandov@osandov.com>
> >
> > As encrypted files will be incompatible with older filesystem versions,
> > new filesystems should be created with an incompat flag for fscrypt,
> > which will gate access to the encryption ioctls.
> >
> > Signed-off-by: Omar Sandoval <osandov@osandov.com>
> > Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> > Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> > Signed-off-by: Daniel Vacek <neelx@suse.com>
> > ---
> >
> > v5: https://lore.kernel.org/linux-btrfs/ccbea52046c1dadbbef926bfc878cc23af952729.1706116485.git.josef@toxicpanda.com/
> >  * No changes since.
> > ---
> >  fs/btrfs/fs.h              | 3 ++-
> >  fs/btrfs/super.c           | 5 +++++
> >  fs/btrfs/sysfs.c           | 6 ++++++
> >  include/uapi/linux/btrfs.h | 1 +
> >  4 files changed, 14 insertions(+), 1 deletion(-)
> >
> > diff --git a/fs/btrfs/fs.h b/fs/btrfs/fs.h
> > index a4758d94b32e..dbdb73722c14 100644
> > --- a/fs/btrfs/fs.h
> > +++ b/fs/btrfs/fs.h
> > @@ -322,7 +322,8 @@ enum {
> >       (BTRFS_FEATURE_INCOMPAT_SUPP_STABLE |   \
> >        BTRFS_FEATURE_INCOMPAT_RAID_STRIPE_TREE | \
> >        BTRFS_FEATURE_INCOMPAT_EXTENT_TREE_V2 | \
> > -      BTRFS_FEATURE_INCOMPAT_REMAP_TREE)
> > +      BTRFS_FEATURE_INCOMPAT_REMAP_TREE |    \
> > +      BTRFS_FEATURE_INCOMPAT_ENCRYPT)
> >
> >  #else
> >
> > diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> > index efaa0788c1fc..84df97363611 100644
> > --- a/fs/btrfs/super.c
> > +++ b/fs/btrfs/super.c
> > @@ -2563,6 +2563,11 @@ static int __init btrfs_print_mod_info(void)
> >                       ", fsverity=yes"
> >  #else
> >                       ", fsverity=no"
> > +#endif
> > +#ifdef CONFIG_FS_ENCRYPTION
> > +                     ", fscrypt=yes"
> > +#else
> > +                     ", fscrypt=no"
> >  #endif
> >                       ;
> >
> > diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
> > index 0d14570c8bc2..3fe57843f902 100644
> > --- a/fs/btrfs/sysfs.c
> > +++ b/fs/btrfs/sysfs.c
> > @@ -305,6 +305,9 @@ BTRFS_FEAT_ATTR_INCOMPAT(remap_tree, REMAP_TREE);
> >  #ifdef CONFIG_FS_VERITY
> >  BTRFS_FEAT_ATTR_COMPAT_RO(verity, VERITY);
> >  #endif
> > +#ifdef CONFIG_FS_ENCRYPTION
> > +BTRFS_FEAT_ATTR_INCOMPAT(encryption, ENCRYPT);
> > +#endif /* CONFIG_FS_ENCRYPTION */
> >
> >  /*
> >   * Features which depend on feature bits and may differ between each fs.
> > @@ -338,6 +341,9 @@ static struct attribute *btrfs_supported_feature_attrs[] = {
> >  #ifdef CONFIG_FS_VERITY
> >       BTRFS_FEAT_ATTR_PTR(verity),
> >  #endif
> > +#ifdef CONFIG_FS_ENCRYPTION
> > +     BTRFS_FEAT_ATTR_PTR(encryption),
> > +#endif /* CONFIG_FS_ENCRYPTION */
> >       NULL
> >  };
> >
> > diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
> > index 9165154a274d..2f6a46e5f4ce 100644
> > --- a/include/uapi/linux/btrfs.h
> > +++ b/include/uapi/linux/btrfs.h
> > @@ -335,6 +335,7 @@ struct btrfs_ioctl_fs_info_args {
> >  #define BTRFS_FEATURE_INCOMPAT_ZONED         (1ULL << 12)
> >  #define BTRFS_FEATURE_INCOMPAT_EXTENT_TREE_V2        (1ULL << 13)
> >  #define BTRFS_FEATURE_INCOMPAT_RAID_STRIPE_TREE      (1ULL << 14)
> > +#define BTRFS_FEATURE_INCOMPAT_ENCRYPT               (1ULL << 15)
> >  #define BTRFS_FEATURE_INCOMPAT_SIMPLE_QUOTA  (1ULL << 16)
> >  #define BTRFS_FEATURE_INCOMPAT_REMAP_TREE    (1ULL << 17)
>
> There seems to be an inconsistency where btrfs's fscrypt support depends
> on CONFIG_BTRFS_EXPERIMENTAL, but the support is advertised in sysfs
> regardless.

That is true. These should also depend on BTRFS_EXPERIMENTAL. Will
amend. Thank you.

--nX

> - Eric
