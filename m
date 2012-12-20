Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from m59-178.qiye.163.com ([123.58.178.59]:32992 "EHLO
	m59-178.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776Ab2LTOun (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Dec 2012 09:50:43 -0500
Received: from mail-la0-f48.google.com (mail-la0-f48.google.com [209.85.215.48])
	by m59-178.qiye.163.com (HMail) with ESMTPA id 7813B81030A
	for <linux-btrfs@vger.kernel.org>; Thu, 20 Dec 2012 22:50:38 +0800 (CST)
Received: by mail-la0-f48.google.com with SMTP id m13so3153181lah.35
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Dec 2012 06:50:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAMRmmpKMxjjRShPY=VTJ+29eVY_hu-PTVAFsmhKpx1wRBi0akQ@mail.gmail.com>
References: <CAMRmmp+=YT_-KdGHRWo5GrofiSnkZB_xVpN1Z8Jp4xgo0fVS3A@mail.gmail.com>
 <20121219152925.GC4033@localhost.localdomain> <CAMRmmp+gqw11a32GV=X1VGKvJWGRO0PXk-13fMyEmWyKgCkngg@mail.gmail.com>
 <CAMRmmpKMxjjRShPY=VTJ+29eVY_hu-PTVAFsmhKpx1wRBi0akQ@mail.gmail.com>
From: Rock Lee <zimilo@code-trick.com>
Date: Thu, 20 Dec 2012 22:49:56 +0800
Message-ID: <CAMRmmp+5jZoSs9J9Xr1HHMyhS4HaheDMnfzhKCiLDOR+s-+XCg@mail.gmail.com>
Subject: Re: HIT WARN_ON WARNING: at fs/btrfs/extent-tree.c:6339
 btrfs_alloc_free_block+0x126/0x330 [btrfs]()
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It's really easy to get this warning.

In my other testing codes, got the same issue again.

Detail log:


use_block_rsv: 18 callbacks suppressed
[ 8444.788581] btrfs: block rsv returned -28
[ 8444.788584] ------------[ cut here ]------------
[ 8444.788621] WARNING: at fs/btrfs/extent-tree.c:6323
btrfs_alloc_free_block+0x376/0x380 [btrfs]()
[ 8444.788626] Hardware name: 2356BG6
[ 8444.788629] Modules linked in: btrfs libcrc32c zlib_deflate hidp
fuse vboxpci(O) vboxnetadp(O) vboxnetflt(O) vboxdrv(O) lockd rfcomm
bnep ip6t_REJECT nf_conntrack_ipv4 nf_conntrack_ipv6 nf_defrag_ipv4
nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables
snd_hda_codec_hdmi snd_hda_codec_realtek uvcvideo snd_hda_intel
snd_hda_codec videobuf2_vmalloc videobuf2_memops videobuf2_core arc4
btusb iwldvm snd_hwdep thinkpad_acpi bluetooth videodev mac80211
snd_seq snd_seq_device snd_pcm iwlwifi snd_page_alloc media snd_timer
snd coretemp cfg80211 iTCO_wdt iTCO_vendor_support soundcore i2c_i801
mei kvm_intel kvm rfkill lpc_ich mfd_core microcode uinput xts
gf128mul dm_crypt crc32c_intel ghash_clmulni_intel sdhci_pci sdhci
mmc_core e1000e wmi i915 video i2c_algo_bit drm_kms_helper drm
i2c_core sunrpc
[ 8444.788743] Pid: 5215, comm: btrfs-balance Tainted: G        WC O
3.6.10-2.fc17.x86_64 #1
[ 8444.788747] Call Trace:
[ 8444.788762]  [<ffffffff8105c8ef>] warn_slowpath_common+0x7f/0xc0
[ 8444.788770]  [<ffffffff8105c94a>] warn_slowpath_null+0x1a/0x20
[ 8444.788800]  [<ffffffffa0644a06>] btrfs_alloc_free_block+0x376/0x380 [btrfs]
[ 8444.788828]  [<ffffffffa064c91f>] ? btree_set_page_dirty+0x3f/0x50 [btrfs]
[ 8444.788850]  [<ffffffffa0630a9a>] __btrfs_cow_block+0x12a/0x510 [btrfs]
[ 8444.788870]  [<ffffffffa0630f77>] btrfs_cow_block+0xf7/0x200 [btrfs]
[ 8444.788891]  [<ffffffffa06351a7>] btrfs_search_slot+0x3e7/0x8f0 [btrfs]
[ 8444.788918]  [<ffffffffa0653fa4>] ?
btrfs_record_root_in_trans+0x64/0x80 [btrfs]
[ 8444.788950]  [<ffffffffa0692dde>] do_relocation+0x3ee/0x540 [btrfs]
[ 8444.788970]  [<ffffffffa0639e8b>] ? block_rsv_add_bytes+0x2b/0x70 [btrfs]
[ 8444.789005]  [<ffffffffa0696a06>] relocate_tree_blocks+0x676/0x6b0 [btrfs]
[ 8444.789035]  [<ffffffffa0690b74>] ? tree_insert+0x54/0x60 [btrfs]
[ 8444.789063]  [<ffffffffa06946ee>] ? add_tree_block+0xee/0x1a0 [btrfs]
[ 8444.789090]  [<ffffffffa06979ad>] relocate_block_group+0x42d/0x6a0 [btrfs]
[ 8444.789114]  [<ffffffffa0697dcf>]
btrfs_relocate_block_group+0x1af/0x2e0 [btrfs]
[ 8444.789142]  [<ffffffffa0672ed5>]
btrfs_relocate_chunk.isra.53+0x75/0x730 [btrfs]
[ 8444.789169]  [<ffffffffa066fb47>] ? free_extent_buffer+0x37/0x90 [btrfs]
[ 8444.789201]  [<ffffffffa06774b7>] btrfs_balance+0x807/0xd10 [btrfs]
[ 8444.789230]  [<ffffffffa0677a42>] balance_kthread+0x82/0x90 [btrfs]
[ 8444.789255]  [<ffffffffa06779c0>] ? btrfs_balance+0xd10/0xd10 [btrfs]
[ 8444.789263]  [<ffffffff8107fdf3>] kthread+0x93/0xa0
[ 8444.789274]  [<ffffffff81628184>] kernel_thread_helper+0x4/0x10
[ 8444.789282]  [<ffffffff8107fd60>] ? kthread_freezable_should_stop+0x70/0x70
[ 8444.789290]  [<ffffffff81628180>] ? gs_change+0x13/0x13
[ 8444.789295] ---[ end trace 4c2182f6ae8a3638 ]---
[ 8444.789617] btrfs: block rsv returned -28
[ 8444.789619] ------------[ cut here ]------------
[ 8444.789630] WARNING: at fs/btrfs/extent-tree.c:6323
btrfs_alloc_free_block+0x376/0x380 [btrfs]()
[ 8444.789632] Hardware name: 2356BG6
[ 8444.789632] Modules linked in: btrfs libcrc32c zlib_deflate hidp
fuse vboxpci(O) vboxnetadp(O) vboxnetflt(O) vboxdrv(O) lockd rfcomm
bnep ip6t_REJECT nf_conntrack_ipv4 nf_conntrack_ipv6 nf_defrag_ipv4
nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables
snd_hda_codec_hdmi snd_hda_codec_realtek uvcvideo snd_hda_intel
snd_hda_codec videobuf2_vmalloc videobuf2_memops videobuf2_core arc4
btusb iwldvm snd_hwdep thinkpad_acpi bluetooth videodev mac80211
snd_seq snd_seq_device snd_pcm iwlwifi snd_page_alloc media snd_timer
snd coretemp cfg80211 iTCO_wdt iTCO_vendor_support soundcore i2c_i801
mei kvm_intel kvm rfkill lpc_ich mfd_core microcode uinput xts
gf128mul dm_crypt crc32c_intel ghash_clmulni_intel sdhci_pci sdhci
mmc_core e1000e wmi i915 video i2c_algo_bit drm_kms_helper drm
i2c_core sunrpc
[ 8444.789673] Pid: 5215, comm: btrfs-balance Tainted: G        WC O
3.6.10-2.fc17.x86_64 #1
[ 8444.789674] Call Trace:
[ 8444.789679]  [<ffffffff8105c8ef>] warn_slowpath_common+0x7f/0xc0
[ 8444.789687]  [<ffffffff8105c94a>] warn_slowpath_null+0x1a/0x20
[ 8444.789695]  [<ffffffffa0644a06>] btrfs_alloc_free_block+0x376/0x380 [btrfs]
[ 8444.789701]  [<ffffffffa0630c95>] ? __btrfs_cow_block+0x325/0x510 [btrfs]
[ 8444.789709]  [<ffffffffa0670c23>] ? read_extent_buffer+0xc3/0x120 [btrfs]
[ 8444.789715]  [<ffffffffa0630a9a>] __btrfs_cow_block+0x12a/0x510 [btrfs]
[ 8444.789723]  [<ffffffffa066a6a5>] ?
mark_extent_buffer_accessed+0x55/0x70 [btrfs]
[ 8444.789732]  [<ffffffffa0630f77>] btrfs_cow_block+0xf7/0x200 [btrfs]
[ 8444.789741]  [<ffffffffa0692e67>] do_relocation+0x477/0x540 [btrfs]
[ 8444.789749]  [<ffffffffa0639e8b>] ? block_rsv_add_bytes+0x2b/0x70 [btrfs]
[ 8444.789757]  [<ffffffffa0696a06>] relocate_tree_blocks+0x676/0x6b0 [btrfs]
[ 8444.789764]  [<ffffffffa0690b74>] ? tree_insert+0x54/0x60 [btrfs]
[ 8444.789771]  [<ffffffffa06946ee>] ? add_tree_block+0xee/0x1a0 [btrfs]
[ 8444.789778]  [<ffffffffa06979ad>] relocate_block_group+0x42d/0x6a0 [btrfs]
[ 8444.789786]  [<ffffffffa0697dcf>]
btrfs_relocate_block_group+0x1af/0x2e0 [btrfs]
[ 8444.789794]  [<ffffffffa0672ed5>]
btrfs_relocate_chunk.isra.53+0x75/0x730 [btrfs]
[ 8444.789801]  [<ffffffffa066fb47>] ? free_extent_buffer+0x37/0x90 [btrfs]
[ 8444.789809]  [<ffffffffa06774b7>] btrfs_balance+0x807/0xd10 [btrfs]
[ 8444.789816]  [<ffffffffa0677a42>] balance_kthread+0x82/0x90 [btrfs]
[ 8444.789823]  [<ffffffffa06779c0>] ? btrfs_balance+0xd10/0xd10 [btrfs]
[ 8444.789826]  [<ffffffff8107fdf3>] kthread+0x93/0xa0
[ 8444.789828]  [<ffffffff81628184>] kernel_thread_helper+0x4/0x10
[ 8444.789831]  [<ffffffff8107fd60>] ? kthread_freezable_should_stop+0x70/0x70
[ 8444.789833]  [<ffffffff81628180>] ? gs_change+0x13/0x13
[ 8444.789834] ---[ end trace 4c2182f6ae8a3639 ]---

2012/12/20 Rock Lee <zimilo@code-trick.com>:
> Is there anyone who are tracking this issue?
>
> 2012/12/19 Rock Lee <zimilo@code-trick.com>:
>> Hi,
>>
>>  I just try to write the testcase a few hours before. So there will be
>> some problems.
>>
>>  Maybe you can ignore the unimplemented and the ugly parts.
>>
>>  Welcome any feedback. :)
>>
>>  I have uploaded the test source file to Github. Please open this link:
>>
>>     https://github.com/Zimilo/btrfs-testing-suites/blob/master/fallocate/fallocate.c
>>
>>  Latest kernel commit is 752451f01c4567b506bf4343082682dbb8fb30dd in
>> linus git tree.
>>
>>  Testing on a 20GB loop device.
>>
>>  When running the second case, try to do the sync command manually at
>> the some time several times. Always could be reproduced.
>>
>>  You will get hit the WARN_ON, dmesg will report them.
>>
>>
>>  Except this problem, there's another bug,   btrfs_fallocate doesn't
>> guarantee subsequent write to that range not to fail because of disk
>> space.
>>
>>
>>
>> 2012/12/19 Josef Bacik <jbacik@fusionio.com>:
>>> On Wed, Dec 19, 2012 at 08:12:01AM -0700, Rock Lee wrote:
>>>> Hi all,
>>>>
>>>>     Did someone have met this problem before. When doing the tests, I hit
>>>>
>>>> the WARN_ON. Is this log make sense or someone had fixed the problem.
>>>>
>>>>  If needed, I can supply the detail log and the testcase source file.
>>>>
>>>>  Version: the latest codes at linus git tree.
>>>>
>>>
>>> If you can give me your testcase I will love you forever.  Thanks,
>>>
>>> Josef

