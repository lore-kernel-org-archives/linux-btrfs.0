Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from www.humilis.net ([80.100.93.5]:53065 "EHLO panda.humilis.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752585AbbFBH0F (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 2 Jun 2015 03:26:05 -0400
Date: Tue, 2 Jun 2015 09:26:01 +0200
From: Sander <sander@humilis.net>
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: possible raid6 corruption
Message-ID: <20150602072601.GA16215@panda>
Reply-To: sander@humilis.net
References: <1433208291.7073.52.camel@scientia.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1433208291.7073.52.camel@scientia.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Christoph Anton Mitterer wrote (ao):
> May 19 03:25:50 lcg-lrz-dc10 kernel: [903106.581205] sd 0:0:14:0: Device offlined - not ready after error recovery

> May 28 16:38:43 lcg-lrz-dc10 kernel: [1727488.984810] sd 0:0:14:0: rejecting I/O to offline device

> May 28 16:39:19 lcg-lrz-dc10 kernel: [1727524.067182] BTRFS: lost page write due to I/O error on /dev/sdm
> May 28 16:39:19 lcg-lrz-dc10 kernel: [1727524.067426] BTRFS: bdev /dev/sdm errs: wr 1, rd 0, flush 0, corrupt 0, gen 0

> May 28 21:03:06 lcg-lrz-dc10 kernel: [1743336.347191] sd 0:0:14:0: rejecting I/O to offline device
> May 28 21:03:06 lcg-lrz-dc10 kernel: [1743336.369569] BTRFS: lost page write due to I/O error on /dev/sdm

> Well as I've said,.. maybe it's not an issue at all, but at least it's
> strange that this happens on brand new hardware only with the
> btrfs-raid56 node, especially the gazillions of megasas messages.

Brand new hardware is most likely to show (hardware) issues as it has no
proven track record yet while it was subject to any kind of abuse during
transport. I'm sure you will see the same if you put sw raid + ext4 on
this server.

Nice hardware btw, please share your findings.

	Sander
