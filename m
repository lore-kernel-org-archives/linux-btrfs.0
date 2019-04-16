Return-Path: <SRS0=AHcI=SS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 058DBC10F13
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Apr 2019 07:46:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C00802073F
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Apr 2019 07:46:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=brunner-ninja.20150623.gappssmtp.com header.i=@brunner-ninja.20150623.gappssmtp.com header.b="Lxz2kEHs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728478AbfDPHqw (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 16 Apr 2019 03:46:52 -0400
Received: from mail-wm1-f53.google.com ([209.85.128.53]:38080 "EHLO
        mail-wm1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727845AbfDPHqw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 Apr 2019 03:46:52 -0400
Received: by mail-wm1-f53.google.com with SMTP id w15so23884896wmc.3
        for <linux-btrfs@vger.kernel.org>; Tue, 16 Apr 2019 00:46:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brunner-ninja.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=16L6u0k3vnu+W+8RKYgKSs980JDZQGOL2YWlh+2QWBE=;
        b=Lxz2kEHsRm6Upax3zm6U70AEZ9XTBuU+tkA3YIpXFjuLXfGFfsvRJJ6IFP23iOO/kr
         mXtjdJZOrF7HQDTuarxICon0EBv31TYEXnveWwruoyjuxHUqb221i6vfwKrKL9YUWN0s
         ZAaOP5qEUwUlRTryiM6ybC+udG6/qLqbTXcMTD5Q7++X6girNmyRWxeMB4lUisVN/h0S
         MZATVOAXVzYeFNg8U5IWsnuIJL3p5xYo5y1Kup3HNbw1eX/3SUJ/UN5M+qZcKsLXQprD
         9t25K5zxv7soXhbwinkFlGtQ6lVRA5LhGBDU+pZDneGy4crFWT9EOA7HezMTkQ7BrYSP
         j0FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=16L6u0k3vnu+W+8RKYgKSs980JDZQGOL2YWlh+2QWBE=;
        b=BA5eZaZI1zJUmwrva/jqpnUmvITrnLQN+eNCqj4yjiaagSgw6brpVP9bulevFzVCTq
         waO3e2M5NTdiNlWmWp9DKjDpjOjudPnMFs+ded3bYYtuE8ELuRWEPJfDEOcJena4AztQ
         9DjigBjlDqqLn4sSb5R0Voe2qJdME9+Kn/R7gI/nGvGRXEEhH9H6YLqMsIf5bp0Xdw2q
         MlTmODdWs5H3H/rI82cOzfoc4AxBuzvKhB9L0/FgN09Qa4YJVVeeM/jpqI88hKbEh7IX
         naw8zbGF4L0lzBRK2W5uv5SZGNOsS1J9GHCIyA6nAzYwd+tleG5LsEQnUO5uEUOvYcAf
         IeVA==
X-Gm-Message-State: APjAAAVFoF+KS8vQW5RFuLvWqY/jJlenRLVjkh/iTxKZGQVv5EWJG+lb
        9alQE9oiuZbIYD0PZwQQzwfDVD9E/iZIv+7gWiZPQw==
X-Google-Smtp-Source: APXvYqxN24REfyr3ZPn91NBE9nxUAE4+SrMRLU+W4CM7ON9U0Wiexh2Ovw0KJ6jakx2MP8KJW5muVukDNpcjw5ynMlE=
X-Received: by 2002:a1c:1a53:: with SMTP id a80mr25456507wma.15.1555400810395;
 Tue, 16 Apr 2019 00:46:50 -0700 (PDT)
MIME-Version: 1.0
References: <CAD7Y51iQMJQiTBBW9AqQ_-aJ6A4fMVEswyNwPMYnj5iAaLOXjw@mail.gmail.com>
 <CAD7Y51jD5HDjDHWNZwycYYb2UHjuao_X4bTT2ATeMiX1gOUi_w@mail.gmail.com> <d762e0b9-034e-9386-3ecc-ee182493a82e@gmx.com>
In-Reply-To: <d762e0b9-034e-9386-3ecc-ee182493a82e@gmx.com>
From:   Daniel Brunner <daniel@brunner.ninja>
Date:   Tue, 16 Apr 2019 09:46:39 +0200
Message-ID: <CAD7Y51jX2x39tLaDOL9LcBxSmGecG92-Xytku0TWsU4B5d=EcA@mail.gmail.com>
Subject: Re: Corrupted files support needed
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi,

thanks for the quick response.

The filesystem went read-only on its own right at the first read error.
I unmounted all mounts and rebooted (just to be sure).

I ran the command you suggested with --progress
All output is flushed away with thousands of lines like those at the
end of the log paste.

Does it make sense to let it run until the end or can I assume that 2
drives are bad?
Also I checked SMART values but they seem to be ok.

https://0x0.st/zNg6.log

-- Daniel

Am Mo., 15. Apr. 2019 um 13:58 Uhr schrieb Qu Wenruo <quwenruo.btrfs@gmx.co=
m>:
>
>
>
> On 2019/4/15 =E4=B8=8B=E5=8D=887:44, Daniel Brunner wrote:
> > Hi,
> >
> > after normal a reboot I noticed that many files fail to open / read
> > (Input/Output error). I don't really have a backup of it (only
> > snapshots which also seem to be corrupted too).
> > The machine is remote, I can only ssh into it (at the moment). The
> > raid consists of 8x 10TB drives.
> >
> > System & Metadata is RAID1
> > Data is RAID6
> >
> > kernel is the most recent from arch linux repositories:
> > 5.0.7-arch1-1-ARCH #1 SMP PREEMPT Mon Apr 8 10:37:08 UTC 2019 x86_64 GN=
U/Linux
> >
> > Disk layout & usage:
> > https://0x0.st/zNBl.log
> >
> > Output of btrfs check:
> > https://0x0.st/zNJs.log
>
> Strange, btrfs check reports no error at all.
>
> Would you please try btrfs check unmounted just in case.
>
> >
> > Kernel messages:
> > http://cwillu.com:8080/84.115.44.105/2
>
> According to the dmesg, it looks like one device is bad, affecting both
> data and metadata.
>
> And thanks to recent RAID6 enhancement to try all possible mirror
> combination, it doesn't cause too many problem to metadata at least.
>
> Although data csum is not that good.
> Quite a lot of combination doesn't match checksum, and even more, some
> check doesn't exist in csum tree.
>
> An unmounted btrfs check is recommended.
> # btrfs check --check-data-csum --readonly
>
> This would be better than scrub.
>
> And please check the SMART info, some devices look suspicious.
>
> Also, please remount the fs read only at least to prevent further
> corruption.
>
> Thanks,
> Qu
>
> >
> > btrfs scrub is running but it seems like it will take weeks to finish..=
.
> >
> > Do you think my data is gone or is there anything I can try? An rsync
> > is already running, but every 5th file fails to read.
> >
> > Best regards,
> > Daniel
> >
>
