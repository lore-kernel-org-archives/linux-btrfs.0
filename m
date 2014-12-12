Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-po-08v.sys.comcast.net ([96.114.154.167]:56087 "EHLO
	resqmta-po-08v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967795AbaLLNaE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Dec 2014 08:30:04 -0500
Message-ID: <548AEDD6.1090904@pobox.com>
Date: Fri, 12 Dec 2014 05:29:58 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Patrik Lundquist <patrik.lundquist@gmail.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: A note on spotting "bugs" [Was: ENOSPC after conversion]
References: <CAA7pwKNhYxeQjfTyd4WQrsQ7MuapKgRfjwF3kHY+VWDnVk+cTA@mail.gmail.com>	<548A13F7.30904@pobox.com> <CAA7pwKNKeuysdoS83m=z-Cn5ecWtGrQAfjNKwXjryRceHUV=3Q@mail.gmail.com>
In-Reply-To: <CAA7pwKNKeuysdoS83m=z-Cn5ecWtGrQAfjNKwXjryRceHUV=3Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/11/2014 10:42 PM, Patrik Lundquist wrote:
> On 11 December 2014 at 23:00, Robert White <rwhite@pobox.com> wrote:
>> On 12/11/2014 12:18 AM, Patrik Lundquist wrote:
>>>
>>> * Full balance, that ended with "98 enospc errors during balance."
>>
>> Assuming that quote is an actual quote from the output of the balance...
>
> It is, from dmesg.
>
>
>> "Bugs" are unexpected things that cause failures and/or damage.
>
> Not all errors are as pretty as
>
> BTRFS info (device sdc1): relocating block group 1756675178496 flags 1
> BTRFS error (device sdc1): allocation failed flags 1, wanted 1272844288
> BTRFS: space_info 1 has 13703077888 free, is not full
> BTRFS: space_info total=1504312295424, used=1487622750208, pinned=0,
> reserved=2986196992, may_use=1308749824, readonly=270336
>
> some are
>
> BTRFS info (device sdc1): relocating block group 1780297498624 flags 1
> ------------[ cut here ]------------
> WARNING: CPU: 2 PID: 11094 at
> /build/linux-Y9HjRe/linux-3.16.7/fs/btrfs/extent-tree.c:7280
> btrfs_alloc_free_block+0x219/0x450 [btrfs]()
> BTRFS: block rsv returned -28
> Modules linked in: nfsd auth_rpcgss oid_registry nfs_acl nfs lockd
> fscache sunrpc btrfs xor nls_utf8 nls_cp437 vfat fat kvm_intel
> raid6_pq kvm crc32_pclmul jc42 coretemp ghash_clmulni_intel iTCO_wdt
> ipmi_watchdog iTCO_vendor_support aesni_intel joydev aes_x86_64
> efi_pstore lrw gf128mul evdev glue_helper ast ablk_helper lpc_ich
> cryptd ttm pcspkr efivars mfd_core i2c_i801 drm_kms_helper drm tpm_tis
> tpm acpi_cpufreq i2c_ismt shpchp button processor thermal_sys ipmi_si
> ipmi_poweroff ipmi_devintf ipmi_msghandler autofs4 ext4 crc16 mbcache
> jbd2 sg sd_mod crc_t10dif crct10dif_generic hid_generic usbhid hid
> ahci libahci crct10dif_pclmul crct10dif_common crc32c_intel igb libata
> ehci_pci i2c_algo_bit xhci_hcd ehci_hcd i2c_core dca scsi_mod ptp
> usbcore pps_core usb_common
> CPU: 2 PID: 11094 Comm: btrfs Tainted: G        W     3.16.0-4-amd64
> #1 Debian 3.16.7-2
> Hardware name: Supermicro A1SAi/A1SAi, BIOS 1.0c 02/27/2014
>   0000000000000009 ffffffff81506b43 ffff88032779f780 ffffffff81065717
>   ffff88032d68a640 ffff88032779f7d0 0000000000001000 ffff8803117df480
>   0000000000000000 ffffffff8106577c ffffffffa0536338 0000000000000020
> Call Trace:
>   [<ffffffff81506b43>] ? dump_stack+0x41/0x51
>   [<ffffffff81065717>] ? warn_slowpath_common+0x77/0x90
>   [<ffffffff8106577c>] ? warn_slowpath_fmt+0x4c/0x50
>   [<ffffffffa04a8b09>] ? btrfs_alloc_free_block+0x219/0x450 [btrfs]
>   [<ffffffff81142bf6>] ? free_hot_cold_page_list+0x46/0x90
>   [<ffffffffa04dc5c8>] ? read_extent_buffer+0xc8/0x120 [btrfs]
>   [<ffffffffa0492c31>] ? btrfs_copy_root+0x101/0x2e0 [btrfs]
>   [<ffffffffa05032d1>] ? create_reloc_root+0x201/0x2d0 [btrfs]
>   [<ffffffffa0509398>] ? btrfs_init_reloc_root+0x98/0xb0 [btrfs]
>   [<ffffffffa04b9564>] ? record_root_in_trans+0xa4/0xf0 [btrfs]
>   [<ffffffffa04ba95f>] ? btrfs_record_root_in_trans+0x3f/0x70 [btrfs]
>   [<ffffffffa04bb940>] ? start_transaction+0x90/0x560 [btrfs]
>   [<ffffffffa04c605a>] ? btrfs_evict_inode+0x33a/0x4d0 [btrfs]
>   [<ffffffff811bf0ec>] ? evict+0xac/0x170
>   [<ffffffffa04c0762>] ? btrfs_run_delayed_iputs+0xd2/0xf0 [btrfs]
>   [<ffffffffa04bb812>] ? btrfs_commit_transaction+0x922/0x9c0 [btrfs]
>   [<ffffffffa04bb940>] ? start_transaction+0x90/0x560 [btrfs]
>   [<ffffffffa0504ea4>] ? prepare_to_relocate+0xf4/0x1b0 [btrfs]
>   [<ffffffffa0509e72>] ? relocate_block_group+0x42/0x670 [btrfs]
>   [<ffffffffa050a667>] ? btrfs_relocate_block_group+0x1c7/0x2d0 [btrfs]
>   [<ffffffffa04e0432>] ? btrfs_relocate_chunk.isra.27+0x62/0x700 [btrfs]
>   [<ffffffffa04928d1>] ? btrfs_set_path_blocking+0x31/0x70 [btrfs]
>   [<ffffffffa0497d8d>] ? btrfs_search_slot+0x4ad/0xad0 [btrfs]
>   [<ffffffffa04d1fd5>] ? btrfs_get_token_64+0x55/0xf0 [btrfs]
>   [<ffffffffa04e355b>] ? btrfs_balance+0x82b/0xe80 [btrfs]
>   [<ffffffffa04eaba4>] ? btrfs_ioctl_balance+0x154/0x500 [btrfs]
>   [<ffffffffa04ef89c>] ? btrfs_ioctl+0x58c/0x2b10 [btrfs]
>   [<ffffffff811670f1>] ? handle_mm_fault+0xa91/0x11a0
>   [<ffffffff810562a1>] ? __do_page_fault+0x1d1/0x4e0
>   [<ffffffff8116afc1>] ? vma_link+0xb1/0xc0
>   [<ffffffff811b788f>] ? do_vfs_ioctl+0x2cf/0x4b0
>   [<ffffffff811b7af1>] ? SyS_ioctl+0x81/0xa0
>   [<ffffffff8150ecc8>] ? page_fault+0x28/0x30
>   [<ffffffff8150cc2d>] ? system_call_fast_compare_end+0x10/0x15
> ---[ end trace 880987d36ae50245 ]---
> BTRFS error (device sdc1): allocation failed flags 1, wanted 2013265920
> BTRFS: space_info 1 has 8384299008 free, is not full
> BTRFS: space_info total=1500017328128, used=1491533037568, pinned=0,
> reserved=99807232, may_use=2147475456, readonly=184320
>

Interesting but only fractionally so.

The function btrfs_alloc_free_block() has disappeared from the kernel 
sources in Linus' git tree for the kernel. It used to be in 
linux/fs/btrfs/extent-tree.c ... direct allocation seems to have been 
replaced by a reservation system.

This still doesnt say _anything_ is wrong with your filesystem except 
that it doesn't have enough _raw_ space to create a 2-ish gig extent.

To produce that backtrace as a _WARNING_ (check out the first line) the 
programmer explicitly had to call the function that generates that 
backtrace. That is, it's not a "oops" or other _unforeseen_ critical 
path failure.

So while it's still just a harmless out-of-space condition in terms 
balance, and its got nothing to do with being "out of space" at the 
functional level, some work is being done on the way the handling is 
taking place.

Particularly, there was some code that explicitly called WARN() or 
BUG_ON() while it was processing that out of raw space condition. This 
is a normal-ish thing for code to do when the programmer is like "hey, 
I'd like to see what the state actually is when this happens".

Since the code has literally been replaced whole-scale in 3.18 (that 
just got tagged in the development tree I'm referencing) chances are its 
been on someone's mind for a while now.

That is someone was thinking "this downright likely condition could 
happen when we don't have a big enough contiguous chunk of raw space, 
maybe we should handle it better". Then they replaced the code.

---

So as much as you seem to want to characterize this as a "huge problem" 
or a "bug" it's just a less-than-optimal but completely stable and 
foreseeable result of feeding an really chaotic and previously full EXT4 
file system into btrfs-convert.

You yourself even found the annotation in the wiki that said you should 
have e4defragged the system before conversion.

...

We are not on new, shifting, or terrible ground here.

Just because you don't know how to read a backtrace doesn't mean that 
every backtrace is cause for concern. Some are. The "warnings" usually 
not so much.

You've already found what you missed (the e4defrag) when preparing for 
the conversion.

You've already heard my rationale for why conversions tend to be less 
than optimal regardless of the systems.

You've already heard Duncan's rational for the same position.

You've already heard my argument for building a new filesystem and 
copying the contents over onto it.

You've already decided that it would have been better to start with a 
clean filesystem and then copy the files.

You've already decided to do that create and copy process.

I've written maybe a couple thousand words to guide you through the 
analysis so you can understand the difference between raw allocation at 
the partition space level versus user-level allocations for storing 
files etc.

What you are experiencing is a little vexing, but it's not a bug. It's 
not even a "huge problem". And if you'd stop banging your head against 
it it wouldn't be any sort of problem at all. Neither of us can change 
these facts.

I feel your pain man, but thats about it.

What more can I do?
What is it that you want?

