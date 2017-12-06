Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:42279 "EHLO
        mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751288AbdLFGIl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Dec 2017 01:08:41 -0500
Received: by mail-oi0-f51.google.com with SMTP id o64so1863122oia.9
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Dec 2017 22:08:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CABi++uJj6x=ZT1QbB7vu5Zh3_Mf6nsLNMAO9QXNLEBQN_ngoYA@mail.gmail.com>
References: <CABi++uJj6x=ZT1QbB7vu5Zh3_Mf6nsLNMAO9QXNLEBQN_ngoYA@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 5 Dec 2017 23:08:39 -0700
Message-ID: <CAJCQCtQtYBP98QEWAn5Ks1YuEB9G1ZQ15TBk8i3MjeBOB1892g@mail.gmail.com>
Subject: Re: Chunk-Recovery fails with alignment error
To: Benjamin Beichler <hadrian2002@googlemail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 5, 2017 at 12:22 PM, Benjamin Beichler
<hadrian2002@googlemail.com> wrote:
> Hi,
>
> I have a setup as following:  (1,7TB drive + 128GB SSD in Bcache) <==>
> luks device <==> btrfs FS
> I have been running Arch linux with newest stable kernel 4.14.

There is a known bug in 4.14 that affects all bcache backed file
systems (maybe more, I think it's not a bcache specific bug). You need
to downgrade or upgrade your kernel. Fix should be in 4.14.2.

The bug was found quickly enough I'm surprised 4.14.0 would be in Arch
stable, let alone it *still* being in stable.


-- 
Chris Murphy
