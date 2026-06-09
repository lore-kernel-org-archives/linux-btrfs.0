Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C4653F9F4C
	for <linux-btrfs@vger.kernel.org>; Tue,  9 Jun 2026 10:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781002413; cv=none; b=OLP6K9cL07yJOL2H81Q7k7FG/WnovZPKkGKa3LoMNn+z4PybT2LXwD9d1RQmGabdKe0Vlf29l9zKzwGYn3dF1Q2kQEUEAQYL1E1q1wL9NVia19Swo8ThWyen/+q/3vlPSImia5Ep0OvF9l+WlhJsZzXgIJcVoupB8VXuhxfdtCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781002413; c=relaxed/simple;
	bh=TN/dQKXmPWxEmXKY42pYNi0cKQCS4Kw+GuKpG+Wruvk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rEkGozdTqM4jAoJ8BKbmjjeR6cMBrfbhUEHDhhLFSUQ/h1TcBQ+/c/pQdck3Gg06nUqYVTtBbit2cConvor05IXXD0prFaZdfYB/zHBK+Y+3btrh5a2NDZohGerzXzdxitSvh/fbFkx+20R8D2p86prbqo4cZJwWGVtFvVDzdG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aL0EFBWf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aL0EFBWf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E85A21F0089C
	for <linux-btrfs@vger.kernel.org>; Tue,  9 Jun 2026 10:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781002411;
	bh=gRkFMrj+4v0iKN8SUBnG2edtd4Bm5Ep+vwYT0ibAVyg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=aL0EFBWfbHtq2eXgU+beIaDH+3O9iyXiQlltK7ADJGL2rRA/WMv+WPANKHqJ/SfBM
	 UdnZwOXqdW1Rl0HF3SasAqAmMuUzN2tx+2MTWJ28k9FelmJbTkaAUr5Aa/29i5Xc0v
	 p0J7ETvEBFEYWBNWSIt4L4E2ixqfGYxdFt7rbTc8siq8Had2JmcuE3dp72DGgo2sS2
	 d3m0GY2L7r4UTH20HM2o8ZIJKjKIYdsr0S/aLDPisFF2Nn5u1Ir1ZxbJvZNiT8TkSM
	 HPRn65M1Z74H35xQHxfAiw2Jl5bmTNhSMzDb2loLI9/T4YFTf3QdRR9iy1G4EN5BVG
	 mjOesjM3roHeg==
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-68cec9f4c6cso7498856a12.0
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Jun 2026 03:53:31 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8YTpKRLtIaMQFa++ueM1U3CVnzFY/vUH+yPFbdSCQVgm9tAF9itPKKeP3j5G1Zt6oKcamkvXvAyIqMBw==@vger.kernel.org
X-Gm-Message-State: AOJu0YygyfJdqWvIt7Ci3YSpwzAteA/mXimBmQ2lr8g+e6Uh/McGeEUq
	fJOubfS6bEUwWJNUKUbu42LY5RXeb9gGoKGy88fTJw1IldEtu4lgjTzsJcQtCyaUssDMs3okW88
	EORMw09rcJmNh7IfyMmGYExSdprUPB58=
X-Received: by 2002:a17:907:1c99:b0:bef:d3a1:5065 with SMTP id
 a640c23a62f3a-bf372059bdbmr962116966b.18.1781002410431; Tue, 09 Jun 2026
 03:53:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <aibaQGK38EIgqJQA@stanley.mountain>
In-Reply-To: <aibaQGK38EIgqJQA@stanley.mountain>
From: Filipe Manana <fdmanana@kernel.org>
Date: Tue, 9 Jun 2026 11:52:53 +0100
X-Gmail-Original-Message-ID: <CAL3q7H4w=tT-NQK1gQwZzi5vzrw3p6Cr_Ct2YpBf0p1YesUcJA@mail.gmail.com>
X-Gm-Features: AVVi8Certqs97gPch6H5C_xaTIi9yu2DNTkV79Rdq3WxutsGihJvHQtor2fY7G8
Message-ID: <CAL3q7H4w=tT-NQK1gQwZzi5vzrw3p6Cr_Ct2YpBf0p1YesUcJA@mail.gmail.com>
Subject: Re: [PATCH next] btrfs: tracepoints: fix error code in add_conflicting_inode()
To: Dan Carpenter <error27@gmail.com>
Cc: Filipe Manana <fdmanana@suse.com>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, 
	Johannes Thumshirn <johannes.thumshirn@wdc.com>, linux-btrfs@vger.kernel.org, 
	kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 8, 2026 at 4:46=E2=80=AFPM Dan Carpenter <error27@gmail.com> wr=
ote:
>
> This code had a second "ret" variable that shadowed the "real ret
> variable" so when we set the error code it was just discarded and
> we returned success.  Get rid of the shadow variable.
>
> Fixes: 3e4489a270f2 ("btrfs: tracepoints: add trace event for add_conflic=
ting_inode()")
> Signed-off-by: Dan Carpenter <error27@gmail.com>

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Folded into the original patch, thanks.

> ---
>  fs/btrfs/tree-log.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
> index bcccddcc568c..f01a53e825b0 100644
> --- a/fs/btrfs/tree-log.c
> +++ b/fs/btrfs/tree-log.c
> @@ -6174,7 +6174,7 @@ static int add_conflicting_inode(struct btrfs_trans=
_handle *trans,
>          *    some inode from it to some other directory).
>          */
>         if (IS_ERR(inode)) {
> -               int ret =3D PTR_ERR(inode);
> +               ret =3D PTR_ERR(inode);
>
>                 if (ret !=3D -ENOENT)
>                         goto out;
> --
> 2.53.0
>
>
