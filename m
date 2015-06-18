Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f173.google.com ([209.85.217.173]:33455 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754837AbbFRLIP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Jun 2015 07:08:15 -0400
Received: by lbbvz5 with SMTP id vz5so1762413lbb.0
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Jun 2015 04:08:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5581C0EF.90106@suse.com>
References: <CAC8ULPYHuqsZN1Lm_2TxGMw7z6n=4zAprqYr9uoi=3kjoiSxQw@mail.gmail.com>
	<5581C0EF.90106@suse.com>
Date: Thu, 18 Jun 2015 14:08:13 +0300
Message-ID: <CAC8ULPZgbNak4fezpHaKDF9ZOyvLWeEUMjxo4Ju65X_XShykww@mail.gmail.com>
Subject: Re: btrfs partition converted from ext4 becomes read-only minutes
 after booting: WARNING: CPU: 2 PID: 2777 at ../fs/btrfs/super.c:260 __btrfs_abort_transaction+0x4b/0x120
From: Robert Munteanu <robert.munteanu@gmail.com>
To: Jeff Mahoney <jeffm@suse.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 17, 2015 at 9:48 PM, Jeff Mahoney <jeffm@suse.com> wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> On 6/12/15 8:19 AM, Robert Munteanu wrote:
>> Hi,
>>
>> I have converted my root ext4 partition to btrfs. I used an USB
>> stick to boot and used btrfs-convert.
>>
>> I also did a balance and defrag ( in that order ) , both when the
>> fs was mounted.
>>
>> After logging in to KDE I quickly get a read-only filesystem. I've
>> pasted the backtrace below
>>
>> Jun 11 23:13:08 mars kernel: WARNING: CPU: 2 PID: 2777 at
>> ../fs/btrfs/super.c:260 __btrfs_abort_transaction+0x4b/0x120
>> [btrfs]() Jun 11 23:13:08 mars kernel: BTRFS: Transaction aborted
>> (error -95) Jun 11 23:13:08 mars kernel: Modules linked in: bnep
>> bluetooth rfkill fuse vboxpci(O) vboxnetadp(O) vboxnetflt(O)
>> vboxdrv(O) af_packet nf_log_ipv6 xt_pkttype nf_log_ip v4
>> nf_log_common xt_LOG xt_limit ip6t_REJECT xt_tcpudp
>> nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_raw ipt_REJECT
>> iptable_raw xt_CT iptable_filter ip6table_mangle nf_con
>> ntrack_netbios_ns nf_conntrack_broadcast nf_conntrack_ipv4
>> nf_defrag_ipv4 ip_tables xt_conntrack nf_conntrack ip6table_filter
>> ip6_tables x_tables xfs libcrc32c snd_hda _codec_hdmi raid1 md_mod
>> gpio_ich ppdev iTCO_wdt iTCO_vendor_support coretemp
>> snd_hda_codec_realtek snd_hda_codec_generic kvm_intel snd_hda_intel
>> dm_mod kvm snd_hda_co ntroller snd_hda_codec snd_hwdep serio_raw
>> pcspkr snd_pcm i2c_i801 snd_seq joydev snd_seq_device snd_timer snd
>> 8250_fintek parport_pc parport acpi_cpufreq lpc_ich Jun 11 23:13:08
>> mars kernel:  soundcore mfd_core shpchp processor ata_generic btrfs
>> hid_logitech_hidpp xor raid6_pq sr_mod cdrom nvidia_uvm(PO)
>> nvidia(PO) firewire_ohc i firewire_core crc_itu_t uas usb_storage
>> r8169 mii pata_jmicron hid_logitech_dj drm button sg Jun 11
>> 23:13:08 mars kernel: CPU: 2 PID: 2777 Comm: kworker/u8:0 Tainted:
>> P           O    4.0.4-3-desktop #1
>
> openSUSE Tumbleweed, I take it?

Yes. Also reported at https://bugzilla.opensuse.org/show_bug.cgi?id=934464 .

>
> We still actively support btrfs-convert through SLES, so we're
> invested in ensuring it continues working properly.  I'd be interested
> in seeing images of both filesystems to investigate and to see if we
> can reproduce it. Errno -95 is -EOPNOTSUPP which is kind of strange to
> see.  I can see a few possible places it would get passed up with a
> trace like that but being able to reproduce it would be extremely helpfu
> l.

In the meantime I got bored and 'fixed' it ( I think ) . The "fix"
involved copying the /home tree to a different ( xfs ) partition, and
now the error does not appear anymore.

However, I still have the old tree in the btrfs partition ( as /home2
). I will try and reproduce the issue there and submit a reduced image
which triggers the error. Unfortunately I no longer have the old ext4
partition image.

Thanks,

Robert

>
> - -Jeff
>
>> Jun 11 23:13:08 mars kernel: Hardware name: Gigabyte Technology
>> Co., Ltd. EP35-DS4/EP35-DS4, BIOS F6d 01/08/2009 Jun 11 23:13:08
>> mars kernel: Workqueue: btrfs-endio-write btrfs_endio_write_helper
>> [btrfs] Jun 11 23:13:08 mars kernel:  0000000000000000
>> ffffffffa0a92832 ffffffff8167c4aa ffff880128513ca8 Jun 11 23:13:08
>> mars kernel:  ffffffff81063bb1 ffff880031929d28 ffff880221e71800
>> 00000000ffffffa1 Jun 11 23:13:08 mars kernel:  ffffffffa0a914e0
>> 0000000000000b50 ffffffff81063c2a ffffffffa0a95928 Jun 11 23:13:08
>> mars kernel: Call Trace: Jun 11 23:13:08 mars kernel:
>> [<ffffffff8100574c>] dump_trace+0x8c/0x340 Jun 11 23:13:08 mars
>> kernel:  [<ffffffff81005aa3>] show_stack_log_lvl+0xa3/0x190 Jun 11
>> 23:13:08 mars kernel:  [<ffffffff81007201>] show_stack+0x21/0x50
>> Jun 11 23:13:08 mars kernel:  [<ffffffff8167c4aa>]
>> dump_stack+0x47/0x67 Jun 11 23:13:08 mars kernel:
>> [<ffffffff81063bb1>] warn_slowpath_common+0x81/0xb0 Jun 11 23:13:08
>> mars kernel:  [<ffffffff81063c2a>] warn_slowpath_fmt+0x4a/0x50 Jun
>> 11 23:13:08 mars kernel:  [<ffffffffa09e598b>]
>> __btrfs_abort_transaction+0x4b/0x120 [btrfs] Jun 11 23:13:08 mars
>> kernel:  [<ffffffffa0a1d18a>] btrfs_finish_ordered_io+0x5aa/0x620
>> [btrfs] Jun 11 23:13:08 mars kernel:  [<ffffffffa0a43253>]
>> normal_work_helper+0xc3/0x320 [btrfs] Jun 11 23:13:08 mars kernel:
>> [<ffffffff8107bcf2>] process_one_work+0x142/0x420 Jun 11 23:13:08
>> mars kernel:  [<ffffffff8107c0e4>] worker_thread+0x114/0x460 Jun 11
>> 23:13:08 mars kernel:  [<ffffffff81081261>] kthread+0xc1/0xe0 Jun
>> 11 23:13:08 mars kernel:  [<ffffffff81682d58>]
>> ret_from_fork+0x58/0x90 Jun 11 23:13:08 mars kernel: ---[ end trace
>> 4c4eb7d6e98afa91 ]--- Jun 11 23:13:08 mars kernel: BTRFS: error
>> (device sda1) in btrfs_finish_ordered_io:2896: errno=-95 unknown
>> Jun 11 23:13:08 mars kernel: BTRFS info (device sda1): forced
>> readonly
>>
>> Some diagnostic info:
>>
>> - btrfs scrub reports no errors - on the host machine I'm running
>> btrfs v4.0+20150429 and kernel 4.0.4-3-desktop - on the live
>> medium, used to run btrfs-convert, I was running btrfs
>> v4.0+20150429 and kernel 4.0.3-1-default
>>
>> # btrfs fi show Label: none  uuid:
>> 54dea125-74cd-4bb2-86a2-f7bc645b76cf Total devices 1 FS bytes used
>> 90.22GiB devid    1 size 223.57GiB used 92.03GiB path /dev/sda1
>>
>> btrfs-progs v4.0+20150429
>>
>> # btrfs fi df / Data, single: total=89.00GiB, used=88.17GiB System,
>> single: total=32.00MiB, used=16.00KiB Metadata, single:
>> total=3.00GiB, used=2.05GiB GlobalReserve, single: total=512.00MiB,
>> used=0.00B
>>
>> Is there a way out? I still have the old ext4 image and can
>> revert, but I'm keeping the btrfs one for now, in case I can
>> extract some useful debugging information from it.
>>
>> Thanks,
>>
>> Robert
>>
>>
>
>
> - --
> Jeff Mahoney
> SUSE Labs
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG/MacGPG2 v2.0.19 (Darwin)
>
> iQIcBAEBAgAGBQJVgcDvAAoJEB57S2MheeWyzv0P/16m75jpx9hgcT7SVy+4u5Ja
> sX2fFwDHgd/zGItt+F9GR4/yOB73maASeNVuNTxsBiERF7s56oGeBJ4+MYVIx48W
> rrYdvKAC0DBrcc27/PiG1nwPVH/zfVPzcyYZSfvU2Mp3QFHG5ak54yw4MJhweiyW
> cfdepCll1dWfGRM0o2sa5f+eXJaX/V5c2br316gsnvnlCaDlkgE9AZL9Siggrdok
> ICtEJvcp5BSIBKWcvJVVJPJKS4i03TaEU2DU6ZqLs9xYWJEtu8ts0QIOmOUpOZU+
> cgYTd3tb2uVzow0cK/H64CVbP/hkmA3z7WwjeiGYl1l2+bzCj+nu/YemYUIm2LYV
> OCygm3o+b0RBLBFmwCVu03bjls56xwwmU71jJ5J30nPpYrwNcOEpTNN0uAfKhfmw
> brziKpGEr/ITVuu1dXJ28R5dK1NNUTIhMDm5kotQUAYE8P36AY4WUmNZmTgw2Tp/
> JLoNFj4XiAZNLN0t17gwYuJG+rJk5qMKzpL4MvbY2+/M0QaE7PvbVGtQTJWYgyfB
> JYdBFBGUwNO7gnnKFecN+meobumuDZY0ogf7msf1Kt5x8hlrsFRtkqtvWENEtwCR
> 4yBPAagBrCTHJnEqp99yztg6KHYUwsPICxHJDItZnzFnHvn4P9zM8urosgzHvPsu
> a3Le0Zo2YKNEWULHV5Q3
> =obS1
> -----END PGP SIGNATURE-----



-- 
http://robert.muntea.nu/
