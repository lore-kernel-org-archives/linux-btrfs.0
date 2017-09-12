Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([91.121.75.85]:53320 "EHLO len.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751370AbdILLJp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Sep 2017 07:09:45 -0400
Date: Tue, 12 Sep 2017 16:09:43 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Adam Borowski <kilobyte@angband.pl>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: qemu-kvm VM died during partial raid1 problems of btrfs
Message-ID: <20170912160943.582507f6@natsu>
In-Reply-To: <20170912103214.6dzjlugcr7q47x6g@angband.pl>
References: <2ee9f15b-a11a-886e-2460-557bb9f8d41d@rqc.ru>
        <CAGqmi770j8gO8zFNiMgie5n3b6rm2JVdvG+K+HMDJ-CpMCiEiw@mail.gmail.com>
        <69e843f4-1233-261a-3b88-306359ef20c9@rqc.ru>
        <pan$556a1$a0a94487$f12a0554$4371a5e6@cox.net>
        <20170912103214.6dzjlugcr7q47x6g@angband.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 12 Sep 2017 12:32:14 +0200
Adam Borowski <kilobyte@angband.pl> wrote:

> discard in the guest (not supported over ide and virtio, supported over scsi
> and virtio-scsi)

IDE does support discard in QEMU, I use that all the time.

It got broken briefly in QEMU 2.1 [1], but then fixed again.

[1] https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=757927


-- 
With respect,
Roman
