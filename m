Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:50570 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726105AbeIFOnV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Sep 2018 10:43:21 -0400
Received: by mail-it0-f68.google.com with SMTP id j81-v6so13989489ite.0
        for <linux-btrfs@vger.kernel.org>; Thu, 06 Sep 2018 03:08:37 -0700 (PDT)
Subject: Re: Transactional btrfs
To: Nathan Dehnel <ncdehnel@gmail.com>, linux-btrfs@vger.kernel.org
References: <CAEEhgEtgahZjLd-Uy-sFSc+36pNNUOa82sadJgBcbWKvPYsLiA@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <228f7179-6c5c-4412-2bb1-b0e73439b05a@gmail.com>
Date: Thu, 6 Sep 2018 06:08:33 -0400
MIME-Version: 1.0
In-Reply-To: <CAEEhgEtgahZjLd-Uy-sFSc+36pNNUOa82sadJgBcbWKvPYsLiA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-09-06 03:23, Nathan Dehnel wrote:
> https://lwn.net/Articles/287289/
> 
> In 2008, HP released the source code for a filesystem called advfs so
> that its features could be incorporated into linux filesystems. Advfs
> had a feature where a group of file writes were an atomic transaction.
> 
> https://www.usenix.org/system/files/conference/fast15/fast15-paper-verma.pdf
> 
> These guys used advfs to add a "syncv" system call that makes writes
> across multiple files atomic.
> 
> https://lwn.net/Articles/715918/
> 
> A patch was later submitted based on the previous paper in some way.
> 
> So I guess my question is, does btrfs support atomic writes across
> multiple files? Or is anyone interested in such a feature?
> 
I'm fairly certain that it does not currently, but in theory it would 
not be hard to add.

Realistically, the only cases I can think of where cross-file atomic 
_writes_ would be of any benefit are database systems.

However, if this were extended to include rename, unlink, touch, and a 
handful of other VFS operations, then I can easily think of a few dozen 
use cases.  Package managers in particular would likely be very 
interested in being able to atomically rename a group of files as a 
single transaction, as it would make their job _much_ easier.
