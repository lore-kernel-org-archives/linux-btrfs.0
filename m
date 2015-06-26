Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:16277 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753421AbbFZCII (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Jun 2015 22:08:08 -0400
Subject: Re: btrfs partition converted from ext4 becomes read-only minutes
 after booting: WARNING: CPU: 2 PID: 2777 at ../fs/btrfs/super.c:260
 __btrfs_abort_transaction+0x4b/0x120
To: Robert Munteanu <robert.munteanu@gmail.com>, <linux-btrfs@vger.kernel.org>
References: <CAC8ULPYHuqsZN1Lm_2TxGMw7z6n=4zAprqYr9uoi=3kjoiSxQw@mail.gmail.com>
 <558CB0D4.8060401@cn.fujitsu.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <558CB404.8050300@cn.fujitsu.com>
Date: Fri, 26 Jun 2015 10:08:04 +0800
MIME-Version: 1.0
In-Reply-To: <558CB0D4.8060401@cn.fujitsu.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Qu Wenruo wrote on 2015/06/26 09:54 +0800:
>
>
> Robert Munteanu wrote on 2015/06/12 15:19 +0300:
>> Hi,
>>
>> I have converted my root ext4 partition to btrfs. I used an USB stick
>> to boot and used btrfs-convert.
>>
>> I also did a balance and defrag ( in that order ) , both when the fs
>> was mounted.
>>
>> After logging in to KDE I quickly get a read-only filesystem. I've
>> pasted the backtrace below
>>
>> Jun 11 23:13:08 mars kernel: WARNING: CPU: 2 PID: 2777 at
>> ../fs/btrfs/super.c:260 __btrfs_abort_transaction+0x4b/0x120 [btrfs]()
>> Jun 11 23:13:08 mars kernel: BTRFS: Transaction aborted (error -95)
>> Jun 11 23:13:08 mars kernel: Modules linked in: bnep bluetooth rfkill
>> fuse vboxpci(O) vboxnetadp(O) vboxnetflt(O) vboxdrv(O) af_packet
>> nf_log_ipv6 xt_pkttype nf_log_ip
>> v4 nf_log_common xt_LOG xt_limit ip6t_REJECT xt_tcpudp
>> nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_raw ipt_REJECT iptable_raw
>> xt_CT iptable_filter ip6table_mangle nf_con
>> ntrack_netbios_ns nf_conntrack_broadcast nf_conntrack_ipv4
>> nf_defrag_ipv4 ip_tables xt_conntrack nf_conntrack ip6table_filter
>> ip6_tables x_tables xfs libcrc32c snd_hda
>> _codec_hdmi raid1 md_mod gpio_ich ppdev iTCO_wdt iTCO_vendor_support
>> coretemp snd_hda_codec_realtek snd_hda_codec_generic kvm_intel
>> snd_hda_intel dm_mod kvm snd_hda_co
>> ntroller snd_hda_codec snd_hwdep serio_raw pcspkr snd_pcm i2c_i801
>> snd_seq joydev snd_seq_device snd_timer snd 8250_fintek parport_pc
>> parport acpi_cpufreq lpc_ich
>> Jun 11 23:13:08 mars kernel:  soundcore mfd_core shpchp processor
>> ata_generic btrfs hid_logitech_hidpp xor raid6_pq sr_mod cdrom
>> nvidia_uvm(PO) nvidia(PO) firewire_ohc
>> i firewire_core crc_itu_t uas usb_storage r8169 mii pata_jmicron
>> hid_logitech_dj drm button sg
>> Jun 11 23:13:08 mars kernel: CPU: 2 PID: 2777 Comm: kworker/u8:0
>> Tainted: P           O    4.0.4-3-desktop #1
>> Jun 11 23:13:08 mars kernel: Hardware name: Gigabyte Technology Co.,
>> Ltd. EP35-DS4/EP35-DS4, BIOS F6d 01/08/2009
>> Jun 11 23:13:08 mars kernel: Workqueue: btrfs-endio-write
>> btrfs_endio_write_helper [btrfs]
>> Jun 11 23:13:08 mars kernel:  0000000000000000 ffffffffa0a92832
>> ffffffff8167c4aa ffff880128513ca8
>> Jun 11 23:13:08 mars kernel:  ffffffff81063bb1 ffff880031929d28
>> ffff880221e71800 00000000ffffffa1
>> Jun 11 23:13:08 mars kernel:  ffffffffa0a914e0 0000000000000b50
>> ffffffff81063c2a ffffffffa0a95928
>> Jun 11 23:13:08 mars kernel: Call Trace:
>> Jun 11 23:13:08 mars kernel:  [<ffffffff8100574c>] dump_trace+0x8c/0x340
>> Jun 11 23:13:08 mars kernel:  [<ffffffff81005aa3>]
>> show_stack_log_lvl+0xa3/0x190
>> Jun 11 23:13:08 mars kernel:  [<ffffffff81007201>] show_stack+0x21/0x50
>> Jun 11 23:13:08 mars kernel:  [<ffffffff8167c4aa>] dump_stack+0x47/0x67
>> Jun 11 23:13:08 mars kernel:  [<ffffffff81063bb1>]
>> warn_slowpath_common+0x81/0xb0
>> Jun 11 23:13:08 mars kernel:  [<ffffffff81063c2a>]
>> warn_slowpath_fmt+0x4a/0x50
>> Jun 11 23:13:08 mars kernel:  [<ffffffffa09e598b>]
>> __btrfs_abort_transaction+0x4b/0x120 [btrfs]
>> Jun 11 23:13:08 mars kernel:  [<ffffffffa0a1d18a>]
>> btrfs_finish_ordered_io+0x5aa/0x620 [btrfs]
>> Jun 11 23:13:08 mars kernel:  [<ffffffffa0a43253>]
>> normal_work_helper+0xc3/0x320 [btrfs]
>> Jun 11 23:13:08 mars kernel:  [<ffffffff8107bcf2>]
>> process_one_work+0x142/0x420
>> Jun 11 23:13:08 mars kernel:  [<ffffffff8107c0e4>]
>> worker_thread+0x114/0x460
>> Jun 11 23:13:08 mars kernel:  [<ffffffff81081261>] kthread+0xc1/0xe0
>> Jun 11 23:13:08 mars kernel:  [<ffffffff81682d58>]
>> ret_from_fork+0x58/0x90
>> Jun 11 23:13:08 mars kernel: ---[ end trace 4c4eb7d6e98afa91 ]---
>> Jun 11 23:13:08 mars kernel: BTRFS: error (device sda1) in
>> btrfs_finish_ordered_io:2896: errno=-95 unknown
>
> IIRC some one in the mail-list has reported the same bug.
> Still not sure the root cause but seems highly related to converted fs.
>
> It would be much better if you have a clue to trigger the bug.
> Like read/write which file(s) may cause the bug.
>
> If it's OK for you, please upload the btrfs-debug-tree output.
> WARNING: This output will not contain any data but all your filename/dir
> name.
>
> My first guess is some btrfs codes can't handle the special extent
> converted from ext* well, but still quite hard to say even the
> errno(EOPNOTSUPP) is quite unique and easy to find the source.... :(
>
> Thanks,
> Qu

A quite code search leads me to inline extent.

So, if you still have the original ext* image,
would you please try revert to ext* and then convert it to btrfs again?

But this time, please convert with --no-inline option, and see if this 
remove the problem.

Thanks,
Qu
>
>> Jun 11 23:13:08 mars kernel: BTRFS info (device sda1): forced readonly
>>
>> Some diagnostic info:
>>
>> - btrfs scrub reports no errors
>> - on the host machine I'm running btrfs v4.0+20150429 and kernel
>> 4.0.4-3-desktop
>> - on the live medium, used to run btrfs-convert, I was running btrfs
>> v4.0+20150429 and kernel 4.0.3-1-default
>>
>> # btrfs fi show
>> Label: none  uuid: 54dea125-74cd-4bb2-86a2-f7bc645b76cf
>>          Total devices 1 FS bytes used 90.22GiB
>>          devid    1 size 223.57GiB used 92.03GiB path /dev/sda1
>>
>> btrfs-progs v4.0+20150429
>>
>> # btrfs fi df /
>> Data, single: total=89.00GiB, used=88.17GiB
>> System, single: total=32.00MiB, used=16.00KiB
>> Metadata, single: total=3.00GiB, used=2.05GiB
>> GlobalReserve, single: total=512.00MiB, used=0.00B
>>
>> Is there a way out? I still have the old ext4 image and can revert,
>> but I'm keeping the btrfs one for now, in case I can extract some
>> useful debugging information from it.
>>
>> Thanks,
>>
>> Robert
>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
