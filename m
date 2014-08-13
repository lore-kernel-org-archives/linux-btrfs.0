Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.vavmaster.de ([148.251.133.103]:56006 "EHLO
	mail.vavmaster.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607AbaHMR06 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Aug 2014 13:26:58 -0400
Received: from [176.195.77.16] (helo=stakan.localnet)
	by mail.vavmaster.de with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.83)
	(envelope-from <v@piratweb.com>)
	id 1XHba0-000870-Uy
	for linux-btrfs@vger.kernel.org; Wed, 13 Aug 2014 18:39:17 +0200
From: Valdis Voronin <v@piratweb.com>
To: linux-btrfs@vger.kernel.org
Subject: Welcome to linux-btrfs
Date: Wed, 13 Aug 2014 20:39:15 +0400
Message-ID: <2553353.cJGYBglVXM@stakan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I am using here Debian Jessie whith classic Raid1 mdadm, with two ssd devices 
(Crucial_CT256MX100SSD1) and btrfs 3.14-2-amd64 #1 SMP Debian 3.14.13-2 
(2014-07-24) x86_64 GNU/Linux.
The server under load. After some days or a week is see in messages (log files, 
see below.).
The server is not freeze but works not correctly. There are no possibility to 
reboot.
Is this a bug? May be somebody has an ider for mount options or kernel 
upgrade?

cat > fstab

/dev/md/2 / btrfs defaults 0 0


Regards
Vladislav

cat > messages

Aug 12 06:25:45 srv1 rsyslogd: [origin software="rsyslogd" swVersion="7.6.3" 
x-pid="1676" x-info="http://www.rsyslog.com"] rsyslogd was HUPed
Aug 12 06:28:36 srv1 rsyslogd-2359: action 'action 17' resumed (module 
'builtin:ompipe') [try http://www.rsyslog.com/e/2359 ]
Aug 12 07:02:04 srv1 rsyslogd-2007: action 'action 17' suspended, next retry 
is Tue Aug 12 07:02:34 2014 [try http://www.rsyslog.com/e/2007 ]
Aug 12 09:03:41 srv1 kernel: [163223.598939] mysqld          D ffff88040b2a2e38     
0 11941   4011 0x00000000
Aug 12 09:03:41 srv1 kernel: [163223.598941]  ffff88040b2a2a20 0000000000000086 
0000000000014380 ffff880428eeffd8
Aug 12 09:03:41 srv1 kernel: [163223.598943]  0000000000014380 ffff88040b2a2a20 
ffff88081ea54c10 ffff88081edc7608
Aug 12 09:03:41 srv1 kernel: [163223.598944]  0000000000000002 ffffffff81121000 
ffff880428eef6d0 ffff880428eef7b0
Aug 12 09:03:41 srv1 kernel: [163223.598946] Call Trace:
Aug 12 09:03:41 srv1 kernel: [163223.598950]  [<ffffffff81121000>] ? 
wait_on_page_read+0x60/0x60
Aug 12 09:03:41 srv1 kernel: [163223.598954]  [<ffffffff814c7e34>] ? 
io_schedule+0x94/0x130 
Aug 12 09:03:41 srv1 kernel: [163223.598955]  [<ffffffff81121005>] ? 
sleep_on_page+0x5/0x10
Aug 12 09:03:41 srv1 kernel: [163223.598956]  [<ffffffff814c81a4>] ? 
__wait_on_bit+0x54/0x80
Aug 12 09:03:41 srv1 kernel: [163223.598960]  [<ffffffff8109f510>] ? 
autoremove_wake_function+0x30/0x30
Aug 12 09:03:41 srv1 kernel: [163223.598965]  [<ffffffff811345b7>] ? 
shrink_inactive_list+0x187/0x4d0
Aug 12 09:03:41 srv1 kernel: [163223.598968]  [<ffffffff811352de>] ? 
shrink_zone+0x5e/0x180
Aug 12 09:03:41 srv1 kernel: [163223.598971]  [<ffffffff81135e45>] ? 
try_to_free_mem_cgroup_pages+0xc5/0x150
Aug 12 09:03:41 srv1 kernel: [163223.598975]  [<ffffffff8117f82f>] ? 
__mem_cgroup_try_charge+0x55f/0x6a0
Aug 12 09:03:41 srv1 kernel: [163223.598990]  [<ffffffff8117ffdd>] ? 
mem_cgroup_charge_common+0x3d/0x90
Aug 12 09:03:41 srv1 kernel: [163223.598995]  [<ffffffff81121d41>] ? 
add_to_page_cache_lru+0x11/0x40
Aug 12 09:03:41 srv1 kernel: [163223.599002]  [<ffffffffa023f80e>] ? 
prepare_pages.isra.19+0xae/0x170 [btrfs]
Aug 12 09:03:41 srv1 kernel: [163223.599012]  [<ffffffffa0240925>] ? 
btrfs_file_aio_write+0x215/0x550 [btrfs]
Aug 12 09:03:41 srv1 kernel: [163223.599015]  [<ffffffff811876a7>] ? 
do_sync_write+0x57/0x90
Aug 12 09:03:41 srv1 kernel: [163223.599018]  [<ffffffff8118876d>] ? 
SyS_write+0x3d/0xa0
Aug 12 09:03:41 srv1 kernel: [163223.599054]  ffff8807f6a1b1f0 0000000000000086 
0000000000014380 ffff88053c2c3fd8
Aug 12 09:03:41 srv1 kernel: [163223.599057]  0000000000000002 ffffffff81121000 
ffff88053c2c3650 ffff88053c2c3730
Aug 12 09:03:41 srv1 kernel: [163223.599059]  [<ffffffff81121000>] ? 
wait_on_page_read+0x60/0x60
Aug 12 09:03:41 srv1 kernel: [163223.599062]  [<ffffffff81121005>] ? 
sleep_on_page+0x5/0x10
Aug 12 09:03:41 srv1 kernel: [163223.599064]  [<ffffffff81120e0f>] ? 
wait_on_page_bit+0x7f/0x90 
Aug 12 09:03:41 srv1 kernel: [163223.599067]  [<ffffffff81133bb7>] ? 
shrink_page_list+0x667/0xa50   
Aug 12 09:03:41 srv1 kernel: [163223.599069]  [<ffffffff81134f69>] ? 
shrink_lruvec+0x2e9/0x600
Aug 12 09:03:41 srv1 kernel: [163223.599072]  [<ffffffff811357a0>] ? 
do_try_to_free_pages+0xe0/0x550
Aug 12 09:03:41 srv1 kernel: [163223.599076]  [<ffffffff81135e45>] ? 
try_to_free_mem_cgroup_pages+0xc5/0x150
Aug 12 09:03:41 srv1 kernel: [163223.599079]  [<ffffffff8117f82f>] ? 
__mem_cgroup_try_charge+0x55f/0x6a0
Aug 12 09:03:41 srv1 kernel: [163223.599082]  [<ffffffff8117ffdd>] ? 
mem_cgroup_charge_common+0x3d/0x90 
Aug 12 09:03:41 srv1 kernel: [163223.599084]  [<ffffffff81121c0f>] ? 
add_to_page_cache_locked+0x2f/0x150  
Aug 12 09:03:41 srv1 kernel: [163223.599091]  [<ffffffffa024e127>] ? 
extent_readpages+0xb7/0x190 [btrfs]
Aug 12 09:03:41 srv1 kernel: [163223.599098]  [<ffffffff8112d503>] ? 
__do_page_cache_readahead+0x193/0x240
Aug 12 09:03:41 srv1 kernel: [163223.599101]  [<ffffffff811238d9>] ? 
generic_file_aio_read+0x459/0x6d0
Aug 12 09:03:41 srv1 kernel: [163223.599103]  [<ffffffff81187c41>] ? 
vfs_read+0x91/0x160
Aug 12 09:03:41 srv1 kernel: [163223.599106]  [<ffffffff814d2cf9>] ? 
system_call_fastpath+0x16/0x1b
Aug 12 09:03:41 srv1 kernel: [163223.599168] kworker/u16:2   D ffff880730ea0868     
0 27951      2 0x00000000
Aug 12 09:03:41 srv1 kernel: [163223.599172]  ffff880730ea0450 0000000000000046 
0000000000014380 ffff88000721ffd8
Aug 12 09:03:41 srv1 kernel: [163223.599174]  ffff88000721f880 0000000000000002 
ffffffff81121000 ffff8805827e3d98
Aug 12 09:03:41 srv1 kernel: [163223.599176]  [<ffffffff81121000>] ? 
wait_on_page_read+0x60/0x60
Aug 12 09:03:41 srv1 kernel: [163223.599179]  [<ffffffff81121005>] ? 
sleep_on_page+0x5/0x10
Aug 12 09:03:41 srv1 kernel: [163223.599181]  [<ffffffff811210f5>] ? 
__lock_page+0x65/0x70
Aug 12 09:03:41 srv1 kernel: [163223.599189]  [<ffffffffa0248fcd>] ? 
lock_delalloc_pages+0x10d/0x190 [btrfs]
Aug 12 09:03:41 srv1 kernel: [163223.599199]  [<ffffffffa024b95f>] ? 
submit_extent_page.isra.36+0x1af/0x230 [btrfs]
Aug 12 09:03:41 srv1 kernel: [163223.599209]  [<ffffffffa024b640>] ? 
end_extent_writepage+0x90/0x90 [btrfs] 
Aug 12 09:03:41 srv1 kernel: [163223.599215]  [<ffffffffa024ce97>] ? 
extent_write_cache_pages.isra.29.constprop.49+0x207/0x340 [btrfs]
Aug 12 09:03:41 srv1 kernel: [163223.599225]  [<ffffffffa0233960>] ? 
btrfs_submit_direct+0x6b0/0x6b0 [btrfs]
Aug 12 09:03:41 srv1 kernel: [163223.599229]  [<ffffffff811ad63c>] ? 
writeback_sb_inodes+0x19c/0x3d0
Aug 12 09:03:41 srv1 kernel: [163223.599232]  [<ffffffff811adb73>] ? 
wb_writeback+0x243/0x2d0 
Aug 12 09:03:41 srv1 kernel: [163223.599236]  [<ffffffff8101255b>] ? 
__switch_to+0x11b/0x4b0
Aug 12 09:03:41 srv1 kernel: [163223.599240]  [<ffffffff8107a7e6>] ? 
worker_thread+0x116/0x3b0
Aug 12 09:03:41 srv1 kernel: [163223.599243]  [<ffffffff81080a68>] ? 
kthread+0xb8/0xd0
Aug 12 09:03:41 srv1 kernel: [163223.599245]  [<ffffffff814d2c4c>] ? 
ret_from_fork+0x7c/0xb0  
Aug 12 09:05:41 srv1 kernel: [163343.527812] Call Trace:

Grus
Valdis
