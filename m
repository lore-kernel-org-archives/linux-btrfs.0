Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:37229 "EHLO
        mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727028AbeHJKI7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 10 Aug 2018 06:08:59 -0400
Received: by mail-oi0-f46.google.com with SMTP id j205-v6so14329821oib.4
        for <linux-btrfs@vger.kernel.org>; Fri, 10 Aug 2018 00:40:19 -0700 (PDT)
MIME-Version: 1.0
From: Dan Merillat <dan.merillat@gmail.com>
Date: Fri, 10 Aug 2018 03:40:18 -0400
Message-ID: <CAPL5yKfaoujn4gOcejJKwvXHhnuRgFLACKHxxy=bXQz0tE0YMA@mail.gmail.com>
Subject: Mount stalls indefinitely after enabling quota groups.
To: BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Kernel 4.17.9, 11tb BTRFS device (md-backed, not btrfs raid)

I was testing something out and enabled quota groups and started getting
2-5 minute long pauses where a btrfs-transaction thread spun at 100%.

Post-reboot the mount process spinds at 100% CPU, occasinally yielding
to a btrfs-transaction thread at 100% CPU.  The switchover is marked
by a burst of disk activity in btrace.

Btrace shows all disk activity is returning promptly - no hanging submits.

Currently the mount is at 6+ hours.

Suggestions on how to go about debugging this?
