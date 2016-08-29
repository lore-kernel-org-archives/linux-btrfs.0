Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f46.google.com ([209.85.215.46]:33253 "EHLO
        mail-lf0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752197AbcH2GGr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 Aug 2016 02:06:47 -0400
Received: by mail-lf0-f46.google.com with SMTP id b199so93388481lfe.0
        for <linux-btrfs@vger.kernel.org>; Sun, 28 Aug 2016 23:06:46 -0700 (PDT)
MIME-Version: 1.0
From: Lukas Lueg <lukas.lueg@gmail.com>
Date: Mon, 29 Aug 2016 08:06:24 +0200
Message-ID: <CAJF-kYko=dSuCmxpj6uJmKRZtAOhYCzoK=8hoyqBAe5UA8nQUg@mail.gmail.com>
Subject: Multiple bugs found by fuzzing BTRFS
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I've now spent around 160 hours of fuzzing BTRFS, here are the crashes
I found so far. Every type of crash is reported only once although
there are usually multiple locations where they show up (especially
heap-use-after-free and calls to abort()).

The following bug reports have attached to them images of ±18kb which
expand to 16mb and reproduce a crash when running btrfsck; they all
have been revirginized so CRC- and FSID-checks pass by a vanilla
btrfsck.


Use-after-free, shows up all over the place:
https://bugzilla.kernel.org/show_bug.cgi?id=153641

Segfault in memcpy, yeah: https://bugzilla.kernel.org/show_bug.cgi?id=154021

Run-off-the-mill buffer-overflow:
https://bugzilla.kernel.org/show_bug.cgi?id=154961

Endless loop in btrfsck: https://bugzilla.kernel.org/show_bug.cgi?id=155151

Calls to abort() by lack of error paths:
https://bugzilla.kernel.org/show_bug.cgi?id=155181

Division by zero, the old problem of computing stripe_size:
https://bugzilla.kernel.org/show_bug.cgi?id=155201


There are many more crashes like the above; how do you guys want them
to be reported?


Best regards
