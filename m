Return-Path: <SRS0=vUl+=QK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F559C282D7
	for <linux-btrfs@archiver.kernel.org>; Sun,  3 Feb 2019 00:21:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E6CC820855
	for <linux-btrfs@archiver.kernel.org>; Sun,  3 Feb 2019 00:21:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="mmKL4tZs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726945AbfBCASU (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 2 Feb 2019 19:18:20 -0500
Received: from mail-lj1-f171.google.com ([209.85.208.171]:34349 "EHLO
        mail-lj1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726849AbfBCASU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 2 Feb 2019 19:18:20 -0500
Received: by mail-lj1-f171.google.com with SMTP id u89-v6so8893182lje.1
        for <linux-btrfs@vger.kernel.org>; Sat, 02 Feb 2019 16:18:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bBnVKPfO9lZP4TKJT3o2ntQDiBAtkGLl3oMU5RP4JlY=;
        b=mmKL4tZsJhFAOaNKJ2LyVlEOl9A81PKUu9JccCCac23Y1P6wB9863BF1zNyaB01nr6
         yHLriA+ZrywenCTLrFVvQNuNGxOmo7d5G9AsWHvbPwQdIuWVhsCCWKWDlVfLznGz6mGw
         vuV2wHAu5vf8ov/6Uzp6eIKgaRnTtMUN06mOlHE1Yxp0GgxYHHdVN0AKdDtpGWMSQmgD
         SNtUAU6jbVubaUOqITQVvxyrL6flfsrZ1Yw5FkM+lXQJbUYZF9G7jslMn0zs8l8o9K+w
         zzYlf837Yu9AmV3UWmSEEGCH0oDsOh6nedefw/C4U+p8WzWMNA+1npagN/MvEVK5gnEa
         BGJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bBnVKPfO9lZP4TKJT3o2ntQDiBAtkGLl3oMU5RP4JlY=;
        b=DIPhhV6Q7kWQb3lFvJWz7HqLGn+QCcnFVLu5K3TbQKUVbK1F/2lSWGgROGlvFe4BDI
         SYyEeNznBq8ooCeroBQoIF1epZQKf2mDma4FUwplIX0xMMSmt00EfXnMnYjDlX92nSBM
         vVZSNI+zIyhX8qMRoT0yxOFH/SMqjj+Ps2JJjeeoYQUUPJEaLR3fm6rkfNG/KpPNZJau
         SuxievnoWLblavRh2i0Z7mb5T+s+6N/9CjdHsYlU5vwHzlHhAlhxOQCzzXBkeu/o6GxB
         RBf+vPvHygJKadIjJCwrgvxObmUPUy832ldj4UKJcjw2rNwKTuz8ILlLA2Aqr5EZr7sz
         +BQQ==
X-Gm-Message-State: AHQUAuaN/pyFwQsUdVgBBeQ09t5CqZdixLCgGpHWbu1voQIIhdUuKKZt
        pd/apGrHuItEfxDb7PJv6+1rRV+qU2dsJpY7VOna4g==
X-Google-Smtp-Source: AHgI3IaKvC5ueFGSI44sh+0Et4em3lbUCIjMkokVLcEZR7xrAcMQE69UvA0UMt/n6XMqr3bpaa98mWQi/5tvvzJGGPc=
X-Received: by 2002:a2e:a289:: with SMTP id k9-v6mr10542238lja.24.1549153098175;
 Sat, 02 Feb 2019 16:18:18 -0800 (PST)
MIME-Version: 1.0
References: <4ef8b545-efa8-43b0-8576-78c71bfb0e2c@www.fastmail.com>
In-Reply-To: <4ef8b545-efa8-43b0-8576-78c71bfb0e2c@www.fastmail.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Sat, 2 Feb 2019 17:18:06 -0700
Message-ID: <CAJCQCtSN0_RzgDmQEPs0CiLOhb-4G_Q3UbJv8Oaprj6kyVo8zg@mail.gmail.com>
Subject: Re: RAID1 filesystem not mounting
To:     Alan Hardman <alanh@fastmail.com>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Feb 1, 2019 at 9:28 PM Alan Hardman <alanh@fastmail.com> wrote:
>
> I have a Btrfs filesystem using 6 partitionless disks in RAID1 that's failing to mount. I've tried the common recommended safe check options, but I haven't gotten the disk to mount at all, even with -o ro,recovery.

Try '-o ro,degraded,nologreplay'

If that works update your backups before you do anything else. Then
you can report the following which are all read-only commands, and
should still work whether or not the file system is mounted.

btrfs fi show
btrfs insp dump-s -f <pick any btrfs device>
btrfs rescue super -v <pick any btrfs device>
smartctl -x <each drive>
smartctl -l scterc <each drive>
cat /sys/block/sdX/device/timeout   #also for each drive X

Search all system logs you have with 'grep -A 15 exception' so we can
see if there are any nasty libata messages.



> [  534.519437] BTRFS warning (device sdd): 'recovery' is deprecated, use 'usebackuproot' instead
> [  534.519441] BTRFS info (device sdd): trying to use backup root at mount time
> [  534.519443] BTRFS info (device sdd): disk space caching is enabled
> [  534.519446] BTRFS info (device sdd): has skinny extents
> [  536.306194] BTRFS info (device sdd): bdev /dev/sdc errs: wr 23038942, rd 22208378, flush 1, corrupt 29486730, gen 2933

That's a lot of errors. These statistics are for the life of the file
system, until reset with 'btrfs dev stats -z' so it's possible all of
these errors are for a previous problem you've since recovered from.
However, that you now have a new problem, it's not clear to what
degree they are the result of read, write, corruption and generation
errors.



> [  556.126928] BTRFS critical (device sdd): corrupt leaf: root=2 block=25540634836992 slot=45, unexpected item end, have 13882 expect 13898
> [  556.134767] BTRFS critical (device sdd): corrupt leaf: root=2 block=25540634836992 slot=45, unexpected item end, have 13882 expect 13898
> [  556.150278] BTRFS critical (device sdd): corrupt leaf: root=2 block=25540634836992 slot=45, unexpected item end, have 13882 expect 13898

The fact this is a raid1 volume, and there are no messages for fixups,
tells me this is bad news. Either both copies are bad, or the good
copy can't be found (missing device or more than one missing).

Anyway, the less you modify the file system with repair attempts, or
trying to mount it read write, the better the chance of recovery.
Right now there isn't enough information to tell you what to do other
than do as little as possible.

-- 
Chris Murphy
