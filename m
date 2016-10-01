Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:37177 "EHLO
        mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750981AbcJAWdA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 1 Oct 2016 18:33:00 -0400
Received: by mail-wm0-f47.google.com with SMTP id b201so14778107wmb.0
        for <linux-btrfs@vger.kernel.org>; Sat, 01 Oct 2016 15:32:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRw4oeTddQCTWGNjnLa07-71PmbHqa3hdbdLkGsP8smdQ@mail.gmail.com>
References: <CAOf5Se5C+6Y+=uz=Lkv-wrPhHZOMD94hzrtLHwDR3D78UHiSSQ@mail.gmail.com>
 <CAJCQCtRw4oeTddQCTWGNjnLa07-71PmbHqa3hdbdLkGsP8smdQ@mail.gmail.com>
From: Nicolas Pujol <nicolas.pujol@gmail.com>
Date: Sun, 2 Oct 2016 00:32:01 +0200
Message-ID: <CAOf5Se5eP5mk2OJPyz7cxG_AWrQkkBEsC0Fx8eAMpy4XEM6dWg@mail.gmail.com>
Subject: Re: Resize a btrfs File System : no enough free space... why ?!?
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, Thank you for your help.

I tried all the commands, but without success so I check again the
disk size. Unfortunately I made a mistake :-/
# lvdisplay --units=k
--- Logical volume ---
  LV Path                /dev/VG1/Vol3
  LV Size                5860536320,00 KiB

So when I use this command that's was too big:
# btrfs filesystem resize 1:5860537344k /mnt/RAID
Resize '/mnt/RAID' of '1:5860537344k'
ERROR: unable to resize '/mnt/RAID': no enough free space

I success to resize with this command to be also accepted with an 128k
mdadm chunk :
# btrfs filesystem resize 1:5860196352k /mnt/RAID

Now everything is working so I'm sorry for this mistake.

Nicolas
