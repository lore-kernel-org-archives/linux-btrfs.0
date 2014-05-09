Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:35813 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756270AbaEIWhS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 May 2014 18:37:18 -0400
Date: Fri, 9 May 2014 15:36:59 -0700
From: Marc MERLIN <marc@merlins.org>
To: Chris Murphy <lists@colorremedies.com>, bo.li.liu@oracle.com,
        jbacik@fb.com, hugo@carfax.org.uk, dsterba@suse.cz, clm@fb.com
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs cleaner failure - fs/btrfs/extent-tree.c:5748 (3.14.0)
Message-ID: <20140509223659.GW11401@merlins.org>
References: <20140507233959.GB11401@merlins.org>
 <536AD20E.70004@fb.com>
 <20140508004344.GE11401@merlins.org>
 <20140508013440.GH11401@merlins.org>
 <CAKgsxVR=6GTesbtqG_SAyKnpw9pxz1TZ0oOi_MB8Ej3j4-vMiw@mail.gmail.com>
 <20140508220242.GO11401@merlins.org>
 <CAKhhfD5DTPfKvWcRDERxWa_pjfhCkZxW3WBtznYC94EFy7A0mQ@mail.gmail.com>
 <423AB9BE-EDBF-478B-8CED-C1A9A0FAE736@colorremedies.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <423AB9BE-EDBF-478B-8CED-C1A9A0FAE736@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Ok, first for the devs, I found the real trace that happened just before the system went
read only
My apologies for pasting the bad one first.

I'll wipe/rebuild the FS tonight unless you ask me to wait for one more day and/or data off it.

Please advise if I should rebuilt with 3.14.3 or 3.15rc4

Thanks.


Details:
It looks like my corruption came from there.
I'm still not sure why it's apparently so severe that btrfs recovery cannot
open the FS now.

WARNING: CPU: 6 PID: 555 at fs/btrfs/extent-tree.c:5748 __btrfs_free_extent+0x359/0x712()
CPU: 6 PID: 555 Comm: btrfs-cleaner Tainted: G        W    3.14.0-amd64-i915-preempt-20140216 #2
Hardware name: LENOVO 20BECT0/20BECT0, BIOS GMET28WW (1.08 ) 09/18/2013
 0000000000000000 ffff8800cd9f1b38 ffffffff8160a06d 0000000000000000
 ffff8800cd9f1b70 ffffffff81050025 ffffffff812170f6 ffff88013c9cbdf0
 00000000fffffffe 0000000000000000 0000000001856000 ffff8800cd9f1b80
Call Trace:
 [<ffffffff8160a06d>] dump_stack+0x4e/0x7a
 [<ffffffff81050025>] warn_slowpath_common+0x7f/0x98
 [<ffffffff812170f6>] ? __btrfs_free_extent+0x359/0x712
 [<ffffffff810500ec>] warn_slowpath_null+0x1a/0x1c
 [<ffffffff812170f6>] __btrfs_free_extent+0x359/0x712
 [<ffffffff8160f97b>] ? _raw_spin_unlock+0x17/0x2a
 [<ffffffff8126518b>] ? btrfs_check_delayed_seq+0x84/0x90
 [<ffffffff8121c262>] __btrfs_run_delayed_refs+0xa94/0xbdf
 [<ffffffff8113fcf3>] ? __cache_free.isra.39+0x1b4/0x1c3
 [<ffffffff8121df46>] btrfs_run_delayed_refs+0x81/0x18f
 [<ffffffff8121ac3a>] ? walk_up_tree+0x72/0xf9
 [<ffffffff8122af08>] btrfs_should_end_transaction+0x52/0x5b
 [<ffffffff8121cba9>] btrfs_drop_snapshot+0x36f/0x610
 [<ffffffff8160f97b>] ? _raw_spin_unlock+0x17/0x2a
 [<ffffffff8114020e>] ? kfree+0x66/0x85
 [<ffffffff8122c73d>] btrfs_clean_one_deleted_snapshot+0x103/0x10f
 [<ffffffff81224f09>] cleaner_kthread+0x103/0x136
 [<ffffffff81224e06>] ? btrfs_alloc_root+0x26/0x26
 [<ffffffff8106bc62>] kthread+0xae/0xb6
 [<ffffffff8106bbb4>] ? __kthread_parkme+0x61/0x61
 [<ffffffff8161637c>] ret_from_fork+0x7c/0xb0
 [<ffffffff8106bbb4>] ? __kthread_parkme+0x61/0x61


On Fri, May 09, 2014 at 10:19:46AM -0600, Chris Murphy wrote:
> 
> On May 9, 2014, at 4:35 AM, Marc MERLIN <marc@merlins.org> wrote:
> 
> > 
> > Howdy,
> > 
> > I won't have the time to rebuild my laptop tonight, so I'll wait one more
> > day to see if anyone would like data from that fs to see why it crashed and
> > why btrfs recovery doesn't even seem able to open it.
> 
> There's some underlying reason why it went read only, but we don't
> have those messages. The message we do have says the kernel is already
> tainted, so something (possibly entirely unrelated) happened earlier.
 
Oh, I missed that.
May  2 14:23:06 legolas kernel: [283268.319035] CPU: 0 PID: 25726 Comm: watchdog/0 Tainted: G        W    3.14.0-amd64-i915-preempt-20140216 #2
This is weird because I don't use any 3rd party binary modules.

Right now, I do see:
legolas:~# cat /proc/sys/kernel/tainted
512

Mmmh, so I missed up and pasted the wrong error. I found the real one now, pasted below

> > Also I'm not sure if I should risk 3.15rc to rebuild the filesystem and I'd
> > love not to have to say during my talk that even almost latest btrfs
> > corrupts itself without reason and working recovery methods :-/
> 
> Just because the reason isn't yet known or understood yet doesn't mean it's happened without reason. And we also don't know whether it corrupted itself, or had help earlier on. Neither is good, but depending on the cause of the corruption, recovery may not even be realistic.

You're right that there is always a reason :)
(especially now that I see the real error, my fault for missing it the first time)

But I was fairly dismayed that btrfs recovery couldn't even open the filesystem.
I was somehow thinking maybe I gave it the wrong options.
 
> I'd probably consider 3.13.11 if I simply had work that needs to get done rather than testing. If the problem happens there too then you've stumbled on something that isn't likely a regression.

True, although most devs tell you to run the latest, or any problems or bugs are your fault :)
(losely paraphrased :)

> If you've done any suspend/hibernate at all, I'd stop doing that until
> you're in a position to do a lot more rigorous testing. I say that

Thanks for warning me of that.
I only use S3 sleep, oh but you say that's bad too?
I've been using it for more than 10 years, is it now suddenly cause of
kernel and/or filesystem corruption?

> because suspend and hibernate have become so completely unreliable
> for so many people I know doing testing, including myself, that it's
> worth avoiding. I've had lots of corruptions, not just Btrfs, related
> to suspend testing in particular (hibernate doesn't work either but
> it hasn't corrupted the file system). And there's a bunch of new work
> happening on suspend in 3.15 so things are probably about to change
> yet again.
> 
> 
> Chris Murphy--
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

May  7 10:00:24 legolas kernel: [544969.313363] ------------[ cut here ]------------
May  7 10:00:24 legolas kernel: [544969.313372] WARNING: CPU: 6 PID: 555 at fs/btrfs/extent-tree.c:5748 __btrfs_free_extent+0x359/0x712()
May  7 10:00:24 legolas kernel: [544969.313373] Modules linked in: e1000e iwlmvm mac80211 iwlwifi cfg80211 xhci_hcd usb_storage rndis_host cdc_ether btusb uvcvideo usbne
t ehci_pci ehci_hcd usbcore usb_common tun sg nls_utf8 nls_cp437 vfat fat rpcsec_gss_krb5 nfsv4 ctr ccm ipt_MASQUERADE ipt_REJECT xt_tcpudp xt_conntrack xt_LOG iptable_n
at nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle ip6table_filter ip6_tables iptable_filter ip_tables ebtable_nat ebtables x_tables ppde
v cpufreq_powersave cpufreq_userspace cpufreq_conservative cpufreq_stats rfcomm bnep autofs4 binfmt_misc uinput nfsd auth_rpcgss nfs_acl nfs lockd fscache sunrpc configs
 parport_pc lp parport input_polldev loop firewire_sbp2 firewire_core crc_itu_t ecryptfs videobuf2_vmalloc videobuf2_memops videobuf2_core videodev bluetooth 6lowpan_iph
c media joydev arc4 snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss thinkpad_acpi x86_pkg_
temp_thermal s
May  7 10:00:24 legolas kernel: nd_pcm intel_powerclamp nvram coretemp snd_seq_midi snd_seq_midi_event kvm_intel snd_rawmidi kvm crct10dif_pclmul snd_seq crc32_pclmul rt
sx_pci_ms iTCO_wdt iTCO_vendor_support ghash_clmulni_intel snd_seq_device memstick rtsx_pci_sdmmc snd_timer lpc_ich pcspkr microcode psmouse i2c_i801 serio_raw snd rtsx_
pci soundcore tpm_tis rfkill tpm ac battery intel_smartconnect wmi evdev processor sata_sil24 r8169 mii fuse fan raid456 multipath mmc_block mmc_core dm_snapshot dm_bufi
o dm_mirror dm_region_hash dm_log dm_crypt dm_mod async_raid6_recov async_pq async_xor async_memcpy async_tx blowfish_x86_64 blowfish_common ecb xts crc32c_intel aesni_i
ntel aes_x86_64 glue_helper lrw gf128mul ablk_helper cryptd ptp pps_core thermal [last unloaded: e1000e]
May  7 10:00:24 legolas kernel: [544969.313477] CPU: 6 PID: 555 Comm: btrfs-cleaner Tainted: G        W    3.14.0-amd64-i915-preempt-20140216 #2
May  7 10:00:24 legolas kernel: [544969.313478] Hardware name: LENOVO 20BECT0/20BECT0, BIOS GMET28WW (1.08 ) 09/18/2013
May  7 10:00:27 magic watchdog[4518]: still alive after 33667224 interval(s)
May  7 10:00:24 legolas kernel: [544969.313480]  0000000000000000 ffff8800cd9f1b38 ffffffff8160a06d 0000000000000000
May  7 10:00:24 legolas kernel: [544969.313483]  ffff8800cd9f1b70 ffffffff81050025 ffffffff812170f6 ffff88013c9cbdf0
May  7 10:00:24 legolas kernel: [544969.313486]  00000000fffffffe 0000000000000000 0000000001856000 ffff8800cd9f1b80
May  7 10:00:24 legolas kernel: [544969.313489] Call Trace:
May  7 10:00:24 legolas kernel: [544969.313495]  [<ffffffff8160a06d>] dump_stack+0x4e/0x7a
May  7 10:00:24 legolas kernel: [544969.313498]  [<ffffffff81050025>] warn_slowpath_common+0x7f/0x98
May  7 10:00:24 legolas kernel: [544969.313501]  [<ffffffff812170f6>] ? __btrfs_free_extent+0x359/0x712
May  7 10:00:24 legolas kernel: [544969.313503]  [<ffffffff810500ec>] warn_slowpath_null+0x1a/0x1c
May  7 10:00:24 legolas kernel: [544969.313505]  [<ffffffff812170f6>] __btrfs_free_extent+0x359/0x712
May  7 10:00:24 legolas kernel: [544969.313509]  [<ffffffff8160f97b>] ? _raw_spin_unlock+0x17/0x2a
May  7 10:00:24 legolas kernel: [544969.313512]  [<ffffffff8126518b>] ? btrfs_check_delayed_seq+0x84/0x90
May  7 10:00:24 legolas kernel: [544969.313515]  [<ffffffff8121c262>] __btrfs_run_delayed_refs+0xa94/0xbdf
May  7 10:00:24 legolas kernel: [544969.313519]  [<ffffffff8113fcf3>] ? __cache_free.isra.39+0x1b4/0x1c3
May  7 10:00:24 legolas kernel: [544969.313522]  [<ffffffff8121df46>] btrfs_run_delayed_refs+0x81/0x18f
May  7 10:00:24 legolas kernel: [544969.313524]  [<ffffffff8121ac3a>] ? walk_up_tree+0x72/0xf9
May  7 10:00:24 legolas kernel: [544969.313527]  [<ffffffff8122af08>] btrfs_should_end_transaction+0x52/0x5b
May  7 10:00:24 legolas kernel: [544969.313529]  [<ffffffff8121cba9>] btrfs_drop_snapshot+0x36f/0x610
May  7 10:00:24 legolas kernel: [544969.313532]  [<ffffffff8160f97b>] ? _raw_spin_unlock+0x17/0x2a
May  7 10:00:24 legolas kernel: [544969.313535]  [<ffffffff8114020e>] ? kfree+0x66/0x85
May  7 10:00:24 legolas kernel: [544969.313537]  [<ffffffff8122c73d>] btrfs_clean_one_deleted_snapshot+0x103/0x10f
May  7 10:00:24 legolas kernel: [544969.313540]  [<ffffffff81224f09>] cleaner_kthread+0x103/0x136
May  7 10:00:24 legolas kernel: [544969.313543]  [<ffffffff81224e06>] ? btrfs_alloc_root+0x26/0x26
May  7 10:00:24 legolas kernel: [544969.313547]  [<ffffffff8106bc62>] kthread+0xae/0xb6
May  7 10:00:24 legolas kernel: [544969.313549]  [<ffffffff8106bbb4>] ? __kthread_parkme+0x61/0x61
May  7 10:00:24 legolas kernel: [544969.313552]  [<ffffffff8161637c>] ret_from_fork+0x7c/0xb0
May  7 10:00:24 legolas kernel: [544969.313555]  [<ffffffff8106bbb4>] ? __kthread_parkme+0x61/0x61
May  7 10:00:24 legolas kernel: [544969.313557] ---[ end trace 3c290eaa69000def ]---
May  7 10:00:24 legolas kernel: [544969.313559] BTRFS info (device dm-0): leaf 912747659264 total ptrs 24 free space 1499
May  7 10:00:24 legolas kernel: [544969.313561] #011item 0 key (104008687616 168 40960) itemoff 3945 itemsize 50
May  7 10:00:24 legolas kernel: [544969.313563] #011#011extent refs 2 gen 408973 flags 1
May  7 10:00:24 legolas kernel: [544969.313565] #011#011shared data backref parent 912962129920 count 1
May  7 10:00:24 legolas kernel: [544969.313566] #011#011shared data backref parent 912962125824 count 1
May  7 10:00:24 legolas kernel: [544969.313567] #011item 1 key (104008728576 168 24576) itemoff 3866 itemsize 79
May  7 10:00:24 legolas kernel: [544969.313569] #011#011extent refs 3 gen 408973 flags 1
May  7 10:00:24 legolas kernel: [544969.313570] #011#011extent data backref root 260 objectid 6686893 offset 23666688 count 1
May  7 10:00:24 legolas kernel: [544969.313571] #011#011shared data backref parent 912962129920 count 1
May  7 10:00:24 legolas kernel: [544969.313573] #011#011shared data backref parent 912962125824 count 1
May  7 10:00:24 legolas kernel: [544969.313577] #011#011extent data backref root 260 objectid 6686893 offset 24158208 count 1
May  7 10:00:24 legolas kernel: [544969.313578] #011#011shared data backref parent 912962129920 count 1
May  7 10:00:24 legolas kernel: [544969.313579] #011#011shared data backref parent 912962125824 count 1
May  7 10:00:24 legolas kernel: [544969.313580] #011item 3 key (104008769536 168 8192) itemoff 3721 itemsize 66
May  7 10:00:24 legolas kernel: [544969.313587] #011#011extent refs 3 gen 408973 flags 1
May  7 10:00:24 legolas kernel: [544969.313588] #011#011extent data backref root 260 objectid 6686893 offset 24764416 count 1
May  7 10:00:24 legolas kernel: [544969.313589] #011#011shared data backref parent 828578291712 count 1
May  7 10:00:24 legolas kernel: [544969.313590] #011#011shared data backref parent 33737228288 count 1
May  7 10:00:24 legolas kernel: [544969.313596] #011#011shared data backref parent 33737228288 count 1
May  7 10:00:24 legolas kernel: [544969.313598] #011item 6 key (104008794112 168 8192) itemoff 3484 itemsize 79
May  7 10:00:24 legolas kernel: [544969.313599] #011#011extent refs 3 gen 408973 flags 1
May  7 10:00:24 legolas kernel: [544969.313600] #011#011extent data backref root 260 objectid 6686893 offset 25247744 count 1
May  7 10:00:24 legolas kernel: [544969.313604] #011item 7 key (104008802304 168 90112) itemoff 3434 itemsize 50
May  7 10:00:24 legolas kernel: [544969.313605] #011#011extent refs 6 gen 408973 flags 1
May  7 10:00:24 legolas kernel: [544969.313606] #011#011shared data backref parent 828578291712 count 3
May  7 10:00:24 legolas kernel: [544969.313607] #011#011shared data backref parent 33737228288 count 3
May  7 10:00:24 legolas kernel: [544969.313609] #011item 8 key (104008892416 168 16384) itemoff 3358 itemsize 76
May  7 10:00:24 legolas kernel: [544969.313610] #011#011extent refs 4 gen 408973 flags 1
May  7 10:00:24 legolas kernel: [544969.313611] #011#011shared data backref parent 912774037504 count 1
May  7 10:00:24 legolas kernel: [544969.313612] #011#011shared data backref parent 828844236800 count 1
May  7 10:00:24 legolas kernel: [544969.313613] #011#011shared data backref parent 828556988416 count 1
May  7 10:00:24 legolas kernel: [544969.313614] #011#011shared data backref parent 828556984320 count 1
May  7 10:00:24 legolas kernel: [544969.313616] #011item 9 key (104008908800 168 8192) itemoff 3282 itemsize 76
May  7 10:00:24 legolas kernel: [544969.313617] #011#011extent refs 4 gen 408973 flags 1
May  7 10:00:24 legolas kernel: [544969.313618] #011#011shared data backref parent 912774037504 count 1
May  7 10:00:24 legolas kernel: [544969.313619] #011#011shared data backref parent 828844236800 count 1
May  7 10:00:24 legolas kernel: [544969.313621] #011#011shared data backref parent 828556988416 count 1
May  7 10:00:24 legolas kernel: [544969.313622] #011#011shared data backref parent 828556984320 count 1
May  7 10:00:24 legolas kernel: [544969.313623] #011item 10 key (104008916992 168 16384) itemoff 3219 itemsize 63
May  7 10:00:24 legolas kernel: [544969.313624] #011#011extent refs 3 gen 408973 flags 1
May  7 10:00:24 legolas kernel: [544969.313625] #011#011shared data backref parent 828844236800 count 1
May  7 10:00:24 legolas kernel: [544969.313626] #011#011shared data backref parent 828556988416 count 1
May  7 10:00:24 legolas kernel: [544969.313628] #011#011shared data backref parent 828556984320 count 1
May  7 10:00:24 legolas kernel: [544969.313629] #011item 11 key (104008933376 168 40960) itemoff 3156 itemsize 63
May  7 10:00:24 legolas kernel: [544969.313630] #011#011extent refs 3 gen 408973 flags 1
May  7 10:00:24 legolas kernel: [544969.313631] #011#011shared data backref parent 828844236800 count 1
May  7 10:00:24 legolas kernel: [544969.313632] #011#011shared data backref parent 828556988416 count 1
May  7 10:00:24 legolas kernel: [544969.313633] #011#011shared data backref parent 828556984320 count 1
May  7 10:00:24 legolas kernel: [544969.313635] #011item 12 key (104008974336 168 8192) itemoff 3093 itemsize 63
May  7 10:00:24 legolas kernel: [544969.313636] #011#011extent refs 3 gen 408973 flags 1
May  7 10:00:24 legolas kernel: [544969.313637] #011#011shared data backref parent 828844236800 count 1
May  7 10:00:24 legolas kernel: [544969.313638] #011#011shared data backref parent 828556988416 count 1
May  7 10:00:24 legolas kernel: [544969.313639] #011#011shared data backref parent 828556984320 count 1
May  7 10:00:24 legolas kernel: [544969.313641] #011item 13 key (104008982528 168 155648) itemoff 2988 itemsize 105
May  7 10:00:24 legolas kernel: [544969.313642] #011#011extent refs 5 gen 408973 flags 1
May  7 10:00:24 legolas kernel: [544969.313643] #011#011extent data backref root 260 objectid 6686893 offset 26107904 count 1
May  7 10:00:24 legolas kernel: [544969.313645] #011#011shared data backref parent 912774037504 count 1
May  7 10:00:24 legolas kernel: [544969.313646] #011#011shared data backref parent 828844236800 count 1
May  7 10:00:24 legolas kernel: [544969.313647] #011#011shared data backref parent 828556988416 count 1
May  7 10:00:24 legolas kernel: [544969.313648] #011#011shared data backref parent 828556984320 count 1
May  7 10:00:24 legolas kernel: [544969.313649] #011item 14 key (104009138176 168 155648) itemoff 2912 itemsize 76
May  7 10:00:24 legolas kernel: [544969.313650] #011#011extent refs 4 gen 408973 flags 1
May  7 10:00:24 legolas kernel: [544969.313652] #011#011shared data backref parent 828579962880 count 1
May  7 10:00:24 legolas kernel: [544969.313653] #011#011shared data backref parent 828571164672 count 1
May  7 10:00:24 legolas kernel: [544969.313654] #011#011shared data backref parent 827921731584 count 1
May  7 10:00:24 legolas kernel: [544969.313659] #011#011shared data backref parent 828579962880 count 1
May  7 10:00:24 legolas kernel: [544969.313660] #011#011shared data backref parent 828571164672 count 1
May  7 10:00:24 legolas kernel: [544969.313661] #011#011shared data backref parent 827921731584 count 1
May  7 10:00:24 legolas kernel: [544969.313662] #011#011shared data backref parent 389932756992 count 1
May  7 10:00:24 legolas kernel: [544969.313668] #011#011shared data backref parent 827921731584 count 1
May  7 10:00:24 legolas kernel: [544969.313669] #011#011shared data backref parent 389932756992 count 1
May  7 10:00:24 legolas kernel: [544969.313670] #011item 17 key (104009359360 168 8192) itemoff 2723 itemsize 37
May  7 10:00:24 legolas kernel: [544969.313671] #011#011extent refs 1 gen 408973 flags 1
May  7 10:00:24 legolas kernel: [544969.313678] #011#011shared data backref parent 912997703680 count 1
May  7 10:00:24 legolas kernel: [544969.313679] #011#011shared data backref parent 912997625856 count 1
May  7 10:00:24 legolas kernel: [544969.313680] #011#011shared data backref parent 912776679424 count 1
May  7 10:00:24 legolas kernel: [544969.313681] #011#011shared data backref parent 827921891328 count 1
May  7 10:00:24 legolas kernel: [544969.313687] #011item 20 key (104009392128 168 49152) itemoff 2398 itemsize 170
May  7 10:00:24 legolas kernel: [544969.313688] #011#011extent refs 11 gen 408973 flags 1
May  7 10:00:24 legolas kernel: [544969.313690] #011#011extent data backref root 260 objectid 6686893 offset 27041792 count 2
May  7 10:00:24 legolas kernel: [544969.313691] #011#011shared data backref parent 912997703680 count 1
May  7 10:00:24 legolas kernel: [544969.313696] #011#011shared data backref parent 827921891328 count 1
May  7 10:00:24 legolas kernel: [544969.313697] #011#011shared data backref parent 827921731584 count 1
May  7 10:00:24 legolas kernel: [544969.313699] #011#011shared data backref parent 389932756992 count 1
May  7 10:00:24 legolas kernel: [544969.313700] #011#011shared data backref parent 18480386048 count 1
May  7 10:00:24 legolas kernel: [544969.313706] #011#011shared data backref parent 827921731584 count 1
May  7 10:00:24 legolas kernel: [544969.313707] #011#011shared data backref parent 389932756992 count 1
May  7 10:00:24 legolas kernel: [544969.313708] #011item 22 key (104009539584 168 81920) itemoff 2217 itemsize 105
May  7 10:00:24 legolas kernel: [544969.313709] #011#011extent refs 5 gen 408973 flags 1
May  7 10:00:24 legolas kernel: [544969.313711] #011#011extent data backref root 260 objectid 6686893 offset 26943488 count 1

-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
