Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:65050 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753470AbdHUCnU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 20 Aug 2017 22:43:20 -0400
Subject: Re: BTRFS warning (device dm-0): unhandled fiemap cache detected
To: Christoph Anton Mitterer <calestyo@scientia.net>,
        linux-btrfs@vger.kernel.org
References: <1503282544.4669.10.camel@scientia.net>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <d0d41a1e-7191-4c46-78a1-615dbcfe71c0@gmx.com>
Date: Mon, 21 Aug 2017 10:43:12 +0800
MIME-Version: 1.0
In-Reply-To: <1503282544.4669.10.camel@scientia.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017年08月21日 10:29, Christoph Anton Mitterer wrote:
> Hey.
> 
> Just got the following with 4.12.6:
> 
> Aug 21 03:29:51 heisenberg kernel: BTRFS warning (device dm-0): unhandled fiemap cache detected: offset=0 phys=812641906688 len=12288 flags=0x0
> Aug 21 03:29:56 heisenberg kernel: BTRFS warning (device dm-0): unhandled fiemap cache detected: offset=0 phys=812641906688 len=12288 flags=0x0
> Aug 21 03:30:58 heisenberg kernel: BTRFS warning (device dm-0): unhandled fiemap cache detected: offset=0 phys=813760614400 len=32768 flags=0x0
> Aug 21 03:31:15 heisenberg kernel: BTRFS warning (device dm-0): unhandled fiemap cache detected: offset=0 phys=812641906688 len=12288 flags=0x0

This is just warning about there is some fiemap extent cached but not 
submitted.
So in fact harmless, only mean to info developers.
> 
> Is it what should be fixed with:
> https://patchwork.kernel.org/patch/9803291/
> 
> ?

But it is already in v4.12, so there is some other case I missed.

Any reproducer?

> 
> Is this harmless or must I assume that some part of my data/fs is now
> corrupt and should I recover from backup?

Harmless, it is only designed to merge fiemap output.
No data is touched at all.

Sorry for the trouble.

Thanks,
Qu

> 
> Thanks,
> Chris.
> 
