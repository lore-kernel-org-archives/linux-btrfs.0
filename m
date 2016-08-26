Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f50.google.com ([209.85.215.50]:34568 "EHLO
        mail-lf0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751168AbcHZTX5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Aug 2016 15:23:57 -0400
Received: by mail-lf0-f50.google.com with SMTP id l89so63368921lfi.1
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Aug 2016 12:23:56 -0700 (PDT)
MIME-Version: 1.0
From: Lukas Lueg <lukas.lueg@gmail.com>
Date: Fri, 26 Aug 2016 21:23:34 +0200
Message-ID: <CAJF-kYk3yp7gA_yJJ5mV6+FZVT0f4mk34ncjhtZXTNfSTK6aog@mail.gmail.com>
Subject: heap-use-after-free in btrfsck v4.7-42-g56e9586
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

let me draw your attention to
https://bugzilla.kernel.org/show_bug.cgi?id=153641 which is a
heap-use-after-free bug in btrfs-progs v4.7-42-g56e9586 I found while
fuzzing btrfs.

There are more bugs like this. How do you people want them to be reported?

Best regards
Lukas
