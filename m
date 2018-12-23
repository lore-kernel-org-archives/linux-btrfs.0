Return-Path: <SRS0=mU8m=PA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A586BC43612
	for <linux-btrfs@archiver.kernel.org>; Sun, 23 Dec 2018 00:55:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 685E121934
	for <linux-btrfs@archiver.kernel.org>; Sun, 23 Dec 2018 00:55:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FgN7Aaag"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393051AbeLWAui (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 22 Dec 2018 19:50:38 -0500
Received: from mail-oi1-f172.google.com ([209.85.167.172]:33372 "EHLO
        mail-oi1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387711AbeLWAuh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 22 Dec 2018 19:50:37 -0500
Received: by mail-oi1-f172.google.com with SMTP id c206so7782065oib.0
        for <linux-btrfs@vger.kernel.org>; Sat, 22 Dec 2018 16:50:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=VK5mL4sDVGgs/u9uE+/oEfiYEm+s+3b4C66K/vBAaHc=;
        b=FgN7AaaglwCyAq9jnRDblCtOJauaffTCh/HsVo552cbpHiEpsIxVFEqEaJMsZDee/s
         bd9QIYE+8WZk5z1B/6Si1a8WIywbVP/ANZFyFes9f8IxqMlWfATDiNzY55/FVAflwqwV
         CHV4JvCSFtOEhfEzgx+AuYBEF7SnU24zRlDeMiB/9izOO+TPDbOF/mVvf2sUMYyj5ImA
         iVCfGNcdthwgeDqgxLHnuysmCbiTag55gDEzBqT2A9Nz5wXmr0VGzKdqmzLm6mETTvJN
         vHotnew2Rwb3/zA+WwDyA6Q22Nevg3ybAoEnqif/XgeAEaEqoL9imM0dlf1Z5Mcx04DI
         kR8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=VK5mL4sDVGgs/u9uE+/oEfiYEm+s+3b4C66K/vBAaHc=;
        b=P1JpXlgjH27zL8FwIhA5jvCjE9JYxtPkEFJROaKaTgHW5fOS5RTeX9b/BP5YGYGxFi
         +Oa+0b1/gt73wNG+Sr4Zf61pOZOQiLSe7W4ni6AiVTwdmZqIii+/5+Q1sXt6aSYVpnqq
         hN+0dSi7b1m3BrVvZpx0RtDbFJUmIxpLDMxHsZWRDyXSeStLh2hXkILK96j5ye3ckPHL
         myaDs2QnAfl9W3dyLMVdQRZLjQuvQntXAJ8gvmiFJeA9iIzf4ZdflkzWz/4A8FoU1Jr1
         bBm+6zAZBWEhLXiRMAT5ZMKsQzDO1a9QM6+0V++1sC5lMJAa0iSL4auJnP8aP3HYjjlR
         l7XQ==
X-Gm-Message-State: AA+aEWY6yXL02DqRfdXE88/WwljDITtEsm37Kz5dFFuEJZiBoCrqA5QI
        tOuh9M7SjKzZuRZwGFVfc4fCqvaFr5OHOz8qGrTv4A==
X-Google-Smtp-Source: AFSGD/WvUUnG79it4mYD2tyHLpGWv0E1bcXStrwylSOm6tn/KKNgnxCfYstEjTCDvHexwzWOfBnIRK5VgGiUTO703zQ=
X-Received: by 2002:aca:4b48:: with SMTP id y69mr5068215oia.200.1545526236852;
 Sat, 22 Dec 2018 16:50:36 -0800 (PST)
MIME-Version: 1.0
From:   Raymond Jennings <shentino@gmail.com>
Date:   Sat, 22 Dec 2018 16:50:01 -0800
Message-ID: <CAGDaZ_rX9bwugUbysqvbEm0mGs-6sXx2_p6PhUMmUz4j_T9emQ@mail.gmail.com>
Subject: btrfs-convert just dumped core
To:     linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

I tried to convert an ext4 volume, and it tripped an abort and dumped core.

The volume in question had a good e2fsck both before and after.
