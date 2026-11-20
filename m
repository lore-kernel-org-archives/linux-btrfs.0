Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795183561;
	b=kADUbarK+qS9L8RRMC7QVWKSldPdjL2dQktES7OUIrPFsieYLi5Xz6KA9Pe/77eTx7u/
	 ef5DnP//9pCL+6N5jbQfP5VZT/t04Mi+ZdE2kyHJ1m+VujQiioQeDqjvFA1Z3yHFsazWm
	 wvNcl1+l+laWvCAh8alj0cTfF99f8eMsvbSq8drkGNxNhmfItsKXxj+uwwPn1StaQkWHX
	 1Unsl7WVPtufJh5cSPI7vJ8D71xHtjzCGWuQHGk5vHawtP28vX4ysQokr3bk1R9anQYuX
	 tGY/MKObO+gBXe9TMTNVLN8aCpACFrBWGGBpa3iwOJZ7P6APHJUB5TjSV7n+ujaTcAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795183561;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Mime-Version:Content-Type:Date:Message-Id:To:Cc:Subject:From:X-Mailer:
	 References:In-Reply-To;
	bh=lQXWhNQQlhPXEIIcGVoxJddlPdJJNSTkNAUDZ7QCuXs=;
	b=0UUqwnxmGiRbsI1i1UC+iYo6GmcMKei2Y1LKyDPMVIgMWfF+MICROYzeNmMBCLXzowk5
	 XthiCQ7jm5XbfhMcSUJ7VRHr58yjMAlklWBOmTiVVImzRYDcituu+XbE98utMjuKSWTz8
	 qE+2lckfQKH/+FyRHiGiBHs5CU6N/gaTR/E3n+xvk6eRURPCdAw8lXg5wzN8AgxokVfuv
	 kv7D2B0f1+5eU5OjflILb01j2hr8uZtLUn0eeVwQmZddPs3uRlA9QCZUqu6zZcKS10B9F
	 84ycsg4GpLd3ax0+nn2UhIYBk2oogyazYuRmPMXUiEDfz1rs2mT7QIXeIc/ebNhvQ/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="gpLZb0Z/";
	arc=none smtp.remote-ip=209.85.221.41
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A586E606A335
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2026 14:06:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A586E606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=gpLZb0Z/
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-491971ac844so796089f8f.2
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2026 06:06:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795183559; x=1795788359; darn=vger.kernel.org;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-type:mime-version:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=lQXWhNQQlhPXEIIcGVoxJddlPdJJNSTkNAUDZ7QCuXs=;
        b=gpLZb0Z/dRVHbMoXZrh+kzP5ioym8u6jETVmOgUHiTsO0gHBZvjaY1u8xn9vZYPjI3
         HlADiDIbW85273oCtZNkS/gSMZj7KDnEn2FCDAQplgZJNRBrG8J9zrvGJt5nkEQ6W9mF
         fyOtpp1IFic0Xu2tcDpKrH6QzUNu+5abygtChqmqZyNkLbL0LOGVwoaOpODRNVGjAFvj
         k86yIOI2k6HAthLvLU42zksjw+fJO5ba8Jqt7Q7/f94IEHSHQAXazZxeQGEOHaejOQg0
         KlroNHqPtg8w0ywi+z661oXiBCqpbpJqy0269kS0oz/lBVQ4wbPIsmv7FRbzRIsX7nVg
         1l4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795183559; x=1795788359;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-type:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=lQXWhNQQlhPXEIIcGVoxJddlPdJJNSTkNAUDZ7QCuXs=;
        b=C1+qFSGDD+yGAFDSa6nsxOdv6amdfwrl5TidOoCdBNJ+XzKJIuw5gNkT6a+SXKofMt
         3AuqUCYv7ay6akcQD92zQGf1BofGzY8PAZluqkO+mZ7MHBaUD5Z/lS+75+9r3+fPIcqi
         G4ZPbF4fdxC2lN2jOCpWZRI2mqxUVH13JME0QIQNEgpLlzRLCCzf/fT3u1ZBsoRugEzQ
         PYpmBOnYtGbdMMGxMqtHZEUB8b/2LRh/pFa63OVx1nxOxkKQUzUcqrN1egDJ1pSr6Usn
         awWKsYIMQrR8GNE4W2gR+XR66XrHA6SMK6YTS51YJRWYw6kr4wocfPJI8PJaXuKUz8Uu
         VUeg==
X-Forwarded-Encrypted: i=1; AL+hErEYDxTNTLygp4PG5ox2GztRHpb1zP1eZi4krrn8hFne1oGGf5iNSDtVBLCG+QMkmBognvmt9I0v999jKg==@vger.kernel.org
X-Gm-Message-State: APuU4Z8dgQm0T/gt9o7bu5h7xaziRbJu3HwAPdDY8JgZGJa9wRbtZeJ1
	QFDQPdn+zZF7Zt8Mg2w1nnK/YuGJHzHbJBapifelppT39Rlfo4VAzKvj
X-Gm-Gg: AZFdTZdVwb1ROtGAOoAMCdXX0AGk4d70W54MMssqG8Sqkv27On/QqR7jBWyjkykfKD2
	zbdrpEmUGg0JfgM2ARhh7IdA66PCVmNs8FUQqdjJGMTkV6d3dTBGZ//Ah5fdg6kjhmXgAexeRis
	J5At+9VRdGolDd7sbVD+Ff5rcQG+RB4ZmifCnRXt39kHAbTE/Xw1hfUnYWwgyqsNVSN70Fzj+Ht
	TTBDc0oaCwe+4hNk6czRThx4QHg/bUEVmOGxf887KDDuA/EzBL3440DPEvRaldwIXxew+zK64Fm
	JvAP+ZnRENEy7vXcNcf9PCD4bniNmcD6FrzLj2438Qkf6vyUO5tEDAvDXowLtiNDb7FLiLxKS3z
	1LcCDIfeWJEZR9lMp1bN+sC0DhwjbCVEfFVySOFfXepyM/0LA2F3SFimMJ69S68NfYnsv3F9/kQ
	H9iuaY5zwx4Na7/3yTUyzHeafZXXzfGKrtfmZZwHfX/sabTlJEFO0tEeWlZ1cpjqoGuYp3YQPZf
	odASS9oM9IYwWD76qNHo73jU9y4MEX9Ku1L4Wb1UFQbBXdFEwwccwSwW2Bnl6Mih+F4Sm750BUH
	E/gD0dtuX/VImsF6OkadUezQiSldWzbW/iDRB+C6/bI9ijg3GTSs8cdEG4Yb26gfgTqVcQ==
X-Received: by 2002:a05:6000:24c3:b0:4a4:368:409d with SMTP id ffacd0b85a97d-4abaa9769d3mr7118563f8f.3.1795183558599;
        Fri, 20 Nov 2026 06:05:58 -0800 (PST)
Received: from localhost ([130.192.98.149])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab658e2d1bsm6110394f8f.8.2026.11.20.06.05.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Nov 2026 06:05:57 -0800 (PST)
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
 boundary=9e5986ede954feecad11ad001d02150c5a356196d013aeccc838f4a9c70a;
 micalg=pgp-sha512; protocol="application/pgp-signature"
Date: Fri, 20 Nov 2026 15:05:53 +0100
Message-Id: <DN03GJ80ZWNZ.9GM35HM4T48N@gmail.com>
To: "Amir Goldstein" <amir73il@gmail.com>, "koraynilay"
 <koray.fra@gmail.com>
Cc: "David Sterba" <dsterba@suse.com>, "Namjae Jeon"
 <linkinjeon@kernel.org>, "Sungjong Seo" <sj1557.seo@samsung.com>,
 "Alexander Viro" <viro@zeniv.linux.org.uk>, "Christian Brauner"
 <brauner@kernel.org>, "Trond Myklebust" <trondmy@kernel.org>, "Anna
 Schumaker" <anna@kernel.org>, "Chuck Lever" <cel@kernel.org>, "Jeff Layton"
 <jlayton@kernel.org>, "Konstantin Komarov"
 <almaz.alexandrovich@paragon-software.com>, "Paulo Alcantara"
 <pc@manguebit.org>, "Chris Mason" <mason@kernel.org>, "Yuezhang Mo"
 <yuezhang.mo@sony.com>, "Jan Kara" <jack@suse.cz>, "NeilBrown"
 <neil@brown.name>, "Olga Kornievskaia" <okorniev@redhat.com>, "Dai Ngo"
 <Dai.Ngo@oracle.com>, "Tom Talpey" <tom@talpey.com>, "Ronnie Sahlberg"
 <ronniesahlberg@gmail.com>, "Shyam Prasad N" <sprasad@microsoft.com>,
 "Bharath SM" <bharathsm@microsoft.com>, "Sergey Senozhatsky"
 <senozhatsky@chromium.org>, "ChenXiaoSong" <chenxiaosong@chenxiaosong.com>,
 "Darrick J . Wong" <djwong@kernel.org>, "Sean Smith"
 <defendthedisabled@gmail.com>, "Andrey Albershteyn" <aalbersh@kernel.org>,
 "Pedro Falcato" <pfalcato@suse.de>, =?utf-8?q?Pali_Roh=C3=A1r?=
 <pali@kernel.org>, <linux-btrfs@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
 <exfat@lists.linux.dev>, <ntfs3@lists.linux.dev>,
 <linux-cifs@vger.kernel.org>, <linux-nfs@vger.kernel.org>,
 <linux-api@vger.kernel.org>, "Miklos Szeredi" <miklos@szeredi.hu>
Subject: Re: [RFC PATCH v4 10/10] cifs: add provenance time (ptime) and map
 it to SMB's CreationTime
From: "koraynilay" <koray.fra@gmail.com>
X-Mailer: aerc 0.22.0-0-gc2f86b7abde3
References: <20261115180343.576773-1-koray.fra@gmail.com>
 <20261115180343.576773-11-koray.fra@gmail.com>
 <CAOQ4uxg2gpC99ohuvKm-SgPzuffJy1fSvXorbuBnYZ=OFSxT3w@mail.gmail.com>
 <DMZIZ05H7MMB.1WYNR4X44BPGR@gmail.com>
 <CAOQ4uxg8aVcWyNiFDk8djdn-M3xJcu_7-kRxVq9jjFsbcGp1ew@mail.gmail.com>
In-Reply-To: <CAOQ4uxg8aVcWyNiFDk8djdn-M3xJcu_7-kRxVq9jjFsbcGp1ew@mail.gmail.com>

--9e5986ede954feecad11ad001d02150c5a356196d013aeccc838f4a9c70a
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

On Fri Nov 20, 2026 at 7:34 AM CET, Amir Goldstein wrote:
> On Thu, Nov 19, 2026 at 11:02=E2=80=AFPM koraynilay <koray.fra@gmail.com>=
 wrote:
>>
>> On Thu Nov 19, 2026 at 7:32 PM CET, Amir Goldstein wrote:
>> > On Sun, Nov 15, 2026 at 7:04=E2=80=AFPM koraynilay <koray.fra@gmail.co=
m> wrote:
>> >>
>> >> Implement provenance time (ptime) in cifs, as introduced in a
>> >> previous commit ("vfs: add provenance time (ptime)").
>> >>
>> >> Map it to SMB's CreationTime, making it settable from userspace and
>> >> propagating it to the SMB server via FILE_BASIC_INFO.
>> >>
>> >> Support reading ptime via statx(2) and fileattr_get() from the cached
>> >> CreationTime.
>> >>
>> >> Update cifs_fileattr_set() to check xflags instead of only legacy fla=
gs
>> >> and add the cifs_set_file_crtime() helper to wrap the RPC call to the
>> >> SMB server.
>> >>
>> >> Assisted-by: Gemini:3.8-flash-high antigravity-cli-1.5.7
>> >> Signed-off-by: koraynilay <koray.fra@gmail.com>
>> >> ---
>> >>  fs/smb/client/cifsfs.c |   8 +++
>> >>  fs/smb/client/inode.c  |   7 ++-
>> >>  fs/smb/client/ioctl.c  | 109 ++++++++++++++++++++++++++++++---------=
--
>> >>  3 files changed, 94 insertions(+), 30 deletions(-)
>> >>
>> >> diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
>> >> index 8cff7857b450..c2f557e406d3 100644
>> >> --- a/fs/smb/client/cifsfs.c
>> >> +++ b/fs/smb/client/cifsfs.c
>> >> @@ -1307,6 +1307,14 @@ int cifs_fileattr_get(struct dentry *dentry, s=
truct file_kattr *fa)
>> >>         if (READ_ONCE(CIFS_I(inode)->cifsAttrs) & ATTR_COMPRESSED)
>> >>                 fa->flags |=3D FS_COMPR_FL;
>> >>
>> >> +       /* Report provenance time (ptime) to userspace */
>> >> +       if (CIFS_I(inode)->createtime) {
>> >> +               fa->fsx_xflags |=3D FS_XFLAG_PTIME;
>> >> +               fa->fsx_xflags_mask |=3D FS_XFLAG_PTIME;
>> >> +               fa->fsx_ptime =3D
>> >> +                     cifs_NTtimeToUnix(cpu_to_le64(CIFS_I(inode)->cr=
eatetime));
>> >> +       }
>> >> +
>> >>         /*
>> >>          * FS_CASEFOLD_FL is defined by UAPI as a folder attribute,
>> >>          * and userspace tools (e.g., lsattr) display it only on
>> >> diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
>> >> index 2647785ec1e4..f0b20a72b9c2 100644
>> >> --- a/fs/smb/client/inode.c
>> >> +++ b/fs/smb/client/inode.c
>> >> @@ -222,6 +222,7 @@ cifs_fattr_to_inode(struct inode *inode, struct c=
ifs_fattr *fattr,
>> >>
>> >>         cifs_i->cifsAttrs =3D fattr->cf_cifsattrs;
>> >>         cifs_i->reparse_tag =3D fattr->cf_cifstag;
>> >> +       cifs_i->createtime =3D fattr->cf_createtime;
>> >>
>> >>         if (fattr->cf_flags & CIFS_FATTR_NEED_REVAL)
>> >>                 cifs_i->time =3D 0;
>> >> @@ -2958,7 +2959,8 @@ int cifs_getattr(const struct mnt_idmap *idmap,=
 const struct path *path,
>> >>          * We need to be sure that all dirty pages are written and th=
e server
>> >>          * has actual ctime, mtime and file length.
>> >>          */
>> >> -       if ((request_mask & (STATX_CTIME | STATX_MTIME | STATX_SIZE |=
 STATX_BLOCKS)) &&
>> >> +       if ((request_mask & (STATX_CTIME | STATX_MTIME | STATX_PTIME
>> >> +                            | STATX_SIZE | STATX_BLOCKS)) &&
>> >>             !CIFS_CACHE_READ(CIFS_I(inode)) &&
>> >>             inode->i_mapping && inode->i_mapping->nrpages !=3D 0) {
>> >>                 rc =3D filemap_fdatawait(inode->i_mapping);
>> >> @@ -2992,6 +2994,9 @@ int cifs_getattr(const struct mnt_idmap *idmap,=
 const struct path *path,
>> >>                 stat->result_mask |=3D STATX_BTIME;
>> >>                 stat->btime =3D
>> >>                       cifs_NTtimeToUnix(cpu_to_le64(CIFS_I(inode)->cr=
eatetime));
>> >> +               stat->result_mask |=3D STATX_PTIME;
>> >> +               stat->ptime =3D
>> >> +                     cifs_NTtimeToUnix(cpu_to_le64(CIFS_I(inode)->cr=
eatetime));
>> >>         }
>> >>
>> >>         stat->attributes_mask |=3D (STATX_ATTR_COMPRESSED | STATX_ATT=
R_ENCRYPTED);
>> >> diff --git a/fs/smb/client/ioctl.c b/fs/smb/client/ioctl.c
>> >> index bb8808289a46..19a9556d39b4 100644
>> >> --- a/fs/smb/client/ioctl.c
>> >> +++ b/fs/smb/client/ioctl.c
>> >> @@ -181,6 +181,41 @@ static int cifs_set_compression(unsigned int xid=
, struct dentry *dentry,
>> >>                                             compression_state);
>> >>  }
>> >>
>> >> +static int cifs_set_file_crtime(unsigned int xid, struct dentry *den=
try,
>> >> +                               struct cifs_tcon *tcon, u64 crtime)
>> >> +{
>> >> +       struct inode *inode =3D d_inode(dentry);
>> >> +       struct TCP_Server_Info *server =3D tcon->ses->server;
>> >> +       FILE_BASIC_INFO info_buf =3D {};
>> >> +       const char *full_path;
>> >> +       void *page;
>> >> +       int rc;
>> >> +
>> >> +       if (!server->ops->set_file_info)
>> >> +               return -EOPNOTSUPP;
>> >> +
>> >> +       info_buf.CreationTime =3D cpu_to_le64(crtime);
>> >> +
>> >> +       page =3D alloc_dentry_path();
>> >> +       full_path =3D build_path_from_dentry(dentry, page);
>> >> +       if (IS_ERR(full_path)) {
>> >> +               rc =3D PTR_ERR(full_path);
>> >> +               goto out;
>> >> +       }
>> >> +
>> >> +       rc =3D server->ops->set_file_info(inode, full_path, &info_buf=
, xid);
>> >> +       if (rc =3D=3D 0) {
>> >> +               CIFS_I(inode)->createtime =3D crtime;
>> >> +               CIFS_I(inode)->time =3D 0;
>> >> +               inode_set_ctime_current(inode);
>> >> +       }
>> >> +
>> >> +out:
>> >> +       free_dentry_path(page);
>> >> +       return rc;
>> >> +}
>> >> +
>> >> +#define CIFS_SUPPORTED_XFLAGS (FS_XFLAG_PTIME)
>> >>  int cifs_fileattr_set(const struct mnt_idmap *idmap, struct dentry *=
dentry,
>> >>                       struct file_kattr *fa)
>> >>  {
>> >> @@ -193,49 +228,65 @@ int cifs_fileattr_set(const struct mnt_idmap *i=
dmap, struct dentry *dentry,
>> >>         bool enable_compression;
>> >>         struct cifs_tcon *tcon;
>> >>         unsigned int xid;
>> >> -       int rc;
>> >> +       int rc =3D 0;
>> >>
>> >> -       if (!fa->flags_valid)
>> >> +       if (fileattr_has_fsx_mask(fa, CIFS_SUPPORTED_XFLAGS))
>> >>                 return -EOPNOTSUPP;
>> >
>> > What is this supposed to check that is not already checked
>> > explicitly with fsx_xflags_mask below?
>>
>> It should work for FS_IOC_FSSETXATTR, where mask is 0... but it's also
>> there because when I started writing the various filesystems code I
>> hadn't added _mask yet, so I'll need to take a little step back and
>> revisit.
>>
>
> Yes, I see.
> I think the helper may still have value for fs that still parse the
> two types of flags.

Yeah maybe, I'll see after I the first vfs-only patch I think.

> To reduce the scope of your patch set this may be better.
>
>> >>
>> >> -       /*
>> >> -        * chattr writes back all flags returned by fileattr_get(). A=
ccept
>> >> -        * FS_CASEFOLD_FL only when it reflects the share's casefold =
state.
>> >> -        */
>> >> -       if (fa->flags & FS_CASEFOLD_FL) {
>> >> -               rc =3D cifs_fileattr_get(dentry, &current_fa);
>> >> -               if (rc)
>> >> -                       return rc;
>> >> -               if (current_fa.flags & FS_CASEFOLD_FL)
>> >> -                       allowed |=3D FS_CASEFOLD_FL;
>> >> -       }
>> >> -       if (fa->flags & ~allowed)
>> >> +       if (fa->fsx_xflags_mask & ~CIFS_SUPPORTED_XFLAGS)
>> >>                 return -EOPNOTSUPP;
>> >>
>> >> -       enable_compression =3D fa->flags & FS_COMPR_FL;
>> >> -       compression_state =3D enable_compression ? COMPRESSION_FORMAT=
_DEFAULT :
>> >> -                                                COMPRESSION_FORMAT_N=
ONE;
>> >> +       if (fa->flags_valid) {
>> >> +               /*
>> >> +                * chattr writes back all flags returned by fileattr_=
get(). Accept
>> >> +                * FS_CASEFOLD_FL only when it reflects the share's c=
asefold state.
>> >> +                */
>> >> +               if (fa->flags & FS_CASEFOLD_FL) {
>> >> +                       rc =3D cifs_fileattr_get(dentry, &current_fa)=
;
>> >> +                       if (rc)
>> >> +                               return rc;
>> >> +                       if (current_fa.flags & FS_CASEFOLD_FL)
>> >> +                               allowed |=3D FS_CASEFOLD_FL;
>> >> +               }
>> >> +               if (fa->flags & ~allowed)
>> >> +                       return -EOPNOTSUPP;
>> >
>> > This whole mess could be sorted out by switching the cifs
>> > implementation to the new API
>>
>> ("new API" you mean _mask right?)
>>
>
> Yes and ro_mask, but it probably also means converting all the
> read-only CASEFOLD fs to new api, so that FS_XFLAG_CASEFOLD
> could be taken out of FS_XFLAG_RDONLY_MASK

Can all flags currently in FS_XFLAG_RDONLY_MASK be rw for some
filesystems or only some?
Should they all be removed from FS_XFLAG_RDONLY_MASK and left to each
filesystem to define them as ro (to put in _ro_mask)?

>> > and implementing a generic vfs
>> > helper which does something like the above code to handle the
>> > old ioctls.
>> > FS_XFLAG_CASEFOLD would then be removed from
>> > FS_XFLAG_RDONLY_MASK and set explicitly in xflags_ro_mask
>> > by fs which don't allow to set if (e.g. nfs) and added to
>> > FS_COMMON_FL/FS_XFLAG_COMMON
>> >
>> > cifs would advertise FS_XFLAG_CASEFOLD in its ro_mask
>> > and then the generic helper would mask it and the new syscall
>> > will not allow it.
>> >
>> >> +       }
>> >> [...]
>> >> +               cifs_dbg(FYI, "set compress flag rc %d\n", rc);
>> >
>> > I think that the roadmap should be to slowly define all the old FS_*_F=
L
>> > flags as FS_XFLAGS_* and let the generic helpers deal with the convers=
ion.
>>
>> > But it is not so hard to convert one filesystem at a time in a way tha=
t
>> > fa->fsx_valid will have to be true, because, for example, here
>> > all the relevant flags would be supported by the new xflags API.
>>
>> So, something like what fileattr_fill_{x,}flags() do now, but for
>> file_attr_to_fileattr()?
>>
>
> Yes, something like this (maybe)
>
>  void fileattr_fill_flags(struct file_kattr *fa, u32 flags)
>  {
>         fa->flags_valid =3D true;
> +       fa->fsx_valid =3D !(flags & ~FS_COMMON_FL);
> +       fa->fsx_xflags_mask =3D FS_XFLAG_COMMON;
>         fa->flags =3D flags;

So, for the filesystems that switch to the new API, these new/changed
helpers should handle giving userspace the legacy FS_*_FL flags (if
userspace uses FS_IOC_GETFLAGS) by converting them from the FS_XFLAG_*
reported by the filesystem?

But did you write this
> +       fa->fsx_valid =3D !(flags & ~FS_COMMON_FL);
> +       fa->fsx_xflags_mask =3D FS_XFLAG_COMMON;
while thinking about FS_IOC_SETFLAGS, so from userspace to filesystem,
and this would be needed because that filesystem wouldn't know what
FS_*_FL are, so it will use the _mask and the converted xflags?

But why the opposite of (flags & ~FS_COMMON_FL) as fsx_valid?

Why fsx_valid =3D 0 if the passed flags also contain non-FS_COMMON_FL
flags and fsx_valid =3D 1 if the passed flags contain only FS_COMMON_FL
flags?
(if I understood correctly)

> But in this model FS_XFLAG_COMMON are only the ones that
> are mutable from the old ioctl.
>
> We would need to define FS_READONLY_FL to deal with the
> group of read-only legacy flags, if some fs needs them and wants
> to use the new API.

So the those filesystems can put it in _ro_mask on GET you mean?

>> > No need to do that now, as part of this patch set which is complicated
>> > enough, just need to see the road ahead of us that we have a way
>> > forward out of this messy flags_valid/fsx_valid inside filesystem
>> > implementations.
>>
>> I think it's probably better to clean up the API now, before introducing
>> new flags (like FS_XFLAG_BTIME/PTIME or the shared extent one in the
>> other thread) and as I'll say in that reply (I'll write it in a bit) I
>> think it's even better to first split the _mask changes into their own
>> RFC PATCH series, then have a separate one for ptime/btime.
>>
>
> Agree.
>
> It's even two different changes -
> The vfs internal _mask change and the UAPI _mask change.
> chattr -p implementation with new API would be the perfect
> champion to drive this UAPI change IMO.

Ah, right, they could even be made in 2 separate patches but it's
probably better to keep both in only one, since otherwise there would
need to be temporary vfs functions to convert xflags to xflags_mask and
back.

>> > My understanding is that Miklos introduced those hints to reduce the
>> > work needed per filesystem for the initial implementation of the
>> > vfs methods.
>>
>> Ah yeah that would make sense.
>>
>
> BTW the trigger for the vfs interface was ovl_copy_fileattr()
> so this is a user of the new vfs _mask API that we need to
> pay attention to.

Ah ok, I'll look into that too then.

> Thanks,
> Amir.



--9e5986ede954feecad11ad001d02150c5a356196d013aeccc838f4a9c70a
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRJ2XvJtXGwULYEerQ0bnTtJTDoOAUCawBTwQAKCRA0bnTtJTDo
OAhLAQD6MiOLbbybL5wy9alM14eREvB1XFf4dJYhOSWBa9LYCQD+OXKSMpjBKzE6
Qide56j5p8y/OESAy2MNJBjIhpYtBQU=
=hD6S
-----END PGP SIGNATURE-----

--9e5986ede954feecad11ad001d02150c5a356196d013aeccc838f4a9c70a--
