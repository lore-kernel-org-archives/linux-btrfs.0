Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:41435 "EHLO
        mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750951AbeAUUdF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 21 Jan 2018 15:33:05 -0500
Received: by mail-oi0-f41.google.com with SMTP id m83so2149751oik.8
        for <linux-btrfs@vger.kernel.org>; Sun, 21 Jan 2018 12:33:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <c0eee716-6210-eb54-89b5-e2c330117e82@gmx.com>
References: <CAKxU2N_4A_bC7xKEhvRTu0+H3Bgm58hvnFx-bLSK39WH0BtWEg@mail.gmail.com>
 <c0eee716-6210-eb54-89b5-e2c330117e82@gmx.com>
From: Rosen Penev <rosenp@gmail.com>
Date: Sun, 21 Jan 2018 12:33:04 -0800
Message-ID: <CAKxU2N_jBRfg=TqHx041v28uRRh_4+zTVeWuQ+5o9RM+7QkYnw@mail.gmail.com>
Subject: Re: btrfs volume corrupt. btrfs-progs bug or need to rebuild volume?
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jan 21, 2018 at 1:53 AM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>
>
> On 2018年01月20日 05:45, Rosen Penev wrote:
>> v2: Add proper subject
>>
>> I've been playing around with a specific kernel on a specific device
>> trying to figure out why btrfs keeps throwing csum errors after ~15
>> hours. I've almost nailed it down to some specific CONFIG option in
>> the kernel, possibly related to IRQs.
>
> According to the hostname, it seems to be LEDE (or should be called
> OpenWRT soon?).
> Using btrfs in embedded environment is really interesting to see.
>
The issue that was causing the corruption seems to have been fixed in
.75 of 4.9. The particular device is using router hardware (mt7621)
except instead of using the pcie lanes for wireless controllers, it
has Asmedia SATA controllers. Slow but seems to work.
>>
>> Anyway, I managed to get my btrfs RAID5 array corrupted to the point
>> where it will just mount to read-only mode. btrfs check doesn't seem
>> to work either. Here's some output.
>
> So not really deadly corrupted, if the data matters mount it RO and grab
> whatever you could get.
>
Funny story about that. On access, it locks up the entire shell making
me unable to do anything. However, Samba actually works. A lot of the
data that was on the array was corrupted but I did manage to grab some
stuff.
>>
>> root@LEDE:~# btrfs check /dev/sda
>> Checking filesystem on /dev/sda
>> UUID: 22d612d9-b7b6-4c4c-95cd-64f5056d420b
>> checksum verify failed on 3174631424000 found 6F04F3FC wanted 2658452A
>> checksum verify failed on 3174631424000 found 6F04F3FC wanted 2658452A
>> checksum verify failed on 3174631424000 found 6F04F3FC wanted 2658452A
>> checksum verify failed on 3174631424000 found 6F04F3FC wanted 2658452A
>> Csum didn't match
>> ERROR: failed to repair root items: I/O error
>
> IIRC btrfs-progs doesn't handle RAID5/6 repair well, so if something
> went wrong btrfs-progs just give up.
>
> So don't expect too much when using btrfs-progs with RAID5/6.
>
Duly noted. I/O error is strange since the hardware is fine...
>>
>> root@LEDE:~# btrfs check --init-extent-tree /dev/sda
>> Checking filesystem on /dev/sda
>> UUID: 22d612d9-b7b6-4c4c-95cd-64f5056d420b
>> Creating a new extent tree
>> Failed to find [3174144425984, 168, 16384]
>> btrfs unable to find ref byte nr 3174347603968 parent 0 root 1  owner 1 offset 0
>> Failed to find [3174144475136, 168, 16384]
>> btrfs unable to find ref byte nr 3174444449792 parent 0 root 1  owner 0 offset 1
>> Failed to find [3174144507904, 168, 16384]
>> btrfs unable to find ref byte nr 3174631505920 parent 0 root 1  owner 0 offset 1
>> checking extents
>> cmds-check.c:7866: add_data_backref: BUG_ON `!back` triggered, value 1
>> Aborted
>
> You're calling one of the most dangerous operation.
> It's a fortune it just aborts before causing more dangerous.
>
Didn't realize this option was dangerous. Guess I should have read man pages...
>>
>> root@LEDE:~# btrfs check --init-csum-tree /dev/sda
>> Creating a new CRC tree
>> Checking filesystem on /dev/sda
>> UUID: 22d612d9-b7b6-4c4c-95cd-64f5056d420b
>> Reinitialize checksum tree
>> Fixed 0 roots.
>> checking extents
>> cmds-check.c:7866: add_data_backref: BUG_ON `!back` triggered, value 1
>> Aborted
>>
>> This is with version 4.14 of btrfs-progs. Do I need a newer version or
>> should I just reinitialize my array and copy everything back?
>>
>> Log on mount attached below:
>>
>> Fri Jan 19 14:26:01 2018 kern.info kernel: [168376.739242] BTRFS info
>> (device sda): disk space caching is enabled
>> Fri Jan 19 14:26:01 2018 kern.info kernel: [168376.752038] BTRFS info
>> (device sda): has skinny extents
>> Fri Jan 19 14:26:04 2018 kern.info kernel: [168380.493600] BTRFS info
>> (device sda): continuing balance
>
> It seems to be a problem relocating the chunk.
>
> Try 'skip_balance' to see if it allow you to mount it RW.
>
> If it doesn't work, and since btrfs-progs won't help much in such case,
> rebuilding seems to be your only option.
>

Ended up rebuilding. It seems userspace (and maybe kernel?) is getting
proper data now from the drives so btrfs is not detecting silent data
corruption and trying to deal with it.

> Thanks,
> Qu
>
>> Fri Jan 19 14:26:07 2018 kern.info kernel: [168382.691771] BTRFS info
>> (device sda): relocating block group 3295510790144 flags 129
>> Fri Jan 19 14:26:07 2018 kern.warn kernel: [168383.028958] BTRFS
>> warning (device sda): sda checksum verify failed on 3174631424000
>> wanted 2658452A found 6F04F3FC level 0
>> Fri Jan 19 14:26:07 2018 kern.warn kernel: [168383.052699] BTRFS
>> warning (device sda): sda checksum verify failed on 3174631424000
>> wanted 2658452A found 6F04F3FC level 0
>> Fri Jan 19 14:26:07 2018 kern.warn kernel: [168383.087279] BTRFS
>> warning (device sda): sda checksum verify failed on 3174631424000
>> wanted 2658452A found 6F04F3FC level 0
>> Fri Jan 19 14:26:07 2018 kern.warn kernel: [168383.110017]
>> ------------[ cut here ]------------
>> Fri Jan 19 14:26:07 2018 kern.warn kernel: [168383.119950] WARNING:
>> CPU: 0 PID: 2496 at fs/btrfs/extent-tree.c:6958
>> btrfs_lookup_block_group+0x1438/0x1f74 [btrfs]
>> Fri Jan 19 14:26:07 2018 kern.warn kernel: [168383.120096] BTRFS
>> warning (device sda): sda checksum verify failed on 3174631424000
>> wanted 2658452A found 6F04F3FC level 0
>> Fri Jan 19 14:26:07 2018 kern.crit kernel: [168383.120189] BTRFS:
>> error (device sda) in __btrfs_free_extent:6958: errno=-5 IO failure
>> Fri Jan 19 14:26:07 2018 kern.info kernel: [168383.120197] BTRFS info
>> (device sda): forced readonly
>> Fri Jan 19 14:26:07 2018 kern.crit kernel: [168383.120214] BTRFS:
>> error (device sda) in btrfs_run_delayed_refs:2967: errno=-5 IO failure
>> Fri Jan 19 14:26:07 2018 kern.debug kernel: [168383.207466] BTRFS:
>> Transaction aborted (error -5)
>> Fri Jan 19 14:26:07 2018 kern.warn kernel: [168383.217230] Modules
>> linked in: snd_usb_audio nf_conntrack_ipv6 iptable_nat ipt_REJECT
>> ipt_MASQUERADE xt_time xt_tcpudp xt_state xt_nat xt_multiport xt_mark
>> xt_mac xt_limit xt_conntrack xt_comment xt_TCPMSS xt_REDIRECT xt_LOG
>> snd_usbmidi_lib nf_reject_ipv4 nf_nat_redirect nf_nat_masquerade_ipv4
>> nf_conntrack_ipv4 nf_nat_ipv4 nf_nat nf_log_ipv4 nf_defrag_ipv6
>> nf_defrag_ipv4 nf_conntrack_rtcache nf_conntrack libcrc32c
>> iptable_mangle iptable_filter ip_tables ip6t_REJECT nf_reject_ipv6
>> nf_log_ipv6 nf_log_common ip6table_mangle ip6table_filter ip6_tables
>> x_tables snd_compress snd_pcm_oss snd_mixer_oss snd_pcm snd_timer
>> snd_rawmidi snd_seq_device snd_hwdep snd soundcore cifs sha256_generic
>> md5 md4 hmac ecb des_generic usb_storage leds_gpio xhci_mtk
>> xhci_plat_hcd xhci_pci xhci_hcd ahci libahci libata sd_mod
>> Fri Jan 19 14:26:08 2018 kern.warn kernel: [168383.361711]  scsi_mod
>> gpio_button_hotplug btrfs xor raid6_pq usbcore nls_base usb_common
>> crc32c_generic
>> Fri Jan 19 14:26:08 2018 kern.warn kernel: [168383.378239] CPU: 0 PID:
>> 2496 Comm: kworker/u8:2 Tainted: G        W       4.9.75 #0
>> Fri Jan 19 14:26:08 2018 kern.warn kernel: [168383.394206] Workqueue:
>> btrfs-extent-refs btrfs_extent_refs_helper [btrfs]
>> Fri Jan 19 14:26:08 2018 kern.warn kernel: [168383.408183] Stack :
>> 8b3b8200 804c0000 8045bc04 8f7d359c 00000009 00001b2e 8ed29270
>> 00000000
>> Fri Jan 19 14:26:08 2018 kern.warn kernel: [168383.425374]
>> 8f673800 8006b9c8 8045bc04 00000000 000009c0 80523824 8045bb70
>> 8c6b3b24
>> Fri Jan 19 14:26:08 2018 kern.warn kernel: [168383.442564]
>> 804c0000 800a8670 00000001 80520000 804c9ec4 804c9ec8 80460810
>> 8c6b3b24
>> Fri Jan 19 14:26:08 2018 kern.warn kernel: [168383.459753]
>> 804c0000 8004334c 8ed29270 8c6b3b5c 000005ae 00000000 00000006
>> 006b3b44
>> Fri Jan 19 14:26:08 2018 kern.warn kernel: [168383.476942]
>> 8f7777ac 8fe2e400 8fe2eb00 66727462 78652d73 746e6574 6665722d
>> 00000073
>> Fri Jan 19 14:26:08 2018 kern.warn kernel: [168383.494132]         ...
>> Fri Jan 19 14:26:08 2018 kern.warn kernel: [168383.499272] Call Trace:
>> Fri Jan 19 14:26:08 2018 kern.warn kernel: [168383.504435]
>> [<8000f814>] show_stack+0x54/0x88
>> Fri Jan 19 14:26:08 2018 kern.warn kernel: [168383.513472]
>> [<801da9cc>] dump_stack+0x8c/0xd0
>> Fri Jan 19 14:26:08 2018 kern.warn kernel: [168383.522505]
>> [<8002bdc4>] __warn+0xe4/0x118
>> Fri Jan 19 14:26:08 2018 kern.warn kernel: [168383.531005]
>> [<8002be28>] warn_slowpath_fmt+0x30/0x3c
>> Fri Jan 19 14:26:08 2018 kern.warn kernel: [168383.541343]
>> [<8f716adc>] btrfs_lookup_block_group+0x1438/0x1f74 [btrfs]
>> Fri Jan 19 14:26:08 2018 kern.warn kernel: [168383.555109] ---[ end
>> trace d625fb7e6ea3d882 ]---
>> Fri Jan 19 14:26:08 2018 kern.crit kernel: [168383.564700] BTRFS:
>> error (device sda) in __btrfs_free_extent:6958: errno=-5 IO failure
>> Fri Jan 19 14:26:08 2018 kern.crit kernel: [168383.581024] BTRFS:
>> error (device sda) in btrfs_run_delayed_refs:2967: errno=-5 IO failure
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
