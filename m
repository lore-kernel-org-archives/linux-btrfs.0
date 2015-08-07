Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f49.google.com ([209.85.192.49]:35054 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932267AbbHGQWe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Aug 2015 12:22:34 -0400
Received: by qgj62 with SMTP id 62so52906377qgj.2
        for <linux-btrfs@vger.kernel.org>; Fri, 07 Aug 2015 09:22:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAA7pwKO0detCTYWJDSDLX7fepthE+hBhURifnJjBPUe4XxGfVA@mail.gmail.com>
References: <CAOFdcFMnYfLzw+xH71eNNgZyhqrgH4qOccak0m4OAnH31V_H=A@mail.gmail.com>
 <CAA7pwKO0detCTYWJDSDLX7fepthE+hBhURifnJjBPUe4XxGfVA@mail.gmail.com>
From: Peter Foley <pefoley2@pefoley.com>
Date: Fri, 7 Aug 2015 09:22:14 -0700
Message-ID: <CAOFdcFOTwf6S3Pm6+b-=8RGskCHU+Ms8yQxXG8YHBNG3pJMD=w@mail.gmail.com>
Subject: Re: Removing bad hdd from btrfs volume
To: Patrik Lundquist <patrik.lundquist@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 7, 2015 at 2:30 AM, Patrik Lundquist
<patrik.lundquist@gmail.com> wrote:
> On 7 August 2015 at 00:17, Peter Foley <pefoley2@pefoley.com> wrote:
>> Hi,
>>
>> I have an btrfs volume that spans multiple disks (no raid, just
>> single), and earlier this morning I hit some hardware problems with
>> one of the disks.
>> I tried btrfs dev del /dev/sda1 /, but btrfs was unable to migrate the
>> 1gb that appears to be causing the read errors.
>> See http://sprunge.us/aeZC
>
> You might want to try to save as much as possible from the failing
> disk with the help of GNU ddrescue. Either by copying sda to a
> replacement disk or by copying sda1 to a file for loopback mounting.
>
> Unmount filesystem before copying and remove sda before you mount with the copy.

So, it turns out that the only corrupted file was some random header.
I was able to rm the file, and then the btrfs dev del succeeded.

Thanks,

Peter
