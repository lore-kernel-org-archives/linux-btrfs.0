From: Dave Cundiff <syshackmin@gmail.com>
Subject: Re: Performance degradation
Date: Fri, 24 Sep 2010 15:39:19 -0400
Message-ID: <AANLkTin9kzby9Xgr0Ns1bFyK=igKNWMRZq7S3=2mzPJi@mail.gmail.com>
References: <AANLkTimhpg22M0UUcfksh1H9oGMweVhwpDvqeu0nfOP0@mail.gmail.com>
	<D1A263E5-C03A-4D6B-BC4D-6085F10714E1@noir.com>
	<AANLkTi=569wzOheD_eeai6O7uaWBxMhRv5_YuUE1dJZb@mail.gmail.com>
	<20100922000217.GP27633@think>
	<AANLkTikLcyQr7Ooi5jxMMHOq9Y1OaH58GMjucGhfUQUH@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>,
	"K. Richard Pixley" <rich@noir.com>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Daniel J Blueman <daniel.blueman@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTikLcyQr7Ooi5jxMMHOq9Y1OaH58GMjucGhfUQUH@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

>> It shouldn't but it depends on how much metadata we have to read in =
to
>> process the snapshots. =A0Could you do a few sysrq-w? =A0We'll see w=
here you
>> are spending your time based on the traces.
>
> Also, using 'perf' may give a good picture of where the time is spent=
, eg:
>
> $ sudo perf record -a sleep 20
> $ sudo perf report | tee profile.txt
> --
> Daniel J Blueman
>

The cleaner finished before I was able to get any debug, however,
here's sysrq's and perf data from my very slow running backups. I also
did a test on the same box with rsync between the ext3 and btrfs
filesystem with 1 large file. rsync can pretty much saturate the
100mbit port writing to the ext3 filesystem. The ext3 and btrfs
filesystems are on the same RAID5 container. Just different
partitions.

btrfs filesystem:
rsync --progress -v -e 'ssh' a2s55:/var/log/exim_mainlog .
exim_mainlog
    64019026 100%    1.76MB/s    0:00:34 (xfer#1, to-check=3D0/1)

Ext3:
rsync --progress -v -e 'ssh' a2s55:/var/log/exim_mainlog .
exim_mainlog
    64032337 100%    8.40MB/s    0:00:07 (xfer#1, to-check=3D0/1)

Here's an iostat across 20 seconds while the backups were running and
actively trying to copy a 10gig file:
sdb               0.00     0.00  0.25 27.45     2.00  4000.80   144.51
    0.01    0.28   0.22   0.60

The sysrq and perf data is also from the backup trying to copy a 10gig
file. Its not gonna complete for almost 2 hours... :(

home/dmportal/public_html/data3m7_data_wiki.tgz
1782775808  15%    1.57MB/s    1:40:45

The only process I could get to show blocked in the sysrq was ssh
which is how rsync is transmitting its data.

[336155.004946]   task                        PC stack   pid father
[336155.005018] ssh           D 00000001140c8669  4424 20748  20747 0x0=
0000080
[336155.005024]  ffff880402421628 0000000000000086 ffff8804024215d8
0000000000004000
[336155.008563]  0000000000013140 ffff8801cd458378 ffff8801cd458000
ffff880236dd16b0
[336155.008567]  ffffffff02421678 ffffffff810e23d8 000000000000000a
0000000000000001
[336155.008572] Call Trace:
[336155.008581]  [<ffffffff810e23d8>] ? free_page_list+0xe8/0x100
[336155.008589]  [<ffffffff815cde98>] schedule_timeout+0x138/0x2b0
[336155.008595]  [<ffffffff81058920>] ? process_timeout+0x0/0x10
[336155.008599]  [<ffffffff815ccee0>] io_schedule_timeout+0x80/0xe0
[336155.008606]  [<ffffffff810ed9a1>] congestion_wait+0x71/0x90
[336155.008610]  [<ffffffff8106a280>] ? autoremove_wake_function+0x0/0x=
40
[336155.008614]  [<ffffffff810e4171>] shrink_inactive_list+0x2e1/0x310
[336155.008619]  [<ffffffff810e449f>] shrink_zone+0x2ff/0x4e0
[336155.008625]  [<ffffffff810e16b9>] ? shrink_slab+0x149/0x180
[336155.008628]  [<ffffffff810e486e>] zone_reclaim+0x1ee/0x290
[336155.008632]  [<ffffffff810d926a>] ? zone_watermark_ok+0x2a/0x100
[336155.008637]  [<ffffffff810db55a>] get_page_from_freelist+0x5fa/0x7b=
0
[336155.008642]  [<ffffffff81130956>] ? free_poll_entry+0x26/0x30
[336155.008647]  [<ffffffff81037f6e>] ? select_idle_sibling+0x9e/0x120
[336155.008652]  [<ffffffff810dc860>] __alloc_pages_nodemask+0x130/0x7e=
0
[336155.008658]  [<ffffffff8103f7cf>] ? enqueue_task_fair+0x4f/0x60
[336155.008661]  [<ffffffff8103d8f8>] ? enqueue_task+0x68/0xa0
[336155.008665]  [<ffffffff814bd8f1>] ? __alloc_skb+0x51/0x180
[336155.008671]  [<ffffffff8110f02c>] kmalloc_large_node+0x5c/0xb0
[336155.008676]  [<ffffffff81112166>] __kmalloc_node_track_caller+0xf6/=
0x1f0
[336155.008682]  [<ffffffff814ba2f0>] ? sock_alloc_send_pskb+0x1a0/0x2f=
0
[336155.008685]  [<ffffffff814bd920>] __alloc_skb+0x80/0x180
[336155.008689]  [<ffffffff814ba2f0>] sock_alloc_send_pskb+0x1a0/0x2f0
[336155.008693]  [<ffffffff81037a6e>] ? __wake_up_sync_key+0x5e/0x80
[336155.008697]  [<ffffffff814ba455>] sock_alloc_send_skb+0x15/0x20
[336155.008704]  [<ffffffff81567c22>] unix_stream_sendmsg+0x282/0x3c0
[336155.008709]  [<ffffffff814b6b20>] sock_aio_write+0x170/0x180
[336155.008715]  [<ffffffff8111ff95>] do_sync_write+0xd5/0x120
[336155.008720]  [<ffffffff812204af>] ? security_file_permission+0x1f/0=
x70
[336155.008724]  [<ffffffff8112034e>] vfs_write+0x17e/0x190
[336155.008727]  [<ffffffff81120d25>] sys_write+0x55/0x90
[336155.008733]  [<ffffffff81002e1b>] system_call_fastpath+0x16/0x1b


and 60 seconds of perf data while the 10gig file was languishing. I
trimmed it just to the top entries. Lemme know if you need the entire
thing.

# Samples: 140516
#
# Overhead          Command                   Shared Object  Symbol
# ........  ...............  ..............................  ......
#
    25.92%              ssh  /lib64/libcrypto.so.0.9.8e      [.]
0x000000000e0bb8
     5.19%            rsync  /usr/bin/rsync                  [.] md5_pr=
ocess
     5.18%           [idle]  [kernel]                        [k] intel_=
idle
     4.35%              ssh  /usr/bin/ssh                    [.]
0x000000000254ae
     4.00%           [idle]  [kernel]                        [k] read_h=
pet
     3.67%              ssh  /lib64/libcrypto.so.0.9.8e      [.]
md5_block_asm_data_order
     2.64%            rsync  [kernel]                        [k]
__etree_search [btrfs]
     2.47%            rsync  [kernel]                        [k]
buffer_search  [btrfs]
     2.40%            rsync  [kernel]                        [k] read_h=
pet
     1.30%  btrfs-endio-wri  [kernel]                        [k]
buffer_search  [btrfs]
     1.16%              ssh  /lib64/libcrypto.so.0.9.8e      [.] AES_en=
crypt
     1.02%  btrfs-endio-wri  [kernel]                        [k]
__etree_search [btrfs]
     0.89%              ssh  [kernel]                        [k]
copy_user_generic_string
     0.76%            rsync  [kernel]                        [k] _raw_s=
pin_lock
     0.53%            rsync  /usr/bin/rsync                  [.] read_t=
imeout
     0.50%            rsync  [kernel]                        [k]
generic_bin_search     [btrfs]
     0.48%            rsync  [kernel]                        [k]
copy_user_generic_string
     0.48%   btrfs-worker-0  [kernel]                        [k]
crc32c_intel_le_hw     [crc32c_intel]
     0.42%            rsync  [kernel]                        [k]
btrfs_search_slot      [btrfs]
     0.38%            rsync  [kernel]                        [k]
map_private_extent_buffer      [btrfs]
     0.34%            rsync  [kernel]                        [k]
comp_keys      [btrfs]
     0.34%            rsync  [kernel]                        [k]
kmem_cache_alloc
     0.34%              ssh  /lib64/libc-2.5.so              [.] __GI_m=
emcpy
     0.31%            rsync  [kernel]                        [k]
btrfs_comp_cpu_keys    [btrfs]


 and lastly, the same giant file writing to the ext3 partition on the
same RAID container while the btrfs transfer was still trying to copy
it. It was able to saturate the 100mbit port.

rsync --progress -v -e'ssh'
a2s55:/home/dmportal/public_html/data3m7_data_wiki.tgz .
data3m7_data_wiki.tgz 8.10MB/s    0:22:19


Thanks for any input!

--=20
Dave Cundiff
System Administrator
A2Hosting, Inc
http://www.a2hosting.com
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
