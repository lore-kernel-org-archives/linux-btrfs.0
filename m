Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f41.google.com ([209.85.215.41]:45779 "EHLO
        mail-lf0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756363AbdKQDv5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 16 Nov 2017 22:51:57 -0500
Received: by mail-lf0-f41.google.com with SMTP id e143so1183804lfg.12
        for <linux-btrfs@vger.kernel.org>; Thu, 16 Nov 2017 19:51:56 -0800 (PST)
Subject: Re: Need help with incremental backup strategy (snapshots,
 defragmentingt & performance)
To: Kai Krakow <hurikhan77@gmail.com>, linux-btrfs@vger.kernel.org
References: <CAH=dxU5mGQ5ws11fFKC+X3F810MceMxNBwnCR=g=Rau9DLDRng@mail.gmail.com>
 <20171101101510.218eeead@natsu>
 <CAH=dxU56geiO7MuWSbPgpfBQ3vbkPYm6juQZzu3-1=-RzG+ZSQ@mail.gmail.com>
 <20171114135040.65a659c0@natsu>
 <CAH=dxU7wjag+BPNdu__WidU1qNPeF7Sxgc8YthAVvxbrHx5VmA@mail.gmail.com>
 <20171116171330.7493c9c4@jupiter.sol.kaishome.de>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <d7f8d215-e845-79e6-12a9-29468287d7b9@gmail.com>
Date: Fri, 17 Nov 2017 06:51:52 +0300
MIME-Version: 1.0
In-Reply-To: <20171116171330.7493c9c4@jupiter.sol.kaishome.de>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

16.11.2017 19:13, Kai Krakow пишет:
...
> > BTW: From user API perspective, btrfs snapshots do not guarantee
> perfect granular consistent backups.

Is it documented somewhere? I was relying on crash-consistent
write-order-preserving snapshots in NetApp for as long as I remember.
And I was sure btrfs offers is as it is something obvious for
redirect-on-write idea.

> A user-level file transaction may
> still end up only partially in the snapshot. If you are running
> transaction sensitive applications, those usually do provide some means
> of preparing a freeze and a thaw of transactions.
> 

Is snapshot creation synchronous to know when thaw?

> I think the user transactions API which could've been used for this
> will even be removed during the next kernel cycles. I remember
> reiserfs4 tried to deploy something similar. But there's no consistent
> layer in the VFS for subscribing applications to filesystem snapshots
> so they could prepare and notify the kernel when they are ready.
> 

I do not see what VFS has to do with it. NetApp works by simply
preserving previous consistency point instead of throwing it away. I.e.
snapshot is always last committed image on stable storage. Would
something like this be possible on btrfs level by duplicating current
on-disk root (sorry if I use wrong term)?

...
