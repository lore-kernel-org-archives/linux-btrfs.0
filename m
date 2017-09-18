Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f171.google.com ([209.85.223.171]:51698 "EHLO
        mail-io0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752275AbdIRI1B (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Sep 2017 04:27:01 -0400
Received: by mail-io0-f171.google.com with SMTP id l15so270412iol.8
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Sep 2017 01:27:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAP9W88j+UZCiF6-Bj6Nyh83L=jpTfM5vF-Pz0y09TJ5dsbciZw@mail.gmail.com>
References: <CAP9W88j+UZCiF6-Bj6Nyh83L=jpTfM5vF-Pz0y09TJ5dsbciZw@mail.gmail.com>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Mon, 18 Sep 2017 11:26:20 +0300
Message-ID: <CAGqmi74XQkpRwhZ23qyNg7EuGi=aC8aKymUU8g8XeMsLmNHkVA@mail.gmail.com>
Subject: Re: using fio to test btrfs compression
To: shally verma <shallyvermacavium@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2017-09-18 10:36 GMT+03:00 shally verma <shallyvermacavium@gmail.com>:
> Hi
>
> I wanted to test btrfs compression using fio command but somehow
> during fio writes, I don't see code taking route of compression blocks
> where as If I do a copy to btrfs compression enabled mount point then
> I can easily see code falling through compression.c.
>
> Here's how I do my setup
>
> 1. mkfs.btrfs /dev/sdb1
> 2. mount -t btrfs -o compress=zlib,compress-force /dev/sdb1 /mnt
> 3. cp <some large test file> /mnt
> 4. dmesg shows print staments from compression.c and zlib.c confirming
> compression routine was invoked during write
> 5. now, copy back from btrfs mount point to home directory also shows
> decompress call invokation
>
> Now, try same with fio commands:
>
> fio command
>
> fio --directory=/mnt/ --numjobs=1 --direct=0 --buffered=1
> --ioengine=libaio --group_reporting --bs=64k --rw=write --iodepth=128
> --name=test --size=10G --runtime=180 --time_based
>
> But it seems to write uncompressed data.
>
> Any help here? what's missing?
>
> Thanks
> Shally
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

1. mount -t btrfs -o compress=zlib,compress-force -> compress-force=zlib
2. Tune fio to generate compressible data


-- 
Have a nice day,
Timofey.
