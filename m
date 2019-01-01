Return-Path: <SRS0=BfcD=PJ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9D56C43612
	for <linux-btrfs@archiver.kernel.org>; Tue,  1 Jan 2019 18:41:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 93870208E3
	for <linux-btrfs@archiver.kernel.org>; Tue,  1 Jan 2019 18:41:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=synesis-ru.20150623.gappssmtp.com header.i=@synesis-ru.20150623.gappssmtp.com header.b="jJNj4cdi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726792AbfAASkh (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 1 Jan 2019 13:40:37 -0500
Received: from mail-oi1-f195.google.com ([209.85.167.195]:44306 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbfAASkg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Jan 2019 13:40:36 -0500
Received: by mail-oi1-f195.google.com with SMTP id m6so23667460oig.11
        for <linux-btrfs@vger.kernel.org>; Tue, 01 Jan 2019 10:40:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=synesis-ru.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=JkWubpw4HNgHUoKmTCiydKoJnX6rYDwDkBbe2ph1YYE=;
        b=jJNj4cdi9lnZOzcZPY+DKYQ+rGJjF6KMIum1b+IwxrBbXarnsdCd06dgjprLcNMCup
         qfJ6e1B7uPRJjwDWR6rT9XY3XtvHUEy19MXrzK66ko/e+VSLwbtAXCCZm/JYg/Ip7CD9
         slackVCcdR3R7r+5/8JZ+TqhPOhUBGp9PZH/cJWHp+Xe3UoOmm+eQAVHBWRyrYQKEnCT
         k/0TsT+ivICAUVVhAl3I7qETFRaagfb5ETUl1DN0cWmu8Wlj0gl/MRAAxXUhi9lSrwdO
         s4rMQ5X1if3kllaUTfJaw+oDYaoxmVBE0b1YeKkXYp1lKANvfnmw0V754ZFLSvcLiEX/
         SSeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=JkWubpw4HNgHUoKmTCiydKoJnX6rYDwDkBbe2ph1YYE=;
        b=N4o97shyqgTWQ9hrH8FUT7rfzrnlevFNplLPvLO548PER5iUDZwoz+Q2UA0fGA2Pyc
         9xn4dIN1+26Uj/R455CSquMISzDKww3lT9AlJYTVWnBPfmFFCogu/0p7rQWYYBEG9e6T
         120gyG00FndPzE/vajqbWo8bH560Wu/XRiBNXN8b+6H5KbR1EpxAKxcP7liDjkQFavbI
         ecG/fg4QFy/5I0AuG8PRpVbVgwuPOZdORvyf7ntTX9yesf2D7qz+tcfqAyBgShscMuSF
         ATt6wXNnp5cSz4QYurCKSaDAU6jnleMk/sf0Rl8qOEXDQPoO3t2xfX0quyaIoCcYfLOA
         QEfA==
X-Gm-Message-State: AJcUukfztFwAeWosu8mAtjA546f9sDtqefYJkIP2k0AN6h/zLx89pHIX
        jGkNUuXDPHvG+SA6QK+cnGMiGdB2OqBMiA==
X-Google-Smtp-Source: ALg8bN6ss6IM6lJ4WBDayj3wbPGFzH8ZcFX0S0NKJ9IZV8tTyDlxN3p9kI5p8yhvB15Djoh8DOofJg==
X-Received: by 2002:aca:6c4:: with SMTP id 187mr21366202oig.290.1546368034365;
        Tue, 01 Jan 2019 10:40:34 -0800 (PST)
Received: from mail-oi1-f170.google.com (mail-oi1-f170.google.com. [209.85.167.170])
        by smtp.gmail.com with ESMTPSA id 96sm24657625ota.28.2019.01.01.10.40.32
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 01 Jan 2019 10:40:33 -0800 (PST)
Received: by mail-oi1-f170.google.com with SMTP id j21so23683727oii.8
        for <linux-btrfs@vger.kernel.org>; Tue, 01 Jan 2019 10:40:32 -0800 (PST)
X-Received: by 2002:aca:a805:: with SMTP id r5mr28370606oie.5.1546368032470;
 Tue, 01 Jan 2019 10:40:32 -0800 (PST)
MIME-Version: 1.0
References: <20181112115839.13969-1-timofey.titovets@synesis.ru> <a1854e9d-b3f3-f751-0364-118dc98da057@oracle.com>
In-Reply-To: <a1854e9d-b3f3-f751-0364-118dc98da057@oracle.com>
From:   Timofey Titovets <timofey.titovets@synesis.ru>
Date:   Tue, 1 Jan 2019 21:39:56 +0300
X-Gmail-Original-Message-ID: <CAGqmi765-YAPVrYjFrgV9ZVBSbtKdy42fM-6R=7Jrvvm1N+qVA@mail.gmail.com>
Message-ID: <CAGqmi765-YAPVrYjFrgV9ZVBSbtKdy42fM-6R=7Jrvvm1N+qVA@mail.gmail.com>
Subject: Re: [PATCH V7] Btrfs: enhance raid1/10 balance heuristic
To:     Anand Jain <anand.jain@oracle.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>,
        Nikolay Borisov <nborisov@suse.com>,
        David Sterba <dsterba@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Oh, just forgot to answer.

=D1=81=D1=80, 14 =D0=BD=D0=BE=D1=8F=D0=B1. 2018 =D0=B3. =D0=B2 04:27, Anand=
 Jain <anand.jain@oracle.com>:
>
> I am ok with the least used path approach here for the IO routing
> that's probably most reasonable in generic configurations. It can
> be default read mirror policy as well.
(thanks, that's pleasant for me %) )

> But as I mentioned. Not all configurations would agree to the heuristic
> approach here. For example: To make use of the SAN storage cache to
> get high IO throughput read must access based on the LBA, And this
> heuristic would make matter worst. There are plans to add more
> options read_mirror_policy [1].
>
> [1]
> https://patchwork.kernel.org/patch/10403299/

Can you please add some example of SAN stack were that
will make something 'worst'?

Moreover pid lb will also not play good for your example.

In SAN stack client always see one device with N path.
And no raid1 balancing can happen.
Maybe i didn't see all setups in world, but configure raid1
from 2 remote devices sounds very bad for me. Even drbd
only provide one logical device to end user.

> I would rather provide the configuration tune-ables to the use
> cases rather than fixing it using heuristic. Heuristic are good
> only with the known set of IO pattern for which heuristic is
> designed for.

Yep, but how compex that tunables must be?
i.e. we'll _always_ have cerner cases with bad behaviour.

(Also i prefer have sysfs tunables for that, instead of adding another
mount option.)

> This is not the first time you are assuming heuristic would provide
> the best possible performance in all use cases. As I mentioned
> in the compression heuristic there was no problem statement that
> you wanted to address using heuristic, theoretically the integrated
> compression heuristic would have to do a lot more computation when
> all the file-extents are compressible, its not convenience to me
> how compression heuristic would help on a desktop machine where
> most of the files are compressible.

Different tools exists, because we have different use cases.
If something adds more problems than it solves, it must be changed or
just purged.

Moreover, claim what on every desktop machine most of files are compressibl=
e
not true. I don't want to make long discussion about "spherical cow" in spa=
ce.
Just my example:
=E2=9E=9C  ~ sudo compsize /mnt
Processed 1198830 files, 1404382 regular extents (1481132 refs), 675870 inl=
ine.
Type       Perc     Disk Usage   Uncompressed Referenced
TOTAL       77%      240G         308G         285G
none       100%      202G         202G         176G
zlib        37%      1.8G         5.1G         5.6G
lzo         61%       64M         104M         126M
zstd        35%       36G         100G         103G

That's are system + home.
Home have different type of trash in it: videos, photos, source repos,
steam games, docker images.
DE Apps DB and other random things. Some data have NOCOW because i
just lack of "mental strength"
to finish fix of bad behaviour autodefrag with compressed data.
As you can see most volume of data are not compressed.

> IMO heuristic are good only for a set of types of workload. Giving
> an option to move away from it for the manual tuning is desired.
>
> Thanks, Anand

Any way, may be you right about demand in adding some control about
internal behaviour.
And we can combine our work to properly support that.
(I don't like over engineering, and just try avoid way where users will sta=
rt to
switch random flags to make things better.)
But before that we need some feedback from upstream. Bad or good.

Because currently core btrfs devs works on companies, which internal
use btrfs and/or
sell that to customers (suse?). I'm afraid what devs afraid to change inter=
nal
behaviour without 100% confident that it will be better.

Thanks!

> On 11/12/2018 07:58 PM, Timofey Titovets wrote:
> > From: Timofey Titovets <nefelim4ag@gmail.com>
> >
> > Currently btrfs raid1/10 balancer b=D0=B0lance requests to mirrors,
> > based on pid % num of mirrors.
> >
> > Make logic understood:
> >   - if one of underline devices are non rotational
> >   - Queue length to underline devices
> >
> > By default try use pid % num_mirrors guessing, but:
> >   - If one of mirrors are non rotational, repick optimal to it
> >   - If underline mirror have less queue length then optimal,
> >     repick to that mirror
> >
> > For avoid round-robin request balancing,
> > lets round down queue length:
> >   - By 8 for rotational devs
> >   - By 2 for all non rotational devs
> >
> > Some bench results from mail list
> > (Dmitrii Tcvetkov <demfloro@demfloro.ru>):
> > Benchmark summary (arithmetic mean of 3 runs):
> >           Mainline     Patch
> > ------------------------------------
> > RAID1  | 18.9 MiB/s | 26.5 MiB/s
> > RAID10 | 30.7 MiB/s | 30.7 MiB/s
> > -----------------------------------------------------------------------=
-
> > mainline, fio got lucky to read from first HDD (quite slow HDD):
> > Jobs: 1 (f=3D1): [r(1)][100.0%][r=3D8456KiB/s,w=3D0KiB/s][r=3D264,w=3D0=
 IOPS]
> >    read: IOPS=3D265, BW=3D8508KiB/s (8712kB/s)(499MiB/60070msec)
> >    lat (msec): min=3D2, max=3D825, avg=3D60.17, stdev=3D65.06
> > -----------------------------------------------------------------------=
-
> > mainline, fio got lucky to read from second HDD (much more modern):
> > Jobs: 1 (f=3D1): [r(1)][8.7%][r=3D11.9MiB/s,w=3D0KiB/s][r=3D380,w=3D0 I=
OPS]
> >    read: IOPS=3D378, BW=3D11.8MiB/s (12.4MB/s)(710MiB/60051msec)
> >    lat (usec): min=3D416, max=3D644286, avg=3D42312.74, stdev=3D48518.5=
6
> > -----------------------------------------------------------------------=
-
> > mainline, fio got lucky to read from an SSD:
> > Jobs: 1 (f=3D1): [r(1)][100.0%][r=3D436MiB/s,w=3D0KiB/s][r=3D13.9k,w=3D=
0 IOPS]
> >    read: IOPS=3D13.9k, BW=3D433MiB/s (454MB/s)(25.4GiB/60002msec)
> >    lat (usec): min=3D343, max=3D16319, avg=3D1152.52, stdev=3D245.36
> > -----------------------------------------------------------------------=
-
> > With the patch, 2 HDDs:
> > Jobs: 1 (f=3D1): [r(1)][100.0%][r=3D17.5MiB/s,w=3D0KiB/s][r=3D560,w=3D0=
 IOPS]
> >    read: IOPS=3D560, BW=3D17.5MiB/s (18.4MB/s)(1053MiB/60052msec)
> >    lat (usec): min=3D435, max=3D341037, avg=3D28511.64, stdev=3D30000.1=
4
> > -----------------------------------------------------------------------=
-
> > With the patch, HDD(old one)+SSD:
> > Jobs: 1 (f=3D1): [r(1)][100.0%][r=3D371MiB/s,w=3D0KiB/s][r=3D11.9k,w=3D=
0 IOPS]
> >    read: IOPS=3D11.6k, BW=3D361MiB/s (379MB/s)(21.2GiB/60084msec)
> >    lat  (usec): min=3D363, max=3D346752, avg=3D1381.73, stdev=3D6948.32
> >
> > Changes:
> >    v1 -> v2:
> >      - Use helper part_in_flight() from genhd.c
> >        to get queue length
> >      - Move guess code to guess_optimal()
> >      - Change balancer logic, try use pid % mirror by default
> >        Make balancing on spinning rust if one of underline devices
> >        are overloaded
> >    v2 -> v3:
> >      - Fix arg for RAID10 - use sub_stripes, instead of num_stripes
> >    v3 -> v4:
> >      - Rebased on latest misc-next
> >    v4 -> v5:
> >      - Rebased on latest misc-next
> >    v5 -> v6:
> >      - Fix spelling
> >      - Include bench results
> >    v6 -> v7:
> >      - Fixes based on Nikolay Borisov review:
> >        * Assume num =3D=3D 2
> >        * Remove "for" loop based on that assumption, where possible
> >        * No functional changes
> >
> > Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
> > Tested-by: Dmitrii Tcvetkov <demfloro@demfloro.ru>
> > Reviewed-by: Dmitrii Tcvetkov <demfloro@demfloro.ru>
> > ---
> >   block/genhd.c      |   1 +
> >   fs/btrfs/volumes.c | 100 ++++++++++++++++++++++++++++++++++++++++++++=
-
> >   2 files changed, 100 insertions(+), 1 deletion(-)
> >
> > diff --git a/block/genhd.c b/block/genhd.c
> > index be5bab20b2ab..939f0c6a2d79 100644
> > --- a/block/genhd.c
> > +++ b/block/genhd.c
> > @@ -81,6 +81,7 @@ void part_in_flight(struct request_queue *q, struct h=
d_struct *part,
> >                               atomic_read(&part->in_flight[1]);
> >       }
> >   }
> > +EXPORT_SYMBOL_GPL(part_in_flight);
> >
> >   void part_in_flight_rw(struct request_queue *q, struct hd_struct *par=
t,
> >                      unsigned int inflight[2])
> > diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> > index f4405e430da6..a6632cc2bfab 100644
> > --- a/fs/btrfs/volumes.c
> > +++ b/fs/btrfs/volumes.c
> > @@ -13,6 +13,7 @@
> >   #include <linux/raid/pq.h>
> >   #include <linux/semaphore.h>
> >   #include <linux/uuid.h>
> > +#include <linux/genhd.h>
> >   #include <linux/list_sort.h>
> >   #include "ctree.h"
> >   #include "extent_map.h"
> > @@ -5159,6 +5160,102 @@ int btrfs_is_parity_mirror(struct btrfs_fs_info=
 *fs_info, u64 logical, u64 len)
> >       return ret;
> >   }
> >
> > +/**
> > + * bdev_get_queue_len - return rounded down in flight queue length of =
bdev
> > + *
> > + * @bdev: target bdev
> > + * @round_down: round factor big for hdd and small for ssd, like 8 and=
 2
> > + */
> > +static int bdev_get_queue_len(struct block_device *bdev, int round_dow=
n)
> > +{
> > +     int sum;
> > +     struct hd_struct *bd_part =3D bdev->bd_part;
> > +     struct request_queue *rq =3D bdev_get_queue(bdev);
> > +     uint32_t inflight[2] =3D {0, 0};
> > +
> > +     part_in_flight(rq, bd_part, inflight);
> > +
> > +     sum =3D max_t(uint32_t, inflight[0], inflight[1]);
> > +
> > +     /*
> > +      * Try prevent switch for every sneeze
> > +      * By roundup output num by some value
> > +      */
> > +     return ALIGN_DOWN(sum, round_down);
> > +}
> > +
> > +/**
> > + * guess_optimal - return guessed optimal mirror
> > + *
> > + * Optimal expected to be pid % num_stripes
> > + *
> > + * That's generaly ok for spread load
> > + * Add some balancer based on queue length to device
> > + *
> > + * Basic ideas:
> > + *  - Sequential read generate low amount of request
> > + *    so if load of drives are equal, use pid % num_stripes balancing
> > + *  - For mixed rotate/non-rotate mirrors, pick non-rotate as optimal
> > + *    and repick if other dev have "significant" less queue length
> > + *  - Repick optimal if queue length of other mirror are less
> > + */
> > +static int guess_optimal(struct map_lookup *map, int num, int optimal)
> > +{
> > +     int i;
> > +     int round_down =3D 8;
> > +     /* Init for missing bdevs */
> > +     int qlen[2] =3D { INT_MAX, INT_MAX };
> > +     bool is_nonrot[2] =3D { false, false };
> > +     bool all_bdev_nonrot =3D true;
> > +     bool all_bdev_rotate =3D true;
> > +     struct block_device *bdev;
> > +
> > +     ASSERT(num =3D=3D 2);
> > +
> > +     /* Check accessible bdevs */
> > +     for (i =3D 0; i < 2; i++) {
> > +             bdev =3D map->stripes[i].dev->bdev;
> > +             if (bdev) {
> > +                     qlen[i] =3D 0;
> > +                     is_nonrot[i] =3D blk_queue_nonrot(bdev_get_queue(=
bdev));
> > +                     if (is_nonrot[i])
> > +                             all_bdev_rotate =3D false;
> > +                     else
> > +                             all_bdev_nonrot =3D false;
> > +             }
> > +     }
> > +
> > +     /*
> > +      * Don't bother with computation
> > +      * if only one of two bdevs are accessible
> > +      */
> > +     if (qlen[0] =3D=3D INT_MAX)
> > +             return 1;
> > +     if (qlen[1] =3D=3D INT_MAX)
> > +             return 0;
> > +
> > +     if (all_bdev_nonrot)
> > +             round_down =3D 2;
> > +
> > +     for (i =3D 0; i < 2; i++) {
> > +             bdev =3D map->stripes[i].dev->bdev;
> > +             qlen[i] =3D bdev_get_queue_len(bdev, round_down);
> > +     }
> > +
> > +     /* For mixed case, pick non rotational dev as optimal */
> > +     if (all_bdev_rotate =3D=3D all_bdev_nonrot) {
> > +             if (is_nonrot[0])
> > +                     optimal =3D 0;
> > +             else
> > +                     optimal =3D 1;
> > +     }
> > +
> > +     if (qlen[optimal] > qlen[(optimal + 1) % 2])
> > +             optimal =3D i;
> > +
> > +     return optimal;
> > +}
> > +
> >   static int find_live_mirror(struct btrfs_fs_info *fs_info,
> >                           struct map_lookup *map, int first,
> >                           int dev_replace_is_ongoing)
> > @@ -5177,7 +5274,8 @@ static int find_live_mirror(struct btrfs_fs_info =
*fs_info,
> >       else
> >               num_stripes =3D map->num_stripes;
> >
> > -     preferred_mirror =3D first + current->pid % num_stripes;
> > +     preferred_mirror =3D first + guess_optimal(map, num_stripes,
> > +                                              current->pid % num_strip=
es);
> >
> >       if (dev_replace_is_ongoing &&
> >           fs_info->dev_replace.cont_reading_from_srcdev_mode =3D=3D
> >
