Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35884 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751246AbcAOSQs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Jan 2016 13:16:48 -0500
Date: Fri, 15 Jan 2016 19:16:44 +0100
From: David Sterba <dsterba@suse.cz>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        tglx@linutronix.de, Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: [PATCH] btrfs: initialize the seq counter in struct btrfs_device
Message-ID: <20160115181644.GJ4227@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1452865035-19681-1-git-send-email-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1452865035-19681-1-git-send-email-bigeasy@linutronix.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 15, 2016 at 02:37:15PM +0100, Sebastian Andrzej Siewior wrote:
> I managed to trigger this:
> | INFO: trying to register non-static key.
> | the code is fine but needs lockdep annotation.
> | turning off the locking correctness validator.
> | CPU: 1 PID: 781 Comm: systemd-gpt-aut Not tainted 4.4.0-rt2+ #14
> | Hardware name: ARM-Versatile Express
> | [<80307cec>] (dump_stack)
> | [<80070e98>] (__lock_acquire)
> | [<8007184c>] (lock_acquire)
> | [<80287800>] (btrfs_ioctl)
> | [<8012a8d4>] (do_vfs_ioctl)
> | [<8012ac14>] (SyS_ioctl)
> 
> so I think that btrfs_device_data_ordered_init() is not invoked behind
> a macro somewhere.

Right, and it hasn't been invoked anywhere  since it's introduction.
Accidentally working because the initial value is 0 (and the device
struct is zeroed), but the lockdep structure is not valid.

> Fixes: 7cc8e58d53cd ("Btrfs: fix unprotected device's variants on 32bits machine")
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Reviewed-by: David Sterba <dsterba@suse.com>
