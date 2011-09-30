From: Stephane Chazelas <stephane_chazelas@yahoo.fr>
Subject: Re: high CPU usage and low perf
Date: Fri, 30 Sep 2011 09:46:44 +0100
Message-ID: <20110930084644.GB4234@yahoo.fr>
References: <20110927091509.GA4149@yahoo.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110927091509.GA4149@yahoo.fr>
List-ID: <linux-btrfs.vger.kernel.org>

2011-09-27 10:15:09 +0100, Stephane Chazelas:
[...]
> btrfs-transacti R  running task        0   963      2 0x00000000
>  ffff880143af7730 ffffffff00000001 ffffffffffffff10 ffff880143af77b0
>  ffff8801456da420 ffffffffffffffff 00000000e86aa840 0000000000001000
>  00000000ffffffe4 ffff8801462ba800 ffff880109f9b540 000088002a95eba8
> Call Trace:
>  [<ffffffffa032765e>] ? tree_search_offset+0x18f/0x1b8 [btrfs]
>  [<ffffffffa02eb745>] ? btrfs_reserve_extent+0xb0/0x190 [btrfs]
>  [<ffffffffa02ebdfc>] ? btrfs_alloc_free_block+0x22e/0x349 [btrfs]
>  [<ffffffffa02dea3d>] ? __btrfs_cow_block+0x102/0x31e [btrfs]
>  [<ffffffffa02ebdfc>] ? btrfs_alloc_free_block+0x22e/0x349 [btrfs]
>  [<ffffffffa02dea3d>] ? __btrfs_cow_block+0x102/0x31e [btrfs]
>  [<ffffffffa02dd400>] ? btrfs_set_node_key+0x1a/0x20 [btrfs]
>  [<ffffffffa02ded5d>] ? btrfs_cow_block+0x104/0x14e [btrfs]
>  [<ffffffffa02e1c34>] ? btrfs_search_slot+0x162/0x4cb [btrfs]
>  [<ffffffffa02e2ea3>] ? btrfs_insert_empty_items+0x6a/0xba [btrfs]
>  [<ffffffffa02e9bf3>] ? run_clustered_refs+0x370/0x682 [btrfs]
>  [<ffffffffa032d201>] ? btrfs_find_ref_cluster+0xd/0x13c [btrfs]
>  [<ffffffffa02e9fd6>] ? btrfs_run_delayed_refs+0xd1/0x17c [btrfs]
>  [<ffffffffa02f8467>] ? btrfs_commit_transaction+0x38f/0x709 [btrfs]
>  [<ffffffff8136f6e6>] ? _raw_spin_lock+0xe/0x10
>  [<ffffffffa02f79fe>] ? join_transaction.clone.23+0xc1/0x200 [btrfs]
[...]

Any idea anyone? The above suggests btrfs struggles to allocate
space, even though the FS is only 66% full.

For now, my work around is to reboot the system once a day. Not
ideal...

I'm also suspecting some data corruption which I'm investigating
now (one a file written via mmap()).

Thanks,
Stephane
