Return-Path: <SRS0=oOJ3=QZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E44F8C43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Feb 2019 20:25:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9C31D217F5
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Feb 2019 20:25:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="XdLt49B7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728212AbfBRUZ3 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 18 Feb 2019 15:25:29 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:41972 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727682AbfBRUZ3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Feb 2019 15:25:29 -0500
Received: by mail-lj1-f196.google.com with SMTP id z25so7644377ljk.8
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Feb 2019 12:25:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=maioOt6lPiKu/wbFxT6G+3bjMEDCJqhcpA5NIPuwDkM=;
        b=XdLt49B7GVNR4A4xGPTYUV+2PohcXadCaXcGrFKbf7sveUv0rhsB39ojUaGaV/vxJr
         TKtCbXqDERHELkSdN+U/nKirPJNXiQhymcScnxzkYKsMRwJiKL/TKfwkDHWkQoS9PRnO
         QYEPtGzNbUkL9anM5DOQqP+y74LsIvALb3bRv0yaSNdsp7ILdAtyB/kuVEEYXddbde0D
         NjhaUSMf+V5BwMzToEsX+nKoHyrbXsvU43AYg9LSucMOLYxDMNaUQYIbZrU4Z8mERdJj
         7UPMh7P5jVWwFifNPEELmxLBg3UFc3p5Fo8C01x8d3ytjFuLsnbLI6WCNaLBXLWVbP4t
         ZCXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=maioOt6lPiKu/wbFxT6G+3bjMEDCJqhcpA5NIPuwDkM=;
        b=r66Ipy49CI86FN2FXYvANf7gkmHVP8CqWAEXR6gF8stTCxSGXTmkk+NlKI3zDKZ4S3
         kfJiIyI9iXfaqa8KkFdnG0/F2QHlbXQPc/UxMvnB2W0sHE3tfsl0zVrPtf4E9aefuFTh
         5DRZQVG0ZBxVjn4qpEA/3MNCKESscNBdoLqQYE0fpG8M8nIVybNIFsMp8cx6u3c2d3tI
         6AZQN1PjHyPxCtiYXwzVRrE6X6wlxIo9xTVMWXYF8f2GXZ0AiM/JkdL4sDTuKeLqGUNc
         JVMsidLsh6yEfYOX/5OyldditALtYn5dlAHvKpzauaqRF+XOh+rwwMQ+9fEmAFfJ0F2q
         9hFA==
X-Gm-Message-State: AHQUAuaYBvk1J7sXAtrwCvBlcGgSbeMxTvesGDR488TO37qtfY80L+K4
        APWxEg8VrucV4XNNuGZ7pKq6IWXtvBk4QzkDqJw+ggOQEHc=
X-Google-Smtp-Source: AHgI3IYV7w7HPAmJuB1qzz+VFrG2ZS7Qb3+qM4PB89nuMeTq3zVFXhBDiizNKMkNfSbp+vAfnPWkZRVRgaqmBgbnr7c=
X-Received: by 2002:a2e:63c3:: with SMTP id s64mr3895194lje.121.1550521526963;
 Mon, 18 Feb 2019 12:25:26 -0800 (PST)
MIME-Version: 1.0
References: <1788794.QoebbjtCvL@t460-skr>
In-Reply-To: <1788794.QoebbjtCvL@t460-skr>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Mon, 18 Feb 2019 13:25:15 -0700
Message-ID: <CAJCQCtTRseEwoN4cbsAaE_YZz5hUYF1oCPB-aRvz7q2mYWJfMw@mail.gmail.com>
Subject: Re: raid1 mount as read only
To:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Stefan K <shadow_7@gmx.net>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Feb 18, 2019 at 2:01 AM Stefan K <shadow_7@gmx.net> wrote:
>
> Hello,
>
> I've played a little bit with raid1:
> my steps was:
> 1. create a raid1 with btrfs (add device; balance start -mconvert=raid1 -dconvert=raid1 /)
> 2.  after finishing, i shutdown the server and remove a device and start it again,
> 3. it works (i used degraded options in fstab)
> 4. I shutdown the server, add the 'old' device, start it and run a btrfs balance

What exact command? There's a very good chance there are newly created
single profile block groups that must be converted, so it requires
another -mconvert and maybe also a -dconvert, depending on what block
groups have been created during the degraded mount.

> 5. until here everything is fine
> 6. I shutdown the server, remove the other harddisk, and start it,
> 7. it works
> 8. I shutdown the server, add the 'old' device, start it and try a btrfs balance
> 9. but now the FS is mounted as read only
>
> I got the following messages in dmesg:
> [    6.401740] BTRFS: device fsid b997e926-ab95-46d0-a9be-da52aa09203d devid 1 transid 3570 /dev/sda1
> [    6.403079] BTRFS info (device sda1): allowing degraded mounts
> [    6.403084] BTRFS info (device sda1): disk space caching is enabled
> [    6.403086] BTRFS info (device sda1): has skinny extents
> [    6.405878] BTRFS warning (device sda1): devid 2 uuid 09a7c9f6-9a13-4852-bca6-2d9120f388d4 missing
> [    6.409108] BTRFS info (device sda1): detected SSD devices, enabling SSD mode
>
> [    6.652411] BTRFS info (device sda1): allowing degraded mounts
> [    6.652414] BTRFS info (device sda1): disk space caching is enabled
> [    6.652416] BTRFS warning (device sda1): too many missing devices, writeable remount is not allowed


Debian 4.9.130-2 (2018-10-27) x86_64 GNU/Linux

Kernel is too old, it doesn't have the patches that permit mounting rw
degraded more than one time before fully converting everything. You'll
need a newer kernel to permit the mount of this file system, and then
you'll need to make sure there are only raid1 block groups. I know
this is not obvious.

Not related to your problem but btrfs-progs 4.7 is really old too.
It's a common issue on the very stable distros like Debian and RHEL,
but strictly speaking if you have problems with such tools and
kernels, you need to get support from the distro. One upstream mailing
lists, no matter what file system, it's very development oriented with
focus on fixing bugs in the mainline and development kernels.

Anyway it should be safe to get a recent LiveOS. Unfortunately I'm not
certain what kernel this behavior changed in, I know for sure kernel
5.0.0 rc's have it, and I'm almost positive 4.20 has it. I'm not sure
if 4.18 has it.


-- 
Chris Murphy
