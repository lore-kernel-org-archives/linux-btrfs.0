Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f47.google.com ([209.85.218.47]:50496 "EHLO
        mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751241AbdKMDmG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 12 Nov 2017 22:42:06 -0500
Received: by mail-oi0-f47.google.com with SMTP id l138so308117oib.7
        for <linux-btrfs@vger.kernel.org>; Sun, 12 Nov 2017 19:42:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4bc2caf5-6f4c-4012-2bab-4daaa766d202@siedziba.pl>
References: <CAJCQCtTJXpoSExk7aVKCZKk5YCpV6V31zUpLgQSxa+k4V8+x+w@mail.gmail.com>
 <20171112004230.GJ27985@carfax.org.uk> <CAJCQCtR5oqOT2JdO_-gSgVCnBpYz_53eBOeF32G6+ZfX6RK7Kw@mail.gmail.com>
 <4bc2caf5-6f4c-4012-2bab-4daaa766d202@siedziba.pl>
From: Chris Murphy <lists@colorremedies.com>
Date: Sun, 12 Nov 2017 20:42:05 -0700
Message-ID: <CAJCQCtSG+pVM95G-vwnDX=aqGK6_LJ_D0H=5W_VYMsrdH_=XJw@mail.gmail.com>
Subject: Re: btrfs-image hash collision option, super slow
To: =?UTF-8?Q?Piotr_Paw=C5=82ow?= <pp@siedziba.pl>
Cc: Chris Murphy <lists@colorremedies.com>, Hugo Mills <hugo@carfax.org.uk>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Nov 12, 2017 at 7:05 AM, Piotr Pawłow <pp@siedziba.pl> wrote:
>
>>>    It could definitely be improved -- I believe there are some good
>>> (but non-trivial) algorithms for finding preimages for CRC32 checksums
>>> out there. It's just that btrfs-image doesn't use them.
>
> I implemented a faster method using a reverse CRC32 table, which is in btrfs-progs since release 4.13.1.
>
> On my 20GB root fs SSD:
>
> # echo 3 >/proc/sys/vm/drop_caches && time btrfs-image -s /dev/mapper/pp-root /dev/null >/dev/null 2>&1
>
> real    0m22,023s
> user    0m14,812s
> sys    0m2,508s
> # echo 3 >/proc/sys/vm/drop_caches && time btrfs-image -ss /dev/mapper/pp-root /dev/null >/dev/null 2>&1
>
> real    0m31,977s
> user    0m17,984s
> sys    0m2,632s
>
> Slower, but not 2 orders of magnitude slower :)


Strange. I was using 4.3.3 and it had been running for over 9 hours at
the time I finally cancelled it.


>
>> The other part I'm not groking is that some filenames fail with:
>>
>> WARNING: cannot find a hash collision for 'Tool', generating garbage,
>> it won't match indexes
>
> Unfortunately there are no CRC32 collisions for any file name having 4 or less characters when you have to keep the same file name length, and there may be no collisions for longer file names when you limit the result to ASCII only.

Gotcha.



-- 
Chris Murphy
