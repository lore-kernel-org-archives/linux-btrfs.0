Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51563 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751466AbaE0BFU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 26 May 2014 21:05:20 -0400
Message-ID: <5383E4CC.7060405@suse.com>
Date: Mon, 26 May 2014 21:05:16 -0400
From: Jeff Mahoney <jeffm@suse.com>
MIME-Version: 1.0
To: dsterba@suse.cz, linux-btrfs <linux-btrfs@vger.kernel.org>,
        Chris Mason <clm@fb.com>
Subject: Re: [PATCH v2] btrfs: allocate raid type kobjects dynamically
References: <537FAA26.7070406@jeffreymahoney.com> <20140526172104.GH5346@twin.jikos.cz>
In-Reply-To: <20140526172104.GH5346@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 5/26/14, 1:21 PM, David Sterba wrote:
> This patch + the fix to add/remove links on the respective device 
> operation seem to work with the previous test that used to catch 
> the slab corruptions, so far so good.
> 
> After this has been running fine for a few hours, I've tried to do 
> a simple check
> 
> # cd /sys/fs/btrfs # find . -type f -exec cat '{}' \;
> 
> that produced this lockdep warning:

Thanks David. That's easy enough to fix.

- -Jeff

> [ 4943.485655] run xfstest btrfs/004 [ 4944.053971] BTRFS: device 
> fsid 6b90f3ce-cd83-44da-88e2-c89a4607b782 devid 1 transid 4 
> /dev/sda9 [ 4944.067637] BTRFS info (device sda9): disk space 
> caching is enabled [ 4944.075621] BTRFS: flagging fs with big 
> metadata feature [ 4944.093954] BTRFS: creating UUID tree [ 
> 4950.077597] BTRFS info (device sda9): setting 8 feature flag [ 
> 4950.084961] BTRFS info (device sda9): disk space caching is 
> enabled [ 4952.992993] [ 4952.996020] 
> ====================================================== [ 
> 4952.996020] [ INFO: possible circular locking dependency detected 
> ] [ 4952.996020] 3.15.0-rc7-default+ #146 Tainted: G        W [ 
> 4952.996020] 
> ------------------------------------------------------- [ 
> 4952.996020] cat/3822 is trying to acquire lock: [ 4952.996020] 
> (&found->groups_sem){++++..}, at: [<ffffffffa004babe>] 
> raid_bytes_show+0x3e/0xd0 [btrfs] [ 4952.996020] [ 4952.996020]
> but task is already holding lock: [ 4952.996020] 
> (s_active#149){++++.+}, at: [<ffffffff811ef1c9>] 
> kernfs_seq_start+0x39/0xb0 [ 4952.996020] [ 4952.996020] which
> lock already depends on the new lock. [ 4952.996020] [ 4952.996020]
> [ 4952.996020] the existing dependency chain (in reverse order) is:
> [ 4952.996020] -> #1 (s_active#149){++++.+}: [ 4952.996020] 
> [<ffffffff810b0662>] lock_acquire+0x92/0x120 [ 4952.996020] 
> [<ffffffff811edc07>] __kernfs_remove+0x2b7/0x380 [ 4952.996020] 
> [<ffffffff811ee787>] kernfs_remove+0x27/0x40 [ 4952.996020] 
> [<ffffffff811f0b3a>] sysfs_remove_dir+0x5a/0x90 [ 4952.996020] 
> [<ffffffff813ba028>] kobject_del+0x18/0x90 [ 4952.996020] 
> [<ffffffffa0023cb2>] btrfs_remove_block_group+0x442/0x580 [btrfs]
> [ 4952.996020]        [<ffffffffa005caf4>] 
> btrfs_relocate_chunk+0x624/0x770 [btrfs] [ 4952.996020] 
> [<ffffffffa005f652>] btrfs_balance+0x902/0xf50 [btrfs] [ 
> 4952.996020]        [<ffffffffa006b090>] 
> btrfs_ioctl_balance+0x1e0/0x350 [btrfs] [ 4952.996020] 
> [<ffffffffa006d4a9>] btrfs_ioctl+0xc39/0x1830 [btrfs] [ 
> 4952.996020]        [<ffffffff8118c381>] do_vfs_ioctl+0x91/0x560 [ 
> 4952.996020]        [<ffffffff8118c8a3>] SyS_ioctl+0x53/0x80 [ 
> 4952.996020]        [<ffffffff81a16cd2>] 
> system_call_fastpath+0x16/0x1b [ 4952.996020] -> #0 
> (&found->groups_sem){++++..}: [ 4952.996020] [<ffffffff810afc5c>]
> __lock_acquire+0x1c4c/0x1fa0 [ 4952.996020] [<ffffffff810b0662>]
> lock_acquire+0x92/0x120 [ 4952.996020] [<ffffffff81a0bedc>]
> down_read+0x4c/0xa0 [ 4952.996020] [<ffffffffa004babe>]
> raid_bytes_show+0x3e/0xd0 [btrfs] [ 4952.996020]
> [<ffffffff813b9ef6>] kobj_attr_show+0x16/0x20 [ 4952.996020]
> [<ffffffff811f04e9>] sysfs_kf_seq_show+0xd9/0x230 [ 4952.996020] 
> [<ffffffff811eec56>] kernfs_seq_show+0x26/0x30 [ 4952.996020] 
> [<ffffffff8119ec8f>] seq_read+0xef/0x410 [ 4952.996020] 
> [<ffffffff811efa35>] kernfs_fop_read+0x125/0x180 [ 4952.996020] 
> [<ffffffff81179fe4>] vfs_read+0xb4/0x180 [ 4952.996020] 
> [<ffffffff8117a269>] SyS_read+0x59/0xd0 [ 4952.996020] 
> [<ffffffff81a16cd2>] system_call_fastpath+0x16/0x1b [ 4952.996020]
>  [ 4952.996020] other info that might help us debug this: [ 
> 4952.996020] [ 4952.996020]  Possible unsafe locking scenario: [ 
> 4952.996020] [ 4952.996020]        CPU0                    CPU1 [ 
> 4952.996020]        ----                    ---- [ 4952.996020] 
> lock(s_active#149); [ 4952.996020] lock(&found->groups_sem); [
> 4952.996020] lock(s_active#149); [ 4952.996020]
> lock(&found->groups_sem); [ 4952.996020] [ 4952.996020]  ***
> DEADLOCK *** [ 4952.996020] [ 4952.996020] 3 locks held by
> cat/3822: [ 4952.996020]  #0: (&p->lock){+.+.+.}, at:
> [<ffffffff8119ebdf>] seq_read+0x3f/0x410 [ 4952.996020]  #1:
> (&of->mutex){+.+.+.}, at: [<ffffffff811ef1c1>] 
> kernfs_seq_start+0x31/0xb0 [ 4952.996020]  #2: 
> (s_active#149){++++.+}, at: [<ffffffff811ef1c9>] 
> kernfs_seq_start+0x39/0xb0 [ 4952.996020] [ 4952.996020] stack 
> backtrace: [ 4952.996020] CPU: 0 PID: 3822 Comm: cat Tainted: G W
> 3.15.0-rc7-default+ #146 [ 4952.996020] Hardware name: Intel 
> Corporation Santa Rosa platform/Matanzas, BIOS 
> TSRSCRB1.86C.0047.B00.0610170821 10/17/06 [ 4952.996020] 
> ffffffff82828a50 ffff880065aedb88 ffffffff81a07898 0000000000000001
> [ 4952.996020]  ffffffff82821230 ffff880065aedbd8 ffffffff810acb74
> 00000000001d4500 [ 4952.996020]  ffff880065aedc58 0000000000000002
> ffff880066ab2c08 0000000000000002 [ 4952.996020] Call Trace: [
> 4952.996020]  [<ffffffff81a07898>] dump_stack+0x51/0x71 [
> 4952.996020]  [<ffffffff810acb74>] print_circular_bug+0x214/0x310 [
> 4952.996020]  [<ffffffff810afc5c>] __lock_acquire+0x1c4c/0x1fa0 [
> 4952.996020]  [<ffffffffa004babe>] ? raid_bytes_show+0x3e/0xd0
> [btrfs] [ 4952.996020] [<ffffffff810b0662>] lock_acquire+0x92/0x120
> [ 4952.996020] [<ffffffffa004babe>] ? raid_bytes_show+0x3e/0xd0
> [btrfs] [ 4952.996020]  [<ffffffff81a0bedc>] down_read+0x4c/0xa0 [ 
> 4952.996020]  [<ffffffffa004babe>] ? raid_bytes_show+0x3e/0xd0 
> [btrfs] [ 4952.996020]  [<ffffffff810aa37f>] ? 
> __lock_is_held+0x5f/0x80 [ 4952.996020]  [<ffffffffa004babe>] 
> raid_bytes_show+0x3e/0xd0 [btrfs] [ 4952.996020] 
> [<ffffffff813b9ef6>] kobj_attr_show+0x16/0x20 [ 4952.996020] 
> [<ffffffff811f04e9>] sysfs_kf_seq_show+0xd9/0x230 [ 4952.996020] 
> [<ffffffff811eec56>] kernfs_seq_show+0x26/0x30 [ 4952.996020] 
> [<ffffffff8119ec8f>] seq_read+0xef/0x410 [ 4952.996020] 
> [<ffffffff811efa35>] kernfs_fop_read+0x125/0x180 [ 4952.996020] 
> [<ffffffff8117941e>] ? rw_verify_area+0xe/0xc0 [ 4952.996020] 
> [<ffffffff81179fe4>] vfs_read+0xb4/0x180 [ 4952.996020] 
> [<ffffffff8117a269>] SyS_read+0x59/0xd0 [ 4952.996020] 
> [<ffffffff81a16cd2>] system_call_fastpath+0x16/0x1b
> 
> -- To unsubscribe from this list: send the line "unsubscribe 
> linux-btrfs" in the body of a message to majordomo@vger.kernel.org
>  More majordomo info at
> http://vger.kernel.org/majordomo-info.html
> 


- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.22 (Darwin)

iQIcBAEBAgAGBQJTg+TMAAoJEB57S2MheeWyxO0P/3NS5HXSAye23YVnTqnrTeZe
JjpXsbflT9sq38cj53mpr0wOBfGqeIaA7lEcwSuQqfCZj9jlq7d/q4uptpUBX3q7
63rmjpbhgJh8xwkdPkSkYi6KbacE1UE+jRK4N2mLevePAUoCcV2KkcKroaiLOcGA
xNsIqpUsnCCVJh/pq78jq75PP3FtvWp+e02RhsUc/HDaJYo06GyEDQ3AN/ItGFLF
uvlgfbGNE3pWgJVbJL5dEwiVK1PZ8yx1zXl4QPsGIevEZectcKe2/o3Z00XHFxqU
W0cKrNVU661PEG6MQ65S/tUyHUFe2PFN/hUx82oOrbU+JhTesGX3CRk4j13oY1o6
J+i0Mp4nIIIkMfvM/a8t3dxdCo12XdIyZCe0g5+EUe6S0P/FX3+5q4GEjFUWXofv
ojM/Jf6MqAYwA+SjoMRL4t096aqb3j3RiBFbwrcfFLhHeBW3cFWTVKAqrSuLQR4A
hOL2eC4SJb3ikOXfblxGadG+HvLvIygz7A0p6WbSh1ppeuJgx11Fqs5nh1iC3x4Y
TLBSibDsWDoBDpArtenQF8Gvy6qIt1Xv0PoSMxXI4PtPChogQu5gmeJaIMhIbHtR
4oJJMJ6CkaE23+MU1MZZkZSBK5oGUtEsomBpDRfgNNEEPuwGvBD94B0glz59YNQJ
84EcIlS+fGSWcvzPGWoY
=f4En
-----END PGP SIGNATURE-----
