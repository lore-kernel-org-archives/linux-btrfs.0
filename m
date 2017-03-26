Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:40864 "EHLO smtp.gentoo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751721AbdCZUha (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 26 Mar 2017 16:37:30 -0400
Received: from mail-it0-f44.google.com (mail-it0-f44.google.com [209.85.214.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: floppym)
        by smtp.gentoo.org (Postfix) with ESMTPSA id 3A9EB341657
        for <linux-btrfs@vger.kernel.org>; Sun, 26 Mar 2017 20:37:28 +0000 (UTC)
Received: by mail-it0-f44.google.com with SMTP id y18so33835254itc.1
        for <linux-btrfs@vger.kernel.org>; Sun, 26 Mar 2017 13:37:28 -0700 (PDT)
MIME-Version: 1.0
From: Mike Gilbert <floppym@gentoo.org>
Date: Sun, 26 Mar 2017 16:37:05 -0400
Message-ID: <CAJ0EP40B51rd1trLP=wMY+2=T4wPLUwYarBwf5Hi5RBABuJv6A@mail.gmail.com>
Subject: Missing __error symbol in btrfs-progs-4.10
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A Gentoo user reports that snapper broke after upgrading to btrfs-progs-4.10.

snapper: symbol lookup error: /usr/lib64/libbtrfs.so.0: undefined
symbol: __error

https://bugs.gentoo.org/show_bug.cgi?id=613890

It seems that the __error symbol is referenced, but not included in libbtrfs.

Exporting this symbol seems like a bad idea, so I would suggest
renaming it, or go back to inlining it in the headers.
