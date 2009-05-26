From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Oops on a converted ext4 system
Date: Tue, 26 May 2009 05:14:04 -0400
Message-ID: <20090526091404.GA25723@think>
References: <4A1B8BD0.6050203@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Tomasz Chmielewski <mangoo@wpkg.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4A1B8BD0.6050203@wpkg.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 26, 2009 at 08:27:28AM +0200, Tomasz Chmielewski wrote:
> I converted an ext4 filesystem with btrfs-convert, mounted it, and wanted to do "lzop -d ...".
>
> The result was an immediate Oops (btrfs is on LVM, on dm-crypt, on /dev/sdb which is USB-connected).
>
>
> mini-904.img.lzo dentry_open failed
> BUG: unable to handle kernel paging request at ffffffcd
> IP: [<c01b5f36>] fput+0x6/0x30
> *pde = 00575067 *pte = 00000000
> Oops: 0002 [#1] SMP
> last sysfs file: /sys/block/sda/removable
> Modules linked in: kqemu sha256_generic aes_i586 aes_generic cbc usb_storage dm_crypt btrfs zlib_deflate crc32c libcrc32c tun radeon drm usblp af_packet ipv6 binfmt_misc loop dm_mirror dm_region_hash dm_log dm_mod cpufreq_ondemand cpufreq_conservative cpufreq_powersave p4_clockmod freq_table speedstep_lib snd_intel8x0 snd_ac97_codec ac97_bus snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device joydev snd_pcm_oss snd_pcm snd_timer usbhid hid snd_mixer_oss snd dvb_usb_dibusb_mc dvb_usb_dibusb_common dib3000mc dibx000_common dvb_usb soundcore rng_core dvb_core r8169 sg sr_mod iTCO_wdt snd_page_alloc mii intel_agp agpgart shpchp rtc_cmos processor pci_hotplug i2c_i801 thermal button ehci_hcd iTCO_vendor_support i2c_core uhci_hcd evdev usbcore ata_generic ide_pci_generic pata_a
 cpi piix ide_gd_mod ide_core ahci ata_piix libata sd_mod scsi_mod crc_t10dif ext4 jbd2 crc16
>
> Pid: 11454, comm: lzop Not tainted (2.6.30-0.rc7.1mdv #1) MS-6728

Does this kernel have any extra patches in it?

-chris
