Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f182.google.com ([209.85.217.182]:48741 "EHLO
        mail-ua0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752585AbdKEIa7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 5 Nov 2017 03:30:59 -0500
Received: by mail-ua0-f182.google.com with SMTP id z4so4549588uaz.5
        for <linux-btrfs@vger.kernel.org>; Sun, 05 Nov 2017 01:30:59 -0700 (PDT)
MIME-Version: 1.0
From: "Lakshmipathi.G" <lakshmipathi.g@gmail.com>
Date: Sun, 5 Nov 2017 14:00:18 +0530
Message-ID: <CAKuJGC98ttkAcmc2yW_K5ROX8jXfrmoe5Q9tTomPMiiK_2UWNA@mail.gmail.com>
Subject: btrfs-progs:fuzz-tests/003-multi-check-unmounted broken?
To: btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi.

Seems like fuzz-test/003 is broken for quite sometime now (it works on
v4.7.3 but not after that).
Can anyone else able to run this test successfully? If this test is
not required anymore, shall
we remove it from fuzz-tests?

TEST=003\* tests/fuzz-tests.sh
[TEST/fuzz]   003-multi-check-unmounted
btrfs-progs/tests/common: line 170:  1439 Aborted
(core dumped) $INSTRUMENT "$@" >> "$RESULTS" 2>&1
mayfail: returned code 134 (SIGABRT), not ignored
test failed for case 003-multi-check-unmounted

Tried applying these two patches
https://patchwork.kernel.org/patch/9939881/ still script doesn't
succeed.

thanks.

----
Cheers,
Lakshmipathi.G
http://www.giis.co.in http://www.webminal.org
