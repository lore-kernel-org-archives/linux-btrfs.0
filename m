Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from forward7h.cmail.yandex.net ([87.250.230.218]:52862 "EHLO
        forward7h.cmail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751897AbdBEVwm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 5 Feb 2017 16:52:42 -0500
Received: from mxback1m.mail.yandex.net (mxback1m.mail.yandex.net [IPv6:2a02:6b8:0:2519::10a])
        by forward7h.cmail.yandex.net (Yandex) with ESMTP id A971321466
        for <linux-btrfs@vger.kernel.org>; Mon,  6 Feb 2017 00:42:01 +0300 (MSK)
From: Alexander Tomokhov <alexoundos@ya.ru>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Is it possible to have metadata-only device with no data?
MIME-Version: 1.0
Message-Id: <14453691486330921@web21h.yandex.ru>
Date: Mon, 06 Feb 2017 00:42:01 +0300
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Is it possible, having two drives to do raid1 for metadata but keep data on a single drive only?
