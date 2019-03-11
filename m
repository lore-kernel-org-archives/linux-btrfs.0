Return-Path: <SRS0=TRLW=RO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D9A7C4360F
	for <linux-btrfs@archiver.kernel.org>; Mon, 11 Mar 2019 05:19:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 330C3206DF
	for <linux-btrfs@archiver.kernel.org>; Mon, 11 Mar 2019 05:19:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="xDzYX1OP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725891AbfCKFTd (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 11 Mar 2019 01:19:33 -0400
Received: from mail-lj1-f177.google.com ([209.85.208.177]:39022 "EHLO
        mail-lj1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725850AbfCKFTd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Mar 2019 01:19:33 -0400
Received: by mail-lj1-f177.google.com with SMTP id g80so2836968ljg.6
        for <linux-btrfs@vger.kernel.org>; Sun, 10 Mar 2019 22:19:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=d6r7v+rdVa9HC+A+Zd/v/QQ/GJ/P/innmsfdz83fGjQ=;
        b=xDzYX1OPdgT1lcEyQaG/U/na7v8Jt5d/4GIUla03Shsn7ZY+yRijp6YfWGdkLxhzm5
         vdNt0CT/HWjBIJbfzsVMXsIexYtlUHO8zAWod03DAKvcZ0AzVfSTaOXY7MICAPRM5EmA
         RSKXGgCJ+0HyGwwsW4QWM9hWvbvT41fQrwhwJM2gLFau3ayjmTE3PWQhYmsUB5czguMk
         pKV3dfKPAxSo/F70Z7Dy61Qmvl24n9kEyrjerOqOP1xl6X+M0aJReX+JbPfkVwxamMay
         o8mVZsKKznoQvsUseeZy14AuIjdnDvQQGh2HtG/gN996g+z1xept2MIlbgY41w8x9kNI
         hEhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=d6r7v+rdVa9HC+A+Zd/v/QQ/GJ/P/innmsfdz83fGjQ=;
        b=b0YW31GL0sSNCq7cLm/4ai1PXJjIVfN80Y2ajinlMmnHbK2oQApvZvXsttqAndfSzv
         IFk4R6pKWPg6MtXuArcgBOEswNcGlbvCen1/tT8hslUBBydCyxK9O0H2XrAxoBBF+p14
         EiEwQPuVRHwbqj/ZhXDBE+55rmzu2XlSYZtT+jphZCge2JDryEsiic/00rhrtqpg1TO6
         IISjIvWz5zf7FMjvj1NK4Id2U8hxjk6Rdnq1ghLMUMvpfA1s49u2WnfBU9aRe/7yIuwE
         bHunBCHzcCQElSZvJ8Vmat4ZvDhSSd3hlVlMbGBiJo8MHy+0tp3duLqDC5ZzQYf1BYq8
         k3Tg==
X-Gm-Message-State: APjAAAUa7pkVzGOAmLQV4AAJQ0yhwEvmmjq0U7URFpahXbxJ3z54Q09J
        yMlrXrWYc6EbHB1SgYP7m5DwkEnGZ8zQ0S32dDWw2JGiL+o=
X-Google-Smtp-Source: APXvYqxQ5Y7fN4fHm36n+mOEaKs/VLaRhlHYGnQvv/rKrznehctsl5uxXwTxHiavnoJHyfCqBEKQaGXB9jJ85a00qt8=
X-Received: by 2002:a2e:8701:: with SMTP id m1mr15263664lji.132.1552281570829;
 Sun, 10 Mar 2019 22:19:30 -0700 (PDT)
MIME-Version: 1.0
References: <CAJCQCtQ9nduarOggGv98Oxo6SE9QBKhm7oxYXFE9UsMbVTnwow@mail.gmail.com>
 <cf8922ef-b7db-7779-c140-80090efc60d5@gmx.com> <CAJCQCtRVT9Fpy0Knj44m0BN80d-PidUfHPJ0d9VJkag7B-KXTQ@mail.gmail.com>
 <2621cc31-0d74-f514-fae4-fea35e34fae3@gmx.com>
In-Reply-To: <2621cc31-0d74-f514-fae4-fea35e34fae3@gmx.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Sun, 10 Mar 2019 23:19:19 -0600
Message-ID: <CAJCQCtQC0piAP7BLHHwm2kgAn7Rpu=-tqFn-vi7jECS3X-8J1w@mail.gmail.com>
Subject: Re: confusing behavior when supers mismatch
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sun, Mar 10, 2019 at 10:58 PM Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>
> Normally 'btrfs rescue super' should be enough for accidentally wiped btrfs.
>
> If not, then we should fix it of course.

Looks like a bug then.

$ sudo mkfs.btrfs /dev/mapper/vg-f30test
btrfs-progs v4.20.2
See http://btrfs.wiki.kernel.org for more information.

Label:              (null)
UUID:               e819e675-a697-45f8-8351-d109d5b95514
Node size:          16384
Sector size:        4096
Filesystem size:    100.00GiB
Block group profiles:
  Data:             single            8.00MiB
  Metadata:         DUP               1.00GiB
  System:           DUP               8.00MiB
SSD detected:       no
Incompat features:  extref, skinny-metadata
Number of devices:  1
Devices:
   ID        SIZE  PATH
    1   100.00GiB  /dev/mapper/vg-f30test

$ sudo mount /dev/mapper/vg-f30test /mnt/test
$ sudo umount /mnt/test
$ sudo wipefs -a /dev/mapper/vg-f30test
/dev/mapper/vg-f30test: 8 bytes were erased at offset 0x00010040
(btrfs): 5f 42 48 52 66 53 5f 4d
$ sudo btrfs rescue super -v /dev/mapper/vg-f30test
No valid Btrfs found on /dev/mapper/vg-f30test
Usage or syntax errors
$ echo "_BHRfS_M" | sudo dd bs=1 count=8 of=/dev/mapper/vg-f30test
seek=$((64*1024+64))
8+0 records in
8+0 records out
8 bytes copied, 0.00523996 s, 1.5 kB/s
$ sudo btrfs rescue super -v /dev/mapper/vg-f30test
All Devices:
        Device: id = 1, name = /dev/mapper/vg-f30test

Before Recovering:
        [All good supers]:
                device name = /dev/mapper/vg-f30test
                superblock bytenr = 65536

                device name = /dev/mapper/vg-f30test
                superblock bytenr = 67108864

        [All bad supers]:

All supers are valid, no need to recover
$

-- 
Chris Murphy
