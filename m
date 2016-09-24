Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from forward17o.cmail.yandex.net ([37.9.109.214]:49773 "EHLO
        forward17o.cmail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756266AbcIXMd5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 24 Sep 2016 08:33:57 -0400
Received: from mxback4o.mail.yandex.net (mxback4o.mail.yandex.net [37.140.190.18])
        by forward17o.cmail.yandex.net (Yandex) with ESMTP id ECE4C2104F
        for <linux-btrfs@vger.kernel.org>; Sat, 24 Sep 2016 15:26:14 +0300 (MSK)
From: Alexander Tomokhov <alexoundos@ya.ru>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Does data checksumming remain for files with No_COW file attribute?
MIME-Version: 1.0
Message-Id: <767591474719974@web21o.yandex.ru>
Date: Sat, 24 Sep 2016 15:26:14 +0300
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There is an unanswered question at stackexchange:
http://unix.stackexchange.com/q/303130/41572

Assume that we don't invoke mount options like nodatacow and nodatasum - operate only at file attributes level, which are controlled with lsattr/chattr. So does setting No_COW on a file (chattr +C) imply disabling data checksumming on it? The same way as mount options behave (nodatacow implies nodatasum)? Moreover may it disable checksumming only for newly written extents and keep for reading existing ones?
