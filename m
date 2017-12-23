Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f47.google.com ([209.85.214.47]:46101 "EHLO
        mail-it0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750842AbdLWT7S (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 23 Dec 2017 14:59:18 -0500
Received: by mail-it0-f47.google.com with SMTP id t1so17552006ite.5
        for <linux-btrfs@vger.kernel.org>; Sat, 23 Dec 2017 11:59:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <pan$678dc$737b7f30$15572b76$e6022b@cox.net>
References: <CAG+QAKXycv-a3G9QKts4V9RWtKxgRgTtSd6mkZP=Dagmi9Ebtg@mail.gmail.com>
 <CAG+QAKUbtQc0V0njpXoC_UZL5NF1BP+qoH6Zbh4KgEN_2EiOdw@mail.gmail.com>
 <83e041e2-a440-845f-df54-ecde29bd10dd@mendix.com> <CAG+QAKViZXY-NguA+=Dy=1pye1Da+sM2+epohnxyefT=BPwXxw@mail.gmail.com>
 <CAG+QAKWN1X9jVWZeZ8q4DNNxSCXLbYFtM-t=LjpFqeGLE8QgGg@mail.gmail.com>
 <CAJCQCtTD0sp_YZGv47m4sjUvuAeTuq_P5XaRfnZ=SjvGvhF+Nw@mail.gmail.com>
 <09697eee-b6f6-eb02-1c0d-1d6f156985f9@applied-asynchrony.com> <pan$678dc$737b7f30$15572b76$e6022b@cox.net>
From: Rich Rauenzahn <rrauenza@gmail.com>
Date: Sat, 23 Dec 2017 11:59:17 -0800
Message-ID: <CAG+QAKXj9=y9aEpWH3Tay22ZX-TMJiH0DtDdk-1Y6Vb+1VJfTg@mail.gmail.com>
Subject: Re: kernel hangs during balance
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I finally got a full stack trace via sysrq.   A lot of stacks seem to
end in page fault -- I wonder if its because my page file is a
loopback on btrfs.

https://pastebin.com/GyWAu1EP

$ cat /proc/cmdline
BOOT_IMAGE=/vmlinuz-4.14.8-1.el7.elrepo.x86_64
root=UUID=35f0ce3f-0902-47a3-8ad8-86179d1f3e3a ro
rootflags=subvol=root00 vconsole.keymap=us crashkernel=128M
vconsole.font=latarcyrheb-sun16 consoleblank=600 scsi_mod.use_blk_mq=n
LANG=en_US.UTF-8
