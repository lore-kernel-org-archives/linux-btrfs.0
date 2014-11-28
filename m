Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:64845 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751139AbaK1VcU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 28 Nov 2014 16:32:20 -0500
Date: Fri, 28 Nov 2014 16:32:03 -0500
From: Chris Mason <clm@fb.com>
Subject: Re: [PATCH v3 10/11] Btrfs: fix possible deadlock caused by pending
 I/O in plug list
To: <miaox@cn.fujitsu.com>
CC: <linux-btrfs@vger.kernel.org>
Message-ID: <1417210323.6046.3@mail.thefacebook.com>
In-Reply-To: <547693D9.3040904@cn.fujitsu.com>
References: <1416928481.3019.13@mail.thefacebook.com>
	<1417007091-11885-1-git-send-email-miaox@cn.fujitsu.com>
	<1417007091-11885-11-git-send-email-miaox@cn.fujitsu.com>
	<1417014143.2258.0@mail.thefacebook.com> <547680EC.7030705@cn.fujitsu.com>
	<547693D9.3040904@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 26, 2014 at 10:00 PM, Miao Xie <miaox@cn.fujitsu.com> wrote:
> On Thu, 27 Nov 2014 09:39:56 +0800, Miao Xie wrote:
>>  On Wed, 26 Nov 2014 10:02:23 -0500, Chris Mason wrote:
>>>  On Wed, Nov 26, 2014 at 8:04 AM, Miao Xie <miaox@cn.fujitsu.com> 
>>> wrote:
>>>>  The increase/decrease of bio counter is on the I/O path, so we 
>>>> should
>>>>  use io_schedule() instead of schedule(), or the deadlock might be
>>>>  triggered by the pending I/O in the plug list. io_schedule() can 
>>>> help
>>>>  us because it will flush all the pending I/O before the task is 
>>>> going
>>>>  to sleep.
>>> 
>>>  Can you please describe this deadlock in more detail?  schedule() 
>>> also triggers
>>>  a flush of the plug list, and if that's no longer sufficient we 
>>> can run into other
>>>  problems (especially with preemption on).
>> 
>>  Sorry for my miss. I forgot to check the current implementation of 
>> schedule(), which flushes the plug list unconditionally. Please 
>> ignore this patch.
> 
> I have updated my raid56-scrub-replace branch, please re-pull the 
> branch.
> 
>   https://github.com/miaoxie/linux-btrfs.git raid56-scrub-replace

Sorry, I wasn't clear.  I do like the patch because it uses a slightly 
better trigger mechanism for the flush.  I was just worried about a 
larger deadlock.

I ran the raid56 work with stress.sh overnight, then scrubbed the 
resulting filesystem and ran balance when the scrub completed.  All of 
these passed without errors (excellent!).

Then I zero'd 4GB of one drive and ran scrub again.  This was the 
result.  Please make sure CONFIG_DEBUG_PAGEALLOC is enabled and you 
should be able to reproduce.

[192392.495260] BUG: unable to handle kernel paging request at 
ffff880303062f80
[192392.495279] IP: [<ffffffffa05fe77a>] lock_stripe_add+0xba/0x390 
[btrfs]
[192392.495281] PGD 2bdb067 PUD 107e7fd067 PMD 107e7e4067 PTE 
8000000303062060
[192392.495283] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
[192392.495307] Modules linked in: ipmi_devintf loop fuse k10temp 
coretemp hwmon btrfs raid6_pq zlib_deflate lzo_compress xor xfs 
exportfs libcrc32c tcp_diag inet_diag nfsv4 ip6table_filter ip6_tables 
xt_NFLOG nfnetlink_log nfnetlink xt_comment xt_statistic iptable_filter 
ip_tables x_tables mptctl netconsole autofs4 nfsv3 nfs lockd grace 
rpcsec_gss_krb5 auth_rpcgss oid_registry sunrpc ipv6 ext3 jbd dm_mod 
rtc_cmos ipmi_si ipmi_msghandler iTCO_wdt iTCO_vendor_support pcspkr 
i2c_i801 lpc_ich mfd_core shpchp ehci_pci ehci_hcd mlx4_en ptp pps_core 
mlx4_core sg ses enclosure button megaraid_sas
[192392.495310] CPU: 0 PID: 11992 Comm: kworker/u65:2 Not tainted 
3.18.0-rc6-mason+ #7
[192392.495310] Hardware name: ZTSYSTEMS Echo Ridge T4  /A9DRPF-10D, 
BIOS 1.07 05/10/2012
[192392.495323] Workqueue: btrfs-btrfs-scrub btrfs_scrub_helper [btrfs]
[192392.495324] task: ffff88013dae9110 ti: ffff8802296a0000 task.ti: 
ffff8802296a0000
[192392.495335] RIP: 0010:[<ffffffffa05fe77a>]  [<ffffffffa05fe77a>] 
lock_stripe_add+0xba/0x390 [btrfs]
[192392.495335] RSP: 0018:ffff8802296a3ac8  EFLAGS: 00010006
[192392.495336] RAX: ffff880577e85018 RBX: ffff880497f0b2f8 RCX: 
ffff8801190fb000
[192392.495337] RDX: 000000000000013d RSI: ffff880303062f80 RDI: 
0000040c275a0000
[192392.495338] RBP: ffff8802296a3b48 R08: ffff880497f00000 R09: 
0000000000000001
[192392.495339] R10: 0000000000000000 R11: 0000000000000000 R12: 
0000000000000282
[192392.495339] R13: 000000000000b250 R14: ffff880577e85000 R15: 
ffff880497f0b2a0
[192392.495340] FS:  0000000000000000(0000) GS:ffff88085fc00000(0000) 
knlGS:0000000000000000
[192392.495341] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[192392.495342] CR2: ffff880303062f80 CR3: 0000000005289000 CR4: 
00000000000407f0
[192392.495342] Stack:
[192392.495344]  ffff880755e28000 ffff880497f00000 000000000000013d 
ffff8801190fb000
[192392.495346]  0000000000000000 ffff88013dae9110 ffffffff81090d40 
ffff8802296a3b00
[192392.495347]  ffff8802296a3b00 0000000000000010 ffff8802296a3b68 
ffff8801190fb000
[192392.495348] Call Trace:
[192392.495353]  [<ffffffff81090d40>] ? bit_waitqueue+0xa0/0xa0
[192392.495363]  [<ffffffffa05fea66>] 
raid56_parity_submit_scrub_rbio+0x16/0x30 [btrfs]
[192392.495372]  [<ffffffffa05e2f0e>] 
scrub_parity_check_and_repair+0x15e/0x1e0 [btrfs]
[192392.495380]  [<ffffffffa05e301d>] scrub_block_put+0x8d/0x90 [btrfs]
[192392.495388]  [<ffffffffa05e6ed7>] ? 
scrub_bio_end_io_worker+0xd7/0x870 [btrfs]
[192392.495396]  [<ffffffffa05e6ee9>] 
scrub_bio_end_io_worker+0xe9/0x870 [btrfs]
[192392.495405]  [<ffffffffa05b8c44>] normal_work_helper+0x84/0x330 
[btrfs]
[192392.495414]  [<ffffffffa05b8f42>] btrfs_scrub_helper+0x12/0x20 
[btrfs]
[192392.495417]  [<ffffffff8106c50f>] process_one_work+0x1bf/0x520
[192392.495419]  [<ffffffff8106c48d>] ? process_one_work+0x13d/0x520
[192392.495421]  [<ffffffff8106c98e>] worker_thread+0x11e/0x4b0
[192392.495424]  [<ffffffff81653ac9>] ? __schedule+0x389/0x880
[192392.495426]  [<ffffffff8106c870>] ? process_one_work+0x520/0x520
[192392.495428]  [<ffffffff81071e2e>] kthread+0xde/0x100
[192392.495430]  [<ffffffff81071d50>] ? __init_kthread_worker+0x70/0x70
[192392.495431]  [<ffffffff81659eac>] ret_from_fork+0x7c/0xb0
[192392.495433]  [<ffffffff81071d50>] ? __init_kthread_worker+0x70/0x70
[192392.495449] Code: 45 88 49 89 c4 4f 8d 7c 28 50 4b 8b 44 28 50 48 
8b 55 90 4c 8d 70 e8 4c 39 f8 48 8b 4d 98 74 32 48 8b 71 10 48 8b 3e 48 
8b 70 f8 <48> 39 3e 75 12 eb 6f 0f 1f 80 00 00 00 00 48 8b 76 f8 48 39 
3e
[192392.495458] RIP  [<ffffffffa05fe77a>] lock_stripe_add+0xba/0x390 
[btrfs]
[192392.495458]  RSP <ffff8802296a3ac8>
[192392.495458] CR2: ffff880303062f80
[192392.496389] ---[ end trace c04c23ee0d843df0 ]---



