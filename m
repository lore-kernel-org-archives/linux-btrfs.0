Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9723840DFAC
	for <linux-btrfs@vger.kernel.org>; Sat, 21 Mar 2026 02:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.215.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774060765; cv=pass; b=iihIfZp/w1JskJHOoC33M/AV+4karA0QV2zeHtywgiicEAjW+ilKugonJybw1x2rIlIZ/TczSORPoGOIyyPtSN34rU/by7bnZ6t7HclDBbkEAn6Q45E/XiC9cAs8gIXfAmVi1ql2Uy9oGkQQblI2Gnqa25MV6zmEs7Werb2VpJc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774060765; c=relaxed/simple;
	bh=h8wRABmku7vmWLk9W0v6nvIq0V8KxfmrjMr3IXd8xik=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cwAFmok75foAgu9ABMXRFVSOsnlZlSaGKpd++fSwzBeDUNpB3S8aJi6z7tH+qqsddTbGsJCSPAZBoUbWIWVpUNqdJVaWSpzUZa8v784U2TwnjXmgEa2hMY6YBbbZQ5/d9HTZ9LDrDfWFlEVgtPcIIMRuLKv0yLJMuKZ7jrUa00w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=quora.org; spf=pass smtp.mailfrom=quora.org; dkim=pass (1024-bit key) header.d=quora.org header.i=@quora.org header.b=kXis5axc; arc=pass smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=quora.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quora.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=quora.org header.i=@quora.org header.b="kXis5axc"
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-c70fb6aa323so1011006a12.3
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Mar 2026 19:39:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774060764; cv=none;
        d=google.com; s=arc-20240605;
        b=D2yRbfq4TIsRKDLwh884iAypxF7J+XHx3bVFQNqfzqEPwtD02sxPaOKUwadZn48OkW
         6Gg19Jka+Xb90fXfvphq9PvgLg+oWmmytTZf1F6LkAmxVXuiJ5kCMRi+3SDT8LO6JLZq
         0WzWUuMky7dNpdPUK9GJsxL4jb1ZQ26w9WSxrX8rM73raC4b/GTl+khIDGpsnpZhl6pE
         prCA0VGekoBGr4cJYjiiCiJeVLf0s4q1dUeMGCeOTcYybHGKE/XVuvx5fTP6vzumG5z8
         cMAzMUIvczjmaPbbH5u48z9AbZVjZ40buQwDQ/BWrNtmKz9yHu1z+EU1EbGC5Xgp4U2M
         5ncg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=21AM6BcbMczt3+4amahvEyye/dz515mZTW0V9mW6ofo=;
        fh=xecBpNkH9DU/eZGjwpffFeWir9jP2aXceExiNWgqlXI=;
        b=YPpM8jDzRBDDlKkMIT1jqatc9khn/HcF4JOc419eJHJ3jFKy6fx0hJ+esrsuW/l711
         dCmaMHEfEBpXrQykFTGhwi6J2WFpT6/4bNpcyk+CNp7FpcaGlXwmaKnebuHDNZa2BZ0f
         Uj/L9JiXnTwtryShCRCH/naP2Asx/QR76IU3Sn115Md/nZ65g6eGuOTKk9ME/W4pFgZf
         yKzGfMeQpwP7gZAJ6cn+O3IVNLJC+brgHiJo8GiDhg6HuyAoXhwJnp10nvH8jgbVtNvf
         00LQviaAWz8brnfbrWxWlpEcsFKPPuqZb9wh2oTIyn3wN5QTEM3EeD268BMV5HCdgYAI
         1bCg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=quora.org; s=google; t=1774060764; x=1774665564; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=21AM6BcbMczt3+4amahvEyye/dz515mZTW0V9mW6ofo=;
        b=kXis5axcWYtUeVkqmaJwbab9Rf526hFtv70CgvVV14LANMhMHRN7ifHNRj7WUJ43n3
         uuo9mHru3YP/wVrf6LuSd6ntJZC3lDiUSPX8PwJ4TxqAJleif6eiJvUEMfp3/RwJkrAw
         323ckhkSQi1yzfS5R/fE71nVkNSSb9QGnZ6xw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774060764; x=1774665564;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=21AM6BcbMczt3+4amahvEyye/dz515mZTW0V9mW6ofo=;
        b=pbC7xQm4LJE0bpQSRhi5xiJs9fiFG2OtgW9xl7SM+JSYuN0HBEBJBDSgSLtUyIrUH8
         O7UuoJKn1WQWPYz9Qlpp15a4cuPy7Y/fs2QXU29phzbBKdrU3LW9fSjW22/Yj56EDpTa
         C8khW1UogLVLiQX56Y9IByvaFs6knHGvLWJycSVDJ33PRDBOLAhCbM0IkjHkI7gKyUmC
         Hq5eHzBhsjPUqWIurKcDZtI2CDzar+MbxKgVolnCxXa7ubG+RFiJPizF+PPOb2K9AAq1
         vbYzMB5LvC43gvPrK/bCKUDMa5MuIXwXsvJk9C4zqNYYSE3h2wuL1faV9OeeTzyomYPF
         Gu7A==
X-Gm-Message-State: AOJu0YyR8WR2vsH8ey5Ojwd0l7Ac/naXtDul/eXCDZXn5DVu+LjQi+YL
	E+iQhIGR3gk3fx2UA+J70a5YhrAR2UiVVB3C1ytS8J88lDS3/Dp3ZzG3TpH7JZqmAXX7U095uRm
	CM5zsCqfAIbPA+qg4HEfAClbDOgfcvBuxOLYbT+/bdA==
X-Gm-Gg: ATEYQzz4qeIhHAO8PG6lKJoYC6co7ysmjDHQOrk5sV9IAw0EwpEofDCYk7q7mt1Xx3h
	XN6wCr6wbvXQYNLIOcRKK3Iq6WQ4yizgbobNr18kGftDFSy8u5mHC/NQtGkgB7W2AoY3YDvq9+S
	UqKvk4O4AMljigjK+MCJjvIAvhnnx0cTdfx1Dsl6weRpxD9E/JY9mQ4+U164D54c6P3zXdP6HIm
	hcjQXeRRFxOtsLzue4ATAn7EelXTY8vEDLfB7nVJ67vYFkPcf2EoluWNTF8hougPeiWgsC5fgmx
	40x3206JXetpRO4eZL9ZIGqA30hBvc+s4svYjIagXdMT5GyI/bIFHoe/WaJ0St4W3bSNKoV5kSC
	hYZtuiQn7m+jn7NpFb1MKmMgTKsbIGPowM2amJnRZSOERQkqtKRYDxaEmcN6bc7BEDY3fY6sGII
	2EQk0CTddsIXPKsbcxfiVQDqKCGhJR1H9YX3A3SIi/687+/hqQHDZvNOwGfqM=
X-Received: by 2002:a05:6a20:a10c:b0:39b:9644:6ea4 with SMTP id
 adf61e73a8af0-39bce9f0e99mr5003944637.16.1774060763918; Fri, 20 Mar 2026
 19:39:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260319053413.14771-1-daniel@quora.org> <4d6f78d3-f274-43e1-adc8-c4fff4f85e24@suse.com>
 <20260320220137.GI5735@twin.jikos.cz> <33164dbf-ab81-4611-ba1a-e6e187bfaf51@suse.com>
In-Reply-To: <33164dbf-ab81-4611-ba1a-e6e187bfaf51@suse.com>
From: Daniel J Blueman <daniel@quora.org>
Date: Sat, 21 Mar 2026 10:39:12 +0800
X-Gm-Features: AaiRm528JPtDzHWipTPW6Mw9aCNltTF0aEcNSPvWR3cYE1rypX_9IxO3jsXI3p4
Message-ID: <CAMVG2stDsMQigJ4NhFH6+K+DO+OLGFHZzCk3S0KX6B9yBOU9cg@mail.gmail.com>
Subject: Re: [PATCH] btrfs: Fix BTRFS arm64 tagged KASAN false-positive
To: Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>, dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kasan-dev@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 21 Mar 2026 at 06:27, Qu Wenruo <wqu@suse.com> wrote:
> =E5=9C=A8 2026/3/21 08:31, David Sterba =E5=86=99=E9=81=93:
> > On Thu, Mar 19, 2026 at 07:26:34PM +1030, Qu Wenruo wrote:
> >>
> >>
> >> =E5=9C=A8 2026/3/19 16:04, Daniel J Blueman =E5=86=99=E9=81=93:
> >>> When booting Linux 7.0-rc4 on a Qualcomm Snapdragon X1 with KASAN
> >>> software tagging with a BTRFS filesystem, we see:
> >>>
> >>> BUG: KASAN: invalid-access in xxh64_update (lib/xxhash.c:143 lib/xxha=
sh.c:283)
> >>> Read of size 8 at addr 7bff000804fe1000 by task kworker/u49:2/138
> >>> Pointer tag: [7b], memory tag: [b2]
> >>>
> >>> CPU: 0 UID: 0 PID: 138 Comm: kworker/u49:2 Not tainted 7.0.0-rc4+ #34=
 PREEMPTLAZY
> >>> Hardware name: LENOVO 83ED/LNVNB161216, BIOS NHCN60WW 09/11/2025
> >>> Workqueue: btrfs-endio-meta simple_end_io_work
> >>> Call trace:
> >>> show_stack (arch/arm64/kernel/stacktrace.c:501) (C)
> >>> dump_stack_lvl (lib/dump_stack.c:122)
> >>> print_report (mm/kasan/report.c:379 mm/kasan/report.c:482)
> >>> kasan_report (mm/kasan/report.c:597)
> >>> kasan_check_range (mm/kasan/sw_tags.c:86 (discriminator 1))
> >>> __hwasan_loadN_noabort (mm/kasan/sw_tags.c:158)
> >>> xxh64_update (lib/xxhash.c:143 lib/xxhash.c:283)
> >>> btrfs_csum_update (fs/btrfs/fs.c:106)
> >>> csum_tree_block (fs/btrfs/disk-io.c:103 (discriminator 3))
> >>> btrfs_validate_extent_buffer (fs/btrfs/disk-io.c:389)
> >>> end_bbio_meta_read (fs/btrfs/extent_io.c:3853 (discriminator 1))
> >>> btrfs_bio_end_io (fs/btrfs/bio.c:152)
> >>> simple_end_io_work (fs/btrfs/bio.c:388)
> >>> process_one_work (./arch/arm64/include/asm/jump_label.h:36 ./include/=
trace/events/workqueue.h:110 kernel/workqueue.c:3281)
> >>> worker_thread (kernel/workqueue.c:3353 (discriminator 2) kernel/workq=
ueue.c:3440 (discriminator 2))
> >>> kthread (kernel/kthread.c:436)
> >>> ret_from_fork (arch/arm64/kernel/entry.S:861)
> >>>
> >>> The buggy address belongs to the physical page:
> >>> page: refcount:3 mapcount:0 mapping:f1ff00080055dee8 index:0x2467bd p=
fn:0x884fe1
> >>> memcg:51ff000800e68ec0 aops:btree_aops ino:1
> >>> flags: 0x9340000000004000(private|zone=3D2|kasantag=3D0x4d)
> >>> raw: 9340000000004000 0000000000000000 dead000000000122 f1ff00080055d=
ee8
> >>> raw: 00000000002467bd 43ff00081d0cc6f0 00000003ffffffff 51ff000800e68=
ec0
> >>> page dumped because: kasan: bad access detected
> >>>
> >>> Memory state around the buggy address:
> >>> ffff000804fe0e00: 7b 7b 7b 7b 7b 7b 7b 7b 7b 7b 7b 7b 7b 7b 7b 7b
> >>> ffff000804fe0f00: 7b 7b 7b 7b 7b 7b 7b 7b 7b 7b 7b 7b 7b 7b 7b 7b
> >>>> ffff000804fe1000: b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2
> >>> ^
> >>> ffff000804fe1100: b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2
> >>> ffff000804fe1200: b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2
> >>>
> >>> This occurs as contiguous pages may have different KASAN tags in the =
upper address
> >>> bits, leading to a tag mismatch if linear addressing is used.
> >>>
> >>> Fix this by treating them as discontiguous.
> >>>
> >>> Signed-off-by: Daniel J Blueman <daniel@quora.org>
> >>> Fixes: 397239ed6a6c ("btrfs: allow extent buffer helpers to skip cros=
s-page handling")
> >>>
> >>> ---
> >>>    fs/btrfs/extent_io.c | 12 ++++++++++--
> >>>    1 file changed, 10 insertions(+), 2 deletions(-)
> >>>
> >>> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> >>> index 5f97a3d2a8d7..e2b241fb6c0e 100644
> >>> --- a/fs/btrfs/extent_io.c
> >>> +++ b/fs/btrfs/extent_io.c
> >>> @@ -3517,8 +3517,16 @@ struct extent_buffer *alloc_extent_buffer(stru=
ct btrfs_fs_info *fs_info,
> >>>              * At this stage, either we allocated a large folio, thus=
 @i
> >>>              * would only be 0, or we fall back to per-page allocatio=
n.
> >>>              */
> >>> -           if (i && folio_page(eb->folios[i - 1], 0) + 1 !=3D folio_=
page(folio, 0))
> >>> -                   page_contig =3D false;
> >>> +           if (i > 0) {
> >>> +                   struct page *prev =3D folio_page(eb->folios[i - 1=
], 0);
> >>> +                   struct page *curr =3D folio_page(folio, 0);
> >>> +
> >>> +                   /*
> >>> +                    * Contiguous pages may have different tags; can'=
t be treated as contiguous
> >>> +                    */
> >>> +                   if (curr !=3D prev + 1 || page_kasan_tag(curr) !=
=3D page_kasan_tag(prev))
> >>> +                           page_contig =3D false;
> >>
> >> I am not a fan of this solution.
> >>
> >> Although it doesn't affect end users who don't have KASAN soft tag
> >> enabled, I don't get what we can really get from the different tags.
> >>
> >> I mean all those pages are already contig in physical addresses, why w=
e
> >> can not access the range in one go?
> >>
> >> Maybe it will be better to set all pages with the same random tag if
> >> page_contig is true?
> >
> > I don't know if there's an interface how to change the tags but adding
> > one condition that enables a sanitizer to work on some platform does no=
t
> > sound like a terrible thing. The contiguous pages on our side is an
> > optimization so it's a special case, I'd rather adapt to the sanitizers
> > than to let people ignore a warning or have to read a warning that that
> > one is harmless.
>
> There is the interface, page_kasan_tag_set()/page_kasan_tag_reset(), and
> is already utilized inside MM.
>
> And the deeper problem is, if this is a false alert, shouldn't we fix
> the sanitizer?
>
> Especially in this case I didn't see any problem accessing properly
> allocated and physically adjacent pages.

I agree with this, however BTRFS doesn't have multi-page folios, thus
these pages are from different allocations; from extent_io.c:

/* For now, we should only have single-page folios for btree inode. */
ASSERT(folio_nr_pages(existing_folio) =3D=3D 1);

The goal of the differing KASAN tags per allocation is to catch UAF
and other lifecycle issues. If preferred, I can test and submit a
patch to set the same KASAN tag in alloc_eb_folio_array()? This would
be removed when multi-page folio support is added and is along the
lines of:

for (int i =3D 1; i < num_pages; i++)
  page_kasan_tag_set(page_array[i], page_kasan_tag(page_array[0]));

It will be less minimal as won't implicitly be compiled out as per my
previous patch.

Thanks,
  Dan
--=20
Daniel J Blueman
