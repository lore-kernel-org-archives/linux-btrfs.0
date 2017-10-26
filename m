Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f171.google.com ([209.85.223.171]:48103 "EHLO
        mail-io0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932246AbdJZPkV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 26 Oct 2017 11:40:21 -0400
Received: by mail-io0-f171.google.com with SMTP id h70so6322697ioi.4
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Oct 2017 08:40:20 -0700 (PDT)
MIME-Version: 1.0
From: Cheyenne Wills <cheyenne.wills@gmail.com>
Date: Thu, 26 Oct 2017 09:40:19 -0600
Message-ID: <CAHpsFVc8a-2ARN+ESza8e1MYhDk5okww9b0K2DAy9QXeiPQsBw@mail.gmail.com>
Subject: Need some assistance/direction in determining a system hang during
 heavy IO
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A while back I opened an issue in the IO/Storage Block layer in kernel
bugzilla -- though it may be going to the wrong queue.

Was wondering if someone could take a quick look at
https://bugzilla.kernel.org/show_bug.cgi?id=193331 and see if the
problem rings a bell, or if it's in the wrong component, etc. or give
me some direction on what information I should try to collect.

Briefly when I upgraded a system from 4.0.5 kernel to 4.9.5 (and
later) I'm seeing a blocked task timeout with heavy IO against a
multi-lun btrfs filesystem.  I've tried a 4.12.12 kernel and am still
getting the hang.  I can force a recreate by running a btrfs scrub
against the filesystem.  My initial encounters with the hang was when
I was running a filesystem backup and also when the major app (FTP
server in this case) was performing a lot of read IO.

Thanks in advance.

Cheyenne Wills
