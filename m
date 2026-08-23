Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54BC01E1024
	for <linux-btrfs@vger.kernel.org>; Sun, 23 Aug 2026 00:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787445485; cv=pass; b=tBclUvlt5LP+vcyZjRueosAmGGlDC+Do3zWufeOIgbN/WRV3wQvVVSPIocrvB+oQODNg69WS+zmpo7gapbdynY5GKtoen+gkTEAjJ3RSId4MVfZ97miIFswSzQPklZXMsjpF3rgGIp1b9u4Npi46sD+Wv4zNAtXyQuk7FEi7y7I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787445485; c=relaxed/simple;
	bh=JBLQh5N2JqtCbNqUnw4vH9T8xdbdDw7YNEB7rNZIXig=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ayIJDKngBaZhjpjxIm3XnnT5VfrutvmZ/2VlW1xcMnFAQKhVP2dS/WV/0q0EKbUnY/gC3W9+BYMQVmsHQQ+e6VR6sQwuGlP/hp+Qo+EZxA09lITjcYE/1/leG0VfPgiQCPILtqmazF/ijLcYB7El6VW1redYe/xe69Qc/Cq0FRE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BjPe0O35; arc=pass smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BjPe0O35"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4956869750eso13889845e9.2
        for <linux-btrfs@vger.kernel.org>; Sat, 22 Aug 2026 17:38:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787445482; cv=none;
        d=google.com; s=arc-20260327;
        b=avx8P1RQv+tJBbMqfojqhjziCbbBMSSknohE6AquaOyqDjoJclQhfIKNpfg/B3ulnG
         sHJlclhEKVPln5veZZWPiWT1gnBcFs5z0bts2poHBCVqK6z8sEaYjoG0qTbDccrjIrjX
         otqsGvcymeYiLhSy7LfAsU96E82+Murw3i4mvG6dNtimY3XHB5bq1ZWL4QQaL5/bqujm
         2GFn2WhxlmA+8rmM2j+NIgYyskDDadPc30zmEAiMsh7OnmFFGpIBjx13hvrdcqrIEsUc
         WGmxjcTXbIItfhxZrUZdCop/ggy/5JcQQnxEX9XY9d9hlusb3H371gR5VO7eJN7AQgys
         5VuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=OGeHAqpGUuvBGBgMKhUFeMVTVPCA3AChfi6BFsL1Dkc=;
        fh=artV68kqAU4HLOwuRFxgWjAkLRX+mbdlhRtr8nBbZvM=;
        b=kQayeA8Lx9oPLcSJTDW49j5NSSTj6dK9rNuMFmLq4JbhNj8/HtjKOM89gPLuXdrU5l
         MD3gGgoAZcarBk4/ZKUp9dSYWv7282Rfj0Qw8ahEyz/IoFsJ2pWc6i7Us8F9CFHDEbo7
         35pBh1dgsdyiSiDu1xHC6cQp/KAORbhZRy0HjuoL9R826PsQuUlvYVQD/BJk5KWve5Ps
         MyL+uvlU71RetlHOdhboQXBMCbE+M63rdOfe6WaaP3YwgdB/qT07DVvHF4fAyKxZYXWz
         5pUUx0e3VargsBmtCnrkdupPMzonHP9i+9cevzItZ4z+oKrvBPKGYcRRwSluJ49n9pK/
         g7bA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787445482; x=1788050282; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=OGeHAqpGUuvBGBgMKhUFeMVTVPCA3AChfi6BFsL1Dkc=;
        b=BjPe0O35PSBwaknOYN3jgZhnXKp5L3Rycn4vSS/5wO+hEqilaROeIdgtIpQzQF+cq2
         B/a0jAqpa8qnZ2IZMmPXdU3E540xCFHkkQ82pX5arfDUaf+aDQTA1S6xmdReAYxrE4ZX
         RHf9lCg1LaA0J/cwvNBlXkUUmOYau3thVxlpmzJIq+PXsRlom6mejCxma41D9ASKI3Vk
         TYvUiTKAciqtdrNpB0YCnk2aAgovPOleZQfHvCOgmBwLmNHr8HctKq88awxeoSeFtEcJ
         VEfSEvbTf9B1gFYWrY1tO5ILAC0OC+SkaY+SxmB2rydTVSqi0A/FUxiAmrTjyBcW3TNC
         nALA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787445482; x=1788050282;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OGeHAqpGUuvBGBgMKhUFeMVTVPCA3AChfi6BFsL1Dkc=;
        b=peV0JVebJAGctylwtTQEwFJbNlE2lY1cIKSfoPjzXwc6krwvqo/RyPCHHaRz1CWRqs
         o9KlqI/kJRin1x8AVIGpYwXHGrnOwyWyCx0ATQZeGQZ7fZSbS1QRLmU7lv6xhAAk751Q
         XRP2gC/L8p7b/hTEE3gPv93F7FDl895XVIVRs48UeUbi1+WjpydReSiMKPAyKaxl5jaC
         eC5vYGOJD0tjsfBpQ//e8bT6gQRWs5s+PWQ/pQt1GJHZrFed2S9VfXXQcUo5eyfTryLD
         p5ZgGgVDzeYhdFK06OtmWAYuIr68AkrWDgXLONZpiCAj8VXSR2TTCSYDYhODRhVFMf3y
         tfhQ==
X-Forwarded-Encrypted: i=1; AHgh+RrztzJRteWLQ2ApOZzjMJtNkmAicngSqoMTotlJ07kA19Ny5a020TTLnjeMt1vsUYRQFe6Kyh7g7Y33jQ==@vger.kernel.org
X-Gm-Message-State: AFuF++kQXqirAybRUFkSpnhtXqmHeoW5x82Hwd2gWjfFtnqnN8y/wTlF
	Dfn4fgsNvwr7r8TyRM5N7oTXXmTgXa19yACA91aATi0pYyIdg5F5Qx0joSp5UeUJ9vgtWLimIj5
	ZI8aTofkvhjaYAFwyUjsX/SDFK6TA1Q==
X-Gm-Gg: AR+sD12SqsSLjg6s/i5P+nk8ED9h3Eb/FRdh4M9tSK8jhjadjA73Yo9yUMNcKEK8E7o
	KZlNGLXrv8RihC3NMEBoaqpFlHJHCaFaJ94ZrCzrJqvCE8tbBZQdS0NGeGL48TfPT0MGtoRzRC7
	XFk8n4PQeEK3MeV05KaKqTKALMdsbmBppak/SpKK+4auvL8C0BI/wEi7YVVdsPsSw8ROF1K3Eno
	UQQXrOcjTLXVWICurq1K4jvrs3ynAQKCN3xRKndMNsbM1ccleHQEC4YtcpPAEJOMSX+SucuMEDU
	O5QP4tbMaceT2pFR4s39RhXSmUYfj3I5N2g05NeQ26rS
X-Received: by 2002:a05:600c:64c6:b0:498:1595:be7b with SMTP id
 5b1f17b1804b1-499c19c707amr75730385e9.4.1787445482152; Sat, 22 Aug 2026
 17:38:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260822-btrfs-zstd-max-level-reclaim-v1-1-0eb13c127480@gmail.com>
 <f7fc4ab6-7a52-48fb-9dd2-fee5aac11727@suse.com>
In-Reply-To: <f7fc4ab6-7a52-48fb-9dd2-fee5aac11727@suse.com>
From: old king <fy15309206903@gmail.com>
Date: Sun, 23 Aug 2026 09:37:51 +0900
X-Gm-Features: AcwNN1WvlN4_puK7L6f1ApDBrzu4vKlnUBYQRCh2ua3WSsgWbYhwqifO4c8DOFs
Message-ID: <CAMMY3OWRjgXor-HtYP7kKAtODsjR1H7bQD9ow0bhgndu_706Hw@mail.gmail.com>
Subject: Re: [PATCH] btrfs: zstd: keep the last max level workspace out of reclaim
To: Qu Wenruo <wqu@suse.com>
Cc: David Sterba <dsterba@suse.com>, Nick Terrell <terrelln@fb.com>, Chris Mason <clm@fb.com>, 
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thanks Sashiko for the report and Qu for the reply.

I will confirm and test this report.

FAN YE

On Sun, Aug 23, 2026 at 7:10=E2=80=AFAM Qu Wenruo <wqu@suse.com> wrote:
>
>
>
> =E5=9C=A8 2026/8/22 22:15, FAN YE via B4 Relay =E5=86=99=E9=81=93:
> > From: FAN YE <fy15309206903@gmail.com>
> >
> > zstd_put_workspace() makes the "hide this workspace from the reclaim ti=
mer"
> > decision only when the workspace is returned at its own level.
> > Decompression always asks for level 0, so a max level workspace borrowe=
d by
> > a read skips the whole block and the test for being the last max level
> > workspace is never made: it goes back to idle_ws[] still linked on the =
lru.
> > A read borrowing one while a write holds the other is enough to leave e=
very
> > max level workspace on the lru, where the reclaim timer can then free t=
hem
> > all and clear the level bit.
> >
> > Once no max level workspace is left, zstd_put_workspace() never reaches
> > cond_wake_up() and a task sleeping in zstd_get_workspace() after a fail=
ed
> > allocation has no possible waker.  Make the decision on every put of a =
max
> > level workspace and unlink it from the lru when it is the last one;
> > list_del_init() in zstd_find_workspace() keeps the entry usable for tha=
t.
> > The test also no longer hides workspaces of other levels, which it did
> > whenever no max level workspace happened to be idle.
> >
> > Fixes: 3f93aef535c8 ("btrfs: add zstd compression level support")
> > Assisted-by: Claude:claude-opus-5
> > Signed-off-by: FAN YE <fy15309206903@gmail.com>
>
> Sashiko found a high level problem:
>
> https://sashiko.dev/#/patchset/20260822-btrfs-zstd-max-level-reclaim-v1-1=
-0eb13c127480%40gmail.com
> > ---
> > Reproduced under QEMU/TCG.  Both arms are the same kernel with the recl=
aim
> > interval shortened to 100ms and a module param picking the old or the n=
ew
> > zstd_put_workspace(); the workload is compress-force=3Dzstd:15, three r=
ounds
> > of four concurrent writers followed by drop_caches, four readers and tw=
o
> > writers.  "unprotected" counts puts of a max level workspace after whic=
h
> > nothing left in idle_ws[] is off the lru; "borrowed" counts a max level
> > workspace taken and returned by a lower level request, the path this pa=
tch
> > changes.
> >
> >                      borrowed   unprotected   timer cleared the level b=
it
> >    current code       245/339       118/216                          1/=
0
> >    this patch         300/379           0/0                          0/=
0
> >
> > borrowed is of the same order in both arms, so the zeroes are not "the =
code
> > was never reached".  The last column needs the reclaim timer to tick in=
side
> > the window, so it is a coincidence rather than the criterion.
> >
> > Compile-tested (W=3D1, x86_64 defconfig + CONFIG_BTRFS_FS=3Dy).  Indepe=
ndent of
> > and applies without my lost wakeup fix for zstd_get_workspace(),
> > 20260821-btrfs-zstd-lost-wakeup-v1-1-84f358d4ea67@gmail.com.
> > ---
> >   fs/btrfs/zstd.c | 25 ++++++++++++-------------
> >   1 file changed, 12 insertions(+), 13 deletions(-)
> >
> > diff --git a/fs/btrfs/zstd.c b/fs/btrfs/zstd.c
> > index 86919293fd54..8abc4e456f32 100644
> > --- a/fs/btrfs/zstd.c
> > +++ b/fs/btrfs/zstd.c
> > @@ -260,7 +260,7 @@ static struct list_head *zstd_find_workspace(struct=
 btrfs_fs_info *fs_info, int
> >                       /* keep its place if it's a lower level using thi=
s */
> >                       workspace->req_level =3D level;
> >                       if (clip_level(level) =3D=3D workspace->level)
> > -                             list_del(&workspace->lru_list);
> > +                             list_del_init(&workspace->lru_list);
> >                       if (list_empty(&zwsm->idle_ws[i]))
> >                               clear_bit(i, &zwsm->active_map);
> >                       spin_unlock_bh(&zwsm->lock);
> > @@ -335,18 +335,17 @@ void zstd_put_workspace(struct btrfs_fs_info *fs_=
info, struct list_head *ws)
> >       ASSERT(zwsm);
> >       spin_lock_bh(&zwsm->lock);
> >
> > -     /* A node is only taken off the lru if we are the corresponding l=
evel */
> > -     if (clip_level(workspace->req_level) =3D=3D workspace->level) {
> > -             /* Hide a max level workspace from reclaim */
> > -             if (list_empty(&zwsm->idle_ws[ZSTD_BTRFS_MAX_LEVEL - 1]))=
 {
> > -                     INIT_LIST_HEAD(&workspace->lru_list);
> > -             } else {
> > -                     workspace->last_used =3D jiffies;
> > -                     list_add(&workspace->lru_list, &zwsm->lru_list);
> > -                     if (!timer_pending(&zwsm->timer))
> > -                             mod_timer(&zwsm->timer,
> > -                                       jiffies + ZSTD_BTRFS_RECLAIM_JI=
FFIES);
> > -             }
> > +     /* Forward progress depends on always keeping one max level works=
pace */
> > +     if (workspace->level =3D=3D clip_level(ZSTD_BTRFS_MAX_LEVEL) &&
> > +         list_empty(&zwsm->idle_ws[ZSTD_BTRFS_MAX_LEVEL - 1])) {
> > +             list_del_init(&workspace->lru_list);
> > +     } else if (clip_level(workspace->req_level) =3D=3D workspace->lev=
el) {
> > +             /* A node is only taken off the lru if we are the corresp=
onding level */
> > +             workspace->last_used =3D jiffies;
> > +             list_add(&workspace->lru_list, &zwsm->lru_list);
> > +             if (!timer_pending(&zwsm->timer))
> > +                     mod_timer(&zwsm->timer,
> > +                               jiffies + ZSTD_BTRFS_RECLAIM_JIFFIES);
> >       }
> >
> >       set_bit(workspace->level, &zwsm->active_map);
> >
> > ---
> > base-commit: 26260251022fbc2f248a3d747a9b2b961b18d2d8
> > change-id: 20260822-btrfs-zstd-max-level-reclaim-5ab59a71f83e
> >
> > Best regards,
> > --
> > FAN YE <fy15309206903@gmail.com>
> >
> >
> >
>
