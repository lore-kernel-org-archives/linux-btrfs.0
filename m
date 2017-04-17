Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f175.google.com ([209.85.161.175]:34109 "EHLO
        mail-yw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753999AbdDQSeT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Apr 2017 14:34:19 -0400
Received: by mail-yw0-f175.google.com with SMTP id k13so59598487ywk.1
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Apr 2017 11:34:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <8f046fa5-a458-9db8-b616-907afd34383b@gmail.com>
References: <CAK5rZE4ko_xFr_Zv=bmZ4tR9X59jXaqFnTv16_ynEO0+E5uzeg@mail.gmail.com>
 <f5cb15a5-5566-b366-ebda-c3101fa96eec@gmail.com> <CAJCQCtS=xqcWMqiRxC_uoqTRUaW6aMwayoqjtMqq6XhcCJNVRg@mail.gmail.com>
 <8f046fa5-a458-9db8-b616-907afd34383b@gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 17 Apr 2017 12:34:17 -0600
Message-ID: <CAJCQCtTCd7BEwQN4k9n0Jm6ZQTnCS738ctEUnKDb2eENhe21Sg@mail.gmail.com>
Subject: Re: Btrfs/SSD
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Imran Geriskovan <imran.geriskovan@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 17, 2017 at 11:13 AM, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:

>> What is a high end SSD these days? Built-in NVMe?
>
> One with a good FTL in the firmware.  At minimum, the good Samsung EVO
> drives, the high quality Intel ones, and the Crucial MX series, but probably
> some others.  My choice of words here probably wasn't the best though.

It's a confusing market that sorta defies figuring out what we've got.

I have a Samsung EVO SATA SSD in one laptop, but then I have a Samsung
EVO+ SD Card in an Intel NUC. They use that same EVO branding on an
$11 SD Card.

And then there's the Samsung Electronics Co Ltd NVMe SSD Controller
SM951/PM951 in another laptop.


>> So long as this file is not reflinked or snapshot, filefrag shows a
>> pile of mostly 4096 byte blocks, thousands. But as they're pretty much
>> all continuous, the file fragmentation (extent count) is usually never
>> higher than 12. It meanders between 1 and 12 extents for its life.
>>
>> Except on the system using ssd_spread mount option. That one has a
>> journal file that is +C, is not being snapshot, but has over 3000
>> extents per filefrag and btrfs-progs/debugfs. Really weird.
>
> Given how the 'ssd' mount option behaves and the frequency that most systemd
> instances write to their journals, that's actually reasonably expected.  We
> look for big chunks of free space to write into and then align to 2M
> regardless of the actual size of the write, which in turn means that files
> like the systemd journal which see lots of small (relatively speaking)
> writes will have way more extents than they should until you defragment
> them.

Nope. The first paragraph applies to NVMe machine with ssd mount
option. Few fragments.

The second paragraph applies to SD Card machine with ssd_spread mount
option. Many fragments.

These are different versions of systemd-journald so I can't completely
rule out a difference in write behavior.


>> Now, systemd aside, there are databases that behave this same way
>> where there's a small section contantly being overwritten, and one or
>> more sections that grow the data base file from within and at the end.
>> If this is made cow, the file will absolutely fragment a ton. And
>> especially if the changes are mostly 4KiB block sizes that then are
>> fsync'd.
>>
>> It's almost like we need these things to not fsync at all, and just
>> rely on the filesystem commit time...
>
> Essentially yes, but that causes all kinds of other problems.

Drat.

-- 
Chris Murphy
