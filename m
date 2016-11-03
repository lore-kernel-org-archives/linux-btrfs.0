Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f175.google.com ([209.85.161.175]:33937 "EHLO
        mail-yw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755798AbcKCPHc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Nov 2016 11:07:32 -0400
Received: by mail-yw0-f175.google.com with SMTP id t125so49759957ywc.1
        for <linux-btrfs@vger.kernel.org>; Thu, 03 Nov 2016 08:07:31 -0700 (PDT)
Subject: Re: Problem with btrfs snapshots
To: Peter Becker <floyd.net@gmail.com>,
        =?UTF-8?B?0JTQvNC40YLRgNC40Lkg0J0=?= =?UTF-8?B?0LXRh9Cw0LXQsg==?=
        <d.nechaev@sigma-it.ru>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <053201d235cc$e62439e0$b26cada0$@sigma-it.ru>
 <CAEtw4r31p7YmB8mq9qGpu=mW=KmLMBeP7EdfS0YbpzA9CfrMxw@mail.gmail.com>
 <06d901d235dc$ee308480$ca918d80$@sigma-it.ru>
 <CAEtw4r1BXKOVOTqVTdoBZDE2N4pb88x6fATMCeKErtoy3RwC-w@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <848ef375-e4a5-c668-4a77-d59b1cf0e788@gmail.com>
Date: Thu, 3 Nov 2016 11:07:24 -0400
MIME-Version: 1.0
In-Reply-To: <CAEtw4r1BXKOVOTqVTdoBZDE2N4pb88x6fATMCeKErtoy3RwC-w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-11-03 10:21, Peter Becker wrote:
> (copy for mainlinglist)
>
> 2016-11-03 15:16 GMT+01:00 Дмитрий Нечаев <d.nechaev@sigma-it.ru>:
> Yes. We tried "sync" in our script but it doesn't help. It works only
> then we make one snapshot at a time. Even if we use "sync" before and
> after creating snapshot, it doesn't help.
You might try 'btrfs filesystem sync' called on the filesystem the 
snapshots are being created on.  This works differently from the sync() 
syscall used by regular 'sync', and as a result forces metadata out as 
well as regular data (and it's almost certainly a metadata issue you are 
seeing), and it won't have as much impact on the rest of the system.

