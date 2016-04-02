Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46585 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755508AbcDBBP6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Apr 2016 21:15:58 -0400
Subject: Re: Global hotspare functionality
To: Yauhen Kharuzhy <yauhen.kharuzhy@zavadatar.com>
References: <20160318193937.GA21352@jek-Latitude-E7440>
 <56FA9420.8020503@oracle.com> <20160329194722.GC27148@jeknote.loshitsa1.net>
Cc: linux-btrfs@vger.kernel.org
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <56FF1D4C.9030200@oracle.com>
Date: Sat, 2 Apr 2016 09:15:56 +0800
MIME-Version: 1.0
In-Reply-To: <20160329194722.GC27148@jeknote.loshitsa1.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 03/30/2016 03:47 AM, Yauhen Kharuzhy wrote:
> On Tue, Mar 29, 2016 at 10:41:36PM +0800, Anand Jain wrote:
>>
>> Hi Yauhen,
>>
>
>>>
>>> Issue 2.
>>> At start of autoreplacig drive by hotspare, kernel craches in transaction
>>> handling code (inside of btrfs_commit_transaction() called by autoreplace initiating
>>> routines). I 'fixed' this by removing of closing of bdev in btrfs_close_one_device_dont_free(), see
>>> https://bitbucket.org/jekhor/linux-btrfs/commits/dfa441c9ec7b3833f6a5e4d0b6f8c678faea29bb?at=master
>>> (oops text is attached also). Bdev is closed after replacing by
>>> btrfs_dev_replace_finishing(), so this is safe but doesn't seem
>>> to be right way.
>>
>>   I have sent out V2. I don't see that issue with this,
>>   could you pls try ?
>
> Yes, it reproduced on v4.4.5 kernel. I will try with current
> 'for-linus-4.6' Chris' tree soon.
>
> To emulate a drive failure, I disconnect the drive in VirtualBox, so bdev
> can be freed by kernel after releasing of all references to it.

   So far the raid group profile would adapt to lower suitable
   group profile when device is missing/failed. This appears to
   be not happening with RAID56 OR there are stale IO which wasn't
   flushed out. Anyway to have this fixed I am moving the patch
    btrfs: introduce device dynamic state transition to offline or failed
   to the top in v3 for any potential changes.
   But firstly we need a reliable test case, or a very carefully
   crafted test case which can create this situation

   Here below is the dm-error that I am using for testing, which
   apparently doesn't report this issue. Could you please try on V3. ?
   (pls note the device names are hard coded in the test script
   sorry about that) This would eventually be fstests script.


----
# cat util
run()
{
	local ret

	echo -- ${*} --
	echo ${*} | bash
	ret=$?
	if [ $ret -ne 0 ]; then
		echo
		echo "###### FAILED: RET $ret #####"
		echo
		exit
	fi
	echo
	#echo "OK?"; read
}

runnt()
{
	local ret

	echo -- ${*} --
	echo ${*} | bash
	ret=$?
	echo
	#echo "OK?"; read
}

wipeall()
{
	runnt "wipefs -a /dev/sd[c-h] > /dev/null"
}

create_err_dev_raid1()
{
	dm_backing_dev="/dev/sdd"
	blk_dev_size=`blockdev --getsz $dm_backing_dev`
	dmerror_dev="/dev/mapper/dm-sdd"
	dmlinear_table="0 $blk_dev_size linear $dm_backing_dev 0"
	dmerror_table="0 $blk_dev_size error $dm_backing_dev 0"

	echo -e dm_backing_dev'\t'= $dm_backing_dev
	echo -e blk_dev_size'\t'= $blk_dev_size
	echo -e dmerror_dev'\t'= $dmerror_dev
	echo -e dmlinear_table'\t'= $dmlinear_table
	echo -e dmerror_table'\t'= $dmerror_table
	echo

	runnt "dmsetup remove dm-sdd > /dev/null 2>&1"
	run "dmsetup create dm-sdd --table '${dmlinear_table}'"

	run "mkfs.btrfs -f -draid1 -mraid1 /dev/sdc $dmerror_dev > /dev/null 2>&1"
	run mount /dev/sdc /btrfs
	run "fillfs /btrfs 1000 > /dev/null 2>&1"
	run "dd if=/dev/zero of=/btrfs/tf1 bs=4096 count=100 > /dev/null 2>&1"

	run btrfs fi show

#	run sleep 32

	run dmsetup suspend dm-sdd
	run "dmsetup load dm-sdd --table '$dmerror_table'"
	run dmsetup resume dm-sdd
	run "dd if=/dev/zero of=/btrfs/tf1 bs=4096 count=100 > /dev/null 2>&1"

	run btrfs fi show
}

create_err_dev_raid56()
{
	dm_backing_dev="/dev/sdd"
	blk_dev_size=`blockdev --getsz $dm_backing_dev`
	dmerror_dev="/dev/mapper/dm-sdd"
	dmlinear_table="0 $blk_dev_size linear $dm_backing_dev 0"
	dmerror_table="0 $blk_dev_size error $dm_backing_dev 0"

	echo -e dm_backing_dev'\t'= $dm_backing_dev
	echo -e blk_dev_size'\t'= $blk_dev_size
	echo -e dmerror_dev'\t'= $dmerror_dev
	echo -e dmlinear_table'\t'= $dmlinear_table
	echo -e dmerror_table'\t'= $dmerror_table
	echo

	runnt "dmsetup remove dm-sdd > /dev/null 2>&1"
	run "dmsetup create dm-sdd --table '${dmlinear_table}'"

	run "mkfs.btrfs -f -draid5 -mraid5 /dev/sdc /dev/sdf $dmerror_dev > 
/dev/null 2>&1"
	run mount /dev/sdc /btrfs
	run "fillfs /btrfs 1000 > /dev/null 2>&1"
	run "dd if=/dev/zero of=/btrfs/tf1 bs=4096 count=100 > /dev/null 2>&1"

	run btrfs fi show

#	run sleep 32

	run dmsetup suspend dm-sdd
	run "dmsetup load dm-sdd --table '$dmerror_table'"
	run dmsetup resume dm-sdd
	run "dd if=/dev/zero of=/btrfs/tf1 bs=4096 count=100 > /dev/null 2>&1"

	run btrfs fi show
}

# cat auto-replace-test56
source $(dirname $0)/util

wipeall

run btrfs spare add /dev/sde

#run cat /proc/fs/btrfs/devlist

create_err_dev_raid56
------


Thanks, Anand



> [ 1464.232552] BTRFS info (device sdc): dev_replace from <missing disk> (devid 4) to /dev/sdg started
> [ 1464.255824] BUG: unable to handle kernel NULL pointer dereference at 0000000000000548
> [ 1464.291760] IP: [<ffffffff8131d58d>] generic_make_request_checks+0x4d/0x910
> [ 1464.309746] PGD 5c668067 PUD 5b841067 PMD 0
> [ 1464.326143] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
> [ 1464.340474] Modules linked in: cpufreq_powersave cpufreq_stats cpufreq_userspace cpufreq_conservative softdog nfsd auth_rpcgss oid_registry nfs_acl nfs lockd grace fscache sunrpc ipmi_devintf ipmi_msghandler iosf_mbi crct10dif_pclmul crc32_pclmul sha256_ssse3 sha256_generic hmac drbg iTCO_wdt ansi_cprng iTCO_vendor_support snd_pcm snd_timer aesni_intel snd soundcore psmouse aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd evdev serio_raw pcspkr battery acpi_cpufreq 8250_fintek parport_pc video lpc_ich parport mfd_core tpm_tis tpm ac rng_core processor button i2c_piix4 btrfs xor raid6_pq dm_mod raid1 md_mod sg sd_mod ahci libahci libata pcnet32 crc32c_intel scsi_mod mii
> [ 1464.483244] CPU: 0 PID: 4702 Comm: btrfs-casualty Not tainted 4.4.5-scst31x+ #20
> [ 1464.511300] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
> [ 1464.518035] task: ffff88005e658580 ti: ffff88005e65c000 task.ti: ffff88005e65c000
> [ 1464.543072] RIP: 0010:[<ffffffff8131d58d>]  [<ffffffff8131d58d>] generic_make_request_checks+0x4d/0x910
> [ 1464.579027] RSP: 0018:ffff88005e65f498  EFLAGS: 00010283
> [ 1464.604774] RAX: 0000000000000000 RBX: ffff88005b919f28 RCX: 0000000000030b00
> [ 1464.629544] RDX: 0000000000000080 RSI: 0000000000000781 RDI: ffff88004ecd5ac0
> [ 1464.652763] RBP: ffff88005e65f500 R08: ffff88005b130ff0 R09: 0000000000010000
> [ 1464.674939] R10: ffff88005e674f28 R11: 0000000000000000 R12: 0000000000000080
> [ 1464.691478] R13: 0000000000000004 R14: ffff88004e48de00 R15: 0000000000000010
> [ 1464.714115] FS:  0000000000000000(0000) GS:ffff880066600000(0000) knlGS:0000000000000000
> [ 1464.737302] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [ 1464.766380] CR2: 0000000000000548 CR3: 000000005723f000 CR4: 00000000000406f0
> [ 1464.804808] Stack:
> [ 1464.814950]  ffffffff813184ae 0000000000000246 0000000000000082 0000000000000000
> [ 1464.847217]  0000000000000000 0000000000000092 0000000000000000 ffff88005e65f540
> [ 1464.879147]  ffff88005b919f28 00000000ffffffff 0000000000000004 ffff88004e48de00
> [ 1464.907440] Call Trace:
> [ 1464.919293]  [<ffffffff813184ae>] ? bvec_alloc+0x5e/0x100
> [ 1464.939019]  [<ffffffff813213a4>] generic_make_request+0x24/0x290
> [ 1464.961775]  [<ffffffff81321677>] submit_bio+0x67/0x140
> [ 1464.971842]  [<ffffffffa02051b9>] finish_rmw+0x409/0x570 [btrfs]
> [ 1464.983700]  [<ffffffffa02053c5>] full_stripe_write+0xa5/0xb0 [btrfs]
> [ 1464.996554]  [<ffffffffa0206d05>] raid56_parity_write+0xf5/0x180 [btrfs]
> [ 1465.012560]  [<ffffffffa01bab95>] btrfs_map_bio+0x105/0x300 [btrfs]
> [ 1465.046907]  [<ffffffffa018f8b3>] ? btrfs_get_extent+0x83/0xb20 [btrfs]
> [ 1465.052462]  [<ffffffffa018d175>] btrfs_submit_bio_hook+0xe5/0x1b0 [btrfs]
> [ 1465.069342]  [<ffffffff810dc081>] ? __raw_callee_save___pv_queued_spin_unlock+0x11/0x20
> [ 1465.091031]  [<ffffffffa01a917d>] submit_one_bio+0x6d/0xa0 [btrfs]
> [ 1465.111233]  [<ffffffffa01ae06e>] submit_extent_page+0xee/0x230 [btrfs]
> [ 1465.126076]  [<ffffffffa01ae7f4>] __extent_writepage_io+0x444/0x490 [btrfs]
> [ 1465.132550]  [<ffffffffa01ade10>] ? end_extent_writepage+0x80/0x80 [btrfs]
> [ 1465.145490]  [<ffffffffa01aeaa5>] __extent_writepage+0x265/0x3e0 [btrfs]
> [ 1465.168445]  [<ffffffffa01aef1b>] extent_write_cache_pages.isra.32.constprop.49+0x2fb/0x3d0 [btrfs]
> [ 1465.204094]  [<ffffffffa01b009d>] extent_writepages+0x4d/0x70 [btrfs]
> [ 1465.229627]  [<ffffffffa018f830>] ? btrfs_real_readdir+0x5c0/0x5c0 [btrfs]
> [ 1465.250927]  [<ffffffffa018d5e8>] btrfs_writepages+0x28/0x30 [btrfs]
> [ 1465.274099]  [<ffffffff811afcb1>] do_writepages+0x21/0x30
> [ 1465.298275]  [<ffffffff811a10ea>] __filemap_fdatawrite_range+0xaa/0xf0
> [ 1465.324278]  [<ffffffff811a1203>] filemap_fdatawrite_range+0x13/0x20
> [ 1465.341055]  [<ffffffffa01a1490>] btrfs_fdatawrite_range+0x20/0x50 [btrfs]
> [ 1465.378952]  [<ffffffffa01d377a>] __btrfs_write_out_cache.isra.27+0x3ea/0x430 [btrfs]
> [ 1465.405760]  [<ffffffffa01d4a7f>] btrfs_write_out_cache+0x8f/0x110 [btrfs]
> [ 1465.428091]  [<ffffffffa0176128>] btrfs_write_dirty_block_groups+0x228/0x290 [btrfs]
> [ 1465.458865]  [<ffffffffa0208d6a>] commit_cowonly_roots+0x1f8/0x283 [btrfs]
> [ 1465.480450]  [<ffffffffa018b0d7>] btrfs_commit_transaction+0x577/0xb60 [btrfs]
> [ 1465.512410]  [<ffffffffa0202cf3>] btrfs_dev_replace_start+0x2e3/0x520 [btrfs]
> [ 1465.535358]  [<ffffffffa0202b6e>] ? btrfs_dev_replace_start+0x15e/0x520 [btrfs]
> [ 1465.548049]  [<ffffffffa02038d8>] btrfs_auto_replace_start+0x58/0xd0 [btrfs]
> [ 1465.551787]  [<ffffffffa01834ad>] casualty_kthread+0x2bd/0x340 [btrfs]
> [ 1465.561195]  [<ffffffffa01833d1>] ? casualty_kthread+0x1e1/0x340 [btrfs]
> [ 1465.573308]  [<ffffffffa01831f0>] ? btrfs_check_devices+0x1f0/0x1f0 [btrfs]
> [ 1465.610840]  [<ffffffff810a70df>] kthread+0xef/0x110
> [ 1465.629472]  [<ffffffff810dc081>] ? __raw_callee_save___pv_queued_spin_unlock+0x11/0x20
> [ 1465.648678]  [<ffffffff810a6ff0>] ? kthread_create_on_node+0x200/0x200
> [ 1465.660686]  [<ffffffff81637c2f>] ret_from_fork+0x3f/0x70
> [ 1465.667065]  [<ffffffff810a6ff0>] ? kthread_create_on_node+0x200/0x200
> [ 1465.676861] Code: 67 28 48 c7 c7 6b f8 a3 81 e8 40 09 d9 ff e8 3b 43 31 00 41 c1 ec 09 48 8b 7b 08 45 85 e4 0f 85 13 01 00 00 48 8b 87 f0 00 00 00 <4c> 8b b8 48 05 00 00 4d 85 ff 0f 84 d5 01 00 00 4c 8b af e0 00
> [ 1465.750135] RIP  [<ffffffff8131d58d>] generic_make_request_checks+0x4d/0x910
> [ 1465.776005]  RSP <ffff88005e65f498>
> [ 1465.790848] CR2: 0000000000000548
> [ 1465.797370] ---[ end trace 45545495cd54e799 ]---
>
>
>
