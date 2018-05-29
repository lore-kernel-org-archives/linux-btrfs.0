Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:51473 "EHLO
        mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934136AbeE2Ne1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 May 2018 09:34:27 -0400
MIME-Version: 1.0
From: shankarapailoor <shankarapailoor@gmail.com>
Date: Tue, 29 May 2018 06:34:25 -0700
Message-ID: <CAB+yDaZ1SCDWs7budkTDh0OL0Pvmpf0Eh94koT8+B=8p5c3Dyg@mail.gmail.com>
Subject: 2 BUG_ON crashes
To: clm@fb.com, jbacik@fb.com
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I have been fuzzing linux 4.17-rc4 with Syzkaller and it triggered the
following BUG_ONs.

1. kernel BUG at fs/btrfs/file.c:997
(https://elixir.bootlin.com/linux/v4.17-rc4/source/fs/btrfs/file.c#L997)

Stack Trace: https://pastebin.com/QZeDnRvm

2. kernel BUG at fs/btrfs/extent_io.c:4049
(https://elixir.bootlin.com/linux/v4.17-rc4/source/fs/btrfs/extent_io.c#L4049)

Stack Trace: https://pastebin.com/qZN5qF3e

Both bugs appear to be triggered by fault injections but can the
BUG_ON's be changed to Warnings?

Regards,
Shankara Pailoor
