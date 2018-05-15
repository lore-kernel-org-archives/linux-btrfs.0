Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:52123 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752967AbeEOMHA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 May 2018 08:07:00 -0400
Received: by mail-it0-f67.google.com with SMTP id n202-v6so740442ita.1
        for <linux-btrfs@vger.kernel.org>; Tue, 15 May 2018 05:07:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <99A8759B-68EA-480F-A95D-DF2496B5E767@fb.com>
References: <20180514143510.x5hwstlzm2lpeiqx@US-160370MP2.local> <99A8759B-68EA-480F-A95D-DF2496B5E767@fb.com>
From: Liu Bo <obuil.liubo@gmail.com>
Date: Tue, 15 May 2018 20:06:59 +0800
Message-ID: <CANQeFDBXjTFe9Y+ifuSP_8FFRQfkWau+SkF9m2ZwL+sy9gNgbQ@mail.gmail.com>
Subject: Re: verify key failure
To: Chris Mason <clm@fb.com>
Cc: Liu Bo <bo.liu@linux.alibaba.com>, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 15, 2018 at 12:10 AM, Chris Mason <clm@fb.com> wrote:
>
>
> On 14 May 2018, at 10:35, Liu Bo wrote:
>
>> Hi,
>>
>> I got another warning of verify_level_key by running btrfs/124 in a loop,
>> I'm testing against 4.17-rc3.
>>
>> Not sure if it's false positive.
>
>
> How long does this take to trigger?
>


btrfs/124 takes ~24s on my box, and it took 10 ~ 15 runs to hit.


thanks,
liubo

> -chris
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
