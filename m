Return-Path: <SRS0=W6bw=RH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10C4BC43381
	for <linux-btrfs@archiver.kernel.org>; Mon,  4 Mar 2019 13:10:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D28F22075B
	for <linux-btrfs@archiver.kernel.org>; Mon,  4 Mar 2019 13:10:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AD+ZGGNT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbfCDNKB (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 4 Mar 2019 08:10:01 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:36964 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726094AbfCDNKB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Mar 2019 08:10:01 -0500
Received: by mail-lf1-f66.google.com with SMTP id z196so3462741lff.4
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Mar 2019 05:09:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=oEmf6GlalJQuzcPWSKb1XfOW7QtfHkgnlyedADgUdHI=;
        b=AD+ZGGNTrOF7t8xK6v2BIaAbVVOx0xMOLTI3nUMFGs1pwtVFpoNnxB+saQ27/kekeL
         TfS+EYSuPpVATqhUMUR/nbj8qkNM+CRabs3UT85c0HkC0368GLHNY45Yg4TIgGlNADRb
         BSOdMoTIHBU38qzUAKaq53WvVyNzs/u6puGHqsugOhJpwbJO9DnGyKsjAtgEBiRyCk4g
         Z6+QIUCf8gtFrWj+NNMxVKurv4EH+WI6tLRIQDVocXRuPw4lYnbqrejbSzRrrZRsSpxl
         l+krp3xnQHmBqhc8x1Ch17no6V4QrAmeuOrEFrI5YHrisZ1zZDVa3DWOHzZfu4eXLLuQ
         zOmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=oEmf6GlalJQuzcPWSKb1XfOW7QtfHkgnlyedADgUdHI=;
        b=kZVD84y3ZzHf2BlMvRXMpex69OkC1Dw++DNVN+MH4TtXoLE5U11nTWMQhf0mw99qVw
         BgXbUsQJ0kD+Fq6m+DR8fl0xrC4J5ZosvTSXnd0ml8sS3ZBrlF86eNCMyL+YPGMYgKZP
         FFDATjrPYxzTImFoF+VpEi1pPz0typjvlI5zde43PKEN/T2V94LpVrpVp/9HksgWKxkj
         +G5R6+bDYGp0jBGefyUs8f38PaAcEXet81NQxvCJq2/YLs6kyIIfa+Ix7M091IcCMyGG
         C87P7qtDT3uEWTHeQEFnm1VvANmY7PyletXC4W2m4b6c9qzlneqC4uuJPnm3jF4msKP+
         4n8w==
X-Gm-Message-State: APjAAAVH4IZ+41U/xBvaXJp+21PqtCltlyB4urDFv9Fe0zJbfqI7yuGH
        xAwbuvzLMmYuroPVBOo4Qsg3jhwFU1WV42nmIhvt5oVC
X-Google-Smtp-Source: APXvYqw2Zi4tk90lcunVsiW7APOrMWrdAT/fBkWMfLCSpkZhw2txELCDSe40lGRmkwL03VgRxChGQnqBn3UtmCMyuEg=
X-Received: by 2002:a19:3f44:: with SMTP id m65mr9894994lfa.136.1551704998089;
 Mon, 04 Mar 2019 05:09:58 -0800 (PST)
MIME-Version: 1.0
From:   Richard Sanger <rsangerarj@gmail.com>
Date:   Tue, 5 Mar 2019 02:09:46 +1300
Message-ID: <CAN6QFNziqSoTyvJH3MKPQqUGGS+Wj-Om4W5ajL6QnK-E2OAj=w@mail.gmail.com>
Subject: Btrfs balance convert does not balance reads+dealloc evenly across
 disks, any proper fix?
To:     linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi,

Firstly, thanks for all the development on btrfs, I've been using it
on quite a few systems without any significant issues and have found
features like snapshots very useful.

I recently decided that raid6 was stable enough for data with raid1
metadata, and went about converting a raid1 array. But, I ran into a
curious problem when trying to convert existing raid1 data to raid6
with a six drive array.
From what I can tell balance doesn't select the raid1 chunks it
converts evenly from all drives. As a result, one pair of drives can
be converted first which causes the remaining drives to fill up with
raid6 data before having a chance to free any data raid1. When this
happens the 6-way raid6 can degrade to 5-way, 4-way, or 3-way raid6.

What is the selection strategy is btrfs balance using? e.g. starting
from the first chunk/drive, by file creation/modification, random?
And is there a reason for this behaviour and can it be changed?

As a solution, I'm now forcing an even balance by polling device usage
and adding the devid filter to the balance.
Here's that script for anyone else in a similar situation.
https://gist.github.com/rsanger/ad384c0fd3f4a003d3fbd9f097db8443

Below are the full details of what I've seen:
I'm running a recent kernel from stretch backports: Debian
4.19.16-1~bpo9+1 (2019-02-07) x86_64 GNU/Linux
I have a 6x8tb btrfs array, mounted at /media/Kilo.
It has been added to over time, originally starting with 1 or 2 drives.

Before conversion 'btrfs device usage' the drives looked something like this:
------------------------------------------------------------------
5 drives approx:
Device size: 7.28TiB
Data, RAID1: 6.9TiB
...
Unallocated: 500GiB

1 drive, replaced a 4TB with an 8TB before the conversion:
Device size: 7.28TiB
Data, RAID1: 3.8TiB
...
Unallocated: 3.8TiB
------------------------------------------------------------------

I started conversion using:
~ btrfs balance start -dconvert=raid6 /media/Kilo/

Nearing 50% completion I noticed the drive usage looked like this,
annotated with my interpretation:
------------------------------------------------------------------
/dev/sda1, ID: 1
   Device size:             7.28TiB
   Device slack:              0.00B
   Data,RAID1:              3.88TiB
   Data,RAID6:              1.76TiB <- 6-way
   Data,RAID6:              7.63GiB <- ?
   Data,RAID6:              1.62TiB <- 4-way
   Metadata,RAID1:         12.00GiB
   System,RAID1:           32.00MiB
   Unallocated:             2.92GiB

/dev/sdb1, ID: 6
   Device size:             7.28TiB
   Device slack:            3.00KiB
   Data,RAID1:              1.86TiB
   Data,RAID6:              1.76TiB <- 6-way
   Data,RAID6:              8.37GiB <- ??? 2-way
   Data,RAID6:              1.62TiB <- 4-way
   Data,RAID6:            320.00KiB <- 3-way
   Metadata,RAID1:          2.00GiB
   Unallocated:             2.02TiB

/dev/sdd1, ID: 2
   Device size:             7.28TiB
   Device slack:            3.50KiB
   Data,RAID1:              3.88TiB
   Data,RAID6:              1.76TiB <- 6-way
   Data,RAID6:              8.37GiB <- ??? 2-way
   Data,RAID6:              1.62TiB <- 4-way
   Data,RAID6:            320.00KiB <- 3-way
   Metadata,RAID1:          7.00GiB
   System,RAID1:           32.00MiB
   Unallocated:             5.18GiB

/dev/sdf1, ID: 3
   Device size:             7.28TiB
   Device slack:            3.50KiB
   Data,RAID1:              2.27TiB
   Data,RAID6:              1.76TiB <- 6-way
   Data,RAID6:              6.57GiB <- ?
   Data,RAID6:              1.62TiB <- 4-way
   Metadata,RAID1:          7.00GiB
   Unallocated:             1.62TiB

/dev/sdg1, ID: 5
   Device size:             7.28TiB
   Device slack:            3.50KiB
   Data,RAID1:              5.49TiB
   Data,RAID6:              1.76TiB <- 6-way
   Data,RAID6:             12.66GiB <- ?
   Data,RAID6:            320.00KiB <- 3-way
   Data,RAID6:              3.77GiB <- ?
   Metadata,RAID1:          6.00GiB
   Unallocated:             1.00MiB

/dev/sdh1, ID: 4
   Device size:             7.28TiB
   Device slack:            3.50KiB
   Data,RAID1:              5.49TiB
   Data,RAID6:              1.76TiB <- 6-way
   Data,RAID6:              7.12GiB <- ?
   Data,RAID6:              6.31GiB <- ?
   Metadata,RAID1:          8.00GiB
   Unallocated:             1.00MiB
------------------------------------------------------------------
From what I can see disks 4 and 5 have filled up, and balance convert
is creating 4-way raid6, not 6-way? At this point, I cancelled the
balance and started using the script mentioned earlier.

So now I'm in this situation is there anyway to filter to fix just the
non 6-way raid-6 or will I have to run a full balance again?

It would be great to see the balance operation improved in the future
to avoid such situations. I can lodge a proper bug report if that is
best.

Thanks,
Richard Sanger
