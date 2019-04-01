Return-Path: <SRS0=hUT/=SD=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4967FC43381
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Apr 2019 05:48:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 13B1B20830
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Apr 2019 05:48:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YbTr6UWP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726961AbfDAFsQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 1 Apr 2019 01:48:16 -0400
Received: from mail-oi1-f177.google.com ([209.85.167.177]:44646 "EHLO
        mail-oi1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725860AbfDAFsP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Apr 2019 01:48:15 -0400
Received: by mail-oi1-f177.google.com with SMTP id i21so6227609oib.11
        for <linux-btrfs@vger.kernel.org>; Sun, 31 Mar 2019 22:48:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hHtiNpOh+zv1Ze9Rl4oCXTAO8cSFtj4QRNFSduBBQeM=;
        b=YbTr6UWPTGMqVQJjp1LCl4Fl5PSX5z6pic38PeGkRnc2Ek5ccGl341BWUxut9Uj2JP
         gYGuXIrLFS3GTnSBJOkkWfBzVbe6ZWv6d2W7XEkp2qwKhRrguwXyROSN8eUy9sxoNdnR
         nVBYaTqInhDKQKOnX3tsNIJkP4VW8hj3P3SDSyh3M7+i9TXGoIOdGgDan4eMA6tV1xRV
         cM54/EVFDqzzk6Kpn2dLUabnVG2g5rtV3T6jQHU4tVVPksJpNDCxm/eAjafEn8iHwumC
         86kcaLrQBXhqUGaWKIKVkP3tJlcx24dsgQ4co1E9jKGeeO9lKS7VaBwDrmKAf1BiSsZl
         62xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hHtiNpOh+zv1Ze9Rl4oCXTAO8cSFtj4QRNFSduBBQeM=;
        b=K3bRkL8bqwxwB5ahPXvAutPXzczGRzekO7Jvnav1YGP9y0uCZmel8FklrYWW4X+3e1
         PvCZ6Ozc4dHCGseFWSc5+7PSt0v71VThd/ff7YsD5m1LhLKw3FIoC6VmLJFPStbEF58K
         FTvVSTwxJz0XcQR0XNZyA1sxn2mTeWnABo1k6salkPPfnj0qMSTtiTyCAqayfgunX0/a
         I83WBHM0C0H6LeA3CBx0iZPTzALi7zLq9qHNRAC4BzcYtQiSzx6OaljPmcJnCE16Hz6r
         RXPlxnihmbJDGQnYweLg2ti8rHBbL9DecHqhiwJqMQHpPeDNPoTrV+WgEf+lfOEBf1GQ
         uqRg==
X-Gm-Message-State: APjAAAUWL8pvI8/UPnODfSfrn/NU6+C38USLeTyTBhVMvVLpsx5LbQu4
        P9rHJc6KxJN51pysGMmSE1VwBuYKufAHjAFajr4=
X-Google-Smtp-Source: APXvYqy9VKAYPRCxk1hOFPQjujglEZVkjDS6OvUUnJgVdKO/sGA7Uogaew4rgVFsh0btgAbDosdDSbjqxPgkdgXnXQU=
X-Received: by 2002:aca:5757:: with SMTP id l84mr12239096oib.155.1554097695246;
 Sun, 31 Mar 2019 22:48:15 -0700 (PDT)
MIME-Version: 1.0
References: <CAG3pWAmvekNpnBsQTaMrefKe6pvMSZjPm+SOxnKkMkpGO_1msQ@mail.gmail.com>
 <CAJCQCtQ3YFovgt4tFNQ+uLE81BiD0KFqPdvzE7Rxu+3wujWp2A@mail.gmail.com>
 <CAG3pWA=pzd+xxCrZ92b4TBw5iWtsHkfJQ4nsNrnqcBz_6dX4Hg@mail.gmail.com> <CAJCQCtTgfVY9g+A3m=FA_k0O-kbMGifz8QF62W2LMVmW_C8wnA@mail.gmail.com>
In-Reply-To: <CAJCQCtTgfVY9g+A3m=FA_k0O-kbMGifz8QF62W2LMVmW_C8wnA@mail.gmail.com>
From:   Glenn Trigg <ggtrigg@gmail.com>
Date:   Mon, 1 Apr 2019 16:48:04 +1100
Message-ID: <CAG3pWAkZdzD-W2HHd46bdyAzHwLdOt-t+LVXhWgV_bBkUmKBVg@mail.gmail.com>
Subject: Re: help request for an unmountable raid1 filesystem
To:     Chris Murphy <lists@colorremedies.com>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi Chris,

After booting the fedora usb stick (running rc2), I got the same results.

On Mon, 1 Apr 2019 at 08:35, Chris Murphy <lists@colorremedies.com> wrote:
>
> On Sat, Mar 30, 2019 at 5:43 PM Glenn Trigg <ggtrigg@gmail.com> wrote:
...
>
> I'm confused because "can't read superblock" isn't found in fs/btrfs.
> I'm only finding it in fs/gfs2/ops_fstype.c
>
> From what you provided, /dev/sda1 definitely has a valid btrfs
> superblock. I wonder if there's some other stale something or other on
> this partition?
>
> What do you get for
>
> $ sudo blkid

/dev/sda1: LABEL="data" UUID="d5e50511-3e31-4de6-ba37-c5841895be9f"
UUID_SUB="a28b0f34-f14d-492b-995b-2dd8a78ec9bb" TYPE="btrfs"
PARTUUID="efa240ec-01"
/dev/sdc1: LABEL="data" UUID="d5e50511-3e31-4de6-ba37-c5841895be9f"
UUID_SUB="d9c56d7a-21a1-4197-a701-5493392e1ae1" TYPE="btrfs"
PARTUUID="1aae1443-c03e-4509-ad06-124a64c4df4f"

> $ sudo wipefs -an /dev/sda1 /dev/sdc1

/dev/sda1: 8 bytes were erased at offset 0x00010040 (btrfs): 5f 42 48
52 66 53 5f 4d
/dev/sdc1: 8 bytes were erased at offset 0x00010040 (btrfs): 5f 42 48
52 66 53 5f 4d

> $ sudo mount -v -o ro,nologreplay,usebackuproot

mount: /data: can't read superblock on /dev/sda1.

and in dmesg...

[ 1045.029981] BTRFS info (device sda1): use lzo compression, level 0
[ 1045.029987] BTRFS info (device sda1): disabling log replay at mount time
[ 1045.029991] BTRFS info (device sda1): trying to use backup root at mount time
[ 1045.029992] BTRFS info (device sda1): disk space caching is enabled
[ 1045.029994] BTRFS info (device sda1): has skinny extents
[ 1045.127375] BTRFS info (device sda1): bdev /dev/sda1 errs: wr 0, rd
0, flush 0, corrupt 1, gen 0
[ 1045.127381] BTRFS info (device sda1): bdev /dev/sdc1 errs: wr 0, rd
0, flush 0, corrupt 4, gen 0
[ 1045.154198] BTRFS error (device sda1): parent transid verify failed
on 628168376320 wanted 37601 found 37712
[ 1045.178310] BTRFS error (device sda1): parent transid verify failed
on 628168376320 wanted 37601 found 37712

I.e. the same as before. It's puzzling!

Regards,
Glenn

>
> --
> Chris Murphy
