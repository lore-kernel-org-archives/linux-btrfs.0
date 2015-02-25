Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:61368 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751410AbbBYJBn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Feb 2015 04:01:43 -0500
Message-ID: <54ED8F72.7040603@cn.fujitsu.com>
Date: Wed, 25 Feb 2015 17:01:38 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: <bo.li.liu@oracle.com>, Tomasz Chmielewski <tch@virtall.com>,
        Josef Bacik <jbacik@fb.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: WARNING: CPU: 1 PID: 2436 at fs/btrfs/qgroup.c:1414 btrfs_delayed_qgroup_accounting+0x9f1/0xa0b
 [btrfs]()
References: <27573d37c7d634c3232820fa8464f235@admin.virtall.com> <109673fe6cda15800a731d1ee79d9175@admin.virtall.com> <20150213045648.GC25697@localhost.localdomain>
In-Reply-To: <20150213045648.GC25697@localhost.localdomain>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: WARNING: CPU: 1 PID: 2436 at fs/btrfs/qgroup.c:1414 
btrfs_delayed_qgroup_accounting+0x9f1/0xa0b [btrfs]()
From: Liu Bo <bo.li.liu@oracle.com>
To: Tomasz Chmielewski <tch@virtall.com>
Date: 2015年02月13日 12:56
> On Fri, Feb 13, 2015 at 10:20:25AM +0900, Tomasz Chmielewski wrote:
>> FYI, still seeing this with 3.19:
> I also got this warning (can be reproduced by a loop of running xfstests/btrfs/057) and
> tried to fix it but I failed.
>
> I think you also have several snapshots, and this warning may occur
> after deleting a shared file, the reason is that after
> 'commit fcebe4562dec ("Btrfs: rework qgroup accounting")', btrfs doesn't
> record time_seq for delayed refs at the point of adding delayed refs,
>
> Imagine such a case,
>
> # How we process a 'delete',
> 1. add delayed ref 'DROP'
> 2. run delayed ref 'DROP'
> 3. record qgroup operation for 'DROP'
> 4. process qgroup accounting for 'DROP'
>
> Here is an example,
> tree block A is shared by fs tree (rootid=5) and its snapshot
> (rootid=257), then we remove A in both fs tree and the snapshot, which
> means
>
> 'DROP A' on root 5 will either
> a) reduce fs tree's "qgroup reference number" and add snapshot's "qgroup exclusive number",
> or
> b) 'DROP A' on root 5 will think it's the last ref on this extent and reduce fs tree's both "qgroup reference
> number" and "qgroup exclusive number" by tree block A's length, and in a
> later time, 'DROP A' on root 257 will do this again, so the number can
> be something negative like -4k.
>
> Thanks,
>
> -liubo
And things seems get even worse when involving file extents in the 
shared leaf.
Still use the A leaf shared by 5 and 257 and call the file extent in it 
as F for example.
root 5 has only one exclusive node(4K for example) and F is 16K long.

When root 257 needs to change leaf A, btrfs cow it and increase ref 
counts on all file extents in A,
including F.
Btrfs ref increase codes knows leaf A is shared so passed ADD_SHARED 
operation for qgroup codes.(*)

Although qgroup rescan already consider every file extent in A is 
shared, but in ADD_SHARED operation codes,
it still decide to reduce the excl number of root 5 since it consider 
the file extent is exclusive before ADD_SHARED.

So excl number of root 5 will be reduced by the length of F, which we 
will get 4k - 16k.

I have a 1G(compressed to 1.1M) binary image with the above situation 
and any one can just trigger it by
remove everything in the fs.
(just rm <mountpoint> -rf ,except the snapshot which can't be removed 
using rm -rf).
https://drive.google.com/file/d/0BxpkL3ehzX3pYlkwRDJaUEFQZzQ/view?usp=sharing

Commit fcebe4562dec makes qgroup nearly unusable with snapshot.
To Josef, would you please consider revert that huge commit?

Thanks,
Qu
>> [196992.429463] ------------[ cut here ]------------
>> [196992.429526] WARNING: CPU: 1 PID: 26328 at fs/btrfs/qgroup.c:1414
>> btrfs_delayed_qgroup_accounting+0x9f3/0xa0d [btrfs]()
>> [196992.429617] Modules linked in: xt_nat xt_tcpudp ipt_MASQUERADE
>> nf_nat_masquerade_ipv4 iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4
>> nf_nat_ipv4 nf_nat nf_conntrack ip_tables x_tables tun
>> cpufreq_conservative cpufreq_powersave cpufreq_stats ipv6 btrfs xor
>> raid6_pq zlib_deflate coretemp hwmon loop pcspkr i2c_i801 i2c_core
>> battery parport_pc parport tpm_infineon tpm_tis tpm video
>> 8250_fintek lpc_ich mfd_core ehci_pci ehci_hcd button acpi_cpufreq
>> ext4 crc16 jbd2 mbcache raid1 sg sd_mod ahci libahci libata scsi_mod
>> r8169 mii
>> [196992.429979] CPU: 1 PID: 26328 Comm: kworker/u16:21 Not tainted
>> 3.19.0 #1
>> [196992.430026] Hardware name: System manufacturer System Product
>> Name/P8H77-M PRO, BIOS 1101 02/04/2013
>> [196992.430123] Workqueue: btrfs-extent-refs
>> btrfs_extent_refs_helper [btrfs]
>> [196992.430171]  0000000000000009 ffff8800045a3c18 ffffffff813bc952
>> 0000000000000000
>> [196992.430260]  0000000000000000 ffff8800045a3c58 ffffffff8103b015
>> ffff8807f9281c90
>> [196992.430349]  ffffffffa0332a33 ffff8807f9281000 ffff8807f2747f00
>> ffffffffffffffff
>> [196992.430438] Call Trace:
>> [196992.430484]  [<ffffffff813bc952>] dump_stack+0x45/0x57
>> [196992.430532]  [<ffffffff8103b015>] warn_slowpath_common+0x97/0xb1
>> [196992.430586]  [<ffffffffa0332a33>] ?
>> btrfs_delayed_qgroup_accounting+0x9f3/0xa0d [btrfs]
>> [196992.430675]  [<ffffffff8103b044>] warn_slowpath_null+0x15/0x17
>> [196992.430727]  [<ffffffffa0332a33>]
>> btrfs_delayed_qgroup_accounting+0x9f3/0xa0d [btrfs]
>> [196992.430820]  [<ffffffffa02d1449>]
>> btrfs_run_delayed_refs+0x1e4/0x21b [btrfs]
>> [196992.430873]  [<ffffffffa02d1a2d>]
>> delayed_ref_async_start+0x37/0x76 [btrfs]
>> [196992.430927]  [<ffffffffa03069d7>] normal_work_helper+0xb5/0x16a
>> [btrfs]
>> [196992.430981]  [<ffffffffa0306b98>]
>> btrfs_extent_refs_helper+0xd/0xf [btrfs]
>> [196992.431030]  [<ffffffff8104c0cb>] process_one_work+0x187/0x2a9
>> [196992.431077]  [<ffffffff8104c458>] worker_thread+0x241/0x33e
>> [196992.431125]  [<ffffffff8104c217>] ?
>> process_scheduled_works+0x2a/0x2a
>> [196992.431173]  [<ffffffff81050067>] kthread+0xcd/0xd5
>> [196992.431219]  [<ffffffff8104ff9a>] ?
>> kthread_freezable_should_stop+0x43/0x43
>> [196992.431268]  [<ffffffff813c12ac>] ret_from_fork+0x7c/0xb0
>> [196992.431315]  [<ffffffff8104ff9a>] ?
>> kthread_freezable_should_stop+0x43/0x43
>> [196992.431363] ---[ end trace 5d57d07bb94831a0 ]---
>> [197051.336444] ------------[ cut here ]------------
>> [197051.336506] WARNING: CPU: 5 PID: 2544 at fs/btrfs/qgroup.c:1414
>> btrfs_delayed_qgroup_accounting+0x9f3/0xa0d [btrfs]()
>> [197051.336598] Modules linked in: xt_nat xt_tcpudp ipt_MASQUERADE
>> nf_nat_masquerade_ipv4 iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4
>> nf_nat_ipv4 nf_nat nf_conntrack ip_tables x_tables tun
>> cpufreq_conservative cpufreq_powersave cpufreq_stats ipv6 btrfs xor
>> raid6_pq zlib_deflate coretemp hwmon loop pcspkr i2c_i801 i2c_core
>> battery parport_pc parport tpm_infineon tpm_tis tpm video
>> 8250_fintek lpc_ich mfd_core ehci_pci ehci_hcd button acpi_cpufreq
>> ext4 crc16 jbd2 mbcache raid1 sg sd_mod ahci libahci libata scsi_mod
>> r8169 mii
>> [197051.336965] CPU: 5 PID: 2544 Comm: btrfs-cleaner Tainted: G
>> W      3.19.0 #1
>> [197051.337070] Hardware name: System manufacturer System Product
>> Name/P8H77-M PRO, BIOS 1101 02/04/2013
>> [197051.337160]  0000000000000009 ffff8800c7e8bbe8 ffffffff813bc952
>> 000000000000009b
>> [197051.337249]  0000000000000000 ffff8800c7e8bc28 ffffffff8103b015
>> ffff8807f9281c90
>> [197051.337338]  ffffffffa0332a33 ffff8807f9281000 ffff8807f2740480
>> ffffffffffffffff
>> [197051.337427] Call Trace:
>> [197051.337473]  [<ffffffff813bc952>] dump_stack+0x45/0x57
>> [197051.337521]  [<ffffffff8103b015>] warn_slowpath_common+0x97/0xb1
>> [197051.337576]  [<ffffffffa0332a33>] ?
>> btrfs_delayed_qgroup_accounting+0x9f3/0xa0d [btrfs]
>> [197051.337664]  [<ffffffff8103b044>] warn_slowpath_null+0x15/0x17
>> [197051.337717]  [<ffffffffa0332a33>]
>> btrfs_delayed_qgroup_accounting+0x9f3/0xa0d [btrfs]
>> [197051.337809]  [<ffffffffa02d1449>]
>> btrfs_run_delayed_refs+0x1e4/0x21b [btrfs]
>> [197051.337863]  [<ffffffffa02df041>]
>> btrfs_should_end_transaction+0x4a/0x53 [btrfs]
>> [197051.337955]  [<ffffffffa02cfdc3>]
>> btrfs_drop_snapshot+0x379/0x68f [btrfs]
>> [197051.338009]  [<ffffffffa02ee811>] ?
>> btrfs_run_defrag_inodes+0x2fa/0x30e [btrfs]
>> [197051.338101]  [<ffffffffa02d22f2>] ?
>> btrfs_delete_unused_bgs+0x3f/0x210 [btrfs]
>> [197051.338193]  [<ffffffffa02df42b>]
>> btrfs_clean_one_deleted_snapshot+0xb4/0xc2 [btrfs]
>> [197051.338284]  [<ffffffffa02be105>] ? btrfs_free_path+0x22/0x26
>> [btrfs]
>> [197051.338336]  [<ffffffffa02d889e>] cleaner_kthread+0x134/0x16c
>> [btrfs]
>> [197051.338388]  [<ffffffffa02d876a>] ? btrfs_alloc_root+0x2c/0x2c
>> [btrfs]
>> [197051.338437]  [<ffffffff81050067>] kthread+0xcd/0xd5
>> [197051.338484]  [<ffffffff8104ff9a>] ?
>> kthread_freezable_should_stop+0x43/0x43
>> [197051.338533]  [<ffffffff813c12ac>] ret_from_fork+0x7c/0xb0
>> [197051.338580]  [<ffffffff8104ff9a>] ?
>> kthread_freezable_should_stop+0x43/0x43
>> [197051.338628] ---[ end trace 5d57d07bb94831a1 ]---
>> [197051.340365] ------------[ cut here ]------------
>> [197051.340450] WARNING: CPU: 0 PID: 26314 at fs/btrfs/qgroup.c:1414
>> btrfs_delayed_qgroup_accounting+0x9f3/0xa0d [btrfs]()
>> [197051.340568] Modules linked in: xt_nat xt_tcpudp ipt_MASQUERADE
>> nf_nat_masquerade_ipv4 iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4
>> nf_nat_ipv4 nf_nat nf_conntrack ip_tables x_tables tun
>> cpufreq_conservative cpufreq_powersave cpufreq_stats ipv6 btrfs xor
>> raid6_pq zlib_deflate coretemp hwmon loop pcspkr i2c_i801 i2c_core
>> battery parport_pc parport tpm_infineon tpm_tis tpm video
>> 8250_fintek lpc_ich mfd_core ehci_pci ehci_hcd button acpi_cpufreq
>> ext4 crc16 jbd2 mbcache raid1 sg sd_mod ahci libahci libata scsi_mod
>> r8169 mii
>> [197051.341053] CPU: 0 PID: 26314 Comm: kworker/u16:5 Tainted: G
>> W      3.19.0 #1
>> [197051.341165] Hardware name: System manufacturer System Product
>> Name/P8H77-M PRO, BIOS 1101 02/04/2013
>> [197051.341297] Workqueue: btrfs-extent-refs
>> btrfs_extent_refs_helper [btrfs]
>> [197051.341360]  0000000000000009 ffff8802c511bc18 ffffffff813bc952
>> 0000000000000000
>> [197051.341475]  0000000000000000 ffff8802c511bc58 ffffffff8103b015
>> ffff8807f9281c90
>> [197051.341590]  ffffffffa0332a33 ffff8807f9281000 ffff8807f2745300
>> ffffffffffffffff
>> [197051.341705] Call Trace:
>> [197051.341763]  [<ffffffff813bc952>] dump_stack+0x45/0x57
>> [197051.341825]  [<ffffffff8103b015>] warn_slowpath_common+0x97/0xb1
>> [197051.341901]  [<ffffffffa0332a33>] ?
>> btrfs_delayed_qgroup_accounting+0x9f3/0xa0d [btrfs]
>> [197051.342015]  [<ffffffff8103b044>] warn_slowpath_null+0x15/0x17
>> [197051.342089]  [<ffffffffa0332a33>]
>> btrfs_delayed_qgroup_accounting+0x9f3/0xa0d [btrfs]
>> [197051.342214]  [<ffffffffa02d1449>]
>> btrfs_run_delayed_refs+0x1e4/0x21b [btrfs]
>> [197051.342287]  [<ffffffffa02d1a2d>]
>> delayed_ref_async_start+0x37/0x76 [btrfs]
>> [197051.342365]  [<ffffffffa03069d7>] normal_work_helper+0xb5/0x16a
>> [btrfs]
>> [197051.342441]  [<ffffffffa0306b98>]
>> btrfs_extent_refs_helper+0xd/0xf [btrfs]
>> [197051.342506]  [<ffffffff8104c0cb>] process_one_work+0x187/0x2a9
>> [197051.342568]  [<ffffffff8104c458>] worker_thread+0x241/0x33e
>> [197051.342630]  [<ffffffff8104c217>] ?
>> process_scheduled_works+0x2a/0x2a
>> [197051.342694]  [<ffffffff81050067>] kthread+0xcd/0xd5
>> [197051.342755]  [<ffffffff8104ff9a>] ?
>> kthread_freezable_should_stop+0x43/0x43
>> [197051.342819]  [<ffffffff813c12ac>] ret_from_fork+0x7c/0xb0
>> [197051.342880]  [<ffffffff8104ff9a>] ?
>> kthread_freezable_should_stop+0x43/0x43
>> [197051.342944] ---[ end trace 5d57d07bb94831a2 ]---
>>
>>
>> Tomasz Chmielewski
>> http://www.sslrack.com
>>
>> On 2015-01-04 07:58, Tomasz Chmielewski wrote:
>>> Got this with 3.18.1 and qgroups enabled. Not sure how to reproduce.
>>>
>>>
>>> [1262648.802286] ------------[ cut here ]------------
>>> [1262648.802350] WARNING: CPU: 1 PID: 2436 at fs/btrfs/qgroup.c:1414
>>> btrfs_delayed_qgroup_accounting+0x9f1/0xa0b [btrfs]()
>>> [1262648.802441] Modules linked in: ipt_MASQUERADE
>>> nf_nat_masquerade_ipv4 iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4
>>> nf_nat_ipv4 nf_nat nf_conntrack ip_tables x_tables cpufreq_ondemand
>>> cpufreq_conservative cpufreq_powersave cpufreq_stats nfsd auth_rpcgss
>>> oid_registry exportfs nfs_acl nfs lockd grace fscache sunrpc ipv6
>>> btrfs xor raid6_pq zlib_deflate coretemp hwmon loop pcspkr i2c_i801
>>> i2c_core battery parport_pc parport 8250_fintek tpm_infineon tpm_tis
>>> tpm video ehci_pci ehci_hcd lpc_ich mfd_core acpi_cpufreq button ext4
>>> crc16 jbd2 mbcache raid1 sg sd_mod r8169 mii ahci libahci libata
>>> scsi_mod
>>> [1262648.802854] CPU: 1 PID: 2436 Comm: btrfs-cleaner Not tainted
>>> 3.18.1 #1
>>> [1262648.802902] Hardware name: System manufacturer System Product
>>> Name/P8H77-M PRO, BIOS 1101 02/04/2013
>>> [1262648.802992]  0000000000000009 ffff8800c805fbe8 ffffffff813b1128
>>> 0000000000000000
>>> [1262648.803081]  0000000000000000 ffff8800c805fc28 ffffffff81039b39
>>> ffff8807f341c000
>>> [1262648.803170]  ffffffffa0300be2 ffff8807f341c000 ffff8807f3fd8b40
>>> ffffffffffffffff
>>> [1262648.803259] Call Trace:
>>> [1262648.803305]  [<ffffffff813b1128>] dump_stack+0x46/0x58
>>> [1262648.803352]  [<ffffffff81039b39>] warn_slowpath_common+0x77/0x91
>>> [1262648.803406]  [<ffffffffa0300be2>] ?
>>> btrfs_delayed_qgroup_accounting+0x9f1/0xa0b [btrfs]
>>> [1262648.803495]  [<ffffffff81039b68>] warn_slowpath_null+0x15/0x17
>>> [1262648.803548]  [<ffffffffa0300be2>]
>>> btrfs_delayed_qgroup_accounting+0x9f1/0xa0b [btrfs]
>>> [1262648.803642]  [<ffffffffa02a12a5>]
>>> btrfs_run_delayed_refs+0x1e4/0x21b [btrfs]
>>> [1262648.803734]  [<ffffffffa02aec96>]
>>> btrfs_should_end_transaction+0x4a/0x53 [btrfs]
>>> [1262648.803826]  [<ffffffffa029fc34>]
>>> btrfs_drop_snapshot+0x379/0x68f [btrfs]
>>> [1262648.803881]  [<ffffffffa02be478>] ?
>>> btrfs_run_defrag_inodes+0x2fa/0x30e [btrfs]
>>> [1262648.803974]  [<ffffffffa02b0401>]
>>> btrfs_clean_one_deleted_snapshot+0xb3/0xc2 [btrfs]
>>> [1262648.804067]  [<ffffffffa02a84ff>] cleaner_kthread+0x134/0x16c
>>> [btrfs]
>>> [1262648.804119]  [<ffffffffa02a83cb>] ?
>>> btrfs_alloc_root+0x2c/0x2c [btrfs]
>>> [1262648.804169]  [<ffffffff8104ebe7>] kthread+0xcd/0xd5
>>> [1262648.804215]  [<ffffffff8104eb1a>] ?
>>> kthread_freezable_should_stop+0x43/0x43
>>> [1262648.804264]  [<ffffffff813b59ec>] ret_from_fork+0x7c/0xb0
>>> [1262648.804311]  [<ffffffff8104eb1a>] ?
>>> kthread_freezable_should_stop+0x43/0x43
>>> [1262648.804360] ---[ end trace b76fd72b4be63515 ]---
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message tomajordomo@vger.kernel.org
>> More majordomo info athttp://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message tomajordomo@vger.kernel.org
> More majordomo info athttp://vger.kernel.org/majordomo-info.html

