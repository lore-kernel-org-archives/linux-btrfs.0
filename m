Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f179.google.com ([209.85.223.179]:33357 "EHLO
        mail-io0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751214AbdILJgg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Sep 2017 05:36:36 -0400
Received: by mail-io0-f179.google.com with SMTP id k101so1144385iod.0
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Sep 2017 02:36:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <bac84554-c4a4-a089-a766-446c0267f33c@rqc.ru>
References: <2ee9f15b-a11a-886e-2460-557bb9f8d41d@rqc.ru> <CAGqmi770j8gO8zFNiMgie5n3b6rm2JVdvG+K+HMDJ-CpMCiEiw@mail.gmail.com>
 <69e843f4-1233-261a-3b88-306359ef20c9@rqc.ru> <CAGqmi77Gb7_-tL3jeBbssTZke7UXiOD39Lf7O1MEmidRTL+_Fg@mail.gmail.com>
 <bac84554-c4a4-a089-a766-446c0267f33c@rqc.ru>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Tue, 12 Sep 2017 12:35:55 +0300
Message-ID: <CAGqmi74i_e0C5tC0MfhBGCfqmsNqzGeuVSCSEAKbUZ7br60OaQ@mail.gmail.com>
Subject: Re: qemu-kvm VM died during partial raid1 problems of btrfs
To: Marat Khalili <mkh@rqc.ru>
Cc: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2017-09-12 12:29 GMT+03:00 Marat Khalili <mkh@rqc.ru>:
> On 12/09/17 12:21, Timofey Titovets wrote:
>>
>> Can't reproduce that on latest kernel: 4.13.1
>
> Great! Thank you very much for the test. Do you know if it's fixed in 4.10?
> (or what particular version does?)
> --
>
> With Best Regards,
> Marat Khalili
>

Nope, i reading all list message for at least 3 years and i can't
remember merget patches that can fix that, may be this can be related
to latest BIO API rework and changes, but i'm unsure.
Sry.

-- 
Have a nice day,
Timofey.
