Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:34667 "EHLO
	mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800AbcGBSiv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 2 Jul 2016 14:38:51 -0400
Received: by mail-oi0-f53.google.com with SMTP id s66so150457620oif.1
        for <linux-btrfs@vger.kernel.org>; Sat, 02 Jul 2016 11:38:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CADbsYN15dJa6OszsV3Fia6Qt=87RxuP28swy_s2JFORjOXO4iA@mail.gmail.com>
References: <CADbsYN2RZ9q7pFSawEkWbTXvomAONz60t7b1Hm6f7Mma=veKgQ@mail.gmail.com>
 <CAJCQCtQheg_PqSaf1EZ7_oHkBBwa=CLSifMbW9=sXNLK7asFng@mail.gmail.com>
 <CADbsYN2Y+UaOVZO_kATeomEy6Xho6kMkY-vgAyKMK4w2MV6VCQ@mail.gmail.com>
 <CAJCQCtQ_=Z1f6oO0gtjtA-wKiEL2VsB=iy0sE4AmwHwh-9gYXw@mail.gmail.com> <CADbsYN15dJa6OszsV3Fia6Qt=87RxuP28swy_s2JFORjOXO4iA@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Sat, 2 Jul 2016 12:38:50 -0600
Message-ID: <CAJCQCtR=cDCtVtn2Y8eaezJaT-jxmGTMJ8=ugGCtd-hjNC+BnA@mail.gmail.com>
Subject: Re: btrfs lockup
To: Grey Christoforo <grey@christoforo.net>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 1, 2016 at 3:50 PM, Grey Christoforo <grey@christoforo.net> wrote:
> On Fri, Jul 1, 2016 at 9:51 PM, Chris Murphy <lists@colorremedies.com> wrote:
>> This is interesting:
>>
>> Jul 01 11:56:40 kernel: BTRFS info (device nvme0n1p5): relocating
>> block group 232511242240 flags 1
>>
>> a. It's an NVMe drive.
>> b. Btrfs at this time is involved in a balance operation of some sort.
> The balance operation is one I started manually. It's a coincidence
> that it's running at this point and I don't believe it's related to
> the lockups because
> 1) I saw the lockups on a previous baobab scan of my
> /var/lib/docker/btrfs/subvolumes when no balance was taking place
> and
> 2) after removing all of docker's subvolumes, the problem has gone away
>>
>>
>> And then what you previously reported, the parts of which I don't follow:
>>
>> Jul 01 12:00:31 kernel: NMI watchdog: BUG: soft lockup - CPU#0 stuck
>> for 22s! [scanner:7121]
> I'd guess this is the kernel's protection mechanism to try to recover
> when come critical (blocking) thread does not return, looks like it's
> essentially killing the process when a watchdog timer expires.

I suggest filing a bug and put the URL here. If you can reproduce
without balance that's probably cleaner for a developer to follow. And
then also when the blocking happens if you can do sysrq+t, then
something like 'journalctl -k -o short-monotonic > dmesg_sysrqt.log'
since often it'll overfill the kernel message buffer where journald
will get it all and just the kernel messages. Attach that to the bug.

Open question if there are kernel debug options to try, I can't really
tell if this is directly Btrfs related or incidental. The soft lockup
message refers to scanner as the running task, and it comes up more
than once in the message log. No idea what that is. I guess it could
be some unexpected interaction between Btrfs, VFS and this scanner
task.


-- 
Chris Murphy
