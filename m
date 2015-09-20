Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:54071 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753424AbbITBWj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 19 Sep 2015 21:22:39 -0400
Subject: Re: kernel BUG at linux-4.2.0/fs/btrfs/extent-tree.c:1833 on
 rebalance
To: =?UTF-8?Q?St=c3=a9phane_Lesimple?= <stephane_btrfs@lesimple.fr>
References: <9c864637fe7676a8b7badc5ddd7a4e0c@all.all>
 <2c00c4b7c15e424659fb2e810170e32e@all.all> <55F83181.9010201@fb.com>
 <532aadf0f92d08d3d2b274173548aee1@all.all>
 <pan$e885$1290ceef$c5017ead$b38037f1@cox.net>
 <f81878fadaf2980a72522e54010e0415@all.all> <55F9486F.4040302@googlemail.com>
 <0973de930ee87e102c533c719807b748@all.all>
 <pan$5599c$cb01bfb8$910004c8$d38ea6b6@cox.net>
 <d2f30d85fa83b8b98af3c7e5a862044d@all.all> <55FA2D9A.1060405@cn.fujitsu.com>
 <e80ea6421a1f6a5f84c5d1032fc6a3e8@all.all> <55FA60C5.5090002@cn.fujitsu.com>
 <7a6f2d794fb6cbf7d598b92e3470201c@all.all> <55FA759E.6030707@cn.fujitsu.com>
 <3386a8bfa1a5796460306a53a668e47e@all.all> <55FA98D8.5010301@gmx.com>
 <53a5553a9c5301789e246144bb264e43@all.all> <55FB61E9.4000300@cn.fujitsu.com>
 <2ce9b35f73732b145e0f80b18f230a52@all.all>
 <c605d4d156f9a880b216e89ca0705269@all.all>
 <762ec73d5389b5057be4d3c17f74e1f9@all.all>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <55FE0A50.9060607@gmx.com>
Date: Sun, 20 Sep 2015 09:22:24 +0800
MIME-Version: 1.0
In-Reply-To: <762ec73d5389b5057be4d3c17f74e1f9@all.all>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



在 2015年09月18日 18:26, Stéphane Lesimple 写道:
> Le 2015-09-18 12:15, Stéphane Lesimple a écrit :
>> Le 2015-09-18 09:36, Stéphane Lesimple a écrit :
>>> Sure, I did a quota disable / quota enable before running the snapshot
>>> debug procedure, so the qgroups were clean again when I started :
>>>
>>> qgroupid          rfer          excl     max_rfer     max_excl parent
>>> child
>>> --------          ----          ----     --------     -------- ------
>>> -----
>>> 0/5              16384         16384         none         none --- ---
>>> 0/1906   1657848029184 1657848029184         none         none --- ---
>>> 0/1909    124950921216  124950921216         none         none --- ---
>>> 0/1911   1054587293696 1054587293696         none         none --- ---
>>> 0/3270     23727300608   23727300608         none         none --- ---
>>> 0/3314     23221784576   23221784576         none         none --- ---
>>> 0/3341      7479275520    7479275520         none         none --- ---
>>> 0/3367     24185790464   24185790464         none         none --- ---
>>>
>>> The test is running, I expect to post the results within an hour or two.
>>
>> Well, my system crashed twice while running the procedure...
>> By "crashed" I mean : the machine no longer pings, and nothing is
>> logged in kern.log unfortunately :
>>
>> [ 7096.735731] BTRFS info (device dm-3): qgroup scan completed
>> (inconsistency flag cleared)
>> [ 7172.614851] BTRFS info (device dm-3): qgroup scan completed
>> (inconsistency flag cleared)
>> [ 7242.870259] BTRFS info (device dm-3): qgroup scan completed
>> (inconsistency flag cleared)
>> [ 7321.466931] BTRFS info (device dm-3): qgroup scan completed
>> (inconsistency flag cleared)
>> [    0.000000] Initializing cgroup subsys cpuset
>>
>> The even stranger part is that the last 2 stdout dump files exist but
>> are empty :
>>
>> -rw-r--r-- 1 root root   21 Sep 18 10:29 snap32.step5
>> -rw-r--r-- 1 root root 3.2K Sep 18 10:29 snap32.step6
>> -rw-r--r-- 1 root root 3.2K Sep 18 10:29 snap33.step1
>> -rw-r--r-- 1 root root 3.3K Sep 18 10:29 snap33.step3
>> -rw-r--r-- 1 root root   21 Sep 18 10:30 snap33.step5
>> -rw-r--r-- 1 root root 3.3K Sep 18 10:30 snap33.step6
>> -rw-r--r-- 1 root root 3.3K Sep 18 10:30 snap34.step1
>> -rw-r--r-- 1 root root    0 Sep 18 10:30 snap34.step3 <==
>> -rw-r--r-- 1 root root    0 Sep 18 10:30 snap34.step5 <==
>>
>> The mentioned steps are as follows :
>>
>> 0) Rsync data from the next ext4 "snapshot" to the subvolume
>> 1) Do 'sync; btrfs qgroup show -⁠prce -⁠-⁠raw' and save the output <==
>> 2) Create the needed readonly snapshot on btrfs
>> 3) Do 'sync; btrfs qgroup show -⁠prce -⁠-⁠raw' and save the output <==
>> 4) Avoid doing IO if possible until step 6)
>> 5) Do 'btrfs quota rescan -⁠w' and save it <==
>> 6) Do 'sync; btrfs qgroup show -⁠prce -⁠-⁠raw' and save the output <==
>>
>> The resulting files are available here:
>> http://speed47.net/tmp2/qgroup.tar.gz
>> The run2 is the more complete one, during run1 the machine crashed
>> even faster.
>> It's interesting to note, however, that it seems to have crashed the
>> same way and at the same step in the process.

Your data really helps a lot!!

And the good news is, the qgroup accouting part is working as expected.
Although I only checked about 1/3/6 of about 5 snaps, they are all OK.

I can make a script to cross check them, but from the last few result, I 
think qgroup works fine.

I'm more confident about the minus number, which should be a result of 
deleted subvolume, and the real problem is, such qgroup is not handled 
well with qgroup rescan.

I'll try to add a hot fix for such case if needed.
But right now, I don't have a good idea for it until Mark's work of 
rescan subtree.

Maybe I can add a new option for btrfs-progs to automatically remove the 
qgroup and trigger a rescan?

> Actually about that, I forgot I did set up netconsole before starting
> the second run after the first "muted" crash, and it did work : even if
> I have no logs in kern.log, netconsole managed to send them to my other
> machine before going down, so here it is :
>
> ---
> [ 5738.172692] BUG: unable to handle kernel NULL pointer dereference at
> 00000000000001f0
> [ 5738.172702] IP: [<ffffffffc03150db>] start_transaction+0x1b/0x580
> [btrfs]
> [ 5738.172719] PGD c0aa7067 PUD c0aa6067 PMD 0
> [ 5738.172723] Oops: 0000 [#1] SMP
> [ 5738.172726] Modules linked in: netconsole configfs xts gf128mul drbg
> ansi_cprng xt_multiport xt_comment xt_conntrack xt_nat xt_tcpudp
> nfnetlink_queue nfnetlink_log nfnetlink nf_conntrack_ftp
> nf_conntrack_sane iptable_security iptable_filter iptable_mangle
> iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat
> nf_conntrack iptable_raw ip_tables x_tables nfsd auth_rpcgss nfs_acl nfs
> cmac dm_crypt rfcomm bnep lockd grace sunrpc fscache binfmt_misc
> intel_rapl snd_hda_codec_realtek iosf_mbi x86_pkg_temp_thermal
> intel_powerclamp kvm_intel snd_hda_codec_generic snd_hda_intel
> snd_hda_codec kvm eeepc_wmi asus_wmi snd_hda_core btusb sparse_keymap
> btrtl snd_hwdep btbcm snd_pcm btintel 8021q bluetooth snd_seq_midi
> dm_multipath snd_seq_midi_event garp snd_rawmidi mrp snd_seq stp llc
> snd_seq_device snd_timer crct10dif_pclmul crc32_pclmul snd
> ghash_clmulni_intel cryptd serio_raw soundcore mei_me mei lpc_ich shpchp
> mac_hid parport_pc ppdev nct6775 hwmon_vid coretemp lp parport btrfs
> raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor
> async_tx xor raid6_pq raid0 multipath linear nbd raid1 i915 e1000e
> i2c_algo_bit drm_kms_helper syscopyarea ptp sysfillrect sysimgblt
> fb_sys_fops psmouse ahci drm libahci pps_core wmi video [last unloaded:
> netconsole]
> [ 5738.172831] CPU: 1 PID: 10932 Comm: kworker/u4:14 Not tainted
> 4.3.0-rc1 #1
> [ 5738.172833] Hardware name: ASUS All Series/H87I-PLUS, BIOS 1005
> 01/06/2014
> [ 5738.172843] Workqueue: btrfs-qgroup-rescan btrfs_qgroup_rescan_helper
> [btrfs]
> [ 5738.172845] task: ffff8800c7010000 ti: ffff88006acf4000 task.ti:
> ffff88006acf4000
> [ 5738.172847] RIP: 0010:[<ffffffffc03150db>]  [<ffffffffc03150db>]
> start_transaction+0x1b/0x580 [btrfs]
> [ 5738.172855] RSP: 0018:ffff88006acf7ca8  EFLAGS: 00010282
> [ 5738.172856] RAX: 0000000000000004 RBX: 0000000000000201 RCX:
> 0000000000000002
> [ 5738.172857] RDX: 0000000000000201 RSI: 0000000000000001 RDI:
> 0000000000000000
> [ 5738.172858] RBP: ffff88006acf7cf0 R08: ffff88010990eab0 R09:
> 00000001801c0017
> [ 5738.172860] R10: 000000000990e701 R11: ffffea0004264380 R12:
> 0000000000000000
> [ 5738.172861] R13: ffff8800c73a6e08 R14: ffff880027963800 R15:
> 0000160000000000
> [ 5738.172862] FS:  0000000000000000(0000) GS:ffff88011fb00000(0000)
> knlGS:0000000000000000
> [ 5738.172863] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 5738.172864] CR2: 00000000000001f0 CR3: 0000000027a65000 CR4:
> 00000000000406e0
> [ 5738.172866] Stack:
> [ 5738.172867]  ffff8800c73a6e08 ffff880027963800 0000160000000000
> ffff88006acf7ce8
> [ 5738.172871]  00000000000000be 00000000fffffffc ffff8800c73a6e08
> ffff880027963800
> [ 5738.172875]  0000160000000000 ffff88006acf7d00 ffffffffc031565b
> ffff88006acf7dc0
> [ 5738.172879] Call Trace:
> [ 5738.172887]  [<ffffffffc031565b>] btrfs_start_transaction+0x1b/0x20
> [btrfs]
> [ 5738.172896]  [<ffffffffc0378038>]
> btrfs_qgroup_rescan_worker+0x388/0x5a0 [btrfs]

Your netconsole backtrace is also of greate value.
This one implies that, my rework also caused some stupid bug.
(Yeah, I always make such bugs) or some existing unexposed rescan bug.

Would you please use gdb to show the codes of 
"btrfs_qgroup_rescan_worker+0x388" ?
(Need kernel debuginfo)

My guess is the following line:(pretty sure, but not 100% sure)
------
/*
          * only update status, since the previous part has alreay 
updated the
          * qgroup info.
          */
         trans = btrfs_start_transaction(fs_info->quota_root, 1); <<<<<
         if (IS_ERR(trans)) {
                 err = PTR_ERR(trans);
                 btrfs_err(fs_info,
                           "fail to start transaction for status update: 
%d\n",
                           err);
                 goto done;
         }
------

But that means, at rescan time, fs_info->quota_root is still NULL, which 
is quite wired.
I can add extra check to avoid such NULL pointer for now, but it's 
better to review the existing rescan workflow, as I think there is some 
race for it to init quota_root.

You can also try the following hotfix patch to see if it works:
http://pastebin.com/966GQXPk

My concern is, this may cause qgroup rescan to exit without updating its 
accounting info...

So still need your help.
Or I can use your reproducer script to test it next Monday.


> [ 5738.172904]  [<ffffffffc03444e0>] normal_work_helper+0xc0/0x270 [btrfs]
> [ 5738.172912]  [<ffffffffc03448a2>]
> btrfs_qgroup_rescan_helper+0x12/0x20 [btrfs]
> [ 5738.172915]  [<ffffffff8109127e>] process_one_work+0x14e/0x3d0
> [ 5738.172917]  [<ffffffff8109192a>] worker_thread+0x11a/0x470
> [ 5738.172919]  [<ffffffff81091810>] ? rescuer_thread+0x310/0x310
> [ 5738.172921]  [<ffffffff81097059>] kthread+0xc9/0xe0
> [ 5738.172923]  [<ffffffff81096f90>] ? kthread_park+0x60/0x60
> [ 5738.172926]  [<ffffffff817aac4f>] ret_from_fork+0x3f/0x70
> [ 5738.172928]  [<ffffffff81096f90>] ? kthread_park+0x60/0x60
> [ 5738.172929] Code: 49 c1 e9 5c ff ff ff 66 0f 1f 84 00 00 00 00 00 0f
> 1f 44 00 00 55 48 89 e5 41 57 41 56 41 55 41 54 49 89 fc 53 89 d3 48 83
> ec 20 <48> 8b 87 f0 01 00 00 48 8b 90 60 0e 00 00 83 e2 01 0f 85 86 00
> [ 5738.172973] RIP  [<ffffffffc03150db>] start_transaction+0x1b/0x580
> [btrfs]
> [ 5738.172981]  RSP <ffff88006acf7ca8>
> [ 5738.172982] CR2: 00000000000001f0
> [ 5738.172984] ---[ end trace 9feb85def1327ee9 ]---
> [ 5738.173010] BUG: unable to handle kernel paging request at
> ffffffffffffffd8
> [ 5738.173012] IP: [<ffffffff810977d0>] kthread_data+0x10/0x20
> [ 5738.173015] PGD 1c13067 PUD 1c15067 PMD 0
> [ 5738.173019] Oops: 0000 [#2] SMP
> [ 5738.173021] Modules linked in: netconsole configfs xts gf128mul drbg
> ---
>
> Clearly this is during a rescan.
>
>> As the machine is now, qgroups seems OK :
>>
>> ~# btrfs qgroup show -pcre --raw /tank/
>> qgroupid          rfer          excl     max_rfer     max_excl parent
>> child
>> --------          ----          ----     --------     -------- ------
>> -----
>> 0/5              32768         32768         none         none --- ---
>> 0/1906   3315696058368 3315696058368         none         none --- ---
>> 0/1909    249901842432  249901842432         none         none --- ---
>> 0/1911   2109174587392 2109174587392         none         none --- ---
>> 0/3270     47454601216   47454601216         none         none --- ---
>> 0/3314     46408499200         32768         none         none --- ---
>> 0/3341     14991097856         32768         none         none --- ---
>> 0/3367     48371580928   48371580928         none         none --- ---
>> 0/5335     56523751424     280592384         none         none --- ---
>> 0/5336     60175253504    2599960576         none         none --- ---
>> 0/5337     45751746560     250888192         none         none --- ---
>> 0/5338     45804650496     186531840         none         none --- ---
>> 0/5339     45875167232     190521344         none         none --- ---
>> 0/5340     45933486080        327680         none         none --- ---
>> 0/5341     45933502464        344064         none         none --- ---
>> 0/5342     46442815488      35454976         none         none --- ---
>> 0/5343     46442520576      30638080         none         none --- ---
>> 0/5344     46448312320      36495360         none         none --- ---
>> 0/5345     46425235456      86204416         none         none --- ---
>> 0/5346     46081941504     119398400         none         none --- ---
>> 0/5347     46402715648      55615488         none         none --- ---
>> 0/5348     46403534848      50528256         none         none --- ---
>> 0/5349     45486301184      91463680         none         none --- ---
>> 0/5351     46414635008        393216         none         none --- ---
>> 0/5352     46414667776        294912         none         none --- ---
>> 0/5353     46414667776        294912         none         none --- ---
>> 0/5354     46406148096      24829952         none         none --- ---
>> 0/5355     46415986688      33103872         none         none --- ---
>> 0/5356     46406262784      23216128         none         none --- ---
>> 0/5357     46408245248      17408000         none         none --- ---
>> 0/5358     46416052224      25280512         none         none --- ---
>> 0/5359     46406336512      23158784         none         none --- ---
>> 0/5360     46408335360      25157632         none         none --- ---
>> 0/5361     46406402048      24395776         none         none --- ---
>> 0/5362     46415273984      32260096         none         none --- ---
>> 0/5363     46408499200         32768         none         none --- ---
>> 0/5364     14949441536     139812864         none         none --- ---
>> 0/5365     14996299776     176889856         none         none --- ---
>> 0/5366     14958616576     143065088         none         none --- ---
>> 0/5367     14919172096     100171776         none         none --- ---
>> 0/5368     14945968128     142409728         none         none --- ---
>> 0/5369     14991097856         32768         none         none --- ---
>>
>>
>> But I'm pretty sure I can get that (u64)-1 value again by deleting
>> snapshots. Shall I ? Or do you have something else for me to run
>> before that ?

You have already done a great job in helping maturing qgroups.
The minus number and 0 excl is somewhat expected for deleted snapshots.

Good news is, 1) it doesn't affect valid(non-orphan) qgroup.
2) Mark is already working on it.

I'll try to add a btrfs-progs hotfix for you to delete and rescan 
qgroups to avoid such problem.

>>
>> So, as a quick summary of this big thread, it seems I've been hitting
>> 3 bugs, all reproductible :
>> - kernel BUG on balance (this original thread)

For this, I can't provide much help, as extent backref bug is quite hard 
to debug, unless a developer is interested in it and find a stable way 
to reproduce it.

The rest two are explained or have hot fix mentioned above.

Thanks,
Qu

>> - negative or zero "excl" qgroups
>> - hard freezes without kernel trace when playing with snapshots and quota
>>
>> Still available to dig deeper where needed.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
