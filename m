From: dima <dolenin@parallels.com>
Subject: Re: linux v3.1 with btrfs-work: oops when deleting files
Date: Wed, 26 Oct 2011 18:35:52 +0900
Message-ID: <4EA7D478.8030106@parallels.com>
References: <6mrhn8-b6u.ln1@hurikhan.ath.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Cc: <linux-btrfs@vger.kernel.org>
To: Kai Krakow <hurikhan77+btrfs@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <6mrhn8-b6u.ln1@hurikhan.ath.cx>
List-ID: <linux-btrfs.vger.kernel.org>

On 10/25/2011 01:48 PM, Kai Krakow wrote:
> Hello list!
>
> I'm trying to rm some files, this is what I get in dmesg:
>
> [30975.249519] ------------[ cut here ]------------
> [30975.249529] WARNING: at fs/btrfs/extent-tree.c:4588
> __btrfs_free_extent+0x3b7/0x7ed()
> [30975.249532] Hardware name:
> [30975.249535] Modules linked in: af_packet lm90 it87 hwmon_vid hwmon fuse
> snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss
> snd_mixer_oss reiserfs zram(C) mperf loop emu10k1_gp sidewinder joydev nfs
> lockd auth_rpcgss nfs_acl tcp_cubic sunrpc ipv6 snd_usb_audio
> snd_usbmidi_lib gspca_sonixj gspca_main videodev usbhid 8250_pnp
> i82875p_edac edac_core sr_mod sg analog cdrom firewire_ohci firewire_core
> evdev pcspkr parport_pc floppy parport ns558 gameport i2c_i801 ne2k_pci 8390
> 8250 serial_core snd_mpu401 snd_mpu401_uart intel_agp e1000 crc_itu_t fan
> button intel_gtt agpgart processor thermal unix usb_storage hid [last
> unloaded: microcode]
> [30975.249604] Pid: 12291, comm: rm Tainted: G       A C  3.1.0-00057-
> gc82b96b-dirty #6

Hello Kai,
Can you ls the directory where the problem files are located? What would 
the the output? I had a very similar problem but on 3.0.x kernel when 
several files suddenly got corrupted.

~d
