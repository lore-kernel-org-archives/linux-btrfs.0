From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: Re: Bunch of warn_slowpath_common with 3.1rc3
Date: Wed, 24 Aug 2011 19:01:00 +0800
Message-ID: <4E54D9EC.3040705@cn.fujitsu.com>
References: <4E54D169.6030909@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Petr Hejl <hejl.petr@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E54D169.6030909@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 08/24/2011 06:24 PM, Petr Hejl wrote:
> Hi,
> after upgrading, I receive these messages (or similar) all the time...
> P.
> 

Seems this patch can help you :)

https://patchwork.kernel.org/patch/1074802/

thanks,
liubo

> [  142.542311] ------------[ cut here ]------------
> [  142.542323] WARNING: at /home/kernel-ppa/COD/linux/fs/inode.c:1309
> iput_final+0x14e/0x170()
> [  142.542326] Hardware name: Latitude E6410
> [  142.542327] Modules linked in: iptable_filter ip_tables x_tables
> rfcomm bnep vboxnetadp vboxnetflt vboxdrv speedstep_lib dm_crypt
> snd_hda_codec_hdmi snd_hda_codec_idt uvcvideo snd_hda_intel
> snd_hda_codec arc4 snd_hwdep videodev v4l2_compat_ioctl32 snd_pcm ppdev
> dell_wmi sparse_keymap snd_seq_midi joydev snd_rawmidi
> snd_seq_midi_event snd_seq btusb bluetooth dell_laptop psmouse snd_timer
> dcdbas serio_raw snd_seq_device snd iwlagn intel_ips mac80211 soundcore
> snd_page_alloc cfg80211 i8k parport_pc coretemp lp parport btrfs
> zlib_deflate libcrc32c usbhid hid ahci libahci firewire_ohci sdhci_pci
> firewire_core sdhci crc_itu_t i915 e1000e drm_kms_helper drm
> i2c_algo_bit video wmi
> [  142.542388] Pid: 2880, comm: thunderbird-bin Tainted: G        W
> 3.1.0-0301rc3-generic #201108231005
> [  142.542391] Call Trace:
> [  142.542396]  [<ffffffff81189d0e>] ? iput_final+0x14e/0x170
> [  142.542402]  [<ffffffff81066120>] warn_slowpath_common+0x90/0xc0
> [  142.542408]  [<ffffffff8106616a>] warn_slowpath_null+0x1a/0x20
> [  142.542411]  [<ffffffff81189d0e>] iput_final+0x14e/0x170
> [  142.542413]  [<ffffffff81189d75>] iput+0x45/0x50
> [  142.542437]  [<ffffffffa022246f>] btrfs_iget+0xcf/0xf0 [btrfs]
> [  142.542452]  [<ffffffffa022321f>] btrfs_lookup_dentry+0x15f/0x1d0
> [btrfs]
> [  142.542466]  [<ffffffffa02232a6>] btrfs_lookup+0x16/0x30 [btrfs]
> [  142.542470]  [<ffffffff8117aab9>] d_alloc_and_lookup+0x49/0x80
> [  142.542473]  [<ffffffff8117ce24>] do_lookup+0x224/0x2d0
> [  142.542476]  [<ffffffff8117d523>] do_last+0x133/0x6b0
> [  142.542479]  [<ffffffff8117e403>] path_openat+0xd3/0x410
> [  142.542482]  [<ffffffff8117e868>] do_filp_open+0x48/0xa0
> [  142.542487]  [<ffffffff812fdf93>] ? strncpy_from_user+0x43/0x50
> [  142.542494]  [<ffffffff815e75ce>] ? _raw_spin_lock+0xe/0x20
> [  142.542498]  [<ffffffff8118ba56>] ? alloc_fd+0x116/0x140
> [  142.542504]  [<ffffffff8116f3f6>] do_sys_open+0x106/0x1d0
> [  142.542508]  [<ffffffff8116f500>] sys_open+0x20/0x30
> [  142.542512]  [<ffffffff815efe02>] system_call_fastpath+0x16/0x1b
> [  142.542515] ---[ end trace 4259c393ac94899a ]---
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

