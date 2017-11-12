Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zlom.siedziba.pl ([83.144.122.22]:33124 "EHLO zlom.siedziba.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750866AbdKLOLR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 12 Nov 2017 09:11:17 -0500
Subject: Re: btrfs-image hash collision option, super slow
To: Chris Murphy <lists@colorremedies.com>, Hugo Mills <hugo@carfax.org.uk>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAJCQCtTJXpoSExk7aVKCZKk5YCpV6V31zUpLgQSxa+k4V8+x+w@mail.gmail.com>
 <20171112004230.GJ27985@carfax.org.uk>
 <CAJCQCtR5oqOT2JdO_-gSgVCnBpYz_53eBOeF32G6+ZfX6RK7Kw@mail.gmail.com>
From: =?UTF-8?Q?Piotr_Paw=c5=82ow?= <pp@siedziba.pl>
Message-ID: <4bc2caf5-6f4c-4012-2bab-4daaa766d202@siedziba.pl>
Date: Sun, 12 Nov 2017 15:05:44 +0100
MIME-Version: 1.0
In-Reply-To: <CAJCQCtR5oqOT2JdO_-gSgVCnBpYz_53eBOeF32G6+ZfX6RK7Kw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


>>    It could definitely be improved -- I believe there are some good
>> (but non-trivial) algorithms for finding preimages for CRC32 checksums
>> out there. It's just that btrfs-image doesn't use them.

I implemented a faster method using a reverse CRC32 table, which is in btrfs-progs since release 4.13.1.

On my 20GB root fs SSD:

# echo 3 >/proc/sys/vm/drop_caches && time btrfs-image -s /dev/mapper/pp-root /dev/null >/dev/null 2>&1

real    0m22,023s
user    0m14,812s
sys    0m2,508s
# echo 3 >/proc/sys/vm/drop_caches && time btrfs-image -ss /dev/mapper/pp-root /dev/null >/dev/null 2>&1

real    0m31,977s
user    0m17,984s
sys    0m2,632s

Slower, but not 2 orders of magnitude slower :)

> The other part I'm not groking is that some filenames fail with:
>
> WARNING: cannot find a hash collision for 'Tool', generating garbage,
> it won't match indexes

Unfortunately there are no CRC32 collisions for any file name having 4 or less characters when you have to keep the same file name length, and there may be no collisions for longer file names when you limit the result to ASCII only.
