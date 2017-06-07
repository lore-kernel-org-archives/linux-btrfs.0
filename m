Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f176.google.com ([209.85.220.176]:32989 "EHLO
        mail-qk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751008AbdFGKLH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Jun 2017 06:11:07 -0400
Received: by mail-qk0-f176.google.com with SMTP id r62so4200027qkf.0
        for <linux-btrfs@vger.kernel.org>; Wed, 07 Jun 2017 03:11:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <b8195f2f-adf8-4eb6-2d48-ac6bb5f182fd@xunil.at>
References: <5693147c-befc-da58-cb20-6af31e9aa9cb@xunil.at>
 <CAGqmi76XY0+sYZb3XaDs3rHKzZa=t2kzaGCE+uq_K4vz7PK5_A@mail.gmail.com> <b8195f2f-adf8-4eb6-2d48-ac6bb5f182fd@xunil.at>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Wed, 7 Jun 2017 13:10:26 +0300
Message-ID: <CAGqmi77URH-XTW7fCB+NqzcSb-Y+LvwuvQep+CRJ6_ENgRtWRQ@mail.gmail.com>
Subject: Re: getting rid of "csum failed" on a hw raid
To: "Stefan G. Weichinger" <lists@xunil.at>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2017-06-07 13:05 GMT+03:00 Stefan G. Weichinger <lists@xunil.at>:
> Am 2017-06-07 um 11:37 schrieb Timofey Titovets:
>
>> btrfs scrub start /mnt_path do this trick
>>
>> After, you can find info with paths in dmesg
>
> thank you, I think I have the file, it's a qemu-img-file.
> I try cp-ing it to another fs first, but assume this will fail, right?

Yes, because btrfs will return -EIO
So try dd_rescue

-- 
Have a nice day,
Timofey.
