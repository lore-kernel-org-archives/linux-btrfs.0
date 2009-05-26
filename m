From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: Oops on a converted ext4 system
Date: Tue, 26 May 2009 11:22:04 +0200
Message-ID: <4A1BB4BC.3000301@wpkg.org>
References: <4A1B8BD0.6050203@wpkg.org> <20090526091404.GA25723@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: Chris Mason <chris.mason@oracle.com>,
	Tomasz Chmielewski <mangoo@wpkg.org>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090526091404.GA25723@think>
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason wrote:
> On Tue, May 26, 2009 at 08:27:28AM +0200, Tomasz Chmielewski wrote:
>> I converted an ext4 filesystem with btrfs-convert, mounted it, and wanted to do "lzop -d ...".
>>
>> The result was an immediate Oops (btrfs is on LVM, on dm-crypt, on /dev/sdb which is USB-connected).
>>
>>
>> mini-904.img.lzo dentry_open failed
>> BUG: unable to handle kernel paging request at ffffffcd
>> IP: [<c01b5f36>] fput+0x6/0x30
>> *pde = 00575067 *pte = 00000000
>> Oops: 0002 [#1] SMP
>> last sysfs file: /sys/block/sda/removable
>> Modules linked in: kqemu sha256_generic aes_i586 aes_generic cbc usb_storage dm_crypt btrfs zlib_deflate crc32c libcrc32c tun radeon drm usblp af_packet ipv6 binfmt_misc loop dm_mirror dm_region_hash dm_log dm_mod cpufreq_ondemand cpufreq_conservative cpufreq_powersave p4_clockmod freq_table speedstep_lib snd_intel8x0 snd_ac97_codec ac97_bus snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device joydev snd_pcm_oss snd_pcm snd_timer usbhid hid snd_mixer_oss snd dvb_usb_dibusb_mc dvb_usb_dibusb_common dib3000mc dibx000_common dvb_usb soundcore rng_core dvb_core r8169 sg sr_mod iTCO_wdt snd_page_alloc mii intel_agp agpgart shpchp rtc_cmos processor pci_hotplug i2c_i801 thermal button ehci_hcd iTCO_vendor_support i2c_core uhci_hcd evdev usbcore ata_generic ide_pci_generic pata_
 acpi piix ide_gd_mod ide_core ahci ata_piix libata sd_mod scsi_mod crc_t10dif ext4 jbd2 crc16
>>
>> Pid: 11454, comm: lzop Not tainted (2.6.30-0.rc7.1mdv #1) MS-6728
> 
> Does this kernel have any extra patches in it?

It's a distribution kernel with this description: "NOTE: This kernel has 
no patches and no third-party drivers".
So there shouldn't be any extra patches in it.


-- 
Tomasz Chmielewski
http://wpkg.org
