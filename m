Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:42415 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754099AbbGCAZD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Jul 2015 20:25:03 -0400
Subject: Re: [PATCH 4/4] btrfs: Fix data checksum error cause by replace with
 io-load.
To: Chris Mason <clm@fb.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
        <linux-btrfs@vger.kernel.org>
References: <5c5c914dad20c018cfe74174827219c418839f39.1432900529.git.zhaolei@cn.fujitsu.com>
 <33ad2c0da35681e20afdc6a75ecb19ff2b09f767.1432900529.git.zhaolei@cn.fujitsu.com>
 <5591FE4A.9060406@cn.fujitsu.com>
 <20150702124221.GI23627@ret.masoncoding.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <5595D65B.5000004@cn.fujitsu.com>
Date: Fri, 3 Jul 2015 08:24:59 +0800
MIME-Version: 1.0
In-Reply-To: <20150702124221.GI23627@ret.masoncoding.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Chris Mason wrote on 2015/07/02 08:42 -0400:
> On Tue, Jun 30, 2015 at 10:26:18AM +0800, Qu Wenruo wrote:
>> To Chris:
>>
>> Would you consider merging these patchset for late 4.2 merge window?
>> If it's OK to merge it into 4.2 late rc, we'll start our test and send pull
>> request after our test, eta this Friday or next Monday.
>>
>> I know normally we should submit it early especially when such fix is not
>> small.
>> But the bug is long-standing and is quite annoying (possibility involved),
>> also Zhao Lei has quite a good idea to cleanup the scrub codes based on the
>> patchset.
>>
>> So it would be quite nice if we have any chance to merge it into 4.2
>>
>> Would it be OK for you?
>>
>
> I can still take these patches in a later RC, but with this set applied,
> I'm getting this during xfstests (btrfs/073 and btrfs/066):
We also found that problem.
In our investigation, this seems to be a mistake when rebasing the patchset.

We will resend the patchset for review when we fix them all.
And only after that, we will send a pull request.

Thanks,
Qu
>
> [11185.853152] ------------[ cut here ]------------
> [11185.862659] WARNING: CPU: 7 PID: 580363 at fs/btrfs/extent-tree.c:9460 btrfs_create_pending_block_groups+0x161/0x1f0 [btrfs]()
> [11185.885804] Modules linked in: dm_flakey btrfs raid6_pq zlib_deflate lzo_compress xor xfs exportfs libcrc32c tcp_diag inet_diag nfsv4 fuse loop k10temp coretemp hwmon ip6table_filter ip6_tables xt_NFLOG nfnetlink_log nfnetlink xt_comment xt_statistic iptable_filter ip_tables x_tables mptctl nfsv3 nfs lockd grace netconsole autofs4 rpcsec_gss_krb5 auth_rpcgss oid_registry sunrpc ipv6 ext3 jbd iTCO_wdt iTCO_vendor_support pcspkr rtc_cmos ipmi_si ipmi_msghandler i2c_i801 i2c_core lpc_ich mfd_core shpchp ehci_pci ehci_hcd mlx4_en ptp pps_core mlx4_core sg ses enclosure button dm_mod megaraid_sas
> [11185.994338] CPU: 7 PID: 580363 Comm: btrfs Tainted: G        W       4.1.0-rc6-mason+ #82
> [11186.011074] Hardware name: ZTSYSTEMS Echo Ridge T4  /A9DRPF-10D, BIOS 1.07 05/10/2012
> [11186.027107]  00000000000024f4 ffff880894b539c8 ffffffff816c48c5 ffffffffa06dbe8d
> [11186.042442]  ffff880894b53a18 ffff880894b53a08 ffffffff8105ba75 ffff881053ad4000
> [11186.057769]  ffff88085417c9a8 ffff88085417c800 ffff8806335a8858 00000000ffffffe5
> [11186.073128] Call Trace:
> [11186.078233]  [<ffffffff816c48c5>] dump_stack+0x4f/0x6a
> [11186.088713]  [<ffffffff8105ba75>] warn_slowpath_common+0x95/0xe0
> [11186.100926]  [<ffffffff8105bb76>] warn_slowpath_fmt+0x46/0x70
> [11186.112627]  [<ffffffffa062c551>] btrfs_create_pending_block_groups+0x161/0x1f0 [btrfs]
> [11186.129039]  [<ffffffffa064f6ec>] __btrfs_end_transaction+0xac/0x400 [btrfs]
> [11186.143325]  [<ffffffffa064fa70>] btrfs_end_transaction+0x10/0x20 [btrfs]
> [11186.157092]  [<ffffffffa063bdf6>] btrfs_inc_block_group_ro+0x116/0x1d0 [btrfs]
> [11186.171941]  [<ffffffffa06b8962>] scrub_enumerate_chunks+0x2f2/0x5e0 [btrfs]
> [11186.186233]  [<ffffffff8108cf4d>] ? ttwu_stat+0x4d/0x250
> [11186.197045]  [<ffffffff810a4100>] ? bit_waitqueue+0x80/0xa0
> [11186.208392]  [<ffffffff810af1fd>] ? trace_hardirqs_on+0xd/0x10
> [11186.220271]  [<ffffffffa06b8e16>] btrfs_scrub_dev+0x1c6/0x5d0 [btrfs]
> [11186.233350]  [<ffffffff811fd4f9>] ? __mnt_want_write_file+0x29/0x30
> [11186.246083]  [<ffffffffa068c991>] btrfs_ioctl_scrub+0xb1/0x130 [btrfs]
> [11186.259348]  [<ffffffffa068f408>] btrfs_ioctl+0xa68/0x11d0 [btrfs]
> [11186.271908]  [<ffffffff811ef57f>] do_vfs_ioctl+0x8f/0x580
> [11186.282903]  [<ffffffff811fcb50>] ? __fget+0x110/0x200
> [11186.293377]  [<ffffffff811fca40>] ? get_close_on_exec+0x180/0x180
> [11186.305764]  [<ffffffff811fcc6a>] ? __fget_light+0x2a/0x90
> [11186.316928]  [<ffffffff811efb11>] SyS_ioctl+0xa1/0xb0
> [11186.327233]  [<ffffffff8110de5c>] ? __audit_syscall_entry+0xac/0x110
> [11186.340133]  [<ffffffff816cb7d7>] system_call_fastpath+0x12/0x6f
> [11186.352346] ---[ end trace 720cebad3201fcad ]---
> [11186.361785] BTRFS: error (device sdi) in btrfs_create_pending_block_groups:9460: errno=-27 unknown^M
>
> I've removed them for now.
>
> -chris
>
