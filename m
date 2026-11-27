Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.173
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795780980;
	b=VS8uSnoXz5X43LURfp4DRem2j5aFO27zKTDoGrBnkTwlNyrH2bwr8kngJwm5PRlfOig5
	 bMIdmrtP87yxxfMD2y09lGEVVdthnNfcnpoyzpVnf6QPgyc2V8MYxFZ/nLOGdQVCf96nW
	 Vv0mRwQ+N5TrXt0+IRfyA5SkCvrA3fnUSud0b9eG2p//f6CA8xEvpUT2wzXewDHwMwOJE
	 Muof5APBGUSvJsUAmL8vDAmPEMoCAZPD11ZdrQCBClPhRV1VdzUfQjRCSm6/hghrMm1i6
	 GVImi4yx2GU2kZ2yNFtOEkie5CMfU3YlasfwE82+0cLuKpbjDV1o2Xp4uQadXnRO43g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795780980;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=sKBAqoHb6dKCB8lGd+jVvxodjbVVN2AMGRa9Yq/Mby4=;
	b=AXe+RqJBVqbTWDmFK5oqR3QvkfXFo7akoOZbQE3/9wSfPqb9A1gct/D6FbyHgR1Af5Gm
	 xuEqvTKaq7UJQClvxhpfy0zQ+KAy0jCebLi4FDy/rK3/lrkOmLFT28YI/OrZ4gSMIbaHZ
	 HU9nl6h231NZwf9AWMh8bYCiYkeqcDaJ3sD4LSbVWLXKA9bmlK1oRT8ZTSUR7868DtKtb
	 Kfa00MtDHB/4NfZAUwBjc4acEcjybLD3UX0AJWRre3kqZ8Irva5EDg1U7csSIZGJCPT83
	 7SG974+gLuSWaiT/O+FDgaHFf5jUn5Cz0uch3nC3znwOGPwHd7klWcKVRW+jHHv38+g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=SnFA07cx;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.173
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C01B8606A31E
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Nov 2026 12:02:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C01B8606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=SnFA07cx
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-3ae85e3685cso56214871fa.2
        for <linux-btrfs@vger.kernel.org>; Fri, 27 Nov 2026 04:02:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795780978; cv=none;
        d=google.com; s=arc-20260327;
        b=kCEUoLemIZGHPeNgA/Qz5stiXKNgYnJalJgYSe029xDnhr1hA7RTvcww0qObkqzrPy
         PasFdJR5A7jaGMM5oPJNOzeg7P8oV8VhDQqlF/K4rY4TzFV+fBMdVtGZwdCFg5gaWXXi
         kD5HOtA/Wa7LNo5RVgZyYJcGRH8wOHfAPcK5vdyWQGPCFaQIBX41+8iX1+3lCXmrFSTc
         0aGyZ8lqDEs2ljrPsbzxCVq6DC/LS82oGZMQUEj2C+O6eEtNeApX7cGvlgfCTWyCiiVF
         IhvPQiIfhnlyfGfB+Bc+Rh2l8/1j+DHna1l3CQQVi1cezBiTSvbeA6+Wml7M4EfO5ukR
         6pIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=sKBAqoHb6dKCB8lGd+jVvxodjbVVN2AMGRa9Yq/Mby4=;
        fh=F75NjEZJ6QFI2EVmy3YyxjmRvaWqw26ODw2buRpc3uk=;
        b=mKxMOiKQAojCXcN9U2sAPc/XvR8AJ7SdSaJBJQRteiskgN0dyqXW1NoYuwZrFoYlrr
         GfYPgNwacdXMI4luDJ1hkN9GWBb3X2AQJcgGGvS1GEYodv+cMh5WjovEjE99JOr+kNd6
         YT9jvfbMvKkgNB+d2cRxSVYfFkXOVYkEnFl44jw4/1O6Cr+wSuZUPJ+jarCydTIwgcPv
         7DC5LlZBFoqDLTMFhVEPfEVtN/u6C1WJ3gY22WFCOeThu+9HC8fvUUlr7N0FWpkFXvZZ
         MRBUI6pD8HAGK6F0c0GExBxUcQpJJtryHSZX9ghwuHnNetoSRsEE7FqHRtvycQ1b235C
         zYZw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795780978; x=1796385778; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=sKBAqoHb6dKCB8lGd+jVvxodjbVVN2AMGRa9Yq/Mby4=;
        b=SnFA07cxVyuwSSQ2WlqVldYscrENhFj8PVisFe6EUr/u+zjaGcOlyf+NO4/VeKXXX7
         4E5nqOC+Z3I662UCySIHIiaMwrjJK+ZjK9X5FK/V848T+A65ClvPxk5bvJvrsV+MWdo/
         JIM89r7vSI7FFB67/tWpYnfwZs9/cVksgSfXEE4llKDhqleU1ZWfSy+N4AE/zsZMEKkf
         FXtLBubySwAUA91pvO8XAdbubi6E7QFc7BDt/+z27xlpQGmIW0sbpzCnfaiUYkOVUtJK
         S6zwuiZQCA+1rzhAC+jCChTTNWgaEmMmc18deOG2Q+9ze1ubEHLrjAXDP7U1S018fipI
         jn7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795780978; x=1796385778;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sKBAqoHb6dKCB8lGd+jVvxodjbVVN2AMGRa9Yq/Mby4=;
        b=kUat46LTG25rj+MQUl6zAJhuafAun0URoa1dRMiCKl4VG4Ai+ZkAMIZvACMsuvMog9
         /2UbMf3WCTFXs3ptRps7uqirjrUcwvrWpesS6Q/OK+JsQ2nLdgb+W9VjvOlDv9LPWaZ4
         w5mKya7EFNyhgP2nXfIZKfaY6tetWP0DH33H8Rcllh5seznshlPNbH4WRcu1VR2FKLNB
         Mt2Cy3v6I1s7CVOlrYaEMgqgHW50uHw98YCCkivJaxqPgW12bg43Fqup89Hm6n1wiFSB
         A69UbtNy1/M4R7zxw8lW86n49Q5zuWYRZfTOHSzCmqYdCx6Uf6aWCxZFXTZ2dkci8nav
         6glQ==
X-Forwarded-Encrypted: i=1; AL+hErFeaO4U7xywFlf6uTGOGNdeZhuT+8uQDca9abJ/mMC1bvzOLKBGKNEO5EZv/FH+862xBNgBFy2MAtQaIA==@vger.kernel.org
X-Gm-Message-State: APuU4Z/c0rwx6P8RXNgKBlzwHtIwXjsrlzWT+EL6kmQk0SSE4jsEQ0+d
	BaXDI0/+er/mLyusd8+pfn3Q2hpp6YD+WAmTBDUWa+Hn7zjletc3x53SXjBZu4Ox0mL3tnlESwT
	n00Y7xFkAf/CLSuDv3PDpfV8YinSgpDk=
X-Gm-Gg: AZFdTZddX0IZO+xxDT+5oRdftbTWJh/BKftTp8VOejeplGqOxubmVQwcr21tuCS9/Vv
	8/ao422OFW4tKEWMVvI/lnDCbm8xQsN4AXQUxct246UAw0Uu4nJYylbjxCZf1Jyak+/O1CbJSFE
	tsVth2c7RKzQQXAabDtnJD+hR9TDRk9mcyCMfaPFxVKOricRUuf7g4JcPY5WEWuswqyfxnbmfD/
	c9sgJ+K5hi6rQ9SiOLrU+7GNaH5Qr0/bLNPTeufRgxnljIDYhm7k+/sED+ZA92N4YhLhFA798gK
	aRIyTMn9nI5Ms5llSqgDvWhs+3gfdBB4Syl1pb5lw0aqKg8b4K8SUyJshgVB0fGMT0Ucz/WdSwj
	QkQUuTUVkkvF9izwOxPbGE3nJIg80n7RUaaPzamS88ehJ5J3HbFjZbIJF6wgBieG/PheUEQ==
X-Received: by 2002:a05:6512:1148:b0:5bc:cc46:1849 with SMTP id
 2adb3069b0e04-5c1bc874b3cmr6981033e87.54.1795780976912; Fri, 27 Nov 2026
 04:02:56 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261126163114.403846-1-koray.fra@gmail.com> <20261126163114.403846-3-koray.fra@gmail.com>
 <CAOQ4uxjGLfuZMFABCwMvdXwnU+P24G_aTJLudWbjeSmWwyDF6Q@mail.gmail.com> <DN5YPR39J7QI.1S1LCFLNUCZNL@gmail.com>
In-Reply-To: <DN5YPR39J7QI.1S1LCFLNUCZNL@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 27 Nov 2026 13:02:44 +0100
X-Gm-Features: Aa3M54ohq34732gC99y698hjwvA-0NF3EsaW7G0zij4KAugMs04c_-FFLASygdQ
Message-ID: <CAOQ4uxgzmB0dEpQCVGKOc8reJ6OFV=BxDMgRW81aKiCMwDSn_Q@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] fscrypt: update fscrypt_prepare_setflags() to use xflags
To: koraynilay <koray.fra@gmail.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>, Hyunchul Lee <hyc.lee@gmail.com>, 
	Eric Biggers <ebiggers@kernel.org>, "Theodore Y . Ts'o" <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>, Jan Kara <jack@suse.cz>, 
	Alexander Aring <alex.aring@gmail.com>, "Darrick J . Wong" <djwong@kernel.org>, 
	Andrey Albershteyn <aalbersh@kernel.org>, =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>, 
	Lauri Gates <lauri.gates@gmail.com>, Christoph Hellwig <hch@infradead.org>, Dave Chinner <dgc@kernel.org>, 
	linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	ntfs@lists.linux.dev, linux-nfs@vger.kernel.org, linux-api@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 27, 2026 at 12:38=E2=80=AFPM koraynilay <koray.fra@gmail.com> w=
rote:
>
> On Fri Nov 27, 2026 at 12:35 PM CET, Amir Goldstein wrote:
> > On Thu, Nov 26, 2026 at 5:31=E2=80=AFPM koraynilay <koray.fra@gmail.com=
> wrote:
> >>
> >> Update fscrypt_prepare_setflags() to use FS_XFLAG_* xflags instead of
> >> legacy FS_*_FL flags.
> >>
> >> Signed-off-by: koraynilay <koray.fra@gmail.com>
> >> ---
> >>  fs/crypto/hooks.c       | 10 +++++-----
> >>  fs/file_attr.c          |  2 +-
> >>  include/linux/fscrypt.h |  6 +++---
> >>  3 files changed, 9 insertions(+), 9 deletions(-)
> >>
> >> diff --git a/fs/crypto/hooks.c b/fs/crypto/hooks.c
> >> index 149498bdab94..52d6a33fc9e9 100644
> >> --- a/fs/crypto/hooks.c
> >> +++ b/fs/crypto/hooks.c
> >> @@ -182,10 +182,10 @@ int __fscrypt_prepare_setattr(struct dentry *den=
try, struct iattr *attr)
> >>  EXPORT_SYMBOL_GPL(__fscrypt_prepare_setattr);
> >>
> >>  /**
> >> - * fscrypt_prepare_setflags() - prepare to change flags with FS_IOC_S=
ETFLAGS
> >> + * fscrypt_prepare_setflags() - prepare to change xflags
> >
> > prepare to change the file attributes with file_setattr() or one of
> > the legacy ioctls
>
> Ah yes.
>
> >>   * @inode: the inode on which flags are being changed
> >> - * @oldflags: the old flags
> >> - * @flags: the new flags
> >> + * @oldxflags: the old xflags
> >> + * @xflags: the new xflags
> >>   *
> >>   * The caller should be holding i_rwsem for write.
> >>   *
> >> @@ -193,7 +193,7 @@ EXPORT_SYMBOL_GPL(__fscrypt_prepare_setattr);
> >>   *        another error occurs.
> >>   */
> >>  int fscrypt_prepare_setflags(struct inode *inode,
> >> -                            unsigned int oldflags, unsigned int flags=
)
> >> +                            unsigned int oldxflags, unsigned int xfla=
gs)
> >
> > This here is a backporting landmine -
> >
> > Changing the semantics drastically without changing the helper name
> > or signature.
> >
> > Please rename the helper something like fscrypt_prepare_fileattr_set()
> > so that backporting mistakes will be caught at build time.
>
> Yes, though, would it maybe be better to just use xflags_to_flags() in
> the vfs patch instead of changing the fscrypt function at all?

Yes, much better. I agree.

Now looking at the /* initialize missing bits from old_ma */
hunk my reaction is to look away its huge and it should be
using helpers probably called from within fileattr_set_prepare()
itself - because if this is de-facto preparing for a set.

Thanks,
Amir.
