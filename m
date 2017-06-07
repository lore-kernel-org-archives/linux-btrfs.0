Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f170.google.com ([209.85.216.170]:33664 "EHLO
        mail-qt0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751026AbdFGJiM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Jun 2017 05:38:12 -0400
Received: by mail-qt0-f170.google.com with SMTP id u12so4072018qth.0
        for <linux-btrfs@vger.kernel.org>; Wed, 07 Jun 2017 02:38:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5693147c-befc-da58-cb20-6af31e9aa9cb@xunil.at>
References: <5693147c-befc-da58-cb20-6af31e9aa9cb@xunil.at>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Wed, 7 Jun 2017 12:37:26 +0300
Message-ID: <CAGqmi76XY0+sYZb3XaDs3rHKzZa=t2kzaGCE+uq_K4vz7PK5_A@mail.gmail.com>
Subject: Re: getting rid of "csum failed" on a hw raid
To: "Stefan G. Weichinger" <lists@xunil.at>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2017-06-07 11:48 GMT+03:00 Stefan G. Weichinger <lists@xunil.at>:
>
> greets
>
> I have a customer server that was set up with a hardware raid and on top
> of that /dev/sda exists a btrfs filesystem.
>
> Yes, I know, that is stupid (can't change that easily).
>
> In dmesg I get flooding:
>
> [2329426.792480] BTRFS warning (device sda): csum failed ino 7454384 off
> 81708052480 csum 3746940842 expected csum 3305376500
> [2329427.844757] BTRFS warning (device sda): csum failed ino 7454384 off
> 81708052480 csum 3746940842 expected csum 3305376500
> [2329428.929354] BTRFS warning (device sda): csum failed ino 7454384 off
> 81708052480 csum 3746940842 expected csum 3305376500
>
> ...
>
> I googled how to spot the file containing that problematic block(?):
>
> find / -type f -exec cp {} /dev/null \;
>
> I have that running within tmux now, are there any other ways to find
> that file and somehow fix it?
>
> That btrfs contains the root-fs of the server ... so I would maybe have
> to driver there, boot from stick or so and btrfsck the unmounted fs?
>
> thanks, Stefan

btrfs scrub start /mnt_path do this trick

After, you can find info with paths in dmesg

-- 
Have a nice day,
Timofey.
