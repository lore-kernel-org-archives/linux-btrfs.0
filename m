Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f46.google.com ([209.85.215.46]:35582 "EHLO
        mail-lf0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751059AbdGGQ7q (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Jul 2017 12:59:46 -0400
Received: by mail-lf0-f46.google.com with SMTP id b207so28570038lfg.2
        for <linux-btrfs@vger.kernel.org>; Fri, 07 Jul 2017 09:59:45 -0700 (PDT)
Subject: Re: btrfs device ready purpose
To: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAJCQCtR+dJr8H2co41LB0hEUZCFSnkixeyv46ccdureMiBVTWg@mail.gmail.com>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <74c792e3-d8f6-fb09-c6ee-62dfdf59650c@gmail.com>
Date: Fri, 7 Jul 2017 19:59:42 +0300
MIME-Version: 1.0
In-Reply-To: <CAJCQCtR+dJr8H2co41LB0hEUZCFSnkixeyv46ccdureMiBVTWg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

07.07.2017 19:42, Chris Murphy пишет:
> I'm digging through piles of list emails and not really finding an
> answer to this. Maybe it's Friday and I'm just confused...
> 
> 
> [root@f26s ~]# btrfs device ready /dev/sda1
> [root@f26s ~]# echo $?
> 0
> [root@f26s ~]# btrfs device ready /dev/mapper/vg-1
> [root@f26s ~]# echo $?
> 0
> 
> 
> /dev/sda1 is a single device btrfs and it is present, 'btrfs fi show' finds it.
> /dev/mapper/vg-1 is one member of a two device Btrfs volume, the
> missing device is /dev/mapper/vg-2 and 'btrfs fi show' sees 1 but not
> 2 and says a device is missing.
> 
> And yet the ready command completes and the exit code is the same, and
> I just don't understand the purpose of this command. The man page says
> "wait" but I don't see any waiting, so at the very least we probably
> need to come up with a more descriptive man page description.
> 

Here on Ubuntu 16.04.2 man page says

       ready <device>
           Check device to see if it has all of it’s devices in cache
for mounting.

Nothing about "wait".

btrfs device ready is only useful during startup. The only check it does
- whether kernel knows about all devices or not. It is really intended
to be used from udev rule to delay attempt to mount filesystem until all
devices have been seen. And it is only useful with systemd as it is the
only program that actually pays attention to it.
