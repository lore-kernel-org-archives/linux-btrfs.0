Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f193.google.com ([209.85.161.193]:34951 "EHLO
        mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753188AbcKZS4q (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 26 Nov 2016 13:56:46 -0500
Received: by mail-yw0-f193.google.com with SMTP id b66so6170613ywh.2
        for <linux-btrfs@vger.kernel.org>; Sat, 26 Nov 2016 10:56:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5108140.l7kIxhTaVr@exnet.gdb.it>
References: <1479730155.5832e3eb3fde8@webmail.adria.it> <5108140.l7kIxhTaVr@exnet.gdb.it>
From: Chris Murphy <lists@colorremedies.com>
Date: Sat, 26 Nov 2016 11:56:45 -0700
Message-ID: <CAJCQCtRpppbJb4a_zEdRFi7Fbxnhg5VkLktHuLMW2Z0H-cOkDg@mail.gmail.com>
Subject: Re: [CORRUPTION FILESYSTEM] Corrupted and unrecoverable file system
 during the snapshot receive
To: Giuseppe Della Bianca <bepi@adria.it>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I haven't seen this with 4.7.10. I suggest running 'btrfs check'
(without repair) using a recent btrfs-progs. You can find 4.8.3 in
koji, just download the appropriate rpm, and 'dnf update *rpm'

As for kernel, Fedora 23 has 4.8.8 in updates (stable) and 4.8.10 is
in updates-testing, I suggest moving to one of those.


Chris Murphy
