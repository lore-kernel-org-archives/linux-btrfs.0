Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.43
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795445772;
	b=iZIrTParVqfqCyb+bMIBQ+grQfA9RrzOhBaOoip+toy4RNHxVE/h+dUBqaJH1oK0pALQ
	 +vYMEKkfhQHa/sJYzqRsPOAU99lcequ+BK+YR2x10XEAPn/U5T5F19zSJUeO+pRG6dTaK
	 DYVeY51f3ltA4ggmH3htqUvsukFbQ71ZJixG9ba51pMP4rLk2OiSFiv+IhRFl3HbN8mwK
	 rh4uQZ6doRMBQ5inCfEjEz9VKkwezPDoopyQJJ9GgHY4uM29Fosv4GtTWoT4zNM1+xk33
	 JjS7tiRocVtW42f4BOP7cMkXFOF/zdxFSNnIueJqk39blC8zLpXjLPC9aKWgG8GuDIw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795445772;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=iLBZumrqdFfo+uoEqy5DjzVlLpVK7yMeWhuKRObIsyk=;
	b=GYjUxxFTjn0Le3c4yKugP32ATj4VyYxQc4eiOCEwYJRhuCrtfOMRQYzTcCN1FfAhza1n
	 CyCZ74dMVSJ7hu6O26jvaeYQ0rJgDaYB3rOlh1mdag9Giu/Vn5Zie7d7Oheb8MLdvgJuQ
	 zmDfMCfm+I9vdQ0+JwbHmV7e/pwZeYFrQ51oVIZLAwzXZzAD7ZOjuBwpaG9fauk4SKOrI
	 Lhn8pTXVU/sRDzbqOIqbtV1TAXnBuUkR2nI/vKWdz2RM+fiORi117OpXfIJ7m8q4slGp+
	 uNzG0kM9+cvvJJA8iJkHiS2O++g5JA98PgbPrw2k+3q2/dBc7Ec/sIbjZ+Q4QGupqOw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=wqeG4UVx;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.43
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56FCA606A32D
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Nov 2026 14:56:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 56FCA606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=wqeG4UVx
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6ba38c41804so3825605a12.3
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Nov 2026 06:56:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795445771; cv=none;
        d=google.com; s=arc-20260327;
        b=nW/WfwxaDNvcxr1mQYgRKnvXWgi0TbKRPRwYwPjonKlWWG6TwLrC1RhYQCCDaFkE/d
         5RvBkXRezpE6IpPB0/pzo8Wef96p9sew0aQSu+TTSv4hrHj2WioDwhOmBI6BFP+LgjcV
         LxH5tGW617dGg5oOaY6TvQ03ojREC6QLM/1URGGMjz4E++pXA5ymRhqTUWAAN8EqE/ij
         CqEw8IDrapJ39boDIXR/qDd4v+tYeTfj8ivImGn435/9ZnOAEfiF2HxWPjkQEPF0ZFC9
         oYEDqSavUvUphvUvFQTYtKWecz6JyronzZ5rJ5bA/8ixxRVt2oYvNKzxLv4uQv2xJdAz
         icMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=iLBZumrqdFfo+uoEqy5DjzVlLpVK7yMeWhuKRObIsyk=;
        fh=7oOXSLHJmGDrm+YIWMrmGZny4rDQty5B0SQjFw9roug=;
        b=Uu+8ZuNak9MJW5P/9BBbhhDElbvfvQiAgLKbjV9WC5qB0FF039osJHyh0doJmo0x6J
         9zzq37hf/TcZ4TaCj5oQ2Y0RJKUAFBGNsCUnLA5kLE6G2ZdKV3eagGmvrRITKONY1TZo
         OxIJYF9k8Q7wBOAbaZ20ogmpcsT8T0KUM6LQ9ilNxyVtuMvOlbGmOS5mwlJowjq+dLZE
         NM+WzhYhWYRaqDE44Ve3D69t5CJNbNdhfQ10gSoBaizWsRI/n+rLJbi3zN2TodOzExXt
         NAEY/OaNKIFRt3vknn0eoDapGig8thjFYvweNQUISHcXhTBLYfYJYG0eb0sNfFcgw8gh
         5vSA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795445771; x=1796050571; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=iLBZumrqdFfo+uoEqy5DjzVlLpVK7yMeWhuKRObIsyk=;
        b=wqeG4UVxEsqawGNw4hgj4cfTFQ6arGqHSUO6imUiUMeXa8Rm1J1TOte1yUPje6cwe+
         TH7GIH833ISdvF+478dTG3g3rLc8GhsHBKY9tqDuuQG6ExZLNhc6wL4HurcYB7XYzYdM
         k1c8ZPl+i2LZWoD5sDSXAeuyZzpwDmF+lV5KF+mNx7I24cADkXDh2iddswNPgtjRQiod
         98Rf1TYJCpfC9KwAJ5lRFDyGvcIpE/pXspm8dgf3k6SDEHnakNvYQAXllHZS4/z97Zhl
         7Cy4Ubz5DFhoeGRxQ9Dvdf2g25hW/qM8ZE/LRkxbNQ4Q7lkYgGaDdPliMsLLJbdE54BG
         tBDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795445771; x=1796050571;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iLBZumrqdFfo+uoEqy5DjzVlLpVK7yMeWhuKRObIsyk=;
        b=1PniksQdKHVVoVaSwBGGsX4E8dWOH7uHG6ueePx+5TNNha6DAdYby/bQuaS4KBCevp
         EGC7OTip+e2qPfuq6PsRMF4NfMogm/7uOSddcGbpFrskPbF36JlaGAN9DCLdkbtHrfqo
         u7lbSaU8X1EHQNJnSAPes36g7jW3RXUa490xH+fBLfoJeSNqkeRJXXUmNo6isShR+5k1
         StnkEA5oxMVLZXIZUHDPZBZQBlPabdFhAfNlN+tVsC81h1z7BjhfFc8bB0Fm8ljtSPML
         +Wz/KztF1dglV/Tk3czZN6phVJjLfnhFomDSB32xK/v9zKNXXY/9ImBipx2LOM1OjMfn
         hD9g==
X-Forwarded-Encrypted: i=1; AL+hErHBE15US1/NwLQKwwjf5ABjzYnFeYTfFNZm4Zmug8/ElXYX/vpQGZxB0IXZ1z7LOt4suXADv4zjd609cg==@vger.kernel.org
X-Gm-Message-State: APuU4Z9/4T01Mr6qYTQP5fslEkGWtp5TZeKENxVUBG6p8Iz+qFwUliL1
	09l4kivY0unNbdvEwerIZqrL26L7e/nURuMl2ohkG+ym0IX/+UquzWw6KDV+p/+9O/33tLSsh7T
	yGLWeZ7PeoJKLv736PawQuA20rDYaE1c=
X-Gm-Gg: AZFdTZcEJcfMfiulVey2GEyDKXxeJazNA/qmNYdBO33YG0SQ9Qalj/XmR4esC+csBXI
	jcG1MQ8lIMelqydQN26c7vpkwA0lU4JsDWrbFWjr6+3OuP9UgZ9DqZ/aEVIXD2ObntFzr9TVMCk
	qTYadp/bxRrz8gFuHV0mEFEDfOWAnaDHMd6PT0K1goCOe8wKOGqnwazSNg54uxKsLdy/aJ1T+JW
	LUp9BaQLv3R3+jqVD49v/hxVezV86gpJCVxnoiyxT+14mWqcNrlEcCZeFMYTHKTAg1J0qJQrV7h
	PVrbikVZz6xh2Y/E6YnIPNzKocwE69G63cAnHUKKnuqpuU/d4IOxpff73u3pDUVqPSuhjSGd08G
	w75oj2a5kCmtl6rwJc2fvxPotzB3FtL60wSAo/mJ8XWskyO3Xh2QZzfnqqDtqDncEGZf/zQ==
X-Received: by 2002:a05:6402:5516:b0:6b6:ef7f:600d with SMTP id
 4fb4d7f45d1cf-6ba37e74244mr7852050a12.21.1795445770471; Mon, 23 Nov 2026
 06:56:10 -0800 (PST)
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
 <CAOQ4uxgc6pP+_xvJMbqj6wOdGzS75Vn6x6i_vUfCJDD46DAA_Q@mail.gmail.com>
 <DN2N0BY83OY2.1OV3ZAZFSWCDG@gmail.com> <CAOQ4uxg9O-R_SUPAZ75ESGB99-4Z4EEUKGMkCF2f-sXkGPq1GA@mail.gmail.com>
 <DN2NVGUNO0GA.89JAB2PVI0LA@gmail.com>
In-Reply-To: <DN2NVGUNO0GA.89JAB2PVI0LA@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 23 Nov 2026 15:55:57 +0100
X-Gm-Features: Aa3M54p3kKL3ZKUzvEHZq54IOonM6T5WCFB3q5vIRbaCh5i5swbxajRtrCtjW5o
Message-ID: <CAOQ4uxjuAN0FdxGr_-OccO5qnUuLF5oxOq7L_545tG3+36EKFw@mail.gmail.com>
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

On Mon, Nov 23, 2026 at 3:31=E2=80=AFPM koraynilay <koray.fra@gmail.com> wr=
ote:
>
> On Mon Nov 23, 2026 at 3:14 PM CET, Amir Goldstein wrote:
> > On Mon, Nov 23, 2026 at 2:50=E2=80=AFPM koraynilay <koray.fra@gmail.com=
> wrote:
> >>
> >> On Mon Nov 23, 2026 at 2:00 PM CET, Amir Goldstein wrote:
> >> > On Sun, Nov 22, 2026 at 1:09=E2=80=AFAM koraynilay <koray.fra@gmail.=
com> wrote:
> >> >>
> [...]
> >> > Rule:
> >> >
> >> > You cannot add a flag to common without carefully auditing all
> >> > filesystems that support the legacy flag.
> >>
> >> Yeah, sashiko pointed out a problem in f2fs, and I could reproduce it =
in
> >> testing, where adding COMPR to COMMON makes f2fs crash, it also needs
> >> NOCOMP in COMMON.
> >>
> >
> > I don't think this is correct, or at least not enough.
> > My agent said that this breaks or changes things on  f2fs/ext4/ubifs
> > I didn't bother to check if all of them are true - I doubt it
> > bottom line - need careful audit and good testing.
>
> Yes, definitely.
>
> >
> >> > FS_XFLAG_ENCRYPT can go into common but must also
> >> > go to FS_XFLAG_RDONLY_MASK because it's read-only for
> >> > all existing fs.
> >> >
> >> > COMPR is rw for some fs and ro for others.
> >> > As with CASEFOLD, you cannot make it COMMON before
> >> > converting all casefold fs to new API so that each can say
> >> > whether it wants RO or RW.
> >>
> >> How's CASEFOLD currently handled? in the v2 I'm drafting, I added
> >> fileattr_mask_to_legacy() and fileattr_legacy_to_mask(), which convert
> >> between the old format (filtering by FS_XFLAGS_MASK) and the new mask
> >> format.
> >>
> >
> > Good question.
> > Need to check this.
>
> Can you do that? If not, I'll check tonight, no problem.
>

CASEFOLD is set in FS_XFLAG_RDONLY_MASK and NOT set
in COMMON

Therefore, doing set with the old xflags API for the common flags always
preserves the old CASEFOLD.

This is kind of ugly and works but its hard to see the design there
so hopefully all the new helpers and masks will sort this and make it
more explicit.

IOW, ENCRYPT can use the VERITY RDONLY and COMMON
precedent because it is read-only across all fs (via this API).

COMPR (for the purpose of ntfs patch) can follow the precedent
of CASEFOLD of RDONLY and ~COMMON, which somehow works.

Note that for fs that were converted to the xflags_mask API,
COMMON should be irrelevant.

COMMON is only used in SET to do GET and preserve the ~COMMON
bits of the "other" API flavor.

With the xflags_mask API, unless we adopt the "verify" feature
there needs to be no internal GET with user SET and then COMMON
is not used at all relevant at all for those fs (e.g. ntfs) only the
_fill_ converters are important.

> >> > I think there may be a way to deal with this easily since
> >> > ntfs doesn't need to set either but not sure.
> >>
> >> We could export the 2 other helpers I added for v2 (xflags_to_flags an=
d
> >> flags_to_xflags) and make NTFS use them?
> >> Though adding the fileattr_ prefix will make the current (v2) vfs code
> >> maybe too verbose.
> >>
> >
> > Honestly, I can't say for sure - you can try
> >
> > I think you may need a different set of helpers fileattr_prep_ used by =
the
> > filesystsems that are converted to xflags_mask, which may be different =
from
> > the set of helpers used by the user facing ioctls but I'm not sure.
> >
>
> I guess I'll think about it when I move NTFS's impl to the updated vfs
> code.
>
> > The thing is - this is all hard to wrap our heads around
> Yes.
> > You and I have parts of the design in our heads w.r.t backward
> > compat with legacy API, both UAPI and vfs internal api.
> >
> > I think you should put it in writing to see that you and I have
> > not left anything out because this v1 surely does get it wrong
> > in several places both wrt legacy UAPI breakage and internal
> > API correctness.
>
> I agree, now the version in my head is not finalized yet, so I'll do
> that in the v2 patch/cover letter.
>
> TLDR is "use the legacy to/from mask converters whenever needed, so:
> - user legacy -> fs legacy: keep as the old code did
> - user legacy -> fs mask: fileattr_legacy_to_mask()
> - user mask -> fs legacy: fileattr_mask_to_legacy()
> - user mask -> fs mask: pass it through
>
> (before finalizing the GET path I want to finish the SET path).
>

Maybe for me if I don't see the full picture, full get-set cycle
it's hard for me to judge.

Thanks,
Amir.
