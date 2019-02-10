Return-Path: <SRS0=C9fc=QR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0364C282C2
	for <linux-btrfs@archiver.kernel.org>; Sun, 10 Feb 2019 10:35:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B241820874
	for <linux-btrfs@archiver.kernel.org>; Sun, 10 Feb 2019 10:35:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FeB6zYIX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725999AbfBJKfT (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 10 Feb 2019 05:35:19 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:39176 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725950AbfBJKfT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 10 Feb 2019 05:35:19 -0500
Received: by mail-pf1-f196.google.com with SMTP id f132so3842008pfa.6
        for <linux-btrfs@vger.kernel.org>; Sun, 10 Feb 2019 02:35:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=b8C9BpVJkigziz0qUnZLeVDhngaztt/sq17gSrQrWg4=;
        b=FeB6zYIXbRA/MGwikxGjIV47v+zTWXYnrtJSpHwA4jwkyPJ5jgVJb/mpb6x75yLigG
         7j16eoMk6kUUJ/6Spiii0xnTXwPeZZ1GwWQOw6C6gA65Ln9SIYzCflSVwC9PDFcX59wO
         jifMBz0Ngi4ojDSprBdpQzqg15O0wFnZpuDOsjl/1qoHLsrBKLMqqxVL/amrQPnaQ7cb
         6wqjm1uuGjkwYYrDb367C6Aj16rEbJ9UZv+F1t6TGL9jRTczvivcuW83seiV9j6aYVF7
         E6QOjLgvl/ugQBuKS+JGgwOiYpUBL4kmnt+qLLSRpFSGAFTkfLXWkHMlhCD1KpX8XHHV
         CoEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=b8C9BpVJkigziz0qUnZLeVDhngaztt/sq17gSrQrWg4=;
        b=LaDSMfpmmcueCQCkXcjIcvSYkrusUoc/VrMY3U//tN6EfOgi4xpXxZ32tEKhERAZ6M
         6b1laspggwnn0+/a30Si/H+eM3FVs0hKVaUCVmC2WGSO4d1KMs0rQScGqHe/BAwQp589
         uf7aZDVCnJPfe4ezu+iaaHaj/jUjV3ZNbhP5QVPnly/GqEcAmnzGLYd2Mdgv2PtfKkPb
         j8Lkoa40gqck+rEXmOnkixV/U60qynJcz693KxVdwVUeijLNHEt8zLPswTMtWXMipqDw
         jyFmiXcVHjUzaKiZpOijmrG+kOcz2XRN2DoxHTVAj6stgeHIoRUvihrvAvEb6G14z1JX
         bWKg==
X-Gm-Message-State: AHQUAubEVb0f7L3X6OYY3zp/ai7TksdAdbCGiGcIS2GlubSrX2CwYM/k
        mywbV/WmbpF8WFmj/hG0zimwrqWrPjgmD1MgC9KDdALWEDY=
X-Google-Smtp-Source: AHgI3IbrqM1uMb38NqUE9BA90wVaZOAEfB7Zxj3lyE5biRCrCVaO8iye+HYNEBKcBi4O6gUkMMCV9efiZLPkT6Cf5kY=
X-Received: by 2002:a63:5c41:: with SMTP id n1mr12676262pgm.1.1549794918038;
 Sun, 10 Feb 2019 02:35:18 -0800 (PST)
MIME-Version: 1.0
References: <1690578645.233565651.1549781791550.JavaMail.zimbra@shaw.ca>
In-Reply-To: <1690578645.233565651.1549781791550.JavaMail.zimbra@shaw.ca>
From:   Thiago Ramon <thiagoramon@gmail.com>
Date:   Sun, 10 Feb 2019 08:35:06 -0200
Message-ID: <CAO1Y9wr7WA1PS+3cvyPBKGgd-_Xf-nnesWhLvmgV83_XTa7RUA@mail.gmail.com>
Subject: Re: corruption with multi-device btrfs + single bcache, won't mount
To:     STEVE LEUNG <sjleung@shaw.ca>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sun, Feb 10, 2019 at 5:07 AM STEVE LEUNG <sjleung@shaw.ca> wrote:
>
> Hi all,
>
> I decided to try something a bit crazy, and try multi-device raid1 btrfs on
> top of dm-crypt and bcache.  That is:
>
>   btrfs -> dm-crypt -> bcache -> physical disks
>
> I have a single cache device in front of 4 disks.  Maybe this wasn't
> that good of an idea, because the filesystem went read-only a few
> days after setting it up, and now it won't mount.  I'd been running
> btrfs on top of 4 dm-crypt-ed disks for some time without any
> problems, and only added bcache (taking one device out at a time,
> converting it over, adding it back) recently.
>
> This was on Arch Linux x86-64, kernel 4.20.1.
>
> dmesg from a mount attempt (using -o usebackuproot,nospace_cache,clear_cache):
>
>   [  267.355024] BTRFS info (device dm-5): trying to use backup root at mount time
>   [  267.355027] BTRFS info (device dm-5): force clearing of disk cache
>   [  267.355030] BTRFS info (device dm-5): disabling disk space caching
>   [  267.355032] BTRFS info (device dm-5): has skinny extents
>   [  271.446808] BTRFS error (device dm-5): parent transid verify failed on 13069706166272 wanted 4196588 found 4196585
>   [  271.447485] BTRFS error (device dm-5): parent transid verify failed on 13069706166272 wanted 4196588 found 4196585
>   [  271.447491] BTRFS error (device dm-5): failed to read block groups: -5
>   [  271.455868] BTRFS error (device dm-5): open_ctree failed
>
> btrfs check:
>
>   parent transid verify failed on 13069706166272 wanted 4196588 found 4196585
>   parent transid verify failed on 13069706166272 wanted 4196588 found 4196585
>   parent transid verify failed on 13069706166272 wanted 4196588 found 4196585
>   parent transid verify failed on 13069706166272 wanted 4196588 found 4196585
>   Ignoring transid failure
>   ERROR: child eb corrupted: parent bytenr=13069708722176 item=7 parent level=2 child level=0
>   ERROR: cannot open file system
>
> Any simple fix for the filesystem?  It'd be nice to recover the data
> that's hopefully still intact.  I have some backups that I can dust
> off if it really comes down to it, but it's more convenient to
> recover the data in-place.
>
> This is complete speculation, but I do wonder if having the single
> cache device for multiple btrfs disks triggered the problem.
No, having a single cache device with multiple backing devices is the
most common way to use bcache. I've used a setup similar to yours for
a couple of years without problems (until it broke down recently due
to other issues).

Your current filesystem is probably too damaged to properly repair
right now (some other people here might be able to help with that),
but you probably haven't lost much of what's in there. You can dump
the files out with "btrfs restore", or you can use a patch to allow
you to mount the damaged filesystem read-only
(https://patchwork.kernel.org/patch/10738583/).

But before you try to restore anything, can you go back in your kernel
logs and check for errors? Either one of your devices is failing, you
might have physical link issues or bad memory. Even with a complex
setup like this you shouldn't be getting random corruption like this.

>
> Thanks for any assistance.
>
> Steve
