Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f44.google.com ([209.85.218.44]:35205 "EHLO
	mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209AbcF1S3g (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Jun 2016 14:29:36 -0400
Received: by mail-oi0-f44.google.com with SMTP id r2so35266040oih.2
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Jun 2016 11:29:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <9f86cccc-b6b3-95c7-400d-026894e257f5@fastmail.fm>
References: <5b7fbcfe-520a-cc00-f772-97a83fc9aa3d@fastmail.fm>
 <CAJCQCtQXBhtMr71wcb9TW3gFycoKT1QEYj=+P59fW+FM+WogLQ@mail.gmail.com> <9f86cccc-b6b3-95c7-400d-026894e257f5@fastmail.fm>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 28 Jun 2016 12:29:35 -0600
Message-ID: <CAJCQCtRiOwU_DYor0gKbPQ4knBH17PGTtto58KZv2picxLkxeQ@mail.gmail.com>
Subject: Re: Btrfs check command fails with "assertion failed" error
To: Francesco Turco <fturco@fastmail.fm>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 28, 2016 at 12:20 PM, Francesco Turco <fturco@fastmail.fm> wrote:
> On 2016-06-28 20:05, Chris Murphy wrote:
>> Well it probably shouldn't crash but the question is why is device 4
>> missing? We have no information what version of btrfs-progs or kernel
>> is used, or what the layout of this volume is: how many devices,
>> what's the profile breakdown, etc. Are you attempting to fix a
>> degraded volume and are the minimum number of devices present? Btrfs
>> fi show would be useful for this.
>>
>> If it's relatively recent version of btrfs-progs then I'd file a bug
>> just because it shouldn't crash, it should give some sort of coherent
>> message about why it can't proceed.
>
> Sorry for the missing informations. Here you are:
>
> - linux-libre: 4.6.2
> - btrfs-progs: 4.5.3
>
> # btrfs filesystem show /dev/loop0
> warning, device 4 is missing
> Label: none  uuid: 34fb5b58-f50f-47c3-a5b8-91d81a30eade
>         Total devices 2 FS bytes used 5.17GiB
>         devid    1 size 30.00GiB used 30.00GiB path /dev/loop0
>         *** Some devices missing
>
> If I remember correctly I extended that root filesystem with some
> additional space from a file in the home directory, in the hope of
> fixing a problem with btrfs balance and not enough space. I don't have
> the additional file anymore, so I probably won't be able to mount this
> image file anymore. Anyway as you said btrfs-check shouldn't crash.
>
> So I'm going to submit a bug as you suggested.

Yeah depending on the layout, if the only copy of some important
metadata is on the missing device, the btrfs check will naturally
fail. It's just that to a human the messages are out of order...

warning, device 4 is missing
(therefore)
Unable to find block group for 0
(And therefore fail to proceed... please find missing device 4) or some such.


-- 
Chris Murphy
