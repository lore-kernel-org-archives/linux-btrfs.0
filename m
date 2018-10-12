Return-Path: <SRS0=eG6O=MY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CC6AC43441
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 08:51:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0F35920868
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 08:51:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Fir0JByl"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0F35920868
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727996AbeJLQWZ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Oct 2018 12:22:25 -0400
Received: from mail-vk1-f193.google.com ([209.85.221.193]:46688 "EHLO
        mail-vk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726071AbeJLQWZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Oct 2018 12:22:25 -0400
Received: by mail-vk1-f193.google.com with SMTP id h186so1354892vkh.13
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2018 01:51:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=9xp1KTzo/cNRfYnPtixoLnBcnfceskbzkKQje71ZewU=;
        b=Fir0JByl6HdRLUGs9S0lsCYWoAhzlPxJrAsDFP0ifyA0VtdqYOb+/7o6fGvv5R81UW
         SlVidgs9tTKvbsZ9D5vlAuEX2F3ds5ZEFlIqGLnP9GOBDBhhlu9cCPg+pD0OV4qkXdQK
         VZDWTDbVwwWZKk38MmErSmofoBGg9isCg9J6J/nf1JiyUIrX6CQ7KFfcBXRoqjFG3Qzq
         btXnj/2f2tGqpOjxh+goYZnE0eL08s8ZG3kMsUGYfBjo3Qai/bUC4tf/aKPB9RDh2BOW
         su+xMok0A2UtLNTz5iOJl0nvwjosypHVq66HHhe9zQ0YNmsLVSV+wVB6DbG5kPyUS0nb
         RueA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=9xp1KTzo/cNRfYnPtixoLnBcnfceskbzkKQje71ZewU=;
        b=QO/EBtFrym0TK0WGMfP2ijxtnCqHg0M+YGawfpb8m8HUds0FZyPNFjulrDH8MugaV0
         omvDecYdFACx2ZvTQeqP/aOO1ijCgS6/uvD4MjOQIIzjulDa77nZZykpaGOVP/e5XFSX
         vgw7lKA87h96407QkvOYI54XYskWH60geJIaluS9W+3NrFm+Pymy8oXfye2BGzblI+IP
         F2VRgibkoB4AlPjEQA+xd/+hfVKDZNnT5cCu3gpbeQ2q8186BOb55vnSm9S4HZwBTo8z
         LYQEY7rPjCehhu5rcnSKUnSL6gOKCej+FJz81+6w7an6rid2kJDGJshxeSGESiI6WWbN
         69/g==
X-Gm-Message-State: ABuFfoh7C5OxTklALUiZFLiBHvKNEFoNVHx54jSza6YdnGybNtxd6ZTS
        9mgzI9NL6Lqu31x06ck1o5iL3pqLnzyqMCUmGUE=
X-Google-Smtp-Source: ACcGV63LIjuCBMre92odPL+ZATXTW7v4qhDs1fe9qT3ZLH7XSyc1dcvJ/5u1UtL6huvDjGA2baNkyraa4hF7dzNl+Lg=
X-Received: by 2002:a1f:b995:: with SMTP id j143-v6mr2108556vkf.88.1539334260351;
 Fri, 12 Oct 2018 01:51:00 -0700 (PDT)
MIME-Version: 1.0
References: <20181011195431.3441-1-josef@toxicpanda.com> <20181011195431.3441-20-josef@toxicpanda.com>
In-Reply-To: <20181011195431.3441-20-josef@toxicpanda.com>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Fri, 12 Oct 2018 09:50:49 +0100
Message-ID: <CAL3q7H68LY_wji0NTtCDR1-GSPKEJdcynuW77wW3-HknFbsS=Q@mail.gmail.com>
Subject: Re: [PATCH 19/42] btrfs: set max_extent_size properly
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     kernel-team@fb.com, linux-btrfs <linux-btrfs@vger.kernel.org>,
        Josef Bacik <jbacik@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Oct 11, 2018 at 8:57 PM Josef Bacik <josef@toxicpanda.com> wrote:
>
> From: Josef Bacik <jbacik@fb.com>
>
> We can't use entry->bytes if our entry is a bitmap entry, we need to use
> entry->max_extent_size in that case.  Fix up all the logic to make this
> consistent.
>
> Signed-off-by: Josef Bacik <jbacik@fb.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>

> ---
>  fs/btrfs/free-space-cache.c | 29 +++++++++++++++++++----------
>  1 file changed, 19 insertions(+), 10 deletions(-)
>
> diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
> index e077ad3b4549..2e96ee7da3ec 100644
> --- a/fs/btrfs/free-space-cache.c
> +++ b/fs/btrfs/free-space-cache.c
> @@ -1770,6 +1770,18 @@ static int search_bitmap(struct btrfs_free_space_c=
tl *ctl,
>         return -1;
>  }
>
> +static void set_max_extent_size(struct btrfs_free_space *entry,
> +                               u64 *max_extent_size)
> +{
> +       if (entry->bitmap) {
> +               if (entry->max_extent_size > *max_extent_size)
> +                       *max_extent_size =3D entry->max_extent_size;
> +       } else {
> +               if (entry->bytes > *max_extent_size)
> +                       *max_extent_size =3D entry->bytes;
> +       }
> +}
> +
>  /* Cache the size of the max extent in bytes */
>  static struct btrfs_free_space *
>  find_free_space(struct btrfs_free_space_ctl *ctl, u64 *offset, u64 *byte=
s,
> @@ -1791,8 +1803,7 @@ find_free_space(struct btrfs_free_space_ctl *ctl, u=
64 *offset, u64 *bytes,
>         for (node =3D &entry->offset_index; node; node =3D rb_next(node))=
 {
>                 entry =3D rb_entry(node, struct btrfs_free_space, offset_=
index);
>                 if (entry->bytes < *bytes) {
> -                       if (entry->bytes > *max_extent_size)
> -                               *max_extent_size =3D entry->bytes;
> +                       set_max_extent_size(entry, max_extent_size);
>                         continue;
>                 }
>
> @@ -1810,8 +1821,7 @@ find_free_space(struct btrfs_free_space_ctl *ctl, u=
64 *offset, u64 *bytes,
>                 }
>
>                 if (entry->bytes < *bytes + align_off) {
> -                       if (entry->bytes > *max_extent_size)
> -                               *max_extent_size =3D entry->bytes;
> +                       set_max_extent_size(entry, max_extent_size);
>                         continue;
>                 }
>
> @@ -1823,8 +1833,8 @@ find_free_space(struct btrfs_free_space_ctl *ctl, u=
64 *offset, u64 *bytes,
>                                 *offset =3D tmp;
>                                 *bytes =3D size;
>                                 return entry;
> -                       } else if (size > *max_extent_size) {
> -                               *max_extent_size =3D size;
> +                       } else {
> +                               set_max_extent_size(entry, max_extent_siz=
e);
>                         }
>                         continue;
>                 }
> @@ -2684,8 +2694,7 @@ static u64 btrfs_alloc_from_bitmap(struct btrfs_blo=
ck_group_cache *block_group,
>
>         err =3D search_bitmap(ctl, entry, &search_start, &search_bytes, t=
rue);
>         if (err) {
> -               if (search_bytes > *max_extent_size)
> -                       *max_extent_size =3D search_bytes;
> +               set_max_extent_size(entry, max_extent_size);
>                 return 0;
>         }
>
> @@ -2722,8 +2731,8 @@ u64 btrfs_alloc_from_cluster(struct btrfs_block_gro=
up_cache *block_group,
>
>         entry =3D rb_entry(node, struct btrfs_free_space, offset_index);
>         while (1) {
> -               if (entry->bytes < bytes && entry->bytes > *max_extent_si=
ze)
> -                       *max_extent_size =3D entry->bytes;
> +               if (entry->bytes < bytes)
> +                       set_max_extent_size(entry, max_extent_size);
>
>                 if (entry->bytes < bytes ||
>                     (!entry->bitmap && entry->offset < min_start)) {
> --
> 2.14.3
>


--=20
Filipe David Manana,

=E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you're=
 right.=E2=80=9D
