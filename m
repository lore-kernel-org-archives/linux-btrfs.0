Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:46468 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728162AbeIEUbs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 5 Sep 2018 16:31:48 -0400
Received: by mail-oi0-f66.google.com with SMTP id y207-v6so14538365oie.13
        for <linux-btrfs@vger.kernel.org>; Wed, 05 Sep 2018 09:00:58 -0700 (PDT)
MIME-Version: 1.0
References: <20180824043139.GA8263@giis.co.in>
In-Reply-To: <20180824043139.GA8263@giis.co.in>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Wed, 5 Sep 2018 19:00:21 +0300
Message-ID: <CAGqmi74eMiHe7HK_oueaj0JZmy1Kp1NoOCrU0yheEE8MjngLKA@mail.gmail.com>
Subject: Re: dduper - Offline btrfs deduplication tool
To: lakshmipathi.g@giis.co.in
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

пт, 24 авг. 2018 г. в 7:41, Lakshmipathi.G <lakshmipathi.g@giis.co.in>:
>
> Hi -
>
> dduper is an offline dedupe tool. Instead of reading whole file blocks and
> computing checksum, It works by fetching checksum from BTRFS csum tree. This
> hugely improves the performance.
>
> dduper works like:
>         - Read csum for given two files.
>         - Find matching location.
>         - Pass the location to ioctl_ficlonerange directly
>           instead of ioctl_fideduperange
>
> By default, dduper adds safty check to above steps by creating a
> backup reflink file and compares the md5sum after dedupe.
> If the backup file matches new deduped file, then backup file is
> removed. You can skip this check by passing --skip option. Here is
> sample cli usage [1] and quick demo [2]
>
> Some performance numbers: (with -skip option)
>
> Dedupe two 1GB files with same  content - 1.2 seconds
> Dedupe two 5GB files with same  content - 8.2 seconds
> Dedupe two 10GB files with same  content - 13.8 seconds
>
> dduper requires `btrfs inspect-internal dump-csum` command, you can use
> this branch [3] or apply patch by yourself [4]
>
> [1] https://gitlab.collabora.com/laks/btrfs-progs/blob/dump_csum/Documentation/dduper_usage.md
> [2] http://giis.co.in/btrfs_dedupe.gif
> [3] git clone https://gitlab.collabora.com/laks/btrfs-progs.git -b  dump_csum
> [4] https://patchwork.kernel.org/patch/10540229/
>
> Please remember its version-0.1, so test it out, if you plan to use dduper real data.
> Let me know, if you have suggestions or feedback or bugs :)
>
> Cheers.
> Lakshmipathi.G
>

One question:
Why not ioctl_fideduperange?
i.e. you kill most of benefits from that ioctl - atomicity.


-- 
Have a nice day,
Timofey.
