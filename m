Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57570 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757086Ab3BKNIG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Feb 2013 08:08:06 -0500
Date: Mon, 11 Feb 2013 14:08:03 +0100
From: David Sterba <dsterba@suse.cz>
To: Blair Zajac <blair@orcaware.com>
Cc: linux-btrfs@vger.kernel.org, chris.mason@fusionio.com, jbacik@fusionio.com
Subject: Re: v3.8-rc6: btrfs-transacti Tainted: GF in btrfs_orphan_commit_root
Message-ID: <20130211130803.GO12339@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <5116A1AC.7040300@orcaware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5116A1AC.7040300@orcaware.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Feb 09, 2013 at 11:21:16AM -0800, Blair Zajac wrote:
> Running an Ubuntu Raring VM which was built a week ago that is now running
> 3.8-rc6, I was booting it last night when it hung.  After a few forced
> reboots, it came back up and I found the attached in kern.log.
> 
> Are these reports useful?  Is there any additional information I can provide
> from the VM?  What happens if it gets hung again, is there additional
> information I can gather?

Yes they're useful, we can see if it's a known or new issue. I've hit
the same problem not so long ago and a guy on IRC reported the same
problem yesterday.

There's a fix from Josef, https://patchwork.kernel.org/patch/2083101/
and given the increasing number of reports (the warning followed by a
crash), I think this this a material for a late -rc.

Chris please consider picking this patch for 3.8. I think it qualifies
as a regression sice we haven't hit earlier than 3.8-rc4.


david


Warning for the reference:

[   37.372740] ------------[ cut here ]------------
[   37.372766] WARNING: at /build/buildd/linux-3.8.0/fs/btrfs/inode.c:2214 btrfs_orphan_commit_root+0x10c/0x110 [btrfs]()
[   37.372768] Hardware name: Bochs
[   37.372770] Modules linked in: dm_crypt(F) microcode(F) virtio_balloon(F) psmouse(F) serio_raw(F) acpiphp(F) btrfs(F) zlib_deflate(F) libcrc32c(F) ghash_clmulni_intel(F) 8139too(F) aesni_intel(F) aes_x86_64(F) xts(F) lrw(F) gf128mul(F) ablk_helper(F) cryptd(F) floppy(F) 8139cp(F)
[   37.372789] Pid: 274, comm: btrfs-transacti Tainted: GF            3.8.0-5-generic #10-Ubuntu
[   37.372791] Call Trace:
[   37.372813]  [<ffffffff8105879f>] warn_slowpath_common+0x7f/0xc0
[   37.372817]  [<ffffffff810587fa>] warn_slowpath_null+0x1a/0x20
[   37.372831]  [<ffffffffa00b1cac>] btrfs_orphan_commit_root+0x10c/0x110 [btrfs]
[   37.372845]  [<ffffffffa010dabb>] commit_fs_roots.isra.24+0xad/0x171 [btrfs]
[   37.372860]  [<ffffffffa00fdb36>] ? btrfs_scrub_pause+0xf6/0x110 [btrfs]
[   37.372865]  [<ffffffff816c3c1e>] ? _raw_spin_lock+0xe/0x20
[   37.372879]  [<ffffffffa00abd0d>] btrfs_commit_transaction+0x5bd/0xab0 [btrfs]
[   37.372882]  [<ffffffff8107dc00>] ? finish_wait+0x80/0x80
[   37.372895]  [<ffffffffa00a4cfd>] transaction_kthread+0x1bd/0x240 [btrfs]
[   37.372906]  [<ffffffffa00a4b40>] ? write_dev_flush.part.107+0xc0/0xc0 [btrfs]
[   37.372909]  [<ffffffff8107d2c0>] kthread+0xc0/0xd0
[   37.372913]  [<ffffffff8107d200>] ? kthread_create_on_node+0x120/0x120
[   37.372917]  [<ffffffff816cc4ac>] ret_from_fork+0x7c/0xb0
[   37.372920]  [<ffffffff8107d200>] ? kthread_create_on_node+0x120/0x120
[   37.372922] ---[ end trace b6a5be0adeb704db ]---

