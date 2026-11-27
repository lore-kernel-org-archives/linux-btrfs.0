Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795805298;
	b=Uw1/dtg3P1Awfsmpr4AN/DED8Z7Rh0MCPAyGUa+33exbsytOgMD/x2E0KJI9ZIgR3C87
	 AEm1dI7RIq7XOTfqmAY+JtO0KxP8HI/4eNXVqNHIvfw+iYCjLHQ4b8o31n9LqZT6AuHEs
	 AaCwtb4O7rCXf8t+3UfrnGqsZ1VnEbFbPYY4b4juF29v0cAVD6IfPK2D/iXQEyTj1OehM
	 qqku6QnLUVr2QSginkXfoaQghE/W8k/8Ai64YtaRuBU/oJYMEg4nuttKGHROIdGY7+fpa
	 h4egChUNe63M+EafDU7t3mjG2FdkW7/1CKRc6RZmZU+rCrrq5GD32GbCFUNY3oezltQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795805298;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Mime-Version:Content-Type:Date:Message-Id:Subject:From:To:Cc:X-Mailer:
	 References:In-Reply-To;
	bh=oy7FTT2Z4DmSg2OYB5b2jigZEgUI9eD6ki27DGKKGCM=;
	b=S1JI94fIdjaT2nG7JjNnTsadfOueEAYNyghBqi6rBqfGHt6sfCmIpR09pvQOq3MYY5Zw
	 GCLw2DeHLWjv349iNyK4EhvKp5fF0AAANzrcy9TtN8NgouGAyslaPY5EmL3qNzKBuXxEp
	 XfB1ITkXQLQzQODXuFVE4rj4xUHJOghe0Zc2TwO9n0J/0R2lrsvR/M9h3Tsqv66VatkQ3
	 /Mu0D+DLMh4Z7A+kH0FpzsUzjyvjQses0MO6Qzoxlw3SC+4ZbYxLnmN7QtEsqDXG1gzOR
	 eXg+0EWWO9Nv1EevyMYgjMCpHYT8vyoKP3hVvqSE6M/yNlixue+piTbZzZ/c2v+tJuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="T/+qZfLV";
	arc=none smtp.remote-ip=209.85.128.54
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 520F2606A330
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Nov 2026 18:48:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 520F2606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=T/+qZfLV
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4a207b02a2cso60548615e9.1
        for <linux-btrfs@vger.kernel.org>; Fri, 27 Nov 2026 10:48:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795805296; x=1796410096; darn=vger.kernel.org;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-type:mime-version:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=oy7FTT2Z4DmSg2OYB5b2jigZEgUI9eD6ki27DGKKGCM=;
        b=T/+qZfLV5CjkJ4gFPi4nyjg/gd6831Z+GldIEfpiK46L4apaQ728C4F8xVanPkaGN8
         +dqukTCri/9Z2lEROHzCcX+7h8eB/3SOxZWG0twbXbwnBvC2UNeY+pM4hOrXwXqrnzeO
         Pdiku14AUoK0mzCwX+t3nvaBIymxGT+KxrmWYCMnlx/pzfzhS7brXI3lYQGHw0yXPBQ2
         SlJOy7A2EU9ynQRDDcscE2E9eRToPqWgkJAfwk/T4sq9tD93oXqHe4lzeq0l/lGp3SYa
         Q/Yti1C3lYMQZwaFxWy+39Kane8NUQFff3eN19MEnhb4PMohvJ3C6grSpwhVB4Dko78v
         sEWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795805296; x=1796410096;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-type:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=oy7FTT2Z4DmSg2OYB5b2jigZEgUI9eD6ki27DGKKGCM=;
        b=UsYtipEL7bgorwCWU05mlGi6LAsDzlD754DwZc2YEfAQBGUhmywLQ1XZ3cWo+SmB2v
         nStt1FH8sS3/p+nlkdqM7iD7yA5vQ0Ol0xJlLqcd9aFacP5VE9P0txPq+bOHJgu8P1zA
         IwkdHmdVnk31bQ2w5XTtpCW82BucVzM3PoMZMtezvdhxcOv7smc5o7uF0vjY498V/8em
         gZ0eJIvjJFZGZ8diV3paKlTztZ1BQYrBEzPfHWUvHCLFSguphp0DRNJfA2f19/QKGlTJ
         woIOSMuJC7y/n4eoWuczq6POF9rv4Pa7pgZzuuBAJdAQxDEEbB8/JaSJ7QlxJKujENDE
         zM8g==
X-Forwarded-Encrypted: i=1; AL+hErFEKlbcNgerzMW3+Tc+ceQ4lnSJMDn9ZxWc16VnIvHbJh11QzRkC54gDyefavErifnpLf6E5fD6JXxVuQ==@vger.kernel.org
X-Gm-Message-State: APuU4Z+MbugAmGt+OGQseXb1sHdY82FzYmSSeCD4ZLT7O1AOGloNhuir
	sPCnJzTpVf4rttiSwG0bDe9rHSq34jQHf2RTbpyXrB/RrNRovGrtDXlJ
X-Gm-Gg: AZFdTZcf6YBElfGEwLR7z7A7ctd3q3cwBcWUzA+PknL7Kl1GlqYFwfV1L1UV5kUfY1x
	q2Gwxcz9S/47bv7loQlJKYFDeI5uTteTT2uNYv8m0v1P+KjinXjheUhO4ZicXQhNfeeOJD5xTd1
	cqyjCT5osZzxaUgkY7xBIpPyllvCfoRJ4PLAi7309LQY++HOJtU465r+KrKcUOTUMkJM1PYAX4E
	+yCSvic+BfVZU9HjJZkfQnaccTA4AB9EXmG8DlLBnnM9MgQMfruMKuI2gTd0zGhoIg/ru/hEKca
	aCFRagxA4cJDjPJBWmxJyuFPBqJzDGhqxiGz+wglik08GGmDPxN+09jHaNNr2l7/Sbsj4o8mTzb
	il1R4TsuTZCW8Zii64qu1f04nov7P897E6CiLK2RMQ+1SVh1zFhY4N+QQLvLNggVbBflVUOV8DK
	lc1HB9qfJIsJLxDPE3v1tp4UT4H8J1WeUMjLJ8ypRPi+Xgvg7N/iNZrLA8m8cClGvXswMbrsK93
	oe0L7Jj+d0LzejG3j+eIsd607mwy5/uepTaKZEjyJTbq8bEFwYcinrrd+sDjiioWvVhKD1vQigG
	Y5RjHPxw5zRYw1RUyDj7K9VZlg==
X-Received: by 2002:a05:600c:4e0d:b0:4bb:69b2:d3b3 with SMTP id 5b1f17b1804b1-4bb8881eea5mr513199335e9.27.1795805295502;
        Fri, 27 Nov 2026 10:48:15 -0800 (PST)
Received: from localhost ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb90655f5asm471463405e9.1.2026.11.27.10.48.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Nov 2026 10:48:14 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Content-Type: multipart/signed;
 boundary=16029ccac70a6b44605f57a804e20e90125af7e99e5e6cc7ae776e1d3bab;
 micalg=pgp-sha512; protocol="application/pgp-signature"
Date: Fri, 27 Nov 2026 19:48:10 +0100
Message-Id: <DN67UHJNHO9H.CKHOY0N86Z9T@gmail.com>
Subject: Re: [PATCH v2 3/4] vfs: add xflags mask to fileattr API
From: "koraynilay" <koray.fra@gmail.com>
To: "Amir Goldstein" <amir73il@gmail.com>, "koraynilay"
 <koray.fra@gmail.com>, "Christian Brauner" <brauner@kernel.org>
Cc: "Namjae Jeon" <linkinjeon@kernel.org>, "Hyunchul Lee"
 <hyc.lee@gmail.com>, "Eric Biggers" <ebiggers@kernel.org>, "Theodore Y .
 Ts'o" <tytso@mit.edu>, "Jaegeuk Kim" <jaegeuk@kernel.org>, "Alexander Viro"
 <viro@zeniv.linux.org.uk>, "Chuck Lever" <cel@kernel.org>, "Jeff Layton"
 <jlayton@kernel.org>, "Jan Kara" <jack@suse.cz>, "Alexander Aring"
 <alex.aring@gmail.com>, "Darrick J . Wong" <djwong@kernel.org>, "Andrey
 Albershteyn" <aalbersh@kernel.org>, =?utf-8?q?Pali_Roh=C3=A1r?=
 <pali@kernel.org>, "Lauri Gates" <lauri.gates@gmail.com>, "Christoph
 Hellwig" <hch@infradead.org>, "Dave Chinner" <dgc@kernel.org>,
 <linux-btrfs@vger.kernel.org>, <linux-xfs@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
 <ntfs@lists.linux.dev>, <linux-nfs@vger.kernel.org>,
 <linux-api@vger.kernel.org>
X-Mailer: aerc 0.22.0-0-gc2f86b7abde3
References: <20261126163114.403846-1-koray.fra@gmail.com>
 <20261126163114.403846-4-koray.fra@gmail.com>
 <CAOQ4uxhA+93bo5WseLxe7cAvJHJ8eQodoQHLwh=iToyEVkeXEA@mail.gmail.com>
 <DN66YKVRVRU7.1062V6NCL4LUW@gmail.com>
 <CAOQ4uxi6oyFj_A9nPbgGeSufGo11L2N=QxLi2DW=ZKy25YQ5Tw@mail.gmail.com>
In-Reply-To: <CAOQ4uxi6oyFj_A9nPbgGeSufGo11L2N=QxLi2DW=ZKy25YQ5Tw@mail.gmail.com>

--16029ccac70a6b44605f57a804e20e90125af7e99e5e6cc7ae776e1d3bab
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

On Fri Nov 27, 2026 at 7:41 PM CET, Amir Goldstein wrote:
> On Fri, Nov 27, 2026 at 7:06=E2=80=AFPM koraynilay <koray.fra@gmail.com> =
wrote:
>>
>> On Fri Nov 27, 2026 at 6:48 PM CET, Amir Goldstein wrote:
>> > On Thu, Nov 26, 2026 at 5:31=E2=80=AFPM koraynilay <koray.fra@gmail.co=
m> wrote:
>> >>
>> >> Add fa_xflags_rw_mask and fa_xflags_ro_mask to struct file_attr, both
>> >> __u64 to match fa_xflags' size, and bump FILE_ATTR_SIZE_LATEST to
>> >> FILE_ATTR_SIZE_VER1, which is now 40 bytes.
>> >>
...
>> >> +
>> >> +       /* Convert between formats and initialize missing bits from o=
ld_ma */
>> >>         if (fa->flags_valid) {
>> >> -               fa->fsx_xflags |=3D old_ma.fsx_xflags & ~FS_XFLAG_COM=
MON;
>> >> -               fa->fsx_extsize =3D old_ma.fsx_extsize;
>> >> -               fa->fsx_nextents =3D old_ma.fsx_nextents;
>> >> -               fa->fsx_projid =3D old_ma.fsx_projid;
>> >> -               fa->fsx_cowextsize =3D old_ma.fsx_cowextsize;
>> >> +               if (!old_ma.has_masks) {
>> >> +                       /* FS_IOC_SETFLAGS */
>> >> +                       fa->fsx_xflags_rw_mask =3D 0;
>> >> +                       fa->fsx_xflags |=3D old_ma.fsx_xflags & ~FS_X=
FLAG_COMMON;
>> >> +                       fa->fsx_extsize =3D old_ma.fsx_extsize;
>> >> +                       fa->fsx_nextents =3D old_ma.fsx_nextents;
>> >> +                       fa->fsx_projid =3D old_ma.fsx_projid;
>> >> +                       fa->fsx_cowextsize =3D old_ma.fsx_cowextsize;
>> >> +               } else {
>> >> +                       err =3D fileattr_set_legacy_to_mask(fa, &old_=
ma);
>> >> +                       if (err)
>> >> +                               goto out;
>> >> +               }
>> >> +       } else if (!fa->has_masks) {
>> >> +               if (!old_ma.has_masks) {
>> >> +                       /* FS_IOC_FSSETXATTR / file_attr VER0 */
>> >> +                       fa->flags |=3D old_ma.flags & ~FS_COMMON_FL;
>> >> +               } else {
>> >> +                       err =3D fileattr_set_legacy_to_mask(fa, &old_=
ma);
>> >> +                       if (err)
>> >> +                               goto out;
>> >> +               }
>> >>         } else {
>> >> -               fa->flags |=3D old_ma.flags & ~FS_COMMON_FL;
>> >> +               /* file_attr VER1 */
>> >> +               if (old_ma.has_masks) {
>> >> +                       /*
>> >> +                        * Don't preserve non-common flags since file=
systems
>> >> +                        * with masks only use xflags
>> >> +                        */
>> >> +               } else {
>> >> +                       /*
>> >> +                        * Filesystem doesn't support _mask API yet, =
switch to
>> >> +                        * old rmw format.
>> >> +                        * PROJID is supported like the legacy masks,=
 but will
>> >> +                        * be stripped during conversion.
>> >> +                        */
>> >> +                       err =3D fileattr_set_mask_to_legacy(fa, &old_=
ma);
>> >> +                       if (err)
>> >> +                               goto out;
>> >> +               }
>> >
>> > I stand behind my earlier comment - this is too much for open coding
>> > here. I won't suggest a better factoring I am sure you will figure out
>> > one by yourself. focus on readability and reviewability please.
>>
>> Hmm, ok, I'll try.
>> Can I keep the comments though? (changing them a little maybe)
>> I think it's important to have them since we're dealing with bitwise
>> operations and a not so easy to understand logic.
>>
>
> I have no problem with the comments.

Ok.
>
>> >> diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
>> >> index a13c7b32a1bd..63d88ebe3420 100644
>> >> --- a/include/uapi/linux/fs.h
>> >> +++ b/include/uapi/linux/fs.h
>> >> @@ -238,10 +238,13 @@ struct file_attr {
>> >>         __u32 fa_nextents;      /* nextents field value (get)   */
>> >>         __u32 fa_projid;        /* project identifier (get/set) */
>> >>         __u32 fa_cowextsize;    /* CoW extsize field value (get/set) =
*/
>> >> +       __u64 fa_xflags_rw_mask;/* supported writeable xflags (get) /=
 flags to set (set) */
>> >> +       __u64 fa_xflags_ro_mask;/* supported read-only xflags (get) *=
/
>> >>  };
>> >>
>> >>  #define FILE_ATTR_SIZE_VER0 24
>> >> -#define FILE_ATTR_SIZE_LATEST FILE_ATTR_SIZE_VER0
>> >> +#define FILE_ATTR_SIZE_VER1 40
>> >> +#define FILE_ATTR_SIZE_LATEST FILE_ATTR_SIZE_VER1
>> >>
>> >
>> > Man... we really need a bot to review all UAPI changes
>> > Please someone tell the bot to check
>> > NO LATEST/LAST/ALL constants in UAPI headers!!!
>> >
>> > Your patch does not introduce this constant in UAPI but if we change
>> > it we risk spreading different versions in installed headers.
>>
>> You mean someone having different versions of the header, each with a
>> different FILE_ATTR_SIZE_LATEST?
>>
>
> Yes, I think this is bad practice.

Ah ok.

>> > Honestly I see no reason for FILE_ATTR_SIZE_VER* to be in UAPI
>> > either. For other UAPIs those constants are not in the UAPI header:
>> >
>> > ~/src/linux$ git grep SIZE_LATEST include/linux/
>> > include/linux/fcntl.h:#define OPEN_HOW_SIZE_LATEST      OPEN_HOW_SIZE_=
VER0
>> > include/linux/seccomp.h:#define SECCOMP_NOTIFY_ADDFD_SIZE_LATEST
>> > SECCOMP_NOTIFY_ADDFD_SIZE_VER0
>> > include/linux/xattr.h:#define XATTR_ARGS_SIZE_LATEST    XATTR_ARGS_SIZ=
E_VER0
>> >
>> > So please move those contacts before adding/changing them
>> > (can be in the same patch IMO).
>>
>> Should I move them to fs/linux/fileattr.h?
>
> Yes please.

Okeh.

>> If so, all of them or only VER1/LATEST? (since they're maybe used by
>> some userspace program already (?))
>
> All of them.
> I doubt that someone is using them and it's easy to
> return them if needed.
>
> Btw, nsfs.h also has this pattern:
>
> $ git grep SIZE_LATEST include/uapi/
> include/uapi/linux/fs.h:#define FILE_ATTR_SIZE_LATEST FILE_ATTR_SIZE_VER0
> include/uapi/linux/nsfs.h:#define NSFS_FILE_HANDLE_SIZE_LATEST
> sizeof(struct nsfs_file_handle) /* sizeof latest published struct */
>
> This is not as bad as defining it to a constant (40) IMO, but
> I also don't really see the point of defining this constant in uapi,
> when programs can just do the sizeof() instead.

Should I make a separate patch for each one just moving them in their
in-kernel headers?
(or a single patch moving both fileattr's and nsfs's? since it's the
same kind of change)

Thanks,
koraynilay

> Thanks,
> Amir.



--16029ccac70a6b44605f57a804e20e90125af7e99e5e6cc7ae776e1d3bab
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSgVimKafU5DQMcjcDmj22qf5IGXAUCawnQagAKCRDmj22qf5IG
XEPFAP0WY/ogYCs7CZPZ7xJp2AjprhL8TAV6fBXYiDTc2Y1zvwD/Z5SLL/+IDNeH
YSoTy/KESs1KeWq/BbG4JL9FnG6wlwE=
=qxyh
-----END PGP SIGNATURE-----

--16029ccac70a6b44605f57a804e20e90125af7e99e5e6cc7ae776e1d3bab--
