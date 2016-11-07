Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.sigma-it.ru ([212.65.87.1]:56926 "EHLO mail.sigma-it.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750717AbcKGHAe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 7 Nov 2016 02:00:34 -0500
From: =?UTF-8?B?0JTQvNC40YLRgNC40Lkg0J3QtdGH0LDQtdCy?=
        <d.nechaev@sigma-it.ru>
To: "'Austin S. Hemmelgarn'" <ahferroin7@gmail.com>,
        "'Peter Becker'" <floyd.net@gmail.com>,
        "'linux-btrfs'" <linux-btrfs@vger.kernel.org>
References: <053201d235cc$e62439e0$b26cada0$@sigma-it.ru> <CAEtw4r31p7YmB8mq9qGpu=mW=KmLMBeP7EdfS0YbpzA9CfrMxw@mail.gmail.com> <06d901d235dc$ee308480$ca918d80$@sigma-it.ru> <CAEtw4r1BXKOVOTqVTdoBZDE2N4pb88x6fATMCeKErtoy3RwC-w@mail.gmail.com> <848ef375-e4a5-c668-4a77-d59b1cf0e788@gmail.com>
In-Reply-To: <848ef375-e4a5-c668-4a77-d59b1cf0e788@gmail.com>
Subject: RE: Problem with btrfs snapshots
Date: Mon, 7 Nov 2016 10:00:31 +0300
Message-ID: <03b901d238c4$a0e7d8a0$e2b789e0$@sigma-it.ru>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Part of script:
================
btrfs filesystem sync 
cp -pR --reflink 
btrfs filesystem sync 
================
So if another copy or two of script is starting in the moment, then first snapshot is making - then we receive ENOSPC.

-----Original Message-----
From: Austin S. Hemmelgarn [mailto:ahferroin7@gmail.com] 
Sent: Thursday, November 03, 2016 6:07 PM
To: Peter Becker; Дмитрий Нечаев; linux-btrfs
Subject: Re: Problem with btrfs snapshots

On 2016-11-03 10:21, Peter Becker wrote:
> (copy for mainlinglist)
>
> 2016-11-03 15:16 GMT+01:00 Дмитрий Нечаев <d.nechaev@sigma-it.ru>:
> Yes. We tried "sync" in our script but it doesn't help. It works only 
> then we make one snapshot at a time. Even if we use "sync" before and 
> after creating snapshot, it doesn't help.
You might try 'btrfs filesystem sync' called on the filesystem the snapshots are being created on.  This works differently from the sync() syscall used by regular 'sync', and as a result forces metadata out as well as regular data (and it's almost certainly a metadata issue you are seeing), and it won't have as much impact on the rest of the system.


