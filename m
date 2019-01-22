Return-Path: <SRS0=kIOr=P6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A219CC282C3
	for <linux-btrfs@archiver.kernel.org>; Tue, 22 Jan 2019 23:42:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 673D621726
	for <linux-btrfs@archiver.kernel.org>; Tue, 22 Jan 2019 23:42:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l2ydhXdn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726893AbfAVXmC (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 22 Jan 2019 18:42:02 -0500
Received: from mail-vs1-f52.google.com ([209.85.217.52]:38197 "EHLO
        mail-vs1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726814AbfAVXmC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Jan 2019 18:42:02 -0500
Received: by mail-vs1-f52.google.com with SMTP id x64so218850vsa.5
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Jan 2019 15:42:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=gx7Sptg074o/kEog/AvSglXiAxSYl6E26/UvOJK/uvA=;
        b=l2ydhXdnQdsebvuibAS7xyqw6eQWHCCXgVUdR+qGVrz4h7CbPbBvnE29gWzjSSnPzp
         ChjdkNtrtVT1BDaWaEPyNhcZmAQi1o9u4cjA2iIIwvsj+2tvJG9rL8+LwXhsVngQVnsj
         pwt9eSu2/dK/+0bBd5O3mbpLprJVAckHBCSYlJLzkSozqT685RXUY6plsH3VygluMJt6
         PYkkQt5c9GCm3L3B2cAcy93+GB4gCfGZE3BSHYwHYZwi5t1aKbYocfsU3c3exjkHSRX+
         krJsR3K6et4tc7L8AAj/OMX0c5eP3AbTPLHAgX1JhR8yr6/Cp6jnk2GCC875M00P6i0B
         3KoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=gx7Sptg074o/kEog/AvSglXiAxSYl6E26/UvOJK/uvA=;
        b=HCOPQSThCqFQCp+PiMO+LYOyEKxM+cTzDltpy+F35vUOYOVVlw14YdS1v3i9EyHsAl
         s1BAGbLXuW5ktr4y7jFu1uRELKWaAev9h7VKA6MDGfSJwfM1XLaE+dvmUuJ/ioI5IHHo
         FIzNqAj+HxY9KSdQNy0+O7X6rHb/XfLT5hagUgmLGhOHSFWW3nXmEXaxk4CaPt9vZmvc
         RPdOEld+XzOgXTwqW8xnoXb/eFP4v2P8LFedoei0q/e1ek7/sv4tFlxLxOBy7vLcXA4E
         PbAxB3uENHuod6Z7s8r6kCpNOHujIJgGh+axZPb2wiAyk7ell6NhGwjwjDYnhPI89yMW
         Q8Vw==
X-Gm-Message-State: AJcUukdhq/aTUCSnO4XfFMW7yDFeyrStEp9EewzhYEn5mN1eZzaZ5A53
        rDMnnaQ7T4pP9YzNU+IJe6j9Kk4yiyAqHUdygGGzkj45
X-Google-Smtp-Source: ALg8bN5yiepqSDGtV4Hlddr999nYPUydgmH4yKazJujQXJA2S7JQaQn4HqR/W047mJ1acWvEu/BS+aFU1SAlzh3bQjA=
X-Received: by 2002:a67:e89a:: with SMTP id x26mr14725530vsn.80.1548200520985;
 Tue, 22 Jan 2019 15:42:00 -0800 (PST)
MIME-Version: 1.0
From:   Matthew Friday <lkmfriday@gmail.com>
Date:   Tue, 22 Jan 2019 23:41:50 +0000
Message-ID: <CANmnzbMpBsE5dcmc9_mHOTB9tUY7enWxicRCbmTwpZ2HuDOhaw@mail.gmail.com>
Subject: Do btrfs provide filesystem debugger?
To:     linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi all,

I recently started learning BTRFS internals, and one think that I
cannot find is filesystem debugger to browse on disk data structures
(like xfs_db or ext debugfs).
Do BTRFS provide similar way to navigate on disk structures? I can see
the btrfs-debug-tree utility which provide whole tree of the
informations, is this something that can be then perhaps parsed in
easy way to view the internal structures?

Many Thanks
Matt
