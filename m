Received: from mail-oa1-f44.google.com (mail-oa1-f44.google.com [209.85.160.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EC27175A7C
	for <linux-btrfs@vger.kernel.org>; Thu, 11 Jun 2026 23:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781219371; cv=pass; b=iM3I8gsxk0FDDKjAiSMJb+PLvJ+10t+93NtFY+9/Cu1A9lCah1V+DEo8I/hOtfFCjIm4/CuEB/pW4vCZCwqav3fSxwtKCxtI8a3p3LhFCl44Byh0Q5iAUZXN/Nw35vMaXnZ1hi35tZtx64by0OGZwtrasrD7xqwvh0CVfiUqvgg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781219371; c=relaxed/simple;
	bh=KGDhkeaNUAI/6zixZyd2LQF+k4+t5jv5l13iqMrIU58=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qYMALm6ATOOQAZA4kslGhfio7L0jTw/zN18fMaNA7Ync8n0647+FjnKuYs6ghULgABljJD+F177ynRjF296oCu23Xl1te/PwNcW/06QmFdltgDENTY/sAYWLsLO6JbLfhUENQNXi+kCLtWAc1ki6+j4hc+EsFsZ1yX9qv0jT0to=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=openai.com; spf=pass smtp.mailfrom=openai.com; dkim=pass (1024-bit key) header.d=openai.com header.i=@openai.com header.b=IxD4kygc; arc=pass smtp.client-ip=209.85.160.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=openai.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=openai.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=openai.com header.i=@openai.com header.b="IxD4kygc"
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-43d2c7b5a6aso379718fac.0
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Jun 2026 16:09:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781219368; cv=none;
        d=google.com; s=arc-20240605;
        b=RIWz4DEvtHYKP89j0lnpFE6ONXRW/Zl5ig8qZ51jWySREs0B2gizzv6GuLoAeLGYe3
         XfOGYg9v5rN0ytdrdTsgF26CWShImPFlq1C6HNT8EwMBBlmbJ7Oz+NiHEtl4IyKykhQ3
         k4rBvlWNfATBIiNWSSEygvc4KZmxrFM329ZjTfBeH/gt878gUJ+BedmASG+4Pjzg58Es
         HhdjhXxPlQrAT59PHbeSE6w0iM2W0fnT4XoPIZrPeWFGbwtFxJTnepvmAhJ4X3tqHeTg
         5F7g0DMDGXZn97iPBZY2k3+2k7/TPPkECy++CPONXB9fYQKcJfsgUW8utQNzTRVm/BBo
         KOtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=CHpLlJLV3Hcod2loCA0BSzXxPhjsB2blr8IPHws7/qU=;
        fh=oIMRFk3AhNFDJfEtfWQIVtO2rjuJtXGHPqME8fo38rg=;
        b=QwJCRxFWLjQVEcamTjpTflH8n3H3PmX6IbiUSNmlBhUvXQtrfdCFqjBKz+1huuGa4f
         Jpdf2SLGjhviCqmA7hvvvR0Yw0HLPz/48+6/DZNx6xDdEBeOzr8BUhADbTAYIFvOHtmk
         Hc/OXoXe2aehzsKK1enWVyc6fg2S0imbgQ6/Ik7uQn3VbAGrupWZbGskY0aOuIaM66jg
         QhckDCTU6AYUEVC2sUZiSTfBj0Wn3EehdS1j9czuHJ9kvAUTkYf2U8X8QO4ZebMqpJV8
         zHTykmEDT64myReKwcOJ/DVH8e6LPFmhZfR2T68EXFxzI8lUJxL8weAbZ90JFKakBmyf
         umGw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openai.com; s=google; t=1781219368; x=1781824168; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CHpLlJLV3Hcod2loCA0BSzXxPhjsB2blr8IPHws7/qU=;
        b=IxD4kygctHlnHtjPfLumAFl9yKtO8cpVVdRbs7yHJXKZaGMZKsdCZX5HaeDZS3txQX
         m1/seG4GFKLcflRaOMWMaqBBH+JOvUUdVyEVuw7K7c5djVKX9UkTuybhoqdx2nQQuzA8
         Zb92xr9R5TOYnz23jUphCgPe2/F4oo02SRR8U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781219368; x=1781824168;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CHpLlJLV3Hcod2loCA0BSzXxPhjsB2blr8IPHws7/qU=;
        b=LeQbHuaGby7MqKCXxDl9GYOOYwZPorM+tIdcd/8kHEfjnlVh4/4NONGTjesVPmFx9Y
         nvn5IS02fUuNvOIFiGvOc7h8wZgSbPyCcHFpzLTO9udsltdXZkC5rjWMZ31IVMlr0IMF
         3z2LszY+9s/pyZkuiI26Ei3j8I4YPmH9IDE3nT7CVqIigIuDno67sezAT0OrOnaS6IN/
         kEEu87Ppv4stSwM6sAZJbpYx42QHoh0jN0mkjRUeU7pvcmPsVo7yumwqP33xw//QVCf6
         tLwoFiAsrgsggv8rE2BKummT6ddvc37fI5qbMaQikU3FX0cGZfsnotDu4yvCkqyIiPVw
         8rBg==
X-Gm-Message-State: AOJu0YyCUwpJ5bYie9JBXAwzJaCFrR+iDVELyRDyQ896IViq/K0ukeMb
	3wcUSmwPR3rMxoHXAz6LvL0owTXd/pgxw99rabwCmuPxlBYSkd5cNZfZWUy/X7AnuiHQPNn4GfL
	/YXX4M/aaYffXQBmTslGieOJi3hMWdWlJJTyleuj44w==
X-Gm-Gg: Acq92OE0zxMxsoO8tYq5iWs9ZG3iUqvh8ZyMDNIbunHCMkgLUI+7j0Uk4+fGzovIGpy
	/mvO+x8V5QqzB7P+klHnt0UgL8zEHGCBR6CzYjXmWvoMgEVcfkLZo3iMLIwnLdo2h1UnRu6bBg7
	9oQwStemoCksOqLJ+QQRi9oDX4Zb2B85+b/dcq4brujt7QSMo3teSXO520D5+KNeiWUQVDgvHDW
	NygS/5A4i4mu1/OyXM5MbTb+b21kUqQT0QEliQuGhENnlIo54IkNdgq7+5omMpWcDar1+/9m6IN
	VCj6cRsXbB2OT/IcsbdQWs4S+Gj8kgGwWfcYT2rBemIIlk/xGdEHlALIpSuCupMyPA==
X-Received: by 2002:a05:6870:55d4:b0:43d:1d30:7ea6 with SMTP id
 586e51a60fabf-4426dc71b2fmr163747fac.2.1781219368091; Thu, 11 Jun 2026
 16:09:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260611212445.4848-1-kylebot@openai.com> <dbb8c9d8-346a-486e-9e23-f200f6bebb5f@suse.com>
In-Reply-To: <dbb8c9d8-346a-486e-9e23-f200f6bebb5f@suse.com>
From: Kyle Zeng <kylebot@openai.com>
Date: Thu, 11 Jun 2026 16:09:17 -0700
X-Gm-Features: AVVi8Cf_uXFgACaWxPxtpFyW_QQzA80KZXXA3uO7qVgUYgL9pMwbcAwqWQtDukg
Message-ID: <CAC7i46_mVFdRE0a2CexemTKF+COueLhh0+tQNrcgGtYEgThVqQ@mail.gmail.com>
Subject: Re: [PATCH] btrfs: validate root ref item size and name length
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>, 
	David Sterba <dsterba@suse.com>, outbounddisclosures@openai.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Wenruo,

I'm actually a human who happens to have "bot" in the handle:
https://kylebot.net/.
I manually verified that my PoC worked against the master branch
before sending the patch.If you think I'm validating against the wrong
branch, just let me know. That was a bit unnecessary.

Best,
Kyle

On Thu, Jun 11, 2026 at 3:56=E2=80=AFPM Qu Wenruo <wqu@suse.com> wrote:
>
>
>
> =E5=9C=A8 2026/6/12 06:54, Kyle Zeng =E5=86=99=E9=81=93:
> > ROOT_REF and ROOT_BACKREF items contain a struct btrfs_root_ref followe=
d
> > by one variable-length name.  The tree checker validates only generic l=
eaf
> > geometry for these item types, so corrupted metadata can expose a root-=
ref
> > item whose item size does not match the embedded name_len field.
> >
> > Several readers later trust the item size or the name_len field when
> > copying the name into fixed-size buffers.  For example,
> > BTRFS_IOC_GET_SUBVOL_INFO subtracts sizeof(struct btrfs_root_ref) from
> > the item size and copies that many bytes into the 256-byte subvolume na=
me
> > field.  A crafted ROOT_BACKREF item can therefore trigger a kernel heap
> > out-of-bounds write.
> >
> > Validate root refs in the tree checker before other Btrfs code consumes
> > them.  Reject items that are too small for the fixed header, names larg=
er
> > than BTRFS_NAME_LEN, and item sizes that do not exactly match
> > sizeof(struct btrfs_root_ref) plus the embedded name length.
> >
> > Fixes: 23d0b79dfaed ("btrfs: Add unprivileged version of ino_lookup ioc=
tl")
> > Fixes: b64ec075bded ("btrfs: Add unprivileged ioctl which returns subvo=
lume information")
> > Cc: stable@vger.kernel.org
> > Assisted-by: Codex:gpt-5.5
> > Signed-off-by: Kyle Zeng <kylebot@openai.com>
>
> Tell you stupid agent to grab the correct branch.
>
> All it's doing is just a worse version of the existing check in for-next
> tree.
>
> > ---
> >   fs/btrfs/tree-checker.c | 38 ++++++++++++++++++++++++++++++++++++++
> >   1 file changed, 38 insertions(+)
> >
> > diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
> > index 1f15d0793a9c..fb072045ca18 100644
> > --- a/fs/btrfs/tree-checker.c
> > +++ b/fs/btrfs/tree-checker.c
> > @@ -1915,6 +1915,40 @@ static int check_inode_extref(struct extent_buff=
er *leaf,
> >       return 0;
> >   }
> >
> > +static int check_root_ref(struct extent_buffer *leaf, int slot)
> > +{
> > +     struct btrfs_root_ref *rref;
> > +     const u32 item_size =3D btrfs_item_size(leaf, slot);
> > +     u32 expect_size;
> > +     u16 name_len;
> > +
> > +     if (unlikely(item_size < sizeof(*rref))) {
> > +             generic_err(leaf, slot,
> > +                         "invalid root ref item size, have %u expect >=
=3D %zu",
> > +                         item_size, sizeof(*rref));
> > +             return -EUCLEAN;
> > +     }
>
> Your stupid agent doesn't reject name_len =3D=3D 0 case, meanwhile the
> for-next one does.
