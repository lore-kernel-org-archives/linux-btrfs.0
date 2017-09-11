Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f176.google.com ([209.85.220.176]:34627 "EHLO
        mail-qk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750980AbdIKGGE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Sep 2017 02:06:04 -0400
Received: by mail-qk0-f176.google.com with SMTP id b23so16620776qkg.1
        for <linux-btrfs@vger.kernel.org>; Sun, 10 Sep 2017 23:06:04 -0700 (PDT)
MIME-Version: 1.0
From: shally verma <shallyvermacavium@gmail.com>
Date: Mon, 11 Sep 2017 11:35:33 +0530
Message-ID: <CAP9W88gEje_unDuNTGCZXn5PKoDwHtTgrjc7Cwzn0a_2KWtWow@mail.gmail.com>
Subject: BTRFS Deduplication
To: linux-btrfs@vger.kernel.org
Cc: "Verma, Shally" <shally.verma@cavium.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I was going through  BTRFS Deduplication page
(https://btrfs.wiki.kernel.org/index.php/Deduplication) and I read

"As such, xfs_io, is able to perform deduplication on a BTRFS file system," ..

following this, I followed on to xfs_io link https://linux.die.net/man/8/xfs_io

As I understand, these are set of commands allow us to do different
operations on "xfs" filesystem.
and command set mentioned here, couldn't see which is command to
invoke dedupe task.
and how this works with BTRFS.

So, can anyone help here and point me what am I missing here.

Thanks
Shally
