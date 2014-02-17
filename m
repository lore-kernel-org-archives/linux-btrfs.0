Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f43.google.com ([209.85.215.43]:49236 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833AbaBQHnH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Feb 2014 02:43:07 -0500
Received: by mail-la0-f43.google.com with SMTP id pv20so11159522lab.30
        for <linux-btrfs@vger.kernel.org>; Sun, 16 Feb 2014 23:43:04 -0800 (PST)
Received: from mail-lb0-x230.google.com (mail-lb0-x230.google.com [2a00:1450:4010:c04::230])
        by mx.google.com with ESMTPSA id e1sm24217473laa.8.2014.02.16.23.43.03
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Sun, 16 Feb 2014 23:43:03 -0800 (PST)
Received: by mail-lb0-f176.google.com with SMTP id w7so10966965lbi.35
        for <linux-btrfs@vger.kernel.org>; Sun, 16 Feb 2014 23:43:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20140216135808.GA1491@frosties>
References: <20140216135808.GA1491@frosties>
From: Dan van der Ster <dan@vanderster.com>
Date: Mon, 17 Feb 2014 08:42:23 +0100
Message-ID: <CABZ+qqmbU3gR-FeR4tpok-QcUgVyCL5Vq5ygrmM4CEqf=PTXcw@mail.gmail.com>
Subject: Re: ENOSPC with 270GiB free
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Did you already try this?? [1]:

   btrfs fi balance start -dusage=5 /mnt/nas3

Cheers, dan

[1] https://btrfs.wiki.kernel.org/index.php/Problem_FAQ#I_get_.22No_space_left_on_device.22_errors.2C_but_df_says_I.27ve_got_lots_of_space

On Sun, Feb 16, 2014 at 2:58 PM, Goswin von Brederlow <goswin-v-b@web.de> wrote:
> Hi,
>
> I'm getting a ENOSPC error from btrfs despite there still being plenty
> of space left:
>
> % df -m /mnt/nas3
> Filesystem         1M-blocks     Used Available Use% Mounted on
> /dev/mapper/nas3-a  19077220 18805132    270773  99% /mnt/nas3
>
> % btrfs fi show
> Label: none  uuid: 4b18f84e-2499-41ca-81ff-fe1783c11491
>         Total devices 1 FS bytes used 17.91TiB
>         devid    1 size 18.19TiB used 17.94TiB path /dev/mapper/nas3-a
>
> Btrfs v3.12
>
> % btrfs fi df
> Data, single: total=17.89TiB, used=17.88TiB
> System, DUP: total=32.00MiB, used=1.92MiB
> Metadata, DUP: total=25.50GiB, used=24.89GiB
>
> As you can see there are still 270GiB free and plenty of block groups
> free on the device too.
>
> So why isn't btrfs allocating a new block group to store more data?
>
> MfG
>         Goswin
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
