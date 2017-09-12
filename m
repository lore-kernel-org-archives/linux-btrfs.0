Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f179.google.com ([209.85.223.179]:36922 "EHLO
        mail-io0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751251AbdILJWc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Sep 2017 05:22:32 -0400
Received: by mail-io0-f179.google.com with SMTP id j141so42899001ioj.4
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Sep 2017 02:22:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <69e843f4-1233-261a-3b88-306359ef20c9@rqc.ru>
References: <2ee9f15b-a11a-886e-2460-557bb9f8d41d@rqc.ru> <CAGqmi770j8gO8zFNiMgie5n3b6rm2JVdvG+K+HMDJ-CpMCiEiw@mail.gmail.com>
 <69e843f4-1233-261a-3b88-306359ef20c9@rqc.ru>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Tue, 12 Sep 2017 12:21:51 +0300
Message-ID: <CAGqmi77Gb7_-tL3jeBbssTZke7UXiOD39Lf7O1MEmidRTL+_Fg@mail.gmail.com>
Subject: Re: qemu-kvm VM died during partial raid1 problems of btrfs
To: Marat Khalili <mkh@rqc.ru>
Cc: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2017-09-12 11:42 GMT+03:00 Marat Khalili <mkh@rqc.ru>:
> On 12/09/17 11:25, Timofey Titovets wrote:
>>
>> AFAIK, if while read BTRFS get Read Error in RAID1, application will
>> also see that error and if application can't handle it -> you got a
>> problems
>>
>> So Btrfs RAID1 ONLY protect data, not application (qemu in your case).
>
> That's news to me! Why doesn't it try another copy and when does it correct
> the error then? Any idea on how to work it around at least for qemu?
> (Assemble the array from within the VM?)
>
>
> --
>
> With Best Regards,
> Marat Khalili

Can't reproduce that on latest kernel: 4.13.1
For reproduce i use 2 usb flash disk in btrfs raid1 + fio test for generate load
While test i pull down one flash drive, some time ago (year?) this
produce fio error, at now test continues without problems.

-- 
Have a nice day,
Timofey.
