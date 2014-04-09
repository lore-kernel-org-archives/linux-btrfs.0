Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:39462 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932461AbaDIPnA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Apr 2014 11:43:00 -0400
Date: Wed, 9 Apr 2014 08:42:59 -0700
From: Marc MERLIN <marc@merlins.org>
To: Chris Mason <clm@fb.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Upgrade to 3.14.0 messed up raid0 array (btrfs cleaner crashes in fs/btrfs/extent-tree.c:5748 and fs/btrfs/free-space-cache.c:1183 )
Message-ID: <20140409154259.GM10789@merlins.org>
References: <20140408153609.GE23524@merlins.org> <20140408220903.GV9923@merlins.org> <53448AFA.4080601@fb.com> <20140409043125.GI10789@merlins.org> <20140409053139.GJ10789@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140409053139.GJ10789@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 08, 2014 at 10:31:39PM -0700, Marc MERLIN wrote:
> On Tue, Apr 08, 2014 at 09:31:25PM -0700, Marc MERLIN wrote:
> > On Tue, Apr 08, 2014 at 07:49:14PM -0400, Chris Mason wrote:
> > > 
> > > 
> > > On 04/08/2014 06:09 PM, Marc MERLIN wrote:
> > > >I forgot to add that while I'm not sure if anyone ended up looking at the
> > > >last image I made regarding
> > > >https://bugzilla.kernel.org/show_bug.cgi?id=72801
> > > >
> > > >I can generate a an image of that filesystem if that helps, or try other
> > > >commands which hopefully won't crash my running server :)
> > > >(filesystem is almost 2TB, so the image will again be big)
> > > >
> > > 
> > > Hi Marc,
> > > 
> > > So from the messages it looks like your space cache is corrupted.  Lets 
> > > start with clearing the space cache and running fsck and seeing exactly 
> > > what is wrong.
> > 
> > gargamel:~# mount  -o clear_cache /dev/dm-4 /mnt/mnt
> > [48132.661274] BTRFS: device label btrfs_raid0 devid 1 transid 50567 /dev/mapper/raid0d1
> > [48132.703063] BTRFS info (device dm-5): force clearing of disk cache
> > [48132.724780] BTRFS info (device dm-5): disk space caching is enabled

So, I tried again this morning, mounted with clear_cache, let the clearer
process work a bit:
root     25187  0.0  0.0      0     0 ?        S    07:56   0:00 [btrfs-freespace]
but even though I did not have the FS mounted, after just one minute, the
kernel went into that death loop again.

Then (2nd log below), I tried mounting with -o clear_cache,nospace_cache and 
had the same problem too.

I'll wait on your next suggestion, with maybe how you'd like me to run btrfsck

Thanks,
Marc



[37652.548583] BTRFS: device label btrfs_raid0 devid 2 transid 50571 /dev/mapper/raid0d2
[37652.757397] BTRFS info (device dm-5): force clearing of disk cache
[37652.779375] BTRFS info (device dm-5): disk space caching is enabled
[37842.582194] WARNING: CPU: 2 PID: 25231 at fs/btrfs/extent-tree.c:5748 __btrfs_free_extent+0x359/0x712()
[37842.613790] Modules linked in: udp_diag tcp_diag inet_diag ip6table_filter ip6_tables ebtable_nat ebtables tun ppdev lp autofs4 binfmt_misc kl5kusb105 deflate ctr twofish_avx_x86_64 twofish_x86_64_3way twofish_x86_64 twofish_generic twofish_common camellia_x86_64 camellia_generic serpent_sse2_x86_64 serpent_avx_x86_64 glue_helper lrw serpent_generic blowfish_x86_64 blowfish_generic blowfish_common cast5_avx_x86_64 ablk_helper cast5_generic cast_common des_generic cmac xcbc rmd160 sha512_ssse3 sha512_generic ftdi_sio crypto_null keyspan af_key xfrm_algo dm_mirror dm_region_hash dm_log nfsd nfs_acl auth_rpcgss nfs fscache lockd sunrpc ipt_REJECT xt_conntrack xt_nat xt_tcpudp xt_LOG iptable_mangle iptable_filter aes_x86_64 lm85 hwmon_vid dm_snapshot dm_bufio iptable_nat ip_tables nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_conntrack_ftp ipt_MASQUERADE nf_nat x_tables nf_conntrack sg st snd_pcm_oss snd_mixer_oss fuse microcode snd_hda_codec_realtek snd_cmipci snd_hda_codec_generic kvm_intel gameport kvm eeepc_wmi snd_hda_intel asus_wmi sparse_keymap snd_opl3_lib snd_mpu401_uart snd_seq_midi snd_hda_codec rfkill snd_seq_midi_event snd_seq snd_rawmidi snd_hwdep snd_pcm snd_timer tpm_infineon battery snd_seq_device wmi coretemp processor rc_ati_x10 pl2303 pcspkr snd intel_rapl asix tpm_tis x86_pkg_temp_thermal parport_pc ati_remote libphy ezusb soundcore i2c_i801 parport tpm intel_powerclamp rc_core lpc_ich xhci_hcd usbnet usbserial evdev xts gf128mul dm_crypt dm_mod raid456 async_raid6_recov async_pq async_xor async_memcpy async_tx e1000e ptp pps_core crc32_pclmul crc32c_intel ehci_pci sata_sil24 r8169 ehci_hcd thermal mii crct10dif_pclmul fan sata_mv ghash_clmulni_intel cryptd usbcore usb_common [last unloaded: kl5kusb105]
[37843.113872] CPU: 2 PID: 25231 Comm: btrfs-cleaner Not tainted 3.14.0-amd64-i915-preempt-20140216 #2
[37843.143161] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 3806 08/20/2012
[37843.143161] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 3806 08/20/2012
[37843.172720]  0000000000000000 ffff880076d15b38 ffffffff8160a06d 0000000000000000
[37843.197245]  ffff880076d15b70 ffffffff81050025 ffffffff812170f6 ffff8801bbdf3580
[37843.221785]  00000000fffffffe 0000000ee0610000 0000000000000000 ffff880076d15b80
[37843.246199] Call Trace:
[37843.255694]  [<ffffffff8160a06d>] dump_stack+0x4e/0x7a
[37843.273251]  [<ffffffff81050025>] warn_slowpath_common+0x7f/0x98
[37843.293448]  [<ffffffff812170f6>] ? __btrfs_free_extent+0x359/0x712
[37843.314212]  [<ffffffff810500ec>] warn_slowpath_null+0x1a/0x1c
[37843.334376]  [<ffffffff812170f6>] __btrfs_free_extent+0x359/0x712
[37843.354692]  [<ffffffff8160f97b>] ? _raw_spin_unlock+0x17/0x2a
[37843.374076]  [<ffffffff8126518b>] ? btrfs_check_delayed_seq+0x84/0x90
[37843.395273]  [<ffffffff8121c262>] __btrfs_run_delayed_refs+0xa94/0xbdf
[37843.417102]  [<ffffffff8113fcf3>] ? __cache_free.isra.39+0x1b4/0x1c3
[37843.437969]  [<ffffffff8121df46>] btrfs_run_delayed_refs+0x81/0x18f
[37843.458651]  [<ffffffff8121ac3a>] ? walk_up_tree+0x72/0xf9
[37843.476870]  [<ffffffff8122af08>] btrfs_should_end_transaction+0x52/0x5b
[37843.498825]  [<ffffffff8121cba9>] btrfs_drop_snapshot+0x36f/0x610
[37843.518879]  [<ffffffff8122c73d>] btrfs_clean_one_deleted_snapshot+0x103/0x10f
[37843.542271]  [<ffffffff81224f09>] cleaner_kthread+0x103/0x136
[37843.561253]  [<ffffffff81224e06>] ? btrfs_alloc_root+0x26/0x26
[37843.580455]  [<ffffffff8106bc62>] kthread+0xae/0xb6
[37843.597117]  [<ffffffff8106bbb4>] ? __kthread_parkme+0x61/0x61
[37843.616153]  [<ffffffff8161637c>] ret_from_fork+0x7c/0xb0
[37843.633875]  [<ffffffff8106bbb4>] ? __kthread_parkme+0x61/0x61
[37843.652855] ---[ end trace 12ad5103b5a879ce ]---
[37843.668162] BTRFS info (device dm-5): leaf 307314688 total ptrs 134 free space 7975
[37843.692552]  item 0 key (1125730791424 168 40960) itemoff 16246 itemsize 37
[37843.714875]          extent refs 1 gen 12770 flags 1
[37843.729365]          shared data backref parent 223898337280 count 1
[37843.748012]  item 1 key (1125732311040 168 40960) itemoff 16209 itemsize 37
[37843.770332]          extent refs 1 gen 12770 flags 1
[37843.784809]          shared data backref parent 223898337280 count 1



For fun, I tried this:
gargamel:~# mount -o clear_cache,nospace_cache LABEL=btrfs_raid0   /mnt/btrfs_raid0 
and then looked at the mounted filesystem. It very quickly crashed the kernel with a looping of:

gargamel login: [  505.952090] BTRFS: device label btrfs_raid0 devid 2 transid 50573 /dev/mapper/raid0d2
[  505.990811] BTRFS info (device dm-5): force clearing of disk cache
[  506.009489] BTRFS info (device dm-5): disabling disk space caching
[  541.494536] ------------[ cut here ]------------
[  541.508444] WARNING: CPU: 2 PID: 16979 at fs/btrfs/extent-tree.c:5748 __btrfs_free_extent+0x359/0x712()
[  541.536672] Modules linked in: ip6table_filter ip6_tables ebtable_nat ebtables tun ppdev lp autofs4 binfmt_misc kl5kusb105 ftdi_sio keyspan deflate ctr twofish_avx_x86_64 twofish_x86_64_3way twofish_x86_64 twofish_generic twofish_common camellia_x86_64 camellia_generic serpent_sse2_x86_64 serpent_avx_x86_64 glue_helper lrw serpent_generic blowfish_x86_64 blowfish_generic blowfish_common cast5_avx_x86_64 ablk_helper cast5_generic cast_common des_generic cmac xcbc rmd160 sha512_ssse3 sha512_generic crypto_null af_key xfrm_algo dm_mirror dm_region_hash dm_log nfsd nfs_acl auth_rpcgss nfs fscache lockd sunrpc ipt_REJECT xt_conntrack xt_nat xt_tcpudp xt_LOG iptable_mangle iptable_filter aes_x86_64 lm85 hwmon_vid dm_snapshot dm_bufio iptable_nat ip_tables nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_conntrack_ftp ipt_MASQUERADE nf_nat x_tables nf_conntrack sg st snd_pcm_oss snd_mixer_oss fuse microcode snd_hda_codec_realtek snd_hda_codec_generic eeepc_wmi kvm_intel asus_wmi snd_cmipci kvm gameport sparse_keymap rfkill snd_hda_intel snd_opl3_lib snd_mpu401_uart snd_hda_codec coretemp snd_seq_midi snd_seq_midi_event rc_ati_x10 snd_hwdep snd_seq asix snd_pcm ati_remote intel_rapl battery pcspkr evdev wmi tpm_infineon snd_rawmidi processor libphy snd_timer snd_seq_device lpc_ich parport_pc rc_core i2c_i801 pl2303 parport usbnet x86_pkg_temp_thermal intel_powerclamp ezusb xhci_hcd tpm_tis usbserial snd tpm soundcore xts gf128mul dm_crypt dm_mod raid456 async_raid6_recov async_pq async_xor async_memcpy async_tx e1000e ptp pps_core ehci_pci ehci_hcd sata_sil24 crc32_pclmul crc32c_intel sata_mv crct10dif_pclmul usbcore thermal r8169 mii fan ghash_clmulni_intel cryptd usb_common [last unloaded: kl5kusb105]
[  541.995046] CPU: 2 PID: 16979 Comm: find Not tainted 3.14.0-amd64-i915-preempt-20140216 #2
[  542.019859] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 3806 08/20/2012
[  542.047285]  0000000000000000 ffff8800a44fdb58 ffffffff8160a06d 0000000000000000
[  542.069689]  ffff8800a44fdb90 ffffffff81050025 ffffffff812170f6 ffff88020787e7c0
[  542.092095]  00000000fffffffe 0000000ee0610000 0000000000000000 ffff8800a44fdba0
[  542.114496] Call Trace:
[  542.121862]  [<ffffffff8160a06d>] dump_stack+0x4e/0x7a
[  542.137306]  [<ffffffff81050025>] warn_slowpath_common+0x7f/0x98
[  542.155348]  [<ffffffff812170f6>] ? __btrfs_free_extent+0x359/0x712
[  542.174188]  [<ffffffff810500ec>] warn_slowpath_null+0x1a/0x1c
[  542.191733]  [<ffffffff812170f6>] __btrfs_free_extent+0x359/0x712
[  542.210059]  [<ffffffff8107c300>] ? account_entity_enqueue+0xd/0x8b
[  542.228885]  [<ffffffff8160f97b>] ? _raw_spin_unlock+0x17/0x2a
[  542.246418]  [<ffffffff8126518b>] ? btrfs_check_delayed_seq+0x84/0x90
[  542.265754]  [<ffffffff8121c262>] __btrfs_run_delayed_refs+0xa94/0xbdf
[  542.286760]  [<ffffffff81218c3d>] ? reserve_metadata_bytes+0x1b2/0x723
[  542.307720]  [<ffffffff8121df46>] btrfs_run_delayed_refs+0x81/0x18f
[  542.327888]  [<ffffffff8122c13f>] __btrfs_end_transaction+0xe1/0x2c6
[  542.348690]  [<ffffffff8122c334>] btrfs_end_transaction+0x10/0x12
[  542.368326]  [<ffffffff812306c1>] btrfs_dirty_inode+0x8f/0xac
[  542.386876]  [<ffffffff8123075c>] btrfs_update_time+0x7e/0x8c
[  542.405559]  [<ffffffff81169daf>] update_time+0x25/0xb4
[  542.422629]  [<ffffffff8116a528>] touch_atime+0xe8/0x121
[  542.440005]  [<ffffffff81164148>] iterate_dir+0x84/0xa6
[  542.457091]  [<ffffffff8119516b>] compat_sys_getdents64+0x7d/0xd9
[  542.476786]  [<ffffffff81193acb>] ? compat_filldir+0xf8/0xf8
[  542.495114]  [<ffffffff810a13f3>] ? current_kernel_time+0xe/0x32
[  542.514653]  [<ffffffff8161812c>] sysenter_dispatch+0x7/0x21
[  542.533315] ---[ end trace ada256a83cb53c26 ]---
[  542.548714] BTRFS info (device dm-5): leaf 123420672 total ptrs 134 free space 7975
[  542.573374]  item 0 key (1125730791424 168 40960) itemoff 16246 itemsize 37
[  542.595682]          extent refs 1 gen 12770 flags 1
[  542.610165]          shared data backref parent 223898337280 count 1
[  542.628775]  item 1 key (1125732311040 168 40960) itemoff 16209 itemsize 37
[  542.651009]          extent refs 1 gen 12770 flags 1
[  542.665505]          shared data backref parent 223898337280 count 1
[  542.684047]  item 2 key (1125733752832 168 40960) itemoff 16172 itemsize 37
[  542.706425]          extent refs 1 gen 12770 flags 1
[  542.720730]          shared data backref parent 223898337280 count 1
[  542.739209]  item 3 key (1125738274816 168 40960) itemoff 16135 itemsize 37
[  542.761287]          extent refs 1 gen 12770 flags 1
[  542.775553]          shared data backref parent 223898337280 count 1
[  542.793946]  item 4 key (1125740027904 168 40960) itemoff 16098 itemsize 37
[  542.815973]          extent refs 1 gen 12770 flags 1


-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
