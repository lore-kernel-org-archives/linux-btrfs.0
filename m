Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f182.google.com ([209.85.161.182]:32910 "EHLO
        mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752426AbdEPSzz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 May 2017 14:55:55 -0400
Received: by mail-yw0-f182.google.com with SMTP id 203so57413637ywe.0
        for <linux-btrfs@vger.kernel.org>; Tue, 16 May 2017 11:55:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <e399fe02-0d5e-890f-48e4-423c8ef8174b@hale.ee>
References: <92b9b7cd-5b54-775f-95c1-4788b2d3ea67@hale.ee> <CAJCQCtRmMtm5PW-TsUw+erQdXC9K41F0Nys5R+CRv0=KRh7aHw@mail.gmail.com>
 <e399fe02-0d5e-890f-48e4-423c8ef8174b@hale.ee>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 16 May 2017 12:55:40 -0600
Message-ID: <CAJCQCtSLQcOvWvZ9XuuO3H7BC3wqpGsD9zDT0SE2aEHEUqaR-g@mail.gmail.com>
Subject: Re: "Corrected" errors persist after scrubbing
To: Tom Hale <tom@hale.ee>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 16, 2017 at 3:53 AM, Tom Hale <tom@hale.ee> wrote:

> # mdadm --build /dev/md0 --level=faulty --raid-devices=1 /dev/loop0
> # mdadm --grow /dev/md0 --layout=rp400
> layout for /dev/md0 set to 12803

I'm not familiar with this method of simulating problems. Everything
I've seen on this list is it's done with dm-flakey, or with the btrfs
corrupt tool. Everytime I've done that, fixups are honored and are
actually fixed. I have no idea if the above method is accepting
repairs properly. We can see from your log that Btrfs detects problems
and applies fixups. Everytime I've done this on real devices, it's
always fixed the problem. So my guess is the problem is fixed but then
the layout changes with this command

> # mdadm --grow /dev/md0 --layout=clear
> layout for /dev/md0 set to 31

And now the fixes are invalid so you get new errors again. That's just
a guess, like I said I've never seen this method of introducing faults
before so I don't know how it's behaving or what the expectations are.

The very fact Btrfs says it's sent fixups, to the specific faulty
device and sector value, and yet a 2nd scrub shows the exact same
logical errors can't be coincidence. So I suspect the methodology has
a flawed assumption, and either the fixup is not passing through
correctly or is corrupted on the way; or it's fixed but then clearing
the layout recorrupts just those fixed blocks.

>From this description:
http://linux-raid.vger.kernel.narkive.com/XFofrUH1/error-injection

>mdadm -G /dev/md0 --layout=clear
>will stop producing new errors
>mdadm -G /dev/md0 --layout=flush
>will forget all persistent errors.

I don't really understand the distinction, but it sounds like clear
might not be sufficient, that even thought fixes were applied, those
same sectors will still produce errors until flush is used.

Anyway I suspect flawed testing method.






-- 
Chris Murphy
