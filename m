Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.54
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795447799;
	b=kX7+KbE5A1eLhA8H6Xm2dGSQKEtiuDgy+obFSEiiYfp85WqUeNXyr9YPIxCu0EfPmQqz
	 zhaY7EGDPcQz3y7Gv6oFhPZAptIIxi7LiWLKKtZNUbk2H8Cijz3Iw6Q3RtSsTcBpgtwSQ
	 XfakjSonELXThoHc4iSatMdwSc7rApRaKeVsa+dNj8EhWwXsUq8AsRmTIlkaTDDJveCxb
	 GXzhWXNduJ2ndZUkKSKbNbidUOB2wWUf/5cHR8ILf48Vc3rX8OROiLVUvQMHfsE37OKCp
	 L0VyX7T31DvX0BGTVqratR3kZwPOOQbqtHoqFZm7QhuA4FOdQpN0vyrkGqD3dR/6Tmw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795447799;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=XTqD3jTsvce7PV4dxiBL4DNg4qThdQn7thVX1pxBbRQ=;
	b=xj8uI4I3q/8D6Y506ZSAKJEXvzm4f3TIhlNC+yc8jr/cm5oH0T5PPYiqV95i2KQ1enEN
	 wKqm5J/UpRh6ktjqSChpdQF7gD4W/aZOAkHcekSUwGpCer8kK7Gxt1KSYEAZfftHzvijc
	 crbvpWUWA6qYMIH71RITZ2TlkliyhLgcx+0NNweHTutLHFKue+1VwYfiat1Xx84NAPCsb
	 39DmVVpoe7K2vQkiGtW/HoS7462Np0efXfMZOGzHsfu9g5at7h87hiE/v1rmm6WxjJroj
	 3+HRBAg/pRwXbDxpry5DXdMCYNsR3UE2YLDoBC2yrW9h+xytQi5PSvLS+FQDN5l4hfw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=U3UavhO0;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.54
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50EE2606A321
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Nov 2026 15:29:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 50EE2606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=U3UavhO0
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-6b587538a37so5047103a12.2
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Nov 2026 07:29:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795447797; cv=none;
        d=google.com; s=arc-20260327;
        b=UBz3V0y0bixhrGpm+mtpx6bJc6qu/QIcEMCqwFEKxrR8Tp3lnKPpFk7KKgJ7cNNLR5
         ZmTBKKxa38QQqI5H1nH4shKNITH/6yeMQSNJ6iVoi1jkDLdHTIW5HjDG3osHe416oXrX
         HJUPqDWGaqaSg3P8juX6XJX/9mujbCTvPx636T44J6+XkD3gsCGgUj5zSC4FIN1vzcQQ
         mtYAIPrDzrOPopr3E1UkzOUUqcJBy2dKQhfEhP3LByhUkCbIAyBMNNqRFeoJWpkM7hFc
         v8uAW0Le3ldvFYJ6IF8eLRSmiLeWOqYdPFjeQlnzOub/pZMRamm0YiQmVc0AIwhrvE+i
         Mqdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=XTqD3jTsvce7PV4dxiBL4DNg4qThdQn7thVX1pxBbRQ=;
        fh=4dsZQrPmioNKjdC51/1ZVBa3+pLypStEA/1R/Pbn228=;
        b=dwRJ1tIM9uX7/zw+oPWktE7d/5n0rzSW5QC8HOQEOHDqgNy/Da8BtCHPy1uBmrmL1T
         /RcYkEXX/5ZI46SF/WiWBu4/fK8YUCSgYlBjAex75Ti4zV7dTswZtJw+/6xxeC+uZWFk
         wmUYujxWO9EtCgaW62jIlaYkxD4O3uJjS0t5Q1wcw0NL3PFnHoP88D2Umkn/XKohDaNJ
         CWgxJwyW4vU9HtsmhNplfv6CpGbQOdKNotQHKb5BcEoTOG64iWRmwyoppsBX2PZbK1CQ
         DzMsp3mvlWzZT5+AUYimQOLAliDftjztLpqf96Wis+5SGkJHUsh9oYZADGimzmknAMcn
         mi3w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795447797; x=1796052597; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=XTqD3jTsvce7PV4dxiBL4DNg4qThdQn7thVX1pxBbRQ=;
        b=U3UavhO0vHfet44jf/aYXoS79W6o76/gvGmauPo8EJm4ak5yEu10LKFJc+bYM6DlNU
         dCfYYbZo4XhCpeXp62rA0WhWPdxwGSBPkk4yinisKQ/3HfliRazobfQ9a7wzP5P/SNIj
         eY6Fkypy+Iu144S/pfklmW+0egIWItbVB08gm8qw5tnR8zDbFxxrzY0hnU6BZ3IwGmbE
         LsikLplsus57/TtIIXYJNnBuJ+PJ0Bp+wTkqaQckcSlNsFqJe0wHdq3V547JgL9TtAhO
         QOlSChEk/jL5J2GuElsY4mHz8m3/NfdWUNuOhXFy5X6AjFyJdiPpdHYlxE7EGBx26kpc
         vI5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795447797; x=1796052597;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XTqD3jTsvce7PV4dxiBL4DNg4qThdQn7thVX1pxBbRQ=;
        b=mxv0U4Y05C4utVgaQnj65CiyZtlG8Sgi1UqVXxvs6EXnQjcz/rUJqvfB6kNkE/3UdH
         9egFWBbvNmMfPAoO6W6UxmYtm/UJ7CQJcDOzYqYa+L9+X+QlfIwQ2NOnxxh7AjMFtcd7
         9XCE5k7uZ37AfXzB3wpyKiePW5N41bxzBLLSYwtAuVYAO/xXc66R/00KfBAe+SN8JECY
         ZLX3iQ2YXRqfNsSnlY5skk7QsTGS5Za+Cg+Z8ue6StNxm/rmd4XbbK3tFkrqt6BAHj3Y
         4QuorEaYsmiEESGrI0zz440btqnZTnJOLUqrDgeVFfe+kAN3KzWApANnd39ubSrRJWgX
         a/Xg==
X-Forwarded-Encrypted: i=1; AL+hErH7r9U1W/RZHnJqXIjSzF7u2G1bvgJEvlAHBSexidCgpBhAzNdIfNZTRGmDgUjdkBBaPEeqjqH50W80nA==@vger.kernel.org
X-Gm-Message-State: APuU4Z96VivJK7ZUrgS/K6mNEQG9SLSjAu1sY4nflvnO175tFnosXHCN
	i0N6/bToQaPjhnKl6j0+6XlneLf5Kl5TTmE8+hz3gMWYphQVYH7sVXi68iBh1jzVQyKxr2EEMmw
	bO6nlsyemoReXj+EzWdspwovE0r3ZIe8=
X-Gm-Gg: AZFdTZd2rMXkyLo33Rtx/VzGnRwSBkyuKHvw50ZJh0phgyBNBTDwqkGxAoS7Lh12NpF
	wlMS+x/ZARIxpWLGLzwb+wmy7FkKtVfDOpSj9UuMhzZwtLIt+IvbpEhkso1ltNKcUSuhrQj7NR3
	j4HZLggHJ996F9Ug83sNwSTTYc+VSbJCZt5H+W+efTJ1qAPD2kVbUQIqDaFUi3s58kkeP7KlnGg
	jIpCtRnLqVsEO/MHXtB+vrZPssM3a0OEd/IdkhJPoCtsDyvSGAybvGBIv02liSiznfZ3iOSQIB8
	sl+E3+61p0iIly6xwAvHmKQsfzPJ0PBKyoTsEO3yzfqjOoHGJ3yVD/GzZp5fV8xEAQKWj3Pqx6H
	BExMGYXJq4OnNRmlXluyix1FiwHe5dZxx+5y8gnolQv0I7rWAWhFskGFrcnCBe76zjzEJ3A==
X-Received: by 2002:a05:6402:e05:b0:6b4:9919:b54 with SMTP id
 4fb4d7f45d1cf-6ba37f04a34mr8166206a12.42.1795447796335; Mon, 23 Nov 2026
 07:29:56 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261122000856.536902-1-koray.fra@gmail.com> <20261122000856.536902-3-koray.fra@gmail.com>
 <CAOQ4uxhegn1z=41_MHL1Zu2hXuPtzNhC=x4gd371oaeJE4-weQ@mail.gmail.com> <DN2N6A68PBO1.2QT8ZOARF4I6L@gmail.com>
In-Reply-To: <DN2N6A68PBO1.2QT8ZOARF4I6L@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 23 Nov 2026 16:29:44 +0100
X-Gm-Features: Aa3M54rXlfF1ti3csfwg-SOdn_z3DGpZ_P359TQjfteI3PWichkZOxWgdTC23l0
Message-ID: <CAOQ4uxhDQqEQ3T9NveBFpUmSU032BxrNV5D+_zHj8u9LOQY+qg@mail.gmail.com>
Subject: Re: [PATCH 2/3] vfs: add xflags mask to fileattr API
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

On Mon, Nov 23, 2026 at 2:58=E2=80=AFPM koraynilay <koray.fra@gmail.com> wr=
ote:
>
> On Mon Nov 23, 2026 at 2:24 PM CET, Amir Goldstein wrote:
> > On Sun, Nov 22, 2026 at 1:09=E2=80=AFAM koraynilay <koray.fra@gmail.com=
> wrote:
> >>
> >> Add fa_xflags_rw_mask and fa_xflags_ro_mask to struct file_attr and
> >> equivalent masks to struct file_kattr.
> >>
> >> Also add has_masks selector to struct file_kattr so we can know when a
> >> user of this API (userspace or filesystem) supports them.
> >>
> >> This lets filesystems advertise their support for specific xflags, lik=
e
> >> statx.stx_attributes_mask does, and userspace can specify only which
> >> xflags it wants to change without needing a RMW cycle:
> >> - on GET: each filesystem that wants to support this new API fills the
> >>   masks according to its supported and read-only xflags, then:
> >>   * for boolean xflags: it fills fsx_xflags with the current on-disk v=
alue
> >>   * for value xflags: it sets the xflag bit to 1 in fsx_xflags and the
> >>     xflag value in the struct field;
> >> - on SET: userspace fills the rw_mask with the bits of the xflags it
> >>   wants to change, then:
> >>   * for boolean xflags: it provides the xflag value as a bit in fa_xfl=
ags
> >>   * for value xflags: it sets the xflag bit to 1 in fa_xflags and then
> >>     provides the value in the struct field; if the xflag bit is set to=
 0
> >>     instead, this informs the kernel to unset/clear that value.
> >>
> >> Since fa_xflags_rw_mask means "I want to change the xflags specified i=
n
> >> here", if userspace specifies fa_xflags_rw_mask =3D 0, only check for
> >> permissions and fileattr support without checking any xflags.
> >>
> >> Behaviour of older programs that already use file_[gs]etattr() is
> >> preserved by checking against FILE_ATTR_SIZE_VER*.
> >>
> >> Also add the missing FS_XFLAG_PROJID xflag, to allow userspace to set
> >> the projid using file_[gs]etattr() by leveraging the new masks.
> >>
> >> Finally, in order to prevent the legacy FS_IOC_FSSETXATTR from accepti=
ng
> >> FS_XFLAG_PROJID, add a FS_FILE_ATTR_XFLAGS_MASK to support new xflags
> >> and use it to validate/clamp both the _xflags fields and the masks.
> >>
> >> Assisted-by: Gemini:3.8-flash-high antigravity-cli-1.5.11
> >> Signed-off-by: koraynilay <koray.fra@gmail.com>
> >> ---
...
> >>         err =3D fileattr_set_prepare(inode, &old_ma, fa);
> >> @@ -424,6 +504,14 @@ SYSCALL_DEFINE5(file_getattr, int, dfd, const cha=
r __user *, filename,
> >>                 return error;
> >>
> >>         fileattr_to_file_attr(&fa, &fattr);
> >> +       /*
> >> +        * Remove xflags added in or after VER1 so userspace programs =
compiled
> >> +        * against VER0 don't try to write xflags they don't know abou=
t (since
> >> +        * they do RMW).
> >> +        */
> >> +       if (usize < FILE_ATTR_SIZE_VER1)
> >> +               fattr.fa_xflags &=3D FS_XFLAGS_MASK;
> >> +
> >
> > This looks odd.
> > old struct size with new flags should be -EINVAL not silently drop them
>
> Right, and the GET path should strip any new flags, so old programs
> doing RMW will never see them, correct?
>

Yes, I think so.

> >
> >>         error =3D copy_struct_to_user(ufattr, usize, &fattr,
> >>                                     sizeof(struct file_attr), NULL);
> >>
> >> @@ -460,10 +548,6 @@ SYSCALL_DEFINE5(file_setattr, int, dfd, const cha=
r __user *, filename,
> >>         if (error)
> >>                 return error;
> >>
> >> -       error =3D file_attr_to_fileattr(&fattr, &fa);
> >> -       if (error)
> >> -               return error;
> >> -
> >>         CLASS(filename_maybe_null, name)(filename, at_flags);
> >>         if (!name && dfd >=3D 0) {
> >>                 CLASS(fd, f)(dfd);
> >> @@ -479,6 +563,30 @@ SYSCALL_DEFINE5(file_setattr, int, dfd, const cha=
r __user *, filename,
> >>                         return error;
> >>         }
> >>
> >> +       /*
> >> +        * Userspace said "I don't want to change any flag", so be it =
I guess.
> >> +        * Still check for fileattr support and permissions, also in c=
ase this
> >> +        * is just a probe.
> >> +        */
> >> +       if (usize >=3D FILE_ATTR_SIZE_VER1 && fattr.fa_xflags_rw_mask =
=3D=3D 0) {
> >> +               struct inode *inode =3D d_inode(filepath.dentry);
> >
> >
> > No No this is not what this userspace said!
> >
> > This user space is the same old chattr programs recompiled with a new
> > fs.h header file
> > installed.
>
> Oh, right, I did not think about this case, I hope it doesn't break too
> much of the new code I changed already for v2 :(
>
> > When userspace does not set anything is masks it means "old API"
>
> And so a modern program using masks that passes rw_mask as 0 should be
> also interpreted as "old API", even if it kinda goes against the
> definition of rw_mask right?

Yes, but it is not a problem to describe this backward compat exception:
When (rw_mask | ro_mask) =3D=3D 0, it means "no mask" "set everything"
but then vfs will not accept new xflags that were not supported in v0
syscall.

> And other than VER there is no way to know if it's a SETFLAGS compiled
> against modern fs.h or fileattr VER1 explicitly setting rw_mask to 0,
> right?
>

SETFLAGS with explicit 0 rw_mask is not useful and does not make
sense, so there is no reason to support this in any other meaning than
legacy programs.

Thanks,
Amir.
