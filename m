Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795441832;
	b=eN10ySNcEPplIDwNTCHLeeMGTrrvkXGpvg6UEp3n6oKa+cvE0lcIUuwtsVbqqh6GlMku
	 AZBtN66Bt5VWoEO8xv3+6OJtitegvPH1qPVvkzJcumc2JBkDOttx00Nh3+xDpYDYByyFG
	 xsNHx84gfTqt3UmOMgJJTNBXh2dPzcoUgzQy8/8EepVprVKTdZ3zfk0Ouja9y5p2uCIcL
	 Ujm4sU/2D3kmByP/D9W42pmaMo/G54q7CaeRylsG+0kbo794E+eaQWHzh+KAPxc5w3HII
	 PaiilMcJ+xKn3UaXBkp1hAPBDz13bfP5H1qXvNioiS7pyCA8aPAAIzqnLAwLVEI0Hog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795441832;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:X-Mailer:
	 References:In-Reply-To;
	bh=nDVijpGqwKWyH50w8XVucnbg4rdJHZCpEUX0lljvpb8=;
	b=tcXCNWfs9E19hw4W2Js+rmENbUpykzRZJiZps+RGbR1BgGlzvzjHSQQeFm1cACQHhvjA
	 skh8+QX2aS6FX/K99R2p9PdQfe1Fz64Vv1RYeuHyHAlGnUiYMPcZJlIvGNm3EYoKKjIk9
	 gJGFIYkxtq7FR5sAp7F3mrfMJ6aPlposcwYth8WPl59M63I+G6ViFCEAVXnhxBLLHKKGR
	 CIKmP2B3t+C1so0CdOy4lCgpArASezRneVp2B46lALecqPkRx99cvX4f68t1rvxgbdiUv
	 ccAD0WfwK8aOkjGVsshqn9DKtj2pq1S6SxpbdZDtNWfKmuHhVuJJWS85108rA5+4lyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=EROWc7oY;
	arc=none smtp.remote-ip=209.85.128.48
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D201A606A31F
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Nov 2026 13:50:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D201A606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=EROWc7oY
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4ba013938d7so30415025e9.2
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Nov 2026 05:50:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795441830; x=1796046630; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=nDVijpGqwKWyH50w8XVucnbg4rdJHZCpEUX0lljvpb8=;
        b=EROWc7oY9HdiuOpsRGUthkHINXiipaSyPMDYzSawxLU5aWqobqcmnFnwToY98OdLXf
         qJfDcB4+A8q++a+EN13WjvAlZeWCaOKo2UsSQJ5+fQ1MlRl/KRNafFwDinnSNxWYPbiw
         VRXPFVDoI4cdf5PnMJEf/NKzywFpZn4lJNqxpoOsYQjBEC6qtplcSoQa7v6tcT2EpGRz
         RHG2vyd9p4eg4I4DRsTf0IhQP79hJaY0pykaI9fujqA9telSKI6p+nDD1LZyoFpMfWjv
         JuzCe0SaA+DkidiGkJTl8r1/CIuJAip5VhrU8jiv+enZEzaWHcx0BJ2R5jDN2AtBxTOH
         fO1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795441830; x=1796046630;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=nDVijpGqwKWyH50w8XVucnbg4rdJHZCpEUX0lljvpb8=;
        b=vQiVyZMYz7VNp9SqvNC3ugUhd5NSmEqlbl3w0QqR/DV9TDv0c0RZFgnA9+Tn2HLffE
         +WP8OUCXR9u3yTsEdZvGzyACK6erXz4Fnc+8HfaAlhTwprm3BIAHq5Y3PyUmQnkgbmPv
         gi6IAPyG5EYphYuwCkwQvqex5hNgsbsYWwHVTu5zqxfntKjxLP4O8NV5nrD2tRmGoU/b
         UORIr5tPJ5DTMW9VLGe7NEWf7/gyF1UB2ThE/Mcroc+Tg+OodoFAnAHcgzrIl3NB96wz
         DdsjMf/RegXVjWIdMlW5AejXnYLTH8ZDSvogAZGjUdVcyjTnQeH7aW98aDmF96v/h+fm
         C1tg==
X-Forwarded-Encrypted: i=1; AL+hErHNR73hYRRsqegmpV6GUpzKBvzoKTgblVTmNpD93+1ysW/2FpA08l/k8kLlM1C/V/KmBfwZaPq8XplxKw==@vger.kernel.org
X-Gm-Message-State: APuU4Z+g7QDJWtDA1FlzX5T8ZhZAxisBYlbERHjxwvnX2fwPIUK4RsI6
	wk5H0NGS8qsZkIBbp7dc01l/g+eUCsi5rXG5+3XxjxS6qjhaCuIldDXn
X-Gm-Gg: AZFdTZeAhZkO6XeWtwKWWT81/e3pgXL/V8ZZtU290r2HwPZlXOFxympWdpjKuqiPTDy
	zKEOxoCMWoXybRGGVie6J+PGziud7wS8HaQKGZAp0P0TgP94zeKxh74alOp8twjgOWdbMQ6tJuo
	BwA0WcixPkT6OzBOq5kQk90xFwB5XRxAtuKyqXQutsAZuiWCnxIK9Zc2aOutpLC3pcYVAJp5kan
	CvVMUiGhUWIQp5RVPHfzlKcs6koRirdGEzd6GvfhDEfM2ZnmPbbxHiw+mWGUSpVxcoy8UrJOAf5
	D7k/l71gdpqaQ1f2Aw4LqccAGO1QhMEahJxuGB4TrXUgWNcllyKfG7XHOjQz9sCquKju3L7QkR1
	/E9NmH9uNeoc9KzbD71flWuPJCA/SoRQbNpb7aC1I+apaOkbQXe5zh9bcMQU4EUDJyM2fPrCqzU
	Mjiuxpwt1UjPg7lO1sO0k5YLR5nMh13QEqSWLMa28pfj10e3qjzFOdYmtffp0GnNwV06ZaagjVv
	2klSEhmTmlCXpFlwdg9dkH3LCTRxojliz3CnJkQwcggxp704R5TZTycraMbIlYObdzPd+QRMLrm
	7hR7/tZsO5zLvdfxzJEhaOq+jryfTBuNu3Z/W0iStQcImr8=
X-Received: by 2002:a05:600c:5493:b0:4a2:8c5:5e5 with SMTP id 5b1f17b1804b1-4bb8881c734mr251533555e9.7.1795441829886;
        Mon, 23 Nov 2026 05:50:29 -0800 (PST)
Received: from localhost ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb853ca452sm348754825e9.15.2026.11.23.05.50.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Nov 2026 05:50:28 -0800 (PST)
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
 boundary=5849192148479b23b3d4c31f6e3ae6158a9ba4dcae3531b8cba6e234b57e;
 micalg=pgp-sha512; protocol="application/pgp-signature"
Date: Mon, 23 Nov 2026 14:50:25 +0100
Message-Id: <DN2N0BY83OY2.1OV3ZAZFSWCDG@gmail.com>
Cc: "Namjae Jeon" <linkinjeon@kernel.org>, "Hyunchul Lee"
 <hyc.lee@gmail.com>, "Alexander Viro" <viro@zeniv.linux.org.uk>, "Christian
 Brauner" <brauner@kernel.org>, "Chuck Lever" <cel@kernel.org>, "Jeff
 Layton" <jlayton@kernel.org>, "Jan Kara" <jack@suse.cz>, "Darrick J . Wong"
 <djwong@kernel.org>, "Andrey Albershteyn" <aalbersh@kernel.org>,
 =?utf-8?q?Pali_Roh=C3=A1r?= <pali@kernel.org>, "Lauri Gates"
 <lauri.gates@gmail.com>, "Christoph Hellwig" <hch@infradead.org>, "Dave
 Chinner" <dgc@kernel.org>, <linux-btrfs@vger.kernel.org>,
 <linux-xfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <linux-fsdevel@vger.kernel.org>, <ntfs@lists.linux.dev>,
 <linux-nfs@vger.kernel.org>, <linux-api@vger.kernel.org>
Subject: Re: [PATCH 3/3] ntfs: switch to the new xflags fileattr API
From: "koraynilay" <koray.fra@gmail.com>
To: "Amir Goldstein" <amir73il@gmail.com>, "koraynilay"
 <koray.fra@gmail.com>
X-Mailer: aerc 0.22.0-0-gc2f86b7abde3
References: <20261122000856.536902-1-koray.fra@gmail.com>
 <20261122000856.536902-4-koray.fra@gmail.com>
 <CAOQ4uxgc6pP+_xvJMbqj6wOdGzS75Vn6x6i_vUfCJDD46DAA_Q@mail.gmail.com>
In-Reply-To: <CAOQ4uxgc6pP+_xvJMbqj6wOdGzS75Vn6x6i_vUfCJDD46DAA_Q@mail.gmail.com>

--5849192148479b23b3d4c31f6e3ae6158a9ba4dcae3531b8cba6e234b57e
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

On Mon Nov 23, 2026 at 2:00 PM CET, Amir Goldstein wrote:
> On Sun, Nov 22, 2026 at 1:09=E2=80=AFAM koraynilay <koray.fra@gmail.com> =
wrote:
>>
>> Switch ntfs_fileattr_[gs]et() from the legacy FS_*_FL flags to the
>> modern xflags (FS_XFLAG_*) fileattr API with masks.
>>
>> Introduce FS_XFLAG_COMPR and FS_XFLAG_ENCRYPT and add them to
>> FS_XFLAG_COMMON (and add FS_COMPR_FL and FS_ENCRYPT_FL to FS_COMMON_FL)
>> to be used in this API switch.
>>
>> Assisted-by: Gemini:3.8-flash-high antigravity-cli-1.5.11
>> Signed-off-by: koraynilay <koray.fra@gmail.com>
>> ---
>>  fs/file_attr.c           |  8 +++++
>>  fs/ntfs/file.c           | 63 +++++++++++++++++++---------------------
>>  include/linux/fileattr.h |  6 ++--
>>  include/uapi/linux/fs.h  |  2 ++
>>  4 files changed, 44 insertions(+), 35 deletions(-)
>>
> ...
>
>> diff --git a/fs/ntfs/file.c b/fs/ntfs/file.c
>> index 50be49f4c913..fde6fb2fe39c 100644
>> --- a/fs/ntfs/file.c
>> +++ b/fs/ntfs/file.c
>> @@ -155,31 +155,37 @@ int ntfs_file_release(struct inode *vi, struct fil=
e *filp)
>>   * @dentry: dentry to report the flags of
>>   * @fa: filled in with the flags of @dentry
>>   */
>> +#define NTFS_RO_XFLAGS (FS_XFLAG_COMPR | FS_XFLAG_ENCRYPT | FS_XFLAG_CA=
SEFOLD)
>> +#define NTFS_RW_XFLAGS (FS_XFLAG_IMMUTABLE | FS_XFLAG_APPEND | \
>> +                       FS_XFLAG_NOATIME | FS_XFLAG_NODUMP)
>
> Nit: checkpatch may allow 100 chars, but this due formatting is not
> easy on the eyes
> pls break to RO line
It should be 78 and imo it looks fine, but yes, I'll split it in next
patch.

> and indent the broken lines below (

This should be a diff-only problem, in my working tree the file has them
correctly indented using 3 tabs (wide 8) and 0 space, probably same
problem as the PROJID line being unaligned here:
>>  #define FS_XFLAG_PROJID                0x00100000      /* project ID */
>> +#define FS_XFLAG_COMPR         0x00200000      /* Compress file */

>
>> diff --git a/include/linux/fileattr.h b/include/linux/fileattr.h
>> index 4faa40febf11..219e7c8eb601 100644
>> --- a/include/linux/fileattr.h
>> +++ b/include/linux/fileattr.h
>> @@ -7,12 +7,14 @@
>>  #define FS_COMMON_FL \
>>         (FS_SYNC_FL | FS_IMMUTABLE_FL | FS_APPEND_FL | \
>>          FS_NODUMP_FL | FS_NOATIME_FL | FS_DAX_FL | \
>> -        FS_PROJINHERIT_FL | FS_VERITY_FL)
>> +        FS_PROJINHERIT_FL | FS_VERITY_FL | FS_COMPR_FL | \
>> +        FS_ENCRYPT_FL)
>>
>>  #define FS_XFLAG_COMMON \
>>         (FS_XFLAG_SYNC | FS_XFLAG_IMMUTABLE | FS_XFLAG_APPEND | \
>>          FS_XFLAG_NODUMP | FS_XFLAG_NOATIME | FS_XFLAG_DAX | \
>> -        FS_XFLAG_PROJINHERIT | FS_XFLAG_VERITY)
>> +        FS_XFLAG_PROJINHERIT | FS_XFLAG_VERITY | FS_XFLAG_COMPR | \
>> +        FS_XFLAG_ENCRYPT)
>
>
> Rule:
>
> You cannot add a flag to common without carefully auditing all
> filesystems that support the legacy flag.

Yeah, sashiko pointed out a problem in f2fs, and I could reproduce it in
testing, where adding COMPR to COMMON makes f2fs crash, it also needs
NOCOMP in COMMON.

> FS_XFLAG_ENCRYPT can go into common but must also
> go to FS_XFLAG_RDONLY_MASK because it's read-only for
> all existing fs.
>
> COMPR is rw for some fs and ro for others.
> As with CASEFOLD, you cannot make it COMMON before
> converting all casefold fs to new API so that each can say
> whether it wants RO or RW.

How's CASEFOLD currently handled? in the v2 I'm drafting, I added
fileattr_mask_to_legacy() and fileattr_legacy_to_mask(), which convert
between the old format (filtering by FS_XFLAGS_MASK) and the new mask
format.

> I think there may be a way to deal with this easily since
> ntfs doesn't need to set either but not sure.

We could export the 2 other helpers I added for v2 (xflags_to_flags and
flags_to_xflags) and make NTFS use them?
Though adding the fileattr_ prefix will make the current (v2) vfs code
maybe too verbose.

>>
>>  /* Read-only inode flags */
>>  #define FS_XFLAG_RDONLY_MASK \
>> diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
>> index e40806b3a69c..09fc7e066485 100644
>> --- a/include/uapi/linux/fs.h
>> +++ b/include/uapi/linux/fs.h
>> @@ -275,6 +275,8 @@ struct file_attr {
>>  #define FS_XFLAG_CASENONPRESERVING 0x00080000  /* case not preserved */
>>
>>  #define FS_XFLAG_PROJID                0x00100000      /* project ID */
>> +#define FS_XFLAG_COMPR         0x00200000      /* Compress file */
>> +#define FS_XFLAG_ENCRYPT       0x00400000      /* Encrypted file */
>
> This is a mistake of patch 1. the newline should remain above HASATTR
> which is allocated from the end.

Right, fixed (and removed the blank line between CASENONPRESERVING and
PROJID).

Thanks,
koraynilay

>
>>  #define FS_XFLAG_HASATTR       0x80000000      /* no DIFLAG for this   =
*/
>>
>>  /* the read-only stuff doesn't really belong here, but any other place =
is
>
> Thanks,
> Amir.
>>



--5849192148479b23b3d4c31f6e3ae6158a9ba4dcae3531b8cba6e234b57e
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSgVimKafU5DQMcjcDmj22qf5IGXAUCawREoQAKCRDmj22qf5IG
XPikAQDShiHwdlBzVhBmmlaSOjx657TCRAUhtq5TpU0jWZ2HUwEAqm4ENGadEir3
5R98mqEdCF353Ii7LkdpHNEHYRGrkQE=
=QROX
-----END PGP SIGNATURE-----

--5849192148479b23b3d4c31f6e3ae6158a9ba4dcae3531b8cba6e234b57e--
