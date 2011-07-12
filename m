From: "Morten P.D. Stevens" <mstevens@imt-systems.com>
Subject: Re: Lockdep warning in btrfs_clear_lock_blocking
Date: Tue, 12 Jul 2011 16:14:52 +0200
Message-ID: <CAKSJeFLRuV=SZtMciqOUuMoL37RLGrCii_s-zGWPL8mFRLHuog@mail.gmail.com>
References: <20110510124447.GP12709@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: dave@jikos.cz, chris.mason@oracle.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110510124447.GP12709@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

2011/5/10 David Sterba <dave@jikos.cz>
>
> Hi,
>
> I've hit this lockdep warning, 2.6.39rc6. Single btrfs partition, 30GB,
> filled with 2GB, "compress-force=lzo", warning trigered after normal copy+du.
> Happened only once.
>
> [Might be a false positive.]

Hi,

I have a similar error with 3.0-rc6.

OS: Fedora 15
Kernel: 3.0-0.rc6.git6.1.fc16.x86_64

Jul 12 15:44:13 x86-002 kernel: [ 1294.229850]
Jul 12 15:44:13 x86-002 kernel: [ 1294.229852]
=============================================
Jul 12 15:44:13 x86-002 kernel: [ 1294.230298] [ INFO: possible
recursive locking detected ]
Jul 12 15:44:13 x86-002 kernel: [ 1294.230443] 3.0-0.rc6.git6.1.fc16.x86_64 #1
Jul 12 15:44:13 x86-002 kernel: [ 1294.230443]
---------------------------------------------
Jul 12 15:44:13 x86-002 kernel: [ 1294.230443] mv/1289 is trying to
acquire lock:
Jul 12 15:44:13 x86-002 kernel: [ 1294.230443]
(&(&eb->lock)->rlock){+.+...}, at: [<ffffffffa01b84cc>]
btrfs_try_spin_lock+0x27/0x83 [btrfs]
Jul 12 15:44:13 x86-002 kernel: [ 1294.230443]
Jul 12 15:44:13 x86-002 kernel: [ 1294.230443] but task is already holding lock:
Jul 12 15:44:13 x86-002 kernel: [ 1294.230443]
(&(&eb->lock)->rlock){+.+...}, at: [<ffffffffa01b849c>]
btrfs_clear_lock_blocking+0x1f/0x28 [btrfs]
Jul 12 15:44:13 x86-002 kernel: [ 1294.230443]
Jul 12 15:44:13 x86-002 kernel: [ 1294.230443] other info that might
help us debug this:
Jul 12 15:44:13 x86-002 kernel: [ 1294.230443]  Possible unsafe
locking scenario:
Jul 12 15:44:13 x86-002 kernel: [ 1294.230443]
Jul 12 15:44:13 x86-002 kernel: [ 1294.230443]        CPU0
Jul 12 15:44:13 x86-002 kernel: [ 1294.230443]        ----
Jul 12 15:44:13 x86-002 kernel: [ 1294.230443]   lock(&(&eb->lock)->rlock);
Jul 12 15:44:13 x86-002 kernel: [ 1294.230443]   lock(&(&eb->lock)->rlock);
Jul 12 15:44:13 x86-002 kernel: [ 1294.230443]
Jul 12 15:44:13 x86-002 kernel: [ 1294.230443]  *** DEADLOCK ***
Jul 12 15:44:13 x86-002 kernel: [ 1294.230443]
Jul 12 15:44:13 x86-002 kernel: [ 1294.230443]  May be due to missing
lock nesting notation
Jul 12 15:44:13 x86-002 kernel: [ 1294.230443]
Jul 12 15:44:13 x86-002 kernel: [ 1294.230443] 1 lock held by mv/1289:
Jul 12 15:44:13 x86-002 kernel: [ 1294.230443]  #0:
(&(&eb->lock)->rlock){+.+...}, at: [<ffffffffa01b849c>]
btrfs_clear_lock_blocking+0x1f/0x28 [btrfs]
Jul 12 15:44:13 x86-002 kernel: [ 1294.230443]
Jul 12 15:44:13 x86-002 kernel: [ 1294.230443] stack backtrace:
Jul 12 15:44:13 x86-002 kernel: [ 1294.230443] Pid: 1289, comm: mv Not
tainted 3.0-0.rc6.git6.1.fc16.x86_64 #1
Jul 12 15:44:13 x86-002 kernel: [ 1294.230443] Call Trace:
Jul 12 15:44:13 x86-002 kernel: [ 1294.230443]  [<ffffffff81088c6d>]
__lock_acquire+0x917/0xcf7
Jul 12 15:44:13 x86-002 kernel: [ 1294.230443]  [<ffffffff8100e9ad>] ?
paravirt_read_tsc+0x9/0xd
Jul 12 15:44:13 x86-002 kernel: [ 1294.230443]  [<ffffffff8100ee82>] ?
sched_clock+0x9/0xd
Jul 12 15:44:13 x86-002 kernel: [ 1294.230443]  [<ffffffff8107a44d>] ?
sched_clock_local+0x12/0x75
Jul 12 15:44:13 x86-002 kernel: [ 1294.230443]  [<ffffffffa01b849c>] ?
btrfs_clear_lock_blocking+0x1f/0x28 [btrfs]
Jul 12 15:44:13 x86-002 kernel: [ 1294.230443]  [<ffffffffa01b84cc>] ?
btrfs_try_spin_lock+0x27/0x83 [btrfs]
Jul 12 15:44:13 x86-002 kernel: [ 1294.230443]  [<ffffffff810894da>]
lock_acquire+0xbf/0x103
Jul 12 15:44:13 x86-002 kernel: [ 1294.230443]  [<ffffffffa01b84cc>] ?
btrfs_try_spin_lock+0x27/0x83 [btrfs]
Jul 12 15:44:13 x86-002 kernel: [ 1294.230443]  [<ffffffff814f61e8>]
_raw_spin_lock+0x36/0x6a
Jul 12 15:44:13 x86-002 kernel: [ 1294.230443]  [<ffffffffa01b84cc>] ?
btrfs_try_spin_lock+0x27/0x83 [btrfs]
Jul 12 15:44:13 x86-002 kernel: [ 1294.230443]  [<ffffffffa01b849c>] ?
btrfs_clear_lock_blocking+0x1f/0x28 [btrfs]
Jul 12 15:44:13 x86-002 kernel: [ 1294.230443]  [<ffffffffa01b84cc>]
btrfs_try_spin_lock+0x27/0x83 [btrfs]
Jul 12 15:44:13 x86-002 kernel: [ 1294.230443]  [<ffffffffa0178d30>]
btrfs_search_slot+0x37b/0x499 [btrfs]
Jul 12 15:44:13 x86-002 kernel: [ 1294.230443]  [<ffffffffa0186a3a>]
btrfs_lookup_csum+0x68/0x10a [btrfs]
Jul 12 15:44:13 x86-002 kernel: [ 1294.230443]  [<ffffffffa0186c59>]
__btrfs_lookup_bio_sums+0x17d/0x2e2 [btrfs]
Jul 12 15:44:13 x86-002 kernel: [ 1294.230443]  [<ffffffffa0186e0e>]
btrfs_lookup_bio_sums+0x16/0x18 [btrfs]
Jul 12 15:44:13 x86-002 kernel: [ 1294.230443]  [<ffffffffa01917b3>]
btrfs_submit_bio_hook+0x9b/0x111 [btrfs]
Jul 12 15:44:13 x86-002 kernel: [ 1294.230443]  [<ffffffffa01a9137>]
submit_one_bio+0x92/0xca [btrfs]
Jul 12 15:44:13 x86-002 kernel: [ 1294.230443]  [<ffffffffa01ac752>]
extent_readpages+0xbf/0xd0 [btrfs]
Jul 12 15:44:13 x86-002 kernel: [ 1294.230443]  [<ffffffffa0192aeb>] ?
uncompress_inline+0x11e/0x11e [btrfs]
Jul 12 15:44:13 x86-002 kernel: [ 1294.230443]  [<ffffffffa019260c>]
btrfs_readpages+0x1f/0x21 [btrfs]
Jul 12 15:44:13 x86-002 kernel: [ 1294.230443]  [<ffffffff810f2ff7>]
__do_page_cache_readahead+0x158/0x1de
Jul 12 15:44:13 x86-002 kernel: [ 1294.230443]  [<ffffffff810f32e6>]
ra_submit+0x21/0x25
Jul 12 15:44:13 x86-002 kernel: [ 1294.230443]  [<ffffffff810f34d8>]
ondemand_readahead+0x1ee/0x1fd
Jul 12 15:44:13 x86-002 kernel: [ 1294.230443]  [<ffffffff810f35a9>]
page_cache_sync_readahead+0x40/0x43
Jul 12 15:44:13 x86-002 kernel: [ 1294.230443]  [<ffffffff810eb1e7>]
generic_file_aio_read+0x2b9/0x65b
Jul 12 15:44:13 x86-002 kernel: [ 1294.230443]  [<ffffffff811377ba>]
do_sync_read+0xbf/0xff
Jul 12 15:44:13 x86-002 kernel: [ 1294.230443]  [<ffffffff8120d5c2>] ?
security_file_permission+0x2e/0x33
Jul 12 15:44:13 x86-002 kernel: [ 1294.230443]  [<ffffffff81137af1>] ?
rw_verify_area+0xb6/0xd3
Jul 12 15:44:13 x86-002 kernel: [ 1294.230443]  [<ffffffff81137e7e>]
vfs_read+0xac/0xf3
Jul 12 15:44:13 x86-002 kernel: [ 1294.230443]  [<ffffffff8113928a>] ?
fget_light+0x3a/0xa2
Jul 12 15:44:13 x86-002 kernel: [ 1294.230443]  [<ffffffff81137f12>]
sys_read+0x4d/0x74
Jul 12 15:44:13 x86-002 kernel: [ 1294.230443]  [<ffffffff814fd5c2>]
system_call_fastpath+0x16/0x1b
Jul 12 15:44:37 x86-002 kernel: [ 1319.205483] flush-btrfs-1 used
greatest stack depth: 2856 bytes left

Best regards,

Morten
