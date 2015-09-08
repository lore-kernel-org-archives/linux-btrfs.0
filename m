Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f181.google.com ([209.85.160.181]:33362 "EHLO
	mail-yk0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864AbbIHUI5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Sep 2015 16:08:57 -0400
Received: by ykei199 with SMTP id i199so137047747yke.0
        for <linux-btrfs@vger.kernel.org>; Tue, 08 Sep 2015 13:08:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAA85sZtUJCDQ2=7KNFapZXPXb8SseiLCBvJVBDkoUa_7Ah8idQ@mail.gmail.com>
References: <CAA85sZv5V_YGnHaYfDKJ8L9=Nmg0XNRoxK9NLZER_jKZ7TUdnA@mail.gmail.com>
	<20150908193405.GN23944@carfax.org.uk>
	<CAA85sZu9xJOHMr0rs7hvzvBZwBWN7RvCb3bt4dYM7_6D2qyh7Q@mail.gmail.com>
	<CAA85sZvJdOyUhZqFy4bWEPbKfM7k9gKU4vui9k+rRDmnWvPSxQ@mail.gmail.com>
	<CAA85sZtUJCDQ2=7KNFapZXPXb8SseiLCBvJVBDkoUa_7Ah8idQ@mail.gmail.com>
Date: Tue, 8 Sep 2015 14:08:57 -0600
Message-ID: <CAJCQCtSOmfAOfdXXWKJ0noD_PJ=smpETLQ=C5ND-QGOserr6TQ@mail.gmail.com>
Subject: Re: [btrfs tools] ability to fail a device...
From: Chris Murphy <lists@colorremedies.com>
To: Ian Kumlien <ian.kumlien@gmail.com>
Cc: Hugo Mills <hugo@carfax.org.uk>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 8, 2015 at 2:00 PM, Ian Kumlien <ian.kumlien@gmail.com> wrote:
> On 8 September 2015 at 21:55, Ian Kumlien <ian.kumlien@gmail.com> wrote:
>> On 8 September 2015 at 21:43, Ian Kumlien <ian.kumlien@gmail.com> wrote:
>>> On 8 September 2015 at 21:34, Hugo Mills <hugo@carfax.org.uk> wrote:
>>>> On Tue, Sep 08, 2015 at 09:18:05PM +0200, Ian Kumlien wrote:
>> [--8<--]
>>
>>>>    Physically removing it is the way to go (or disabling it using echo
>>>> offline >/sys/block/sda/device/state). Once you've done that, you can
>>>> mount the degraded FS with -odegraded, then either add a new device
>>>> and balance to restore the RAID-1, or balance with
>>>> -{d,m}convert=single to drop the redundancy to single.
>>>
>>> This did not work...
>>
>> And removing the pyscial device is not the answer either... until i
>> did a read only mount ;)
>>
>> Didn't expect it to fail with unable to open ctree like that...
>
> Someone thought they were done too early, only one disk => read only
> mount. But, readonly mount => no balance.
>
> I think something is wrong....
>
> btrfs balance start -dconvert=single -mconvert=single /mnt/disk/
> ERROR: error during balancing '/mnt/disk/' - Read-only file system
>
> btrfs dev delete missing /mnt/disk/
> ERROR: error removing the device 'missing' - Read-only file system
>
> Any mount without ro becomes:
> [  507.236652] BTRFS info (device sda2): allowing degraded mounts
> [  507.236655] BTRFS info (device sda2): disk space caching is enabled
> [  507.325365] BTRFS: bdev (null) errs: wr 2036894, rd 2031380, flush
> 705, corrupt 0, gen 0
> [  510.983321] BTRFS: too many missing devices, writeable mount is not allowed
> [  511.006241] BTRFS: open_ctree failed
>
> And one of them has to give! ;)


You've run into this:
https://bugzilla.kernel.org/show_bug.cgi?id=92641




-- 
Chris Murphy
