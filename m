Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f45.google.com ([209.85.219.45]:33395 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756182Ab3B0UYN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Feb 2013 15:24:13 -0500
Received: by mail-oa0-f45.google.com with SMTP id o6so2141857oag.32
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Feb 2013 12:24:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20130225194624.GC19641@localhost.localdomain>
References: <CAMfhy91KbFSdCyNdQo1a4whWtqg2TbXKLuJdCiRTfj9E3oOePw@mail.gmail.com>
	<20130222174401.GF2062@localhost.localdomain>
	<CAMfhy92G2yGh4HeQGq1VYVZ=pr2VkH+6yT86ZwfnLvxrUY=Wyg@mail.gmail.com>
	<20130222181017.GG2062@localhost.localdomain>
	<CAMfhy924GJHkxTmy2bDZc=TaYD9ivyg6Q8LBN=+9_m6Xo=tnag@mail.gmail.com>
	<CAMfhy90toxsRFFQVB-3kotm4zyoCJDOFknq-AUegaCsia2pazg@mail.gmail.com>
	<20130222194021.GH2062@localhost.localdomain>
	<CAMfhy91HiiJwy8iQKLJzjGj=oqbAqisNxb67JQMRkcpKJTwvug@mail.gmail.com>
	<20130225191236.GA19641@localhost.localdomain>
	<CAMfhy930iLRwh07gcPwptoxqXE8mg_HoLtzZgibn4GMnhnVzPw@mail.gmail.com>
	<20130225194624.GC19641@localhost.localdomain>
Date: Wed, 27 Feb 2013 15:24:13 -0500
Message-ID: <CAMfhy92Z1JhqY4yC-gzANJAMphQ1h4f7qSbsqnyQ=kxjEvC7Bg@mail.gmail.com>
Subject: Re: WARNING: at fs/btrfs/extent_io.c:4718 map_private_extent_buffer+0xd4/0xe0
 [btrfs]()
From: Mace Moneta <moneta.mace@gmail.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 25, 2013 at 2:46 PM, Josef Bacik <jbacik@fusionio.com> wrote:
> On Mon, Feb 25, 2013 at 12:21:30PM -0700, Mace Moneta wrote:
>> On Mon, Feb 25, 2013 at 2:12 PM, Josef Bacik <jbacik@fusionio.com> wrote:
>>
>> >
>> > Is there any chance you got the line above [ cut here ]?  (I hate that stupid [
>> > cut here ], it makes us miss all the usefull info.)  Thanks,
>> >
>> > Josef
>>
>> There was really nothing significant above the 'cut here'.  Here it is
>> with over an hour of earlier context:
>>
>
> Sigh, I don't know why this warn_on(1, printk) isn't doing it's job.  Here is a
> debug patch, please capture the output from this so I can figure out what is
> going on.  Thanks,
>
> Josef
>
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 66f999b..eed5554 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -4715,9 +4715,10 @@ int map_private_extent_buffer(struct extent_buffer *eb, unsigned long start,
>         }
>
>         if (start + min_len > eb->len) {
> -               WARN(1, KERN_ERR "btrfs bad mapping eb start %llu len %lu, "
> +               printk(KERN_ERR "btrfs bad mapping eb start %llu len %lu, "
>                        "wanted %lu %lu\n", (unsigned long long)eb->start,
>                        eb->len, start, min_len);
> +               WARN_ON(1);
>                 return -EINVAL;
>         }
>

Finally got a re-occurrence:

[ 5655.849208] Bluetooth: Unexpected continuation frame (len 0)
[ 5655.891215] Bluetooth: Unexpected continuation frame (len 0)
[ 5655.896217] Bluetooth: Unexpected continuation frame (len 0)
[ 5655.901205] Bluetooth: Unexpected continuation frame (len 0)
[ 5655.904200] Bluetooth: Unexpected continuation frame (len 0)
[ 5655.909198] Bluetooth: Unexpected continuation frame (len 0)
[ 6430.693016] Bluetooth: Unexpected continuation frame (len 0)
[ 6430.731014] Bluetooth: Unexpected continuation frame (len 0)
[ 6430.740003] Bluetooth: Unexpected continuation frame (len 0)
[ 6430.751012] Bluetooth: Unexpected continuation frame (len 0)
[ 6430.753010] Bluetooth: Unexpected continuation frame (len 0)
[ 6430.755999] Bluetooth: Unexpected continuation frame (len 0)
[ 6662.532218] Bluetooth: Unexpected continuation frame (len 0)
[ 6662.538447] Bluetooth: Unexpected continuation frame (len 0)
[ 7839.497442] ------------[ cut here ]------------
[ 7839.497475] WARNING: at fs/btrfs/extent_io.c:4720
map_private_extent_buffer+0xd4/0xe0 [btrfs]()
[ 7839.497477] Hardware name: C2SEA
[ 7839.497479] btrfs bad mapping eb start 1540317184 len 4096, wanted 4104 8
[ 7839.497482] Modules linked in: fuse rfcomm bnep ip6t_REJECT
nf_conntrack_ipv6 nf_defrag_ipv6 nf_conntrack_ipv4 nf_defrag_ipv4
xt_conntrack nf_conntrack w83627ehf ip6table_filter hwmon_vid
ip6_tables uvcvideo snd_hda_codec_realtek snd_hda_intel snd_hda_codec
snd_hwdep videobuf2_vmalloc videobuf2_memops videobuf2_core snd_seq
snd_seq_device coretemp snd_pcm videodev media btusb snd_page_alloc
iTCO_wdt iTCO_vendor_support bluetooth microcode snd_timer lpc_ich snd
rfkill mfd_core r8169 i2c_i801 soundcore mii vhost_net tun macvtap
macvlan kvm_intel kvm uinput i2c_dev binfmt_misc btrfs zlib_deflate
raid6_pq libcrc32c xor ata_generic pata_acpi i915 firewire_ohci video
firewire_core i2c_algo_bit pata_it8213 drm_kms_helper crc_itu_t drm
i2c_core
[ 7839.497528] Pid: 1973, comm: encfs Not tainted
3.8.0-1.BtrfsNextp1.fc18.x86_64 #1
[ 7839.497530] Call Trace:
[ 7839.497537]  [<ffffffff8105e61f>] warn_slowpath_common+0x7f/0xc0
[ 7839.497540]  [<ffffffff8105e716>] warn_slowpath_fmt+0x46/0x50
[ 7839.497559]  [<ffffffffa01b9144>] map_private_extent_buffer+0xd4/0xe0 [btrfs]
[ 7839.497577]  [<ffffffffa01af1f4>] btrfs_get_token_64+0x64/0xf0 [btrfs]
[ 7839.497594]  [<ffffffffa01a3320>]
btrfs_truncate_inode_items+0x720/0x840 [btrfs]
[ 7839.497613]  [<ffffffffa01d31a2>] btrfs_log_inode+0x6b2/0x990 [btrfs]
[ 7839.497618]  [<ffffffff811a02c4>] ? __sb_start_write+0x54/0x110
[ 7839.497621]  [<ffffffff81185725>] ? kmem_cache_alloc+0x35/0x200
[ 7839.497639]  [<ffffffffa01d41ac>] btrfs_log_inode_parent+0x17c/0x430 [btrfs]
[ 7839.497657]  [<ffffffffa01d44a7>] btrfs_log_dentry_safe+0x47/0x70 [btrfs]
[ 7839.497674]  [<ffffffffa01a9bc5>] btrfs_sync_file+0x175/0x290 [btrfs]
[ 7839.497678]  [<ffffffff811cc4ed>] do_fsync+0x5d/0x90
[ 7839.497681]  [<ffffffff811cc783>] sys_fdatasync+0x13/0x20
[ 7839.497685]  [<ffffffff81658d19>] system_call_fastpath+0x16/0x1b
[ 7839.497687] ---[ end trace 9c6b2d0f618cbb64 ]---
[ 7839.497689] ------------[ cut here ]------------
[ 7839.497706] WARNING: at fs/btrfs/extent_io.c:4674
read_extent_buffer+0xee/0x120 [btrfs]()
[ 7839.497707] Hardware name: C2SEA
[ 7839.497709] Modules linked in: fuse rfcomm bnep ip6t_REJECT
nf_conntrack_ipv6 nf_defrag_ipv6 nf_conntrack_ipv4 nf_defrag_ipv4
xt_conntrack nf_conntrack w83627ehf ip6table_filter hwmon_vid
ip6_tables uvcvideo snd_hda_codec_realtek snd_hda_intel snd_hda_codec
snd_hwdep videobuf2_vmalloc videobuf2_memops videobuf2_core snd_seq
snd_seq_device coretemp snd_pcm videodev media btusb snd_page_alloc
iTCO_wdt iTCO_vendor_support bluetooth microcode snd_timer lpc_ich snd
rfkill mfd_core r8169 i2c_i801 soundcore mii vhost_net tun macvtap
macvlan kvm_intel kvm uinput i2c_dev binfmt_misc btrfs zlib_deflate
raid6_pq libcrc32c xor ata_generic pata_acpi i915 firewire_ohci video
firewire_core i2c_algo_bit pata_it8213 drm_kms_helper crc_itu_t drm
i2c_core
[ 7839.497750] Pid: 1973, comm: encfs Tainted: G        W
3.8.0-1.BtrfsNextp1.fc18.x86_64 #1
[ 7839.497752] Call Trace:
[ 7839.497755]  [<ffffffff8105e61f>] warn_slowpath_common+0x7f/0xc0
[ 7839.497758]  [<ffffffff8105e67a>] warn_slowpath_null+0x1a/0x20
[ 7839.497776]  [<ffffffffa01b8b8e>] read_extent_buffer+0xee/0x120 [btrfs]
[ 7839.497793]  [<ffffffffa01af26c>] btrfs_get_token_64+0xdc/0xf0 [btrfs]
[ 7839.497810]  [<ffffffffa01a3320>]
btrfs_truncate_inode_items+0x720/0x840 [btrfs]
[ 7839.497829]  [<ffffffffa01d31a2>] btrfs_log_inode+0x6b2/0x990 [btrfs]
[ 7839.497832]  [<ffffffff811a02c4>] ? __sb_start_write+0x54/0x110
[ 7839.497835]  [<ffffffff81185725>] ? kmem_cache_alloc+0x35/0x200
[ 7839.497853]  [<ffffffffa01d41ac>] btrfs_log_inode_parent+0x17c/0x430 [btrfs]
[ 7839.497870]  [<ffffffffa01d44a7>] btrfs_log_dentry_safe+0x47/0x70 [btrfs]
[ 7839.497887]  [<ffffffffa01a9bc5>] btrfs_sync_file+0x175/0x290 [btrfs]
[ 7839.497891]  [<ffffffff811cc4ed>] do_fsync+0x5d/0x90
[ 7839.497894]  [<ffffffff811cc783>] sys_fdatasync+0x13/0x20
[ 7839.497897]  [<ffffffff81658d19>] system_call_fastpath+0x16/0x1b
[ 7839.497899] ---[ end trace 9c6b2d0f618cbb65 ]---
[ 7839.497907] general protection fault: 0000 [#1] SMP
[ 7839.497943] Modules linked in: fuse rfcomm bnep ip6t_REJECT
nf_conntrack_ipv6 nf_defrag_ipv6 nf_conntrack_ipv4 nf_defrag_ipv4
xt_conntrack nf_conntrack w83627ehf ip6table_filter hwmon_vid
ip6_tables uvcvideo snd_hda_codec_realtek snd_hda_intel snd_hda_codec
snd_hwdep videobuf2_vmalloc videobuf2_memops videobuf2_core snd_seq
snd_seq_device coretemp snd_pcm videodev media btusb snd_page_alloc
iTCO_wdt iTCO_vendor_support bluetooth microcode snd_timer lpc_ich snd
rfkill mfd_core r8169 i2c_i801 soundcore mii vhost_net tun macvtap
macvlan kvm_intel kvm uinput i2c_dev binfmt_misc btrfs zlib_deflate
raid6_pq libcrc32c xor ata_generic pata_acpi i915 firewire_ohci video
firewire_core i2c_algo_bit pata_it8213 drm_kms_helper crc_itu_t drm
i2c_core
[ 7839.498006] CPU 1
[ 7839.498006] Pid: 1973, comm: encfs Tainted: G        W
3.8.0-1.BtrfsNextp1.fc18.x86_64 #1 Supermicro C2SEA/C2SEA
[ 7839.498006] RIP: 0010:[<ffffffff8130409d>]  [<ffffffff8130409d>]
memcpy+0xd/0x110
[ 7839.498006] RSP: 0018:ffff8801f2bd7b60  EFLAGS: 00010246
[ 7839.498006] RAX: ffff8801f2bd7bd0 RBX: 0000000000000008 RCX: 0000000000000001
[ 7839.498006] RDX: 0000000000000000 RSI: 0005080000000008 RDI: ffff8801f2bd7bd0
[ 7839.498006] RBP: ffff8801f2bd7ba8 R08: 000000000000000a R09: 00000000000003c4
[ 7839.498006] R10: 0000000000000000 R11: 00000000000003c3 R12: ffff8801f2bd7bd8
[ 7839.498006] R13: ffff880156603020 R14: 0000000000000010 R15: 0000000000000008
[ 7839.498006] FS:  00007f8e6fd28800(0000) GS:ffff880237c80000(0000)
knlGS:0000000000000000
[ 7839.498006] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 7839.498006] CR2: 0000000001adf1f0 CR3: 00000001f843c000 CR4: 00000000000007e0
[ 7839.498006] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 7839.498006] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 7839.498006] Process encfs (pid: 1973, threadinfo ffff8801f2bd6000,
task ffff8801f2b62ec0)
[ 7839.498006] Stack:
[ 7839.498006]  ffffffffa01b8b63 0000000000001000 0000000000001008
ffff8801f2bd7ba8
[ 7839.498006]  0000000000000000 ffff880156603020 0000000000001008
000000000000002d
[ 7839.498006]  0000000000000fdb ffff8801f2bd7c08 ffffffffa01af26c
ffff8801ac6d4000
[ 7839.498006] Call Trace:
[ 7839.498006]  [<ffffffffa01b8b63>] ? read_extent_buffer+0xc3/0x120 [btrfs]
[ 7839.498006]  [<ffffffffa01af26c>] btrfs_get_token_64+0xdc/0xf0 [btrfs]
[ 7839.498006]  [<ffffffffa01a3320>]
btrfs_truncate_inode_items+0x720/0x840 [btrfs]
[ 7839.498006]  [<ffffffffa01d31a2>] btrfs_log_inode+0x6b2/0x990 [btrfs]
[ 7839.498006]  [<ffffffff811a02c4>] ? __sb_start_write+0x54/0x110
[ 7839.498006]  [<ffffffff81185725>] ? kmem_cache_alloc+0x35/0x200
[ 7839.498006]  [<ffffffffa01d41ac>] btrfs_log_inode_parent+0x17c/0x430 [btrfs]
[ 7839.498006]  [<ffffffffa01d44a7>] btrfs_log_dentry_safe+0x47/0x70 [btrfs]
[ 7839.498006]  [<ffffffffa01a9bc5>] btrfs_sync_file+0x175/0x290 [btrfs]
[ 7839.498006]  [<ffffffff811cc4ed>] do_fsync+0x5d/0x90
[ 7839.498006]  [<ffffffff811cc783>] sys_fdatasync+0x13/0x20
[ 7839.498006]  [<ffffffff81658d19>] system_call_fastpath+0x16/0x1b
[ 7839.498006] Code: 2b 43 50 88 43 4e 48 83 c4 08 5b 5d c3 90 e8 eb
fb ff ff eb e6 90 90 90 90 90 90 90 90 90 48 89 f8 48 89 d1 48 c1 e9
03 83 e2 07 <f3> 48 a5 89 d1 f3 a4 c3 20 4c 8b 06 4c 8b 4e 08 4c 8b 56
10 4c
[ 7839.498006] RIP  [<ffffffff8130409d>] memcpy+0xd/0x110
[ 7839.498006]  RSP <ffff8801f2bd7b60>
[ 7839.517244] ---[ end trace 9c6b2d0f618cbb66 ]---
