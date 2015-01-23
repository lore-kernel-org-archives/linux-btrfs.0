Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34084 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755389AbbAWO5h (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 23 Jan 2015 09:57:37 -0500
Date: Fri, 23 Jan 2015 15:57:35 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz, miaoxie@huawei.com
Subject: Re: [PATCH RFC v3 1/5] Revert "btrfs: add support for processing
 pending changes" related commits
Message-ID: <20150123145735.GN13289@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1422005505-9472-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1422005505-9472-2-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1422005505-9472-2-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 23, 2015 at 05:31:41PM +0800, Qu Wenruo wrote:
> For mount option change, later patches will introduce copy-n-update
> method and rwsem protects to keep mount options consistent during
> transaction.

That's a better approach, for the mount options.

> For sysfs interface to change label/features, it will keep the same
> behavior as 'btrfs pro set', so pending changes are also not needed.

This still leaves the transaction commit inside the syfs handler, that
was one of the points not to do that.

The callstack looks safe from, eg. the label handler:

[169148.523158] WARNING: CPU: 1 PID: 2044 at fs/btrfs/sysfs.c:394 btrfs_label_store+0x135/0x190 [btrfs]()
[169148.533925] Modules linked in: btrfs dm_flakey rpcsec_gss_krb5 loop [last unloaded: btrfs]
[169148.536950] CPU: 1 PID: 2044 Comm: bash Tainted: G        W      3.19.0-rc5-default+ #211
[169148.536952] Hardware name: Intel Corporation Santa Rosa platform/Matanzas, BIOS TSRSCRB1.86C.0047.B00.0610170821 10/17/06
[169148.536954]  000000000000018a ffff88007a753dc8 ffffffff81a9898b 000000000000018a
[169148.536963]  0000000000000000 ffff88007a753e08 ffffffff81077f65 ffff880077fb0100
[169148.536972]  ffff880075dc0000 ffff880077fbff00 0000000000000009 ffff880075dc06d0
[169148.536980] Call Trace:
[169148.536983]  [<ffffffff81a9898b>] dump_stack+0x4f/0x6c
[169148.536991]  [<ffffffff81077f65>] warn_slowpath_common+0x95/0xe0
[169148.537000]  [<ffffffff81077fca>] warn_slowpath_null+0x1a/0x20
[169148.537005]  [<ffffffffa0052b65>] btrfs_label_store+0x135/0x190 [btrfs]
[169148.537030]  [<ffffffff813ed8b7>] kobj_attr_store+0x17/0x20
[169148.537037]  [<ffffffff812147ff>] sysfs_kf_write+0x4f/0x70
[169148.537044]  [<ffffffff81213cc8>] kernfs_fop_write+0x128/0x180
[169148.537051]  [<ffffffff8119f404>] vfs_write+0xd4/0x1d0
[169148.537059]  [<ffffffff8119f7b9>] SyS_write+0x59/0xd0
[169148.537070]  [<ffffffff81a9f9d2>] system_call_fastpath+0x12/0x17

Lockep shows these locks held:

[169148.537296] 4 locks held by bash/2044:
[169148.537309]  #0:  (sb_writers#5){.+.+.+}, at: [<ffffffff8119f4e0>] vfs_write+0x1b0/0x1d0
[169148.537319]  #1:  (&of->mutex){+.+.+.}, at: [<ffffffff81213c2e>] kernfs_fop_write+0x8e/0x180
[169148.537330]  #2:  (s_active#214){.+.+.+}, at: [<ffffffff81213c36>] kernfs_fop_write+0x96/0x180
[169148.537342]  #3:  (tasklist_lock){.+.+..}, at: [<ffffffff810b9ed4>] debug_show_all_locks+0x44/0x1e0

#3 is from lockdep
#2 is not really a lock, annotated vfs atomic counter
#0 is annotated atomic, the freezing barrier

#1 is a kernfs mutex that, afaics it's per file, but I don't like to see
the lock dependency here. That's a lock we can see now, but it's outside
of btrfs or the vfs. It's a matter of precaution.
