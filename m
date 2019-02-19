Return-Path: <SRS0=T+sm=Q2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E944EC43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Feb 2019 07:33:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B5022217D9
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Feb 2019 07:33:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eVW5YuXZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725797AbfBSHdi (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 19 Feb 2019 02:33:38 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:34338 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725775AbfBSHdi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Feb 2019 02:33:38 -0500
Received: by mail-lf1-f66.google.com with SMTP id u21so14181980lfu.1
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Feb 2019 23:33:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Klc4W1sWbcTfK2fcxELcJwaCwG7R3+bmWeED+HA3KcY=;
        b=eVW5YuXZZ0oIC1EVAklg7nJZyjoCUbWMIGf2n8mB4D6hy8M6gbQ8vgeWlJze4b4VPc
         9i5E28sTFlDUwQ5Gw/kv+RiSFuF6XSFoRmsXZy7h6B1rUc8C/Cbv1bR2V52XDEJQVQBq
         ID4c25egjRnDPDtjRDobey261cIwcBgo6ZNQnJcfJJ5978RnrXUGTfzpz76weIwYWrAg
         WUPAu3qFHQCDqRfJCTJLp7t1bNFjdxdZqbHi5jQtku0KKx9P7yOzAxgWq2IMTnH91a4M
         HYFCa3a9SI7iIFMi9BjIuJPMlQCObxGFsZDadtKt1hBq3L6QZtS3N9Eyqi4MVByrHzAw
         g4fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Klc4W1sWbcTfK2fcxELcJwaCwG7R3+bmWeED+HA3KcY=;
        b=dH+ci69rVUKwRIzCzoYRGhWaUbTmJVPcbaT8881JZ2ZT0uuh/IcKWB4XyV1lXaq8U/
         cCtyDf1JOmuGG5Jg9wBI1SSWob8C9HLbH9GvxmscPYMIo6sHEwYu2BkC1P0Q+g8eXW9N
         wNXhk0ID16xA+2ZDKp3zdYBROeLFvLj+lxVcTXiEiES2EjXbulMjKMjBjiCXnuDiDfE2
         8R1f1Qu8GGFFdKEIIT7TPDUrFu6XXL3DWmkyFS9T+ougGGeUWNNg7oxQD1P7EHY1gK9Z
         n0HTPm6sLBJYNEOnHDUoAMZfpIzRlPNqRoWWEZTmUqvcdUhWONLdUiXNybgDuAyrv9sf
         eWUg==
X-Gm-Message-State: AHQUAuYQ+QSK+4cZbh2LBbND9hHvNWx7mHjG97xlXRClwxhyknly5JWG
        T6CIlA+ipuvcEQ2kEze6+G4UNQLskMxJ2d39L3Q=
X-Google-Smtp-Source: AHgI3Ia1K/dVCw7mfoLh5BJWhd8RkqJyT5/eTsqFErKTMVgBu9GNQ0G9wHlZXxt8uGsBSa6VTyQ8DfiX8qBd4awFJOQ=
X-Received: by 2002:a19:f204:: with SMTP id q4mr16878164lfh.133.1550561615686;
 Mon, 18 Feb 2019 23:33:35 -0800 (PST)
MIME-Version: 1.0
References: <210585b9-99e9-1548-f2b1-66445ab179bb@suse.de> <20190218102837.15219-1-jthumshirn@suse.de>
In-Reply-To: <20190218102837.15219-1-jthumshirn@suse.de>
From:   Peter Becker <floyd.net@gmail.com>
Date:   Tue, 19 Feb 2019 08:33:23 +0100
Message-ID: <CAEtw4r2tHWRNSOP6OiAfBHPdGpwZsckL9KOd3vkogDAk+gsz8Q@mail.gmail.com>
Subject: Re: [PATCH v2.1] btrfs: ensure that a DUP or RAID1 block group has
 exactly two stripes
To:     Johannes Thumshirn <jthumshirn@suse.de>
Cc:     David Sterba <dsterba@suse.com>,
        Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>,
        Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        Hans van Kranenburg <Hans.van.Kranenburg@mendix.com>,
        Liu Bo <obuil.liubo@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

I would prefer "< 2" .. in both cases (RAID1 and DUP) because this
allow us to implement N-Copy RAID1 in the future.

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 03f223aa7194..9024eee889b9 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6791,10 +6791,10 @@ static int btrfs_check_chunk_valid(struct
btrfs_fs_info *fs_info,
        }

        if ((type & BTRFS_BLOCK_GROUP_RAID10 && sub_stripes != 2) ||
-           (type & BTRFS_BLOCK_GROUP_RAID1 && num_stripes < 1) ||
+           (type & BTRFS_BLOCK_GROUP_RAID1 && num_stripes < 2) ||

            (type & BTRFS_BLOCK_GROUP_RAID5 && num_stripes < 2) ||
            (type & BTRFS_BLOCK_GROUP_RAID6 && num_stripes < 3) ||
-           (type & BTRFS_BLOCK_GROUP_DUP && num_stripes > 2) ||
+           (type & BTRFS_BLOCK_GROUP_DUP && num_stripes < 2) ||

            ((type & BTRFS_BLOCK_GROUP_PROFILE_MASK) == 0 &&
             num_stripes != 1)) {
                btrfs_err(fs_info,

Am Mo., 18. Feb. 2019 um 12:24 Uhr schrieb Johannes Thumshirn
<jthumshirn@suse.de>:
>
> We recently had a customer issue with a corrupted filesystem. When trying
> to mount this image btrfs panicked with a division by zero in
> calc_stripe_length().
>
> The corrupt chunk had a 'num_stripes' value of 1. calc_stripe_length()
> takes this value and divides it by the number of copies the RAID profile is
> expected to have to calculate the amount of data stripes. As a DUP profile
> is expected to have 2 copies this division resulted in 1/2 = 0. Later then
> the 'data_stripes' variable is used as a divisor in the stripe length
> calculation which results in a division by 0 and thus a kernel panic.
>
> When encountering a filesystem with a DUP block group and a 'num_stripes'
> value unequal to 2, refuse mounting as the image is corrupted and will lead
> to unexpected behaviour.
>
> Code inspection showed a RAID1 block group has the same issues.
>
> Fixes: e06cd3dd7cea ("Btrfs: add validadtion checks for chunk loading")
> Cc: Liu Bo <obuil.liubo@gmail.com>
> Reviewed-by: Qu Wenruo <wqu@suse.com>
> Reviewed-by: Nikolay Borisov <nborisov@suse.com>
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> ---
> Changes to v2:
> - Really use 2 stripes not 1 (Hans)
> Changes to v1:
> - Also add the check for RAID1 (Hans)
> ---
>  fs/btrfs/volumes.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 03f223aa7194..9024eee889b9 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -6791,10 +6791,10 @@ static int btrfs_check_chunk_valid(struct btrfs_fs_info *fs_info,
>         }
>
>         if ((type & BTRFS_BLOCK_GROUP_RAID10 && sub_stripes != 2) ||
> -           (type & BTRFS_BLOCK_GROUP_RAID1 && num_stripes < 1) ||
> +           (type & BTRFS_BLOCK_GROUP_RAID1 && num_stripes != 2) ||
>             (type & BTRFS_BLOCK_GROUP_RAID5 && num_stripes < 2) ||
>             (type & BTRFS_BLOCK_GROUP_RAID6 && num_stripes < 3) ||
> -           (type & BTRFS_BLOCK_GROUP_DUP && num_stripes > 2) ||
> +           (type & BTRFS_BLOCK_GROUP_DUP && num_stripes != 2) ||
>             ((type & BTRFS_BLOCK_GROUP_PROFILE_MASK) == 0 &&
>              num_stripes != 1)) {
>                 btrfs_err(fs_info,
> --
> 2.16.4
>
