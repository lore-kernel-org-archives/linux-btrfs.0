Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f172.google.com ([209.85.217.172]:45462 "EHLO
        mail-ua0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751245AbdKBFTm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Nov 2017 01:19:42 -0400
Received: by mail-ua0-f172.google.com with SMTP id l40so3119455uah.2
        for <linux-btrfs@vger.kernel.org>; Wed, 01 Nov 2017 22:19:42 -0700 (PDT)
MIME-Version: 1.0
From: "Lakshmipathi.G" <lakshmipathi.g@gmail.com>
Date: Thu, 2 Nov 2017 10:49:01 +0530
Message-ID: <CAKuJGC8M3NFbZ5Ky0gsuwz3oioCayPWK+JcxtC+BZ9=DuG4TXw@mail.gmail.com>
Subject: kernel BUG at fs/btrfs/ctree.h:3457!
To: btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi.

I'm constantly hitting this bug while running btrfs-progs:fsck-test:012 .
Screencast: https://asciinema.org/a/wQxZjCeVvX2kVqKjVBGyR0klq

Logged more details: https://bugzilla.kernel.org/show_bug.cgi?id=197587
Anyone else got this issue or something wrong with my test environment?

----
Cheers,
Lakshmipathi.G
http://www.giis.co.in http://www.webminal.org
