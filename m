Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f42.google.com ([209.85.215.42]:35603 "EHLO
        mail-lf0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750912AbcIKP1d (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 11 Sep 2016 11:27:33 -0400
Received: by mail-lf0-f42.google.com with SMTP id l131so72486037lfl.2
        for <linux-btrfs@vger.kernel.org>; Sun, 11 Sep 2016 08:27:32 -0700 (PDT)
MIME-Version: 1.0
From: Imran Geriskovan <imran.geriskovan@gmail.com>
Date: Sun, 11 Sep 2016 18:27:30 +0300
Message-ID: <CAK5rZE49j5QYZJSriG70LVo-9JnRJRfwFA0qRZSEotXpCxJC6A@mail.gmail.com>
Subject: Small fs
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

What is the smallest recommended fs size for btrfs?

- There are mentions of 256MB around the net.
- Gparted reserves minimum of 256MB for btrfs.

With an ordinary partition on a single disk,
fs created with just "mkfs.btrfs /dev/sdxx":
- 128MB works fine.
- 127MB works but as if it is 64MB.

Can we say size should be in multiples of 64MB?
