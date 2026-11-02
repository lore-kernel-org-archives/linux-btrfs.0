Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.44
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793632194;
	b=ypvkS0Gp2CG4QhDFRGpsulXdZuIuobscH11fcDwYwPPrTHSgNLY02/uVltnHguTYIUCl
	 k/Uei3got2XcwY5Uqz97GmcbQGZOeNljsP9hP8nHtgDea04f+iPV7YKwjQJdIZerIaeK7
	 YN97sZl+LiFDg0oYXKGRyc6G7TmYbv2qniDOkIBZpNhBRKcXpRAlm8yEeC+OVl5+AGK5S
	 VU3mvs2uqftS2j2SAJgqBY4upsTxZkHFJPyUnkBHa0od9p+xnpqUhHieY3toqajAcStx2
	 0VFjGA6SWtyssRZbK5+W2QUYsl5nuqQaPrm9FJ+nPPTrNpEceaB1gUHBFfakfW21bpQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793632194;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=V5oGEHqJ8v+T24gYPQlWKHiFIfSM1fugDdyxpETnIGg=;
	b=WZAwnzcsJzrA8GT2uEvOI+Mp5kJnZK0S2cn1Ee/qaee0E/V9/uiYBOKvrPpOB5Lg/gjT
	 MoOTNXpITXcpkLwJhVtj8Yy084+rfDSJtowg/W6F1L3BbX7A19yhV2azxbF6jGteTEJ7z
	 W4MhJscMvMwXPhatSsSpcBYoeA2ZNaNxXgpkZIyasC81e7jXIEmXkwv4FVWkP8V77fSu0
	 eFOHoMPVhAPImtdYOJ1duig+GctvAOAny3bFhe0ti/hJgfank0y471VBhUxspTR8iat5x
	 33/DhD9HrYLeA/N/KmBafG2Lf3GM95qqvmXJSTXYHUaE3s+iOfBbUDmrEwEa4ZXoONw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=mIOy3AeV;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.44
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 833EE606B1FC
	for <linux-btrfs@vger.kernel.org>; Mon,  2 Nov 2026 15:09:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 833EE606B1FC
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=mIOy3AeV
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6b1b13e09ffso4271347a12.3
        for <linux-btrfs@vger.kernel.org>; Mon, 02 Nov 2026 07:09:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793632193; cv=none;
        d=google.com; s=arc-20260327;
        b=pbu5xKMXgq5xyKMfRlP5m/qLKKBbwQVBZ9vbzoCYaxjCNrVZ2yP4MEQYGE738r31B7
         o9fBK63v11ITOM1vye0sLq34GTydR41HJaK8l8gYB/a9lfIyzwCPLwIe6CKPNJzp7bPm
         qiyGlGwohOnLANmRMLlnApF3oa2c0+9veDz+RJb/IJzPmrIJPYqRV0ei5wRGdB7JARhb
         Vuiw6QHhEiDRLloPAdwz4iS1+iKR2Pw27orrG0+mKLZUPxCYBkzfIfYFYkl8e/8/9KTu
         x4bUZFj44NYyKDesWFoG9MEkCu3tbbdc8PNpZgMjaLvx+icdbomIhSqPrPywUCpQfd02
         ZSiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=V5oGEHqJ8v+T24gYPQlWKHiFIfSM1fugDdyxpETnIGg=;
        fh=phDE5+0PT77z0NVYZKZ856trBPvW1Vwsh2RESxhg4us=;
        b=chu98IiDUryq8htQrBjkDKM02XahFHum07rMN8rxanFlqFwQRCIgKa+CXboET5dnB6
         eB4CWvPP2B5I8ZRcmY/bdWPwpp1AQVjcWiASKOaZEshrO4c8Hg5P7JY6ayK9LUCZcvbP
         a38uMgNeVp3wGunjG50Biart5t4cN7CXvO1dz8Cvgmd5BfWuD8WVkmlIFnz9Sqkw0ZHb
         NmbUhBgD62mw8DFQoFPw2aAESApJ/GzQk6ykLRa4ez6O8k621zBD2XGOjUnhIMJR6PD0
         adDVJu/ujRo7Vksu7wGzAklHDLgKMRRJBhK+iUfW1n6IvdpYpY9Dls/1CtgUt9kHvZxs
         eB6g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793632193; x=1794236993; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=V5oGEHqJ8v+T24gYPQlWKHiFIfSM1fugDdyxpETnIGg=;
        b=mIOy3AeVsuWhyP+l6zA16Ucz20Y+QphUxMILOJk08HJCRUJzanCmGGCzgIzPsgBy9o
         LyJ8inTq2q9yWhRw7me/r58dVxm6liirJLCxwEY6460lx0DXcEkaqlFP8OV8YCx0kFoM
         HoE+n6yR9RitH33XexK6Z6cy5cl3M3o2JG9Z1WE6aUBM6ZsP/VxlHG534TLHDnsUaare
         jMFzjt20DhnmU8TYEiyotX5hCQYZdGjSym2gUXW1p7xsUyYH1XtX0iiA0HpEhiNC0u/o
         zVGFyTi7a55y36X4lQNFQ7NoXmL3GN3UjbePDGNGL779i91M7RqsaBxPOULjaqJU/Hek
         kMvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793632193; x=1794236993;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=V5oGEHqJ8v+T24gYPQlWKHiFIfSM1fugDdyxpETnIGg=;
        b=cJoqzlpkLTMv9OduZHdXb3OaT+jqqTptQqwAVU4O+zhRxEQDilzUrj8dhVCnkFbgXq
         wkscbdQj5pEt4r75IY1t1tXOLHbyxVgAY1uM6Vmp2GppMARg3x5vUBv0JYCHypmdM2i8
         ImySxZQYbj4PSJ3YOPYSdKXrtWjpTqKB8yyTIfbytCNNHx6CeaN1oLYvr0Bseroiw1l+
         O1XabB2+RoPnoa4MvH3FXgr9I4/ds+uhXBa30PEWzVkG9ClXlH3AsikgDWNpjYjLdQus
         P1DkAOHf6bn55xl50ZkBbsAs+0VYJA6Ck1cgaUvW/zgLjHn80iomE2k7N+rkHmEePJma
         C/Kw==
X-Forwarded-Encrypted: i=1; AKwUvBwY3RiCa4Zk5l9X6VH4zEAUlLiJEkieDHE40RyYejdMkxLG1pDOthVbgkBIqjN+YpRD6y7MmO9TdjcWLQ==@vger.kernel.org
X-Gm-Message-State: APuU4Z87cV+tdRFjgMVRN6uRQjnR6qd6AvbEfKbnej8FmA4KShxMQtEf
	irzK+CF9/A+Jn98MMCQ6csGDeBKm+VN6VvX+vrgYBbMST68oTtGsqYloYgv6PCUKe0G3aCql/qh
	w6lIOVysKcNcN1UesFTm3twAaLCRT9pY=
X-Gm-Gg: AYBFou1+4UnQqGoaM7oxBg1YoCRhhcBSMmsyfovFmHiPFPQm4U0TZKtLPq9wmKOwMsj
	+Jnknz+42OCrHx5qw3fAUAVIBH6x+tn74qbkWHL6GAI7A8hk6Eooz8q3dRhzrWBElKgY2wamafV
	lXPzQKEiPdyuXNy7KJAPIBSAUPgTzBFqDQPqsi6cmK5W+J7h81wYVMadf40b72r7m7qIMP6Ea1e
	8E/0x0U7CSm1OObTmP6Y+PmEfyiXbvk/q46eclYIJQsLqXCuxZTMCwQ4af0T3wL7y6hQPir7pTl
	hkum8mQqxUTBqzttpS9qRSaFjiK1UhC1MOThX3lg6mv91B9YOKxeUKeiwKJ3kt8LG7Zb4887e96
	cBGuJ96Dez9B/LBaPkFmRTzVlqcAGWwe/7f8bGHiKB8DuDTrg8s8Gd/3V2WeQimMZ+JLpRQ==
X-Received: by 2002:a17:906:4fd5:b0:c46:7fa4:922c with SMTP id
 a640c23a62f3a-c4ca7b20e1fmr868205166b.24.1793632192478; Mon, 02 Nov 2026
 07:09:52 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261101015551.786044-1-koray.fra@gmail.com> <20261101015551.786044-4-koray.fra@gmail.com>
 <20261102142452.d6jkitgdeuquy23i@pali>
In-Reply-To: <20261102142452.d6jkitgdeuquy23i@pali>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 2 Nov 2026 16:09:41 +0100
X-Gm-Features: AclHuK8kuq8eQ7yCdpsnJrZqU_PhMlxnY90gMXEz8lBNnkHZ5ogvsTJfHTXbOfo
Message-ID: <CAOQ4uxhQ3uhq6s+4deEJAQV5iy8QZoucojR58_dUNYrnjt_yvA@mail.gmail.com>
Subject: Re: [RFC PATCH v3 3/5] ntfs3: make crtime user-settable using ptime
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc: koraynilay <koray.fra@gmail.com>, David Sterba <dsterba@suse.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Namjae Jeon <linkinjeon@kernel.org>, Sungjong Seo <sj1557.seo@samsung.com>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Chris Mason <mason@kernel.org>, 
	Jan Kara <jack@suse.cz>, Yuezhang Mo <yuezhang.mo@sony.com>, Chuck Lever <cel@kernel.org>, 
	"Darrick J . Wong" <djwong@kernel.org>, Sean Smith <defendthedisabled@gmail.com>, 
	Andrey Albershteyn <aalbersh@kernel.org>, Pedro Falcato <pfalcato@suse.de>, linux-btrfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	exfat@lists.linux.dev, ntfs3@lists.linux.dev, linux-api@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 2, 2026 at 3:24=E2=80=AFPM Pali Roh=C3=A1r <pali@kernel.org> wr=
ote:
>
> On Sunday 01 November 2026 02:55:49 koraynilay wrote:
> > @@ -154,6 +158,11 @@ int ntfs_fileattr_set(const struct mnt_idmap *idma=
p, struct dentry *dentry,
> >       if (flags & FS_APPEND_FL)
> >               new_fl |=3D S_APPEND;
> >
> > +     if (fa->fsx_xflags & FS_XFLAG_PTIME) {
> > +             ni->i_crtime.tv_sec =3D fa->fsx_ptime.tv_sec;
> > +             ni->i_crtime.tv_nsec =3D fa->fsx_ptime.tv_nsec;
> > +     }
> > +
> >       inode_set_flags(inode, new_fl, S_IMMUTABLE | S_APPEND);
> >
> >       /* Save nodump flag to return in ntfs_getattr. */
> > @@ -275,8 +284,9 @@ int ntfs_getattr(const struct mnt_idmap *idmap, con=
st struct path *path,
> >       if (unlikely(is_bad_ni(ni)))
> >               return -EINVAL;
> >
> > -     stat->result_mask |=3D STATX_BTIME;
> > +     stat->result_mask |=3D (STATX_BTIME | STATX_PTIME);
> >       stat->btime =3D ni->i_crtime;
> > +     stat->ptime =3D ni->i_crtime;
>
> For me this patch looks dangerous. Somehow I would expect that the
> "btime" will never change for existing inode.
>
> But because the ptime is mapped to i_crtime and ptime is settable from
> userspace, with this patch it is directly possible to change btime.
>
>
>
> I was thinking more about it... Is not this just misunderstanding of how
> the security model around the times is working on different systems?
> Because on NTFS there is stored just one field which says when the file
> was created. There are not two fields like "time set by user and time
> set by system".
>
> Windows security model allows anybody with WRITE_ATTRIBUTES access to
> change that create time. Linux security model does not allow to change it=
.
>
> NTFS in this view is just a filesystem like any other (ext4, btrfs, ...).
> In my opinion if the ext4 or btrfs filesystem is correctly implemented
> on Windows systems, then Windows security model should handle it in the
> same way like for NTFS or exFAT. So if something grants WRITE_ATTRIBUTES
> access, then Windows should allow to change also btime on ext4 or btrfs.
>
>
>
> On the other hand, I understand the use case to have two creation times.
> One time which would never be changed and could be used for any kind of
> atomic / synchronization by userspace application logic (this btime).
> And another time for human which can be changed at any time to any value
> which user wants (this ptime).
>
> In any case, I would suggest that filesystem driver would not report to
> userspace unsupported values and would not try to invent other values
> and lying about them.

But all those fs with mutable creation time already report it with STATX_BT=
IME
so what can we do about this?

If userspace requests both STATX_BTIME|STATX_PTIME in mask arg,
those fs could technically return only STATX_PTIME and it should not regres=
s
existing programs.

But this is still a bit surprising behavior is it not?

Thanks,
Amir.
