Return-Path: <SRS0=L0dM=NW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B60D1C43441
	for <linux-btrfs@archiver.kernel.org>; Sun, 11 Nov 2018 15:33:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 62BDE20872
	for <linux-btrfs@archiver.kernel.org>; Sun, 11 Nov 2018 15:33:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a78fEb+n"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 62BDE20872
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728635AbeKLBWc (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 11 Nov 2018 20:22:32 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:45180 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728498AbeKLBWc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 11 Nov 2018 20:22:32 -0500
Received: by mail-ot1-f67.google.com with SMTP id 32so5270519ota.12
        for <linux-btrfs@vger.kernel.org>; Sun, 11 Nov 2018 07:33:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=dyO2Y6W+fM7tPG2Zwk5cHun8T9EM77+Vj9ehjBwUt1g=;
        b=a78fEb+nn++VNiAnz5C5SGSE9MZhyjQ3avXax2R0Xn45z6Nr12pYazPolYLa7O3JK3
         YsXqXpBvtSVc7+0XcPfDQDL6R8jFE34Tm5ZN33YkZrzWFTdFWGKrL9Ugqohi4+XCavLJ
         edsK9G7fuzmABQwJYOWavWXCilrgNcijZmoglahVXZHhNpSpEoexaSopLKoy3PA6pREO
         P77CFNBN4xqwRNA63p/6tEYE5Y6w/Ug00yrK4w1psG3p9e5gUGkt6ND0IXz+gLFc1exx
         dZ43H7uiVsp6zPgC83KwVWOLexAkkpvdq6UoGGUOHAAn1CiNpIXaVf2pknUVo29Nyq1C
         ZlJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=dyO2Y6W+fM7tPG2Zwk5cHun8T9EM77+Vj9ehjBwUt1g=;
        b=kmE7Ns/Ij+BH1nULMfApb9snk1OrRmpBGI8QLbObzUMkrwSwHUVLE6xwqTLagl2EFs
         J4CEM34S4ift7hzvPAg3/+LqKILo+XWLYbUK/bEtZa/Y9DugPdEsNOSRU2j0j9fOCO08
         6KjfGKAU/wPqhnftMGcZ6kR4uzfxj3q+hG7WrlXTLmIur+f21KYDdCp+Y2RL+VBwDbUZ
         T2NR5EOF/2PqTfDAN0wA33ZkRsUjG+K/8fdJ/SwOzluGTB8rKcGyB/wpEjbWix7d/+MV
         0ETj0xMhuYgDOOQjXG7hsKiXL27VpEZ8SYj0vYXuQzYJDTAK7tqEFH204p1JiA2jt+R6
         KD9g==
X-Gm-Message-State: AGRZ1gLnDmZViDapYv9XSzd/KG7le9qOCG0ydL/c9Jbn8k9bNoR3OcWb
        lNE5Wgynyded3x2dTU/4qg1VHe11cNc6XLlm/qvCzA==
X-Google-Smtp-Source: AJdET5f0CB/naoOjcUTPlQBA2HOY+UgLH0mjmoPNlzxPGF9zbgYTc3DTLWjxUAQ/OiRTTpwCAkm2DA5rfZWmRScU1NY=
X-Received: by 2002:a9d:3208:: with SMTP id t8mr9781827otc.312.1541950419489;
 Sun, 11 Nov 2018 07:33:39 -0800 (PST)
MIME-Version: 1.0
References: <20180925183841.26936-1-nefelim4ag@gmail.com>
In-Reply-To: <20180925183841.26936-1-nefelim4ag@gmail.com>
From:   Timofey Titovets <nefelim4ag@gmail.com>
Date:   Sun, 11 Nov 2018 18:33:02 +0300
Message-ID: <CAGqmi77L7eYehXa=qHWPak1w5vgFwUjWgZ-iE2Oa=KMCeCrxDg@mail.gmail.com>
Subject: Re: [PATCH V6] Btrfs: enhance raid1/10 balance heuristic
To:     linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Gentle ping.
=D0=B2=D1=82, 25 =D1=81=D0=B5=D0=BD=D1=82. 2018 =D0=B3. =D0=B2 21:38, Timof=
ey Titovets <nefelim4ag@gmail.com>:
>
> Currently btrfs raid1/10 balancer b=D0=B0lance requests to mirrors,
> based on pid % num of mirrors.
>
> Make logic understood:
>  - if one of underline devices are non rotational
>  - Queue length to underline devices
>
> By default try use pid % num_mirrors guessing, but:
>  - If one of mirrors are non rotational, repick optimal to it
>  - If underline mirror have less queue length then optimal,
>    repick to that mirror
>
> For avoid round-robin request balancing,
> lets round down queue length:
>  - By 8 for rotational devs
>  - By 2 for all non rotational devs
>
> Some bench results from mail list
> (Dmitrii Tcvetkov <demfloro@demfloro.ru>):
> Benchmark summary (arithmetic mean of 3 runs):
>          Mainline     Patch
> ------------------------------------
> RAID1  | 18.9 MiB/s | 26.5 MiB/s
> RAID10 | 30.7 MiB/s | 30.7 MiB/s
> ------------------------------------------------------------------------
> mainline, fio got lucky to read from first HDD (quite slow HDD):
> Jobs: 1 (f=3D1): [r(1)][100.0%][r=3D8456KiB/s,w=3D0KiB/s][r=3D264,w=3D0 I=
OPS]
>   read: IOPS=3D265, BW=3D8508KiB/s (8712kB/s)(499MiB/60070msec)
>   lat (msec): min=3D2, max=3D825, avg=3D60.17, stdev=3D65.06
> ------------------------------------------------------------------------
> mainline, fio got lucky to read from second HDD (much more modern):
> Jobs: 1 (f=3D1): [r(1)][8.7%][r=3D11.9MiB/s,w=3D0KiB/s][r=3D380,w=3D0 IOP=
S]
>   read: IOPS=3D378, BW=3D11.8MiB/s (12.4MB/s)(710MiB/60051msec)
>   lat (usec): min=3D416, max=3D644286, avg=3D42312.74, stdev=3D48518.56
> ------------------------------------------------------------------------
> mainline, fio got lucky to read from an SSD:
> Jobs: 1 (f=3D1): [r(1)][100.0%][r=3D436MiB/s,w=3D0KiB/s][r=3D13.9k,w=3D0 =
IOPS]
>   read: IOPS=3D13.9k, BW=3D433MiB/s (454MB/s)(25.4GiB/60002msec)
>   lat (usec): min=3D343, max=3D16319, avg=3D1152.52, stdev=3D245.36
> ------------------------------------------------------------------------
> With the patch, 2 HDDs:
> Jobs: 1 (f=3D1): [r(1)][100.0%][r=3D17.5MiB/s,w=3D0KiB/s][r=3D560,w=3D0 I=
OPS]
>   read: IOPS=3D560, BW=3D17.5MiB/s (18.4MB/s)(1053MiB/60052msec)
>   lat (usec): min=3D435, max=3D341037, avg=3D28511.64, stdev=3D30000.14
> ------------------------------------------------------------------------
> With the patch, HDD(old one)+SSD:
> Jobs: 1 (f=3D1): [r(1)][100.0%][r=3D371MiB/s,w=3D0KiB/s][r=3D11.9k,w=3D0 =
IOPS]
>   read: IOPS=3D11.6k, BW=3D361MiB/s (379MB/s)(21.2GiB/60084msec)
>   lat  (usec): min=3D363, max=3D346752, avg=3D1381.73, stdev=3D6948.32
>
> Changes:
>   v1 -> v2:
>     - Use helper part_in_flight() from genhd.c
>       to get queue length
>     - Move guess code to guess_optimal()
>     - Change balancer logic, try use pid % mirror by default
>       Make balancing on spinning rust if one of underline devices
>       are overloaded
>   v2 -> v3:
>     - Fix arg for RAID10 - use sub_stripes, instead of num_stripes
>   v3 -> v4:
>     - Rebased on latest misc-next
>   v4 -> v5:
>     - Rebased on latest misc-next
>   v5 -> v6:
>     - Fix spelling
>     - Include bench results
>
> Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
> Tested-by: Dmitrii Tcvetkov <demfloro@demfloro.ru>
> Reviewed-by: Dmitrii Tcvetkov <demfloro@demfloro.ru>
> ---
>  block/genhd.c      |   1 +
>  fs/btrfs/volumes.c | 111 ++++++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 110 insertions(+), 2 deletions(-)
>
> diff --git a/block/genhd.c b/block/genhd.c
> index 9656f9e9f99e..5ea5acc88d3c 100644
> --- a/block/genhd.c
> +++ b/block/genhd.c
> @@ -81,6 +81,7 @@ void part_in_flight(struct request_queue *q, struct hd_=
struct *part,
>                                 atomic_read(&part->in_flight[1]);
>         }
>  }
> +EXPORT_SYMBOL_GPL(part_in_flight);
>
>  void part_in_flight_rw(struct request_queue *q, struct hd_struct *part,
>                        unsigned int inflight[2])
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index c95af358b71f..fa7dd6ac087f 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -16,6 +16,7 @@
>  #include <linux/raid/pq.h>
>  #include <linux/semaphore.h>
>  #include <linux/uuid.h>
> +#include <linux/genhd.h>
>  #include <linux/list_sort.h>
>  #include "ctree.h"
>  #include "extent_map.h"
> @@ -5201,6 +5202,111 @@ int btrfs_is_parity_mirror(struct btrfs_fs_info *=
fs_info, u64 logical, u64 len)
>         return ret;
>  }
>
> +/**
> + * bdev_get_queue_len - return rounded down in flight queue length of bd=
ev
> + *
> + * @bdev: target bdev
> + * @round_down: round factor big for hdd and small for ssd, like 8 and 2
> + */
> +static int bdev_get_queue_len(struct block_device *bdev, int round_down)
> +{
> +       int sum;
> +       struct hd_struct *bd_part =3D bdev->bd_part;
> +       struct request_queue *rq =3D bdev_get_queue(bdev);
> +       uint32_t inflight[2] =3D {0, 0};
> +
> +       part_in_flight(rq, bd_part, inflight);
> +
> +       sum =3D max_t(uint32_t, inflight[0], inflight[1]);
> +
> +       /*
> +        * Try prevent switch for every sneeze
> +        * By roundup output num by some value
> +        */
> +       return ALIGN_DOWN(sum, round_down);
> +}
> +
> +/**
> + * guess_optimal - return guessed optimal mirror
> + *
> + * Optimal expected to be pid % num_stripes
> + *
> + * That's generaly ok for spread load
> + * Add some balancer based on queue length to device
> + *
> + * Basic ideas:
> + *  - Sequential read generate low amount of request
> + *    so if load of drives are equal, use pid % num_stripes balancing
> + *  - For mixed rotate/non-rotate mirrors, pick non-rotate as optimal
> + *    and repick if other dev have "significant" less queue length
> + *  - Repick optimal if queue length of other mirror are less
> + */
> +static int guess_optimal(struct map_lookup *map, int num, int optimal)
> +{
> +       int i;
> +       int round_down =3D 8;
> +       int qlen[num];
> +       bool is_nonrot[num];
> +       bool all_bdev_nonrot =3D true;
> +       bool all_bdev_rotate =3D true;
> +       struct block_device *bdev;
> +
> +       if (num =3D=3D 1)
> +               return optimal;
> +
> +       /* Check accessible bdevs */
> +       for (i =3D 0; i < num; i++) {
> +               /* Init for missing bdevs */
> +               is_nonrot[i] =3D false;
> +               qlen[i] =3D INT_MAX;
> +               bdev =3D map->stripes[i].dev->bdev;
> +               if (bdev) {
> +                       qlen[i] =3D 0;
> +                       is_nonrot[i] =3D blk_queue_nonrot(bdev_get_queue(=
bdev));
> +                       if (is_nonrot[i])
> +                               all_bdev_rotate =3D false;
> +                       else
> +                               all_bdev_nonrot =3D false;
> +               }
> +       }
> +
> +       /*
> +        * Don't bother with computation
> +        * if only one of two bdevs are accessible
> +        */
> +       if (num =3D=3D 2 && qlen[0] !=3D qlen[1]) {
> +               if (qlen[0] < qlen[1])
> +                       return 0;
> +               else
> +                       return 1;
> +       }
> +
> +       if (all_bdev_nonrot)
> +               round_down =3D 2;
> +
> +       for (i =3D 0; i < num; i++) {
> +               if (qlen[i])
> +                       continue;
> +               bdev =3D map->stripes[i].dev->bdev;
> +               qlen[i] =3D bdev_get_queue_len(bdev, round_down);
> +       }
> +
> +       /* For mixed case, pick non rotational dev as optimal */
> +       if (all_bdev_rotate =3D=3D all_bdev_nonrot) {
> +               for (i =3D 0; i < num; i++) {
> +                       if (is_nonrot[i])
> +                               optimal =3D i;
> +               }
> +       }
> +
> +       for (i =3D 0; i < num; i++) {
> +               if (qlen[optimal] > qlen[i])
> +                       optimal =3D i;
> +       }
> +
> +       return optimal;
> +}
> +
>  static int find_live_mirror(struct btrfs_fs_info *fs_info,
>                             struct map_lookup *map, int first,
>                             int dev_replace_is_ongoing)
> @@ -5219,7 +5325,8 @@ static int find_live_mirror(struct btrfs_fs_info *f=
s_info,
>         else
>                 num_stripes =3D map->num_stripes;
>
> -       preferred_mirror =3D first + current->pid % num_stripes;
> +       preferred_mirror =3D first + guess_optimal(map, num_stripes,
> +                                                current->pid % num_strip=
es);
>
>         if (dev_replace_is_ongoing &&
>             fs_info->dev_replace.cont_reading_from_srcdev_mode =3D=3D
> --
> 2.17.0



--=20
Have a nice day,
Timofey.
