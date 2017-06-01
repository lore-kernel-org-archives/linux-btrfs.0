Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f182.google.com ([209.85.220.182]:36660 "EHLO
        mail-qk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751105AbdFAVco (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Jun 2017 17:32:44 -0400
Received: by mail-qk0-f182.google.com with SMTP id p66so30488582qkf.3
        for <linux-btrfs@vger.kernel.org>; Thu, 01 Jun 2017 14:32:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BEFDC957-ECEA-4EEF-9470-D2EA40C47F60@rqc.ru>
References: <CADtmLM88w-KH_SfoECB-N=PXwgvcswP6cyaBtypRHEEdPKZ1VA@mail.gmail.com>
 <CAGqmi755-pWkzROVcK1Qh2qa3-MQ6CbAFzAL85Lv0WVbjpBxFw@mail.gmail.com> <BEFDC957-ECEA-4EEF-9470-D2EA40C47F60@rqc.ru>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Fri, 2 Jun 2017 00:32:03 +0300
Message-ID: <CAGqmi74pxDc5b66Uid8H+5uaD6-ZJngvDejrcTQLjwdv=cco5g@mail.gmail.com>
Subject: Re: understanding differences in recoverability of raid1 vs raid10
 and performance implications of unusual numbers of devices
To: Marat Khalili <mkh@rqc.ru>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2017-06-01 22:26 GMT+03:00 Marat Khalili <mkh@rqc.ru>:
>>raid 1 write data on all disks synchronously all time, no tricks.
>>btrfs raid1 read data by PID%2
>>0 - first copy
>>1 - second copy
>
> Meaning, a single-process database will only ever read one copy? At least, meaning of first/second relative to physical devices depends on extent, right, right?
> --
>
> With Best Regards,
> Marat Khalili
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

IIRC,
https://github.com/torvalds/linux/blob/dc9edaab90de9441cc28ac570b23b0d2bdba7879/fs/btrfs/volumes.c#L5764

So, for single process database you will read only from one disk.

-- 
Have a nice day,
Timofey.
