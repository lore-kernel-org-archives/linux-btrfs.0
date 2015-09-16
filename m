Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f182.google.com ([209.85.160.182]:34098 "EHLO
	mail-yk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752515AbbIPObd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Sep 2015 10:31:33 -0400
Received: by ykdg206 with SMTP id g206so220386110ykd.1
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2015 07:31:32 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 16 Sep 2015 15:31:32 +0100
Message-ID: <CAA-6JZq+bL31eD5sxaLjwt41G68BzPjt=MJi4hTEgwvMXy3_ZA@mail.gmail.com>
Subject: Re: [PATCH V2] Btrfs: keep dropped roots in cache until transaction commit
From: Glyn Normington <gnormington@pivotal.io>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>On 09/15/15 21:15, Josef Bacik wrote:
>> On 09/15/2015 03:08 PM, Holger Hoffstätte wrote:
>>> On 09/15/15 17:50, Holger Hoffstätte wrote:
>>>> This V2 does indeed seem to fix the issues I reported with snapshot
>>>> deletion & concurrent sync. I've now created/filled/deleted countless
>>>> snapshots while issuing sync(s) in parallel, and the problem that I
>>>> saw fairly frequently with V1 no longer seems to occur here.
>>>
>>> Well..I may have spoken too soon:
>>
>> Huh this doesn't seem related to my stuff. Can I have your script you
>> are running to reproduce this? Thanks,
>
>This was manual - deleted two large files, deleted two snapshots (one
>from the modified subvolume and one sibling), let it sit in the background
>while doing something else for a few seconds and found the messages.
>Don't know how to reproduce this as it didn't show up previously.
>
>-h

We are seeing a very similar problem fwiw. Unfortunately we can't
reproduce this reliably, but it is cropping up regularly. Here's a
chore we are using to track our work on this: [2].

Here's the kernel log:

[610194.395845] WARNING: CPU: 3 PID: 29166 at
/build/linux-lts-vivid-BZwsXG/linux-lts-vivid-3.19.0/fs/btrfs/super.c:260
__btrfs_abort_transaction+0x54/0x130 [btrfs]()
[610194.395847] BTRFS: Transaction aborted (error -2)
[610194.395848] Modules linked in: dummy xt_NFLOG nfnetlink_log
nfnetlink xt_tcpudp xt_iprange ipt_MASQUERADE nf_nat_masquerade_ipv4
veth xt_nat nf_log_ipv4 nf_log_common xt_LOG bridge stp llc
iptable_nat nf_nat_ipv4 nf_nat ipt_REJECT nf_reject_ipv4
nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack
iptable_filter ip_tables x_tables btrfs xor raid6_pq
x86_pkg_temp_thermal coretemp crct10dif_pclmul crc32_pclmul
ghash_clmulni_intel aesni_intel aes_x86_64 lrw gf128mul glue_helper
ablk_helper cryptd nfsd auth_rpcgss nfs_acl nfs lockd grace sunrpc
fscache
[610194.395881] CPU: 3 PID: 29166 Comm: garden-linux Tainted: G
WC     3.19.0-26-generic #28~14.04.1-Ubuntu
[610194.395883]  ffffffffc046ff40 ffff88000ba77968 ffffffff817aeed7
0000000000000000
[610194.395886]  ffff88000ba779b8 ffff88000ba779a8 ffffffff81074d8a
ffff8801605fee38
[610194.395889]  ffff8801bc069210 ffff880005dd5800 00000000fffffffe
ffffffffc046c390
[610194.395892] Call Trace:
[610194.395899]  [<ffffffff817aeed7>] dump_stack+0x45/0x57
[610194.395904]  [<ffffffff81074d8a>] warn_slowpath_common+0x8a/0xc0
[610194.395907]  [<ffffffff81074e06>] warn_slowpath_fmt+0x46/0x50
[610194.395917]  [<ffffffffc03bff14>]
__btrfs_abort_transaction+0x54/0x130 [btrfs]
[610194.395930]  [<ffffffffc03ec686>]
create_pending_snapshot+0x5a6/0x9b0 [btrfs]
[610194.395943]  [<ffffffffc03ecb19>] create_pending_snapshots+0x89/0xb0 [btrfs]
[610194.395955]  [<ffffffffc03ee0ae>]
btrfs_commit_transaction+0x47e/0xa30 [btrfs]
[610194.395970]  [<ffffffffc0423070>] ?
btrfs_mksubvol.isra.28+0x310/0x550 [btrfs]
[610194.395983]  [<ffffffffc0423297>] btrfs_mksubvol.isra.28+0x537/0x550 [btrfs]
[610194.395987]  [<ffffffff810b4e10>] ? prepare_to_wait_event+0x110/0x110
[610194.395999]  [<ffffffffc0423436>]
btrfs_ioctl_snap_create_transid+0x186/0x190 [btrfs]
[610194.396011]  [<ffffffffc0423596>]
btrfs_ioctl_snap_create_v2+0xe6/0x140 [btrfs]
[610194.396024]  [<ffffffffc04259de>] btrfs_ioctl+0xfbe/0x2ac0 [btrfs]
[610194.396028]  [<ffffffff811fbe83>] ? path_openat+0x93/0x5a0
[610194.396032]  [<ffffffff81061eba>] ? __do_page_fault+0x1ea/0x5b0
[610194.396035]  [<ffffffff811ffbf8>] do_vfs_ioctl+0x2f8/0x510
[610194.396038]  [<ffffffff811fc3b6>] ? final_putname+0x26/0x50
[610194.396041]  [<ffffffff811fc659>] ? putname+0x29/0x40
[610194.396043]  [<ffffffff811ffe91>] SyS_ioctl+0x81/0xa0
[610194.396047]  [<ffffffff817b688d>] system_call_fastpath+0x16/0x1b
[610194.396049] ---[ end trace 8477fc3336b22b20 ]---
[610194.396075] BTRFS: error (device loop1) in
create_pending_snapshot:1392: errno=-2 No such entry
[610194.396186] BTRFS info (device loop1): forced readonly
[610194.396189] BTRFS warning (device loop1): Skipping commit of
aborted transaction.
[610194.396191] BTRFS: error (device loop1) in
cleanup_transaction:1670: errno=-2 No such entry
[610194.396290] BTRFS info (device loop1): delayed_refs has NO entry

and the version and btrfs info:

$> uname -a
Linux 1987d92f-d5e0-479c-8744-bb9dca7a28a1 3.19.0-26-generic
#28~14.04.1-Ubuntu SMP Wed Aug 12 14:09:17 UTC 2015 x86_64 x86_64
x86_64 GNU/Linux

$> btrfs --version
btrfs-progs v4.1.2

$> btrfs fi show
Label: none  uuid: 13d624be-b162-4794-8edb-82270d68295d
Total devices 1 FS bytes used 5.40GiB
devid    1 size 29.75GiB used 10.04GiB path /dev/loop2

btrfs-progs v4.1.2

$> btrfs fi df /var/vcap/data/garden/btrfs_graph
Data, single: total=6.01GiB, used=4.66GiB
System, DUP: total=8.00MiB, used=16.00KiB
System, single: total=4.00MiB, used=0.00B
Metadata, DUP: total=1.50GiB, used=752.88MiB
Metadata, single: total=8.00MiB, used=0.00B
GlobalReserve, single: total=128.00MiB, used=0.00B

These plus the full dmesg log are available in [1].

Regards,
Glyn Normington & George Lestaris

[1] https://www.dropbox.com/s/v9wc9ampjw0fa8b/btrfs-diagnostics.txt?dl=1
[2] https://www.pivotaltracker.com/story/show/103489222
