Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([91.121.75.85]:44480 "EHLO len.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751157AbdHVQsT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Aug 2017 12:48:19 -0400
Date: Tue, 22 Aug 2017 21:48:18 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Ulli Horlacher <framstag@rus.uni-stuttgart.de>
Cc: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: finding root filesystem of a subvolume?
Message-ID: <20170822214818.72bb4638@natsu>
In-Reply-To: <20170822154537.GJ14804@rus.uni-stuttgart.de>
References: <20170822122350.GA14804@rus.uni-stuttgart.de>
        <22940.17147.756378.347580@tree.ty.sabi.co.uk>
        <62494c0c-0c27-5b36-3727-b8755eb2cb58@gmail.com>
        <20170822154537.GJ14804@rus.uni-stuttgart.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 22 Aug 2017 17:45:37 +0200
Ulli Horlacher <framstag@rus.uni-stuttgart.de> wrote:

> In perl I have now:
> 
> $root = $volume;
> while (`btrfs subvolume show "$root" 2>/dev/null` !~ /toplevel subvolume/) {
>   $root = dirname($root);
>   last if $root eq '/';
> }
> 
> 

If you are okay with rolling your own solutions like this, take a look at
"btrfs filesystem usage <path>". It will print the blockdevice used for
mounting the base FS. From that you can find the mountpoint via /proc/mounts.

Performance-wise it seems to work instantly on an almost full 2TB FS.

-- 
With respect,
Roman
