Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793704423;
	b=26KGMYolXMrPd6Qx4ZtR9pAzoRjVQrQdsdGb4ODxy7hY7TsyGMMRqkt7Ew3ECEPG+ayD
	 7wEF52M6YCSREcN0U6bEn2qfo9R+RQquX0M0PmLseZ2qfii5RvGX+UT6FwhDGoJs808q/
	 L3IlSp1HHoAKUqmnkts04uezfyMjhm+mdulScYGfhzr2qm5CBVfHJq5SQ9rUw4xbpgWCz
	 tAy78UjRav3RtZUqoBc+uUopz/tovVaCRnO9d1S0NCiJn82YbY98FOmW879N43ruB8bev
	 +MuyyiXyXEp0vHLrBZK5nVeuzZDR4TEA9PecsCQ2mPn6bXyHgMwY0geWB3phNV0nRwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793704423;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:X-Mailer:
	 References:In-Reply-To;
	bh=aApL6RX54q6lZ7c3C3mWoQyOMn5uc2rO6KvHRJ9B9N4=;
	b=WzhVu885ZkV41GmBcDaGCnarrO/ZlrG65qEhr5XeAecdRXAgW26LKE7h34XrIXGf5HXP
	 aTsBmRyQDhHCTYyBC7mcDEcnsypvbPdfvUQ0H31dH28KjN+nBJCVJjaALyBN1qGxvvRTt
	 a5/50bTxuWOXsA5JvmADlVr4PS/V8N89TYileWyqBYx0W3wjTYCG6A60cc0PhtRS3j4p7
	 yHxgw/wHm7dYe116P4XIfY2Qg0r3xFzpyE1iIOdQ1SjVeViyyRbnejplo3Z2IpC5dwNaH
	 e/JIPjQc2CXn78mi+iReLxu1/SW1t3/h80cURTpCWiZLbfCckQq1hNkDXHCosgdJVNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=tpRmkYQw;
	arc=none smtp.remote-ip=209.85.221.49
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6535606A339
	for <linux-btrfs@vger.kernel.org>; Tue,  3 Nov 2026 11:13:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B6535606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=tpRmkYQw
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-48b060ec084so2375880f8f.0
        for <linux-btrfs@vger.kernel.org>; Tue, 03 Nov 2026 03:13:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793704421; x=1794309221; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=aApL6RX54q6lZ7c3C3mWoQyOMn5uc2rO6KvHRJ9B9N4=;
        b=tpRmkYQwFppJ27NUtYosmR6LsYnLr+Wiyh6rMF6lYNSjfpXnh5Q8jwzAgXIY4mEpFO
         PllIYdcu14Ls9Kmp+8OBaskBar+dbdSBWjtrhdkzxVAP+lCC14vkl+/CagIJ3uZFA29P
         qRvlXRbWdHcEcZNpvQncxDYc2R2Z3He37YNGQn4KrNI8JR9Q6xr/53Wvj31TZ1cEGugH
         s3b70ufLGfJHYowjGsb5w/bRKJwTQ7C4AI4YkjUDEPYIhGbphI9sIfhwe4v/kbybfojt
         yE3ClQnwVr5GeYlG3rLRUlNKeykNkNj77XFyn5sOHkJHKcNz89okRIlsMxqXCap6SGix
         KPEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793704421; x=1794309221;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=aApL6RX54q6lZ7c3C3mWoQyOMn5uc2rO6KvHRJ9B9N4=;
        b=CE2usA8D6bbAL4yNTDkMK3lo2j7TNiFA4y7LLj303TZCRp6t+50NCAvPJhY5gbThxn
         0nuiChFOIcNJqG5UWtRNO8IJa7xwuFUABGqVUyFceDR9Y++NmTJjzCb+H/QSy+DJMM9W
         tBENkakAozthgnO+6SPAOse7Id+Lcq8RL8Un2jxs9fvKGaPD7RgQFHDgizzDbU5x6Y0X
         my/S4VZ6OPjXYSI0A9geCCepG15o9L1BoIBn5TG6ZqYqaxWf/+nZaa8+JPaJCGbBjqJl
         O6kBtFZ5FDi46gCjhw+yUc05CTFf4i00fq8J+NNwgvnm88174QQftk4ouODKsM4pyiKr
         pavA==
X-Forwarded-Encrypted: i=1; AKwUvBwV1tIF1D2GV5/uAUtzYg7SXebVUVtjTgXh6Vq3J1n2KZhnMUiJkVuz+2vnwbQRSvJCZzYNU6j8OEHvWg==@vger.kernel.org
X-Gm-Message-State: APuU4Z/PakJM2PIUu0MA3+EGGlLr4gFhEN21XBWeARI3bFD+vnBGluiR
	fG/6sU8Q9WxdTnUKL9X03svoHFL6gNtvbB398UgLNZYqcjoEmdPpLej3
X-Gm-Gg: AYBFou1ybCghWPVuO6+Uml1l7DCP1k3oCOMXime96O0MQ9+GpVpk/N5rVonITAjx7z+
	HHAL+NwUblY/mJWqDaX0A/Yjy7B7K5E9H9XtAzYb01eSm17Yv2VA0U7cValjzAWZ0fNoVgHxG4j
	THC828ahh7B2778S0IYpbiNupsRscd66EY0LaMfd+7CUk2vHUFG27uDWKNdY7k57QDmfSYXKrUu
	Hgpq9r1EYQRqG+cXaXKJqK8qxchVsw0MnTRrPctBKAEWo7BfuD1UnKZjN8q+1BuBaFCwz312yFH
	+rkhiug/wdIVs/JzPMcJ1jh86iZcOnVWnlcqJmTr4Ym0DxFlwjxd1n9kPxzSBD9iAjyvaJSnbFm
	yIuGudofhnm7jtB36v1KkISVQHCHenjMTcaSRGaobOxCWW4N+uwBznYen5gqCpEnC/AQMl9OSH4
	/A8Mt7Mp+eS76RqXj+prLoA+6PWvyMcHcD1juUjG8+V0vUvdMlHA1HI4VWeensBeX/R4Dfy1Til
	fp8zDa0TVRaqmG/8wBhzY2mNCCrXFtzzldi7B9T9AfNPWdpP1AEz0sxgPou7+N8GTVqNiErLUKX
	Xids69NqWj/Vx5JFup3TKvusnlU3+vbHDdQTp91nIsiospeq
X-Received: by 2002:a05:6000:4311:b0:48e:20ed:d5e7 with SMTP id ffacd0b85a97d-48e6e2ff167mr26601099f8f.34.1793704420858;
        Tue, 03 Nov 2026 03:13:40 -0800 (PST)
Received: from localhost ([130.192.98.149])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b8a5a7sm25639265f8f.37.2026.11.03.03.13.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Nov 2026 03:13:40 -0800 (PST)
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
 boundary=e80d9f52f04d877396f5736b7426fc0b9ce68638903c33e71797700113b3;
 micalg=pgp-sha512; protocol="application/pgp-signature"
Date: Tue, 03 Nov 2026 12:13:37 +0100
Message-Id: <DMLJ5DR2A4KZ.28U8XSZ0KFJTG@gmail.com>
Cc: "David Sterba" <dsterba@suse.com>, "Alexander Viro"
 <viro@zeniv.linux.org.uk>, "Christian Brauner" <brauner@kernel.org>,
 "Namjae Jeon" <linkinjeon@kernel.org>, "Sungjong Seo"
 <sj1557.seo@samsung.com>, "Konstantin Komarov"
 <almaz.alexandrovich@paragon-software.com>, "Chris Mason"
 <mason@kernel.org>, "Jan Kara" <jack@suse.cz>, "Yuezhang Mo"
 <yuezhang.mo@sony.com>, "Chuck Lever" <cel@kernel.org>, "Darrick J . Wong"
 <djwong@kernel.org>, "Sean Smith" <defendthedisabled@gmail.com>, "Andrey
 Albershteyn" <aalbersh@kernel.org>, "Pedro Falcato" <pfalcato@suse.de>,
 =?utf-8?q?Pali_Roh=C3=A1r?= <pali@kernel.org>,
 <linux-btrfs@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <exfat@lists.linux.dev>,
 <ntfs3@lists.linux.dev>, <linux-api@vger.kernel.org>
Subject: Re: [RFC PATCH v3 1/5] vfs: add provenance time (ptime)
From: "koraynilay" <koray.fra@gmail.com>
To: "Amir Goldstein" <amir73il@gmail.com>, "koraynilay"
 <koray.fra@gmail.com>
X-Mailer: aerc 0.22.0-0-gc2f86b7abde3
References: <20261101015551.786044-1-koray.fra@gmail.com>
 <20261101015551.786044-2-koray.fra@gmail.com>
 <CAOQ4uxiuJ=eZu28FZAUz3rpqPKqCimPxJucOnYYuBowvD09_Cw@mail.gmail.com>
In-Reply-To: <CAOQ4uxiuJ=eZu28FZAUz3rpqPKqCimPxJucOnYYuBowvD09_Cw@mail.gmail.com>

--e80d9f52f04d877396f5736b7426fc0b9ce68638903c33e71797700113b3
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

On Mon Nov 2, 2026 at 3:00 PM CET, Amir Goldstein wrote:
> On Sun, Nov 1, 2026 at 2:57=E2=80=AFAM koraynilay <koray.fra@gmail.com> w=
rote:
>>
>> Add provenance time (ptime), indicating the time when a file or
>> directory was created. This is user-settable via file_setattr() and
>> retrievable via statx(2) (using STATX_PTIME) or file_getattr().
>>
>> The semantics of when to preserve this new timestamp are the same as
>> mtime, the idea being that there is a correspondence like this:
>>
>> ctime <-> btime
>> mtime <-> ptime
>>
>> so every operation (copying, moving, ...) that currently preserves mtime
>> should also preserve ptime.
>>
>> Furthermore, in order to avoid the legacy FS_IOC_FSSETXATTR accepting
>> FS_XFLAG_PTIME, add an FS_FILE_ATTR_XFLAGS_MASK mask to support new
>> xflags, and use it in fileattr_to_file_attr()/file_attr_to_fileattr() to
>> allow ptime to be used with the file_setattr()/file_getattr() syscalls.
>>
>> [ This is a re-implementation of the initial patch[1] by Sean Smith
>>   <defendthedisabled@gmail.com>, following the advice[2] from Darrick J.
>>   Wong <djwong@kernel.org> of using file_setattr() instead of updating
>>   utimensat() ]
>>
>> [1]: https://lore.kernel.org/20260405195007.1306-2-DefendTheDisabled@gma=
il.com
>> [2]: https://lore.kernel.org/20260407014129.GC6192@frogsfrogsfrogs
>>
>> Assisted-by: Gemini:3.8-flash-high antigravity-cli-1.4.7
>> Signed-off-by: koraynilay <koray.fra@gmail.com>
>> ---
>>  fs/file_attr.c            | 33 +++++++++++++++++++++++++++++++--
>>  fs/stat.c                 |  2 ++
>>  include/linux/fileattr.h  |  5 +++++
>>  include/linux/stat.h      |  1 +
>>  include/uapi/linux/fs.h   |  8 +++++++-
>>  include/uapi/linux/stat.h |  7 ++++++-
>>  6 files changed, 52 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/file_attr.c b/fs/file_attr.c
>> index 833e03810b24..c0645cb22bf3 100644
>> --- a/fs/file_attr.c
>> +++ b/fs/file_attr.c
>> @@ -102,7 +102,7 @@ EXPORT_SYMBOL(vfs_fileattr_get);
>>  static void fileattr_to_file_attr(const struct file_kattr *fa,
>>                                   struct file_attr *fattr)
>>  {
>> -       __u32 mask =3D FS_XFLAGS_MASK;
>> +       __u32 mask =3D FS_FILE_ATTR_XFLAGS_MASK;
>>
>>         memset(fattr, 0, sizeof(struct file_attr));
>>         fattr->fa_xflags =3D fa->fsx_xflags & mask;
>> @@ -110,6 +110,8 @@ static void fileattr_to_file_attr(const struct file_=
kattr *fa,
>>         fattr->fa_nextents =3D fa->fsx_nextents;
>>         fattr->fa_projid =3D fa->fsx_projid;
>>         fattr->fa_cowextsize =3D fa->fsx_cowextsize;
>> +       fattr->fa_ptime_sec =3D fa->fsx_ptime.tv_sec;
>> +       fattr->fa_ptime_nsec =3D fa->fsx_ptime.tv_nsec;
>>  }
>>
>>  /**
>> @@ -141,15 +143,20 @@ EXPORT_SYMBOL(copy_fsxattr_to_user);
>>  static int file_attr_to_fileattr(const struct file_attr *fattr,
>>                                  struct file_kattr *fa)
>>  {
>> -       __u64 mask =3D FS_XFLAGS_MASK;
>> +       __u64 mask =3D FS_FILE_ATTR_XFLAGS_MASK;
>
> That is not the correct way to extend this API.
> This fixed mask was added as a placeholder for
> "We intend to add support for more xflags to selective filesystems":
> https://lore.kernel.org/linux-fsdevel/20250329143312.1350603-2-amir73il@g=
mail.com/
>
> Please see this POC patch for filesystems to publish their supported
> xflags mask:
> https://lore.kernel.org/linux-fsdevel/20250329143312.1350603-3-amir73il@g=
mail.com/

Thanks, I did not think of adding a dynamic mask like that, I will look
into it and implement it for v4.

> This will allow callers of file_getattr() to know if the filesystem
> supports ptime
> without trying to set it and failing.

So after adding fsx_xflags_mask to file_kattr, every filesystem would
populate fsx_xflags_mask with all the returned (=3D=3D supported) FS_XFLAG_=
*
in their own specific .fileattr_get, correct?

Best,
koraynilay

> Thanks,
> Amir.

--e80d9f52f04d877396f5736b7426fc0b9ce68638903c33e71797700113b3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRJ2XvJtXGwULYEerQ0bnTtJTDoOAUCaunB4QAKCRA0bnTtJTDo
OGlqAP9FN1O36Vljpv9qu+GHoMq4dpgT5l0jYNkHeq3xwaeLZQEAp8imIPg1c77f
Nx6+7PN4i6jMGvOBbnpA+XfhiQmdEgs=
=mk5d
-----END PGP SIGNATURE-----

--e80d9f52f04d877396f5736b7426fc0b9ce68638903c33e71797700113b3--
