Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:35626 "EHLO
        mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932443AbdHWUDo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Aug 2017 16:03:44 -0400
Received: by mail-oi0-f49.google.com with SMTP id r200so11772441oie.2
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Aug 2017 13:03:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4756671.4QeJesEyyX@archlinux>
References: <20170823002650.3133-1-nefelim4ag@gmail.com> <20170823002650.3133-5-nefelim4ag@gmail.com>
 <4756671.4QeJesEyyX@archlinux>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Wed, 23 Aug 2017 23:03:03 +0300
Message-ID: <CAGqmi77RHjeJfwdqhRDs5ityswKfPLF2Og-GEbZKjbr0TfKikw@mail.gmail.com>
Subject: Re: [PATCH v5 4/6] Btrfs: heuristic add detection of zeroed sample
To: Diego Calleja <diegocg@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2017-08-23 20:55 GMT+03:00 Diego Calleja <diegocg@gmail.com>:
> El miércoles, 23 de agosto de 2017 2:26:48 (CEST) Timofey Titovets escribió:
>> +     for (i = 0; i < workspace->sample_size; i += sizeof(zero)) {
>> +             if (memcmp(&workspace->sample[i], &zero, sizeof(zero)))
>> +                     return false;
>
> Instead of just checking for 0, wouldn't it be a better idea to check
> for any kind of repetitions?
>
> As in, iterate over the sample and memcmp() each part of sample with
> the previous one. The cost would be the same, and it would detect not
> just zeros, but any kind of repeated data. Is there any reason I'm
> missing for not doing this?

Thank you, i was not think about that,
That approach seems better, i will update the patch.

-- 
Have a nice day,
Timofey.
