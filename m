From: Daniel J Blueman <daniel.blueman@gmail.com>
Subject: Re: Performance degradation
Date: Sun, 26 Sep 2010 15:05:37 +0100
Message-ID: <AANLkTinb2a=Lu-f6W_vNPG_AyOAQNfUiGVakBU-Jwg14@mail.gmail.com>
References: <AANLkTimhpg22M0UUcfksh1H9oGMweVhwpDvqeu0nfOP0@mail.gmail.com>
	<D1A263E5-C03A-4D6B-BC4D-6085F10714E1@noir.com>
	<AANLkTi=569wzOheD_eeai6O7uaWBxMhRv5_YuUE1dJZb@mail.gmail.com>
	<20100922000217.GP27633@think>
	<AANLkTikLcyQr7Ooi5jxMMHOq9Y1OaH58GMjucGhfUQUH@mail.gmail.com>
	<AANLkTin9kzby9Xgr0Ns1bFyK=igKNWMRZq7S3=2mzPJi@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>,
	"K. Richard Pixley" <rich@noir.com>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Dave Cundiff <syshackmin@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTin9kzby9Xgr0Ns1bFyK=igKNWMRZq7S3=2mzPJi@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Dave,

On 24 September 2010 20:39, Dave Cundiff <syshackmin@gmail.com> wrote:
>>> It shouldn't but it depends on how much metadata we have to read in=
 to
>>> process the snapshots. =A0Could you do a few sysrq-w? =A0We'll see =
where you
>>> are spending your time based on the traces.
>>
>> Also, using 'perf' may give a good picture of where the time is spen=
t, eg:
>>
>> $ sudo perf record -a sleep 20
>> $ sudo perf report | tee profile.txt
>> --
>> Daniel J Blueman
>>
>
> The cleaner finished before I was able to get any debug, however,
> here's sysrq's and perf data from my very slow running backups. I als=
o
> did a test on the same box with rsync between the ext3 and btrfs
> filesystem with 1 large file. rsync can pretty much saturate the
> 100mbit port writing to the ext3 filesystem. The ext3 and btrfs
> filesystems are on the same RAID5 container. Just different
> partitions.
>
> btrfs filesystem:
> rsync --progress -v -e 'ssh' a2s55:/var/log/exim_mainlog .
> exim_mainlog
> =A0 =A064019026 100% =A0 =A01.76MB/s =A0 =A00:00:34 (xfer#1, to-check=
=3D0/1)
>
> Ext3:
> rsync --progress -v -e 'ssh' a2s55:/var/log/exim_mainlog .
> exim_mainlog
> =A0 =A064032337 100% =A0 =A08.40MB/s =A0 =A00:00:07 (xfer#1, to-check=
=3D0/1)
>
> Here's an iostat across 20 seconds while the backups were running and
> actively trying to copy a 10gig file:
> sdb =A0 =A0 =A0 =A0 =A0 =A0 =A0 0.00 =A0 =A0 0.00 =A00.25 27.45 =A0 =A0=
 2.00 =A04000.80 =A0 144.51
> =A0 =A00.01 =A0 =A00.28 =A0 0.22 =A0 0.60
>
> The sysrq and perf data is also from the backup trying to copy a 10gi=
g
> file. Its not gonna complete for almost 2 hours... :(
>
> home/dmportal/public_html/data3m7_data_wiki.tgz
> 1782775808 =A015% =A0 =A01.57MB/s =A0 =A01:40:45
>
> The only process I could get to show blocked in the sysrq was ssh
> which is how rsync is transmitting its data.
>
> [336155.004946] =A0 task =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0PC stack =A0 pid father
> [336155.005018] ssh =A0 =A0 =A0 =A0 =A0 D 00000001140c8669 =A04424 20=
748 =A020747 0x00000080
> [336155.005024] =A0ffff880402421628 0000000000000086 ffff8804024215d8
> 0000000000004000
> [336155.008563] =A00000000000013140 ffff8801cd458378 ffff8801cd458000
> ffff880236dd16b0
> [336155.008567] =A0ffffffff02421678 ffffffff810e23d8 000000000000000a
> 0000000000000001
> [336155.008572] Call Trace:
> [336155.008581] =A0[<ffffffff810e23d8>] ? free_page_list+0xe8/0x100
> [336155.008589] =A0[<ffffffff815cde98>] schedule_timeout+0x138/0x2b0
> [336155.008595] =A0[<ffffffff81058920>] ? process_timeout+0x0/0x10
> [336155.008599] =A0[<ffffffff815ccee0>] io_schedule_timeout+0x80/0xe0
> [336155.008606] =A0[<ffffffff810ed9a1>] congestion_wait+0x71/0x90
> [336155.008610] =A0[<ffffffff8106a280>] ? autoremove_wake_function+0x=
0/0x40
> [336155.008614] =A0[<ffffffff810e4171>] shrink_inactive_list+0x2e1/0x=
310
> [336155.008619] =A0[<ffffffff810e449f>] shrink_zone+0x2ff/0x4e0
> [336155.008625] =A0[<ffffffff810e16b9>] ? shrink_slab+0x149/0x180
> [336155.008628] =A0[<ffffffff810e486e>] zone_reclaim+0x1ee/0x290
> [336155.008632] =A0[<ffffffff810d926a>] ? zone_watermark_ok+0x2a/0x10=
0
> [336155.008637] =A0[<ffffffff810db55a>] get_page_from_freelist+0x5fa/=
0x7b0
> [336155.008642] =A0[<ffffffff81130956>] ? free_poll_entry+0x26/0x30
> [336155.008647] =A0[<ffffffff81037f6e>] ? select_idle_sibling+0x9e/0x=
120
> [336155.008652] =A0[<ffffffff810dc860>] __alloc_pages_nodemask+0x130/=
0x7e0
> [336155.008658] =A0[<ffffffff8103f7cf>] ? enqueue_task_fair+0x4f/0x60
> [336155.008661] =A0[<ffffffff8103d8f8>] ? enqueue_task+0x68/0xa0
> [336155.008665] =A0[<ffffffff814bd8f1>] ? __alloc_skb+0x51/0x180
> [336155.008671] =A0[<ffffffff8110f02c>] kmalloc_large_node+0x5c/0xb0
> [336155.008676] =A0[<ffffffff81112166>] __kmalloc_node_track_caller+0=
xf6/0x1f0
> [336155.008682] =A0[<ffffffff814ba2f0>] ? sock_alloc_send_pskb+0x1a0/=
0x2f0
> [336155.008685] =A0[<ffffffff814bd920>] __alloc_skb+0x80/0x180
> [336155.008689] =A0[<ffffffff814ba2f0>] sock_alloc_send_pskb+0x1a0/0x=
2f0
> [336155.008693] =A0[<ffffffff81037a6e>] ? __wake_up_sync_key+0x5e/0x8=
0
> [336155.008697] =A0[<ffffffff814ba455>] sock_alloc_send_skb+0x15/0x20
> [336155.008704] =A0[<ffffffff81567c22>] unix_stream_sendmsg+0x282/0x3=
c0
> [336155.008709] =A0[<ffffffff814b6b20>] sock_aio_write+0x170/0x180
> [336155.008715] =A0[<ffffffff8111ff95>] do_sync_write+0xd5/0x120
> [336155.008720] =A0[<ffffffff812204af>] ? security_file_permission+0x=
1f/0x70
> [336155.008724] =A0[<ffffffff8112034e>] vfs_write+0x17e/0x190
> [336155.008727] =A0[<ffffffff81120d25>] sys_write+0x55/0x90
> [336155.008733] =A0[<ffffffff81002e1b>] system_call_fastpath+0x16/0x1=
b
>
>
> and 60 seconds of perf data while the 10gig file was languishing. I
> trimmed it just to the top entries. Lemme know if you need the entire
> thing.
>
> # Samples: 140516
> #
> # Overhead =A0 =A0 =A0 =A0 =A0Command =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 Shared Object =A0Symbol
> # ........ =A0............... =A0.............................. =A0..=
=2E...
> #
> =A0 =A025.92% =A0 =A0 =A0 =A0 =A0 =A0 =A0ssh =A0/lib64/libcrypto.so.0=
=2E9.8e =A0 =A0 =A0[.]
> 0x000000000e0bb8
> =A0 =A0 5.19% =A0 =A0 =A0 =A0 =A0 =A0rsync =A0/usr/bin/rsync =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0[.] md5_process
> =A0 =A0 5.18% =A0 =A0 =A0 =A0 =A0 [idle] =A0[kernel] =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0[k] intel_idle
> =A0 =A0 4.35% =A0 =A0 =A0 =A0 =A0 =A0 =A0ssh =A0/usr/bin/ssh =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0[.]
> 0x000000000254ae
> =A0 =A0 4.00% =A0 =A0 =A0 =A0 =A0 [idle] =A0[kernel] =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0[k] read_hpet
> =A0 =A0 3.67% =A0 =A0 =A0 =A0 =A0 =A0 =A0ssh =A0/lib64/libcrypto.so.0=
=2E9.8e =A0 =A0 =A0[.]
> md5_block_asm_data_order
> =A0 =A0 2.64% =A0 =A0 =A0 =A0 =A0 =A0rsync =A0[kernel] =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0[k]
> __etree_search [btrfs]
> =A0 =A0 2.47% =A0 =A0 =A0 =A0 =A0 =A0rsync =A0[kernel] =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0[k]
> buffer_search =A0[btrfs]
> =A0 =A0 2.40% =A0 =A0 =A0 =A0 =A0 =A0rsync =A0[kernel] =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0[k] read_hpet
> =A0 =A0 1.30% =A0btrfs-endio-wri =A0[kernel] =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0[k]
> buffer_search =A0[btrfs]
> =A0 =A0 1.16% =A0 =A0 =A0 =A0 =A0 =A0 =A0ssh =A0/lib64/libcrypto.so.0=
=2E9.8e =A0 =A0 =A0[.] AES_encrypt
> =A0 =A0 1.02% =A0btrfs-endio-wri =A0[kernel] =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0[k]
> __etree_search [btrfs]
> =A0 =A0 0.89% =A0 =A0 =A0 =A0 =A0 =A0 =A0ssh =A0[kernel] =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0[k]
> copy_user_generic_string
> =A0 =A0 0.76% =A0 =A0 =A0 =A0 =A0 =A0rsync =A0[kernel] =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0[k] _raw_spin_lock
> =A0 =A0 0.53% =A0 =A0 =A0 =A0 =A0 =A0rsync =A0/usr/bin/rsync =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0[.] read_timeout
> =A0 =A0 0.50% =A0 =A0 =A0 =A0 =A0 =A0rsync =A0[kernel] =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0[k]
> generic_bin_search =A0 =A0 [btrfs]
> =A0 =A0 0.48% =A0 =A0 =A0 =A0 =A0 =A0rsync =A0[kernel] =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0[k]
> copy_user_generic_string
> =A0 =A0 0.48% =A0 btrfs-worker-0 =A0[kernel] =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0[k]
> crc32c_intel_le_hw =A0 =A0 [crc32c_intel]
> =A0 =A0 0.42% =A0 =A0 =A0 =A0 =A0 =A0rsync =A0[kernel] =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0[k]
> btrfs_search_slot =A0 =A0 =A0[btrfs]
> =A0 =A0 0.38% =A0 =A0 =A0 =A0 =A0 =A0rsync =A0[kernel] =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0[k]
> map_private_extent_buffer =A0 =A0 =A0[btrfs]
> =A0 =A0 0.34% =A0 =A0 =A0 =A0 =A0 =A0rsync =A0[kernel] =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0[k]
> comp_keys =A0 =A0 =A0[btrfs]
> =A0 =A0 0.34% =A0 =A0 =A0 =A0 =A0 =A0rsync =A0[kernel] =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0[k]
> kmem_cache_alloc
> =A0 =A0 0.34% =A0 =A0 =A0 =A0 =A0 =A0 =A0ssh =A0/lib64/libc-2.5.so =A0=
 =A0 =A0 =A0 =A0 =A0 =A0[.] __GI_memcpy
> =A0 =A0 0.31% =A0 =A0 =A0 =A0 =A0 =A0rsync =A0[kernel] =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0[k]
> btrfs_comp_cpu_keys =A0 =A0[btrfs]
>
>
> =A0and lastly, the same giant file writing to the ext3 partition on t=
he
> same RAID container while the btrfs transfer was still trying to copy
> it. It was able to saturate the 100mbit port.
>
> rsync --progress -v -e'ssh'
> a2s55:/home/dmportal/public_html/data3m7_data_wiki.tgz .
> data3m7_data_wiki.tgz 8.10MB/s =A0 =A00:22:19

The profile here shows relatively little time spent in BTRFS, thus
most likely the high system-load is due to processes waiting for disk
(which is counted as busy, even though the process isn't scheduled).

The 25% in libcrypto is saturating one core I guess, thus the limiting
factor here. I would suggest to use:

$ rsync --progress -v -e'ssh -o ciphers=3Darcfour -o compression=3Dno'
a2s55:/home/dmportal/public_html/data3m7_data_wiki.tgz .

SSH compression destroys throughput, and arcfour is really much faster
than AES (until you get Intel Westmere + OS support). I was finding
that BTRFS compression was really hurting writeback, due to a known
regression.

Are you using it here on your backup system? Anyway, I guess you need
to grab profile information when you are getting the slow snapshot
deletion...

Dan
--=20
Daniel J Blueman
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
