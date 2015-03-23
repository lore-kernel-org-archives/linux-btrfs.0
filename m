Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:56149 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752205AbbCWPdm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Mar 2015 11:33:42 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Tue, 24 Mar 2015 00:33:40 +0900
From: Tomasz Chmielewski <tch@virtall.com>
To: Chris Mason <clm@fb.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: BTRFS: unable to add free space :-17
In-Reply-To: <1427118518.5707.6@mail.thefacebook.com>
References: <d1161c0c22333dfe9b77144aa18779b1@admin.virtall.com>
 <1427114113.5707.1@mail.thefacebook.com>
 <1427118518.5707.6@mail.thefacebook.com>
Message-ID: <8b9f49986eddfa7f74ac71c38617fb4d@admin.virtall.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2015-03-23 22:48, Chris Mason wrote:
> On Mon, Mar 23, 2015 at 8:35 AM, Chris Mason <clm@fb.com> wrote:
>> 
>> 
>> On Mon, Mar 23, 2015 at 8:19 AM, Tomasz Chmielewski <tch@virtall.com> 
>> wrote:
>>> Got this with 4.0.0-rc5 when doing a degraded mount:
>> Do you get this every time, even after going back to rc4?

Actually, I didn't try yet (going back to 4.0.0-rc4).

Shortly after, it errored with:

[ 4450.519046] ------------[ cut here ]------------
[ 4450.519066] WARNING: CPU: 4 PID: 4734 at fs/btrfs/super.c:260 
__btrfs_abort_transaction+0x4c/0x10e [btrfs]()
[ 4450.519081] BTRFS: Transaction aborted (error -17)
[ 4450.519082] Modules linked in: ipv6 cpufreq_stats cpufreq_powersave 
cpufreq_conservative btrfs xor raid6_pq zlib_deflate ext3 jbd loop 
tpm_infineon tpm_tis i2c_i801 parport_pc parport 8250_fintek lpc_ich 
pcspkr tpm video button acpi_cpufreq i2c_core mfd_core ehci_pci ehci_hcd 
ext4 crc16 jbd2 mbcache raid1 sg sd_mod ahci libahci libata scsi_mod 
r8169 mii
[ 4450.519157] CPU: 4 PID: 4734 Comm: kworker/u16:5 Not tainted 
4.0.0-rc5 #1
[ 4450.519167] Hardware name: System manufacturer System Product 
Name/P8H67-M PRO, BIOS 1106 10/17/2011
[ 4450.519190] Workqueue: btrfs-extent-refs btrfs_extent_refs_helper 
[btrfs]
[ 4450.519201]  0000000000000009 ffff88074e0a7c58 ffffffff813c2f57 
0000000000000000
[ 4450.519215]  ffff88074e0a7ca8 ffff88074e0a7c98 ffffffff8103b031 
ffff8807b2638e68
[ 4450.519255]  ffffffffa02b6356 00000000ffffffef ffff88081bb7e000 
ffff880701ba3210
[ 4450.519323] Call Trace:
[ 4450.519357]  [<ffffffff813c2f57>] dump_stack+0x45/0x57
[ 4450.519394]  [<ffffffff8103b031>] warn_slowpath_common+0x97/0xb1
[ 4450.519434]  [<ffffffffa02b6356>] ? 
__btrfs_abort_transaction+0x4c/0x10e [btrfs]
[ 4450.519501]  [<ffffffff8103b0df>] warn_slowpath_fmt+0x41/0x43
[ 4450.519540]  [<ffffffffa02b6356>] 
__btrfs_abort_transaction+0x4c/0x10e [btrfs]
[ 4450.519610]  [<ffffffffa02cd6d7>] btrfs_run_delayed_refs+0x90/0x21b 
[btrfs]
[ 4450.519653]  [<ffffffffa02cda60>] delayed_ref_async_start+0x37/0x76 
[btrfs]
[ 4450.519699]  [<ffffffffa0302c67>] normal_work_helper+0xb5/0x16a 
[btrfs]
[ 4450.519742]  [<ffffffffa0302e28>] btrfs_extent_refs_helper+0xd/0xf 
[btrfs]
[ 4450.519782]  [<ffffffff8104c16d>] process_one_work+0x187/0x2b2
[ 4450.519819]  [<ffffffff8104c503>] worker_thread+0x241/0x33e
[ 4450.519856]  [<ffffffff8104c2c2>] ? process_scheduled_works+0x2a/0x2a
[ 4450.519894]  [<ffffffff810501a3>] kthread+0xcd/0xd5
[ 4450.519930]  [<ffffffff810500d6>] ? 
kthread_freezable_should_stop+0x43/0x43
[ 4450.519969]  [<ffffffff813c7848>] ret_from_fork+0x58/0x90
[ 4450.520005]  [<ffffffff810500d6>] ? 
kthread_freezable_should_stop+0x43/0x43
[ 4450.520044] ---[ end trace 1aff120928ea0fd5 ]---
[ 4450.520079] BTRFS: error (device sdb4) in 
btrfs_run_delayed_refs:2790: errno=-17 Object already exists
[ 4450.520148] BTRFS info (device sdb4): forced readonly
[ 4450.641829] BTRFS: error (device sdb4) in 
btrfs_run_delayed_refs:2790: errno=-17 Object already exists



After reboot to 4.0.0-rc5, I didn't see "unable to add free space :-17" 
anymore. However, it went again to "forced readonly" some time later.

I'll try going to 4.0.0-rc4 now.

-- 
Tomasz Chmielewski
http://www.sslrack.com

