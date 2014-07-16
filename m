Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tetsuo.zabbo.net ([50.193.208.193]:39704 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933237AbaGPRUW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Jul 2014 13:20:22 -0400
Date: Wed, 16 Jul 2014 10:20:21 -0700
From: Zach Brown <zab@zabbo.net>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/1] Btrfs: fix sparse warning
Message-ID: <20140716172021.GA10833@lenny.home.zabbo.net>
References: <1405451837-8235-1-git-send-email-fabf@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1405451837-8235-1-git-send-email-fabf@skynet.be>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 15, 2014 at 09:17:17PM +0200, Fabian Frederick wrote:
> Fix the following sparse warning:
> fs/btrfs/send.c:518:51: warning: incorrect type in argument 2 (different address spaces)
> fs/btrfs/send.c:518:51:    expected char const [noderef] <asn:1>*<noident>
> fs/btrfs/send.c:518:51:    got char *
> 
> We can safely use (const char __user *) with set_fs(KERNEL_DS)

Yeah, that cast is correct.

Reviewed-by: Zach Brown <zab@zabbo.net>

> @@ -515,7 +515,8 @@ static int write_buf(struct file *filp, const void *buf, u32 len, loff_t *off)

Though this probably wants to be rewritten in terms of kernel_write().
That'd give an opportunity to get rid of the sctx->send_off and have it
use f_pos in the filp.

- z
