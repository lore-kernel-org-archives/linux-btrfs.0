Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:52447 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754325Ab3BGQhJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Feb 2013 11:37:09 -0500
Received: by mail-la0-f41.google.com with SMTP id fo12so2835436lab.28
        for <linux-btrfs@vger.kernel.org>; Thu, 07 Feb 2013 08:37:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAGRMg0nw2zubf9bO=8=FBPR3bgVW7474po=H23OAaZ8eCQSL8g@mail.gmail.com>
References: <CAGRMg0kYWUf5rh0WXNc+++9gG+XZ0-n9_SWpVh8jRHN-_2DfXQ@mail.gmail.com>
	<CAGRMg0nmjsMNp1psLzMnf77HWP2Zynj3fWAA1c0DGkFTgvWx+g@mail.gmail.com>
	<20130206222122.GB28997@carfax.org.uk>
	<CAGRMg0nw2zubf9bO=8=FBPR3bgVW7474po=H23OAaZ8eCQSL8g@mail.gmail.com>
Date: Thu, 7 Feb 2013 17:37:07 +0100
Message-ID: <CAGRMg0mk76ppTG8vS297G-M2OGOXtX+MqwPY0p+Zvk4cOOaUiA@mail.gmail.com>
Subject: Re: btrfs balance -> hang/crash
From: Michael Schneider <mike2.schneider@googlemail.com>
To: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

o.k.,
I've deleted some files from my btrfs filesystem rebooted the machine
and was able to cancel the balance operation thereafter.

So far, everything seems to be working again.

-Mike

On Wed, Feb 6, 2013 at 11:26 PM, Michael Schneider
<mike2.schneider@googlemail.com> wrote:
> # btrfs fi show
> failed to read /dev/sr0
> Label: 'bootssd'  uuid: ac89584c-c757-488e-8a2a-5ee5a5484dde
>         Total devices 1 FS bytes used 34.98GB
>         devid    1 size 56.00GB used 41.07GB path /dev/dm-1
>
> Btrfs v0.19+
>
> # btrfs fi df /
> Data: total=35.00GB, used=33.34GB
> System, DUP: total=32.00MB, used=16.00KB
> System: total=4.00MB, used=0.00
> Metadata, DUP: total=3.00GB, used=1.63GB
>
>
> On Wed, Feb 6, 2013 at 11:21 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
>> On Wed, Feb 06, 2013 at 11:12:14PM +0100, Michael Schneider wrote:
>>> Hi,
>>>
>>> my btrfs "hangs" when doing a balance operation.
>>>
>>> I'm using a 3.7.1 kernel from opensuse:  linux-opzz 3.7.1-2.10-m4 #11 SMP
>>> PREEMPT Fri Jan 11 18:04:04 CET 2013 x86_64 x86_64 x86_64 GNU/Linux
>>> and Btrfs v0.19+
>>>
>>> I did a scrub which completed without errors. Then I tried "btrfs filesystem
>>> balance /" which work fine for the first 23 of 46 chunks, then ist stopped
>>> processing further chunks, but contiued to consume large amounts of the CPU.
>>> The system logged filled quickly with messages like:
>>>
>>> [  347.237658] btrfs: block rsv returned -28
>> [snip]
>>> Any idea what's going on?
>>
>>    You're running out of space. Can you post the output of:
>>
>> # btrfs fi df /mountpoint
>> # btrfs fi show
>>
>> this will give us a bit more info about likely scenarios. Also, josef
>> published a patch(*) in the last few hours, on this list, which may
>> help deal with the issue.
>>
>>    Hugo.
>>
>> (*) Btrfs: rework the overcommit logic to be based on the total size
>>
>> --
>> === Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
>>   PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
>>   --- What do you give the man who has everything? -- Penicillin is ---
>>                              a good start...
