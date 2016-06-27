Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f171.google.com ([209.85.216.171]:33849 "EHLO
	mail-qt0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609AbcF0EDH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jun 2016 00:03:07 -0400
Received: by mail-qt0-f171.google.com with SMTP id m2so16876790qtd.1
        for <linux-btrfs@vger.kernel.org>; Sun, 26 Jun 2016 21:03:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPrP9G8gH4szLy3uHmVcH4dBsoze4XhNZA9t-qUxecnwOgYNVg@mail.gmail.com>
References: <CAPrP9G8gH4szLy3uHmVcH4dBsoze4XhNZA9t-qUxecnwOgYNVg@mail.gmail.com>
From: Nick Austin <nick@smartaustin.com>
Date: Sun, 26 Jun 2016 21:02:46 -0700
Message-ID: <CAPrP9G8gUfYD92m2e89P4n6_2B4i4CJTe-MnZrR_3gAoQAw=1Q@mail.gmail.com>
Subject: Re: Strange behavior when replacing device on BTRFS RAID 5 array.
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jun 26, 2016 at 8:57 PM, Nick Austin <nick@smartaustin.com> wrote:
> sudo btrfs fi show /mnt/newdata
> Label: '/var/data'  uuid: e4a2eb77-956e-447a-875e-4f6595a5d3ec
>         Total devices 4 FS bytes used 8.07TiB
>         devid    1 size 5.46TiB used 2.70TiB path /dev/sdg
>         devid    2 size 5.46TiB used 2.70TiB path /dev/sdl
>         devid    3 size 5.46TiB used 2.70TiB path /dev/sdm
>         devid    4 size 5.46TiB used 2.70TiB path /dev/sdx

It looks like fi show has bad data:

When I start heavy IO on the filesystem (running rsync -c to verify the data),
I notice zero IO on the bad drive I told btrfs to replace, and lots of IO to the
 expected replacement.

I guess some metadata is messed up somewhere?

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
          25.19    0.00    7.81   28.46    0.00   38.54

Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
sdg             437.00     75168.00      1792.00      75168       1792
sdl             443.00     76064.00      1792.00      76064       1792
sdm             438.00     75232.00      1472.00      75232       1472
sdw             443.00     75680.00      1856.00      75680       1856
sdx               0.00         0.00         0.00          0          0
