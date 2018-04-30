Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:41324 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754555AbeD3QEv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 30 Apr 2018 12:04:51 -0400
Received: by mail-oi0-f65.google.com with SMTP id 11-v6so7838357ois.8
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Apr 2018 09:04:51 -0700 (PDT)
MIME-Version: 1.0
From: Vijay Chidambaram <vvijay03@gmail.com>
Date: Mon, 30 Apr 2018 11:04:10 -0500
Message-ID: <CAPaz=E+=aVagu2g3ZUiD-SjvnAAU0zb0SSaPKUitHT9CWuKW8A@mail.gmail.com>
Subject: Strange behavior (possible bugs) in btrfs
To: Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Soujanya Ponnapalli <soujanyap95@gmail.com>,
        Jayashree Mohan <jayashree2912@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

We found two more cases where the btrfs behavior is a little strange.
In one case, an fsync-ed file goes missing after a crash. In the
other, a renamed file shows up in both directories after a crash.

Workload 1:

mkdir A
mkdir B
mkdir A/C
creat B/foo
fsync B/foo
link B/foo A/C/foo
fsync A
-- crash --

Expected state after recovery:
B B/foo A A/C exist

What we find:
Only B B/foo exist

A is lost even after explicit fsync to A.

Workload 2:

mkdir A
mkdir A/C
rename A/C B
touch B/bar
fsync B/bar
rename B/bar A/bar
rename A B (replacing B with A at this point)
fsync B/bar
-- crash --

Expected contents after recovery:
A/bar

What we find after recovery:
A/bar
B/bar

We think this breaks rename's atomicity guarantee. bar should be
present in either A or B, but now it is present in both.

Thanks,
Vijay
