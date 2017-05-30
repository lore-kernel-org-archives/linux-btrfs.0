Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:32884 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750922AbdE3S6A (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 May 2017 14:58:00 -0400
Received: by mail-wm0-f67.google.com with SMTP id b84so26877304wmh.0
        for <linux-btrfs@vger.kernel.org>; Tue, 30 May 2017 11:57:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170530180217.GA21784@lim.localdomain>
References: <20170526002631.8546-1-bo.li.liu@oracle.com> <CAMG9ccwjBmP9HKkodwARxQK7AkC68HACMzuT43wX6+gmWVUjbg@mail.gmail.com>
 <20170530180217.GA21784@lim.localdomain>
From: Ivan Sizov <sivan606@gmail.com>
Date: Tue, 30 May 2017 21:57:37 +0300
Message-ID: <CAMG9cczro5tQEvcE=QN_2+sacTmVH7dDPT8A_tcpw0oq5Z0jbA@mail.gmail.com>
Subject: Re: [PATCH 0/6] add sanity check for extent inline ref type
To: Liu Bo <bo.li.liu@oracle.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2017-05-30 21:02 GMT+03:00 Liu Bo <bo.li.liu@oracle.com>:
> On Tue, May 30, 2017 at 05:05:09PM +0300, Ivan Sizov wrote:
>> 2017-05-26 3:26 GMT+03:00 Liu Bo <bo.li.liu@oracle.com>:
>> >Patch 6 adds scrub support to detect the corruption, so users can be
>> noticed when they do scrub on a regular basis.
>> >I'm not sure in the real world what may result in this corruption
>>
>> I've caught this type of corruption in the wild. The big rsync backup
>> always ends with a kernel crash due to BUG() statement in
>> ctime.h:1779. After applying this patchset and running scrub I've got
>> following messages:
>>
>> [sivan@fruestuck ~]$ dmesg | grep "invalid extent inline"
>> [ 8812.428673] eb 4631634034688(tree block) invalid extent inline ref type 0
>> [ 8812.429148] BTRFS error (device sdb1): scrub: extent
>> 2994741510144(0x2b944810000) has an invalid extent inline ref type,
>> ignored.
>> [ 8812.430086] eb 4631634034688(tree block) invalid extent inline ref type 0
>> [ 8812.430569] BTRFS error (device sdb1): scrub: extent
>> 2994741559296(0x2b94481c000) has an invalid extent inline ref type,
>> ignored.
>>
>> How to find the cause of the corruption? Should I try to fix it, or it
>> is not dangerous for the filesystem? If I should, how to do that?
>
> Did it also print a btree's leaf's content?  If yes, it could show us
> which inline ref has the issue.

Yes, it does.

------------[ cut here ]------------
WARNING: CPU: 0 PID: 14133 at fs/btrfs/scrub.c:2506
scrub_stripe+0xe6f/0x1170 [btrfs]
Modules linked in: veth xt_nat ipt_MASQUERADE nf_nat_masquerade_ipv4
xt_addrtype br_netfilter nf_conntrack_netbios_ns
nf_conntrack_broadcast nf_conntrack_ftp xt_CT ip6t_rpfilter
ip6t_REJECT nf_reject_ipv6 ip_set nfnetlink ebtable_nat ebtable_broute
bridge stp llc ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6
nf_nat_ipv6 ip6table_mangle ip6table_raw ip6table_security iptable_nat
nf_nat_ipv4 nf_nat iptable_mangle iptable_raw iptable_security
ebtable_filter ebtables nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack
nf_conntrack libcrc32c ip6table_filter ip6_tables intel_powerclamp
coretemp kvm_intel kvm snd_hda_codec_realtek snd_hda_codec_generic
irqbypass snd_hda_intel intel_cstate snd_hda_codec intel_uncore ppdev
snd_hda_core snd_hwdep iTCO_wdt iTCO_vendor_support mei_wdt gpio_ich
snd_seq
 snd_seq_device snd_pcm snd_timer snd soundcore tpm_infineon mei_me
mei acpi_cpufreq tpm_tis parport_pc parport i2c_i801 tpm_tis_core
shpchp tpm lpc_ich nfsd auth_rpcgss nfs_acl lockd grace sunrpc
binfmt_misc btrfs hid_logitech_hidpp xor i915 raid6_pq crc32c_intel
video i2c_algo_bit drm_kms_helper serio_raw drm hid_logitech_dj uas
usb_storage r8169 mii
CPU: 0 PID: 14133 Comm: btrfs Not tainted
4.11.3-200.local.btrfs_patched.fc25.x86_64 #1
Hardware name: MSI MS-7636/H55M-P31(MS-7636)   , BIOS V1.9 09/14/2010
Call Trace:
 dump_stack+0x63/0x86
 __warn+0xcb/0xf0
 warn_slowpath_null+0x1d/0x20
 scrub_stripe+0xe6f/0x1170 [btrfs]
 scrub_chunk+0x102/0x140 [btrfs]
 ? scrub_chunk+0x102/0x140 [btrfs]
 scrub_enumerate_chunks+0x300/0x680 [btrfs]
 ? wake_atomic_t_function+0x60/0x70
 btrfs_scrub_dev+0x213/0x540 [btrfs]
 ? __mnt_want_write+0x56/0x60
 btrfs_ioctl+0x1351/0x2470 [btrfs]
 do_vfs_ioctl+0xa3/0x5f0
 ? do_vfs_ioctl+0xa3/0x5f0
 ? security_file_ioctl+0x43/0x60
 SyS_ioctl+0x79/0x90
 do_syscall_64+0x67/0x180
 entry_SYSCALL64_slow_path+0x25/0x25
RIP: 0033:0x7fa688cc4787
RSP: 002b:00007fa6873c2d58 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00005572d3db7190 RCX: 00007fa688cc4787
RDX: 00005572d3db7190 RSI: 00000000c400941b RDI: 0000000000000003
RBP: 0000000000000000 R08: 00007fa6873c3700 R09: 0000000000000000
R10: 00007fa6873c3700 R11: 0000000000000246 R12: 00007fa6873c3500
R13: 00007ffc22fb28ef R14: 00007fa6873c39c0 R15: 00007fa6873c3700
---[ end trace 70deff6b302d4408 ]---
BTRFS info (device sdb1): leaf 2994891669504 total ptrs 121 free space 8284
        item 0 key (2994739920896 169 0) itemoff 16250 itemsize 33
                extent refs 1 gen 833513 flags 258
                shared block backref parent 4026278117376
        item 1 key (2994739937280 169 0) itemoff 16217 itemsize 33
                extent refs 1 gen 1389730 flags 2
                tree block backref root 1429
        item 2 key (2994739953664 169 0) itemoff 16184 itemsize 33
                extent refs 1 gen 1389730 flags 2
                tree block backref root 1429
        item 3 key (2994739970048 169 0) itemoff 16151 itemsize 33
                extent refs 1 gen 1417250 flags 2
                tree block backref root 1451
        item 4 key (2994739986432 169 0) itemoff 16118 itemsize 33
                extent refs 1 gen 826970 flags 2
                tree block backref root 7
        item 5 key (2994740002816 169 0) itemoff 16085 itemsize 33
                extent refs 1 gen 983344 flags 2
                tree block backref root 7
        item 6 key (2994740019200 169 0) itemoff 16052 itemsize 33
                extent refs 1 gen 1389730 flags 2
                tree block backref root 1429
        item 7 key (2994740035584 169 0) itemoff 16019 itemsize 33
                extent refs 1 gen 1389525 flags 2
                tree block backref root 2069
        item 8 key (2994740051968 169 0) itemoff 15986 itemsize 33
                extent refs 1 gen 1389525 flags 2
                tree block backref root 2069
        item 9 key (2994740068352 169 0) itemoff 15953 itemsize 33
                extent refs 1 gen 826970 flags 2
                tree block backref root 7
        item 10 key (2994740084736 169 0) itemoff 15920 itemsize 33
                extent refs 1 gen 1389525 flags 2
                tree block backref root 2069
        item 11 key (2994740101120 169 0) itemoff 15887 itemsize 33
                extent refs 1 gen 1389525 flags 2
                tree block backref root 2069
        item 12 key (2994740117504 169 0) itemoff 15854 itemsize 33
                extent refs 1 gen 1414389 flags 258
                shared block backref parent 4632584617984
        item 13 key (2994740133888 169 0) itemoff 15821 itemsize 33
                extent refs 1 gen 1417250 flags 2
                tree block backref root 1451
        item 14 key (2994740150272 169 0) itemoff 15788 itemsize 33
                extent refs 1 gen 826970 flags 2
                tree block backref root 7
        item 15 key (2994740166656 169 0) itemoff 15755 itemsize 33
                extent refs 1 gen 1389730 flags 2
                tree block backref root 1429
        item 16 key (2994740183040 169 0) itemoff 15722 itemsize 33
                extent refs 1 gen 1389525 flags 2
                tree block backref root 2069
        item 17 key (2994740199424 169 0) itemoff 15689 itemsize 33
                extent refs 1 gen 1417250 flags 2
                tree block backref root 1451
        item 18 key (2994740215808 169 0) itemoff 15647 itemsize 42
                extent refs 2 gen 1406394 flags 258
                shared block backref parent 4633401622528
                shared block backref parent 4627188744192
        item 19 key (2994740232192 169 0) itemoff 15614 itemsize 33
                extent refs 1 gen 833513 flags 258
                shared block backref parent 4026278150144
        item 20 key (2994740248576 169 0) itemoff 15581 itemsize 33
                extent refs 1 gen 1389730 flags 2
                tree block backref root 1429
        item 21 key (2994740264960 169 0) itemoff 15548 itemsize 33
                extent refs 1 gen 1389525 flags 2
                tree block backref root 2069
        item 22 key (2994740281344 169 0) itemoff 15515 itemsize 33
                extent refs 1 gen 1389525 flags 2
                tree block backref root 2069
        item 23 key (2994740297728 169 0) itemoff 15482 itemsize 33
                extent refs 1 gen 1389525 flags 2
                tree block backref root 2069
        item 24 key (2994740314112 169 0) itemoff 15440 itemsize 42
                extent refs 2 gen 1406394 flags 258
                shared block backref parent 4633401622528
                shared block backref parent 4627188744192
        item 25 key (2994740330496 169 0) itemoff 15407 itemsize 33
                extent refs 1 gen 827339 flags 258
                shared block backref parent 4037502517248
        item 26 key (2994740346880 169 0) itemoff 15374 itemsize 33
                extent refs 1 gen 1417250 flags 2
                tree block backref root 1451
        item 27 key (2994740363264 169 0) itemoff 15332 itemsize 42
                extent refs 2 gen 1322391 flags 258
                shared block backref parent 4537765806080
                shared block backref parent 4537190842368
        item 28 key (2994740379648 169 0) itemoff 15290 itemsize 42
                extent refs 2 gen 1406394 flags 258
                shared block backref parent 4633401622528
                shared block backref parent 4627188744192
        item 29 key (2994740396032 169 0) itemoff 15230 itemsize 60
                extent refs 4 gen 826464 flags 258
                shared block backref parent 4037394251776
                shared block backref parent 4037222711296
                shared block backref parent 3213570605056
                shared block backref parent 3213569130496
        item 30 key (2994740412416 169 0) itemoff 15179 itemsize 51
                extent refs 3 gen 827339 flags 258
                shared block backref parent 3470248460288
                shared block backref parent 3470248443904
                shared block backref parent 3470248329216
        item 31 key (2994740428800 169 0) itemoff 15146 itemsize 33
                extent refs 1 gen 1389525 flags 2
                tree block backref root 2069
        item 32 key (2994740461568 169 0) itemoff 15113 itemsize 33
                extent refs 1 gen 1389525 flags 2
                tree block backref root 2069
        item 33 key (2994740477952 169 0) itemoff 15080 itemsize 33
                extent refs 1 gen 1417250 flags 2
                tree block backref root 1451
        item 34 key (2994740510720 169 0) itemoff 15038 itemsize 42
                extent refs 2 gen 1414985 flags 2
                tree block backref root 23268
                shared block backref parent 4633738919936
        item 35 key (2994740527104 169 0) itemoff 15005 itemsize 33
                extent refs 1 gen 1262619 flags 258
                shared block backref parent 2994735022080
        item 36 key (2994740543488 169 0) itemoff 14972 itemsize 33
                extent refs 1 gen 1414571 flags 2
                tree block backref root 23268
        item 37 key (2994740559872 169 0) itemoff 14939 itemsize 33
                extent refs 1 gen 1414571 flags 2
                tree block backref root 23269
        item 38 key (2994740576256 169 0) itemoff 14870 itemsize 69
                extent refs 5 gen 1417199 flags 2
                tree block backref root 23268
                shared block backref parent 4634987790336
                shared block backref parent 4630838362112
                shared block backref parent 4630064791552
                shared block backref parent 4628769914880
        item 39 key (2994740592640 169 0) itemoff 14828 itemsize 42
                extent refs 2 gen 827339 flags 258
                shared block backref parent 4197157306368
                shared block backref parent 4197157257216
        item 40 key (2994740609024 169 0) itemoff 14795 itemsize 33
                extent refs 1 gen 833513 flags 258
                shared block backref parent 4026278117376
        item 41 key (2994740625408 169 0) itemoff 14717 itemsize 78
                extent refs 6 gen 831506 flags 258
                shared block backref parent 4240500473856
                shared block backref parent 4239944220672
                shared block backref parent 4197485166592
                shared block backref parent 4197485150208
                shared block backref parent 4197467586560
                shared block backref parent 4001359904768
        item 42 key (2994740641792 169 0) itemoff 14684 itemsize 33
                extent refs 1 gen 833513 flags 258
                shared block backref parent 4026278150144
        item 43 key (2994740674560 169 0) itemoff 14651 itemsize 33
                extent refs 1 gen 1264652 flags 258
                shared block backref parent 4196919754752
        item 44 key (2994740690944 169 0) itemoff 14591 itemsize 60
                extent refs 4 gen 827339 flags 258
                shared block backref parent 4240327262208
                shared block backref parent 4240083386368
                shared block backref parent 4197838585856
                shared block backref parent 4026387365888
        item 45 key (2994740707328 169 0) itemoff 14558 itemsize 33
                extent refs 1 gen 1389525 flags 2
                tree block backref root 2069
        item 46 key (2994740723712 169 0) itemoff 14525 itemsize 33
                extent refs 1 gen 1400556 flags 258
                shared block backref parent 4636817702912
        item 47 key (2994740740096 169 0) itemoff 14492 itemsize 33
                extent refs 1 gen 833513 flags 258
                shared block backref parent 4026278117376
        item 48 key (2994740756480 169 0) itemoff 14459 itemsize 33
                extent refs 1 gen 1262619 flags 258
                shared block backref parent 4197476712448
        item 49 key (2994740772864 169 0) itemoff 14165 itemsize 294
                extent refs 30 gen 826464 flags 258
                tree block backref root 23269
                tree block backref root 22154
                tree block backref root 599
                shared block backref parent 4851402244096
                shared block backref parent 4635304804352
                shared block backref parent 4628579106816
                shared block backref parent 4628285816832
                shared block backref parent 4627642433536
                shared block backref parent 4537789579264
                shared block backref parent 4537419677696
                shared block backref parent 4537241993216
                shared block backref parent 4240853876736
                shared block backref parent 4240792502272
                shared block backref parent 4240286760960
                shared block backref parent 4197594628096
                shared block backref parent 4197489754112
                shared block backref parent 4197489377280
                shared block backref parent 4197489328128
                shared block backref parent 4197476712448
                shared block backref parent 4197107908608
                shared block backref parent 4001305739264
                shared block backref parent 4000873627648
                shared block backref parent 3918606139392
                shared block backref parent 3470774747136
                shared block backref parent 3213987184640
                shared block backref parent 3213552025600
                shared block backref parent 3213531414528
                shared block backref parent 2994976833536
                shared block backref parent 2994213994496
                shared block backref parent 2405100175360
        item 50 key (2994740789248 169 0) itemoff 13952 itemsize 213
                extent refs 21 gen 827339 flags 258
                tree block backref root 22154
                tree block backref root 599
                shared block backref parent 4627601620992
                shared block backref parent 4537810042880
                shared block backref parent 4537500680192
                shared block backref parent 4537357205504
                shared block backref parent 4537200869376
                shared block backref parent 4240320200704
                shared block backref parent 4240180199424
                shared block backref parent 4197591351296
                shared block backref parent 4197591269376
                shared block backref parent 4197324750848
                shared block backref parent 4196935434240
                shared block backref parent 4037456265216
                shared block backref parent 4027117404160
                shared block backref parent 3379070582784
                shared block backref parent 2993861459968
                shared block backref parent 2993423548416
                shared block backref parent 2941186490368
                shared block backref parent 2405627346944
                shared block backref parent 2405178884096
        item 51 key (2994740805632 169 0) itemoff 13919 itemsize 33
                extent refs 1 gen 833513 flags 258
                shared block backref parent 4026278150144
        item 52 key (2994740822016 169 0) itemoff 13886 itemsize 33
                extent refs 1 gen 832548 flags 2
                tree block backref root 7
        item 53 key (2994740838400 169 0) itemoff 13844 itemsize 42
                extent refs 2 gen 827339 flags 258
                shared block backref parent 4037502517248
                shared block backref parent 3918522187776
        item 54 key (2994740854784 169 0) itemoff 13811 itemsize 33
                extent refs 1 gen 1414662 flags 2
                tree block backref root 23268
        item 55 key (2994740887552 169 0) itemoff 13778 itemsize 33
                extent refs 1 gen 832548 flags 2
                tree block backref root 7
        item 56 key (2994740903936 169 0) itemoff 13736 itemsize 42
                extent refs 2 gen 827339 flags 258
                shared block backref parent 4037502517248
                shared block backref parent 3918522187776
        item 57 key (2994740920320 169 0) itemoff 13703 itemsize 33
                extent refs 1 gen 828860 flags 258
                shared block backref parent 4026247200768
        item 58 key (2994740936704 169 0) itemoff 13670 itemsize 33
                extent refs 1 gen 832548 flags 2
                tree block backref root 7
        item 59 key (2994740953088 169 0) itemoff 13628 itemsize 42
                extent refs 2 gen 1381556 flags 258
                shared block backref parent 3213982466048
                shared block backref parent 2994764578816
        item 60 key (2994740969472 169 0) itemoff 13595 itemsize 33
                extent refs 1 gen 1388773 flags 258
                shared block backref parent 4629308555264
        item 61 key (2994741002240 169 0) itemoff 13562 itemsize 33
                extent refs 1 gen 833647 flags 2
                tree block backref root 7
        item 62 key (2994741018624 169 0) itemoff 13529 itemsize 33
                extent refs 1 gen 828860 flags 258
                shared block backref parent 4026355630080
        item 63 key (2994741035008 169 0) itemoff 13460 itemsize 69
                extent refs 5 gen 1417199 flags 2
                tree block backref root 23268
                shared block backref parent 4634987790336
                shared block backref parent 4630838362112
                shared block backref parent 4630064791552
                shared block backref parent 4628769914880
        item 64 key (2994741051392 169 0) itemoff 13427 itemsize 33
                extent refs 1 gen 1417199 flags 2
                tree block backref root 2
        item 65 key (2994741067776 169 0) itemoff 13394 itemsize 33
                extent refs 1 gen 1414571 flags 2
                tree block backref root 23268
        item 66 key (2994741084160 169 0) itemoff 13343 itemsize 51
                extent refs 3 gen 1414985 flags 2
                tree block backref root 23268
                shared block backref parent 4850632065024
                shared block backref parent 4630524002304
        item 67 key (2994741100544 169 0) itemoff 13310 itemsize 33
                extent refs 1 gen 1401319 flags 258
                shared block backref parent 2404955914240
        item 68 key (2994741116928 169 0) itemoff 13277 itemsize 33
                extent refs 1 gen 833513 flags 258
                shared block backref parent 4026278117376
        item 69 key (2994741133312 169 0) itemoff 13244 itemsize 33
                extent refs 1 gen 1389730 flags 2
                tree block backref root 1429
        item 70 key (2994741149696 169 0) itemoff 13211 itemsize 33
                extent refs 1 gen 833513 flags 258
                shared block backref parent 4026278150144
        item 71 key (2994741182464 169 0) itemoff 13178 itemsize 33
                extent refs 1 gen 1400556 flags 258
                shared block backref parent 4636825878528
        item 72 key (2994741198848 169 0) itemoff 13145 itemsize 33
                extent refs 1 gen 1372535 flags 2
                tree block backref root 1577
        item 73 key (2994741215232 169 0) itemoff 13112 itemsize 33
                extent refs 1 gen 1417199 flags 2
                tree block backref root 2
        item 74 key (2994741231616 169 0) itemoff 13079 itemsize 33
                extent refs 1 gen 1400556 flags 258
                shared block backref parent 4636824109056
        item 75 key (2994741248000 169 0) itemoff 13046 itemsize 33
                extent refs 1 gen 1263596 flags 258
                shared block backref parent 4196936613888
        item 76 key (2994741264384 169 0) itemoff 13013 itemsize 33
                extent refs 1 gen 1389730 flags 2
                tree block backref root 1429
        item 77 key (2994741280768 169 0) itemoff 12980 itemsize 33
                extent refs 1 gen 1389730 flags 2
                tree block backref root 1429
        item 78 key (2994741297152 169 0) itemoff 12947 itemsize 33
                extent refs 1 gen 1389730 flags 2
                tree block backref root 1429
        item 79 key (2994741313536 169 0) itemoff 12914 itemsize 33
                extent refs 1 gen 1389730 flags 2
                tree block backref root 1429
        item 80 key (2994741329920 169 0) itemoff 12746 itemsize 168
                extent refs 16 gen 827339 flags 258
                tree block backref root 600
                shared block backref parent 4628782678016
                shared block backref parent 4537392381952
                shared block backref parent 4537253691392
                shared block backref parent 4197723029504
                shared block backref parent 4197274419200
                shared block backref parent 4197047074816
                shared block backref parent 4037851742208
                shared block backref parent 4000956743680
                shared block backref parent 4000687423488
                shared block backref parent 4000453361664
                shared block backref parent 3918531346432
                shared block backref parent 3918469185536
                shared block backref parent 3213947092992
                shared block backref parent 2993295720448
                shared block backref parent 2477789478912
        item 81 key (2994741346304 169 0) itemoff 12713 itemsize 33
                extent refs 1 gen 1389730 flags 2
                tree block backref root 1429
        item 82 key (2994741362688 169 0) itemoff 12680 itemsize 33
                extent refs 1 gen 1389730 flags 2
                tree block backref root 1429
        item 83 key (2994741379072 169 0) itemoff 12647 itemsize 33
                extent refs 1 gen 1389730 flags 2
                tree block backref root 1429
        item 84 key (2994741395456 169 0) itemoff 12614 itemsize 33
                extent refs 1 gen 1389683 flags 2
                tree block backref root 3095
        item 85 key (2994741411840 169 0) itemoff 12581 itemsize 33
                extent refs 1 gen 1389730 flags 2
                tree block backref root 1429
        item 86 key (2994741428224 169 0) itemoff 12548 itemsize 33
                extent refs 1 gen 1389730 flags 2
                tree block backref root 1429
        item 87 key (2994741444608 169 0) itemoff 12515 itemsize 33
                extent refs 1 gen 1401319 flags 258
                shared block backref parent 2404955914240
        item 88 key (2994741460992 169 0) itemoff 12482 itemsize 33
                extent refs 1 gen 1417250 flags 2
                tree block backref root 1451
        item 89 key (2994741477376 169 0) itemoff 12404 itemsize 78
                extent refs 6 gen 827339 flags 258
                shared block backref parent 4197954289664
                shared block backref parent 4197954256896
                shared block backref parent 4197577523200
                shared block backref parent 4197571641344
                shared block backref parent 4000654016512
                shared block backref parent 3917758775296
        item 90 key (2994741493760 169 0) itemoff 12371 itemsize 33
                extent refs 811139072 gen 246284288 flags 0
                tree block backref root 1429
        item 91 key (2994741510144 169 0) itemoff 12338 itemsize 33
                extent refs 0 gen 0 flags 0
BTRFS error (device sdb1): extent 2994891669504 has invalid ref type 0
        item 92 key (2994741559296 169 0) itemoff 12305 itemsize 33
                extent refs 1 gen 1389525 flags 1578675552460472322
BTRFS error (device sdb1): extent 2994891669504 has invalid ref type 0
        item 93 key (2994741575680 169 0) itemoff 12272 itemsize 33
                extent refs 1 gen 1389525 flags 2
                tree block backref root 2069
        item 94 key (2994741592064 169 0) itemoff 12230 itemsize 42
                extent refs 2 gen 1414178 flags 258
                shared block backref parent 2995019202560
                shared block backref parent 2993213603840
        item 95 key (2994741608448 169 0) itemoff 12197 itemsize 33
                extent refs 1 gen 1322391 flags 258
                shared block backref parent 2404909006848
        item 96 key (2994741624832 169 0) itemoff 12164 itemsize 33
                extent refs 1 gen 1389525 flags 2
                tree block backref root 2069
        item 97 key (2994741641216 169 0) itemoff 12131 itemsize 33
                extent refs 1 gen 1389525 flags 2
                tree block backref root 2069
        item 98 key (2994741657600 169 0) itemoff 12089 itemsize 42
                extent refs 2 gen 1417199 flags 2
                tree block backref root 23268
                shared block backref parent 5168957800448
        item 99 key (2994741673984 169 0) itemoff 12056 itemsize 33
                extent refs 1 gen 1389730 flags 2
                tree block backref root 1429
        item 100 key (2994741690368 169 0) itemoff 12014 itemsize 42
                extent refs 2 gen 1322391 flags 258
                shared block backref parent 4537776128000
                shared block backref parent 4537233702912
        item 101 key (2994741706752 169 0) itemoff 11972 itemsize 42
                extent refs 2 gen 1417199 flags 2
                tree block backref root 23268
                shared block backref parent 5168957800448
        item 102 key (2994741723136 169 0) itemoff 11939 itemsize 33
                extent refs 1 gen 1389525 flags 2
                tree block backref root 2069
        item 103 key (2994741739520 169 0) itemoff 11906 itemsize 33
                extent refs 1 gen 1389525 flags 2
                tree block backref root 2069
        item 104 key (2994741755904 169 0) itemoff 11873 itemsize 33
                extent refs 1 gen 1389525 flags 2
                tree block backref root 2069
        item 105 key (2994741772288 169 0) itemoff 11840 itemsize 33
                extent refs 1 gen 1389525 flags 2
                tree block backref root 2069
        item 106 key (2994741788672 169 0) itemoff 11798 itemsize 42
                extent refs 2 gen 1374196 flags 258
                tree block backref root 23480
                shared block backref parent 2405081251840
        item 107 key (2994741805056 169 0) itemoff 11765 itemsize 33
                extent refs 1 gen 1389525 flags 2
                tree block backref root 2069
        item 108 key (2994741821440 169 0) itemoff 11723 itemsize 42
                extent refs 2 gen 1414985 flags 2
                tree block backref root 23268
                shared block backref parent 4850630082560
        item 109 key (2994741837824 169 0) itemoff 11690 itemsize 33
                extent refs 1 gen 1389730 flags 2
                tree block backref root 1429
        item 110 key (2994741854208 169 0) itemoff 11648 itemsize 42
                extent refs 2 gen 1374196 flags 258
                tree block backref root 23480
                shared block backref parent 2405081251840
        item 111 key (2994741870592 169 0) itemoff 11615 itemsize 33
                extent refs 1 gen 1389730 flags 2
                tree block backref root 1429
        item 112 key (2994741886976 169 0) itemoff 11573 itemsize 42
                extent refs 2 gen 1417199 flags 2
                tree block backref root 23268
                shared block backref parent 5168957800448
        item 113 key (2994741903360 169 0) itemoff 11540 itemsize 33
                extent refs 1 gen 1389525 flags 2
                tree block backref root 2069
        item 114 key (2994741919744 169 0) itemoff 11507 itemsize 33
                extent refs 1 gen 1389525 flags 2
                tree block backref root 2069
        item 115 key (2994741936128 169 0) itemoff 11474 itemsize 33
                extent refs 1 gen 1401319 flags 258
                shared block backref parent 2404955914240
        item 116 key (2994741952512 169 0) itemoff 11441 itemsize 33
                extent refs 1 gen 1401319 flags 258
                shared block backref parent 2404955914240
        item 117 key (2994741968896 169 0) itemoff 11408 itemsize 33
                extent refs 1 gen 1389730 flags 2
                tree block backref root 1429
        item 118 key (2994741985280 169 0) itemoff 11375 itemsize 33
                extent refs 1 gen 1414514 flags 2
                tree block backref root 23268
        item 119 key (2994742001664 169 0) itemoff 11342 itemsize 33
                extent refs 1 gen 827339 flags 258
                shared block backref parent 4037910560768
        item 120 key (2994742018048 169 0) itemoff 11309 itemsize 33
                extent refs 1 gen 1389525 flags 2
                tree block backref root 2069
------------[ cut here ]------------
WARNING: CPU: 0 PID: 14133 at fs/btrfs/extent-tree.c:1150
btrfs_get_extent_inline_ref_type+0xcb/0xe0 [btrfs]
eb 2994891669504(tree block) invalid extent inline ref type 0
Modules linked in: veth xt_nat ipt_MASQUERADE nf_nat_masquerade_ipv4
xt_addrtype br_netfilter nf_conntrack_netbios_ns
nf_conntrack_broadcast nf_conntrack_ftp xt_CT ip6t_rpfilter
ip6t_REJECT nf_reject_ipv6 ip_set nfnetlink ebtable_nat ebtable_broute
bridge stp llc ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6
nf_nat_ipv6 ip6table_mangle ip6table_raw ip6table_security iptable_nat
nf_nat_ipv4 nf_nat iptable_mangle iptable_raw iptable_security
ebtable_filter ebtables nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack
nf_conntrack libcrc32c ip6table_filter ip6_tables intel_powerclamp
coretemp kvm_intel kvm snd_hda_codec_realtek snd_hda_codec_generic
irqbypass snd_hda_intel intel_cstate snd_hda_codec intel_uncore ppdev
snd_hda_core snd_hwdep iTCO_wdt iTCO_vendor_support mei_wdt gpio_ich
snd_seq
 snd_seq_device snd_pcm snd_timer snd soundcore tpm_infineon mei_me
mei acpi_cpufreq tpm_tis parport_pc parport i2c_i801 tpm_tis_core
shpchp tpm lpc_ich nfsd auth_rpcgss nfs_acl lockd grace sunrpc
binfmt_misc btrfs hid_logitech_hidpp xor i915 raid6_pq crc32c_intel
video i2c_algo_bit drm_kms_helper serio_raw drm hid_logitech_dj uas
usb_storage r8169 mii
CPU: 0 PID: 14133 Comm: btrfs Tainted: G        W
4.11.3-200.local.btrfs_patched.fc25.x86_64 #1
Hardware name: MSI MS-7636/H55M-P31(MS-7636)   , BIOS V1.9 09/14/2010
Call Trace:
 dump_stack+0x63/0x86
 __warn+0xcb/0xf0
 warn_slowpath_fmt+0x5a/0x80
 btrfs_get_extent_inline_ref_type+0xcb/0xe0 [btrfs]
 scrub_stripe+0x733/0x1170 [btrfs]
 scrub_chunk+0x102/0x140 [btrfs]
 ? scrub_chunk+0x102/0x140 [btrfs]
 scrub_enumerate_chunks+0x300/0x680 [btrfs]
 ? wake_atomic_t_function+0x60/0x70
 btrfs_scrub_dev+0x213/0x540 [btrfs]
 ? __mnt_want_write+0x56/0x60
 btrfs_ioctl+0x1351/0x2470 [btrfs]
 do_vfs_ioctl+0xa3/0x5f0
 ? do_vfs_ioctl+0xa3/0x5f0
 ? security_file_ioctl+0x43/0x60
 SyS_ioctl+0x79/0x90
 do_syscall_64+0x67/0x180
 entry_SYSCALL64_slow_path+0x25/0x25
RIP: 0033:0x7fa688cc4787
RSP: 002b:00007fa6873c2d58 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00005572d3db7190 RCX: 00007fa688cc4787
RDX: 00005572d3db7190 RSI: 00000000c400941b RDI: 0000000000000003
RBP: 0000000000000000 R08: 00007fa6873c3700 R09: 0000000000000000
R10: 00007fa6873c3700 R11: 0000000000000246 R12: 00007fa6873c3500
R13: 00007ffc22fb28ef R14: 00007fa6873c39c0 R15: 00007fa6873c3700
---[ end trace 70deff6b302d4409 ]---
BTRFS error (device sdb1): scrub: extent 2994741510144(0x2b944810000)
has an invalid extent inline ref type, ignored.
BTRFS info (device sdb1): leaf 2994891669504 total ptrs 121 free space 8284
        item 0 key (2994739920896 169 0) itemoff 16250 itemsize 33
                extent refs 1 gen 833513 flags 258
                shared block backref parent 4026278117376
        item 1 key (2994739937280 169 0) itemoff 16217 itemsize 33
                extent refs 1 gen 1389730 flags 2
                tree block backref root 1429
        item 2 key (2994739953664 169 0) itemoff 16184 itemsize 33
                extent refs 1 gen 1389730 flags 2
                tree block backref root 1429
        item 3 key (2994739970048 169 0) itemoff 16151 itemsize 33
                extent refs 1 gen 1417250 flags 2
                tree block backref root 1451
        item 4 key (2994739986432 169 0) itemoff 16118 itemsize 33
                extent refs 1 gen 826970 flags 2
                tree block backref root 7
        item 5 key (2994740002816 169 0) itemoff 16085 itemsize 33
                extent refs 1 gen 983344 flags 2
                tree block backref root 7
        item 6 key (2994740019200 169 0) itemoff 16052 itemsize 33
                extent refs 1 gen 1389730 flags 2
                tree block backref root 1429
        item 7 key (2994740035584 169 0) itemoff 16019 itemsize 33
                extent refs 1 gen 1389525 flags 2
                tree block backref root 2069
        item 8 key (2994740051968 169 0) itemoff 15986 itemsize 33
                extent refs 1 gen 1389525 flags 2
                tree block backref root 2069
        item 9 key (2994740068352 169 0) itemoff 15953 itemsize 33
                extent refs 1 gen 826970 flags 2
                tree block backref root 7
        item 10 key (2994740084736 169 0) itemoff 15920 itemsize 33
                extent refs 1 gen 1389525 flags 2
                tree block backref root 2069
        item 11 key (2994740101120 169 0) itemoff 15887 itemsize 33
                extent refs 1 gen 1389525 flags 2
                tree block backref root 2069
        item 12 key (2994740117504 169 0) itemoff 15854 itemsize 33
                extent refs 1 gen 1414389 flags 258
                shared block backref parent 4632584617984
        item 13 key (2994740133888 169 0) itemoff 15821 itemsize 33
                extent refs 1 gen 1417250 flags 2
                tree block backref root 1451
        item 14 key (2994740150272 169 0) itemoff 15788 itemsize 33
                extent refs 1 gen 826970 flags 2
                tree block backref root 7
        item 15 key (2994740166656 169 0) itemoff 15755 itemsize 33
                extent refs 1 gen 1389730 flags 2
                tree block backref root 1429
        item 16 key (2994740183040 169 0) itemoff 15722 itemsize 33
                extent refs 1 gen 1389525 flags 2
                tree block backref root 2069
        item 17 key (2994740199424 169 0) itemoff 15689 itemsize 33
                extent refs 1 gen 1417250 flags 2
                tree block backref root 1451
        item 18 key (2994740215808 169 0) itemoff 15647 itemsize 42
                extent refs 2 gen 1406394 flags 258
                shared block backref parent 4633401622528
                shared block backref parent 4627188744192
        item 19 key (2994740232192 169 0) itemoff 15614 itemsize 33
                extent refs 1 gen 833513 flags 258
                shared block backref parent 4026278150144
        item 20 key (2994740248576 169 0) itemoff 15581 itemsize 33
                extent refs 1 gen 1389730 flags 2
                tree block backref root 1429
        item 21 key (2994740264960 169 0) itemoff 15548 itemsize 33
                extent refs 1 gen 1389525 flags 2
                tree block backref root 2069
        item 22 key (2994740281344 169 0) itemoff 15515 itemsize 33
                extent refs 1 gen 1389525 flags 2
                tree block backref root 2069
        item 23 key (2994740297728 169 0) itemoff 15482 itemsize 33
                extent refs 1 gen 1389525 flags 2
                tree block backref root 2069
        item 24 key (2994740314112 169 0) itemoff 15440 itemsize 42
                extent refs 2 gen 1406394 flags 258
                shared block backref parent 4633401622528
                shared block backref parent 4627188744192
        item 25 key (2994740330496 169 0) itemoff 15407 itemsize 33
                extent refs 1 gen 827339 flags 258
                shared block backref parent 4037502517248
        item 26 key (2994740346880 169 0) itemoff 15374 itemsize 33
                extent refs 1 gen 1417250 flags 2
                tree block backref root 1451
        item 27 key (2994740363264 169 0) itemoff 15332 itemsize 42
                extent refs 2 gen 1322391 flags 258
                shared block backref parent 4537765806080
                shared block backref parent 4537190842368
        item 28 key (2994740379648 169 0) itemoff 15290 itemsize 42
                extent refs 2 gen 1406394 flags 258
                shared block backref parent 4633401622528
                shared block backref parent 4627188744192
        item 29 key (2994740396032 169 0) itemoff 15230 itemsize 60
                extent refs 4 gen 826464 flags 258
                shared block backref parent 4037394251776
                shared block backref parent 4037222711296
                shared block backref parent 3213570605056
                shared block backref parent 3213569130496
        item 30 key (2994740412416 169 0) itemoff 15179 itemsize 51
                extent refs 3 gen 827339 flags 258
                shared block backref parent 3470248460288
                shared block backref parent 3470248443904
                shared block backref parent 3470248329216
        item 31 key (2994740428800 169 0) itemoff 15146 itemsize 33
                extent refs 1 gen 1389525 flags 2
                tree block backref root 2069
        item 32 key (2994740461568 169 0) itemoff 15113 itemsize 33
                extent refs 1 gen 1389525 flags 2
                tree block backref root 2069
        item 33 key (2994740477952 169 0) itemoff 15080 itemsize 33
                extent refs 1 gen 1417250 flags 2
                tree block backref root 1451
        item 34 key (2994740510720 169 0) itemoff 15038 itemsize 42
                extent refs 2 gen 1414985 flags 2
                tree block backref root 23268
                shared block backref parent 4633738919936
        item 35 key (2994740527104 169 0) itemoff 15005 itemsize 33
                extent refs 1 gen 1262619 flags 258
                shared block backref parent 2994735022080
        item 36 key (2994740543488 169 0) itemoff 14972 itemsize 33
                extent refs 1 gen 1414571 flags 2
                tree block backref root 23268
        item 37 key (2994740559872 169 0) itemoff 14939 itemsize 33
                extent refs 1 gen 1414571 flags 2
                tree block backref root 23269
        item 38 key (2994740576256 169 0) itemoff 14870 itemsize 69
                extent refs 5 gen 1417199 flags 2
                tree block backref root 23268
                shared block backref parent 4634987790336
                shared block backref parent 4630838362112
                shared block backref parent 4630064791552
                shared block backref parent 4628769914880
        item 39 key (2994740592640 169 0) itemoff 14828 itemsize 42
                extent refs 2 gen 827339 flags 258
                shared block backref parent 4197157306368
                shared block backref parent 4197157257216
        item 40 key (2994740609024 169 0) itemoff 14795 itemsize 33
                extent refs 1 gen 833513 flags 258
                shared block backref parent 4026278117376
        item 41 key (2994740625408 169 0) itemoff 14717 itemsize 78
                extent refs 6 gen 831506 flags 258
                shared block backref parent 4240500473856
                shared block backref parent 4239944220672
                shared block backref parent 4197485166592
                shared block backref parent 4197485150208
                shared block backref parent 4197467586560
                shared block backref parent 4001359904768
        item 42 key (2994740641792 169 0) itemoff 14684 itemsize 33
                extent refs 1 gen 833513 flags 258
                shared block backref parent 4026278150144
        item 43 key (2994740674560 169 0) itemoff 14651 itemsize 33
                extent refs 1 gen 1264652 flags 258
                shared block backref parent 4196919754752
        item 44 key (2994740690944 169 0) itemoff 14591 itemsize 60
                extent refs 4 gen 827339 flags 258
                shared block backref parent 4240327262208
                shared block backref parent 4240083386368
                shared block backref parent 4197838585856
                shared block backref parent 4026387365888
        item 45 key (2994740707328 169 0) itemoff 14558 itemsize 33
                extent refs 1 gen 1389525 flags 2
                tree block backref root 2069
        item 46 key (2994740723712 169 0) itemoff 14525 itemsize 33
                extent refs 1 gen 1400556 flags 258
                shared block backref parent 4636817702912
        item 47 key (2994740740096 169 0) itemoff 14492 itemsize 33
                extent refs 1 gen 833513 flags 258
                shared block backref parent 4026278117376
        item 48 key (2994740756480 169 0) itemoff 14459 itemsize 33
                extent refs 1 gen 1262619 flags 258
                shared block backref parent 4197476712448
        item 49 key (2994740772864 169 0) itemoff 14165 itemsize 294
                extent refs 30 gen 826464 flags 258
                tree block backref root 23269
                tree block backref root 22154
                tree block backref root 599
                shared block backref parent 4851402244096
                shared block backref parent 4635304804352
                shared block backref parent 4628579106816
                shared block backref parent 4628285816832
                shared block backref parent 4627642433536
                shared block backref parent 4537789579264
                shared block backref parent 4537419677696
                shared block backref parent 4537241993216
                shared block backref parent 4240853876736
                shared block backref parent 4240792502272
                shared block backref parent 4240286760960
                shared block backref parent 4197594628096
                shared block backref parent 4197489754112
                shared block backref parent 4197489377280
                shared block backref parent 4197489328128
                shared block backref parent 4197476712448
                shared block backref parent 4197107908608
                shared block backref parent 4001305739264
                shared block backref parent 4000873627648
                shared block backref parent 3918606139392
                shared block backref parent 3470774747136
                shared block backref parent 3213987184640
                shared block backref parent 3213552025600
                shared block backref parent 3213531414528
                shared block backref parent 2994976833536
                shared block backref parent 2994213994496
                shared block backref parent 2405100175360
        item 50 key (2994740789248 169 0) itemoff 13952 itemsize 213
                extent refs 21 gen 827339 flags 258
                tree block backref root 22154
                tree block backref root 599
                shared block backref parent 4627601620992
                shared block backref parent 4537810042880
                shared block backref parent 4537500680192
                shared block backref parent 4537357205504
                shared block backref parent 4537200869376
                shared block backref parent 4240320200704
                shared block backref parent 4240180199424
                shared block backref parent 4197591351296
                shared block backref parent 4197591269376
                shared block backref parent 4197324750848
                shared block backref parent 4196935434240
                shared block backref parent 4037456265216
                shared block backref parent 4027117404160
                shared block backref parent 3379070582784
                shared block backref parent 2993861459968
                shared block backref parent 2993423548416
                shared block backref parent 2941186490368
                shared block backref parent 2405627346944
                shared block backref parent 2405178884096
        item 51 key (2994740805632 169 0) itemoff 13919 itemsize 33
                extent refs 1 gen 833513 flags 258
                shared block backref parent 4026278150144
        item 52 key (2994740822016 169 0) itemoff 13886 itemsize 33
                extent refs 1 gen 832548 flags 2
                tree block backref root 7
        item 53 key (2994740838400 169 0) itemoff 13844 itemsize 42
                extent refs 2 gen 827339 flags 258
                shared block backref parent 4037502517248
                shared block backref parent 3918522187776
        item 54 key (2994740854784 169 0) itemoff 13811 itemsize 33
                extent refs 1 gen 1414662 flags 2
                tree block backref root 23268
        item 55 key (2994740887552 169 0) itemoff 13778 itemsize 33
                extent refs 1 gen 832548 flags 2
                tree block backref root 7
        item 56 key (2994740903936 169 0) itemoff 13736 itemsize 42
                extent refs 2 gen 827339 flags 258
                shared block backref parent 4037502517248
                shared block backref parent 3918522187776
        item 57 key (2994740920320 169 0) itemoff 13703 itemsize 33
                extent refs 1 gen 828860 flags 258
                shared block backref parent 4026247200768
        item 58 key (2994740936704 169 0) itemoff 13670 itemsize 33
                extent refs 1 gen 832548 flags 2
                tree block backref root 7
        item 59 key (2994740953088 169 0) itemoff 13628 itemsize 42
                extent refs 2 gen 1381556 flags 258
                shared block backref parent 3213982466048
                shared block backref parent 2994764578816
        item 60 key (2994740969472 169 0) itemoff 13595 itemsize 33
                extent refs 1 gen 1388773 flags 258
                shared block backref parent 4629308555264
        item 61 key (2994741002240 169 0) itemoff 13562 itemsize 33
                extent refs 1 gen 833647 flags 2
                tree block backref root 7
        item 62 key (2994741018624 169 0) itemoff 13529 itemsize 33
                extent refs 1 gen 828860 flags 258
                shared block backref parent 4026355630080
        item 63 key (2994741035008 169 0) itemoff 13460 itemsize 69
                extent refs 5 gen 1417199 flags 2
                tree block backref root 23268
                shared block backref parent 4634987790336
                shared block backref parent 4630838362112
                shared block backref parent 4630064791552
                shared block backref parent 4628769914880
        item 64 key (2994741051392 169 0) itemoff 13427 itemsize 33
                extent refs 1 gen 1417199 flags 2
                tree block backref root 2
        item 65 key (2994741067776 169 0) itemoff 13394 itemsize 33
                extent refs 1 gen 1414571 flags 2
                tree block backref root 23268
        item 66 key (2994741084160 169 0) itemoff 13343 itemsize 51
                extent refs 3 gen 1414985 flags 2
                tree block backref root 23268
                shared block backref parent 4850632065024
                shared block backref parent 4630524002304
        item 67 key (2994741100544 169 0) itemoff 13310 itemsize 33
                extent refs 1 gen 1401319 flags 258
                shared block backref parent 2404955914240
        item 68 key (2994741116928 169 0) itemoff 13277 itemsize 33
                extent refs 1 gen 833513 flags 258
                shared block backref parent 4026278117376
        item 69 key (2994741133312 169 0) itemoff 13244 itemsize 33
                extent refs 1 gen 1389730 flags 2
                tree block backref root 1429
        item 70 key (2994741149696 169 0) itemoff 13211 itemsize 33
                extent refs 1 gen 833513 flags 258
                shared block backref parent 4026278150144
        item 71 key (2994741182464 169 0) itemoff 13178 itemsize 33
                extent refs 1 gen 1400556 flags 258
                shared block backref parent 4636825878528
        item 72 key (2994741198848 169 0) itemoff 13145 itemsize 33
                extent refs 1 gen 1372535 flags 2
                tree block backref root 1577
        item 73 key (2994741215232 169 0) itemoff 13112 itemsize 33
                extent refs 1 gen 1417199 flags 2
                tree block backref root 2
        item 74 key (2994741231616 169 0) itemoff 13079 itemsize 33
                extent refs 1 gen 1400556 flags 258
                shared block backref parent 4636824109056
        item 75 key (2994741248000 169 0) itemoff 13046 itemsize 33
                extent refs 1 gen 1263596 flags 258
                shared block backref parent 4196936613888
        item 76 key (2994741264384 169 0) itemoff 13013 itemsize 33
                extent refs 1 gen 1389730 flags 2
                tree block backref root 1429
        item 77 key (2994741280768 169 0) itemoff 12980 itemsize 33
                extent refs 1 gen 1389730 flags 2
                tree block backref root 1429
        item 78 key (2994741297152 169 0) itemoff 12947 itemsize 33
                extent refs 1 gen 1389730 flags 2
                tree block backref root 1429
        item 79 key (2994741313536 169 0) itemoff 12914 itemsize 33
                extent refs 1 gen 1389730 flags 2
                tree block backref root 1429
        item 80 key (2994741329920 169 0) itemoff 12746 itemsize 168
                extent refs 16 gen 827339 flags 258
                tree block backref root 600
                shared block backref parent 4628782678016
                shared block backref parent 4537392381952
                shared block backref parent 4537253691392
                shared block backref parent 4197723029504
                shared block backref parent 4197274419200
                shared block backref parent 4197047074816
                shared block backref parent 4037851742208
                shared block backref parent 4000956743680
                shared block backref parent 4000687423488
                shared block backref parent 4000453361664
                shared block backref parent 3918531346432
                shared block backref parent 3918469185536
                shared block backref parent 3213947092992
                shared block backref parent 2993295720448
                shared block backref parent 2477789478912
        item 81 key (2994741346304 169 0) itemoff 12713 itemsize 33
                extent refs 1 gen 1389730 flags 2
                tree block backref root 1429
        item 82 key (2994741362688 169 0) itemoff 12680 itemsize 33
                extent refs 1 gen 1389730 flags 2
                tree block backref root 1429
        item 83 key (2994741379072 169 0) itemoff 12647 itemsize 33
                extent refs 1 gen 1389730 flags 2
                tree block backref root 1429
        item 84 key (2994741395456 169 0) itemoff 12614 itemsize 33
                extent refs 1 gen 1389683 flags 2
                tree block backref root 3095
        item 85 key (2994741411840 169 0) itemoff 12581 itemsize 33
                extent refs 1 gen 1389730 flags 2
                tree block backref root 1429
        item 86 key (2994741428224 169 0) itemoff 12548 itemsize 33
                extent refs 1 gen 1389730 flags 2
                tree block backref root 1429
        item 87 key (2994741444608 169 0) itemoff 12515 itemsize 33
                extent refs 1 gen 1401319 flags 258
                shared block backref parent 2404955914240
        item 88 key (2994741460992 169 0) itemoff 12482 itemsize 33
                extent refs 1 gen 1417250 flags 2
                tree block backref root 1451
        item 89 key (2994741477376 169 0) itemoff 12404 itemsize 78
                extent refs 6 gen 827339 flags 258
                shared block backref parent 4197954289664
                shared block backref parent 4197954256896
                shared block backref parent 4197577523200
                shared block backref parent 4197571641344
                shared block backref parent 4000654016512
                shared block backref parent 3917758775296
        item 90 key (2994741493760 169 0) itemoff 12371 itemsize 33
                extent refs 811139072 gen 246284288 flags 0
                tree block backref root 1429
        item 91 key (2994741510144 169 0) itemoff 12338 itemsize 33
                extent refs 0 gen 0 flags 0
BTRFS error (device sdb1): extent 2994891669504 has invalid ref type 0
        item 92 key (2994741559296 169 0) itemoff 12305 itemsize 33
                extent refs 1 gen 1389525 flags 1578675552460472322
BTRFS error (device sdb1): extent 2994891669504 has invalid ref type 0
        item 93 key (2994741575680 169 0) itemoff 12272 itemsize 33
                extent refs 1 gen 1389525 flags 2
                tree block backref root 2069
        item 94 key (2994741592064 169 0) itemoff 12230 itemsize 42
                extent refs 2 gen 1414178 flags 258
                shared block backref parent 2995019202560
                shared block backref parent 2993213603840
        item 95 key (2994741608448 169 0) itemoff 12197 itemsize 33
                extent refs 1 gen 1322391 flags 258
                shared block backref parent 2404909006848
        item 96 key (2994741624832 169 0) itemoff 12164 itemsize 33
                extent refs 1 gen 1389525 flags 2
                tree block backref root 2069
        item 97 key (2994741641216 169 0) itemoff 12131 itemsize 33
                extent refs 1 gen 1389525 flags 2
                tree block backref root 2069
        item 98 key (2994741657600 169 0) itemoff 12089 itemsize 42
                extent refs 2 gen 1417199 flags 2
                tree block backref root 23268
                shared block backref parent 5168957800448
        item 99 key (2994741673984 169 0) itemoff 12056 itemsize 33
                extent refs 1 gen 1389730 flags 2
                tree block backref root 1429
        item 100 key (2994741690368 169 0) itemoff 12014 itemsize 42
                extent refs 2 gen 1322391 flags 258
                shared block backref parent 4537776128000
                shared block backref parent 4537233702912
        item 101 key (2994741706752 169 0) itemoff 11972 itemsize 42
                extent refs 2 gen 1417199 flags 2
                tree block backref root 23268
                shared block backref parent 5168957800448
        item 102 key (2994741723136 169 0) itemoff 11939 itemsize 33
                extent refs 1 gen 1389525 flags 2
                tree block backref root 2069
        item 103 key (2994741739520 169 0) itemoff 11906 itemsize 33
                extent refs 1 gen 1389525 flags 2
                tree block backref root 2069
        item 104 key (2994741755904 169 0) itemoff 11873 itemsize 33
                extent refs 1 gen 1389525 flags 2
                tree block backref root 2069
        item 105 key (2994741772288 169 0) itemoff 11840 itemsize 33
                extent refs 1 gen 1389525 flags 2
                tree block backref root 2069
        item 106 key (2994741788672 169 0) itemoff 11798 itemsize 42
                extent refs 2 gen 1374196 flags 258
                tree block backref root 23480
                shared block backref parent 2405081251840
        item 107 key (2994741805056 169 0) itemoff 11765 itemsize 33
                extent refs 1 gen 1389525 flags 2
                tree block backref root 2069
        item 108 key (2994741821440 169 0) itemoff 11723 itemsize 42
                extent refs 2 gen 1414985 flags 2
                tree block backref root 23268
                shared block backref parent 4850630082560
        item 109 key (2994741837824 169 0) itemoff 11690 itemsize 33
                extent refs 1 gen 1389730 flags 2
                tree block backref root 1429
        item 110 key (2994741854208 169 0) itemoff 11648 itemsize 42
                extent refs 2 gen 1374196 flags 258
                tree block backref root 23480
                shared block backref parent 2405081251840
        item 111 key (2994741870592 169 0) itemoff 11615 itemsize 33
                extent refs 1 gen 1389730 flags 2
                tree block backref root 1429
        item 112 key (2994741886976 169 0) itemoff 11573 itemsize 42
                extent refs 2 gen 1417199 flags 2
                tree block backref root 23268
                shared block backref parent 5168957800448
        item 113 key (2994741903360 169 0) itemoff 11540 itemsize 33
                extent refs 1 gen 1389525 flags 2
                tree block backref root 2069
        item 114 key (2994741919744 169 0) itemoff 11507 itemsize 33
                extent refs 1 gen 1389525 flags 2
                tree block backref root 2069
        item 115 key (2994741936128 169 0) itemoff 11474 itemsize 33
                extent refs 1 gen 1401319 flags 258
                shared block backref parent 2404955914240
        item 116 key (2994741952512 169 0) itemoff 11441 itemsize 33
                extent refs 1 gen 1401319 flags 258
                shared block backref parent 2404955914240
        item 117 key (2994741968896 169 0) itemoff 11408 itemsize 33
                extent refs 1 gen 1389730 flags 2
                tree block backref root 1429
        item 118 key (2994741985280 169 0) itemoff 11375 itemsize 33
                extent refs 1 gen 1414514 flags 2
                tree block backref root 23268
        item 119 key (2994742001664 169 0) itemoff 11342 itemsize 33
                extent refs 1 gen 827339 flags 258
                shared block backref parent 4037910560768
        item 120 key (2994742018048 169 0) itemoff 11309 itemsize 33
                extent refs 1 gen 1389525 flags 2
                tree block backref root 2069
------------[ cut here ]------------
WARNING: CPU: 0 PID: 14133 at fs/btrfs/extent-tree.c:1150
btrfs_get_extent_inline_ref_type+0xcb/0xe0 [btrfs]
eb 2994891669504(tree block) invalid extent inline ref type 0
Modules linked in: veth xt_nat ipt_MASQUERADE nf_nat_masquerade_ipv4
xt_addrtype br_netfilter nf_conntrack_netbios_ns
nf_conntrack_broadcast nf_conntrack_ftp xt_CT ip6t_rpfilter
ip6t_REJECT nf_reject_ipv6 ip_set nfnetlink ebtable_nat ebtable_broute
bridge stp llc ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6
nf_nat_ipv6 ip6table_mangle ip6table_raw ip6table_security iptable_nat
nf_nat_ipv4 nf_nat iptable_mangle iptable_raw iptable_security
ebtable_filter ebtables nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack
nf_conntrack libcrc32c ip6table_filter ip6_tables intel_powerclamp
coretemp kvm_intel kvm snd_hda_codec_realtek snd_hda_codec_generic
irqbypass snd_hda_intel intel_cstate snd_hda_codec intel_uncore ppdev
snd_hda_core snd_hwdep iTCO_wdt iTCO_vendor_support mei_wdt gpio_ich
snd_seq
 snd_seq_device snd_pcm snd_timer snd soundcore tpm_infineon mei_me
mei acpi_cpufreq tpm_tis parport_pc parport i2c_i801 tpm_tis_core
shpchp tpm lpc_ich nfsd auth_rpcgss nfs_acl lockd grace sunrpc
binfmt_misc btrfs hid_logitech_hidpp xor i915 raid6_pq crc32c_intel
video i2c_algo_bit drm_kms_helper serio_raw drm hid_logitech_dj uas
usb_storage r8169 mii
CPU: 0 PID: 14133 Comm: btrfs Tainted: G        W
4.11.3-200.local.btrfs_patched.fc25.x86_64 #1
Hardware name: MSI MS-7636/H55M-P31(MS-7636)   , BIOS V1.9 09/14/2010
Call Trace:
 dump_stack+0x63/0x86
 __warn+0xcb/0xf0
 warn_slowpath_fmt+0x5a/0x80
 btrfs_get_extent_inline_ref_type+0xcb/0xe0 [btrfs]
 scrub_stripe+0x733/0x1170 [btrfs]
 scrub_chunk+0x102/0x140 [btrfs]
 ? scrub_chunk+0x102/0x140 [btrfs]
 scrub_enumerate_chunks+0x300/0x680 [btrfs]
 ? wake_atomic_t_function+0x60/0x70
 btrfs_scrub_dev+0x213/0x540 [btrfs]
 ? __mnt_want_write+0x56/0x60
 btrfs_ioctl+0x1351/0x2470 [btrfs]
 do_vfs_ioctl+0xa3/0x5f0
 ? do_vfs_ioctl+0xa3/0x5f0
 ? security_file_ioctl+0x43/0x60
 SyS_ioctl+0x79/0x90
 do_syscall_64+0x67/0x180
 entry_SYSCALL64_slow_path+0x25/0x25
RIP: 0033:0x7fa688cc4787
RSP: 002b:00007fa6873c2d58 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00005572d3db7190 RCX: 00007fa688cc4787
RDX: 00005572d3db7190 RSI: 00000000c400941b RDI: 0000000000000003
RBP: 0000000000000000 R08: 00007fa6873c3700 R09: 0000000000000000
R10: 00007fa6873c3700 R11: 0000000000000246 R12: 00007fa6873c3500
R13: 00007ffc22fb28ef R14: 00007fa6873c39c0 R15: 00007fa6873c3700
---[ end trace 70deff6b302d440a ]---
BTRFS error (device sdb1): scrub: extent 2994741559296(0x2b94481c000)
has an invalid extent inline ref type, ignored.
------------[ cut here ]------------
WARNING: CPU: 0 PID: 18938 at fs/btrfs/scrub.c:1804
scrub_bio_end_io_worker+0x32c/0x4e0 [btrfs]
Modules linked in: veth xt_nat ipt_MASQUERADE nf_nat_masquerade_ipv4
xt_addrtype br_netfilter nf_conntrack_netbios_ns
nf_conntrack_broadcast nf_conntrack_ftp xt_CT ip6t_rpfilter
ip6t_REJECT nf_reject_ipv6 ip_set nfnetlink ebtable_nat ebtable_broute
bridge stp llc ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6
nf_nat_ipv6 ip6table_mangle ip6table_raw ip6table_security iptable_nat
nf_nat_ipv4 nf_nat iptable_mangle iptable_raw iptable_security
ebtable_filter ebtables nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack
nf_conntrack libcrc32c ip6table_filter ip6_tables intel_powerclamp
coretemp kvm_intel kvm snd_hda_codec_realtek snd_hda_codec_generic
irqbypass snd_hda_intel intel_cstate snd_hda_codec intel_uncore ppdev
snd_hda_core snd_hwdep iTCO_wdt iTCO_vendor_support mei_wdt gpio_ich
snd_seq
 snd_seq_device snd_pcm snd_timer snd soundcore tpm_infineon mei_me
mei acpi_cpufreq tpm_tis parport_pc parport i2c_i801 tpm_tis_core
shpchp tpm lpc_ich nfsd auth_rpcgss nfs_acl lockd grace sunrpc
binfmt_misc btrfs hid_logitech_hidpp xor i915 raid6_pq crc32c_intel
video i2c_algo_bit drm_kms_helper serio_raw drm hid_logitech_dj uas
usb_storage r8169 mii
CPU: 0 PID: 18938 Comm: kworker/u16:3 Tainted: G        W
4.11.3-200.local.btrfs_patched.fc25.x86_64 #1
Hardware name: MSI MS-7636/H55M-P31(MS-7636)   , BIOS V1.9 09/14/2010
Workqueue: btrfs-scrub btrfs_scrub_helper [btrfs]
Call Trace:
 dump_stack+0x63/0x86
 __warn+0xcb/0xf0
 warn_slowpath_null+0x1d/0x20
 scrub_bio_end_io_worker+0x32c/0x4e0 [btrfs]
 ? set_next_entity+0xd9/0x220
 ? pick_next_task_fair+0x4dc/0x550
 ? __switch_to+0x227/0x460
 btrfs_scrubparity_helper+0xc0/0x2f0 [btrfs]
 btrfs_scrub_helper+0xe/0x10 [btrfs]
 process_one_work+0x197/0x450
 worker_thread+0x4e/0x4a0
 kthread+0x109/0x140
 ? process_one_work+0x450/0x450
 ? kthread_park+0x90/0x90
 ? do_syscall_64+0x67/0x180
 ret_from_fork+0x2c/0x40
---[ end trace 70deff6b302d440b ]---
------------[ cut here ]------------
WARNING: CPU: 0 PID: 18938 at fs/btrfs/scrub.c:1804
scrub_bio_end_io_worker+0x32c/0x4e0 [btrfs]
Modules linked in: veth xt_nat ipt_MASQUERADE nf_nat_masquerade_ipv4
xt_addrtype br_netfilter nf_conntrack_netbios_ns
nf_conntrack_broadcast nf_conntrack_ftp xt_CT ip6t_rpfilter
ip6t_REJECT nf_reject_ipv6 ip_set nfnetlink ebtable_nat ebtable_broute
bridge stp llc ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6
nf_nat_ipv6 ip6table_mangle ip6table_raw ip6table_security iptable_nat
nf_nat_ipv4 nf_nat iptable_mangle iptable_raw iptable_security
ebtable_filter ebtables nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack
nf_conntrack libcrc32c ip6table_filter ip6_tables intel_powerclamp
coretemp kvm_intel kvm snd_hda_codec_realtek snd_hda_codec_generic
irqbypass snd_hda_intel intel_cstate snd_hda_codec intel_uncore ppdev
snd_hda_core snd_hwdep iTCO_wdt iTCO_vendor_support mei_wdt gpio_ich
snd_seq
 snd_seq_device snd_pcm snd_timer snd soundcore tpm_infineon mei_me
mei acpi_cpufreq tpm_tis parport_pc parport i2c_i801 tpm_tis_core
shpchp tpm lpc_ich nfsd auth_rpcgss nfs_acl lockd grace sunrpc
binfmt_misc btrfs hid_logitech_hidpp xor i915 raid6_pq crc32c_intel
video i2c_algo_bit drm_kms_helper serio_raw drm hid_logitech_dj uas
usb_storage r8169 mii
CPU: 0 PID: 18938 Comm: kworker/u16:3 Tainted: G        W
4.11.3-200.local.btrfs_patched.fc25.x86_64 #1
Hardware name: MSI MS-7636/H55M-P31(MS-7636)   , BIOS V1.9 09/14/2010
Workqueue: btrfs-scrub btrfs_scrub_helper [btrfs]
Call Trace:
 dump_stack+0x63/0x86
 __warn+0xcb/0xf0
 warn_slowpath_null+0x1d/0x20
 scrub_bio_end_io_worker+0x32c/0x4e0 [btrfs]
 ? set_next_entity+0xd9/0x220
 ? pick_next_task_fair+0x4dc/0x550
 ? __switch_to+0x227/0x460
 btrfs_scrubparity_helper+0xc0/0x2f0 [btrfs]
 btrfs_scrub_helper+0xe/0x10 [btrfs]
 process_one_work+0x197/0x450
 worker_thread+0x4e/0x4a0
 kthread+0x109/0x140
 ? process_one_work+0x450/0x450
 ? kthread_park+0x90/0x90
 ? do_syscall_64+0x67/0x180
 ret_from_fork+0x2c/0x40
---[ end trace 70deff6b302d440c ]---
------------[ cut here ]------------
WARNING: CPU: 0 PID: 18938 at fs/btrfs/scrub.c:1804
scrub_bio_end_io_worker+0x32c/0x4e0 [btrfs]
Modules linked in: veth xt_nat ipt_MASQUERADE nf_nat_masquerade_ipv4
xt_addrtype br_netfilter nf_conntrack_netbios_ns
nf_conntrack_broadcast nf_conntrack_ftp xt_CT ip6t_rpfilter
ip6t_REJECT nf_reject_ipv6 ip_set nfnetlink ebtable_nat ebtable_broute
bridge stp llc ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6
nf_nat_ipv6 ip6table_mangle ip6table_raw ip6table_security iptable_nat
nf_nat_ipv4 nf_nat iptable_mangle iptable_raw iptable_security
ebtable_filter ebtables nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack
nf_conntrack libcrc32c ip6table_filter ip6_tables intel_powerclamp
coretemp kvm_intel kvm snd_hda_codec_realtek snd_hda_codec_generic
irqbypass snd_hda_intel intel_cstate snd_hda_codec intel_uncore ppdev
snd_hda_core snd_hwdep iTCO_wdt iTCO_vendor_support mei_wdt gpio_ich
snd_seq
 snd_seq_device snd_pcm snd_timer snd soundcore tpm_infineon mei_me
mei acpi_cpufreq tpm_tis parport_pc parport i2c_i801 tpm_tis_core
shpchp tpm lpc_ich nfsd auth_rpcgss nfs_acl lockd grace sunrpc
binfmt_misc btrfs hid_logitech_hidpp xor i915 raid6_pq crc32c_intel
video i2c_algo_bit drm_kms_helper serio_raw drm hid_logitech_dj uas
usb_storage r8169 mii
CPU: 0 PID: 18938 Comm: kworker/u16:3 Tainted: G        W
4.11.3-200.local.btrfs_patched.fc25.x86_64 #1
Hardware name: MSI MS-7636/H55M-P31(MS-7636)   , BIOS V1.9 09/14/2010
Workqueue: btrfs-scrub btrfs_scrub_helper [btrfs]
Call Trace:
 dump_stack+0x63/0x86
 __warn+0xcb/0xf0
 warn_slowpath_null+0x1d/0x20
 scrub_bio_end_io_worker+0x32c/0x4e0 [btrfs]
 ? set_next_entity+0xd9/0x220
 ? pick_next_task_fair+0x4dc/0x550
 ? __switch_to+0x227/0x460
 btrfs_scrubparity_helper+0xc0/0x2f0 [btrfs]
 btrfs_scrub_helper+0xe/0x10 [btrfs]
 process_one_work+0x197/0x450
 worker_thread+0x4e/0x4a0
 kthread+0x109/0x140
 ? process_one_work+0x450/0x450
 ? kthread_park+0x90/0x90
 ? do_syscall_64+0x67/0x180
 ret_from_fork+0x2c/0x40
---[ end trace 70deff6b302d440d ]---
------------[ cut here ]------------
WARNING: CPU: 0 PID: 18938 at fs/btrfs/scrub.c:1804
scrub_bio_end_io_worker+0x32c/0x4e0 [btrfs]
Modules linked in: veth xt_nat ipt_MASQUERADE nf_nat_masquerade_ipv4
xt_addrtype br_netfilter nf_conntrack_netbios_ns
nf_conntrack_broadcast nf_conntrack_ftp xt_CT ip6t_rpfilter
ip6t_REJECT nf_reject_ipv6 ip_set nfnetlink ebtable_nat ebtable_broute
bridge stp llc ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6
nf_nat_ipv6 ip6table_mangle ip6table_raw ip6table_security iptable_nat
nf_nat_ipv4 nf_nat iptable_mangle iptable_raw iptable_security
ebtable_filter ebtables nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack
nf_conntrack libcrc32c ip6table_filter ip6_tables intel_powerclamp
coretemp kvm_intel kvm snd_hda_codec_realtek snd_hda_codec_generic
irqbypass snd_hda_intel intel_cstate snd_hda_codec intel_uncore ppdev
snd_hda_core snd_hwdep iTCO_wdt iTCO_vendor_support mei_wdt gpio_ich
snd_seq
 snd_seq_device snd_pcm snd_timer snd soundcore tpm_infineon mei_me
mei acpi_cpufreq tpm_tis parport_pc parport i2c_i801 tpm_tis_core
shpchp tpm lpc_ich nfsd auth_rpcgss nfs_acl lockd grace sunrpc
binfmt_misc btrfs hid_logitech_hidpp xor i915 raid6_pq crc32c_intel
video i2c_algo_bit drm_kms_helper serio_raw drm hid_logitech_dj uas
usb_storage r8169 mii
CPU: 0 PID: 18938 Comm: kworker/u16:3 Tainted: G        W
4.11.3-200.local.btrfs_patched.fc25.x86_64 #1
Hardware name: MSI MS-7636/H55M-P31(MS-7636)   , BIOS V1.9 09/14/2010
Workqueue: btrfs-scrub btrfs_scrub_helper [btrfs]
Call Trace:
 dump_stack+0x63/0x86
 __warn+0xcb/0xf0
 warn_slowpath_null+0x1d/0x20
 scrub_bio_end_io_worker+0x32c/0x4e0 [btrfs]
 ? set_next_entity+0xd9/0x220
 ? pick_next_task_fair+0x4dc/0x550
 ? __switch_to+0x227/0x460
 btrfs_scrubparity_helper+0xc0/0x2f0 [btrfs]
 btrfs_scrub_helper+0xe/0x10 [btrfs]
 process_one_work+0x197/0x450
 worker_thread+0x4e/0x4a0
 kthread+0x109/0x140
 ? process_one_work+0x450/0x450
 ? kthread_park+0x90/0x90
 ? do_syscall_64+0x67/0x180
 ret_from_fork+0x2c/0x40
---[ end trace 70deff6b302d440e ]---

-- 
Ivan Sizov
