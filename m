Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:17722 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753375AbaKDO5Z (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 4 Nov 2014 09:57:25 -0500
Date: Tue, 4 Nov 2014 09:55:13 -0500
From: Chris Mason <clm@fb.com>
Subject: Re: Kernel crash during "btrfs device delete" on raid6 volume
To: Erik Berg <btrfs@slipsprogrammoer.no>
CC: <linux-btrfs@vger.kernel.org>, Mark Fasheh <mfasheh@suse.de>
Message-ID: <1415112914.25930.0@mail.thefacebook.com>
In-Reply-To: <m3ao9u$de7$1@ger.gmane.org>
References: <m3ao9u$de7$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 4, 2014 at 9:36 AM, Erik Berg <btrfs@slipsprogrammoer.no> 
wrote:
> Pulled the latest btrfs-progs from kdave (v3.17-12-gcafacda) and 
> using the latest linux release candidate (3.18.0-031800rc3-generic) 
> from canonical/ubuntu
> 
> btrfs fi show
> Label: none  uuid: 5c5fea06-0319-4e03-a42e-004e64aeed92
> 	Total devices 9 FS bytes used 10.91TiB
> 	devid    2 size 931.48GiB used 928.02GiB path /dev/sdc1
> 	devid    3 size 931.48GiB used 928.02GiB path /dev/sdd1
> 	devid    4 size 1.82TiB used 1.67TiB path /dev/sde1
> 	devid    5 size 2.73TiB used 2.28TiB path /dev/sdf1
> 	devid    6 size 3.64TiB used 2.73TiB path /dev/sdg1
> 	devid    7 size 3.64TiB used 2.73TiB path /dev/sdh1
> 	devid    8 size 931.46GiB used 655.90GiB path /dev/sdb1
> 	devid    9 size 3.64TiB used 2.73TiB path /dev/sdi1
> 	devid   10 size 3.64TiB used 1.79TiB path /dev/sdj1
> 
> btrfs fi df
> Data, RAID6: total=10.91TiB, used=10.90TiB
> System, RAID6: total=96.00MiB, used=800.00KiB
> Metadata, RAID6: total=13.23GiB, used=11.79GiB
> GlobalReserve, single: total=512.00MiB, used=0.00B
> 
> Trying to remove device sdb1, the kernel crashes after a minute or so.
> 
> [  597.576827] ------------[ cut here ]------------
> [  597.617519] kernel BUG at /home/apw/COD/linux/mm/slub.c:3334!
> [  597.668145] invalid opcode: 0000 [#1] SMP
> [  597.704410] Modules linked in: arc4 md4 ipt_MASQUERADE 
> nf_nat_masquerade_ipv4 iptable_nat nf_nat_ipv4 nf_nat 
> nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack ipt_REJECT 
> nf_reject_ipv4 xt_CHECKSUM iptable_mangle xt_tcpudp bridge stp llc 
> ip6table_filter ip6_tables iptable_filter ip_tables ebtable_nat 
> ebtables x_tables gpio_ich intel_rapl x86_pkg_temp_thermal 
> intel_powerclamp coretemp kvm_intel kvm crct10dif_pclmul crc32_pclmul 
> ghash_clmulni_intel cryptd serio_raw hpilo hpwdt 8250_fintek 
> acpi_power_meter ie31200_edac lpc_ich edac_core ipmi_si 
> ipmi_msghandler mac_hid lp parport nls_utf8 cifs fscache hid_generic 
> usbhid hid btrfs xor raid6_pq uas usb_storage tg3 ptp ahci psmouse 
> libahci pps_core hpsa
> [  598.268179] CPU: 1 PID: 129 Comm: kworker/u128:3 Not tainted 
> 3.18.0-031800rc3-generic #201411022335
> [  598.349925] Hardware name: HP ProLiant MicroServer Gen8, BIOS J06 
> 11/09/2013
> [  598.413231] Workqueue: writeback bdi_writeback_workfn 
> (flush-btrfs-2)
> [  598.471103] task: ffff8803f16a3c00 ti: ffff880036b70000 task.ti: 
> ffff880036b70000
> [  598.538393] RIP: 0010:[<ffffffff811c74fd>]  [<ffffffff811c74fd>] 
> kfree+0x16d/0x170
> [  598.606217] RSP: 0018:ffff880036b73528  EFLAGS: 00010246
> [  598.653844] RAX: 01ffff0000000000 RBX: ffff880036b735c8 RCX: 
> 0000000000000000
> [  598.717899] RDX: ffff8803743a6010 RSI: dead000000100100 RDI: 
> ffff880036b735c8
> [  598.781662] RBP: ffff880036b73558 R08: 0000000000000000 R09: 
> ffffea0000dadcc0
> [  598.846028] R10: 0000000000000001 R11: 0000000000000010 R12: 
> ffff8803f1e09800
> [  598.910713] R13: ffff8803ac757d40 R14: ffffffffc04fed0c R15: 
> ffff880036b735d8
> [  598.975333] FS:  0000000000000000(0000) GS:ffff88040b420000(0000) 
> knlGS:0000000000000000
> [  599.048512] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  599.100167] CR2: 00007fa9a3854024 CR3: 0000000001c16000 CR4: 
> 00000000001407e0
> [  599.165150] Stack:
> [  599.183305]  ffff8803f1e09800 00000dad07c20000 ffff8803f1e09800 
> ffff8803ac757d40
> [  599.249603]  ffff8803ac757d40 ffff880036b735d8 ffff880036b73618 
> ffffffffc04fed0c
> [  599.316306]  ffff8803f1b86b00 ffff880374338000 00000dad07dc0000 
> ffff880036b73638
> [  599.383404] Call Trace:
> [  599.405429]  [<ffffffffc04fed0c>] 
> btrfs_lookup_csums_range+0x2ac/0x4a0 [btrfs]

Not a new bug unfortunately, but since it is in the error handling 
people must not be hitting it often.  It's also not related to device 
replace.


        while (ret < 0 && !list_empty(&tmplist)) {
                sums = list_entry(&tmplist, struct btrfs_ordered_sum, 
list);
                list_del(&sums->list);
                kfree(sums);
        }

We're trying to call kfree on the on-stack list head.  I'm fixing it up 
here, thanks for posting the oops!

-chris



