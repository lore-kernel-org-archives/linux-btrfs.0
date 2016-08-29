Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f45.google.com ([209.85.214.45]:33732 "EHLO
        mail-it0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932628AbcH2Lky (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 Aug 2016 07:40:54 -0400
Received: by mail-it0-f45.google.com with SMTP id j128so15461085ith.0
        for <linux-btrfs@vger.kernel.org>; Mon, 29 Aug 2016 04:40:54 -0700 (PDT)
Subject: Re: btrfs and systemd
To: Imran Geriskovan <imran.geriskovan@gmail.com>
References: <47ee55de-a77b-185a-1a01-b8b39899b188@profihost.ag>
 <0fa90a35-587e-7bfc-9418-ea8416b8f02e@cn.fujitsu.com>
 <f3a27bf7-fecd-e295-991a-8b69c3b92f12@profihost.ag>
 <CAK5rZE6-JKpNEo2zf8jmHqNTPZcPNSMNRJhb9Lbntn11=tzbmA@mail.gmail.com>
Cc: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <22516f5a-3058-5a98-96cd-9e7c3c602df8@gmail.com>
Date: Mon, 29 Aug 2016 07:40:46 -0400
MIME-Version: 1.0
In-Reply-To: <CAK5rZE6-JKpNEo2zf8jmHqNTPZcPNSMNRJhb9Lbntn11=tzbmA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-08-29 07:18, Imran Geriskovan wrote:
>>>> I can't find any fstab setting for systemd to higher this timeout.
>>>> There's just  the x-systemd.device-timeout but this controls how long to
>>>> wait for the device and not for the mount command.
>>>> Is there any solution for big btrfs volumes and systemd?
>>>> Stefan
>
> Switch to Runit.
>
> First time I seriously consider another init on my
> notebook is when I have a problem like yours.
>
> Even when / (root) is mounted just fine, if there is
> any problem with any other fstab entry, you'll
> get into such a situation on systemd.
>
> Give it a try, appending "init=/usr/bin/runit-init"
> to your kernel command line on your bootloader.
> You dont need to uninstall any package until
> getting Runit behave "exactly" as you like.
I hate to say this, but based on my own experience, I have to say that 
switching to a different init system is usually the simplest and 
quickest solution to almost any 'systemd does X that I don't like' problems.

I can't personally give any advice on runit as I've never used it 
myself, but I can say that the stack I'm using (sysv-init, OpenRC, and 
monit) provides most of the good things about systemd except for socket 
activation and interruptible parallel startup, and it's not hard to get 
similarly complete configurations with other tools too.

The downside to this of course is that there are some projects that 
shouldn't need to depend on a particular init system that do, so some 
software may need to be replaced on your system.

As far as this specific case, mount units are what you want to look 
into, as mentioned by Duncan.
