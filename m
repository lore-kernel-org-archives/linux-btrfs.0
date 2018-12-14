Return-Path: <SRS0=3GAk=OX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9614DC43387
	for <linux-btrfs@archiver.kernel.org>; Fri, 14 Dec 2018 17:49:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9EEDB206BA
	for <linux-btrfs@archiver.kernel.org>; Fri, 14 Dec 2018 17:49:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hSPB55lN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729862AbeLNRtE (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 14 Dec 2018 12:49:04 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:34058 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729341AbeLNRtE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Dec 2018 12:49:04 -0500
Received: by mail-lf1-f66.google.com with SMTP id p6so4894718lfc.1
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Dec 2018 09:49:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=mlLsFB8/WiyHfcOebJtoCtDCfTRq7Wth5b7Z9REjr7o=;
        b=hSPB55lNNRQtWFGwgacYYF84J7Kjwexb1kBsoNFuczHv8/84R48hYmsZMiPl+wxhU9
         ar5YA+4PhzDxG/sGzCbbOiemKpPzd5wHdIULZN0Kmcxe0oj2rD6k51S5y5MHmrOkwy7T
         hCDTNOqh8PRvzhcktG0hBRKph78Yd4AUl6Jqn9YKGvxW2TNlhD5PLo4+8bWh2mxFek/7
         ZRaml1T6FkG4/Bb0jOgYZldEfPHa5GtWApPk/kCzkicSAR6J52ETT81OsPJxWOwbx8TC
         qMfL6fHLjZK50c8IWLa2A9BnkIFBvpkUzYZTNo5Ex8j9U75ovTcqtfuGWAsN0wLIzeV2
         36Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=mlLsFB8/WiyHfcOebJtoCtDCfTRq7Wth5b7Z9REjr7o=;
        b=ktrvopl3wmYamh8YwczP0SweZm+D+OSjNyhiYGEgVTwIWqkf6+nizwyTFg4ns1jAUS
         071gMWpif3qOQbPfvu0WGdjmVqIcvd2TSe0oO/cy45IjhLIA1Gc9EGbkfJYR0oGB7Z0L
         RxpKVYDkR+brrjDdHuMXNUmRrvaCv9HNFkV5b8YXUtnHKdj6lAzbbLryMaK2u+7DtJpo
         fdhTzAm35Gj9T6RAuTdN5JItbducarjIrb0XY92N0oKEtj5WoGBPFxOhUu/xoUyLMRNy
         Smr0p8+5y39rSiraJJiASGzTP0KPiD3SYSiqZwm8Ro2X6DME2JI3IW9Qub8VzWQqzapO
         d6gg==
X-Gm-Message-State: AA+aEWYu9Xfk29oELChlD6MRjSzNBUjKLxsbAH/RDT4i0yqCLmv7iQMO
        QluNze5NqIZZa/LHqj/u/T+YgYhzVHT8MwUXWETSECZu
X-Google-Smtp-Source: AFSGD/UjDz633n+ikMcv3YroXNWtgfoUimcAO1UpkPimD0G/Qwu1ogo6GM5+3PcEUumRK4XnEJKTdvoQAeDv4Zccdek=
X-Received: by 2002:a19:f20:: with SMTP id e32mr2470970lfi.51.1544809741709;
 Fri, 14 Dec 2018 09:49:01 -0800 (PST)
MIME-Version: 1.0
References: <66F8D435-4E51-4761-B6CF-BA96F4BC5986@wdc.com>
In-Reply-To: <66F8D435-4E51-4761-B6CF-BA96F4BC5986@wdc.com>
From:   Dmitriy Gorokh <dmitriy.gorokh@gmail.com>
Date:   Fri, 14 Dec 2018 20:48:50 +0300
Message-ID: <CANYdAbLNAxoAXcxuC+ugpdhsCpTbh0zVjY3T5rtOcpVufnmWRA@mail.gmail.com>
Subject: [PATCH v2] btrfs: raid56: data corruption on a device removal
To:     linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

RAID5 or RAID6 filesystem might get corrupted in the following scenario:

1. Create 4 disks RAID6 filesystem
2. Preallocate 16 10Gb files
3. Run fio: 'fio --name=3Dtestload --directory=3D./ --size=3D10G
--numjobs=3D16 --bs=3D64k --iodepth=3D64 --rw=3Drandrw --verify=3Dsha256
--time_based --runtime=3D3600=E2=80=99
4. After few minutes pull out two drives: 'echo 1 >
/sys/block/sdc/device/delete ;  echo 1 > /sys/block/sdd/device/delete=E2=80=
=99

About 5 of 10 times the test is run, it led to a silent data
corruption of a random stripe, resulting in =E2=80=98IO Error=E2=80=99 and =
=E2=80=98csum
failed=E2=80=99 messages while trying to read the affected file. It usually
affects only small portion of the files.

It is possible that few bios which were being processed during the
drives removal, contained non zero bio->bi_iter.bi_done field despite
of EIO bi_status. bi_sector field was also increased from original one
by that 'bi_done' value. Looks like this is a quite rare condition.
Subsequently, in the raid_rmw_end_io handler that failed bio can be
translated to a wrong stripe number and fail wrong rbio.

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Signed-off-by: Dmitriy Gorokh <dmitriy.gorokh@wdc.com>
---
 fs/btrfs/raid56.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 3c8093757497..cd2038315feb 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -1451,6 +1451,12 @@ static int find_bio_stripe(struct btrfs_raid_bio *rb=
io,
  struct btrfs_bio_stripe *stripe;

  physical <<=3D 9;
+ /*
+  * Since the failed bio can return partial data, bi_sector might be
+  * incremented by that value. We need to revert it back to the
+  * state before the bio was submitted.
+  */
+ physical -=3D bio->bi_iter.bi_done;

  for (i =3D 0; i < rbio->bbio->num_stripes; i++) {
  stripe =3D &rbio->bbio->stripes[i];
--=20
2.17.0
