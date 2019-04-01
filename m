Return-Path: <SRS0=hUT/=SD=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0161BC10F05
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Apr 2019 17:15:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C4FC52133D
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Apr 2019 17:15:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="BdyoRPkf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730843AbfDARPA (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 1 Apr 2019 13:15:00 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:46232 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730834AbfDARO7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Apr 2019 13:14:59 -0400
Received: by mail-lj1-f193.google.com with SMTP id h21so8878315ljk.13
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Apr 2019 10:14:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=5e5yXmgyV72YxOst2KCeep4bv8N996HcZLxTHWo96Jg=;
        b=BdyoRPkf4AYcM+HZS22zOZQF/d96UktcRWVb3Z8RVJKh74M9YT+KdeHRI2ECgvlwEg
         ihZzdx/Nz1wJc5ssHIlfPQd2uE/yUj6F/eI8SfzCHMfy6JG5gU6kk6EuhczaLh2KqFIa
         KGvwPo52HnkJlWYd9t0u2zRqM9enetR8FH9hwYMLvqLQNiXr7+gudxtl1obMJs9FTxeH
         iEObmhNq1N6s3Ex163fI+AM6X9wr1EUf/kdyw7N3VEkfRClKgBNwTSxhy6wJF69tS9u1
         5YxlxccPUnJfRuwXP2BFLH1CG824BDf2HuvIs8W5dSwBLMKdtqvEMx/5sqeUe25uDYRj
         xzlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=5e5yXmgyV72YxOst2KCeep4bv8N996HcZLxTHWo96Jg=;
        b=QUewU1hhDdkckk/BHqq4CyFrNUDlONGg53XnPR9ITTG06KgsmViwU4GlrX4AqKnu8U
         6v9U4/TYOtlp3SgPtCXhAoPE/y5ft+zjBl5PpaWpAo9mM7IvIDapmlJtJ9ikpcrI+Dxa
         rkAWbp4ZxgqaFuTzqufRajFckKxglQ7kH6iio8Nf28ZZxS2NQGOi9OqwcxhhhS7HfUTo
         MpRnqejAIb2MpNz8jKLKllGwfJoSEL7U+a04Ga2BqQW5xgyaO7RZ2XGCMwjLvLnd9l/z
         A4c86aEfMfMWZKHu2khRAwqnE4hI7UXg34bAjt4yWBoWAFNWM20zHdOPWB8qqkQlDGyq
         9zbw==
X-Gm-Message-State: APjAAAWOfvK891etkssWYbuzqIg8XyKSJdEFyIXk2/HnAqLM7bx62a4I
        8RsD/vbFaKazSZAZgsndvPNRDj9sTpbuuxFuyqx34jvoRtE=
X-Google-Smtp-Source: APXvYqwdiLct0HQLu325iwozF/KBwxxbry76fSfBFtKBtjD9ATKPYVHuyNKSGKCYKFrxdQGH94bYc06YRruUchhaeM0=
X-Received: by 2002:a2e:99d2:: with SMTP id l18mr27006091ljj.27.1554138897186;
 Mon, 01 Apr 2019 10:14:57 -0700 (PDT)
MIME-Version: 1.0
References: <CAG3pWAmvekNpnBsQTaMrefKe6pvMSZjPm+SOxnKkMkpGO_1msQ@mail.gmail.com>
 <CAJCQCtQ3YFovgt4tFNQ+uLE81BiD0KFqPdvzE7Rxu+3wujWp2A@mail.gmail.com>
 <CAG3pWA=pzd+xxCrZ92b4TBw5iWtsHkfJQ4nsNrnqcBz_6dX4Hg@mail.gmail.com>
 <CAJCQCtTgfVY9g+A3m=FA_k0O-kbMGifz8QF62W2LMVmW_C8wnA@mail.gmail.com> <CAG3pWAkZdzD-W2HHd46bdyAzHwLdOt-t+LVXhWgV_bBkUmKBVg@mail.gmail.com>
In-Reply-To: <CAG3pWAkZdzD-W2HHd46bdyAzHwLdOt-t+LVXhWgV_bBkUmKBVg@mail.gmail.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Mon, 1 Apr 2019 11:14:45 -0600
Message-ID: <CAJCQCtQs_oBAXB4UzY1xGuZatqrCb0=+3y9g8T2f2v+6eEg9RQ@mail.gmail.com>
Subject: Re: help request for an unmountable raid1 filesystem
To:     Glenn Trigg <ggtrigg@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sun, Mar 31, 2019 at 11:48 PM Glenn Trigg <ggtrigg@gmail.com> wrote:
>
> Hi Chris,
>
> After booting the fedora usb stick (running rc2), I got the same results.
>
> On Mon, 1 Apr 2019 at 08:35, Chris Murphy <lists@colorremedies.com> wrote:
> >
> > On Sat, Mar 30, 2019 at 5:43 PM Glenn Trigg <ggtrigg@gmail.com> wrote:
> ...
> >
> > I'm confused because "can't read superblock" isn't found in fs/btrfs.
> > I'm only finding it in fs/gfs2/ops_fstype.c
> >
> > From what you provided, /dev/sda1 definitely has a valid btrfs
> > superblock. I wonder if there's some other stale something or other on
> > this partition?
> >
> > What do you get for
> >
> > $ sudo blkid
>
> /dev/sda1: LABEL="data" UUID="d5e50511-3e31-4de6-ba37-c5841895be9f"
> UUID_SUB="a28b0f34-f14d-492b-995b-2dd8a78ec9bb" TYPE="btrfs"
> PARTUUID="efa240ec-01"
> /dev/sdc1: LABEL="data" UUID="d5e50511-3e31-4de6-ba37-c5841895be9f"
> UUID_SUB="d9c56d7a-21a1-4197-a701-5493392e1ae1" TYPE="btrfs"
> PARTUUID="1aae1443-c03e-4509-ad06-124a64c4df4f"
>
> > $ sudo wipefs -an /dev/sda1 /dev/sdc1
>
> /dev/sda1: 8 bytes were erased at offset 0x00010040 (btrfs): 5f 42 48
> 52 66 53 5f 4d
> /dev/sdc1: 8 bytes were erased at offset 0x00010040 (btrfs): 5f 42 48
> 52 66 53 5f 4d
>
> > $ sudo mount -v -o ro,nologreplay,usebackuproot
>
> mount: /data: can't read superblock on /dev/sda1.
>

That is the sort of error I'd expect if the device were in fstab to be
mounted at /data. But you're running this mount command while booted
from the Fedora USB stick? I'm pretty lost at this point.

Anyway, your best bet is to scrape with `btrfs restore` and then move
on, i.e. start over with a new file system. Right now I have no
confidence in the repair tools, but maybe a developer will come along
and offer some different advice on additional steps. For sure any of
the user space repair options are a last resort. There should be a
btrfs-progs 5.0 soon that is supposed to be safer, and might be worth
a shot. But I think it's a coin toss.


-- 
Chris Murphy
