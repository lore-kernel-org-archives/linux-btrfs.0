Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:63526 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753363AbaLVADQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 21 Dec 2014 19:03:16 -0500
Received: by mail-qa0-f46.google.com with SMTP id w8so2648304qac.19
        for <linux-btrfs@vger.kernel.org>; Sun, 21 Dec 2014 16:03:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20141221234940.GD25267@carfax.org.uk>
References: <CAEtWy5wo07Yey4d8icCeP51saV2wCaCFh+9dMD23oEJ=nhiSUA@mail.gmail.com>
	<001a11c3dd5e0f76ea050ac2678e@google.com>
	<CAEtWy5z0rayrK3waAN36uL81PJ1VDSew8AO_5J+2WxK_1qAyRw@mail.gmail.com>
	<20141221234940.GD25267@carfax.org.uk>
Date: Mon, 22 Dec 2014 00:03:15 +0000
Message-ID: <CAEtWy5y2aQ=BL=vKJS3qWfmSrbHTROSSjEsxS+as-_8kOKQ7Jg@mail.gmail.com>
Subject: Re: Fwd: Delivery Status Notification (Failure)
From: Tom <tom.ashley@gmail.com>
To: Hugo Mills <hugo@carfax.org.uk>, Tom <tom.ashley@gmail.com>,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I think this is the relevant part:

Dec 21 23:01:25 jackal kernel: BTRFS: error (device sda4) in
__btrfs_unlink_inode:3757: errno=-2 No such entry
Dec 21 23:01:26 jackal kernel: BTRFS info (device sda4): forced readonly
Dec 21 23:01:26 jackal kernel: BTRFS: error (device sda4) in
btrfs_rename:8524: errno=-2 No such entry

It seemed to be related to opening Chromium - I have moved the
~/.config/chromium/Default directory and it doesn't seem to be
remounting the fs ro now.

On 21 December 2014 at 23:49, Hugo Mills <hugo@carfax.org.uk> wrote:
> On Sun, Dec 21, 2014 at 11:41:16PM +0000, Tom wrote:
>> Hi,
>>
>> My laptop experienced a loss of power that seems to have caused some kind
>> of corruption on my /home btrfs partition.
>>
>> Upon boot, the partition is mounted rw, but as soon as I start accessing
>> data my /home is remounted ro
>>
>> uname -a
>> Linux jackal 3.17.6-1-ARCH #1 SMP PREEMPT Sun Dec 7 23:43:32 UTC 2014
>> x86_64 GNU/Linux
>>
>> btrfs --version
>> Btrfs v3.17.3
>>
>> btrfs fi show
>> Label: none  uuid: a5ff01bc-dd6c-4d33-95a4-5caca473f4bc
>>     Total devices 1 FS bytes used 144.86GiB
>>     devid    1 size 250.08GiB used 238.04GiB path /dev/sda4
>>
>> Btrfs v3.17.3
>>
>>
>> btrfs fi df /home/
>> Data, single: total=234.01GiB, used=143.67GiB
>> System, DUP: total=8.00MiB, used=32.00KiB
>> System, single: total=4.00MiB, used=0.00B
>> Metadata, DUP: total=2.00GiB, used=1.19GiB
>> Metadata, single: total=8.00MiB, used=0.00B
>> GlobalReserve, single: total=408.00MiB, used=0.00B
>>
>>
>>
>> Is there anything obvious in the dmesg that will help me recover this?
>
>    Can't tell from the above -- could you copy the relevant time
> period of dmesg to an email so we can see? :)
>
>    Hugo.
>
>> Thanks for any help,
>>
>> Tom
>
> --
> Hugo Mills             | I always felt that as a C programmer, I was becoming
> hugo@... carfax.org.uk | typecast.
> http://carfax.org.uk/  |
> PGP: 65E74AC0          |
