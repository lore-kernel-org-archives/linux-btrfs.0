Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from trent.utfs.org ([94.185.90.103]:50780 "EHLO trent.utfs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753818AbdATAOS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Jan 2017 19:14:18 -0500
Date: Thu, 19 Jan 2017 16:05:43 -0800 (PST)
From: Christian Kujau <lists@nerdbynature.de>
To: linux-btrfs@vger.kernel.org
cc: linux-kernel@vger.kernel.org
Subject: btrfs_alloc_tree_block: Faulting instruction address: 0xc02d4584
Message-ID: <alpine.DEB.2.20.999.1701191554340.3270@trent.utfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

after upgrading this powerpc32 box from 4.10-rc2 to -rc4, the message 
below occured a few hours after boot. Full dmesg and .config:

  http://nerdbynature.de/bits/4.10-rc4/

Any ideas?

Thanks,
Christian.


Faulting instruction address: 0xc02d4584
Oops: Kernel access of bad area, sig: 11 [#1]
PowerMac
Modules linked in: ecb xt_tcpudp iptable_filter ip_tables x_tables 
nfnetlink_log nfnetlink sha256_generic twofish_generic twofish_common 
usb_storage therm_adt746x loop i2c_powermac arc4 firewire_sbp2 b43 
rng_core ssb bcma mac80211 cfg80211 ecryptfs [last unloaded: nbd]
CPU: 0 PID: 1395 Comm: btrfs-transacti Tainted: G        W       
4.10.0-rc4-00001-gab8184b #1
task: ee7162e0 task.stack: ee9cc000
NIP: c02d4584 LR: c02d4574 CTR: c00d0df0
REGS: ee9cdaa0 TRAP: 0300   Tainted: G        W        
(4.10.0-rc4-00001-gab8184b)
MSR: 00009032 <EE,ME,IR,DR,RI>
  CR: 24422248  XER: 00000000
DAR: 10581054 DSISR: 42000000 
GPR00: c02d4574 ee9cdb50 ee71d4b8 10581050 00000001 dbc88118 00000000 00000020 
GPR08: 00001205 00000004 00000000 00000000 24422444 00000000 00000000 000093c3 
GPR16: fffff000 00000001 00000000 00000000 00000000 ee260800 00000000 00000000 
GPR24: 00000000 00000001 ee9cdc1b eef5c1a0 00001000 ee470000 dbc88118 ee470170 
NIP [c02d4584] btrfs_alloc_tree_block+0x18c/0x5c4
LR [c02d4574] btrfs_alloc_tree_block+0x17c/0x5c4
Call Trace:
[ee9cdb50] [c02d4574] btrfs_alloc_tree_block+0x17c/0x5c4 (unreliable)
[ee9cdbf0] [c02b86d4] __btrfs_cow_block+0x110/0x638
[ee9cdc70] [c02b8d74] btrfs_cow_block+0xdc/0x1b0
[ee9cdca0] [c02bc48c] btrfs_search_slot+0x1c0/0x904
[ee9cdd10] [c02dc680] btrfs_lookup_inode+0x3c/0x124
[ee9cdd50] [c02ec204] btrfs_update_inode_item+0x4c/0x10c
[ee9cdd80] [c02d05e4] cache_save_setup+0xc0/0x400
[ee9cdde0] [c02d4d54] btrfs_start_dirty_block_groups+0x184/0x47c
[ee9cde50] [c02e7e84] btrfs_commit_transaction+0x148/0xac4
[ee9cdeb0] [c02e313c] transaction_kthread+0x1d0/0x1ec
[ee9cdf00] [c004f1fc] kthread+0xf8/0x124
[ee9cdf40] [c0011480] ret_from_kernel_thread+0x5c/0x64
--- interrupt: 0 at   (null)
    LR =   (null)
Instruction dump:
4800b3ed 7f838040 7c7e1b78 419d0430 806300d4 81db0000 81fb0004 4bdfe2b9 
39200004 7ee6bb78 38630050 7fc5f378 <7dc91d2c> 7de01d2c 809501cf 807501cb 
---[ end trace 937683537ecd986b ]---



-- 
BOFH excuse #342:

HTTPD Error 4004 : very old Intel cpu - insufficient processing power
