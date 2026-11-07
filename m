Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.49
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794070131;
	b=3REf+U0EIhONz9xJ0vyrvUXzJzVpXvh4aDqHk2Xtl+7sUF7VCJl2D53xKx1vkZyjbEOb
	 clJFVHE47M/VvTbaYhpJmKqqw8rcvWfmJ8zd9HwSgL/sXwGo23utOd1zpZvnSs0rOequ7
	 QcgM5cAy6kVOK4CfaUn9cu3QvFft1ySBaqXbVxnKaO+NCDjabu0PfoC5oK2QTrBaUzjJf
	 zgasYN2Rdyn/+YQzTt+Hl9KsSSWg9rBUw+rlJHMgsvwZRrPD5qD+4dm6PnesuD/qVgqLN
	 KykSYuF3FV7noIhWi1PRp2njLMtKSL0OL+qYBIV0302IO8TaJl+E5ufn+pJ0HERQCfw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794070131;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=LZ1hEM+d+iNpX1Pv6g3S4J8ubodEppWnVLdYamIPsBI=;
	b=E6oa5THCnMBH0Q+U+WYtGwt9MmNA+ktR7wkH5cuyOOW05OGIztnukI+OkOs2b7HYb6BE
	 YGp12JrVgsP7g3ZxLarDWsX3IKRRRvVqQCEaFloELyGibKw6XpoC1chq08mBi2hHQdYEl
	 PHGfMugdwT9tbjNnqSC041O52OPJJLDh9wpfEeVSn6ejcUAy/SvRmwKZDiC87kVQ4Dpw6
	 FCXq4AUl9POWimfRSP1JJyLjVqWYMTv1ADy55Qbayb83BfLX9TX4E6Q4WXWSVPoW4IAXG
	 PfAwkMA2P3XcDWXAv+N4zi75Ecb+T7QkHBpBvl/A0eXsoaFsaMbSAM61U7vJMT3op6A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=FbJQ3Zqr;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.49
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1875E606A330
	for <linux-btrfs@vger.kernel.org>; Sat,  7 Nov 2026 16:48:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1875E606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=FbJQ3Zqr
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-6b596569640so915522a12.1
        for <linux-btrfs@vger.kernel.org>; Sat, 07 Nov 2026 08:48:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794070129; cv=none;
        d=google.com; s=arc-20260327;
        b=gYty4SaG9w9CkuFUO86bJuo7qXNVcv4XCFBofLWGtmrxfW51qwh45PwwNTfGPZI05+
         gSky2MJ7qcOIvCIzrgXw8WjSbp3IO7/jHKIvD5UhfilXoBfOa9B1PbL/aaQnaQa0fKQG
         c8bVoZj2FygWdhn/QI25RMEvZ4l8x1quARw7vbwam8LjGqK66nkXkIFi/HYpPmjRaeMe
         9tp/Kmad2gtagGgwK9ANb+c6hKqNC2cAyBPPP581BusLfFSlieDgAPzsKqPnqyv/nu1N
         2DYfkXdWO6myrz75fQBV8nP/0wefQ15Dm3wkoicK9AwoGb7YeYrOVhhygQmSd1fG/Gcj
         2tEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=LZ1hEM+d+iNpX1Pv6g3S4J8ubodEppWnVLdYamIPsBI=;
        fh=fzHS+uEWnSBQk9PVRgCWs8CVJYPKtXiUulAE+pDGJkU=;
        b=Kl4kyLuZNri4yh/gBzWslskh7BigT4Kb5X6BwjDIN2GC3S5pIEVvgEhv3Wx1rgS59P
         ABmMaAMvEyxPT0Wf0bRoAuTIiPDDUAaqKxmfziXdXQBYaFHTXBRCNb8ttV7tXUzs+lxU
         mGmd6K0WftsGV7TQ5+Vcw4WyCVKzP2vqpve+ma8Tzo54NfD0TAASuM1ytl1mUO5LQMnR
         WZxxHTERUKLrEsbNZPa8n0u3hIFyQxPrym5qQ1uMpzw8Y96gIaB+ihittsZoyNt/DcmE
         cAqigRIqpzNW5rMPmZtZW9PVBw58dQ8DVHBuzVZ3MNFFMv96ZX+pPyrIQnSSfz9BzkrL
         NeIg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794070129; x=1794674929; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=LZ1hEM+d+iNpX1Pv6g3S4J8ubodEppWnVLdYamIPsBI=;
        b=FbJQ3Zqrdpn7NIhiDmg+EUuO6n3ozLBXaaXnvJNjmuY5AlqvMAyJo597rNOoVGHd+P
         Wy0+BFjRiKW+LdqY/E8CeYV42t7cwAmJ5AugbcA9IrMB2CM/bZ4DBvia0Xv7MsG4AgZi
         C30lhUT4bvKQ2SikSiGakC0P7/tq5w5ZAiw7cjWTlhOJPAGHcWeKY11DNjLSqhaj3LCJ
         EfYP2qa9hYSvPmYbNMnzYlsCnW2tfO8v2zrKk1TZnVnWfaWVJoi9yePqPucWkME33sCP
         PU+42FoiSdOSik4gy1NrZDeNWmmJHSVsadZh/wdcs6shRWcOD02h1nfTlAf92y48Nmox
         Q9NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794070129; x=1794674929;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LZ1hEM+d+iNpX1Pv6g3S4J8ubodEppWnVLdYamIPsBI=;
        b=TFdsQpXuo2YhTFXXBOJZlAI1lwo0f3zUrxVZSCMlqupRGhHu5YEXuNnnwWDOswOLzo
         0V1Ori6Iwow0A2P1xJ0IaU3EZzXAyu0x+rEAKQLKbf1YX9Zql8qmhDE+BxnCzIIArNql
         +d6edRNlrIPWiTg6MbMNqAce8Y8oT4boFopxzvevhuhHCF/p9/XQKNyrfXJNqcskXT46
         VG0wWVLg2IECNgSdaF3oCO2yiL1jh+EawK9lk6jquz72HkP9ZzQ0EzbFfcpSfksib71D
         I6Tw6e7NRUxlZKxWGXBRz8nsbD9kuocaO8y2+u6mMUmT8/yF2NK+BQ8G80ockuYiBnsq
         xBIQ==
X-Forwarded-Encrypted: i=1; AL+hErGlebghW9WBxQ9jrk8cZbd1hiByP9h99ZuWzmmlKXU6FIDNxVKKXOh8u9btAzOLJALCDTZ6hCbyE/gYcw==@vger.kernel.org
X-Gm-Message-State: APuU4Z+WLhO0owVYjQF2spyXtzfM9+opfDC648q5LJxQisV5g8crdjgS
	ZEdDNWLYMpRYpk0/Fg3cqQtlVE2lzkGUGG8Dx6ypIi1Q24Wo5eT1I5vVKVziEgkW9AXF3Cou5+j
	KPnZl0WMF41jNFbEGqVXdLfKYJeshhpE=
X-Gm-Gg: AYBFou3d/rBEsQRdjlDti2x55E8Q49TlQZ2gDMpq+VUaYITgkOKKIKPDZ8pMA7iKHQx
	XRd0qymJ9O4fT7e7tSPjKkTGSoWwOrTYyCz3xfKs+D0nDtwTdhJlQ9CdNM7/M4D6Zb1buVOhEU/
	GbfeazXqxNQTkGphl0CjY1heD5/bNtJh9IKD+VwNeuylO7vqVw/Gs5FxhlT1prJqdt8afoEKNKp
	q1oBU4AgaZQIbt7PJmkTQ1ZXoLmg8/kCtBhMXawYGWqkz7lVo0XHNV0efINAupPsdRYLVtoEZnI
	Lv1586vxgVr9s7cOHMnf9WU9cVZZCKvDG4rD9CAO2y19NLJiWnqCWKKzResLKwMzDO1Hevz/+3B
	psIkcILa+RpJbCLJ5cVVu8jU3lN2WYJ6V9peAgUqMTD92UGNeilEypKvYQtJFaWOgchCQAQ==
X-Received: by 2002:a05:6402:1ec8:b0:6b4:dcab:bf9f with SMTP id
 4fb4d7f45d1cf-6b6fae71be9mr1620380a12.16.1794070129335; Sat, 07 Nov 2026
 08:48:49 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261101015551.786044-1-koray.fra@gmail.com> <20261101015551.786044-2-koray.fra@gmail.com>
 <CAOQ4uxiuJ=eZu28FZAUz3rpqPKqCimPxJucOnYYuBowvD09_Cw@mail.gmail.com> <DMP3UBB0QVOT.20HIXK7ZL6K6U@gmail.com>
In-Reply-To: <DMP3UBB0QVOT.20HIXK7ZL6K6U@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sat, 7 Nov 2026 17:48:38 +0100
X-Gm-Features: AclHuK89rvp6wjLvX07JFLvpP57bRUqY-Yxm_O2zzvQ-fpYQDX7x1__0QP5KjTE
Message-ID: <CAOQ4uxgSVc8n1LbL_dcU-DpNN5BB-ap_vGdXEu7+d0Td7PK5Tw@mail.gmail.com>
Subject: Re: [RFC PATCH v3 1/5] vfs: add provenance time (ptime)
To: koraynilay <koray.fra@gmail.com>
Cc: David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Namjae Jeon <linkinjeon@kernel.org>, 
	Sungjong Seo <sj1557.seo@samsung.com>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Chris Mason <mason@kernel.org>, 
	Jan Kara <jack@suse.cz>, Yuezhang Mo <yuezhang.mo@sony.com>, Chuck Lever <cel@kernel.org>, 
	"Darrick J . Wong" <djwong@kernel.org>, Sean Smith <defendthedisabled@gmail.com>, 
	Andrey Albershteyn <aalbersh@kernel.org>, Pedro Falcato <pfalcato@suse.de>, =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>, 
	linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, exfat@lists.linux.dev, ntfs3@lists.linux.dev, 
	linux-api@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 7, 2026 at 5:04=E2=80=AFPM koraynilay <koray.fra@gmail.com> wro=
te:
>
> On Mon Nov 2, 2026 at 3:00 PM CET, Amir Goldstein wrote:
> > On Sun, Nov 1, 2026 at 2:57=E2=80=AFAM koraynilay <koray.fra@gmail.com>=
 wrote:
> >>
> >> Add provenance time (ptime), indicating the time when a file or
> >> directory was created. This is user-settable via file_setattr() and
> >> retrievable via statx(2) (using STATX_PTIME) or file_getattr().
> >>
> >> The semantics of when to preserve this new timestamp are the same as
> >> mtime, the idea being that there is a correspondence like this:
> >>
> >> ctime <-> btime
> >> mtime <-> ptime
> >>
> >> so every operation (copying, moving, ...) that currently preserves mti=
me
> >> should also preserve ptime.
> >>
> >> Furthermore, in order to avoid the legacy FS_IOC_FSSETXATTR accepting
> >> FS_XFLAG_PTIME, add an FS_FILE_ATTR_XFLAGS_MASK mask to support new
> >> xflags, and use it in fileattr_to_file_attr()/file_attr_to_fileattr() =
to
> >> allow ptime to be used with the file_setattr()/file_getattr() syscalls=
.
> >>
> >> [ This is a re-implementation of the initial patch[1] by Sean Smith
> >>   <defendthedisabled@gmail.com>, following the advice[2] from Darrick =
J.
> >>   Wong <djwong@kernel.org> of using file_setattr() instead of updating
> >>   utimensat() ]
> >>
> >> [1]: https://lore.kernel.org/20260405195007.1306-2-DefendTheDisabled@g=
mail.com
> >> [2]: https://lore.kernel.org/20260407014129.GC6192@frogsfrogsfrogs
> >>
> >> Assisted-by: Gemini:3.8-flash-high antigravity-cli-1.4.7
> >> Signed-off-by: koraynilay <koray.fra@gmail.com>
> >> ---
> >>  fs/file_attr.c            | 33 +++++++++++++++++++++++++++++++--
> >>  fs/stat.c                 |  2 ++
> >>  include/linux/fileattr.h  |  5 +++++
> >>  include/linux/stat.h      |  1 +
> >>  include/uapi/linux/fs.h   |  8 +++++++-
> >>  include/uapi/linux/stat.h |  7 ++++++-
> >>  6 files changed, 52 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/fs/file_attr.c b/fs/file_attr.c
> >> index 833e03810b24..c0645cb22bf3 100644
> >> --- a/fs/file_attr.c
> >> +++ b/fs/file_attr.c
> >> @@ -102,7 +102,7 @@ EXPORT_SYMBOL(vfs_fileattr_get);
> >>  static void fileattr_to_file_attr(const struct file_kattr *fa,
> >>                                   struct file_attr *fattr)
> >>  {
> >> -       __u32 mask =3D FS_XFLAGS_MASK;
> >> +       __u32 mask =3D FS_FILE_ATTR_XFLAGS_MASK;
> >>
> >>         memset(fattr, 0, sizeof(struct file_attr));
> >>         fattr->fa_xflags =3D fa->fsx_xflags & mask;
> >> @@ -110,6 +110,8 @@ static void fileattr_to_file_attr(const struct fil=
e_kattr *fa,
> >>         fattr->fa_nextents =3D fa->fsx_nextents;
> >>         fattr->fa_projid =3D fa->fsx_projid;
> >>         fattr->fa_cowextsize =3D fa->fsx_cowextsize;
> >> +       fattr->fa_ptime_sec =3D fa->fsx_ptime.tv_sec;
> >> +       fattr->fa_ptime_nsec =3D fa->fsx_ptime.tv_nsec;
> >>  }
> >>
> >>  /**
> >> @@ -141,15 +143,20 @@ EXPORT_SYMBOL(copy_fsxattr_to_user);
> >>  static int file_attr_to_fileattr(const struct file_attr *fattr,
> >>                                  struct file_kattr *fa)
> >>  {
> >> -       __u64 mask =3D FS_XFLAGS_MASK;
> >> +       __u64 mask =3D FS_FILE_ATTR_XFLAGS_MASK;
> >
> > That is not the correct way to extend this API.
> > This fixed mask was added as a placeholder for
> > "We intend to add support for more xflags to selective filesystems":
> > https://lore.kernel.org/linux-fsdevel/20250329143312.1350603-2-amir73il=
@gmail.com/
> >
> > Please see this POC patch for filesystems to publish their supported
> > xflags mask:
> > https://lore.kernel.org/linux-fsdevel/20250329143312.1350603-3-amir73il=
@gmail.com/
>
> Quick quesiton, should _mask also be used for user-space -> VFS to advert=
ise
> what it wants to change?
> This would be useful for on/off flags, but for ptime both fa->xflags and
> fa->xflags_mask would have the same meaning of "I want to change ptime,
> look at fa->ptime".
> Should we make _mask the only way to advertise what the user wants to
> change, ignore xflags | PTIME in user-space -> VFS and use it only in FS
> -> VFS -> user-space to say "this fs supports PTIME for this file"
> (which will be always once support is added to an FS, so it would just
> be "this FS supports PTIME")?
>

Sorry I was not able to parse your question.

I think the mask should mean "this FS supports PTIME"
regardless if the user asked to get/set it or not.

Thanks,
Amir.
