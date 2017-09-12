Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:38811 "EHLO
        mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751144AbdILIZv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Sep 2017 04:25:51 -0400
Received: by mail-io0-f175.google.com with SMTP id n69so41070984ioi.5
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Sep 2017 01:25:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <2ee9f15b-a11a-886e-2460-557bb9f8d41d@rqc.ru>
References: <2ee9f15b-a11a-886e-2460-557bb9f8d41d@rqc.ru>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Tue, 12 Sep 2017 11:25:10 +0300
Message-ID: <CAGqmi770j8gO8zFNiMgie5n3b6rm2JVdvG+K+HMDJ-CpMCiEiw@mail.gmail.com>
Subject: Re: qemu-kvm VM died during partial raid1 problems of btrfs
To: Marat Khalili <mkh@rqc.ru>
Cc: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2017-09-12 11:02 GMT+03:00 Marat Khalili <mkh@rqc.ru>:
> Thanks to the help from the list I've successfully replaced part of btrfs
> raid1 filesystem. However, while I waited for best opinions on the course of
> actions, the root filesystem of one the qemu-kvm VMs went read-only, and
> this root was of course based in a qcow2 file on the problematic btrfs (the
> root filesystem of the VM itself is ext4, not btrfs). It is very well
> possible that it is a coincidence or something inducted by heavier than
> usual IO load, but it is hard for me to ignore the possibility that somehow
> the hardware error was propagated to VM. Is it possible?
>
> No other processes on the machine developed any problems, but:
> (1) it is very well possible that problematic sector belonged to this qcow2
> file;
> (2) it is a Kernel VM after all, and it might bypass normal IO paths of
> userspace processes;
> (3) it is possible that it uses O_DIRECT or something, and btrfs raid1 does
> not fully protect this kind of access.
> Does this make any sense?
>
> I could not login to the VM normally to see logs, and made big mistake of
> rebooting it. Now all I see in its logs is big hole, since, well, it went
> read-only :( I'll try to find out if (1) above is true after I finish
> migrating data from HDD and remove the it. I wonder where else can I look?
>
> --
>
> With Best Regards,
> Marat Khalili

AFAIK, if while read BTRFS get Read Error in RAID1, application will
also see that error and if application can't handle it -> you got a
problems

So Btrfs RAID1 ONLY protect data, not application (qemu in your case).

-- 
Have a nice day,
Timofey.
