From: Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: btrfs hang on brd
Date: Fri, 03 Jun 2011 12:41:18 +0300
Message-ID: <4DE8AC3E.8020908@intel.com>
References: <4DE492B0.9020302@linux.intel.com> <20110601085439.GD12709@twin.jikos.cz> <4DE60F44.6090400@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
To: dave@jikos.cz
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DE60F44.6090400@linux.intel.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 01/06/11 13:07, Adrian Hunter wrote:
> On 01/06/11 11:54, David Sterba wrote:
>> On Tue, May 31, 2011 at 10:03:12AM +0300, Adrian Hunter wrote:
>>> Hi
>>>
>>> I seem to be able to get btrfs reproducibly to
>>> produce warnings and finally hang when running
>>> a stress test on a ramdisk.
>>>
>>> Testing was done using the "integration-test"
>>> branch of btrfs-unstable.  Note that I also tested
>>> v2.6.39 and "integration-test" took much longer to
>>> hang i.e. it is an improvement
>>>
>>> The test script and stack dumps are below.
>>>
>>> Is this a valid test?
>>>
>>> Is it worth me investigating these?
>>
>> I've tried to reproduce myself, but the fsstress utility (taken from
>> latest LTP suite) crashes sometimes and I cannot take it as a proper
>> reproduction. Can you point me to the exact version you used?
>
> The LTP version does not compile properly:
>
> make[4]: Entering directory
> `/home/ahunter/Desktop/Projects/ltp/ltp-full-20110228/testcases/kernel/fs/fsstress'
>
> gcc -g -O2 -g -O2 -fno-strict-aliasing -pipe -Wall  -DNO_XFS
> -I/home/ahunter/Desktop/Projects/ltp/ltp-full-20110228/testcases/kernel/fs/fsstress
> -D_LARGEFILE64_SOURCE -D_GNU_SOURCE -Wno-error -I../../../../include
> -I../../../../include   -L../../../../lib  fsstress.c   -o fsstress
> fsstress.c: In function 'dread_f':
> fsstress.c:1829:2: warning: implicit declaration of function 'memalign'
> fsstress.c:1829:6: warning: assignment makes pointer from integer
> without a cast
> fsstress.c: In function 'dwrite_f':
> fsstress.c:1912:6: warning: assignment makes pointer from integer
> without a cast
> fsstress.c:1844:17: warning: 'diob.d_miniosz' may be used uninitialized
> in this function
> fsstress.c:1844:17: warning: 'diob.d_maxiosz' may be used uninitialized
> in this function
> fsstress.c:1844:17: warning: 'diob.d_mem' may be used uninitialized in
> this function
> fsstress.c: In function 'dread_f':
> fsstress.c:1750:17: warning: 'diob.d_miniosz' may be used uninitialized
> in this function
> fsstress.c:1750:17: warning: 'diob.d_maxiosz' may be used uninitialized
> in this function
> fsstress.c:1750:17: warning: 'diob.d_mem' may be used uninitialized in
> this function
>
>
> I hacked a couple of changes but I need to check them before
> mailing to the ltp-list:
>
>
> From: Adrian Hunter <adrian.hunter@intel.com>
> Date: Wed, 1 Jun 2011 13:01:48 +0300
> Subject: [PATCH] fsstress: quick fix for compile errors
>
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> ---
>   testcases/kernel/fs/fsstress/fsstress.c |    2 ++
>   testcases/kernel/fs/fsstress/global.h   |    1 +
>   2 files changed, 3 insertions(+), 0 deletions(-)
>
> diff --git a/testcases/kernel/fs/fsstress/fsstress.c
> b/testcases/kernel/fs/fsstress/fsstress.c
> index e3b48ea..83c23ed 100644
> --- a/testcases/kernel/fs/fsstress/fsstress.c
> +++ b/testcases/kernel/fs/fsstress/fsstress.c
> @@ -1757,6 +1757,7 @@ dread_f(int opno, long r)
>       struct stat64    stb;
>       int        v;
>
> +    memset(&diob, 0, sizeof(struct dioattr));
>       init_pathname(&f);
>       if (!get_fname(FT_REGFILE, r, &f, NULL, NULL, &v)) {
>           if (v)
> @@ -1851,6 +1852,7 @@ dwrite_f(int opno, long r)
>       struct stat64    stb;
>       int        v;
>
> +    memset(&diob, 0, sizeof(struct dioattr));
>       init_pathname(&f);
>       if (!get_fname(FT_REGFILE, r, &f, NULL, NULL, &v)) {
>           if (v)
> diff --git a/testcases/kernel/fs/fsstress/global.h
> b/testcases/kernel/fs/fsstress/global.h
> index f788395..5ab5d56 100644
> --- a/testcases/kernel/fs/fsstress/global.h
> +++ b/testcases/kernel/fs/fsstress/global.h
> @@ -58,6 +58,7 @@
>   #include <stdlib.h>
>   #include <stdio.h>
>   #include <unistd.h>
> +#include <malloc.h>
>
>   #ifndef O_DIRECT
>   #define O_DIRECT 040000
> --
> 1.7.4.4
>
>
>> (But no warning or hang observed, on top of 3.0-rc1 + cmason/for-linus)
>
> I will try it tonight.

No improvement on 3.0-rc1+ (commit 
5c6cce92bc8aee751aafe82c5d9caf7553226a3d).

Logs follow:


Warnings
--------

[ 2857.023360] WARNING: at fs/btrfs/extent-tree.c:5648 
btrfs_alloc_free_block+0x14e/0x357 [btrfs]()
[ 2857.023364] Hardware name: XPS 8300
[ 2857.023367] Modules linked in: tun btrfs zlib_deflate libcrc32c brd 
fuse cpufreq_ondemand acpi_cpufreq freq_table mperf ip6t_REJECT 
nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables ipv6 uinput 
snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec 
snd_hwdep snd_seq snd_seq_device broadcom snd_pcm snd_timer snd tg3 
iTCO_wdt serio_raw dcdbas iTCO_vendor_support microcode soundcore pcspkr 
snd_page_alloc i2c_i801 joydev usb_storage i915 drm_kms_helper drm 
i2c_algo_bit i2c_core video [last unloaded: scsi_wait_scan]
[ 2857.023431] Pid: 8809, comm: btrfs-endio-wri Not tainted 
3.0.0-rc1-work-2011-06-01-01+ #11
[ 2857.023435] Call Trace:
[ 2857.023461]  [<ffffffff8104db2e>] warn_slowpath_common+0x85/0x9d
[ 2857.023471]  [<ffffffff8104db60>] warn_slowpath_null+0x1a/0x1c
[ 2857.023494]  [<ffffffffa029cc98>] btrfs_alloc_free_block+0x14e/0x357 
[btrfs]
[ 2857.023526]  [<ffffffffa02c75bb>] ? 
map_private_extent_buffer+0xb1/0xd5 [btrfs]
[ 2857.023547]  [<ffffffffa028f99f>] __btrfs_cow_block+0x102/0x31e [btrfs]
[ 2857.023565]  [<ffffffffa028e500>] ? unlock_up+0xd9/0xe4 [btrfs]
[ 2857.023585]  [<ffffffffa028fcbf>] btrfs_cow_block+0x104/0x14e [btrfs]
[ 2857.023604]  [<ffffffffa0292aa0>] btrfs_search_slot+0x162/0x502 [btrfs]
[ 2857.023625]  [<ffffffffa0293d46>] btrfs_insert_empty_items+0x6a/0xba 
[btrfs]
[ 2857.023636]  [<ffffffff81110422>] ? kmem_cache_alloc+0x29/0xf7
[ 2857.023658]  [<ffffffffa02adb39>] 
insert_reserved_file_extent.clone.34+0xad/0x1fc [btrfs]
[ 2857.023680]  [<ffffffffa02c4708>] ? lock_extent_bits+0x5e/0xa8 [btrfs]
[ 2857.023701]  [<ffffffffa02b0772>] 
btrfs_endio_direct_write+0x171/0x29a [btrfs]
[ 2857.023719]  [<ffffffffa02a3afa>] ? end_workqueue_fn+0xf6/0x10e [btrfs]
[ 2857.023728]  [<ffffffff81143d1c>] bio_endio+0x2d/0x2f
[ 2857.023744]  [<ffffffffa02a3b05>] end_workqueue_fn+0x101/0x10e [btrfs]
[ 2857.023766]  [<ffffffffa02cde4d>] worker_loop+0x193/0x4ca [btrfs]
[ 2857.023786]  [<ffffffffa02cdcba>] ? btrfs_queue_worker+0x214/0x214 
[btrfs]
[ 2857.023793]  [<ffffffff81068f4e>] kthread+0x82/0x8a
[ 2857.023801]  [<ffffffff81483664>] kernel_thread_helper+0x4/0x10
[ 2857.023807]  [<ffffffff81068ecc>] ? kthread_worker_fn+0x14b/0x14b
[ 2857.023813]  [<ffffffff81483660>] ? gs_change+0x13/0x13
[ 2857.023818] ---[ end trace 11fa90e2fd0455a5 ]---
[ 2857.023835] ------------[ cut here ]------------
[ 2857.023851] WARNING: at fs/btrfs/extent-tree.c:5648 
btrfs_alloc_free_block+0x14e/0x357 [btrfs]()
[ 2857.023856] Hardware name: XPS 8300
[ 2857.023859] Modules linked in: tun btrfs zlib_deflate libcrc32c brd 
fuse cpufreq_ondemand acpi_cpufreq freq_table mperf ip6t_REJECT 
nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables ipv6 uinput 
snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec 
snd_hwdep snd_seq snd_seq_device broadcom snd_pcm snd_timer snd tg3 
iTCO_wdt serio_raw dcdbas iTCO_vendor_support microcode soundcore pcspkr 
snd_page_alloc i2c_i801 joydev usb_storage i915 drm_kms_helper drm 
i2c_algo_bit i2c_core video [last unloaded: scsi_wait_scan]
[ 2857.023948] Pid: 8833, comm: btrfs-endio-wri Tainted: G        W 
3.0.0-rc1-work-2011-06-01-01+ #11
[ 2857.023953] Call Trace:
[ 2857.023959]  [<ffffffff8104db2e>] warn_slowpath_common+0x85/0x9d
[ 2857.023966]  [<ffffffff8104db60>] warn_slowpath_null+0x1a/0x1c
[ 2857.023982]  [<ffffffffa029cc98>] btrfs_alloc_free_block+0x14e/0x357 
[btrfs]
[ 2857.023989]  [<ffffffff81041344>] ? 
update_stats_wait_end.clone.74+0x6a/0xad
[ 2857.024002]  [<ffffffffa028f99f>] __btrfs_cow_block+0x102/0x31e [btrfs]
[ 2857.024015]  [<ffffffffa028e500>] ? unlock_up+0xd9/0xe4 [btrfs]
[ 2857.024028]  [<ffffffffa028fcbf>] btrfs_cow_block+0x104/0x14e [btrfs]
[ 2857.024049]  [<ffffffffa02d295e>] ? btrfs_spin_on_block+0x55/0x55 [btrfs]
[ 2857.024062]  [<ffffffffa0292aa0>] btrfs_search_slot+0x162/0x502 [btrfs]
[ 2857.024068]  [<ffffffff8110f8e8>] ? 
slab_pre_alloc_hook.clone.33+0x2d/0x31
[ 2857.024086]  [<ffffffffa02a0e16>] btrfs_lookup_file_extent+0x3c/0x3e 
[btrfs]
[ 2857.024099]  [<ffffffffa028f13c>] ? btrfs_alloc_path+0x1a/0x2b [btrfs]
[ 2857.024119]  [<ffffffffa02b684d>] btrfs_drop_extents+0x10e/0x731 [btrfs]
[ 2857.024127]  [<ffffffff8103d050>] ? need_resched+0x23/0x2d
[ 2857.024134]  [<ffffffff8147a88e>] ? _cond_resched+0xe/0x22
[ 2857.024140]  [<ffffffff8110f8e8>] ? 
slab_pre_alloc_hook.clone.33+0x2d/0x31
[ 2857.024146]  [<ffffffff81110422>] ? kmem_cache_alloc+0x29/0xf7
[ 2857.024165]  [<ffffffffa02adafc>] 
insert_reserved_file_extent.clone.34+0x70/0x1fc [btrfs]
[ 2857.024187]  [<ffffffffa02c4708>] ? lock_extent_bits+0x5e/0xa8 [btrfs]
[ 2857.024206]  [<ffffffffa02b0772>] 
btrfs_endio_direct_write+0x171/0x29a [btrfs]
[ 2857.024225]  [<ffffffffa02a3afa>] ? end_workqueue_fn+0xf6/0x10e [btrfs]
[ 2857.024232]  [<ffffffff81143d1c>] bio_endio+0x2d/0x2f
[ 2857.024248]  [<ffffffffa02a3b05>] end_workqueue_fn+0x101/0x10e [btrfs]
[ 2857.024269]  [<ffffffffa02cde4d>] worker_loop+0x193/0x4ca [btrfs]
[ 2857.024289]  [<ffffffffa02cdcba>] ? btrfs_queue_worker+0x214/0x214 
[btrfs]
[ 2857.024295]  [<ffffffff81068f4e>] kthread+0x82/0x8a
[ 2857.024301]  [<ffffffff81483664>] kernel_thread_helper+0x4/0x10
[ 2857.024308]  [<ffffffff81068ecc>] ? kthread_worker_fn+0x14b/0x14b
[ 2857.024314]  [<ffffffff81483660>] ? gs_change+0x13/0x13
[ 2857.024318] ---[ end trace 11fa90e2fd0455a6 ]---
[ 2857.024374] ------------[ cut here ]------------
[ 2857.024390] WARNING: at fs/btrfs/extent-tree.c:5648 
btrfs_alloc_free_block+0x14e/0x357 [btrfs]()
[ 2857.024395] Hardware name: XPS 8300
[ 2857.024398] Modules linked in: tun btrfs zlib_deflate libcrc32c brd 
fuse cpufreq_ondemand acpi_cpufreq freq_table mperf ip6t_REJECT 
nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables ipv6 uinput 
snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec 
snd_hwdep snd_seq snd_seq_device broadcom snd_pcm snd_timer snd tg3 
iTCO_wdt serio_raw dcdbas iTCO_vendor_support microcode soundcore pcspkr 
snd_page_alloc i2c_i801 joydev usb_storage i915 drm_kms_helper drm 
i2c_algo_bit i2c_core video [last unloaded: scsi_wait_scan]
[ 2857.024483] Pid: 8809, comm: btrfs-endio-wri Tainted: G        W 
3.0.0-rc1-work-2011-06-01-01+ #11
[ 2857.024487] Call Trace:
[ 2857.024494]  [<ffffffff8104db2e>] warn_slowpath_common+0x85/0x9d
[ 2857.024501]  [<ffffffff8104db60>] warn_slowpath_null+0x1a/0x1c
[ 2857.024517]  [<ffffffffa029cc98>] btrfs_alloc_free_block+0x14e/0x357 
[btrfs]
[ 2857.024538]  [<ffffffffa02c397e>] ? merge_state+0xa6/0x11a [btrfs]
[ 2857.024546]  [<ffffffff8122aef8>] ? rb_insert_color+0xb8/0xe1
[ 2857.024559]  [<ffffffffa028f99f>] __btrfs_cow_block+0x102/0x31e [btrfs]
[ 2857.024579]  [<ffffffffa02c7693>] ? unmap_extent_buffer+0xe/0x10 [btrfs]
[ 2857.024592]  [<ffffffffa028e500>] ? unlock_up+0xd9/0xe4 [btrfs]
[ 2857.024604]  [<ffffffffa028fcbf>] btrfs_cow_block+0x104/0x14e [btrfs]
[ 2857.024617]  [<ffffffffa02920b4>] push_leaf_right+0xc4/0x142 [btrfs]
[ 2857.024635]  [<ffffffffa02c764b>] ? map_extent_buffer+0x6c/0xa6 [btrfs]
[ 2857.024649]  [<ffffffffa0292267>] split_leaf+0x84/0x53c [btrfs]
[ 2857.024661]  [<ffffffffa028e297>] ? btrfs_item_offset_nr+0x19/0x1b 
[btrfs]
[ 2857.024673]  [<ffffffffa028e569>] ? leaf_space_used+0x5e/0x86 [btrfs]
[ 2857.024686]  [<ffffffffa0292d87>] btrfs_search_slot+0x449/0x502 [btrfs]
[ 2857.024700]  [<ffffffffa0293d46>] btrfs_insert_empty_items+0x6a/0xba 
[btrfs]
[ 2857.024707]  [<ffffffff81110422>] ? kmem_cache_alloc+0x29/0xf7
[ 2857.024727]  [<ffffffffa02adb39>] 
insert_reserved_file_extent.clone.34+0xad/0x1fc [btrfs]
[ 2857.024747]  [<ffffffffa02c4708>] ? lock_extent_bits+0x5e/0xa8 [btrfs]
[ 2857.024767]  [<ffffffffa02b0772>] 
btrfs_endio_direct_write+0x171/0x29a [btrfs]
[ 2857.024785]  [<ffffffffa02a3afa>] ? end_workqueue_fn+0xf6/0x10e [btrfs]
[ 2857.024792]  [<ffffffff81143d1c>] bio_endio+0x2d/0x2f
[ 2857.024808]  [<ffffffffa02a3b05>] end_workqueue_fn+0x101/0x10e [btrfs]
[ 2857.024828]  [<ffffffffa02cde4d>] worker_loop+0x193/0x4ca [btrfs]
[ 2857.024848]  [<ffffffffa02cdcba>] ? btrfs_queue_worker+0x214/0x214 
[btrfs]
[ 2857.024855]  [<ffffffff81068f4e>] kthread+0x82/0x8a
[ 2857.024861]  [<ffffffff81483664>] kernel_thread_helper+0x4/0x10
[ 2857.024868]  [<ffffffff81068ecc>] ? kthread_worker_fn+0x14b/0x14b
[ 2857.024875]  [<ffffffff81483660>] ? gs_change+0x13/0x13
[ 2857.024879] ---[ end trace 11fa90e2fd0455a7 ]---
[ 2857.024915] ------------[ cut here ]------------
[ 2857.024936] WARNING: at fs/btrfs/extent-tree.c:5648 
btrfs_alloc_free_block+0x14e/0x357 [btrfs]()
[ 2857.024941] Hardware name: XPS 8300
[ 2857.024944] Modules linked in: tun btrfs zlib_deflate libcrc32c brd 
fuse cpufreq_ondemand acpi_cpufreq freq_table mperf ip6t_REJECT 
nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables ipv6 uinput 
snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec 
snd_hwdep snd_seq snd_seq_device broadcom snd_pcm snd_timer snd tg3 
iTCO_wdt serio_raw dcdbas iTCO_vendor_support microcode soundcore pcspkr 
snd_page_alloc i2c_i801 joydev usb_storage i915 drm_kms_helper drm 
i2c_algo_bit i2c_core video [last unloaded: scsi_wait_scan]
[ 2857.025029] Pid: 8833, comm: btrfs-endio-wri Tainted: G        W 
3.0.0-rc1-work-2011-06-01-01+ #11
[ 2857.025034] Call Trace:
[ 2857.025043]  [<ffffffff8104db2e>] warn_slowpath_common+0x85/0x9d
[ 2857.025050]  [<ffffffff8104db60>] warn_slowpath_null+0x1a/0x1c
[ 2857.025066]  [<ffffffffa029cc98>] btrfs_alloc_free_block+0x14e/0x357 
[btrfs]
[ 2857.025080]  [<ffffffffa028f99f>] __btrfs_cow_block+0x102/0x31e [btrfs]
[ 2857.025093]  [<ffffffffa028e500>] ? unlock_up+0xd9/0xe4 [btrfs]
[ 2857.025106]  [<ffffffffa028fcbf>] btrfs_cow_block+0x104/0x14e [btrfs]
[ 2857.025120]  [<ffffffffa0292aa0>] btrfs_search_slot+0x162/0x502 [btrfs]
[ 2857.025138]  [<ffffffffa02a0e16>] btrfs_lookup_file_extent+0x3c/0x3e 
[btrfs]
[ 2857.025150]  [<ffffffffa028f13c>] ? btrfs_alloc_path+0x1a/0x2b [btrfs]
[ 2857.025172]  [<ffffffffa02b684d>] btrfs_drop_extents+0x10e/0x731 [btrfs]
[ 2857.025179]  [<ffffffff8103d050>] ? need_resched+0x23/0x2d
[ 2857.025188]  [<ffffffff8147a88e>] ? _cond_resched+0xe/0x22
[ 2857.025196]  [<ffffffff8110f8e8>] ? 
slab_pre_alloc_hook.clone.33+0x2d/0x31
[ 2857.025205]  [<ffffffff81110422>] ? kmem_cache_alloc+0x29/0xf7
[ 2857.025231]  [<ffffffffa02adafc>] 
insert_reserved_file_extent.clone.34+0x70/0x1fc [btrfs]
[ 2857.025255]  [<ffffffffa02c4708>] ? lock_extent_bits+0x5e/0xa8 [btrfs]
[ 2857.025278]  [<ffffffffa02b0772>] 
btrfs_endio_direct_write+0x171/0x29a [btrfs]
[ 2857.025304]  [<ffffffffa02a3afa>] ? end_workqueue_fn+0xf6/0x10e [btrfs]
[ 2857.025313]  [<ffffffff81143d1c>] bio_endio+0x2d/0x2f
[ 2857.025336]  [<ffffffffa02a3b05>] end_workqueue_fn+0x101/0x10e [btrfs]
[ 2857.025366]  [<ffffffffa02cde4d>] worker_loop+0x193/0x4ca [btrfs]
[ 2857.025387]  [<ffffffffa02cdcba>] ? btrfs_queue_worker+0x214/0x214 
[btrfs]
[ 2857.025393]  [<ffffffff81068f4e>] kthread+0x82/0x8a
[ 2857.025400]  [<ffffffff81483664>] kernel_thread_helper+0x4/0x10
[ 2857.025406]  [<ffffffff81068ecc>] ? kthread_worker_fn+0x14b/0x14b
[ 2857.025413]  [<ffffffff81483660>] ? gs_change+0x13/0x13
[ 2857.025417] ---[ end trace 11fa90e2fd0455a8 ]---
[ 2857.025527] ------------[ cut here ]------------
[ 2857.025544] WARNING: at fs/btrfs/extent-tree.c:5648 
btrfs_alloc_free_block+0x14e/0x357 [btrfs]()
[ 2857.025549] Hardware name: XPS 8300
[ 2857.025552] Modules linked in: tun btrfs zlib_deflate libcrc32c brd 
fuse cpufreq_ondemand acpi_cpufreq freq_table mperf ip6t_REJECT 
nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables ipv6 uinput 
snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec 
snd_hwdep snd_seq snd_seq_device broadcom snd_pcm snd_timer snd tg3 
iTCO_wdt serio_raw dcdbas iTCO_vendor_support microcode soundcore pcspkr 
snd_page_alloc i2c_i801 joydev usb_storage i915 drm_kms_helper drm 
i2c_algo_bit i2c_core video [last unloaded: scsi_wait_scan]
[ 2857.025633] Pid: 8833, comm: btrfs-endio-wri Tainted: G        W 
3.0.0-rc1-work-2011-06-01-01+ #11
[ 2857.025638] Call Trace:
[ 2857.025645]  [<ffffffff8104db2e>] warn_slowpath_common+0x85/0x9d
[ 2857.025653]  [<ffffffff8104db60>] warn_slowpath_null+0x1a/0x1c
[ 2857.025668]  [<ffffffffa029cc98>] btrfs_alloc_free_block+0x14e/0x357 
[btrfs]
[ 2857.025675]  [<ffffffff81041616>] ? dequeue_task_fair+0x1ca/0x1d9
[ 2857.025688]  [<ffffffffa028f99f>] __btrfs_cow_block+0x102/0x31e [btrfs]
[ 2857.025700]  [<ffffffffa028e500>] ? unlock_up+0xd9/0xe4 [btrfs]
[ 2857.025713]  [<ffffffffa028fcbf>] btrfs_cow_block+0x104/0x14e [btrfs]
[ 2857.025734]  [<ffffffffa02d295e>] ? btrfs_spin_on_block+0x55/0x55 [btrfs]
[ 2857.025754]  [<ffffffffa0292aa0>] btrfs_search_slot+0x162/0x502 [btrfs]
[ 2857.025763]  [<ffffffff8110f8e8>] ? 
slab_pre_alloc_hook.clone.33+0x2d/0x31
[ 2857.025788]  [<ffffffffa02a0e16>] btrfs_lookup_file_extent+0x3c/0x3e 
[btrfs]
[ 2857.025803]  [<ffffffffa028f13c>] ? btrfs_alloc_path+0x1a/0x2b [btrfs]
[ 2857.025824]  [<ffffffffa02b684d>] btrfs_drop_extents+0x10e/0x731 [btrfs]
[ 2857.025830]  [<ffffffff8103d050>] ? need_resched+0x23/0x2d
[ 2857.025836]  [<ffffffff8147a88e>] ? _cond_resched+0xe/0x22
[ 2857.025842]  [<ffffffff8110f8e8>] ? 
slab_pre_alloc_hook.clone.33+0x2d/0x31
[ 2857.025848]  [<ffffffff81110422>] ? kmem_cache_alloc+0x29/0xf7
[ 2857.025867]  [<ffffffffa02adafc>] 
insert_reserved_file_extent.clone.34+0x70/0x1fc [btrfs]
[ 2857.025889]  [<ffffffffa02c4708>] ? lock_extent_bits+0x5e/0xa8 [btrfs]
[ 2857.025909]  [<ffffffffa02b0772>] 
btrfs_endio_direct_write+0x171/0x29a [btrfs]
[ 2857.025926]  [<ffffffffa02a3afa>] ? end_workqueue_fn+0xf6/0x10e [btrfs]
[ 2857.025933]  [<ffffffff81143d1c>] bio_endio+0x2d/0x2f
[ 2857.025949]  [<ffffffffa02a3b05>] end_workqueue_fn+0x101/0x10e [btrfs]
[ 2857.025979]  [<ffffffffa02cde4d>] worker_loop+0x193/0x4ca [btrfs]
[ 2857.026006]  [<ffffffffa02cdcba>] ? btrfs_queue_worker+0x214/0x214 
[btrfs]
[ 2857.026012]  [<ffffffff81068f4e>] kthread+0x82/0x8a
[ 2857.026018]  [<ffffffff81483664>] kernel_thread_helper+0x4/0x10
[ 2857.026022]  [<ffffffff81068ecc>] ? kthread_worker_fn+0x14b/0x14b
[ 2857.026027]  [<ffffffff81483660>] ? gs_change+0x13/0x13
[ 2857.026030] ---[ end trace 11fa90e2fd0455a9 ]---
[ 2857.026053] ------------[ cut here ]------------
[ 2857.026067] WARNING: at fs/btrfs/extent-tree.c:5648 
btrfs_alloc_free_block+0x14e/0x357 [btrfs]()
[ 2857.026070] Hardware name: XPS 8300
[ 2857.026072] Modules linked in: tun btrfs zlib_deflate libcrc32c brd 
fuse cpufreq_ondemand acpi_cpufreq freq_table mperf ip6t_REJECT 
nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables ipv6 uinput 
snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec 
snd_hwdep snd_seq snd_seq_device broadcom snd_pcm snd_timer snd tg3 
iTCO_wdt serio_raw dcdbas iTCO_vendor_support microcode soundcore pcspkr 
snd_page_alloc i2c_i801 joydev usb_storage i915 drm_kms_helper drm 
i2c_algo_bit i2c_core video [last unloaded: scsi_wait_scan]
[ 2857.026112] Pid: 8833, comm: btrfs-endio-wri Tainted: G        W 
3.0.0-rc1-work-2011-06-01-01+ #11
[ 2857.026114] Call Trace:
[ 2857.026119]  [<ffffffff8104db2e>] warn_slowpath_common+0x85/0x9d
[ 2857.026124]  [<ffffffff8104db60>] warn_slowpath_null+0x1a/0x1c
[ 2857.026138]  [<ffffffffa029cc98>] btrfs_alloc_free_block+0x14e/0x357 
[btrfs]
[ 2857.026156]  [<ffffffffa02c75bb>] ? 
map_private_extent_buffer+0xb1/0xd5 [btrfs]
[ 2857.026167]  [<ffffffffa028f99f>] __btrfs_cow_block+0x102/0x31e [btrfs]
[ 2857.026178]  [<ffffffffa028e500>] ? unlock_up+0xd9/0xe4 [btrfs]
[ 2857.026188]  [<ffffffffa028fcbf>] btrfs_cow_block+0x104/0x14e [btrfs]
[ 2857.026199]  [<ffffffffa0292aa0>] btrfs_search_slot+0x162/0x502 [btrfs]
[ 2857.026215]  [<ffffffffa02a0e16>] btrfs_lookup_file_extent+0x3c/0x3e 
[btrfs]
[ 2857.026225]  [<ffffffffa028f13c>] ? btrfs_alloc_path+0x1a/0x2b [btrfs]
[ 2857.026243]  [<ffffffffa02b684d>] btrfs_drop_extents+0x10e/0x731 [btrfs]
[ 2857.026250]  [<ffffffff8103d050>] ? need_resched+0x23/0x2d
[ 2857.026256]  [<ffffffff8147a88e>] ? _cond_resched+0xe/0x22
[ 2857.026262]  [<ffffffff8110f8e8>] ? 
slab_pre_alloc_hook.clone.33+0x2d/0x31
[ 2857.026268]  [<ffffffff81110422>] ? kmem_cache_alloc+0x29/0xf7
[ 2857.026287]  [<ffffffffa02adafc>] 
insert_reserved_file_extent.clone.34+0x70/0x1fc [btrfs]
[ 2857.026309]  [<ffffffffa02c4708>] ? lock_extent_bits+0x5e/0xa8 [btrfs]
[ 2857.026328]  [<ffffffffa02b0772>] 
btrfs_endio_direct_write+0x171/0x29a [btrfs]
[ 2857.026347]  [<ffffffffa02a3afa>] ? end_workqueue_fn+0xf6/0x10e [btrfs]
[ 2857.026354]  [<ffffffff81143d1c>] bio_endio+0x2d/0x2f
[ 2857.026370]  [<ffffffffa02a3b05>] end_workqueue_fn+0x101/0x10e [btrfs]
[ 2857.026390]  [<ffffffffa02cde4d>] worker_loop+0x193/0x4ca [btrfs]
[ 2857.026410]  [<ffffffffa02cdcba>] ? btrfs_queue_worker+0x214/0x214 
[btrfs]
[ 2857.026415]  [<ffffffff81068f4e>] kthread+0x82/0x8a
[ 2857.026422]  [<ffffffff81483664>] kernel_thread_helper+0x4/0x10
[ 2857.026428]  [<ffffffff81068ecc>] ? kthread_worker_fn+0x14b/0x14b
[ 2857.026444]  [<ffffffff81483660>] ? gs_change+0x13/0x13
[ 2857.026448] ---[ end trace 11fa90e2fd0455aa ]---
[ 2857.026481] ------------[ cut here ]------------
[ 2857.026497] WARNING: at fs/btrfs/extent-tree.c:5648 
btrfs_alloc_free_block+0x14e/0x357 [btrfs]()
[ 2857.026502] Hardware name: XPS 8300
[ 2857.026505] Modules linked in: tun btrfs zlib_deflate libcrc32c brd 
fuse cpufreq_ondemand acpi_cpufreq freq_table mperf ip6t_REJECT 
nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables ipv6 uinput 
snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec 
snd_hwdep snd_seq snd_seq_device broadcom snd_pcm snd_timer snd tg3 
iTCO_wdt serio_raw dcdbas iTCO_vendor_support microcode soundcore pcspkr 
snd_page_alloc i2c_i801 joydev usb_storage i915 drm_kms_helper drm 
i2c_algo_bit i2c_core video [last unloaded: scsi_wait_scan]
[ 2857.026584] Pid: 8833, comm: btrfs-endio-wri Tainted: G        W 
3.0.0-rc1-work-2011-06-01-01+ #11
[ 2857.026586] Call Trace:
[ 2857.026589]  [<ffffffff8104db2e>] warn_slowpath_common+0x85/0x9d
[ 2857.026592]  [<ffffffff8104db60>] warn_slowpath_null+0x1a/0x1c
[ 2857.026599]  [<ffffffffa029cc98>] btrfs_alloc_free_block+0x14e/0x357 
[btrfs]
[ 2857.026608]  [<ffffffffa02c75bb>] ? 
map_private_extent_buffer+0xb1/0xd5 [btrfs]
[ 2857.026614]  [<ffffffffa028f99f>] __btrfs_cow_block+0x102/0x31e [btrfs]
[ 2857.026620]  [<ffffffffa028e500>] ? unlock_up+0xd9/0xe4 [btrfs]
[ 2857.026626]  [<ffffffffa028fcbf>] btrfs_cow_block+0x104/0x14e [btrfs]
[ 2857.026632]  [<ffffffffa0292aa0>] btrfs_search_slot+0x162/0x502 [btrfs]
[ 2857.026640]  [<ffffffffa02a0e16>] btrfs_lookup_file_extent+0x3c/0x3e 
[btrfs]
[ 2857.026646]  [<ffffffffa028f13c>] ? btrfs_alloc_path+0x1a/0x2b [btrfs]
[ 2857.026655]  [<ffffffffa02b684d>] btrfs_drop_extents+0x10e/0x731 [btrfs]
[ 2857.026658]  [<ffffffff8103d050>] ? need_resched+0x23/0x2d
[ 2857.026661]  [<ffffffff8147a88e>] ? _cond_resched+0xe/0x22
[ 2857.026663]  [<ffffffff8110f8e8>] ? 
slab_pre_alloc_hook.clone.33+0x2d/0x31
[ 2857.026666]  [<ffffffff81110422>] ? kmem_cache_alloc+0x29/0xf7
[ 2857.026674]  [<ffffffffa02adafc>] 
insert_reserved_file_extent.clone.34+0x70/0x1fc [btrfs]
[ 2857.026684]  [<ffffffffa02c4708>] ? lock_extent_bits+0x5e/0xa8 [btrfs]
[ 2857.026693]  [<ffffffffa02b0772>] 
btrfs_endio_direct_write+0x171/0x29a [btrfs]
[ 2857.026701]  [<ffffffffa02a3afa>] ? end_workqueue_fn+0xf6/0x10e [btrfs]
[ 2857.026704]  [<ffffffff81143d1c>] bio_endio+0x2d/0x2f
[ 2857.026711]  [<ffffffffa02a3b05>] end_workqueue_fn+0x101/0x10e [btrfs]
[ 2857.026721]  [<ffffffffa02cde4d>] worker_loop+0x193/0x4ca [btrfs]
[ 2857.026730]  [<ffffffffa02cdcba>] ? btrfs_queue_worker+0x214/0x214 
[btrfs]
[ 2857.026732]  [<ffffffff81068f4e>] kthread+0x82/0x8a
[ 2857.026735]  [<ffffffff81483664>] kernel_thread_helper+0x4/0x10
[ 2857.026738]  [<ffffffff81068ecc>] ? kthread_worker_fn+0x14b/0x14b
[ 2857.026741]  [<ffffffff81483660>] ? gs_change+0x13/0x13
[ 2857.026742] ---[ end trace 11fa90e2fd0455ab ]---
[ 2863.924897] ------------[ cut here ]------------
[ 2863.924924] WARNING: at fs/btrfs/extent-tree.c:3832 
btrfs_free_block_groups+0x13a/0x228 [btrfs]()
[ 2863.924928] Hardware name: XPS 8300
[ 2863.924930] Modules linked in: tun btrfs zlib_deflate libcrc32c brd 
fuse cpufreq_ondemand acpi_cpufreq freq_table mperf ip6t_REJECT 
nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables ipv6 uinput 
snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec 
snd_hwdep snd_seq snd_seq_device broadcom snd_pcm snd_timer snd tg3 
iTCO_wdt serio_raw dcdbas iTCO_vendor_support microcode soundcore pcspkr 
snd_page_alloc i2c_i801 joydev usb_storage i915 drm_kms_helper drm 
i2c_algo_bit i2c_core video [last unloaded: scsi_wait_scan]
[ 2863.924977] Pid: 8875, comm: umount Tainted: G        W 
3.0.0-rc1-work-2011-06-01-01+ #11
[ 2863.924980] Call Trace:
[ 2863.924988]  [<ffffffff8104db2e>] warn_slowpath_common+0x85/0x9d
[ 2863.924994]  [<ffffffff8104db60>] warn_slowpath_null+0x1a/0x1c
[ 2863.925009]  [<ffffffffa029d9fe>] btrfs_free_block_groups+0x13a/0x228 
[btrfs]
[ 2863.925026]  [<ffffffffa02a68c2>] close_ctree+0x22c/0x346 [btrfs]
[ 2863.925031]  [<ffffffff8103d068>] ? should_resched+0xe/0x2e
[ 2863.925036]  [<ffffffff8147a88e>] ? _cond_resched+0xe/0x22
[ 2863.925040]  [<ffffffff8147b465>] ? down_write+0x29/0x49
[ 2863.925050]  [<ffffffffa028ca1e>] btrfs_put_super+0x1d/0x2c [btrfs]
[ 2863.925056]  [<ffffffff8111ecb8>] generic_shutdown_super+0x74/0xe9
[ 2863.925060]  [<ffffffff8111edad>] kill_anon_super+0x16/0x50
[ 2863.925065]  [<ffffffff8111efda>] deactivate_locked_super+0x26/0x4b
[ 2863.925069]  [<ffffffff8111f7c9>] deactivate_super+0x3a/0x3f
[ 2863.925073]  [<ffffffff81134a0d>] mntput_no_expire+0xd0/0xd5
[ 2863.925076]  [<ffffffff8113568c>] sys_umount+0x2dc/0x30a
[ 2863.925081]  [<ffffffff81125c68>] ? path_put+0x22/0x27
[ 2863.925085]  [<ffffffff81482542>] system_call_fastpath+0x16/0x1b
[ 2863.925089] ---[ end trace 11fa90e2fd0455ac ]---
[ 2863.925091] ------------[ cut here ]------------
[ 2863.925104] WARNING: at fs/btrfs/extent-tree.c:3833 
btrfs_free_block_groups+0x155/0x228 [btrfs]()
[ 2863.925107] Hardware name: XPS 8300
[ 2863.925109] Modules linked in: tun btrfs zlib_deflate libcrc32c brd 
fuse cpufreq_ondemand acpi_cpufreq freq_table mperf ip6t_REJECT 
nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables ipv6 uinput 
snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec 
snd_hwdep snd_seq snd_seq_device broadcom snd_pcm snd_timer snd tg3 
iTCO_wdt serio_raw dcdbas iTCO_vendor_support microcode soundcore pcspkr 
snd_page_alloc i2c_i801 joydev usb_storage i915 drm_kms_helper drm 
i2c_algo_bit i2c_core video [last unloaded: scsi_wait_scan]
[ 2863.925147] Pid: 8875, comm: umount Tainted: G        W 
3.0.0-rc1-work-2011-06-01-01+ #11
[ 2863.925150] Call Trace:
[ 2863.925154]  [<ffffffff8104db2e>] warn_slowpath_common+0x85/0x9d
[ 2863.925159]  [<ffffffff8104db60>] warn_slowpath_null+0x1a/0x1c
[ 2863.925172]  [<ffffffffa029da19>] btrfs_free_block_groups+0x155/0x228 
[btrfs]
[ 2863.925188]  [<ffffffffa02a68c2>] close_ctree+0x22c/0x346 [btrfs]
[ 2863.925193]  [<ffffffff8103d068>] ? should_resched+0xe/0x2e
[ 2863.925196]  [<ffffffff8147a88e>] ? _cond_resched+0xe/0x22
[ 2863.925200]  [<ffffffff8147b465>] ? down_write+0x29/0x49
[ 2863.925209]  [<ffffffffa028ca1e>] btrfs_put_super+0x1d/0x2c [btrfs]
[ 2863.925214]  [<ffffffff8111ecb8>] generic_shutdown_super+0x74/0xe9
[ 2863.925218]  [<ffffffff8111edad>] kill_anon_super+0x16/0x50
[ 2863.925223]  [<ffffffff8111efda>] deactivate_locked_super+0x26/0x4b
[ 2863.925227]  [<ffffffff8111f7c9>] deactivate_super+0x3a/0x3f
[ 2863.925231]  [<ffffffff81134a0d>] mntput_no_expire+0xd0/0xd5
[ 2863.925234]  [<ffffffff8113568c>] sys_umount+0x2dc/0x30a
[ 2863.925238]  [<ffffffff81125c68>] ? path_put+0x22/0x27
[ 2863.925242]  [<ffffffff81482542>] system_call_fastpath+0x16/0x1b
[ 2863.925245] ---[ end trace 11fa90e2fd0455ad ]---
[ 2863.925248] ------------[ cut here ]------------
[ 2863.925261] WARNING: at fs/btrfs/extent-tree.c:6846 
btrfs_free_block_groups+0x1e6/0x228 [btrfs]()
[ 2863.925263] Hardware name: XPS 8300
[ 2863.925265] Modules linked in: tun btrfs zlib_deflate libcrc32c brd 
fuse cpufreq_ondemand acpi_cpufreq freq_table mperf ip6t_REJECT 
nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables ipv6 uinput 
snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec 
snd_hwdep snd_seq snd_seq_device broadcom snd_pcm snd_timer snd tg3 
iTCO_wdt serio_raw dcdbas iTCO_vendor_support microcode soundcore pcspkr 
snd_page_alloc i2c_i801 joydev usb_storage i915 drm_kms_helper drm 
i2c_algo_bit i2c_core video [last unloaded: scsi_wait_scan]
[ 2863.925303] Pid: 8875, comm: umount Tainted: G        W 
3.0.0-rc1-work-2011-06-01-01+ #11
[ 2863.925305] Call Trace:
[ 2863.925310]  [<ffffffff8104db2e>] warn_slowpath_common+0x85/0x9d
[ 2863.925323]  [<ffffffffa029dac8>] ? 
btrfs_free_block_groups+0x204/0x228 [btrfs]
[ 2863.925328]  [<ffffffff8104db60>] warn_slowpath_null+0x1a/0x1c
[ 2863.925341]  [<ffffffffa029daaa>] btrfs_free_block_groups+0x1e6/0x228 
[btrfs]
[ 2863.925356]  [<ffffffffa02a68c2>] close_ctree+0x22c/0x346 [btrfs]
[ 2863.925360]  [<ffffffff8103d068>] ? should_resched+0xe/0x2e
[ 2863.925364]  [<ffffffff8147a88e>] ? _cond_resched+0xe/0x22
[ 2863.925368]  [<ffffffff8147b465>] ? down_write+0x29/0x49
[ 2863.925377]  [<ffffffffa028ca1e>] btrfs_put_super+0x1d/0x2c [btrfs]
[ 2863.925382]  [<ffffffff8111ecb8>] generic_shutdown_super+0x74/0xe9
[ 2863.925386]  [<ffffffff8111edad>] kill_anon_super+0x16/0x50
[ 2863.925391]  [<ffffffff8111efda>] deactivate_locked_super+0x26/0x4b
[ 2863.925395]  [<ffffffff8111f7c9>] deactivate_super+0x3a/0x3f
[ 2863.925398]  [<ffffffff81134a0d>] mntput_no_expire+0xd0/0xd5
[ 2863.925402]  [<ffffffff8113568c>] sys_umount+0x2dc/0x30a
[ 2863.925406]  [<ffffffff81125c68>] ? path_put+0x22/0x27
[ 2863.925410]  [<ffffffff81482542>] system_call_fastpath+0x16/0x1b
[ 2863.925413] ---[ end trace 11fa90e2fd0455ae ]---
[ 2863.925416] space_info has 13627392 free, is full
[ 2863.925419] space_info total=41943040, used=19832832, pinned=0, 
reserved=28672, may_use=0, readonly=8454144



Some btrfs complaints
---------------------

[ 3704.817050] btrfs no csum found for inode 17005 start 1302528
[ 3704.817058] btrfs no csum found for inode 17005 start 1306624
[ 3704.817064] btrfs no csum found for inode 17005 start 1310720
[ 3704.817089] btrfs no csum found for inode 17005 start 1314816
[ 3704.817094] btrfs no csum found for inode 17005 start 1318912
[ 3704.817100] btrfs no csum found for inode 17005 start 1323008
[ 3704.817105] btrfs no csum found for inode 17005 start 1327104
[ 3704.817111] btrfs no csum found for inode 17005 start 1331200
[ 3704.817117] btrfs no csum found for inode 17005 start 1335296
[ 3704.817122] btrfs no csum found for inode 17005 start 1339392
[ 3704.817128] btrfs no csum found for inode 17005 start 1343488
[ 3704.817133] btrfs no csum found for inode 17005 start 1347584
[ 3704.817139] btrfs no csum found for inode 17005 start 1351680
[ 3704.817309] btrfs csum failed ino 17005 off 1302528 csum 451097791 
private 0
[ 3704.817350] btrfs csum failed ino 17005 off 1306624 csum 451097791 
private 0
[ 3704.817377] btrfs csum failed ino 17005 off 1310720 csum 451097791 
private 0
[ 3704.817420] btrfs csum failed ino 17005 off 1314816 csum 978321154 
private 0
[ 3704.817446] btrfs csum failed ino 17005 off 1318912 csum 2566472073 
private 0
[ 3704.817472] btrfs csum failed ino 17005 off 1323008 csum 2566472073 
private 0
[ 3704.817497] btrfs csum failed ino 17005 off 1327104 csum 2566472073 
private 0
[ 3704.817523] btrfs csum failed ino 17005 off 1331200 csum 2566472073 
private 0
[ 3704.817549] btrfs csum failed ino 17005 off 1335296 csum 2566472073 
private 0
[ 3704.817575] btrfs csum failed ino 17005 off 1339392 csum 2566472073 
private 0
[ 3704.817601] btrfs csum failed ino 17005 off 1343488 csum 2566472073 
private 0
[ 3704.817627] btrfs csum failed ino 17005 off 1347584 csum 2566472073 
private 0
[ 3704.817654] btrfs csum failed ino 17005 off 1351680 csum 2779917954 
private 0



Hang
----

[152684.675833] btrfs-transacti D ffff880184e18bd0     0 22322      2 
0x00000080
[152684.675835]  ffff88017c26dd60 0000000000000046 0000000000000000 
ffff880100000001
[152684.675838]  0000000000012540 0000000000012540 0000000000012540 
ffff8801a2524560
[152684.675840]  0000000000012540 ffff88017c26dfd8 0000000000012540 
0000000000012540
[152684.675842] Call Trace:
[152684.675844]  [<ffffffff810696b2>] ? prepare_to_wait+0x6c/0x79
[152684.675856]  [<ffffffffa02a8190>] wait_for_commit.clone.14+0x90/0xd5 
[btrfs]
[152684.675858]  [<ffffffff8106941f>] ? wake_up_bit+0x2a/0x2a
[152684.675866]  [<ffffffffa02a9007>] 
btrfs_commit_transaction+0x102/0x694 [btrfs]
[152684.675874]  [<ffffffffa02a8907>] ? 
join_transaction.clone.20+0x17b/0x186 [btrfs]
[152684.675876]  [<ffffffff8106941f>] ? wake_up_bit+0x2a/0x2a
[152684.675882]  [<ffffffffa02a3764>] transaction_kthread+0x17a/0x22f 
[btrfs]
[152684.675889]  [<ffffffffa02a35ea>] ? btrfs_congested_fn+0x86/0x86 [btrfs]
[152684.675891]  [<ffffffff81068f4e>] kthread+0x82/0x8a
[152684.675893]  [<ffffffff81483664>] kernel_thread_helper+0x4/0x10
[152684.675895]  [<ffffffff81068ecc>] ? kthread_worker_fn+0x14b/0x14b
[152684.675897]  [<ffffffff81483660>] ? gs_change+0x13/0x13
[152684.675898] flush-btrfs-770 D 00000001091bba6c     0 22331      2 
0x00000080
[152684.675900]  ffff88017c19bb10 0000000000000046 ffff88017c19ba70 
ffff880100000000
[152684.675902]  0000000000012540 0000000000012540 0000000000012540 
ffff8801a2525c80
[152684.675905]  0000000000012540 ffff88017c19bfd8 0000000000012540 
0000000000012540
[152684.675907] Call Trace:
[152684.675909]  [<ffffffff8147ab8c>] schedule_timeout+0x36/0xe3
[152684.675912]  [<ffffffff8107c30e>] ? arch_local_irq_save+0x18/0x1e
[152684.675914]  [<ffffffff8147be0f>] ? 
_raw_spin_unlock_irqrestore+0x17/0x19
[152684.675916]  [<ffffffff810696b2>] ? prepare_to_wait+0x6c/0x79
[152684.675923]  [<ffffffffa02a91c8>] 
btrfs_commit_transaction+0x2c3/0x694 [btrfs]
[152684.675924]  [<ffffffff8106941f>] ? wake_up_bit+0x2a/0x2a
[152684.675933]  [<ffffffffa02b2a07>] btrfs_write_inode+0xa0/0xa9 [btrfs]
[152684.675935]  [<ffffffff8113b12f>] writeback_single_inode+0x125/0x1bf
[152684.675937]  [<ffffffff8113b40f>] writeback_sb_inodes+0xce/0x160
[152684.675939]  [<ffffffff8113c036>] wb_writeback+0x258/0x3aa
[152684.675942]  [<ffffffff8113c211>] wb_do_writeback+0x89/0x1a1
[152684.675944]  [<ffffffff8105ad6e>] ? run_timer_softirq+0x29a/0x29a
[152684.675946]  [<ffffffff8113c3b5>] bdi_writeback_thread+0x8c/0x20f
[152684.675948]  [<ffffffff8113c329>] ? wb_do_writeback+0x1a1/0x1a1
[152684.675950]  [<ffffffff81068f4e>] kthread+0x82/0x8a
[152684.675952]  [<ffffffff81483664>] kernel_thread_helper+0x4/0x10
[152684.675954]  [<ffffffff81068ecc>] ? kthread_worker_fn+0x14b/0x14b
[152684.675956]  [<ffffffff81483660>] ? gs_change+0x13/0x13
[152684.675957] fsstress        D 0000000100363ef6     0 22334      1 
0x00000084
[152684.675959]  ffff880169f8bb98 0000000000000082 0000000000000000 
0000000000000000
[152684.675961]  0000000000012540 0000000000012540 0000000000012540 
ffff880181f21720
[152684.675963]  0000000000012540 ffff880169f8bfd8 0000000000012540 
0000000000012540
[152684.675966] Call Trace:
[152684.675967]  [<ffffffff810696b2>] ? prepare_to_wait+0x6c/0x79
[152684.675974]  [<ffffffffa02a8758>] 
wait_current_trans.clone.19+0xa0/0xd4 [btrfs]
[152684.675976]  [<ffffffff8106941f>] ? wake_up_bit+0x2a/0x2a
[152684.675977]  [<ffffffff8147afde>] ? mutex_lock+0x29/0x4a
[152684.675984]  [<ffffffffa02a988d>] start_transaction+0x98/0x24f [btrfs]
[152684.675991]  [<ffffffffa02a9d67>] btrfs_start_transaction+0x13/0x15 
[btrfs]
[152684.675999]  [<ffffffffa02b3d72>] btrfs_create+0x3a/0x1de [btrfs]
[152684.676002]  [<ffffffff811276d3>] vfs_create+0x70/0x92
[152684.676004]  [<ffffffff8112791d>] do_last+0x228/0x599
[152684.676006]  [<ffffffff81128ffd>] path_openat+0xc8/0x34d
[152684.676007]  [<ffffffff81126dfa>] ? putname+0x34/0x36
[152684.676009]  [<ffffffff811292bf>] do_filp_open+0x3d/0x89
[152684.676012]  [<ffffffff81132e6a>] ? alloc_fd+0x74/0x11f
[152684.676014]  [<ffffffff8111c847>] do_sys_open+0x74/0x106
[152684.676015]  [<ffffffff8111c8f9>] sys_open+0x20/0x22
[152684.676017]  [<ffffffff8111c923>] sys_creat+0x15/0x17
[152684.676019]  [<ffffffff81482542>] system_call_fastpath+0x16/0x1b
[152684.676020] fsstress        D 0000000100363ef5     0 22335      1 
0x00000084
[152684.676022]  ffff8801665018e8 0000000000000082 ffffffff81144cd4 
00000000000000c0
[152684.676024]  0000000000012540 0000000000012540 0000000000012540 
ffff880181f22e40
[152684.676027]  0000000000012540 ffff880166501fd8 0000000000012540 
0000000000012540
[152684.676029] Call Trace:
[152684.676031]  [<ffffffff81144cd4>] ? bvec_alloc_bs+0xb0/0xcf
[152684.676033]  [<ffffffff8147ab8c>] schedule_timeout+0x36/0xe3
[152684.676041]  [<ffffffffa02c9d78>] ? __btrfs_map_block+0x5f1/0x609 
[btrfs]
[152684.676043]  [<ffffffff8107c30e>] ? arch_local_irq_save+0x18/0x1e
[152684.676045]  [<ffffffff8103d050>] ? need_resched+0x23/0x2d
[152684.676047]  [<ffffffff8147a94f>] wait_for_common+0xad/0x102
[152684.676049]  [<ffffffff8104625f>] ? try_to_wake_up+0x1aa/0x1aa
[152684.676051]  [<ffffffff81053995>] ? local_bh_enable_ip+0xe/0x10
[152684.676053]  [<ffffffff8147aa5c>] wait_for_completion+0x1d/0x1f
[152684.676055]  [<ffffffff8113b892>] writeback_inodes_sb_nr+0x76/0x7d
[152684.676057]  [<ffffffff8113b945>] 
writeback_inodes_sb_nr_if_idle+0x41/0x57
[152684.676062]  [<ffffffffa0296eca>] 
shrink_delalloc.clone.46+0xb2/0x155 [btrfs]
[152684.676068]  [<ffffffffa0297066>] 
reserve_metadata_bytes.clone.47+0xf9/0x1b3 [btrfs]
[152684.676074]  [<ffffffffa0299c01>] btrfs_block_rsv_add+0x2c/0x4f [btrfs]
[152684.676080]  [<ffffffffa0299e2a>] 
btrfs_trans_reserve_metadata+0x4f/0x74 [btrfs]
[152684.676087]  [<ffffffffa02a9985>] start_transaction+0x190/0x24f [btrfs]
[152684.676094]  [<ffffffffa02a9d67>] btrfs_start_transaction+0x13/0x15 
[btrfs]
[152684.676102]  [<ffffffffa02b3d72>] btrfs_create+0x3a/0x1de [btrfs]
[152684.676104]  [<ffffffff811276d3>] vfs_create+0x70/0x92
[152684.676106]  [<ffffffff8112791d>] do_last+0x228/0x599
[152684.676107]  [<ffffffff81128ffd>] path_openat+0xc8/0x34d
[152684.676109]  [<ffffffff8147be0f>] ? 
_raw_spin_unlock_irqrestore+0x17/0x19
[152684.676111]  [<ffffffff8147bda6>] ? _raw_spin_lock+0xe/0x10
[152684.676113]  [<ffffffff811292bf>] do_filp_open+0x3d/0x89
[152684.676115]  [<ffffffff81132e6a>] ? alloc_fd+0x74/0x11f
[152684.676117]  [<ffffffff8111c847>] do_sys_open+0x74/0x106
[152684.676119]  [<ffffffff8111c8f9>] sys_open+0x20/0x22
[152684.676120]  [<ffffffff8111c923>] sys_creat+0x15/0x17
[152684.676122]  [<ffffffff81482542>] system_call_fastpath+0x16/0x1b
[152684.676123] fsstress        D 0000000100363ef5     0 22336      1 
0x00000084
[152684.676125]  ffff88017ba37d48 0000000000000086 ffff88017ba37cb8 
ffffffff812262b8
[152684.676127]  0000000000012540 0000000000012540 0000000000012540 
ffff880181b01720
[152684.676130]  0000000000012540 ffff88017ba37fd8 0000000000012540 
0000000000012540
[152684.676132] Call Trace:
[152684.676134]  [<ffffffff812262b8>] ? cpumask_next_and+0x2c/0x39
[152684.676136]  [<ffffffff8147ab8c>] schedule_timeout+0x36/0xe3
[152684.676138]  [<ffffffff81026cb8>] ? flat_send_IPI_mask+0x11/0x13
[152684.676140]  [<ffffffff8103d050>] ? need_resched+0x23/0x2d
[152684.676142]  [<ffffffff8147a94f>] wait_for_common+0xad/0x102
[152684.676143]  [<ffffffff8104625f>] ? try_to_wake_up+0x1aa/0x1aa
[152684.676145]  [<ffffffff81053995>] ? local_bh_enable_ip+0xe/0x10
[152684.676147]  [<ffffffff8113f1e8>] ? __sync_filesystem+0x7a/0x7a
[152684.676148]  [<ffffffff8147aa5c>] wait_for_completion+0x1d/0x1f
[152684.676150]  [<ffffffff8113b9ec>] sync_inodes_sb+0x91/0x17d
[152684.676152]  [<ffffffff8113f1e8>] ? __sync_filesystem+0x7a/0x7a
[152684.676154]  [<ffffffff8113f1b5>] __sync_filesystem+0x47/0x7a
[152684.676155]  [<ffffffff8113f1fe>] sync_one_sb+0x16/0x18
[152684.676157]  [<ffffffff8111f907>] iterate_supers+0x6d/0xbe
[152684.676159]  [<ffffffff8113f133>] sync_filesystems+0x20/0x22
[152684.676160]  [<ffffffff8113f271>] sys_sync+0x21/0x33
[152684.676162]  [<ffffffff81482542>] system_call_fastpath+0x16/0x1b
[152684.676164] updatedb        D 0000000102716c7c     0 25199  25193 
0x00000080
[152684.676166]  ffff88017fb01e28 0000000000000086 ffff88017fb01f28 
ffff880100000000
[152684.676168]  0000000000012540 0000000000012540 0000000000012540 
ffff88019ee0ae40
[152684.676170]  0000000000012540 ffff88017fb01fd8 0000000000012540 
0000000000012540
[152684.676172] Call Trace:
[152684.676174]  [<ffffffff8147b11a>] 
__mutex_lock_common.clone.5+0x11b/0x17c
[152684.676177]  [<ffffffff8112b56c>] ? filldir64+0xd5/0xd5
[152684.676178]  [<ffffffff8147b1a3>] 
__mutex_lock_killable_slowpath+0x13/0x15
[152684.676181]  [<ffffffff8106bea1>] __mutex_fastpath_lock_retval+0x18/0x1a
[152684.676182]  [<ffffffff8147af53>] mutex_lock_killable+0x38/0x4d
[152684.676184]  [<ffffffff8112b74c>] vfs_readdir+0x56/0xac
[152684.676186]  [<ffffffff8112b88b>] sys_getdents+0x81/0xd1
[152684.676188]  [<ffffffff81482542>] system_call_fastpath+0x16/0x1b
[152684.676191] sync            D 00000001091bba63     0 26977   1943 
0x00000080
[152684.676193]  ffff880183239d48 0000000000000086 0007ffffffffffff 
ffff880100000000
[152684.676196]  0000000000012540 0000000000012540 0000000000012540 
ffff880181b04560
[152684.676198]  0000000000012540 ffff880183239fd8 0000000000012540 
0000000000012540
[152684.676200] Call Trace:
[152684.676202]  [<ffffffff8147ab8c>] schedule_timeout+0x36/0xe3
[152684.676203]  [<ffffffff81026cb8>] ? flat_send_IPI_mask+0x11/0x13
[152684.676205]  [<ffffffff8103d050>] ? need_resched+0x23/0x2d
[152684.676207]  [<ffffffff8147a94f>] wait_for_common+0xad/0x102
[152684.676209]  [<ffffffff8104625f>] ? try_to_wake_up+0x1aa/0x1aa
[152684.676210]  [<ffffffff81053995>] ? local_bh_enable_ip+0xe/0x10
[152684.676212]  [<ffffffff8113f1e8>] ? __sync_filesystem+0x7a/0x7a
[152684.676214]  [<ffffffff8147aa5c>] wait_for_completion+0x1d/0x1f
[152684.676216]  [<ffffffff8113b892>] writeback_inodes_sb_nr+0x76/0x7d
[152684.676218]  [<ffffffff8113b8bb>] writeback_inodes_sb+0x22/0x24
[152684.676219]  [<ffffffff8113f1bf>] __sync_filesystem+0x51/0x7a
[152684.676221]  [<ffffffff8113f1fe>] sync_one_sb+0x16/0x18
[152684.676223]  [<ffffffff8111f907>] iterate_supers+0x6d/0xbe
[152684.676224]  [<ffffffff8113f133>] sync_filesystems+0x20/0x22
[152684.676226]  [<ffffffff8113f267>] sys_sync+0x17/0x33
[152684.676227]  [<ffffffff81482542>] system_call_fastpath+0x16/0x1b
