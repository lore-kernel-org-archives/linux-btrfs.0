Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.54
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795156502;
	b=tMoaQLt/w09MNzgNJjXGQr4FPFFwZwbkJeWuu/p9pZ0EEYV4E5IM7jIoeVmoZ59JborC
	 rY8E50mW9LXA0cil9G0Bq3j/G/eARoHJlqwHPmEImVNG3gmzJ24SA50cB7o30+A38Vjy/
	 WzAIIfrTyUbex2Kg1Dz10OSeFF6qqwEoQN+4BqFh32NofFXFZZC6if+Ypcyf59p4/drCl
	 O2qyXfRYd3YAVDHxpfa9NMSHv0jMeEsXBakMc08pZz+QxfY2AGYG4aL4guyWUPz2Y3+38
	 wziUybgsWirVkDtPx5Rsf4dHaS6zIIVG9nq00sfadFe9rwEcs9GE4X1TNjiGRoM3Qfw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795156502;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=pfrMR7Rruo2Y1Ch+K4Gps8KgIwbSf58C0a+/ogZCwLA=;
	b=dKuHOP0qQaFz7YWS9K7KXS3BeLWDf4pMewOj5UQHGA9+QJIdBQCJbzliAb/gYRnAAg+D
	 HGapogXoU84RW6v8DxlQ1WYY/xzpKikfNDqD4HgPYzfwxKuCGvdok05ROz1f5y2ejVRbE
	 QuiV0YB3dHc20rWRjgQrtYolasYryRzSfzQHZIUM6dUPQgn+iexr9ZH0uMVUuTo7ul941
	 pXinPjjx0+uQSzT1+xmW9i++1nEsMLDwnSk6JSBLTs9PT+VSO0Cwoh8oGF/5Afb1Zv3jK
	 1NrbaHy4X9Oj5nRByX3HtRA7mUn6kA1AJqptbCcTMCFB0Sy7koNNi2rtR6eLy7dJHgw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=kHtdayeo;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.54
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64225606A32A
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2026 06:35:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 64225606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=kHtdayeo
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-6b4bd3d98bfso644213a12.1
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Nov 2026 22:35:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795156500; cv=none;
        d=google.com; s=arc-20260327;
        b=le/xi96Ggj+FXh4yzWczT9qga7gNqjIczXSgIVyVI5JHmD0PQD+Yk8J9SSJniGsxlw
         6L/djSzn/iU/wxzSPanfukiV3Elleqp89Um6vtMhacoErrCZn3lb7SoAX6pVvFGJ5Nod
         sO5IYXFx7107Oc2z//KP/no8KnAm7Iwe+3F2Auido5tK1ntVDKqjkDW3kt9ovD9w0YcO
         ZemfGqzHBzj4kBLwTrSkA1nh9441xw4BXgwYsR9kVEv5WLwcEvFMFeGMzAGCDLcjb9xl
         iaK5qpvvfzx+OuSViaP9kL910y98S/zYa2KJ9oYOkMVFv6q8OuArjgGRL8WLskGbnXHs
         R6Wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=pfrMR7Rruo2Y1Ch+K4Gps8KgIwbSf58C0a+/ogZCwLA=;
        fh=JpFhKNGhyjCR/Aw/hPRiurUq+8wCyiRu6RaCnur9kFg=;
        b=Vo7TJsOr4/WlsGYudzKKdxaz6bTPLFQ3CcoJigpT3OirnT1xkLtxW4aRnyJd0c5p5J
         nkQDB2Chwjl2c0SZxXHHRHceToc8/TPyObFjAbQQz68J2FcA2q4XGh1cqug5ev7bLStB
         sjaivh1HeBhbV+/gx/2slRfa4jBRmyan5u1VCgmfmWkvnkEBxTb2MNO10mHcsalD9VQw
         at1ZRTPpn2CzyBAOgKG+U+B7rKQf15Smfpymow0nhdmbtD9Co66vXw8VyTFicJYNELi8
         89vtcK4xVGLJU0+FTwjwRUb1ZbHchXZiifsim4/Mh+ZNjMcatqgbVGv8Wn6eGkmYH6mz
         ODDQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795156500; x=1795761300; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=pfrMR7Rruo2Y1Ch+K4Gps8KgIwbSf58C0a+/ogZCwLA=;
        b=kHtdayeoZb3A+OaLbnmqCkK0p6jhbv47enjyrbzYNOD1BZ7n2KftkamwqB7+QPeamc
         QCUcZq6rH2/Zmc2Cu0dV75FzWvOsA7kJk2Svb+lzzBDh4MvMLXHPJFzaONzKrlQip3qE
         VoiDVuyg8E3e4+z0V4Si6oHrEBGQ2m2Gp72Lboryv7Hge5nrTsIZv28qnAN/5GQ46NC7
         k9FfbcxZZWjtQH7vZm5457JuUnKr0o5ApojT4O48z2MTx2mWdc0wq2jQglp67Ix9rIaW
         kWjlH62Q5X2wmrOKylIC3wHr+EF540hvntb7YjcCEhgfBcRxzlJz2GFk29G79zRoSASR
         zYJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795156500; x=1795761300;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pfrMR7Rruo2Y1Ch+K4Gps8KgIwbSf58C0a+/ogZCwLA=;
        b=HZU+6QXsqqlqEamJAHVvU2gm2IMGV5z5JSrYB8h/oJZXfWQaISUXWKnr4MmDMmZgm6
         o4HjM5s0PGrThjjYAW/SyqIyezet8XC161GCjceGp61gG6KSHiQIiN2X8BwFpl8sxIto
         x3xmYpQU9ygbtrrnfa3sOCTGsOgj4cISYSruCPfUX/k7mrh0/G/+sb7NknddotAYvhZd
         uBEBFVYk8oM7MNuDLhUJZRQHv/L5e0pdWHDuzQSzqXQMko5nvBsnJC3e9uw7FPJ9sNoT
         33l8UivxIYSWgHqUpTQLYeSCYkpPVo8WwKM6sR+pHW/mrEkrQX9At3HoWcoP9+XCRCpw
         cttQ==
X-Forwarded-Encrypted: i=1; AL+hErHPwFqaK6IFYk2cJIN/CHmRRkMME5XAO8Ruo/U8QBA1Tf8OubduQGdVylR2ioirmljM4zk0L7thwcsuDw==@vger.kernel.org
X-Gm-Message-State: APuU4Z86ly+M0PW+MZ/YFowIu/u50vcAxIeYcTfnQN7Zt/hyPF7MfMrT
	h8ccYdJlFudMUp0MNnyikqv/7ljiwRERbXL8TJUTQPRGGXRK9OBiW4N++E2FSVUxZL0GeOVYqqG
	Rl1q6WoCWcnvkNR7oVbCxXum2qW17eAE=
X-Gm-Gg: AZFdTZea9sBvIMCDuYvpdiHRFjfABbFwHwPLjcb6vfnAlFwOA0LaLSc+UHVGklhga/I
	KAmTCDaGAzH8K49EBCqPeRCXKAVB4B6khOX5prL6Agt08NBHsWSBYDMoEEk4maDEe27/tCqTMQX
	sOodpdYTVUjAmnuppSlsPhkboM9t2OM+pokQ0JINiQhT+Xws1GqFCy/bUn2QREmGtD33dE9qgw3
	4mY7Mk3klq1jK8B/sCsAe/GscfOTJl8UTGBUNksrLmvxRkbRQNa1LU2JRFTLtUm9TXIGe10sZLn
	jO6w/J4dLGCnLIm6mY1PWYA3oyzMk+vyc9uUIq2FVpIc48vJKQ85JvwKFriaQ2r1fYym8oAK/ps
	IYyol8DBiZvquzzaJOoEAyQDH01y7PFKV+5iYAWtOZGoa607GpLk4zJ73zdjGth2MIlwAHeI=
X-Received: by 2002:a05:6402:280e:b0:6b7:9290:dc59 with SMTP id
 4fb4d7f45d1cf-6ba37ed95d3mr1090284a12.37.1795156499250; Thu, 19 Nov 2026
 22:34:59 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261115180343.576773-1-koray.fra@gmail.com> <20261115180343.576773-11-koray.fra@gmail.com>
 <CAOQ4uxg2gpC99ohuvKm-SgPzuffJy1fSvXorbuBnYZ=OFSxT3w@mail.gmail.com> <DMZIZ05H7MMB.1WYNR4X44BPGR@gmail.com>
In-Reply-To: <DMZIZ05H7MMB.1WYNR4X44BPGR@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 20 Nov 2026 07:34:46 +0100
X-Gm-Features: Aa3M54pFpwXClfOUj4X0Ca6dDK3QavsSpzMcSRLuAsiSgUTDoLGicUfCWGHnj0M
Message-ID: <CAOQ4uxg8aVcWyNiFDk8djdn-M3xJcu_7-kRxVq9jjFsbcGp1ew@mail.gmail.com>
Subject: Re: [RFC PATCH v4 10/10] cifs: add provenance time (ptime) and map it
 to SMB's CreationTime
To: koraynilay <koray.fra@gmail.com>
Cc: David Sterba <dsterba@suse.com>, Namjae Jeon <linkinjeon@kernel.org>, 
	Sungjong Seo <sj1557.seo@samsung.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Trond Myklebust <trondmy@kernel.org>, 
	Anna Schumaker <anna@kernel.org>, Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, 
	Paulo Alcantara <pc@manguebit.org>, Chris Mason <mason@kernel.org>, Yuezhang Mo <yuezhang.mo@sony.com>, 
	Jan Kara <jack@suse.cz>, NeilBrown <neil@brown.name>, Olga Kornievskaia <okorniev@redhat.com>, 
	Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Bharath SM <bharathsm@microsoft.com>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>, "Darrick J . Wong" <djwong@kernel.org>, 
	Sean Smith <defendthedisabled@gmail.com>, Andrey Albershteyn <aalbersh@kernel.org>, 
	Pedro Falcato <pfalcato@suse.de>, =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>, 
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, exfat@lists.linux.dev, ntfs3@lists.linux.dev, 
	linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org, 
	linux-api@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 19, 2026 at 11:02=E2=80=AFPM koraynilay <koray.fra@gmail.com> w=
rote:
>
> On Thu Nov 19, 2026 at 7:32 PM CET, Amir Goldstein wrote:
> > On Sun, Nov 15, 2026 at 7:04=E2=80=AFPM koraynilay <koray.fra@gmail.com=
> wrote:
> >>
> >> Implement provenance time (ptime) in cifs, as introduced in a
> >> previous commit ("vfs: add provenance time (ptime)").
> >>
> >> Map it to SMB's CreationTime, making it settable from userspace and
> >> propagating it to the SMB server via FILE_BASIC_INFO.
> >>
> >> Support reading ptime via statx(2) and fileattr_get() from the cached
> >> CreationTime.
> >>
> >> Update cifs_fileattr_set() to check xflags instead of only legacy flag=
s
> >> and add the cifs_set_file_crtime() helper to wrap the RPC call to the
> >> SMB server.
> >>
> >> Assisted-by: Gemini:3.8-flash-high antigravity-cli-1.5.7
> >> Signed-off-by: koraynilay <koray.fra@gmail.com>
> >> ---
> >>  fs/smb/client/cifsfs.c |   8 +++
> >>  fs/smb/client/inode.c  |   7 ++-
> >>  fs/smb/client/ioctl.c  | 109 ++++++++++++++++++++++++++++++----------=
-
> >>  3 files changed, 94 insertions(+), 30 deletions(-)
> >>
> >> diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
> >> index 8cff7857b450..c2f557e406d3 100644
> >> --- a/fs/smb/client/cifsfs.c
> >> +++ b/fs/smb/client/cifsfs.c
> >> @@ -1307,6 +1307,14 @@ int cifs_fileattr_get(struct dentry *dentry, st=
ruct file_kattr *fa)
> >>         if (READ_ONCE(CIFS_I(inode)->cifsAttrs) & ATTR_COMPRESSED)
> >>                 fa->flags |=3D FS_COMPR_FL;
> >>
> >> +       /* Report provenance time (ptime) to userspace */
> >> +       if (CIFS_I(inode)->createtime) {
> >> +               fa->fsx_xflags |=3D FS_XFLAG_PTIME;
> >> +               fa->fsx_xflags_mask |=3D FS_XFLAG_PTIME;
> >> +               fa->fsx_ptime =3D
> >> +                     cifs_NTtimeToUnix(cpu_to_le64(CIFS_I(inode)->cre=
atetime));
> >> +       }
> >> +
> >>         /*
> >>          * FS_CASEFOLD_FL is defined by UAPI as a folder attribute,
> >>          * and userspace tools (e.g., lsattr) display it only on
> >> diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
> >> index 2647785ec1e4..f0b20a72b9c2 100644
> >> --- a/fs/smb/client/inode.c
> >> +++ b/fs/smb/client/inode.c
> >> @@ -222,6 +222,7 @@ cifs_fattr_to_inode(struct inode *inode, struct ci=
fs_fattr *fattr,
> >>
> >>         cifs_i->cifsAttrs =3D fattr->cf_cifsattrs;
> >>         cifs_i->reparse_tag =3D fattr->cf_cifstag;
> >> +       cifs_i->createtime =3D fattr->cf_createtime;
> >>
> >>         if (fattr->cf_flags & CIFS_FATTR_NEED_REVAL)
> >>                 cifs_i->time =3D 0;
> >> @@ -2958,7 +2959,8 @@ int cifs_getattr(const struct mnt_idmap *idmap, =
const struct path *path,
> >>          * We need to be sure that all dirty pages are written and the=
 server
> >>          * has actual ctime, mtime and file length.
> >>          */
> >> -       if ((request_mask & (STATX_CTIME | STATX_MTIME | STATX_SIZE | =
STATX_BLOCKS)) &&
> >> +       if ((request_mask & (STATX_CTIME | STATX_MTIME | STATX_PTIME
> >> +                            | STATX_SIZE | STATX_BLOCKS)) &&
> >>             !CIFS_CACHE_READ(CIFS_I(inode)) &&
> >>             inode->i_mapping && inode->i_mapping->nrpages !=3D 0) {
> >>                 rc =3D filemap_fdatawait(inode->i_mapping);
> >> @@ -2992,6 +2994,9 @@ int cifs_getattr(const struct mnt_idmap *idmap, =
const struct path *path,
> >>                 stat->result_mask |=3D STATX_BTIME;
> >>                 stat->btime =3D
> >>                       cifs_NTtimeToUnix(cpu_to_le64(CIFS_I(inode)->cre=
atetime));
> >> +               stat->result_mask |=3D STATX_PTIME;
> >> +               stat->ptime =3D
> >> +                     cifs_NTtimeToUnix(cpu_to_le64(CIFS_I(inode)->cre=
atetime));
> >>         }
> >>
> >>         stat->attributes_mask |=3D (STATX_ATTR_COMPRESSED | STATX_ATTR=
_ENCRYPTED);
> >> diff --git a/fs/smb/client/ioctl.c b/fs/smb/client/ioctl.c
> >> index bb8808289a46..19a9556d39b4 100644
> >> --- a/fs/smb/client/ioctl.c
> >> +++ b/fs/smb/client/ioctl.c
> >> @@ -181,6 +181,41 @@ static int cifs_set_compression(unsigned int xid,=
 struct dentry *dentry,
> >>                                             compression_state);
> >>  }
> >>
> >> +static int cifs_set_file_crtime(unsigned int xid, struct dentry *dent=
ry,
> >> +                               struct cifs_tcon *tcon, u64 crtime)
> >> +{
> >> +       struct inode *inode =3D d_inode(dentry);
> >> +       struct TCP_Server_Info *server =3D tcon->ses->server;
> >> +       FILE_BASIC_INFO info_buf =3D {};
> >> +       const char *full_path;
> >> +       void *page;
> >> +       int rc;
> >> +
> >> +       if (!server->ops->set_file_info)
> >> +               return -EOPNOTSUPP;
> >> +
> >> +       info_buf.CreationTime =3D cpu_to_le64(crtime);
> >> +
> >> +       page =3D alloc_dentry_path();
> >> +       full_path =3D build_path_from_dentry(dentry, page);
> >> +       if (IS_ERR(full_path)) {
> >> +               rc =3D PTR_ERR(full_path);
> >> +               goto out;
> >> +       }
> >> +
> >> +       rc =3D server->ops->set_file_info(inode, full_path, &info_buf,=
 xid);
> >> +       if (rc =3D=3D 0) {
> >> +               CIFS_I(inode)->createtime =3D crtime;
> >> +               CIFS_I(inode)->time =3D 0;
> >> +               inode_set_ctime_current(inode);
> >> +       }
> >> +
> >> +out:
> >> +       free_dentry_path(page);
> >> +       return rc;
> >> +}
> >> +
> >> +#define CIFS_SUPPORTED_XFLAGS (FS_XFLAG_PTIME)
> >>  int cifs_fileattr_set(const struct mnt_idmap *idmap, struct dentry *d=
entry,
> >>                       struct file_kattr *fa)
> >>  {
> >> @@ -193,49 +228,65 @@ int cifs_fileattr_set(const struct mnt_idmap *id=
map, struct dentry *dentry,
> >>         bool enable_compression;
> >>         struct cifs_tcon *tcon;
> >>         unsigned int xid;
> >> -       int rc;
> >> +       int rc =3D 0;
> >>
> >> -       if (!fa->flags_valid)
> >> +       if (fileattr_has_fsx_mask(fa, CIFS_SUPPORTED_XFLAGS))
> >>                 return -EOPNOTSUPP;
> >
> > What is this supposed to check that is not already checked
> > explicitly with fsx_xflags_mask below?
>
> It should work for FS_IOC_FSSETXATTR, where mask is 0... but it's also
> there because when I started writing the various filesystems code I
> hadn't added _mask yet, so I'll need to take a little step back and
> revisit.
>

Yes, I see.
I think the helper may still have value for fs that still parse the
two types of flags.

To reduce the scope of your patch set this may be better.

> >>
> >> -       /*
> >> -        * chattr writes back all flags returned by fileattr_get(). Ac=
cept
> >> -        * FS_CASEFOLD_FL only when it reflects the share's casefold s=
tate.
> >> -        */
> >> -       if (fa->flags & FS_CASEFOLD_FL) {
> >> -               rc =3D cifs_fileattr_get(dentry, &current_fa);
> >> -               if (rc)
> >> -                       return rc;
> >> -               if (current_fa.flags & FS_CASEFOLD_FL)
> >> -                       allowed |=3D FS_CASEFOLD_FL;
> >> -       }
> >> -       if (fa->flags & ~allowed)
> >> +       if (fa->fsx_xflags_mask & ~CIFS_SUPPORTED_XFLAGS)
> >>                 return -EOPNOTSUPP;
> >>
> >> -       enable_compression =3D fa->flags & FS_COMPR_FL;
> >> -       compression_state =3D enable_compression ? COMPRESSION_FORMAT_=
DEFAULT :
> >> -                                                COMPRESSION_FORMAT_NO=
NE;
> >> +       if (fa->flags_valid) {
> >> +               /*
> >> +                * chattr writes back all flags returned by fileattr_g=
et(). Accept
> >> +                * FS_CASEFOLD_FL only when it reflects the share's ca=
sefold state.
> >> +                */
> >> +               if (fa->flags & FS_CASEFOLD_FL) {
> >> +                       rc =3D cifs_fileattr_get(dentry, &current_fa);
> >> +                       if (rc)
> >> +                               return rc;
> >> +                       if (current_fa.flags & FS_CASEFOLD_FL)
> >> +                               allowed |=3D FS_CASEFOLD_FL;
> >> +               }
> >> +               if (fa->flags & ~allowed)
> >> +                       return -EOPNOTSUPP;
> >
> > This whole mess could be sorted out by switching the cifs
> > implementation to the new API
>
> ("new API" you mean _mask right?)
>

Yes and ro_mask, but it probably also means converting all the
read-only CASEFOLD fs to new api, so that FS_XFLAG_CASEFOLD
could be taken out of FS_XFLAG_RDONLY_MASK

> > and implementing a generic vfs
> > helper which does something like the above code to handle the
> > old ioctls.
> > FS_XFLAG_CASEFOLD would then be removed from
> > FS_XFLAG_RDONLY_MASK and set explicitly in xflags_ro_mask
> > by fs which don't allow to set if (e.g. nfs) and added to
> > FS_COMMON_FL/FS_XFLAG_COMMON
> >
> > cifs would advertise FS_XFLAG_CASEFOLD in its ro_mask
> > and then the generic helper would mask it and the new syscall
> > will not allow it.
> >
> >> +       }
> >> [...]
> >> +               cifs_dbg(FYI, "set compress flag rc %d\n", rc);
> >
> > I think that the roadmap should be to slowly define all the old FS_*_FL
> > flags as FS_XFLAGS_* and let the generic helpers deal with the conversi=
on.
>
> > But it is not so hard to convert one filesystem at a time in a way that
> > fa->fsx_valid will have to be true, because, for example, here
> > all the relevant flags would be supported by the new xflags API.
>
> So, something like what fileattr_fill_{x,}flags() do now, but for
> file_attr_to_fileattr()?
>

Yes, something like this (maybe)

 void fileattr_fill_flags(struct file_kattr *fa, u32 flags)
 {
        fa->flags_valid =3D true;
+       fa->fsx_valid =3D !(flags & ~FS_COMMON_FL);
+       fa->fsx_xflags_mask =3D FS_XFLAG_COMMON;
        fa->flags =3D flags;

But in this model FS_XFLAG_COMMON are only the ones that
are mutable from the old ioctl.

We would need to define FS_READONLY_FL to deal with the
group of read-only legacy flags, if some fs needs them and wants
to use the new API.

> > No need to do that now, as part of this patch set which is complicated
> > enough, just need to see the road ahead of us that we have a way
> > forward out of this messy flags_valid/fsx_valid inside filesystem
> > implementations.
>
> I think it's probably better to clean up the API now, before introducing
> new flags (like FS_XFLAG_BTIME/PTIME or the shared extent one in the
> other thread) and as I'll say in that reply (I'll write it in a bit) I
> think it's even better to first split the _mask changes into their own
> RFC PATCH series, then have a separate one for ptime/btime.
>

Agree.

It's even two different changes -
The vfs internal _mask change and the UAPI _mask change.
chattr -p implementation with new API would be the perfect
champion to drive this UAPI change IMO.

> > My understanding is that Miklos introduced those hints to reduce the
> > work needed per filesystem for the initial implementation of the
> > vfs methods.
>
> Ah yeah that would make sense.
>

BTW the trigger for the vfs interface was ovl_copy_fileattr()
so this is a user of the new vfs _mask API that we need to
pay attention to.

Thanks,
Amir.
