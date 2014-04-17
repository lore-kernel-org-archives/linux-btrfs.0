Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:40784 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751517AbaDQJqy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Apr 2014 05:46:54 -0400
Date: Thu, 17 Apr 2014 10:46:50 +0100
From: Tomasz Chmielewski <tch@virtall.com>
To: <miaox@cn.fujitsu.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: filesystem hang when doing snapshot (3.15-rc1)
Message-ID: <20140417104650.31531b12@s9>
In-Reply-To: <534F3B60.3090109@cn.fujitsu.com>
References: <20140416230511.1cbceb2c@virtall.com>
	<534F3B60.3090109@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 17 Apr 2014 10:24:32 +0800
Miao Xie <miaox@cn.fujitsu.com> wrote:

> > scsi_request_fn+0x31/0x4dc [scsi_mod] [120462.559546]
> > [<ffffffff8107a8af>] ? ktime_get_ts+0x50/0xb7 [120462.559594]
> > [<ffffffff810a32db>] ? delayacct_end+0x77/0x82 [120462.559641]
> > [<ffffffff810b1d6e>] ? __lock_page+0x63/0x63 [120462.559688]
> > [<ffffffff8139d724>] schedule+0x6a/0x6c [120462.559734]
> > [<ffffffff8139d7b0>] io_schedule+0x8a/0xc8 [120462.559780]
> > [<ffffffff810b1d77>] sleep_on_page+0x9/0xd [120462.559827]
> > [<ffffffff8139db83>] __wait_on_bit_lock+0x43/0x8a [120462.559874]
> > [<ffffffff810b1d6c>] __lock_page+0x61/0x63 [120462.559921]
> > [<ffffffff810684de>] ? wake_atomic_t_function+0x28/0x28
> > [120462.559969]  [<ffffffff810b2064>] find_lock_entry+0x39/0x5d
> > [120462.560016]  [<ffffffff810b2091>] find_lock_page+0x9/0x16
> 
> It is very strange that we should be blocked here. Could you tell me
> how to reproduce this problem?

I'm not sure, sorry.

It's just a routine cronjob:

- rsync -> snapshot -> remove old snapshots

-- 
Tomasz Chmielewski
http://wpkg.org

