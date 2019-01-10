Return-Path: <SRS0=+rOy=PS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9F27C43387
	for <linux-btrfs@archiver.kernel.org>; Thu, 10 Jan 2019 18:58:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8D31D20675
	for <linux-btrfs@archiver.kernel.org>; Thu, 10 Jan 2019 18:58:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LyRoMJ8u"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728636AbfAJS63 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 10 Jan 2019 13:58:29 -0500
Received: from mail-lj1-f171.google.com ([209.85.208.171]:42895 "EHLO
        mail-lj1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728307AbfAJS63 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 Jan 2019 13:58:29 -0500
Received: by mail-lj1-f171.google.com with SMTP id l15-v6so10651983lja.9
        for <linux-btrfs@vger.kernel.org>; Thu, 10 Jan 2019 10:58:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ftVeKeFFwz+2l7IdKaY2+qVtaPhpkyVaY56xQyQ4kr0=;
        b=LyRoMJ8udlCJngAsVSw0gPIzd+0N8Ncc9IIfw2aOGv1sImmzJrfjXYw3aNhgKpCwzQ
         BT+tEcPSz+64aBwdCrCJ0wNBbAvn72F9W6DyU1CaqBBRrTndBj9nQ8ls4MP4Sy1mdtSA
         Tr9iVFeyqrKz8Z1ECayIuzhRTemc+fnhB4YlzXYUWuMq/LAuzvxU2IBGIqz5cwgGXCty
         IgkzO90fwfBCCp/T7rC8rEFuiEiz1qOl7goZR7ysPWqLWszJGHw+kvq5ZGoDtHcPMSsC
         xAFAkVkR/PzKe/M+jQjzfyx8Y3h62xOOIBgy1aO5FPJfYcryeV6FrGEMIWf+zbNyHWUP
         3NcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ftVeKeFFwz+2l7IdKaY2+qVtaPhpkyVaY56xQyQ4kr0=;
        b=rpxuyVpxSB7YUS4lB3tGrHt6eKOuRlCWjcpnljh0vvYaBxyYniCL9X9hu28HPE0b7w
         fgboYylrtniGH03u8KiydZMyR4cCuyhcGG+T2YG7ixnyl482zjqefjKrBJZWO0PpcLGf
         lv2N62nN64UhJatk1jxMs/q+D6u0KFl3fkr2v2tJ9xS78zJlchlwQx+tF5zTkkhz71gI
         7icc+H87x6B7CJB2M2a4K1frKplPP9EWlrQjQI5LOCQrRQ+AT4CdikLMtN9Fyo/39bIp
         Oy1VdCM5dYbrtDUA3K2TObB2HRUudRolJb8l6dzF8ysiXH9zDnPA0aPW6fgF0fWPV0wN
         rDLQ==
X-Gm-Message-State: AJcUukfyaDN0TC8T/F/atP+NBmCoekzHKRwsJSjVTi0wA6lxFsci9yWr
        RkGIG9ikagpJ/LCyI5Dtvy02Rpt5QVqF86SUAQM=
X-Google-Smtp-Source: ALg8bN6v6dRymdBx1jKu+To2flS757qTU9BfZ1OUD+ay29KNBMu9216Q9wtG0IpaQEXgfWllK21iaors0frbqTRyeSw=
X-Received: by 2002:a2e:5816:: with SMTP id m22-v6mr6341573ljb.177.1547146706638;
 Thu, 10 Jan 2019 10:58:26 -0800 (PST)
MIME-Version: 1.0
References: <cbffc26e-a57f-e1ad-284c-a54431c4e2f1@gmail.com>
 <64cf0762-bd59-3d77-8aca-94622233767f@gmail.com> <CAEtw4r1we4ctoTwvExFWwc1WFgtBJXYXOizNZrrzqyBGbHCv-A@mail.gmail.com>
 <24856b7a-e4ca-bf12-f70b-7f016142e6b2@gmail.com>
In-Reply-To: <24856b7a-e4ca-bf12-f70b-7f016142e6b2@gmail.com>
From:   Peter Becker <floyd.net@gmail.com>
Date:   Thu, 10 Jan 2019 19:58:15 +0100
Message-ID: <CAEtw4r1-YEotbHF-SF_N12by=d+6h=hwb9u8Rt6RFHeGZaw=Pw@mail.gmail.com>
Subject: Re: Balance of Raid1 pool, does not balance properly.
To:     Karsten Vinding <karstenvinding@gmail.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

for the future you can create a little cron script to avoid this issue.
the data distribution should then be more regular, even if you delete
or overwrite a lot.

deppend on your workload use the right :

# cron.daily / cron.weekly
btrfs balance start -musage=0 -dusage=0 # releases empty blocks for
more unallocated space with can used by future balance runs
btrfs balance start -musage=25 -dusage=25
btrfs balance start -musage=50 -dusage=50


# cron.weekly / cron.monthly
btrfs balance start -musage=90 -dusage=90

A full balance run is then only needed if you add a new device to the
pool or replace a device with a bigger one.


if you are more interesseted about the block usage of your current fs
you can use this little script:

cd /tmp
wget https://raw.githubusercontent.com/kdave/btrfs-progs/master/btrfs-debugfs
chmod +x btrfs-debugfs
stats=$(sudo ./btrfs-debugfs -b /)

echo "00-49: " $(echo "$stats" | grep "usage 0.[0-4]" -c)
echo "50-79: " $(echo "$stats" | grep "usage 0.[5-7]" -c)
echo "80-89: " $(echo "$stats" | grep "usage 0.8" -c)
echo "90-99: " $(echo "$stats" | grep "usage 0.9" -c)
echo "100:   " $(echo "$stats" | grep "usage 1." -c)

The btrfs-debugfs script is from the btrfs progs source and report the
usage of each block group. The following script groups the result.

This script should take less than a few minutes to complete.

Or you can use btrfs-headmap with create a picture:
https://github.com/knorrie/btrfs-heatmap

Am Do., 10. Jan. 2019 um 19:21 Uhr schrieb Karsten Vinding
<karstenvinding@gmail.com>:
>
> Thanks for the answer.
>
> I had already tried "
>
> btrfs balance start -musage=75 -dusage=75 /mnt
>
> It only reallocated 3 blocks.
>
> But after I had moved some data, I ran it with 90, and it realocated a lot more.
>
> I have a new balance running, and this time it seems to be doing its job. At least data is distributed more evenly across disks.
>
> Its not done yet, but its looking fine.
>
>
