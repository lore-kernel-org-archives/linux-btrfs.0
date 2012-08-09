Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:57827 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753602Ab2HIQoV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Aug 2012 12:44:21 -0400
Message-ID: <5023E8DC.50702@giantdisaster.de>
Date: Thu, 09 Aug 2012 18:44:12 +0200
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Linux Btrfs List <linux-btrfs@vger.kernel.org>,
        Miao Xie <miaox@cn.fujitsu.com>, David Sterba <dave@jikos.cz>
Subject: Re: [BUG] btrfs dev del causes 'possible circular locking dependency
 detected'
References: <5023D916.6030707@giantdisaster.de> <20120809160157.GF17430@twin.jikos.cz>
In-Reply-To: <20120809160157.GF17430@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 9 Aug 2012 18:01:57 +0200, David Sterba wrote:
> On Thu, Aug 09, 2012 at 05:36:54PM +0200, Stefan Behrens wrote:
>> Aug  9 16:02:21 qvarne kernel: [  543.479460] -> #2 (&fs_info->cleaner_mutex){+.+...}:
>> Aug  9 16:02:21 qvarne kernel: [  543.541341]        [<ffffffff810da005>] lock_acquire+0x95/0x150
>> Aug  9 16:02:21 qvarne kernel: [  543.612269]        [<ffffffff819259a1>] mutex_lock_nested+0x71/0x360
>> Aug  9 16:02:21 qvarne kernel: [  543.688396]        [<ffffffffa00da06f>] btrfs_commit_super+0x1f/0x100 [btrfs]
>> Aug  9 16:02:21 qvarne kernel: [  543.773884]        [<ffffffffa00db8a8>] close_ctree+0x318/0x360 [btrfs]
>> Aug  9 16:02:21 qvarne kernel: [  543.853132]        [<ffffffffa00b3da4>] btrfs_put_super+0x14/0x20 [btrfs]
>> Aug  9 16:02:21 qvarne kernel: [  543.934459]        [<ffffffff8118ce6d>] generic_shutdown_super+0x5d/0xf0
>> Aug  9 16:02:21 qvarne kernel: [  544.014747]        [<ffffffff8118cf91>] kill_anon_super+0x11/0x20
>> Aug  9 16:02:21 qvarne kernel: [  544.087756]        [<ffffffffa00b7405>] btrfs_kill_super+0x15/0x90 [btrfs]
>> Aug  9 16:02:21 qvarne kernel: [  544.170124]        [<ffffffff8118d1bd>] deactivate_locked_super+0x3d/0x70
>> Aug  9 16:02:21 qvarne kernel: [  544.251452]        [<ffffffff8118dcf9>] deactivate_super+0x49/0x70
>> Aug  9 16:02:21 qvarne kernel: [  544.325500]        [<ffffffff811a8eae>] mntput_no_expire+0xfe/0x160
>> Aug  9 16:02:21 qvarne kernel: [  544.400588]        [<ffffffff811a9c69>] sys_umount+0x69/0x3a0
>> Aug  9 16:02:21 qvarne kernel: [  544.469435]        [<ffffffff81931162>] system_call_fastpath+0x16/0x1b
>> Aug  9 16:02:21 qvarne kernel: [  544.547644]
>> Aug  9 16:02:21 qvarne kernel: [  544.547644] -> #1 (&type->s_umount_key#31){+++++.}:
>> Aug  9 16:02:21 qvarne kernel: [  544.608588]        [<ffffffff810da005>] lock_acquire+0x95/0x150
>> Aug  9 16:02:21 qvarne kernel: [  544.679516]        [<ffffffff81926ca7>] down_read+0x47/0x8e
>> Aug  9 16:02:21 qvarne kernel: [  544.746283]        [<ffffffff811b3ae8>] writeback_inodes_sb_nr_if_idle+0x38/0x60
> 
> this matches the "umount vs cleaner vs writeback_idle" deadlock pattern, Miao sent
> patches some time ago, I've tested them succesfully, but they're not
> merged upstream.
> 
> http://thread.gmane.org/gmane.linux.file-systems/63900
> vfs: re-implement writeback_inodes_sb(_nr)_if_idle() and rename them
> 
> http://thread.gmane.org/gmane.comp.file-systems.btrfs/17040
> [PATCH 2/2] Btrfs: flush all the dirty pages if try_to_writeback_inodes_sb_nr() fails

After applying these two patches from Miao Xie, logcheck does not
complain anymore.

Could we start a second attempt to add these VFS, ext4 and btrfs changes?
