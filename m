Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f170.google.com ([209.85.220.170]:36517 "EHLO
        mail-qk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751395AbdHNBBq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 13 Aug 2017 21:01:46 -0400
Received: by mail-qk0-f170.google.com with SMTP id d136so43804422qkg.3
        for <linux-btrfs@vger.kernel.org>; Sun, 13 Aug 2017 18:01:46 -0700 (PDT)
MIME-Version: 1.0
From: Cerem Cem ASLAN <ceremcem@ceremcem.net>
Date: Mon, 14 Aug 2017 04:01:44 +0300
Message-ID: <CAN4oSBdO8GfBQA1CrLVa1atA+QJquCy63KBqOHhh49Uz=1sgjQ@mail.gmail.com>
Subject: Building a BTRFS test machine
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Would that be useful to build a BTRFS test machine, which will perform
both software tests (btrfs send | btrfs receive, read/write random
data etc.) and hardware tests, such as abrupt power off test, abruptly
removing a raid-X disk physically, etc.

If it would be useful, what tests should it cover?
