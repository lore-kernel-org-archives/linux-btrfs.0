Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C892509EE6
	for <linux-btrfs@vger.kernel.org>; Fri, 18 Sep 2026 17:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789752775; cv=none; b=BY9zQsEtdTe8MbiQuNI0HdZSZH/FtySvSCublEiEzRabzfQNl3o+7Svyic+Ze4yGazvENdjo91yz5pIFy64jtz9gbuxqM7ng2W1lyIc9SfogtmrKyulJybgmzs+J+Gzsb2BQVNskZfVFekAY1NmnHf+Uf31gEvELqZYodOiq/KE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789752775; c=relaxed/simple;
	bh=3BwuemqTZztEeSCWJRdxs99PQi6Tb9Vmdzx9jj0jb9M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ENaYACPAF/4xxqOqQBFF73JijqDl/Q16RtSRNyGLOsRIvlo+ZEsIwCLGs/A3JYwJiYX7YjZRSoFwRpiDaa8eCrRBsx/temG4z1g5Uys1DsZzlHqtnBAhcGel5zWKKO6EkGpJH2ukgmZ1pc5FYbXIaPSqxu4b4dIHuOGgNYGNXug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k6c/TRVk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k6c/TRVk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AA8F1F000FF
	for <linux-btrfs@vger.kernel.org>; Fri, 18 Sep 2026 17:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789752763;
	bh=Hb1fxQuuorLTTna4+2iHL1FGESLJ9XPQ22Wl5ZC8NE8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=k6c/TRVkotQ4diwVyUsfmYscasWwsc9otoZpT/6PD2L7qs5Qn4S1fYPKLvaM5cSjK
	 xcn6Zu0ixQy93RldGNOH6kAO1vmk5GaI8D/Wt0BPhSW167v4hCVTX+Xu3CqmDUyFCw
	 njglcdWR2wi3ih9tNVQSJ/4N4gUSDSoT+Atzmdq93r0YVXrY9Llr7/M7wvUqWJsjc0
	 XrprE+mq+nyDbd3qVk6S6L+1CfeB+aPC2FiYTffjkVSyntIuqrftdYnJ0hGsYSetgI
	 7c/qK84N7U8AbKQN+A+Q0B9ywNab6rr54G4xA3MyJeFDqUICqC8R8J4V1f8HNxFaMZ
	 sMXHyuZn3UP7A==
Received: by mail-vs2-f32.google.com with SMTP id 71dfb90a1353d-5c67e4d8d8aso654519e0c.1
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Sep 2026 10:32:43 -0700 (PDT)
X-Gm-Message-State: AFuF++kAtvDax9+GNzqTOurv+fBgB9nE/jOg85ldaKpI1dheEt7G/g/z
	rn13grG/ZXgDWenvJ6b4/uY02SBA62HGr5mCj4jG81C+OKZEwYlO2bndh0iR7dfTyFtF5zLZTgk
	nsrlFZsYodgcGLjW36zgM2S3W7SB5T/U=
X-Received: by 2002:a05:6122:2214:b0:5c9:18b1:b7ff with SMTP id
 71dfb90a1353d-5c9b58e983emr1619210e0c.7.1789752762025; Fri, 18 Sep 2026
 10:32:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1789734239.git.fdmanana@suse.com> <410734082c3a544458920efe7be7a39222424aeb.1789734245.git.fdmanana@suse.com>
 <20260918171906.GB2900089@zen.localdomain>
In-Reply-To: <20260918171906.GB2900089@zen.localdomain>
From: Filipe Manana <fdmanana@kernel.org>
Date: Fri, 18 Sep 2026 18:32:05 +0100
X-Gmail-Original-Message-ID: <CAL3q7H4dSDPm5Z3F1qwkFA-omHaCXLtyH5u7BOpkhOqAQ3knKg@mail.gmail.com>
X-Gm-Features: AcwNN1VgMVBE_7KAkYLxQNA8HAXzvytvvIWNQq-AfPZ-5UwTvuPc3IlOFeBxvho
Message-ID: <CAL3q7H4dSDPm5Z3F1qwkFA-omHaCXLtyH5u7BOpkhOqAQ3knKg@mail.gmail.com>
Subject: Re: [PATCH 1/3] btrfs: clear BTRFS_ROOT_IN_TRANS_SETUP on early exit
 from record_root_in_trans()
To: Boris Burkov <boris@bur.io>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 18, 2026 at 6:18=E2=80=AFPM Boris Burkov <boris@bur.io> wrote:
>
> On Fri, Sep 18, 2026 at 01:28:09PM +0100, fdmanana@kernel.org wrote:
> > From: Filipe Manana <fdmanana@suse.com>
> >
> > If we exit early because the transaction that last used the root alread=
y
> > matches the current transaction, we leave the BTRFS_ROOT_IN_TRANS_SETUP
> > bit set in the root (which we just set right before the exit). While th=
is
> > does not cause any functional issue, it makes callers of
> > btrfs_record_root_in_trans() always lock fs_info->reloc_mutex and call
>
> I found "always" kind of confusing here. It's until one succeeds and
> clears the bit right? It kind of makes it sound like it leaks it
> forever.

Yes, I can reword the sentence to:

"While this does not cause any functional issue, it makes callers of
  btrfs_record_root_in_trans() lock fs_info->reloc_mutex and call
  record_root_in_trans() for nothing, causing unnecessary lock contention,
  until one of them clears the bit in record_root_in_trans()."

Thanks.

>
> > record_root_in_trans() for nothing, causing unnecessary lock contention=
.
> > One caller of btrfs_record_root_in_trans() is start_transaction(), used=
 to
> > start new transaction or joining an existing one, which is a hot path.
> >
> > So clear BTRFS_ROOT_IN_TRANS_SETUP on early exit.
> >
> > Assisted-by: LLM
> > Signed-off-by: Filipe Manana <fdmanana@suse.com>
> > ---
> >  fs/btrfs/transaction.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> > index ca114235bbe1..c1555621ae4e 100644
> > --- a/fs/btrfs/transaction.c
> > +++ b/fs/btrfs/transaction.c
> > @@ -432,6 +432,7 @@ static int record_root_in_trans(struct btrfs_trans_=
handle *trans,
> >               spin_lock(&fs_info->fs_roots_radix_lock);
> >               if (btrfs_get_root_last_trans(root) =3D=3D trans->transid=
 && !force) {
> >                       spin_unlock(&fs_info->fs_roots_radix_lock);
> > +                     clear_bit(BTRFS_ROOT_IN_TRANS_SETUP, &root->state=
);
> >                       return 0;
> >               }
> >               radix_tree_tag_set(&fs_info->fs_roots_radix,
> > --
> > 2.47.2
> >
