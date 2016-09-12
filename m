Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f41.google.com ([209.85.215.41]:34041 "EHLO
        mail-lf0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932302AbcILRnL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Sep 2016 13:43:11 -0400
Received: by mail-lf0-f41.google.com with SMTP id u14so93395820lfd.1
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Sep 2016 10:43:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAK5rZE7SMLgPpe8tAQZ9qu=vm+3Gk=73L_h2+tOPEag-0tS0Bg@mail.gmail.com>
References: <CAK5rZE49j5QYZJSriG70LVo-9JnRJRfwFA0qRZSEotXpCxJC6A@mail.gmail.com>
 <5440522.9CHaGU5Wjs@merkaba> <pan$238e8$d4dacca2$71255eb4$9f2e5ec1@cox.net>
 <CAK5rZE6X_m6wyTmqRZ8B3TTZsXtEtPT5TaanFfgXKycJoBfsTA@mail.gmail.com>
 <pan$10305$d0b1bd23$a49643ee$465d6f6c@cox.net> <CAK5rZE7SMLgPpe8tAQZ9qu=vm+3Gk=73L_h2+tOPEag-0tS0Bg@mail.gmail.com>
From: Imran Geriskovan <imran.geriskovan@gmail.com>
Date: Mon, 12 Sep 2016 20:43:08 +0300
Message-ID: <CAK5rZE7V46=y9is5rmD2HDV2d5MNMiWd++xUszgSqAOY5VQxsA@mail.gmail.com>
Subject: Re: Small fs
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> btrfs filesystem df /mnt/back/boot
> Data, single: total=8.00MiB, used=0.00B
> System, DUP: total=8.00MiB, used=16.00KiB
> Metadata, DUP: total=32.00MiB, used=112.00KiB
> GlobalReserve, single: total=16.00MiB, used=0.00B
> IT IS DUP!!

Wait wait wait a second:
This is 256 MB SINGLE created
by GPARTED, which is the replacement of MANUALLY
CREATED 127MB DUP which is now non-existant..
Which I was not aware it was a DUP at the time..
Peeww... Small btrfs is full of surprises.. ;)
