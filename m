Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AED7D3603C0
	for <linux-btrfs@vger.kernel.org>; Wed,  1 Jul 2026 15:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782920853; cv=pass; b=AYD6MPSTdYInqslfj7C0/oKBxJj1XAbeRdOCO83O5DoUFTm2av8iNczQEacTuTwbUnvn33qLBxraY5La/n796SMBa52X+pt4YXImQ+ZEnEXGIyvfjre4sqk2FcM1PcmN39u21A7fBjPm5gn1yE56/75yDitrCU0nEi57HTxt44s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782920853; c=relaxed/simple;
	bh=ZayiJGGDGLIh792t6ySSC3WVRP3ob4FSzMOllOM6HdI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=W53nBGzDHVHJ/c3mODl+fjJaZBvFWi3Zr/hOa0REg6Qu+ccYMNm6iRIxjy65UFLRRm+tWUme2PPd7aIA5ojPf+rqIMfVzFAbpz7Uhrl9/bhDWJBmAL3IH8tAGQVWdBJw6gc8WoCs+otjQJQnTxzVPs4HrlL0f7ZZEphMMotAc0s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=dkBMw1p6; arc=pass smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="dkBMw1p6"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-475417f010dso552956f8f.2
        for <linux-btrfs@vger.kernel.org>; Wed, 01 Jul 2026 08:47:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782920850; cv=none;
        d=google.com; s=arc-20260327;
        b=hVDjUp9SlnObMg+F2vNkFdiRC6HaIwMQGUG+ONKYNjP0C/N+4mVu4TtSkQm/nfyVkA
         RIiyckaGw9nTlGiLEaVmQMNKaUmImwn+ocQNu0FI/CHAbq7vk52nuZ7D86t04CRcUZTR
         tG5yZ9xOM3aBQm9kKYuv/xwkzNPlOdN+p6rdyvCU5XKTMZaKJpGl0veTi7E0t2cCu8AT
         OyjBGWAQuoVTvtD5hEGizEY2c/OkyDYZj/xa4Fo2m8iqoP+fZwYCN4CcmEQfly4GIVH3
         bEiG5xw9Sotypa6Aqa7iGvAXNQbF2PlPXdfP+P2QWGglexis/lJXIVF5YBxwQGgax0Lw
         Y0YQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=3u/rPeftjMRMwQ9b5uvwxw83sWJlfLit/lDQul6EARM=;
        fh=GvdLAMSSbuvxeui53H9X+k22xxAKsYwV9nMpb5f88a4=;
        b=PE8jgub0tUzvLeCuqI8YZG2kt9HubTc7oIP4oSOsDuGViYxBEis+tmxfceOX/+yC4b
         cimSA07VO8B3dDITJgaPOweuaJoZQSlAaMDfzKY+g8KLjTAbFtCCTMWkeH9L9lhO7gJU
         IJHLkc3MhQMuddUvykNXQw7EW5+qUCLFqGgv2YSrmWMBI9Lxolv/UZo9lLlhO73GlWYX
         Q1XAE0z09whXFtz0Q/9ozK9jL9nmo1ioiiv/JNgnvLbSNmBI/mW6XCQMx3XIQMBxX26I
         97MmapHbFAsp36LR69VvjgL8F5XpdIB4LmkNTOiGIKK76bMIXL4pToXllFgZsZvWDU03
         l6fw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1782920850; x=1783525650; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3u/rPeftjMRMwQ9b5uvwxw83sWJlfLit/lDQul6EARM=;
        b=dkBMw1p6skgcQ2ZRazuuTc+Aev5k4AOwCNpNvbieuGnlhD1TELmtNULGyBIWomzOQ2
         ipNl7JWgh6C3piifWFipqmjja4cHaTSgy9dmVmR61uIf1yxr4LBSuAcmLJ6tlOnbJ5t+
         W6azQrfReuyutyPiAU3LnLRFoPibCliF3iwXWvePEninlqjgaKtoqLc39eMbjMHNil4K
         mPSCooTZvzWDfSZsLPpopE54U1PbO1mUQLI8RELY9kG0MbJcOs91AeXH6wejXiZ4kWiu
         oXoweJvwiPMKKJlamQqpkcI06aY24cjW/dQIX8bBSEJrpbenzsb/pdQrXfVF8FFUl1iw
         0Iwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782920850; x=1783525650;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3u/rPeftjMRMwQ9b5uvwxw83sWJlfLit/lDQul6EARM=;
        b=fY14sjlH/WBW+14Ubr1K2THDArq6/61JD2W3amw193LDrT2HRLmSsxDBGrC6PmU1hI
         Raqlj9PsbBM4X3qPcVvLf2X4mQzPcnrK/VZhojHVII21NaQsAFChF3qYBQTABUrh7AIZ
         zIrdJCO+znvoYzYIQEWt0eni7gBtv4yXVjeUACJUq0+L+0GhtU+GVR4bccIHElyTy0oe
         kZnv195WmymnKhMxVThgtyKA/ItTdiPadb/PZinz1x1Jzn0YU/lrCiVgw6F2qTadP3dp
         OJR4ziRSNp6mqzg9ylNX4JRUocPExZ8RTrlIwNmdPykg+Z3p98fYyMqTekx5ikevdPiA
         KboA==
X-Forwarded-Encrypted: i=1; AHgh+RrsKKN+9F/Sa6wibnSw04xlz29OIH6v2WbFV/TR7pYmcabv9RvNiypgtEGJE/1oEdMASIJq5g1go18KQQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyJ94fcVvmdFu9lXC9W/wZiZ9hhGG3FdOwhIhCWCIkajkXZZxUs
	LMRWPgg8pzm+5aogC7JVyPzamIN8Ke+vi2m8goqmmAaDZyHc89ew1ODRUlWyibXdfmnOAo4E0Qf
	GUkeQqgzctBaLXGc6IZrO8JjzD3p2di8whC0mSs5OcQ==
X-Gm-Gg: AfdE7clnCZMfl8X9W6RlU/EJ84sq+xfcrWZYH3/Y6JOUElLWDjnfQZx0Js8GrKNC38o
	jAvHPtFvxOQY3NwBJXw/OeNpISGvo8UweUM4KJO1w1OHnszBsfTEDQEXtOc/GWpDQgAsXQRK0Uk
	E4jAK1p4eydkO76JebVZhRcuA0+QDey8wNEF9o7ijd9XEtv4QlcHIJNFYczKA3myxz/md5taq13
	L+QzGZCMjjMJ3jUrjZuT9VI/PwCVMO2+nP9sp3LsXV4TCRfm8+eSveAC4NgpMTz8ks2YRF91TK4
	+RUxSKaFGCyHqKFeZFD8egIoFws5S1I2lxOhgW84CFCQEpBZ0ABZQGk6CFv7qbSR3Cx7Fg==
X-Received: by 2002:a5d:5f82:0:b0:470:258b:b20a with SMTP id
 ffacd0b85a97d-477571cb896mr3856098f8f.10.1782920850225; Wed, 01 Jul 2026
 08:47:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260624165144.556908-1-neelx@suse.com> <20260624165144.556908-2-neelx@suse.com>
 <7d4ab06d-6cd0-4eb6-a355-d2b51d132713@suse.com>
In-Reply-To: <7d4ab06d-6cd0-4eb6-a355-d2b51d132713@suse.com>
From: Daniel Vacek <neelx@suse.com>
Date: Wed, 1 Jul 2026 17:47:18 +0200
X-Gm-Features: AVVi8Cd_RK7AMtLvO_coxJa_GY90chqP4rpiM_IRla7w7nRmF5pUhXw0QeBOrFI
Message-ID: <CAPjX3FdE8REFdGT06k2RehJMfETgrxPzHZ3+V7FPaM_c1UwfcQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/8] btrfs-progs: check: fix max inline extent size
To: Qu Wenruo <wqu@suse.com>
Cc: David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Josef Bacik <josef@toxicpanda.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 26 Jun 2026 at 01:41, Qu Wenruo <wqu@suse.com> wrote:
> =E5=9C=A8 2026/6/25 02:21, Daniel Vacek =E5=86=99=E9=81=93:
> > From: Josef Bacik <josef@toxicpanda.com>
> >
> > Fscrypt will use our entire inline extent range for symlinks, which
> > uncovered a bug in btrfs check where we set the maximum inline extent
> > size to
> >
> > min(sectorsize - 1, BTRFS_MAX_INLINE_DATA_SIZE)
> >
> > which isn't correct, we have always allowed sectorsize sized inline
> > extents, so fix check to use the correct maximum inline extent size.
>
> No, we only allow sector sized inline extent when it is compressed.
> The de-compressed size can be sector sized, but the compressed size
> still can not reach sector size.
>
> So this doesn't seems correct to me.

With encryption it's the other way around. Even shorter data (symlink
path) is always padded to multiple of the cipher block size (16 bytes
with AES). Inlining a full sector size is perfectly valid. The dump
from my test looks like this:

~~~
    item 45 key (290 DIR_ITEM 3363472967) itemoff 11425 itemsize 62
        location key (300 INODE_ITEM 0) type SYMLINK
        transid 14 data_len 0 name_len 32
        name: \243\365@;\312\321\240\367\377\234_{\245\vW\
\035\rS\222ryN\323\031g\243\nt3\321+

    item 58 key (290 DIR_INDEX 11) itemoff 10077 itemsize 62
        location key (300 INODE_ITEM 0) type SYMLINK
        transid 14 data_len 0 name_len 32
        name: \243\365@;\312\321\240\367\377\234_{\245\vW\
\035\rS\222ryN\323\031g\243\nt3\321+

    item 86 key (300 INODE_ITEM 0) itemoff 7197 itemsize 160
        generation 14 transid 14 size 4096 nbytes 4096
        block group 0 mode 120777 links 1 uid 0 gid 0 rdev 0
        sequence 1829 flags 0x1000(ENCRYPT)
        atime 1782916271.8000000 (2026-07-01 16:31:11)
        ctime 1782916271.8000000 (2026-07-01 16:31:11)
        mtime 1782916271.8000000 (2026-07-01 16:31:11)
        otime 1782916271.8000000 (2026-07-01 16:31:11)
    item 87 key (300 INODE_REF 290) itemoff 7155 itemsize 42
        index 11 namelen 32 name:
\243\365@;\312\321\240\367\377\234_{\245\vW\
\035\rS\222ryN\323\031g\243\nt3\321+
    item 88 key (300 FSCRYPT_INODE_CTX 0) itemoff 7115 itemsize 40
        value: 02010403000000005f0642cd89f66ce3ed930fe3ac518b7381bcd7600f7a=
e1f08195bda44461ed5d
    item 89 key (300 EXTENT_DATA 0) itemoff 2998 itemsize 4117
        generation 14 type 0 (inline)
        inline extent data size 4096 ram_bytes 4096 compression 0 (none)
~~~

Perhaps this would better be folded into patch 7?

Or do you rather mean special-casing for compression (with the limits
as you mentioned) and encryption (with full sector size allowed)?

--nX

> > Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> > Signed-off-by: Daniel Vacek <neelx@suse.com>
> > ---
> >   check/main.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/check/main.c b/check/main.c
> > index 5e29e2c5..dedb4db4 100644
> > --- a/check/main.c
> > +++ b/check/main.c
> > @@ -1720,7 +1720,7 @@ static int process_file_extent(struct btrfs_root =
*root,
> >       u64 disk_bytenr =3D 0;
> >       u64 extent_offset =3D 0;
> >       u64 mask =3D gfs_info->sectorsize - 1;
> > -     u32 max_inline_size =3D min_t(u32, mask,
> > +     u32 max_inline_size =3D min_t(u32, gfs_info->sectorsize,
> >                               BTRFS_MAX_INLINE_DATA_SIZE(gfs_info));
> >       u8 compression;
> >       int extent_type;
>
