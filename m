Return-Path: <SRS0=EUcM=33=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3422C2BA83
	for <linux-btrfs@archiver.kernel.org>; Fri,  7 Feb 2020 17:52:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B82A4214AF
	for <linux-btrfs@archiver.kernel.org>; Fri,  7 Feb 2020 17:52:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JS2ac3E+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726956AbgBGRwN (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 7 Feb 2020 12:52:13 -0500
Received: from mail-ua1-f66.google.com ([209.85.222.66]:38587 "EHLO
        mail-ua1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726900AbgBGRwN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Feb 2020 12:52:13 -0500
Received: by mail-ua1-f66.google.com with SMTP id c7so156378uaf.5
        for <linux-btrfs@vger.kernel.org>; Fri, 07 Feb 2020 09:52:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=Kh4tG7VLkGzdU1C2Bi0BWKnkhJHG58P6U/LOUcNnNRk=;
        b=JS2ac3E+DkOvJTiSEh9f2p8294usdkiO8oQnlpCG/MRpwkp58ruLxLiHB5Ni7yNU6y
         ZfZu445Gl2q4BVaVbLekaMUDlhCaxmTBCNG2KDrEKhO9c1ZQkjcIXEGlFTiGzBKUdDKS
         uK5pu4LYnWMQgFtmInnAmV7aI1Y4mypSP8EEwzjEU8nBJ85AgRKNpd5FB7E2HEYHmjOA
         qynUNRHP3GU/GWEmE3gh5zfdVDn/zxvfW2umAsOf+psj4eESI9a78PcC+QlqgQRqG+rw
         DHH0V+u3JWNgvZtHe7BFNMktkT0B1f7fgfP9wLfZJd/rPpAZp4JP6+LdHJYPz4ZVpYxh
         N8BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=Kh4tG7VLkGzdU1C2Bi0BWKnkhJHG58P6U/LOUcNnNRk=;
        b=NeUnssDzP9YpS1tByMmCYiJ5vO04nCELeiuzEDLrUcVYGiGIQHxbFKVshBlyXTNg6V
         5L/pePGx/BrozpUlXn2KG6UpEK2euKVzn31vRV3S57lMTwaufiM+gKpJiw/EIi3rD2v2
         aYHc7H38q5a1nS4XpL7qo7HGaIF3QfJ5nLyULXlRsm0M2ividTmcHe1uJ/Q2a3v17PTr
         3quJgjiIuw8gaqsMa1rEkPTDp8zANdIlSr7X8RbvxtHj5bdLIgjb05AXXW1gRyU+X81w
         rBLX6SjZLPCB6OpYyscZVSvdoWInfqA5ju1zUG9qaCZ/I6MKPWXQS1KXqaQw06Y3drUU
         2Zcw==
X-Gm-Message-State: APjAAAWVfzicY+CsD/m9ci2R/WofYOMaNL0xndkRWbd9F02zk1CDLr9A
        6JXUwIk7swRiXGJcFbeFxo6TaknL/l6FCZsMMK5WnRpNX68=
X-Google-Smtp-Source: APXvYqxGtp54qYB/Wg5KJ/D621Vti76i70jRIzoalTZFfOvXs1CazRLdjhqCcTZQM1sPwYYLO1VUYkwNMmg5m4oNadM=
X-Received: by 2002:ab0:248a:: with SMTP id i10mr5353982uan.108.1581097932158;
 Fri, 07 Feb 2020 09:52:12 -0800 (PST)
MIME-Version: 1.0
References: <CA+M2ft9zjGm7XJw1BUm364AMqGSd3a8QgsvQDCWz317qjP=o8g@mail.gmail.com>
In-Reply-To: <CA+M2ft9zjGm7XJw1BUm364AMqGSd3a8QgsvQDCWz317qjP=o8g@mail.gmail.com>
From:   John Hendy <jw.hendy@gmail.com>
Date:   Fri, 7 Feb 2020 11:52:01 -0600
Message-ID: <CA+M2ft9ANwKT1+ENS6-w9HLtdx0MDOiVhi5RWKLucaT_WtZLkg@mail.gmail.com>
Subject: btrfs root fs started remounting ro
To:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Greetings,

I'm resending, as this isn't showing in the archives. Perhaps it was
the attachments, which I've converted to pastebin links.

As an update, I'm now running off of a different drive (ssd, not the
nvme) and I got the error again! I'm now inclined to think this might
not be hardware after all, but something related to my setup or a bug
with chromium.

After a reboot, chromium wouldn't start for me and demsg showed
similar parent transid/csum errors to my original post below. I used
btrfs-inspect-internal to find the inode traced to
~/.config/chromium/History. I deleted that, and got a new set of
errors tracing to ~/.config/chromium/Cookies. After I deleted that and
tried starting chromium, I found that my btrfs /home/jwhendy pool was
mounted ro just like the original problem below.

dmesg after trying to start chromium:
- https://pastebin.com/CsCEQMJa

Thanks for any pointers, as it would now seem that my purchase of a
new m2.sata may not buy my way out of this problem! While I didn't
want to reinstall, at least new hardware is a simple fix. Now I'm
worried there is a deeper issue bound to recur :(

Best regards,
John

On Wed, Feb 5, 2020 at 10:01 AM John Hendy <jw.hendy@gmail.com> wrote:
>
> Greetings,
>
> I've had this issue occur twice, once ~1mo ago and once a couple of
> weeks ago. Chromium suddenly quit on me, and when trying to start it
> again, it complained about a lock file in ~. I tried to delete it
> manually and was informed I was on a read-only fs! I ended up biting
> the bullet and re-installing linux due to the number of dead end
> threads and slow response rates on diagnosing these issues, and the
> issue occurred again shortly after.
>
> $ uname -a
> Linux whammy 5.5.1-arch1-1 #1 SMP PREEMPT Sat, 01 Feb 2020 16:38:40
> +0000 x86_64 GNU/Linux
>
> $ btrfs --version
> btrfs-progs v5.4
>
> $ btrfs fi df /mnt/misc/ # full device; normally would be mounting a subv=
ol on /
> Data, single: total=3D114.01GiB, used=3D80.88GiB
> System, single: total=3D32.00MiB, used=3D16.00KiB
> Metadata, single: total=3D2.01GiB, used=3D769.61MiB
> GlobalReserve, single: total=3D140.73MiB, used=3D0.00B
>
> This is a single device, no RAID, not on a VM. HP Zbook 15.
> nvme0n1                                       259:5    0 232.9G  0 disk
> =E2=94=9C=E2=94=80nvme0n1p1                                   259:6    0 =
  512M  0
> part  (/boot/efi)
> =E2=94=9C=E2=94=80nvme0n1p2                                   259:7    0 =
    1G  0 part  (/boot)
> =E2=94=94=E2=94=80nvme0n1p3                                   259:8    0 =
231.4G  0 part (btrfs)
>
> I have the following subvols:
> arch: used for / when booting arch
> jwhendy: used for /home/jwhendy on arch
> vault: shared data between distros on /mnt/vault
> bionic: root when booting ubuntu bionic
>
> nvme0n1p3 is encrypted with dm-crypt/LUKS.
>
> dmesg, smartctl, btrfs check, and btrfs dev stats attached.

Edit: links now:
- btrfs check: https://pastebin.com/nz6Bc145
- dmesg: https://pastebin.com/1GGpNiqk
- smartctl: https://pastebin.com/ADtYqfrd

btrfs dev stats (not worth a link):

[/dev/mapper/old].write_io_errs    0
[/dev/mapper/old].read_io_errs     0
[/dev/mapper/old].flush_io_errs    0
[/dev/mapper/old].corruption_errs  0
[/dev/mapper/old].generation_errs  0


> If these are of interested, here are reddit threads where I posted the
> issue and was referred here.
> 1) https://www.reddit.com/r/btrfs/comments/ejqhyq/any_hope_of_recovering_=
from_various_errors_root/
> 2)  https://www.reddit.com/r/btrfs/comments/erh0f6/second_time_btrfs_root=
_started_remounting_as_ro/
>
> It has been suggested this is a hardware issue. I've already ordered a
> replacement m2.sata, but for sanity it would be great to know
> definitively this was the case. If anything stands out above that
> could indicate I'm not setup properly re. btrfs, that would also be
> fantastic so I don't repeat the issue!
>
> The only thing I've stumbled on is that I have been mounting with
> rd.luks.options=3Ddiscard and that manually running fstrim is preferred.
>
>
> Many thanks for any input/suggestions,
> John
