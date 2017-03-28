Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f49.google.com ([74.125.83.49]:36706 "EHLO
        mail-pg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932256AbdC1Rw3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Mar 2017 13:52:29 -0400
Received: by mail-pg0-f49.google.com with SMTP id g2so78761793pge.3
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Mar 2017 10:52:28 -0700 (PDT)
Date: Tue, 28 Mar 2017 23:22:15 +0530
From: Jitendra <jkhasdev@gmail.com>
To: quwenruo@cn.fujitsu.com
Cc: linux-btrfs@vger.kernel.org
Subject: How to test in-bound dedupe
Message-ID: <20170328175215.GA14991@jitendra-HP-ProBook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Qu/All,

I am looking into in-memory in-bound dedup. I have cloned your git tree from
following urls.

Linux Tree: https://github.com/adam900710/linux.git wang_dedupe_latest
btrfs-progs: https://git@github.com:adam900710/btrfs-progs.git dedupe_20170316

Then run the follwoing test https://btrfs.wiki.kernel.org/index.php/User_notes_on_dedupe.

Is there any stuff that needs to be tested for it? if something, then please
point out me.

My goal is to understand in-memory dedup and try to participate in on-disk
de-dup.

---
Jitendra
