Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from kolab.zavadatar.com ([46.101.124.0]:33852 "EHLO
	kolab.zavadatar.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693AbcC3WRN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Mar 2016 18:17:13 -0400
Date: Thu, 31 Mar 2016 01:17:08 +0300
From: Yauhen Kharuzhy <yauhen.kharuzhy@zavadatar.com>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Global hotspare functionality
Message-ID: <20160330221708.GA8892@jeknote.loshitsa1.net>
References: <20160318193937.GA21352@jek-Latitude-E7440>
 <56FA9420.8020503@oracle.com>
 <20160329194040.GB27148@jeknote.loshitsa1.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160329194040.GB27148@jeknote.loshitsa1.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 29, 2016 at 10:40:40PM +0300, Yauhen Kharuzhy wrote:
> Hi.
> 
> I am testing hotspare v2 on kernel v4.4.5 (I will try latest Chris' tree later)
> now with lockdep debugging enabled. At starting of replacement, lockdep warning is displayed,
> because kstrdup() is called with GFP_NOFS inside of rcu_read_lock/unlock()
> block (GFP_NOFS can sleep).

Similar thing in the btrfs_auto_replace_start(): rcu_str_deref() without
rcu_read_lock():

int btrfs_auto_replace_start(struct btrfs_root *root,
                                struct btrfs_device *src_device)
{
        int ret;
        char *tgt_path;

        if (btrfs_get_spare_device(&tgt_path)) {
                btrfs_err(root->fs_info,
                        "No spare device found/configured in the kernel");
                return -EINVAL;
        }

        ret = btrfs_dev_replace_start(root, tgt_path,
                                        src_device->devid,
                                        rcu_str_deref(src_device->name),
                BTRFS_IOCTL_DEV_REPLACE_CONT_READING_FROM_SRCDEV_MODE_AVOID);
        if (ret)
                btrfs_put_spare_device(tgt_path);

        kfree(tgt_path);

        return 0;
}

[  156.168133] ===============================
[  156.168963] [ INFO: suspicious RCU usage. ]
[  156.169822] 4.4.5-scst31x+ #20 Not tainted
[  156.170656] -------------------------------
[  156.171488] fs/btrfs/dev-replace.c:990 suspicious rcu_dereference_check() usage!
[  156.172920] 
[  156.172920] other info that might help us debug this:
[  156.172920] 
[  156.174825] 
[  156.174825] rcu_scheduler_active = 1, debug_locks = 0
[  156.176152] 1 lock held by btrfs-casualty/4807:
[  156.181917]  #0:  (&fs_info->casualty_mutex){+.+...}, at: [<ffffffffa0165364>] casualty_kthread+0x64/0x390 [btrfs]
[  156.193511] 
[  156.193511] stack backtrace:
[  156.194680] CPU: 0 PID: 4807 Comm: btrfs-casualty Not tainted 4.4.5-scst31x+ #20
[  156.201650] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[  156.219100]  0000000000000000 ffff88005d79fda0 ffffffff813529e3 ffff88005e19c600
[  156.221216]  0000000000000001 ffff88005d79fdd0 ffffffff810d6407 0000000000000000
[  156.224287]  0000000000000000 ffff88005f4a0c00 ffff88005da36000 ffff88005d79fe08
[  156.226375] Call Trace:
[  156.227078]  [<ffffffff813529e3>] dump_stack+0x85/0xc2
[  156.228152]  [<ffffffff810d6407>] lockdep_rcu_suspicious+0xd7/0x110
[  156.229418]  [<ffffffffa01e6236>] btrfs_auto_replace_start+0xa6/0xd0 [btrfs]
[  156.230714]  [<ffffffffa01655c4>] casualty_kthread+0x2c4/0x390 [btrfs]
[  156.231915]  [<ffffffffa016549c>] ? casualty_kthread+0x19c/0x390 [btrfs]
[  156.233105]  [<ffffffffa0165300>] ? btrfs_check_devices+0x200/0x200 [btrfs]
[  156.234339]  [<ffffffff810a70df>] kthread+0xef/0x110
[  156.235309]  [<ffffffff810dc081>] ? __raw_callee_save___pv_queued_spin_unlock+0x11/0x20
[  156.236940]  [<ffffffff810a6ff0>] ? kthread_create_on_node+0x200/0x200
[  156.239489]  [<ffffffff81637c2f>] ret_from_fork+0x3f/0x70
[  156.240533]  [<ffffffff810a6ff0>] ? kthread_create_on_node+0x200/0x200


-- 
Yauhen Kharuzhy
