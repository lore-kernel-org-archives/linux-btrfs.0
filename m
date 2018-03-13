Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f169.google.com ([209.85.223.169]:45811 "EHLO
        mail-io0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752030AbeCMNTj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Mar 2018 09:19:39 -0400
Received: by mail-io0-f169.google.com with SMTP id m22so38291iob.12
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Mar 2018 06:19:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAHS0cb_77AcDUyV1iPAMN-CkYfOx_d4ZhSzhrKB=-ZVBU4jWYQ@mail.gmail.com>
References: <CAHS0cb_Pp8z5d_iKKX8MsDX5ixxVQLMyu94eir_a-AJsnhzqUQ@mail.gmail.com>
 <CAHS0cb_77AcDUyV1iPAMN-CkYfOx_d4ZhSzhrKB=-ZVBU4jWYQ@mail.gmail.com>
From: Valerio Pachera <sirio81@gmail.com>
Date: Tue, 13 Mar 2018 14:19:38 +0100
Message-ID: <CAHS0cb85KnE4K6EOjYbREtkQNGhD1bCord7qV=VTPdtqF4YdWA@mail.gmail.com>
Subject: Re: Used space discrepancy
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Today I've been updating the kernel and btrfs-progs to jessie
backports and rebooted the server.
There seems to not be usefull info in dmesg

dmesg | grep -i btrfs
[    4.702295] Btrfs loaded, crc32c=crc32c-generic
[    8.371792] BTRFS: device fsid f0a8ff89-608e-4ca2-bde9-8dc09b91accf
devid 1 transid 61700 /dev/dm-1
[    8.485413] BTRFS info (device dm-1): disk space caching is enabled
