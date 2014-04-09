Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:33949 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766AbaDIFbl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Apr 2014 01:31:41 -0400
Date: Tue, 8 Apr 2014 22:31:39 -0700
From: Marc MERLIN <marc@merlins.org>
To: Chris Mason <clm@fb.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Upgrade to 3.14.0 messed up raid0 array (btrfs cleaner crashes in fs/btrfs/extent-tree.c:5748 and fs/btrfs/free-space-cache.c:1183 )
Message-ID: <20140409053139.GJ10789@merlins.org>
References: <20140408153609.GE23524@merlins.org> <20140408220903.GV9923@merlins.org> <53448AFA.4080601@fb.com> <20140409043125.GI10789@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140409043125.GI10789@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 08, 2014 at 09:31:25PM -0700, Marc MERLIN wrote:
> On Tue, Apr 08, 2014 at 07:49:14PM -0400, Chris Mason wrote:
> > 
> > 
> > On 04/08/2014 06:09 PM, Marc MERLIN wrote:
> > >I forgot to add that while I'm not sure if anyone ended up looking at the
> > >last image I made regarding
> > >https://bugzilla.kernel.org/show_bug.cgi?id=72801
> > >
> > >I can generate a an image of that filesystem if that helps, or try other
> > >commands which hopefully won't crash my running server :)
> > >(filesystem is almost 2TB, so the image will again be big)
> > >
> > 
> > Hi Marc,
> > 
> > So from the messages it looks like your space cache is corrupted.  Lets 
> > start with clearing the space cache and running fsck and seeing exactly 
> > what is wrong.
> 
> gargamel:~# mount  -o clear_cache /dev/dm-4 /mnt/mnt
> [48132.661274] BTRFS: device label btrfs_raid0 devid 1 transid 50567 /dev/mapper/raid0d1
> [48132.703063] BTRFS info (device dm-5): force clearing of disk cache
> [48132.724780] BTRFS info (device dm-5): disk space caching is enabled
> 
> Mmmh, I've never had much luck with btrfsck
> 
> > An image will definitely help if you have a pipe big enough to upload it.
> 
> Mmmh, I guess I should have taken this before the clear_cache mount, but
> even after that, I still got the crash, so let me take an image first
> 
> Then, what fsck options do you recommend?

Here is the image (1.5GB):
http://marc.merlins.org/tmp/btrfs-raid0-image

Please let me know when I can remove it.

It was taken right after I tried a mount again, and soon after got:

[48297.721718] BTRFS: device label btrfs_raid0 devid 2 transid 50567 /dev/mapper/raid0d2
[48317.369527] ------------[ cut here ]------------
[48317.385559] WARNING: CPU: 3 PID: 13019 at fs/btrfs/extent-tree.c:5748 __btrfs_free_extent+0x359/0x712()
[48317.415941] Modules linked in: ip6table_filter ip6_tables ebtable_nat ebtables tun ppdev lp autofs4 binfmt_misc kl5kusb105 deflate ctr twofish_avx_x86_64 twofish_x86_64_3way twofish_x86_64 twofish_generic twofish_common camellia_x86_64 camellia_generic serpent_sse2_x86_64 serpent_avx_x86_64 glue_helper lrw serpent_generic blowfish_x86_64 blowfish_generic blowfish_common cast5_avx_x86_64 ablk_helper cast5_generic cast_common des_generic cmac xcbc rmd160 sha512_ssse3 sha512_generic ftdi_sio crypto_null keyspan af_key xfrm_algo dm_mirror dm_region_hash dm_log nfsd nfs_acl auth_rpcgss nfs fscache lockd sunrpc ipt_REJECT xt_conntrack xt_nat xt_tcpudp xt_LOG iptable_mangle iptable_filter aes_x86_64 lm85 hwmon_vid dm_snapshot dm_bufio iptable_nat ip_tables nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_conntrack_ftp ipt_MASQUERADE nf_nat x_tables nf_conntrack sg st snd_pcm_oss snd_mixer_oss fuse eeepc_wmi microcode asus_wmi kvm_intel sparse_keymap snd_hda_codec_realtek rfkill snd_hda_codec_generic kvm snd_cmipci gameport snd_hda_intel snd_opl3_lib snd_mpu401_uart snd_seq_midi snd_hda_codec snd_seq_midi_event snd_seq snd_rawmidi snd_hwdep asix snd_pcm snd_timer battery tpm_infineon snd_seq_device coretemp libphy processor wmi pl2303 pcspkr snd parport_pc intel_rapl i2c_i801 usbnet rc_ati_x10 parport lpc_ich xhci_hcd tpm_tis ati_remote x86_pkg_temp_thermal intel_powerclamp evdev tpm rc_core soundcore usbserial ezusb xts gf128mul dm_crypt dm_mod raid456 async_raid6_recov async_pq async_xor async_memcpy async_tx e1000e ptp pps_core ehci_pci ehci_hcd crc32_pclmul crc32c_intel sata_sil24 crct10dif_pclmul ghash_clmulni_intel thermal cryptd fan r8169 mii usbcore usb_common sata_mv [last unloaded: kl5kusb105]
[48317.913132] CPU: 3 PID: 13019 Comm: btrfs-cleaner Not tainted 3.14.0-amd64-i915-preempt-20140216 #2
[48317.943303] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 3806 08/20/2012
[48317.973797]  0000000000000000 ffff8801bbfd5b38 ffffffff8160a06d 0000000000000000
[48317.998522]  ffff8801bbfd5b70 ffffffff81050025 ffffffff812170f6 ffff880211af3970
[48318.022993]  00000000fffffffe 0000000ee05cc000 0000000000000000 ffff8801bbfd5b80
[48318.047511] Call Trace:
[48318.057221]  [<ffffffff8160a06d>] dump_stack+0x4e/0x7a
[48318.074556]  [<ffffffff81050025>] warn_slowpath_common+0x7f/0x98
[48318.095323]  [<ffffffff812170f6>] ? __btrfs_free_extent+0x359/0x712
[48318.116854]  [<ffffffff810500ec>] warn_slowpath_null+0x1a/0x1c
[48318.136119]  [<ffffffff812170f6>] __btrfs_free_extent+0x359/0x712
[48318.156327]  [<ffffffff8160f97b>] ? _raw_spin_unlock+0x17/0x2a
[48318.175732]  [<ffffffff8126518b>] ? btrfs_check_delayed_seq+0x84/0x90
[48318.196996]  [<ffffffff8121c262>] __btrfs_run_delayed_refs+0xa94/0xbdf
[48318.218542]  [<ffffffff8113fcf3>] ? __cache_free.isra.39+0x1b4/0x1c3
[48318.239536]  [<ffffffff8121df46>] btrfs_run_delayed_refs+0x81/0x18f
[48318.260623]  [<ffffffff8121ac3a>] ? walk_up_tree+0x72/0xf9
[48318.279115]  [<ffffffff8122af08>] btrfs_should_end_transaction+0x52/0x5b
[48318.301178]  [<ffffffff8121cba9>] btrfs_drop_snapshot+0x36f/0x610
[48318.321381]  [<ffffffff8122c73d>] btrfs_clean_one_deleted_snapshot+0x103/0x10f
[48318.344943]  [<ffffffff81224f09>] cleaner_kthread+0x103/0x136
[48318.363935]  [<ffffffff81224e06>] ? btrfs_alloc_root+0x26/0x26
[48318.383334]  [<ffffffff8106bc62>] kthread+0xae/0xb6
[48318.399802]  [<ffffffff8106bbb4>] ? __kthread_parkme+0x61/0x61
[48318.419029]  [<ffffffff8161637c>] ret_from_fork+0x7c/0xb0
[48318.436931]  [<ffffffff8106bbb4>] ? __kthread_parkme+0x61/0x61
[48318.456118] ---[ end trace 88f99f6aed83f7e4 ]---
[48318.471916] BTRFS info (device dm-5): leaf 300367872 total ptrs 186 free space 4751
[48318.496465]  item 0 key (1125730791424 168 40960) itemoff 16246 itemsize 37
[48318.518933]          extent refs 1 gen 12770 flags 1
[48318.533698]          shared data backref parent 223898337280 count 1
[48318.552449]  item 1 key (1125732311040 168 40960) itemoff 16209 itemsize 37
[48318.574986]          extent refs 1 gen 12770 flags 1
[48318.589596]          shared data backref parent 223898337280 count 1
[48318.608403]  item 2 key (1125733752832 168 40960) itemoff 16172 itemsize 37
[48318.630736]          extent refs 1 gen 12770 flags 1
[48318.645735]          shared data backref parent 223898337280 count 1
[48318.664534]  item 3 key (1125738274816 168 40960) itemoff 16135 itemsize 37
(...)

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
