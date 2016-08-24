Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:35667 "EHLO
        mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755257AbcHXSaY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Aug 2016 14:30:24 -0400
Received: by mail-oi0-f45.google.com with SMTP id 4so34872502oih.2
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Aug 2016 11:30:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRZNNTZ5ymH-X9Cq=h+_aaATym40W42BJ-xM5ECJOQnDg@mail.gmail.com>
References: <CAJCQCtT5YA9EMq1ZC-qeZcNLUeg1GocBm3nT2nZFEBigmV4BxQ@mail.gmail.com>
 <CAJCQCtQjX+0nAWRNPK2gYNoi8wvHxTMEzm6v84PZKXnTLxc50Q@mail.gmail.com>
 <CAJCQCtT0=gEwBerYXYnyueMk3JnmGZp71qBJFB5N4qR4ASF7cg@mail.gmail.com> <CAJCQCtRZNNTZ5ymH-X9Cq=h+_aaATym40W42BJ-xM5ECJOQnDg@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 24 Aug 2016 12:30:23 -0600
Message-ID: <CAJCQCtTo7nS7grh-9XWTKXX_h2pXPXCbLMRGmTfa=NzHq2Aa6g@mail.gmail.com>
Subject: Re: btrfs-progs 4.7, check reports many "incorrect local backref
 count" messages
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[chris@f24s ~]$ btrfs --version
btrfs-progs v4.5.3
[chris@f24s ~]$ sudo btrfs check /dev/mapper/brick1
Checking filesystem on /dev/mapper/brick1
UUID: 30f4724a-9a9f-4a5d-a37d-3e53876bf2e1
checking extents
checking free space cache
checking fs roots
checking csums
checking root refs
found 423302123916 bytes used err is 0
total csum bytes: 412769428
total tree bytes: 626229248
total fs tree bytes: 160776192
total extent tree bytes: 18219008
btree space waste bytes: 68151409
file data blocks allocated: 1030486196224
 referenced 1005660291072


[chris@f24s ~]$ btrfs --version
btrfs-progs v4.6.1
[chris@f24s ~]$ sudo btrfs check /dev/mapper/brick1
Checking filesystem on /dev/mapper/brick1
UUID: 30f4724a-9a9f-4a5d-a37d-3e53876bf2e1
checking extents
checking free space cache
checking fs roots
checking csums
checking root refs
found 423405670400 bytes used err is 0
total csum bytes: 412769428
total tree bytes: 626229248
total fs tree bytes: 160776192
total extent tree bytes: 18219008
btree space waste bytes: 68151409
file data blocks allocated: 1030486196224
 referenced 1005660291072


Looks like it's some kind of regression, or just confusing messages
meant for developers and not the user. It's sort of annoying that
these messages don't come with any advice what the user is supposed to
do about them.

Curious the found bytes between progs 4.5.3 and 4.6.1 differ... file
system was not mounted in between these checks.


----
Chris Murphy
