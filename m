From: Sascha Biermanns <saschakb@gmail.com>
Subject: Re: WARNING: at fs/btrfs/extent-tree.c:5695 btrfs_alloc_free_block+0x22c/0x370
 [btrfs]()
Date: Tue, 31 May 2011 10:30:37 +0200
Message-ID: <4DE4A72D.2070802@gmail.com>
References: <4DE4A30A.9010207@gmail.com> <1306829753-sup-916@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1306829753-sup-916@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

Am 31.05.2011 10:18, schrieb Chris Mason:
> Excerpts from Sascha Biermanns's message of 2011-05-31 04:12:58 -0400:
>> Yesterday, I compiled the new kernel 3.0rc1 from git, but I never
>> successed to go over the point: "Removing old temporary files".
>> Pressing control-c let me boot on, but the pc was the complete time on
>> very high load. It took me minutes, just to reach the tty login - and
>> again minutes after login in, that I had my shell and a prompt to enter
>> something. The load was at that time beyond 10.
>>
>> Now in my /var/log/messages, I found the following warning - and because
>> it happens when "removing" temporary/old files, that might be why the
>> computer has so much trouble:
>>
> 
>> May 30 23:25:17 localhost kernel: [17117.213589] Call Trace:
> 
> Do you have the very first full oops?  This has the call trace, but not
> the beginning text that describes why we've crashed.
> 
> -chris

Hi Chris,

the log starts here - before May 30 21:40:52 there is for 6 hours
nothing. It's the beginning of the logging. I'm sorry to say so, but I'm
absolutely unable to boot into 3.0rc1
I used a complete with luks encrypted btrfs partition, there is only
another /boot partition with ext4 - and this system is running since
march 2010. On other kernels (2.6.38 or 2.6.39) - the logging starts
much more early - but like I said - the load was unbelieveable high the
whole time, the hard disks reached maximum temperature (so it was very
hard to lay the hands on the computer) - and my only explanation are
these entries.


May 30 21:40:52 localhost -- MARK --



May 30 21:41:22 localhost Tor[1422]: We tried for 15 seconds to connect
to '[scrubbed]' using exit 'Amunet8'. Retrying on a new circuit.


May 30 21:41:37 localhost Tor[1422]: We tried for 15 seconds to connect
to '[scrubbed]' using exit 'Wallnut'. Retrying on a new circuit.


May 30 21:41:52 localhost Tor[1422]: We tried for 15 seconds to connect
to '[scrubbed]' using exit 'Amunet6'. Retrying on a new circuit.


May 30 21:42:07 localhost Tor[1422]: We tried for 15 seconds to connect
to '[scrubbed]' using exit 'politkovskaja'. Retrying on a new circuit.


May 30 21:42:22 localhost Tor[1422]: We tried for 15 seconds to connect
to '[scrubbed]' using exit 'BostonUCompSci'. Retrying on a new circuit.


May 30 21:42:37 localhost Tor[1422]: We tried for 15 seconds to connect
to '[scrubbed]' using exit 'rainbowwarrior'. Retrying on a new circuit.


May 30 21:42:52 localhost Tor[1422]: We tried for 15 seconds to connect
to '[scrubbed]' using exit 'ada'. Retrying on a new circuit.


May 30 21:42:52 localhost Tor[1422]: Tried for 125 seconds to get a
connection to [scrubbed]:80. Giving up.


May 30 21:51:10 localhost kernel: [11470.581905] ------------[ cut here
]------------


May 30 21:51:10 localhost kernel: [11470.581965] WARNING: at
fs/btrfs/extent-tree.c:5695 btrfs_alloc_free_block+0x22c/0x370 [btrfs]()


May 30 21:51:10 localhost kernel: [11470.581972] Hardware name: Presario
CQ56 Notebook PC


May 30 21:51:10 localhost kernel: [11470.581976] Modules linked in:
cryptd aes_x86_64 aes_generic ipt_REJECT ipt_LOG xt_limit xt_tcpudp
ipt_addrtype xt_state ip6table_filter ip6_tables nf_nat_irc
nf_conntrack_irc nf_nat_ftp nf
_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack_ftp nf_conntrack
iptable_filter ip_tables x_tables ipv6 fuse cpufreq_conservative
cpufreq_powersave cpufreq_ondemand fglrx(P) snd_hda_codec_realtek
powernow_k8 freq_table mper
f snd_hda_intel snd_hda_codec radeon ttm snd_pcm_oss snd_hwdep joydev
snd_pcm drm_kms_helper drm uvcvideo hp_wmi snd_mixer_oss snd_timer
i2c_algo_bit videodev snd i2c_piix4 soundcore v4l2_compat_ioctl32
sparse_keymap wmi arc4
edac_core evdev snd_page_alloc ecb sp5100_tco battery shpchp processor
sg edac_mce_amd psmouse i2c_core video thermal k10temp pci_hotplug
pcspkr serio_raw button ac brcm80211(C) mac80211 cfg80211 rfkill r8169
mii uvesafb cn sh
a256_generic twofish_generic twofish_x86_64 twofish_common cbc usbhid
hid dm_crypt dm_mod btrfs zlib_deflate crc32c libcrc32c ext4 mbcache
jbd2 crc16 ohci_hcd ehci_hcd sr_mod cdrom usbcore sd_mod ahci libahci
libata scsi_mod


