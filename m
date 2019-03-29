Return-Path: <SRS0=qcGt=SA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C127C43381
	for <linux-btrfs@archiver.kernel.org>; Fri, 29 Mar 2019 02:27:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E67752184E
	for <linux-btrfs@archiver.kernel.org>; Fri, 29 Mar 2019 02:27:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="qz9+LjCl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728555AbfC2C1s (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 28 Mar 2019 22:27:48 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:32996 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728547AbfC2C1s (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Mar 2019 22:27:48 -0400
Received: by mail-lf1-f68.google.com with SMTP id v14so381742lfi.0
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Mar 2019 19:27:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZOm3o3wtE5vyGyixHH6kt2T4clDbB2JACM9QpA6aKVc=;
        b=qz9+LjClCXPBOmZ7/YKOHdJD9H/oYsOKr3u6/561Lfw9O59Jm/GP/+5fIU6gcr6cWa
         cTtYWk3ooJKyh0r8ArgkzrAJftfdA3vBpnOV4y4ZY/qshllXBd3yQ/7MmGcxAV4Tck39
         N2/xpy8JCd4Mjaydsc31MLamaSpPA11SmuP1H33F+vKIOchZ8IWZ89eM/a/brKBI+MCz
         AkeJcX7bU41PhjNqieZQIycHNTxsUjHi1VBx5Gj1wDomrbZc998jot8kGTPdfiIPoDvO
         V+17Jf7t7yV/qeipl1BQcuyOwlZ5Oic9uV9npDlq99k7H9/JAqrRPNQAWp3osGDBNM1P
         Hj8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZOm3o3wtE5vyGyixHH6kt2T4clDbB2JACM9QpA6aKVc=;
        b=l2+YfMnSmhsrwP3Zpe5C9o+i7IBrLir6zwhK6fpmkPVijsl4QSmd57nr/RAtCevXt1
         /ScxojuqRqUR4IIt2eufs8bwNyaQ49eSPq2uCoRRs9r31XFj+F8i2JNwOw3GNXzjIokE
         KsvUfa16CcRo4rvzBgFomCfLWrjt7nSGEQ3pVzenr2lwVlBQD0gfKexv3k5abNVoPH9O
         /v/8P5YGBw8QG/116C/h/Y4sRACKE8oGMDYsLByImwAyBniB4+7luMr/J3KLhKS4zpTe
         COUA+6BtQqpTTqH02LLgUOa9gDgBtrXp49Zd8irA6zdYmqaUxPiGGiC0h5NLfjIfX2ie
         kKEQ==
X-Gm-Message-State: APjAAAXlUKQkeujYHcYhgGKDRCqAR9QEDExmUYCIOjGe5dbklDSi8PNL
        VtXUSx+XljkTVgwvETAOUvy/wbUgDULIFty8CAsnJg==
X-Google-Smtp-Source: APXvYqyNZdcTwkBeDagNFG2iYXpNzT6xkT5NYQv8KsBWfkde6H6Vr7uzo8N6VuqnJGaipER5mGuArL9DtzAEhGSRATI=
X-Received: by 2002:ac2:592f:: with SMTP id v15mr19021562lfi.133.1553826466056;
 Thu, 28 Mar 2019 19:27:46 -0700 (PDT)
MIME-Version: 1.0
References: <CAG3pWAmvekNpnBsQTaMrefKe6pvMSZjPm+SOxnKkMkpGO_1msQ@mail.gmail.com>
In-Reply-To: <CAG3pWAmvekNpnBsQTaMrefKe6pvMSZjPm+SOxnKkMkpGO_1msQ@mail.gmail.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Thu, 28 Mar 2019 20:27:34 -0600
Message-ID: <CAJCQCtQ3YFovgt4tFNQ+uLE81BiD0KFqPdvzE7Rxu+3wujWp2A@mail.gmail.com>
Subject: Re: help request for an unmountable raid1 filesystem
To:     Glenn Trigg <ggtrigg@gmail.com>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sat, Mar 9, 2019 at 2:36 PM Glenn Trigg <ggtrigg@gmail.com> wrote:

> I had some random machine freezing events which I suspected was due to
> issues with a raid1 filesystem and kernel module crashes.

Hard to say with available information. It's more likely hardware
related, and then there's on-disk corruption.


This:

> % mount -r /dev/sda1 /data
> mount: /data: can't read superblock on /dev/sda1.

and this:

> % btrfs rescue super-recover /dev/sda1
> All supers are valid, no need to recover

Seem in conflict. I don't really understand how the kernel complains
about a bad super and yet user space tools say they're all OK.  What
happens if you try:

# mount -o ro,nologreplay,usebackuproot

If that doesn't work, including kernel messages again, and also
include output from:

# btrfs insp dump-s -fa /dev/sda1
# btrfs insp dump-s -fa /dev/sdb1



>
> and dmesg says:
>
> [15944.017629] BTRFS info (device sda1): disk space caching is enabled
> [15944.017632] BTRFS info (device sda1): has skinny extents
> [15944.024480] BTRFS info (device sda1): bdev /dev/sda1 errs: wr 0, rd
> 0, flush 0, corrupt 1, gen 0
> [15944.024487] BTRFS info (device sda1): bdev /dev/sdb1 errs: wr 0, rd
> 0, flush 0, corrupt 4, gen 0
> [15944.029292] BTRFS error (device sda1): parent transid verify failed
> on 628168376320 wanted 37601 found 37700
> [15944.029466] BTRFS error (device sda1): parent transid verify failed
> on 628168376320 wanted 37601 found 37700

That's usually bad.


> Other system information is:
> % uname -a
> Linux izen 4.18.0-16-generic #17-Ubuntu SMP Fri Feb 8 00:06:57 UTC
> 2019 x86_64 x86_64 x86_64 GNU/Linux

It looks like extent tree corruption so I don't think it'll help to
use a newer kernel; but I'd try it anyway in the meantime until a
developer gets around to responding. Distro specific kernels tend to
be supported by that distribution where upstream lists tend to support
mainline. So I suggest 5.0.4, or 4.19.32, or you can be brave and
download this, image it to a USB stick (dd if=file of=/dev/ bs=1M
oflag=direct) which of course will erase everything on the stick.

https://kojipkgs.fedoraproject.org/compose/rawhide/Fedora-Rawhide-20190327.n.0/compose/Everything/x86_64/iso/Fedora-Everything-netinst-x86_64-Rawhide-20190327.n.0.iso

That might have 5.1rc2 on it, or something in between rc1 and rc2.
You're still going to try and mount it read-only per above command, so
even if it blows up it's not going to make this worse.


> % btrfs check /dev/sda1
> Checking filesystem on /dev/sda1
> UUID: d5e50511-3e31-4de6-ba37-c5841895be9f
> checking extents
> parent transid verify failed on 628168343552 wanted 28163 found 37700
> parent transid verify failed on 628168343552 wanted 28163 found 37700
> parent transid verify failed on 628168343552 wanted 28163 found 37700
> parent transid verify failed on 628168343552 wanted 28163 found 37700

The transid's are really far apart, definitely something went really
wrong. It could be hardware or both hardware and btrfs bug. That it
affected *both* copies is a little weird unless it's memory corruption
related, and then a lot of things can go wrong.


>
> Where do I go from here?

If it can't be mounted, then the only chance is `btrfs-find-tree` and
`btrfs restore` to try and scrape out whatever data you need that
isn't already backed up. The priority before trying to repair it, is
to get anything important off because trying to repair it has a good
chance of permanent data loss. Definitely the latest tools are
recommended for repair, kernel doesn't matter so much.


-- 
Chris Murphy
