Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from forward16h.cmail.yandex.net ([87.250.230.158]:47031 "EHLO
        forward16h.cmail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753204AbcHUTGZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 21 Aug 2016 15:06:25 -0400
Received: from mxback6j.mail.yandex.net (mxback6j.mail.yandex.net [5.45.198.20])
        by forward16h.cmail.yandex.net (Yandex) with ESMTP id 1A10E210C5
        for <linux-btrfs@vger.kernel.org>; Sun, 21 Aug 2016 21:59:37 +0300 (MSK)
From: Tomokhov Alexander <alexoundos@ya.ru>
To: linux-btrfs@vger.kernel.org
Subject: Will Btrfs have an official command to "uncow" existing files?
MIME-Version: 1.0
Message-Id: <126611471805976@web2j.yandex.ru>
Date: Sun, 21 Aug 2016 21:59:36 +0300
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs wiki FAQ gives a link to example Python script: https://github.com/stsquad/scripts/blob/master/uncow.py

But such a crucial and fundamental tool must exist in stock btrfs-progs. Filesystem with CoW technology at it's core must provide user sufficient control over CoW aspects. Running 3rd-party or manually written scripts for filesystem properties/metadata manipulation is not convenient, not safe and definitely not the way it must be done.

Also is it possible (at least in theory) to "uncow" files being currently opened in-place? Without the trickery with creation & renaming of files or directories. So that running "chattr +C" on a file would be sufficient. If possible, is it going to be implemented?
