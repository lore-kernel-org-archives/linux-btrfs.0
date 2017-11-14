Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([91.121.75.85]:50502 "EHLO len.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751466AbdKNIVp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Nov 2017 03:21:45 -0500
Date: Tue, 14 Nov 2017 13:21:42 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Marat Khalili <mkh@rqc.ru>
Cc: Dave <davestechshop@gmail.com>,
        Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Need help with incremental backup strategy (snapshots,
 defragmentingt & performance)
Message-ID: <20171114132142.2c30cd8e@natsu>
In-Reply-To: <ebfc86ae-8398-4ecf-d3c9-a0f3e997e9d9@rqc.ru>
References: <CAH=dxU5mGQ5ws11fFKC+X3F810MceMxNBwnCR=g=Rau9DLDRng@mail.gmail.com>
 <20171101101510.218eeead@natsu>
 <CAH=dxU56geiO7MuWSbPgpfBQ3vbkPYm6juQZzu3-1=-RzG+ZSQ@mail.gmail.com>
 <ebfc86ae-8398-4ecf-d3c9-a0f3e997e9d9@rqc.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 14 Nov 2017 10:14:55 +0300
Marat Khalili <mkh@rqc.ru> wrote:

> Don't keep snapshots under rsync target, place them under ../snapshots 
> (if snapper supports this):

> Or, specify them in --exclude and avoid using --delete-excluded.

Both are good suggestions, in my case each system does have its own snapshots
as well, but they are retained for much shorter. So I both use --exclude to
avoid fetching the entire /snaps tree from the source system, and store
snapshots of the destination system outside of the rsync target dirs.

>Or keep using -x if it works, why not?

-x will exclude content of all subvolumes down the tree on the source side --
not only the time-based ones. If you take care to never casually create any
subvolumes content of which you'd still want backed up, then I guess it can
work.

-- 
With respect,
Roman
