Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:33622 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751488AbdLSUrI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Dec 2017 15:47:08 -0500
Received: by mail-io0-f196.google.com with SMTP id t196so14978431iof.0
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Dec 2017 12:47:08 -0800 (PST)
Subject: Re: Unexpected raid1 behaviour
To: Tomasz Pala <gotar@polanet.pl>,
        Linux fs Btrfs <linux-btrfs@vger.kernel.org>
References: <5A357909.8010206@yandex.ru>
 <pan$36ed4$200dd538$4324239e$ed0f9f4@cox.net>
 <23094.37316.66397.431081@tree.ty.sabi.co.uk>
 <91965e24-3b94-7334-c249-d8de5f585f29@gmail.com>
 <20171218194351.GA25245@polanet.pl>
 <7ff86029-5b0f-1d02-778a-af78c6f3e461@gmail.com>
 <20171219144644.GA9855@polanet.pl>
 <CAJCQCtSwfoSmAfFyP15xp-uysBY1kWyt65Jhf37g68YcPQ2QEA@mail.gmail.com>
 <20171219204155.GB14726@polanet.pl>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <aac98fbf-c94b-1a88-f191-902146ff544f@gmail.com>
Date: Tue, 19 Dec 2017 15:47:03 -0500
MIME-Version: 1.0
In-Reply-To: <20171219204155.GB14726@polanet.pl>
Content-Type: text/plain; charset=iso-8859-2; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-12-19 15:41, Tomasz Pala wrote:
> On Tue, Dec 19, 2017 at 12:35:20 -0700, Chris Murphy wrote:
> 
>> with a read only file system. Another reason is the kernel code and
>> udev rule for device "readiness" means the volume is not "ready" until
>> all member devices are present. And while the volume is not "ready"
>> systemd will not even attempt to mount. Solving this requires kernel
>> and udev work, or possibly a helper, to wait an appropriate amount of
> 
> Sth like this? I got such problem a few months ago, my solution was
> accepted upstream:
> https://github.com/systemd/systemd/commit/0e8856d25ab71764a279c2377ae593c0f2460d8f
> 
> Rationale is in referred ticket, udev would not support any more btrfs
> logic, so unless btrfs handles this itself on kernel level (daemon?),
> that is all that can be done.
Or maybe systemd can quit trying to treat BTRFS like a volume manager 
(which it isn't) and just try to mount the requested filesystem with the 
requested options?  Then you would just be able to specify 'degraded' in 
your mount options, and you don't have to care that the kernel refuses 
to mount degraded filesystems without being explicitly asked to.
> 
>> time. I also think it's a bad idea to implement automatic degraded
>> mounts unless there's an API for user space to receive either a push
> [...]
>> There is no amount of documentation that makes up for these
>> deficiencies enough to enable automatic degraded mounts by default. I
>> would consider it a high order betrayal of user trust to do it.
> 
> It doesn't have to be default, might be kernel compile-time knob, module
> parameter or anything else to make the *R*aid work.
There's a mount option for it per-filesystem.  Just add that to all your 
mount calls, and you get exactly the same effect.
