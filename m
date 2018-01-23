Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f174.google.com ([209.85.128.174]:35342 "EHLO
        mail-wr0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751436AbeAWRLW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Jan 2018 12:11:22 -0500
Received: by mail-wr0-f174.google.com with SMTP id g38so1375149wrd.2
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Jan 2018 09:11:21 -0800 (PST)
MIME-Version: 1.0
From: Mike Gilbert <floppymaster@gmail.com>
Date: Tue, 23 Jan 2018 12:11:00 -0500
Message-ID: <CAJ0EP42wcb4uQQ-qivb38ZAYR8_+3k9fD+pDrj1cRZ_uVzdVvg@mail.gmail.com>
Subject: btrfs directory listing temporarily includes a recently removed file
To: linux-btrfs@vger.kernel.org
Cc: jbacik@fb.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

I just wanted to draw some attention to a recent regression regarding
a race condition when listing directories on btrfs. Your assistance in
resolving this would be appreciated.

https://bugzilla.kernel.org/show_bug.cgi?id=198483
