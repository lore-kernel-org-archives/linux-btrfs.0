Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:37245 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751035AbdLSQJZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Dec 2017 11:09:25 -0500
Received: by mail-io0-f193.google.com with SMTP id d16so14126573iob.4
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Dec 2017 08:09:25 -0800 (PST)
MIME-Version: 1.0
From: Rich Rauenzahn <rrauenza@gmail.com>
Date: Tue, 19 Dec 2017 08:09:23 -0800
Message-ID: <CAG+QAKXycv-a3G9QKts4V9RWtKxgRgTtSd6mkZP=Dagmi9Ebtg@mail.gmail.com>
Subject: kernel hangs during balance
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm running 4.4.106-1.el7.elrepo.x86_64 and I do a btrfs balance everynight.

Every night I'm getting a kernel hang, sometimes caught by my
watchdog, sometimes not.  Last night's hang was on the balance of DATA
on / at 70.

I'm not sure how to further trace this down to help you -- the console
by the time I notice just has lots of messages on it without the
initial ones.   The last items in /var/log/message aren't helpful, but
I'm pretty sure it is the nightly balance.

I've run btrfs check on / with no issues recently.

Rich
