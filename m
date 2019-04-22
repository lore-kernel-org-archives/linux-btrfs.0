Return-Path: <SRS0=Q7pU=SY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42745C10F11
	for <linux-btrfs@archiver.kernel.org>; Mon, 22 Apr 2019 21:10:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0129A20896
	for <linux-btrfs@archiver.kernel.org>; Mon, 22 Apr 2019 21:10:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Lpu5hUfP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729170AbfDVVKL (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 22 Apr 2019 17:10:11 -0400
Received: from mail-ot1-f45.google.com ([209.85.210.45]:42345 "EHLO
        mail-ot1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728796AbfDVVKL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 22 Apr 2019 17:10:11 -0400
Received: by mail-ot1-f45.google.com with SMTP id f23so1716007otl.9
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Apr 2019 14:10:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=ptGR0I8kV9OFwr8X6W9ZjNqKgMHI9EbW56ThRDrsoyc=;
        b=Lpu5hUfPsUJjPMNPcxG3jGolDFtlXjjLFfP2Hh3muS+2MogkAKHPiQmaACHbEPeEH8
         d+w7a1D7dMxlB+Qgsdu1Wd/4SejLGK7i+N7Gp3gGcbTQpQC7Ov5CDOgC+sr0TRi8gJI0
         FksaW/Q4Byl/Pi2dBatdtUY/ndYHEbd+3DJzpDk8tre8uostRNyygEy3NpQo/buDydTO
         F6YOR74uA6irLh7/S0cSyekCvWhiu1I4jax4aTRPyB5eYgKzK0mniydiScLpIvkGU5rf
         Ngp3xDFsF+SoTfy5HhXVKN7TvLlkon/SQWKARDa2P3JK6s3DO+f79wQDjrsi2wS6HhwC
         m6nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=ptGR0I8kV9OFwr8X6W9ZjNqKgMHI9EbW56ThRDrsoyc=;
        b=osgS8B/GQpmzM1ckE9/k6tY8ZLB9ptLa5KqQMWdLvI4niIQQI6e9wbYo6FczVfqBwM
         5UnFoetaVzA2jA8irtopxJe+FhugKSDItgU3SWUnWRnLNUYMggBl38vGSRGIT4Dp6iKx
         Bsv5c1Ypu1QcFt3JSVLJB2r+7OBCrhDJ01Tp7znWFv7v74FiqmFx0tcg6TTtqixYlKgb
         bdVoIkQME+PJwQY/luN3V00GDmL4h9DuKp0a+VzHl/oESPVNeAC9lguT1LY4bPpdshI3
         XEAe2hw7/EfUYVwreCKOYbBfWzKVHRTbV4pxRYkYfn2Q3An10m0FNEjWLnKCeR0hAhZ6
         UbcQ==
X-Gm-Message-State: APjAAAUUyhU617xmZy8E0pjL6wQCF5BoP0FkoLw8mZjjos5LKJHZYG+2
        +WeTvaZNHuCi2efhByPE7PuTARNnLsXxyRtv97837Qcu
X-Google-Smtp-Source: APXvYqzvoG53JR+9kArxCQeXeYbsGlscpEmRAzu7ULMBjJAF9W+ADpkH85kLORDhNpnaPM/zzKdgWCDD7BY5F8ynyRE=
X-Received: by 2002:a9d:6a15:: with SMTP id g21mr13632504otn.307.1555967410640;
 Mon, 22 Apr 2019 14:10:10 -0700 (PDT)
MIME-Version: 1.0
From:   Jakob Unterwurzacher <jakobunt@gmail.com>
Date:   Mon, 22 Apr 2019 23:09:59 +0200
Message-ID: <CAPv9Zmk46As_P9Gyf_icET53xRda63h7iC1meES9xbdDEt9qow@mail.gmail.com>
Subject: fallocate does not prevent ENOSPC on write
To:     linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

I have a user who is reporting ENOSPC errors when running gocryptfs on
top of btrfs (ticket: https://github.com/rfjakob/gocryptfs/issues/395 ).

What is interesting is that the error gets thrown at write time. This
is not supposed to happen, because gocryptfs does

    fallocate(..., FALLOC_FL_KEEP_SIZE, ...)

before writing.

I wrote a minimal reproducer in C: https://github.com/rfjakob/fallocate_write
This is what it looks like on ext4:

    $ ../fallocate_write/fallocate_write
    reading from /dev/urandom
    writing to ./blob.379Q8P
    writing blocks of 132096 bytes each
    [...]
    fallocate failed: No space left on device

On btrfs, it will instead look like this:

    [...]
    pwrite failed: No space left on device

Is this a bug in btrfs' fallocate implementation or am I reading the
guarantees that fallocate gives me wrong?

Thanks!
Jakob
