Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f173.google.com ([209.85.216.173]:35826 "EHLO
        mail-qt0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751039AbdIAPYS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Sep 2017 11:24:18 -0400
Received: by mail-qt0-f173.google.com with SMTP id x36so2488966qtx.2
        for <linux-btrfs@vger.kernel.org>; Fri, 01 Sep 2017 08:24:18 -0700 (PDT)
MIME-Version: 1.0
From: Eric Wolf <19wolf@gmail.com>
Date: Fri, 1 Sep 2017 11:23:57 -0400
Message-ID: <CAJ_hD5DTcKYbRGeqCihgQZZc9oGSO4BT+_RhJG7qjFVo2aSB-w@mail.gmail.com>
Subject: Snapper Rollback filesystem is read only
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I rolled back my filesystem with 'snapper rollback 81 (or whatever
snapshot it was)' and now when I boot my filesystem is read-only. How
do I fix it?
