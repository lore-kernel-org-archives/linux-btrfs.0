From: Chris Mason <chris.mason@oracle.com>
Subject: Re: yum upgrade on btrfs very slow
Date: Mon, 28 Sep 2009 09:35:43 -0400
Message-ID: <20090928133543.GB6405@think>
References: <20090928121827.GA15930@mother.pipebreaker.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Tomasz Torcz <tomek@pipebreaker.pl>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090928121827.GA15930@mother.pipebreaker.pl>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 28, 2009 at 02:18:27PM +0200, Tomasz Torcz wrote:
> 
>   Hi,
> 
>  I'm using btrfs as rootfs on my Fedora 12 (rawhide) test system.
> Every yum activity is very slow, like 15 minutes for installation of 11
> packages 25MB in size. Kernel is 2.6.31.1-48.fc12.x86_64, btrfs-progs-0.19-7.fc12.x86_64.
> Hardware is pentium 4 3.0 GHz (Hyperthreading, 64 bit), with single IDE disk 
> on Intel ICH controller.

You're doing quite a lot of reads, and some writes.  Could you please
capture the output of sysrq-w at 5s intervals during the upgrade?

-chris

> 
> /dev/sda2 on / type btrfs (rw)
> 
> /dev/sda2              19G  6,7G   13G  36% /
> 
>   Attached is output from vmstat 1 during yum transaction. I also
> have 200MB of "perf record" output, which I can drill down. First screen
> of profile is below:
> 
> # Samples: 9024736
> #
> # Overhead          Command                                         Shared Object  Symbol
> # ........  ...............  ....................................................  ......
> #
>     15.44%  perf.2.6.31-33.  [kernel]                                              [k] kmem_cache_open
>      9.74%  perf.2.6.31-33.  [kernel]                                              [k] print_lock_contention_bug
>      6.34%  perf.2.6.31-33.  [kernel]                                              [k] free_kmem_cache_cpus
>      4.49%  perf.2.6.31-33.  [kernel]                                              [k] is_module_text_address
>      4.01%  perf.2.6.31-33.  [kernel]                                              [k] lock_set_class
>      3.45%  yum-complete-tr  [kernel]                                              [k] print_lock_contention_bug
>      2.50%  perf.2.6.31-33.  [kernel]                                              [k] _spin_lock
>      2.48%  yum-complete-tr  [kernel]                                              [k] kmem_cache_open
>      2.47%  perf.2.6.31-33.  [kernel]                                              [k] zlib_tr_flush_block      [zlib_deflate]
>      1.65%  yum-complete-tr  [kernel]                                              [k] lock_set_class
>      1.62%  perf.2.6.31-33.  [kernel]                                              [k] schedule_hrtimeout_range
>      1.53%  perf.2.6.31-33.  [kernel]                                              [k] sysfs_slab_add
>      1.50%  yum-complete-tr  [kernel]                                              [k] zlib_tr_flush_block      [zlib_deflate]
>      1.46%  yum-complete-tr  [kernel]                                              [k] free_kmem_cache_cpus
>      1.40%  yum-complete-tr  [kernel]                                              [k] _spin_lock
>      1.34%  perf.2.6.31-33.  [kernel]                                              [k] __mutex_lock_common
>      1.27%  perf.2.6.31-33.  [kernel]                                              [k] btrfs_getxattr   [btrfs]
>      1.06%  perf.2.6.31-33.  [kernel]                                              [k] lock_contended
>      0.78%  perf.2.6.31-33.  [kernel]                                              [k] _raw_read_unlock
>      0.75%  perf.2.6.31-33.  [kernel]                                              [k] btrfs_listxattr  [btrfs]
>      0.74%  perf.2.6.31-33.  [kernel]                                              [k] run_scheduled_bios       [btrfs]
>      0.62%  perf.2.6.31-33.  [kernel]                                              [k] lockdep_count_backward_deps
>      0.61%  perf.2.6.31-33.  [kernel]                                              [k] show_slab_objects
>      0.58%  yum-complete-tr  [kernel]                                              [k] sysfs_slab_add
>      0.48%  yum-complete-tr  /usr/lib64/libpython2.6.so.1.0                        [.] 0x0000000005dab0
>      0.46%  yum-complete-tr  [kernel]                                              [k] btrfs_listxattr  [btrfs]
>      0.45%  yum-complete-tr  /usr/lib64/librpm.so.0.0.0                            [.] 0x0000000004877f
>      0.44%  perf.2.6.31-33.  [kernel]                                              [k] idr_for_each
>      0.44%  perf.2.6.31-33.  [kernel]                                              [k] clear_lock_stats
>      0.44%  yum-complete-tr  [kernel]                                              [k] lock_contended
>      0.43%  perf.2.6.31-33.  [kernel]                                              [k] btrfs_iget       [btrfs]
>      0.41%  yum-complete-tr  [kernel]                                              [k] is_module_text_address
>      0.37%  yum-complete-tr  /usr/lib64/libpython2.6.so.1.0                        [.] PyEval_EvalFrameEx
>      0.36%  yum-complete-tr  [kernel]                                              [k] run_scheduled_bios       [btrfs]
>      0.36%  yum-complete-tr  [kernel]                                              [k] show_slab_objects
>      0.33%  perf.2.6.31-33.  [kernel]                                              [k] lock_acquire
>      0.33%  perf.2.6.31-33.  [kernel]                                              [k] __module_text_address
>      0.29%  yum-complete-tr  [kernel]                                              [k] btrfs_getxattr   [btrfs]
>      0.28%         ldconfig  [kernel]                                              [k] free_kmem_cache_cpus
>      0.27%  perf.2.6.31-33.  [kernel]                                              [k] btrfs_set_device_sector_size     [btrfs]
>      0.26%  yum-complete-tr  [kernel]                                              [k] _raw_read_unlock
>      0.25%  perf.2.6.31-33.  [kernel]                                              [k] _spin_lock_bh
>      0.25%  yum-complete-tr  [kernel]                                              [k] btrfs_drop_extents       [btrfs]
>      0.23%  perf.2.6.31-33.  [kernel]                                              [k] btrfs_comp_cpu_keys      [btrfs]
>      0.23%  yum-complete-tr  /lib64/libc-2.10.90.so                                [.] __GI_memcpy
> 
> 
> 
> -- 
> Tomasz Torcz                                                       72->|   80->|
> xmpp: zdzichubg@chrome.pl                                          72->|   80->|
> 

