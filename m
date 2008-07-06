From: "Daniel J Blueman" <daniel.blueman@gmail.com>
Subject: Re: iozone remove_suid oops...
Date: Sun, 6 Jul 2008 09:34:29 +0100
Message-ID: <6278d2220807060134k23f58690mfcd11775eab20514@mail.gmail.com>
References: <6278d2220807031520s7c7ab7b0o32bc9140fa218a95@mail.gmail.com>
	 <3d0408630807040611j363abab9h75dab574a31d0d2f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: "Yan Zheng" <yanzheng@21cn.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <3d0408630807040611j363abab9h75dab574a31d0d2f@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 4, 2008 at 2:11 PM, Yan Zheng <yanzheng@21cn.com> wrote:
> 2008/7/4 Daniel J Blueman <daniel.blueman@gmail.com>:
>> Having done a current checkout, creating a new FS and running iozone
>> [1] on it results in an oops [2]. remove_suid is called, accessing
>> offset 14 of a NULL pointer.
>>
>> Let me know if you'd like me to test any fix, do further debugging or
>> get more information.
>>
>> Thanks,
>>  Daniel
>>
>> --- [1]
>>
>> # mkfs.btrfs /dev/sda4
>> # mount /dev/sda4 /mnt
>> /mnt# iozone -a .
>>
>> --- [2]
>>
>> [  899.118926] BUG: unable to handle kernel NULL pointer dereference
>> at virtual address 00000014
>> [  899.118938] printing eip: c016d3f1 *pde = 00000000
>> [  899.118946] Oops: 0000 [#1] SMP
>> [  899.118952] Modules linked in: btrfs libcrc32c sonypi ppdev
>> acpi_cpufreq cpufreq_userspace cpufreq_stats cpufreq_powersave
>> cpufreq_ondemand freq_table cpufreq_conservative video output sbs
>> sbshc container dock microcode ipv6 nfs lockd nfs_acl sunrpc
>> iptable_filter ip_tables x_tables ext3 jbd mbcache af_packet aes_i586
>> dm_crypt dm_mod sbp2 parport_pc lp parport pcmcia joydev snd_hda_intel
>> snd_pcm_oss snd_mixer_oss snd_pcm tifm_7xx1 snd_page_alloc snd_hwdep
>> sky2 tifm_core battery ac sony_laptop snd_seq_dummy yenta_socket
>> rsrc_nonstatic pcmcia_core snd_seq_oss snd_seq_midi snd_rawmidi
>> snd_seq_midi_event evdev psmouse snd_seq snd_timer snd_seq_device
>> serio_raw snd button shpchp pci_hotplug iTCO_wdt iTCO_vendor_support
>> soundcore intel_agp agpgart xfs sg sd_mod sr_mod cdrom pata_acpi
>> ata_piix ata_generic ohci1394 ieee1394 libata scsi_mod ehci_hcd
>> uhci_hcd usbcore thermal processor fan fbcon tileblit font bitblit
>> softcursor fuse
>> [  899.119069]
>> [  899.119073] Pid: 24101, comm: iozone Not tainted (2.6.24-19-generic #1)
>> [  899.119078] EIP: 0060:[<c016d3f1>] EFLAGS: 00210206 CPU: 1
>> [  899.119090] EIP is at should_remove_suid+0x1/0x50
>> [  899.119094] EAX: 00000008 EBX: d4b47d48 ECX: ffffffff EDX: e6665000
>> [  899.119098] ESI: 00001000 EDI: 00001000 EBP: 00001000 ESP: e6439eac
>> [  899.119103]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
>> [  899.119108] Process iozone (pid: 24101, ti=e6438000 task=ee09f700
>> task.ti=e6438000)
>> [  899.119112] Stack: d4b47d48 c016d44c 00000000 00001000 f90f4689
>> 00000000 d4b47d48 00000000
>> [  899.119124]        00008003 e6439f30 d25d8000 c019cb7a e6439f30
>> b6c00000 e6665000 00000000
>> [  899.119135]        00000000 00000000 ffffffea d490c3d4 ee2f0000
>> f6524580 e6665000 ffffff9c
>> [  899.119146] Call Trace:
>> [  899.119157]  [<c016d44c>] remove_suid+0xc/0x50
>> [  899.119172]  [<f90f4689>] btrfs_file_write+0x1a9/0x900 [btrfs]
>> [  899.119222]  [<c019cb7a>] open_namei+0x8a/0x640
>> [  899.119244]  [<c018ffa5>] nameidata_to_filp+0x35/0x40
>> [  899.119255]  [<c018fa90>] generic_file_open+0x0/0x60
>> [  899.119265]  [<c0190000>] do_filp_open+0x50/0x60
>> [  899.119277]  [<c016e56a>] __filemap_fdatawrite_range+0x7a/0xa0
>> [  899.119300]  [<f90f44e0>] btrfs_file_write+0x0/0x900 [btrfs]
>> [  899.119341]  [<c01921b9>] vfs_write+0xb9/0x170
>> [  899.119356]  [<c01928f1>] sys_write+0x41/0x70
>> [  899.119375]  [<c01043c2>] sysenter_past_esp+0x6b/0xa9
>> [  899.119388]  =======================
>> [  899.119390] Code: eb d2 90 8d b4 26 00 00 00 00 53 80 ce 02 83 ec
>> 30 89 c3 89 14 24 8b 13 89 e1 8b 40 04 e8 18 97 03 00 83 c4 30 5b c3
>> 8d 76 00 53 <8b> 40 0c 0f b7 50 6a 89 d0 25 00 08 00 00 83 f8 01 19 db
>> 81 e2
>> [  899.119421] EIP: [<c016d3f1>] should_remove_suid+0x1/0x50 SS:ESP
>> 0068:e6439eac
>> [  899.119427] ---[ end trace 74da89b64662263c ]---
>>
>> --- [3] file.c
>>
>> static ssize_t btrfs_file_write(struct file *file, const char __user *buf,
>>                                size_t count, loff_t *ppos)
>> {
>>        loff_t pos;
>>        loff_t start_pos;
>>        ssize_t num_written = 0;
>>        ssize_t err = 0;
>>        int ret = 0;
>>        struct inode *inode = fdentry(file)->d_inode;
>>        struct btrfs_root *root = BTRFS_I(inode)->root;
>>        struct page **pages = NULL;
>>        int nrptrs;
>>        struct page *pinned[2];
>>        unsigned long first_index;
>>        unsigned long last_index;
>>
>>        nrptrs = min((count + PAGE_CACHE_SIZE - 1) / PAGE_CACHE_SIZE,
>>                     PAGE_CACHE_SIZE / (sizeof(struct page *)));
>>        pinned[0] = NULL;
>>        pinned[1] = NULL;
>>        if (file->f_flags & O_DIRECT)
>>                return -EINVAL;
>>
>>        pos = *ppos;
>>        start_pos = pos;
>>
>>        vfs_check_frozen(inode->i_sb, SB_FREEZE_WRITE);
>>        current->backing_dev_info = inode->i_mapping->backing_dev_info;
>>        err = generic_write_checks(file, &pos, &count, S_ISBLK(inode->i_mode));
>>        if (err)
>>                goto out_nolock;
>>        if (count == 0)
>>                goto out_nolock;
>>        err = remove_suid(fdentry(file));  <---
>> --
> This is a known issue caused by AppArmor. See following URL.
>
> http://oss.oracle.com/pipermail/btrfs-devel/2008-February/000491.html

Yan, that really hit the spot.

With the postmark benchmark, we're seeing comparable performance to
XFS in the worst case, best case (all in-core) is a blistering 5x
faster!

Thanks,
  Daniel
-- 
Daniel J Blueman
