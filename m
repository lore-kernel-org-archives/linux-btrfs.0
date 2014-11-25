Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:31367 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750809AbaKYPOv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Nov 2014 10:14:51 -0500
Date: Tue, 25 Nov 2014 10:14:41 -0500
From: Chris Mason <clm@fb.com>
Subject: Re: [PATCH 0/9] Implement device scrub/replace for RAID56
To: Miao Xie <miaox@cn.fujitsu.com>
CC: <linux-btrfs@vger.kernel.org>
Message-ID: <1416928481.3019.13@mail.thefacebook.com>
In-Reply-To: <1415973061-8643-1-git-send-email-miaox@cn.fujitsu.com>
References: <1415973061-8643-1-git-send-email-miaox@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 14, 2014 at 8:50 AM, Miao Xie <miaox@cn.fujitsu.com> wrote:
> This patchset implement the device scrub/replace function for RAID56, 
> the
> most implementation of the common data is similar to the other RAID 
> type.
> The differentia or difficulty is the parity process. In order to avoid
> that problem the data that is easy to be change out the stripe lock,
> we do most work in the RAID56 stripe lock context.
> 
> And in order to avoid making the code more and more complex, we copy 
> some
> code of common data process for the parity, the cleanup work is in my
> TODO list.
> 
> We have done some test, the patchset worked well. Of course, more 
> tests
> are welcome. If you are interesting to use it or test it, you can pull
> the patchset from
> 
>   https://github.com/miaoxie/linux-btrfs.git raid56-scrub-replace

I'm getting crashes from btrfs/060 with these in place:

> [ 1649.712413] BTRFS: assertion failed: logical + PAGE_SIZE <= 
> rbio->raid_map[0] + rbio->stripe_len * rbio->nr_data, file: 
> fs/btrfs/raid56.c, line: 2248^M
> [ 1649.738982] ------------[ cut here ]------------^M
> [ 1649.748727] kernel BUG at fs/btrfs/ctree.h:4020!^M
> [ 1649.758039] invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC^M
> [ 1649.768977] Modules linked in: fuse loop btrfs raid6_pq 
> zlib_deflate lzo_compress xor k10temp coretemp hwmon xfs exportfs 
> libcrc32c tcp_diag inet_diag nfsv4 ip6table_filter ip6_tables 
> xt_NFLOG nfnetlink_log nfnetlink xt_comment xt_statistic 
> iptable_filter ip_tables x_tables nfsv3 nfs lockd grace mptctl 
> netconsole autofs4 rpcsec_gss_krb5 auth_rpcgss oid_registry sunrpc 
> ipv6 ext3 jbd dm_mod iTCO_wdt iTCO_vendor_support rtc_cmos ipmi_si 
> ipmi_msghandler pcspkr i2c_i801 lpc_ich mfd_core shpchp ehci_pci 
> ehci_hcd mlx4_en ptp pps_core mlx4_core ses enclosure sg button 
> megaraid_sas^M
> [ 1649.872917] CPU: 0 PID: 16687 Comm: kworker/u65:0 Not tainted 
> 3.18.0-rc6-mason+ #3^M
> [ 1649.888171] Hardware name: ZTSYSTEMS Echo Ridge T4  /A9DRPF-10D, 
> BIOS 1.07 05/10/2012^M
> [ 1649.903962] Workqueue: btrfs-btrfs-scrub btrfs_scrub_helper 
> [btrfs]^M
> [ 1649.916588] task: ffff88072557dd90 ti: ffff88070fdc4000 task.ti: 
> ffff88070fdc4000^M
> [ 1649.931669] RIP: 0010:[<ffffffffa060db2f>]  [<ffffffffa060db2f>] 
> raid56_parity_add_scrub_pages+0x8f/0xa0 [btrfs]^M
> [ 1649.952169] RSP: 0018:ffff88070fdc7b68  EFLAGS: 00010292^M
> [ 1649.962852] RAX: 0000000000000089 RBX: ffff8804cf681f30 RCX: 
> 0000000000004b4a^M
> [ 1649.977177] RDX: 000000000000004a RSI: 0000000000000001 RDI: 
> 0000000000000000^M
> [ 1649.991496] RBP: ffff88070fdc7b68 R08: 0000000000000001 R09: 
> 0000000000000000^M
> [ 1650.005819] R10: 0000000000000001 R11: 0000000000000000 R12: 
> ffff880689b62800^M
> [ 1650.020140] R13: ffff88024d85cf80 R14: ffff88075d0dd800 R15: 
> 0000000000000003^M
> [ 1650.034459] FS:  0000000000000000(0000) GS:ffff88085fc00000(0000) 
> knlGS:0000000000000000^M
> [ 1650.050757] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033^M
> [ 1650.062306] CR2: 00007f445b6d0e78 CR3: 0000000001c14000 CR4: 
> 00000000000407f0^M
> [ 1650.076625] Stack:^M
> [ 1650.080716]  ffff88070fdc7bc8 ffffffffa05f2e50 ffff8804cf681fc8 
> ffff880700000010^M
> [ 1650.095761]  ffff88070fdc7b98 0000000000010000 ffff880290f92340 
> ffff88074eda9f00^M
> [ 1650.110792]  ffff8807edbb1700 ffff880639910e20 ffff8807edbb1700 
> 0000000000001000^M
> [ 1650.125865] Call Trace:^M
> [ 1650.130845]  [<ffffffffa05f2e50>] 
> scrub_parity_check_and_repair+0x140/0x1e0 [btrfs]^M
> [ 1650.146286]  [<ffffffffa05f2f7d>] scrub_block_put+0x8d/0x90 
> [btrfs]^M
> [ 1650.158884]  [<ffffffff810961e0>] ? 
> cpuacct_account_field+0xd0/0xd0^M
> [ 1650.171493]  [<ffffffffa05f6e19>] 
> scrub_bio_end_io_worker+0xe9/0x870 [btrfs]^M
> [ 1650.185725]  [<ffffffffa05c8b84>] normal_work_helper+0x84/0x330 
> [btrfs]^M
> [ 1650.199041]  [<ffffffffa05c8e82>] btrfs_scrub_helper+0x12/0x20 
> [btrfs]^M
> [ 1650.212165]  [<ffffffff8106c50f>] process_one_work+0x1bf/0x520^M
> [ 1650.223892]  [<ffffffff8106c48d>] ? process_one_work+0x13d/0x520^M
> [ 1650.235988]  [<ffffffff8106c98e>] worker_thread+0x11e/0x4b0^M
> [ 1650.247204]  [<ffffffff81653ac9>] ? __schedule+0x389/0x880^M
> [ 1650.258242]  [<ffffffff8106c870>] ? process_one_work+0x520/0x520^M
> [ 1650.270314]  [<ffffffff81071e2e>] kthread+0xde/0x100^M
> [ 1650.280302]  [<ffffffff81071d50>] ? 
> __init_kthread_worker+0x70/0x70^M
> [ 1650.292894]  [<ffffffff81659eac>] ret_from_fork+0x7c/0xb0^M
> [ 1650.303746]  [<ffffffff81071d50>] ? 
> __init_kthread_worker+0x70/0x70^M
> [ 1650.316359] Code: c0 e8 1d 5a 04 e1 0f 0b eb fe b9 c8 08 00 00 48 
> c7 c2 71 6b 62 a0 48 c7 c6 b8 c4 62 a0 48 c7 c7 80 c4 62 a0 31 c0 e8 
> f8 59 04 e1 <0f> 0b eb fe 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 
> 48 89 e5 ^M
> [ 1650.356466] RIP  [<ffffffffa060db2f>] 
> raid56_parity_add_scrub_pages+0x8f/0xa0 [btrfs]^M
> [ 1650.372307]  RSP <ffff88070fdc7b68>^M
> [ 1650.381427] ---[ end trace 14445249faa12848 ]---^M

