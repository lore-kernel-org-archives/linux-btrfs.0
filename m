Return-Path: <SRS0=H1hn=QQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DE6DC282C4
	for <linux-btrfs@archiver.kernel.org>; Sat,  9 Feb 2019 10:36:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F1B9217D8
	for <linux-btrfs@archiver.kernel.org>; Sat,  9 Feb 2019 10:36:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tDl/pSri"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726994AbfBIKgG (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 9 Feb 2019 05:36:06 -0500
Received: from mail-wm1-f50.google.com ([209.85.128.50]:35551 "EHLO
        mail-wm1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726722AbfBIKgF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 9 Feb 2019 05:36:05 -0500
Received: by mail-wm1-f50.google.com with SMTP id t200so7721191wmt.0
        for <linux-btrfs@vger.kernel.org>; Sat, 09 Feb 2019 02:36:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:from:subject:openpgp:autocrypt:message-id:date:user-agent
         :mime-version:content-transfer-encoding:content-language;
        bh=iMlw/eyXxSnRM9t8lb+8Jx9xlmZlj9YRhSnSil5v4qY=;
        b=tDl/pSrir8Avc+7DccMJu4f7wk0A/h1qkb42GoxAquHnNywcG6yZlGAnocFsWyIh/s
         GfE0Pa8kE5+5074pP7hPegCCDhkcxJuLZ8NPhhYaOtrF3wRYleVfa91iYLLWzGVVgsJ6
         lR3KCtw5RewqvydK4eq59oRpTHrmAl8oluSwxONzpINqoIPcu+gdUK/r6ivUIM3Zcq/b
         z+L1KF8iXP30LRi9MYjpWpvtu3sHrEaVwfz589qpZkH7VLD5g2G3lATtIW5t4izik5zN
         2peUxqv0Ifb8JPZPhP8ovKKDP5hAEaF4vqfK2JyssSeyUaH+GDrfXwZ3xvBFNIxSXjBT
         vwUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:openpgp:autocrypt:message-id
         :date:user-agent:mime-version:content-transfer-encoding
         :content-language;
        bh=iMlw/eyXxSnRM9t8lb+8Jx9xlmZlj9YRhSnSil5v4qY=;
        b=qk+3nNDpCJlM5rdg7XJS9rPqwruGHeNvVyLp83WmtQsD5ecJxrgLm9jQGDg5UUAZ38
         DO5uvtH6tqW1myK7sEfLad0Oix/0P7WXa8bI/q9JtGnl5NA50PzI4/AcbB5L9upBGIRA
         GtPkdNhmG5xOq7ne8Rl0XU9jMaAQIbkgF9UraBsiXEwa4jYB77kt6v1Yn4FXcCyLMdNE
         5300I3W95qDtmkdUDzZE85S9ILekoXKWRhiejFVRvlTcJcjeaM8WIFiOceYNFzB22MG5
         cdLugOkix1jbBE4QcFNod3bi5HnhFGvR2kmnQd1WkNUcNZ6kZ4aTaBftwpS3FZTdV9ar
         h+cQ==
X-Gm-Message-State: AHQUAuagRdkfdxPxJ9td5lPoOL50wajtcIEB5lhrO6pgUk55Kuxtk61c
        FHAiZmv7gHlUm8QmONk3CQQ1RcU=
X-Google-Smtp-Source: AHgI3IYN6Or1aSb87qPuaWCfBmiilhBqRmoHR0zm2cyC1NzU5tcWYczzsMeIwUNRB2dZbKNo9c63bQ==
X-Received: by 2002:adf:f78e:: with SMTP id q14mr7934294wrp.227.1549708563908;
        Sat, 09 Feb 2019 02:36:03 -0800 (PST)
Received: from [192.168.178.53] (ip2505f80d.dynamic.kabel-deutschland.de. [37.5.248.13])
        by smtp.googlemail.com with ESMTPSA id 62sm1100938wra.46.2019.02.09.02.36.02
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Sat, 09 Feb 2019 02:36:03 -0800 (PST)
To:     linux-btrfs@vger.kernel.org
From:   =?UTF-8?Q?Jakob_Sch=c3=b6ttl?= <jschoett@gmail.com>
Subject: Cannot 'mount -o degraded /dev/replacement' after a replace
Openpgp: preference=signencrypt
Autocrypt: addr=jschoett@gmail.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <2efee604-e44c-b00b-2ea8-d13ebc8c6355@gmail.com>
Date:   Sat, 9 Feb 2019 11:36:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: de-DE
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi,

I've setup a RAID1 with two disks (disk1 and disk2) and I'm testing the 
btrfs replace command.

After replacing disk2 with disk3, I can only mount
(a) disk1 or disk3 (if both disk are plugged) and
(b) the original disk1 (degraded, if disk3 is unplugged).

I cannot mount the replacement disk3 if disk1 is unplugged.

 > mount: /mnt: wrong fs type, bad option, bad superblock on /dev/loop3, 
missing codepage or helper program, or other error.

What I expect is that both disk1 and disk3 are fully valid and working 
after a replace.

Steps to reproduce:

   dd if=/dev/zero of=/vdisk1 bs=1024 count=300000
   losetup /dev/loop1 /vdisk1
   dd if=/dev/zero of=/vdisk2 bs=1024 count=300000
   losetup /dev/loop2 /vdisk2
   dd if=/dev/zero of=/vdisk3 bs=1024 count=300000
   # losetup /dev/loop3 /vdisk3    # don't plug this device yet

Create RAID1 file system:

   mkfs.btrfs -L datavol -m raid1 -d raid1 /dev/loop1 /dev/loop2

Unplug device 2 to simulate a defect:

   losetup -d /dev/loop2

Plug device 3:

   losetup /dev/loop3 /vdisk3

Replace device 2 with device 3:

   mount -o degraded /dev/loop1 /mnt
   btrfs filesystem show   # to get devid of device 2
   btrfs replace start -Br 2 /dev/loop3 /mnt
   btrfs replace status /mnt   # check success
   umount /mnt

Unplug the original device 1 to see if device 3 has really replaced 
device 2:

   losetup -d /dev/loop1
   mount -o degraded /dev/loop3 /mnt

The mount fails with this error:

 > mount: /mnt: wrong fs type, bad option, bad superblock on /dev/loop3, 
missing codepage or helper program, or other error.

In this situation, btrfs device scan does not change anything and btrfs
filesystem show shows:

 > warning, device 1 is missing
 > warning, device 1 is missing
 > warning, device 1 is missing
 > warning, device 1 is missing
 > bad tree block 198180864, bytenr mismatch, want=198180864, have=0
 > ERROR: cannot read chunk root
 > Label: 'datavol'  uuid: 640e45d3-e741-4a78-a24e-2d8a41c6b8c3
 >     Total devices 2 FS bytes used 128.00KiB
 >     devid    2 size 292.97MiB used 104.00MiB path /dev/loop3
 >     *** Some devices missing

Is this a known problem? Can you reproduce it? Am I doing something wrong?

Regards, Jakob

