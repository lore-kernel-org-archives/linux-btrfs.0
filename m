Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f174.google.com ([209.85.161.174]:33481 "EHLO
        mail-yw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751567AbdEQEKv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 May 2017 00:10:51 -0400
Received: by mail-yw0-f174.google.com with SMTP id 203so438233ywe.0
        for <linux-btrfs@vger.kernel.org>; Tue, 16 May 2017 21:10:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <84408781-722d-6c87-b510-0497c4f36443@chicoree.fr>
References: <84408781-722d-6c87-b510-0497c4f36443@chicoree.fr>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 16 May 2017 22:10:49 -0600
Message-ID: <CAJCQCtSggDc1F=efwzWQU99r4UsC6MB+_jEw0Uor7JmRkhH1Jw@mail.gmail.com>
Subject: Re: Can't remount a BTRFS partition read write after a drive failure
To: Sylvain Leroux <sylvain@chicoree.fr>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 16, 2017 at 6:56 AM, Sylvain Leroux <sylvain@chicoree.fr> wrote:
> Hi,
> I'm investigating BTRFS using an external USB HDD on a Linux Debian
> Stretch/Sid system.
>
> The drive is not reliable. And I noticed when there is an error and the
> USB device appears to be dead to the kernel, I am later unable to
> remount rw the drive. I can mount it read only though.
>
> This seems to be a systematic behavior. And it occasionally happens when
> the computer wake up from sleep and the drive is still attached.
>
> Power cycling the disk do not change anything, but restarting the
> computer "solves" the issue.
>
>
> I believe this may be caused by BTRFS having issues since the kernel
> assign a different device name to the drive when it bring it back
> inline? Or BTRFS didn't realize the "original" drive has gone away?
>
>
> Attached are the dmesg output corresponding to my issue.
> Initially, the drive was mounted rw and associated to the /dev/sdb
> device, the btrfs partition being /dev/sdb1
> After the failure, I power cycled the drive, and the kernel brought it
> back as /dev/sdc
>
> I can mount /dev/sdc1 read only.
> But I'm unable to mount it read-write. Interestingly, the message in
> dmesg still mention /dev/sdb1 as the device whereas it should be /dev/sdc1.
>
>
>
> sylvain@bulbizarre:~$ uname -a
> Linux bulbizarre 4.9.0-2-amd64 #1 SMP Debian 4.9.18-1 (2017-03-30)
> x86_64 GNU/Linux
> sylvain@bulbizarre:~$ btrfs --version
> btrfs-progs v4.7.3
> sylvain@bulbizarre:~$ sudo btrfs fi show
> Label: 'G-Drive'  uuid: 9465dad3-6604-4437-883e-f66386d69ac8
>     Total devices 1 FS bytes used 503.34GiB
>     devid    1 size 931.51GiB used 507.02GiB path /dev/sdc1
>
>
>
> Any clue to help me mounting back the disk without having to restart the
> system would be greatly appreciated!
> Regards,
> - Sylvain.


Seems normal to me. The device is seriously misbehaving. Btrfs gets
confused. And it goes read-only to avoid causing more problems by
adding writes based on confusing to the misbehaving and unreliable
drive.


-- 
Chris Murphy
