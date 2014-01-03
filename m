Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from www.humilis.net ([80.100.93.5]:41132 "EHLO panda.humilis.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751262AbaACIjx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 3 Jan 2014 03:39:53 -0500
Date: Fri, 3 Jan 2014 09:39:50 +0100
From: Sander <sander@humilis.net>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: Aastha Mehta <aasthakm@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: question regarding caching
Message-ID: <20140103083950.GB29349@panda>
Reply-To: sander@humilis.net
References: <CAEx9m44ZiJLqTO1_G_rVfn+csD7_pOguEdiAjsvr3uPzna+mFA@mail.gmail.com>
 <52C30C8E.9020103@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <52C30C8E.9020103@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Austin S Hemmelgarn wrote (ao):
> The data is probably still cached in the block layer, so after
> unmounting, you could try 'echo 1 > /proc/sys/vm/drop_caches' before
> mounting again, but make sure to run sync right before doing that,
> otherwise you might lose data.

Lose data? Where you get this from?

	Sander
