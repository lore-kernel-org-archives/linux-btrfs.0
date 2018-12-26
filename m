Return-Path: <SRS0=cHbd=PD=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90805C43387
	for <linux-btrfs@archiver.kernel.org>; Wed, 26 Dec 2018 00:15:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 55AEC2171F
	for <linux-btrfs@archiver.kernel.org>; Wed, 26 Dec 2018 00:15:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VF1bsy6D"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725962AbeLZAPl (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 25 Dec 2018 19:15:41 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:43221 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725870AbeLZAPl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Dec 2018 19:15:41 -0500
Received: by mail-qk1-f195.google.com with SMTP id r71so8658207qkr.10
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Dec 2018 16:15:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=EsGAoq9uuKmfOKt5qcx3CnoTOlrL2F9fEgVo2XxY4MI=;
        b=VF1bsy6DApYsy1faOyoXpaHAdWXtsPXYClXZkkBJeO159PfeS6pOmFYiq8ipwcMrwv
         WX+yeVi6C4whOJ7rCpFfjPp23aROoJcwx16jkvyrY5Z+bcRKPjmbOFBWxrDY9NsCSnlA
         jlHrugFAa/5JOdMUfNqWH7wdLULcuMGyOhntQukhMy831hg1sMhBGdYcpEwhsP5P8of/
         NrU7Q5/PhK7gpRprHNeH2rfcHOlMOdq7VKoqk+Cga/G9Bc7ERCV9Lr5CaZYxlYx0skkB
         hTeKbGpj5NpKbzMppGfxx+iXwCYPgwvEuboSfU1iQ1lPYcLbsoCwZOtB2qFJh3syYuXT
         G7hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=EsGAoq9uuKmfOKt5qcx3CnoTOlrL2F9fEgVo2XxY4MI=;
        b=GTK0yKSqVjvG6/5JSJc0zXHO6HY95M5hNPNmYXVoOCSUsMjikbxdsKLIaNy3Y6V5xM
         DGxK4azf8Q9bPu2HgcpczZ7/AkqjFuinfgNZmOhDiKUGzTToWg6gXYrTcLd516bJfQQG
         b07gYjiERsa1RG63ydI7o2ceYvpo27khPirB8Qf9ZnyjUYrmSghgOJRL0UOGzpr2X/TX
         z+eCffPH8iVA9shVxcJVii7Yl0TMqRS8UZgarZmIgaVRydoQ/EhrVbl1jwuqPXbxMXpb
         O+nqNtCf/NooIsBY4Hlrj/gm9ZI9cAbJEBVtRvaCVXNPENkxH8WSuyTPD0iGuVDPJUeT
         Lh1A==
X-Gm-Message-State: AJcUukcAY19COz1oI3nsQQ9jRZlEPgTgYRyJTc4WUU4ND89s9v1Ivx1X
        J/vbWvxWPcwVE8Fw+jXSKK0sLVOnfqO0BiIrSts=
X-Google-Smtp-Source: ALg8bN42nXG6i+M0es8RHiFjaEIxaldqYixLavIv0OhZv1tzRlbv/ad0oZbECT+xg3KaOCGgKyi2wcEcvUx26FAbK1Y=
X-Received: by 2002:a37:a7c3:: with SMTP id q186mr16742130qke.244.1545783340472;
 Tue, 25 Dec 2018 16:15:40 -0800 (PST)
MIME-Version: 1.0
References: <66F8D435-4E51-4761-B6CF-BA96F4BC5986@wdc.com> <CANYdAbLNAxoAXcxuC+ugpdhsCpTbh0zVjY3T5rtOcpVufnmWRA@mail.gmail.com>
In-Reply-To: <CANYdAbLNAxoAXcxuC+ugpdhsCpTbh0zVjY3T5rtOcpVufnmWRA@mail.gmail.com>
From:   Liu Bo <obuil.liubo@gmail.com>
Date:   Tue, 25 Dec 2018 16:15:29 -0800
Message-ID: <CANQeFDAoG5R4j1hq7um997-5h1FrwWrbSMMc_+bZPs3+rZ_BvA@mail.gmail.com>
Subject: Re: [PATCH v2] btrfs: raid56: data corruption on a device removal
To:     Dmitriy Gorokh <dmitriy.gorokh@gmail.com>
Cc:     linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Dec 14, 2018 at 9:51 AM Dmitriy Gorokh <dmitriy.gorokh@gmail.com> w=
rote:
>
> RAID5 or RAID6 filesystem might get corrupted in the following scenario:
>
> 1. Create 4 disks RAID6 filesystem
> 2. Preallocate 16 10Gb files
> 3. Run fio: 'fio --name=3Dtestload --directory=3D./ --size=3D10G
> --numjobs=3D16 --bs=3D64k --iodepth=3D64 --rw=3Drandrw --verify=3Dsha256
> --time_based --runtime=3D3600=E2=80=99
> 4. After few minutes pull out two drives: 'echo 1 >
> /sys/block/sdc/device/delete ;  echo 1 > /sys/block/sdd/device/delete=E2=
=80=99
>
> About 5 of 10 times the test is run, it led to a silent data
> corruption of a random stripe, resulting in =E2=80=98IO Error=E2=80=99 an=
d =E2=80=98csum
> failed=E2=80=99 messages while trying to read the affected file. It usual=
ly
> affects only small portion of the files.
>
> It is possible that few bios which were being processed during the
> drives removal, contained non zero bio->bi_iter.bi_done field despite
> of EIO bi_status. bi_sector field was also increased from original one
> by that 'bi_done' value. Looks like this is a quite rare condition.
> Subsequently, in the raid_rmw_end_io handler that failed bio can be
> translated to a wrong stripe number and fail wrong rbio.
>

Looks good.

Reviewed-by: Liu Bo <bo.liu@linux.alibaba.com>

thanks,
liubo

> Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
> Signed-off-by: Dmitriy Gorokh <dmitriy.gorokh@wdc.com>
> ---
>  fs/btrfs/raid56.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
> index 3c8093757497..cd2038315feb 100644
> --- a/fs/btrfs/raid56.c
> +++ b/fs/btrfs/raid56.c
> @@ -1451,6 +1451,12 @@ static int find_bio_stripe(struct btrfs_raid_bio *=
rbio,
>   struct btrfs_bio_stripe *stripe;
>
>   physical <<=3D 9;
> + /*
> +  * Since the failed bio can return partial data, bi_sector might be
> +  * incremented by that value. We need to revert it back to the
> +  * state before the bio was submitted.
> +  */
> + physical -=3D bio->bi_iter.bi_done;
>
>   for (i =3D 0; i < rbio->bbio->num_stripes; i++) {
>   stripe =3D &rbio->bbio->stripes[i];
> --
> 2.17.0
