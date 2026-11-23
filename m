Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.41
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795443281;
	b=ZKFRb1WHf0VmH9ynwYFzjMPNPFqaElqtuB0xsR/OuqCablnL6coboJ/Mlw2PZh622zxB
	 QFCg/34jZa0gJTKS+zgHGXYLUPHuJinL8dHHC1zxpjoieBHXNpLgc31q0crfuGuzWRdX6
	 aaolQj5pYqz/zbZPz/oMmBxj2G/jGoviiY06/T4VTpFCZxD2ouiICaop/1SR9yflkLxGQ
	 wLxSG2E7+5hbgxUcVguAnR9gLM5228sJI6wN0iZHT7eP7/xHl6eF/7XDoKwv+86Y2uCVM
	 R5CMdmne+Ph3BEb63whWaQuFhrZO4odgZ6Wz7vps7mvz7ky1d/5/oUV3dBKuo51OOag==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795443281;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=AOY0PbbuOL71oawD6vspI9ahlDMqf1h6fTODPqf8U0Q=;
	b=QVma6G3zHlqYZ6HpV54SNCFc2SziFpgmf/BpgmaF4zNGa1DqxZpi9c6uaL5W2mvyAKBP
	 XBwfknrUrdPlYuqeC4+05roBKwiYe0TotDYFeV53roZqOwhbKEU5dzAgA+T74a3mVAH2C
	 hyStSmhcryMLgD0IUsIaESxUGtye64Y0txLQWkF2c+X+KqmhHALdrx/tx4T+pqZJaUv71
	 Gg/VJtEjd1N+cbeeEfH+iS5d09fuXG1dNBDUdEgT7JgEao0kZAynmKKCdvp/VqAkSdLoU
	 FU7vdrJUO8Iadg6VxUNPKXWYqySSgTG3zpreWzX2PD4XNb+v9lUv6xPyMhTbTp+Ux+Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=oROifbQ3;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.41
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F374606A31E
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Nov 2026 14:14:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9F374606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=oROifbQ3
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6b894d9a075so3594963a12.2
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Nov 2026 06:14:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795443279; cv=none;
        d=google.com; s=arc-20260327;
        b=AHCHshr3gmk5QT1Sl+KRigG5xkPZBOYJeouCyb7AYV/7iTwR1csQD6Fn6CHM6CicbN
         KLeJLD7GAnQ/UDy24a4Xddy82hJY9RBEDy+1ZP3+pn3BkgSyzlobFU+/sxz+Nj9eCDPJ
         TFVgCebE4MEvWePiXzLX/qE8AneONS5D4+5izz6LBOWwIyJ3LQ4fTvl8pm5RRWx+jTxC
         k5ExnFhrSbaRrHpEOz0H87O8DIggX6Gla1lpEtQdC2bkC9muFWdySVftoYMQHhaBBZaL
         KyNtq3xzRH0FHuXZsEeSp9go2s4q0rwzZUlAq9Tp0+0frqcrja6F8pg1saKCqiXrfDqW
         nh2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=AOY0PbbuOL71oawD6vspI9ahlDMqf1h6fTODPqf8U0Q=;
        fh=c9qy0H6RceIc8aj/LQtsrJYyW0Q9WDH9bvGYRJEM8jg=;
        b=NroTg4emv++c8gNAn/ybNJkzZq0EYBjIYM8CpVA0OweBx635qa9aA13DCkDR6O7c+H
         G1onIfUEClMaafui6AVWGuaWuytlw7erEuRDIVfiehjZvQDw+kYaNDaODYvaT1t99ZEL
         g5RlfDd22UKoMhjx4OcVbnf64eZpoZk+6Sk+J6sQ/Eeb4Cf2o9eKbLiCuKa8CFmUMfPl
         rKxGOXz0GTHBqMGAJaAIsuiMU8/vKrlO0up86r7kehVdkRnAa0faZR3btGYoeNSH5BfL
         MdmePsyqHlLC6/C7auwdPcR8X3ZFLuyhMta/4X8KOM86d5E8oa8glCJFaC4Qkqn5k9Ba
         x+oA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795443279; x=1796048079; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=AOY0PbbuOL71oawD6vspI9ahlDMqf1h6fTODPqf8U0Q=;
        b=oROifbQ3ZfFHP08nzs0+lu8sfpgDDivFrSADeoz3+9bTXvesuEy2rwbBPYElBwR/Zk
         p2DFa+x0RSp8ucrwkMJCDfO7Ki0RSaRlkB2G52iH9aWFVWkweQv70nv1VsEHkEQwbRUd
         2YEdMiXyLmew14pnSjgcXldLLk9a8OCHu7//RaUtbKG6L+X3Xrz7aeYMEWRTgtjNihm2
         dxhXwncufRKlY5aFIrVzglnY/4jLvuZ4pYgkpxMTb/fER4OXELal/eEVCMUwiO8d/LG5
         a4F3Tm35MPWkaNr7NVSraYc6Vex2mPYtjvUd1NlbBfa0Tya24bh6j51cEkgB0W4hNz3u
         afqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795443279; x=1796048079;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AOY0PbbuOL71oawD6vspI9ahlDMqf1h6fTODPqf8U0Q=;
        b=RpBOCMmywRiz+Vmmk5Fo+2Qx5qdaNKNrgHE1ClmzoP2FCk9XOIUFV21/yLu3uER8Hi
         PjoEY1/4I7BWlpE0GjzWkKLtyp/jlL+QKtvdH/HGL7xp1XDihAkJ7frNRDiSW4E2fj0q
         male8Tl7h5VqJh28p3SkPUzT37RAxyBDoYHmwQL60ws4lBpIg96oA0atXxvyEySz9I/j
         W129nXL/CjvHk7nrrjyVQQ+pjOo//sfqMOcrdrS//26DWOX3XoukuBd7hJRx5ha+L6mJ
         TCckyjf01vs8LWqobIGVSdNA//hkPZdrqCFEwKa2X6K1VYzzV0nggFclMrGJyDRC1N29
         dH9A==
X-Forwarded-Encrypted: i=1; AL+hErHaB9TSS0pNWkZ0DqjvkVHPq2nTWTi1wDaCvr1Kdn25OdBiJVH3rDEkbB7BlpVYWj8C/xkwpmuyHfV5lg==@vger.kernel.org
X-Gm-Message-State: APuU4Z83UpCd/kDTT7rngIXv5WfLRZ+dbmNN0FkGyDErK3zj0QhjNMJW
	C2GQtu5y7uOLG6u7vhuDNXKyooQltIaEo8AG3Iml2ZDvTGaGLRiGMG7LsZxLLZnzGErk03Hushg
	DdEA2V4eJjQcOEbPj5PgkC8IMDdeDOo0=
X-Gm-Gg: AZFdTZdA2973D38temsTEfHG53N8r1nrXJRS4au8OIGmqgH6m6hJu/r7f1V9oX+DqKF
	ZsyB27xuMSQB+njtjKSRyGLOlouOVsE3Ks9wl55YLGwDKk0CBTJ1y15JTcerKcO1oM+DG4QXaPV
	xAWgYckTss2OTJm5qyEcDRWRfyX/NohoYzvv++cyJ/yyfZN/sgAlOLk6SH0XU/gMaeseSt6/Qju
	mfsIhBvS21MQv7BxXmnQeUgWygubUtX/Fs15Dt9CNXD8GjHUYMYd5Iv6CSC8VxaLPd8JPtGNalQ
	zLxJZNPsJrmqd4GuUdEwAPdncnLVzXJza/zPvUMgtNCUSzzT7KmsvmpYhLxdALiNPFSMYZawAkQ
	7xDhdBXxaOBNrP6+RCki7Ju9yB1X3W1yMcGWoLnKvIg/mJrtQZN95FUzPOcJdPCWKbKvdng==
X-Received: by 2002:a05:6402:1e90:b0:6b6:8ed8:765a with SMTP id
 4fb4d7f45d1cf-6ba37eb79cdmr8133267a12.38.1795443278525; Mon, 23 Nov 2026
 06:14:38 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261122000856.536902-1-koray.fra@gmail.com> <20261122000856.536902-4-koray.fra@gmail.com>
 <CAOQ4uxgc6pP+_xvJMbqj6wOdGzS75Vn6x6i_vUfCJDD46DAA_Q@mail.gmail.com> <DN2N0BY83OY2.1OV3ZAZFSWCDG@gmail.com>
In-Reply-To: <DN2N0BY83OY2.1OV3ZAZFSWCDG@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 23 Nov 2026 15:14:25 +0100
X-Gm-Features: Aa3M54qAtfdGB0LeRebZKK7K89qIg_MfhE7-Z5I2BzYrqC2uKTrvU0S-v_Coln4
Message-ID: <CAOQ4uxg9O-R_SUPAZ75ESGB99-4Z4EEUKGMkCF2f-sXkGPq1GA@mail.gmail.com>
Subject: Re: [PATCH 3/3] ntfs: switch to the new xflags fileattr API
To: koraynilay <koray.fra@gmail.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>, Hyunchul Lee <hyc.lee@gmail.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>, Jan Kara <jack@suse.cz>, 
	"Darrick J . Wong" <djwong@kernel.org>, Andrey Albershteyn <aalbersh@kernel.org>, =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>, 
	Lauri Gates <lauri.gates@gmail.com>, Christoph Hellwig <hch@infradead.org>, Dave Chinner <dgc@kernel.org>, 
	linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	ntfs@lists.linux.dev, linux-nfs@vger.kernel.org, linux-api@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 23, 2026 at 2:50=E2=80=AFPM koraynilay <koray.fra@gmail.com> wr=
ote:
>
> On Mon Nov 23, 2026 at 2:00 PM CET, Amir Goldstein wrote:
> > On Sun, Nov 22, 2026 at 1:09=E2=80=AFAM koraynilay <koray.fra@gmail.com=
> wrote:
> >>
> >> Switch ntfs_fileattr_[gs]et() from the legacy FS_*_FL flags to the
> >> modern xflags (FS_XFLAG_*) fileattr API with masks.
> >>
> >> Introduce FS_XFLAG_COMPR and FS_XFLAG_ENCRYPT and add them to
> >> FS_XFLAG_COMMON (and add FS_COMPR_FL and FS_ENCRYPT_FL to FS_COMMON_FL=
)
> >> to be used in this API switch.
> >>
> >> Assisted-by: Gemini:3.8-flash-high antigravity-cli-1.5.11
> >> Signed-off-by: koraynilay <koray.fra@gmail.com>
> >> ---
> >>  fs/file_attr.c           |  8 +++++
> >>  fs/ntfs/file.c           | 63 +++++++++++++++++++--------------------=
-
> >>  include/linux/fileattr.h |  6 ++--
> >>  include/uapi/linux/fs.h  |  2 ++
> >>  4 files changed, 44 insertions(+), 35 deletions(-)
> >>
> > ...
> >
> >> diff --git a/fs/ntfs/file.c b/fs/ntfs/file.c
> >> index 50be49f4c913..fde6fb2fe39c 100644
> >> --- a/fs/ntfs/file.c
> >> +++ b/fs/ntfs/file.c
> >> @@ -155,31 +155,37 @@ int ntfs_file_release(struct inode *vi, struct f=
ile *filp)
> >>   * @dentry: dentry to report the flags of
> >>   * @fa: filled in with the flags of @dentry
> >>   */
> >> +#define NTFS_RO_XFLAGS (FS_XFLAG_COMPR | FS_XFLAG_ENCRYPT | FS_XFLAG_=
CASEFOLD)
> >> +#define NTFS_RW_XFLAGS (FS_XFLAG_IMMUTABLE | FS_XFLAG_APPEND | \
> >> +                       FS_XFLAG_NOATIME | FS_XFLAG_NODUMP)
> >
> > Nit: checkpatch may allow 100 chars, but this due formatting is not
> > easy on the eyes
> > pls break to RO line
> It should be 78 and imo it looks fine, but yes, I'll split it in next
> patch.
>
> > and indent the broken lines below (
>
> This should be a diff-only problem, in my working tree the file has them
> correctly indented using 3 tabs (wide 8) and 0 space, probably same
> problem as the PROJID line being unaligned here:

Sorry, pls ignore.

> >>  #define FS_XFLAG_PROJID                0x00100000      /* project ID =
*/
> >> +#define FS_XFLAG_COMPR         0x00200000      /* Compress file */
>
> >
> >> diff --git a/include/linux/fileattr.h b/include/linux/fileattr.h
> >> index 4faa40febf11..219e7c8eb601 100644
> >> --- a/include/linux/fileattr.h
> >> +++ b/include/linux/fileattr.h
> >> @@ -7,12 +7,14 @@
> >>  #define FS_COMMON_FL \
> >>         (FS_SYNC_FL | FS_IMMUTABLE_FL | FS_APPEND_FL | \
> >>          FS_NODUMP_FL | FS_NOATIME_FL | FS_DAX_FL | \
> >> -        FS_PROJINHERIT_FL | FS_VERITY_FL)
> >> +        FS_PROJINHERIT_FL | FS_VERITY_FL | FS_COMPR_FL | \
> >> +        FS_ENCRYPT_FL)
> >>
> >>  #define FS_XFLAG_COMMON \
> >>         (FS_XFLAG_SYNC | FS_XFLAG_IMMUTABLE | FS_XFLAG_APPEND | \
> >>          FS_XFLAG_NODUMP | FS_XFLAG_NOATIME | FS_XFLAG_DAX | \
> >> -        FS_XFLAG_PROJINHERIT | FS_XFLAG_VERITY)
> >> +        FS_XFLAG_PROJINHERIT | FS_XFLAG_VERITY | FS_XFLAG_COMPR | \
> >> +        FS_XFLAG_ENCRYPT)
> >
> >
> > Rule:
> >
> > You cannot add a flag to common without carefully auditing all
> > filesystems that support the legacy flag.
>
> Yeah, sashiko pointed out a problem in f2fs, and I could reproduce it in
> testing, where adding COMPR to COMMON makes f2fs crash, it also needs
> NOCOMP in COMMON.
>

I don't think this is correct, or at least not enough.
My agent said that this breaks or changes things on  f2fs/ext4/ubifs
I didn't bother to check if all of them are true - I doubt it
bottom line - need careful audit and good testing.


> > FS_XFLAG_ENCRYPT can go into common but must also
> > go to FS_XFLAG_RDONLY_MASK because it's read-only for
> > all existing fs.
> >
> > COMPR is rw for some fs and ro for others.
> > As with CASEFOLD, you cannot make it COMMON before
> > converting all casefold fs to new API so that each can say
> > whether it wants RO or RW.
>
> How's CASEFOLD currently handled? in the v2 I'm drafting, I added
> fileattr_mask_to_legacy() and fileattr_legacy_to_mask(), which convert
> between the old format (filtering by FS_XFLAGS_MASK) and the new mask
> format.
>

Good question.
Need to check this.

> > I think there may be a way to deal with this easily since
> > ntfs doesn't need to set either but not sure.
>
> We could export the 2 other helpers I added for v2 (xflags_to_flags and
> flags_to_xflags) and make NTFS use them?
> Though adding the fileattr_ prefix will make the current (v2) vfs code
> maybe too verbose.
>

Honestly, I can't say for sure - you can try
I think you may need a different set of helpers fileattr_prep_ used by the
filesystsems that are converted to xflags_mask, which may be different from
the set of helpers used by the user facing ioctls but I'm not sure.

The thing is - this is all hard to wrap our heads around

You and I have parts of the design in our heads w.r.t backward
compat with legacy API, both UAPI and vfs internal api.

I think you should put it in writing to see that you and I have
not left anything out because this v1 surely does get it wrong
in several places both wrt legacy UAPI breakage and internal
API correctness.

Thanks,
Amir.
