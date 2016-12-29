Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wj0-f182.google.com ([209.85.210.182]:34821 "EHLO
        mail-wj0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752129AbcL2PbQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 29 Dec 2016 10:31:16 -0500
Received: by mail-wj0-f182.google.com with SMTP id v7so360874757wjy.2
        for <linux-btrfs@vger.kernel.org>; Thu, 29 Dec 2016 07:31:15 -0800 (PST)
Subject: Incremental send receive of snapshot fails
From: Giuseppe Della Bianca <g.dellabianca@gestiware.it>
To: igeligel@gmx.net
Cc: linux-btrfs@vger.kernel.org
In-Reply-To: <1d9e30d3-f34d-9293-8150-b48f8be33bca@gmx.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 29 Dec 2016 16:31:49 +0100
Message-ID: <1483025509.3496.34.camel@localhost>
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi.

In such cases, I have run btrfs check (not repair mode !!!) in every
file system/partition that is involved in creating, sending and
receiving snapshots.


Regards.

Gdb


>Rene Wolf Wed, 28 Dec 2016 03:51:07 -0800


>Hi all
>I have a problem with incremental snapshot send receive in btrfs. May
be my google-fu is weak, but I couldn't find any pointers, so here goes.

>A few words about my setup first:

>I have multiple clients that back up to a central server. All clients
(and the server) are running a (K)Ubuntu 16.10 64Bit on btrfs. Backing
up works with btrfs send / receive, either full or incremental,
depending on whats available on >the server side. All clients have the
usual (Ubuntu) btrfs layout: 2 subvolumes, one for / and one for /home;
explicit entries in fstab; root volume not mounted anywhere. For further
details see the P.s. at the end.
]zac[


