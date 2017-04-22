Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f169.google.com ([209.85.223.169]:33579 "EHLO
        mail-io0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1423676AbdDVNqv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 22 Apr 2017 09:46:51 -0400
Received: by mail-io0-f169.google.com with SMTP id k87so146920141ioi.0
        for <linux-btrfs@vger.kernel.org>; Sat, 22 Apr 2017 06:46:51 -0700 (PDT)
MIME-Version: 1.0
From: Clemens Eisserer <linuxhippy@gmail.com>
Date: Sat, 22 Apr 2017 15:46:49 +0200
Message-ID: <CAFvQSYRUG9WdyBRsfEFH_F+V_P6rYpZn4K7zP-v_-g5t=o=mJg@mail.gmail.com>
Subject: Will dupremove work for compressed btrfs volumnes?
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Sorry if this is off-topic, but the dupremove project doesn't seem to
have a mailing list - and it is actually only generating extent-same
ioctls handled by btrfs anyway.

I recently gave dupremove a try on my btrfs-volume (mounted with
compress-force=lzo), specifically on a folder where I have a lot of
proprietary stuff installed (so 15 copies of
QT/java-runtime/webkit/...) and the result was:

Kernel processed data (excludes target files): 11.9G
Comparison of extent info shows a net change in shared extents of: 2.5M

>From what I understand, only 2,5mb were successfully deduplicated.
So I wonder, doesn't the extent-same ioctl work for compressed files,
or does the dedupe-utility know about compression?

Thank you in advance, Clemens
