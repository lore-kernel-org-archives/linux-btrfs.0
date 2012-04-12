From: Francesco Cepparo <francesco.cepparo@gmail.com>
Subject: Re: kernel BUG at fs/btrfs/extent_io.c:1890!
Date: Thu, 12 Apr 2012 21:56:30 +0000
Message-ID: <CACfQV3j1X_08UJ_o-09thSUM-8SpBse9zB5eWWbuFSz5=7mWPw@mail.gmail.com>
References: <CACfQV3hb92zrYUJ8to1mq8s1wzfdEoMBDi9b5VmfZ0AZ=UBkFA@mail.gmail.com>
	<20120411150158.GA5820@localhost.localdomain>
	<CACfQV3j_WGTB-+booc1bDMvs1i_Kjr_WAAmLKgUb9sUWe-+wPg@mail.gmail.com>
	<20120412180836.GJ1924@localhost.localdomain>
	<20120412181525.GU29506@shiny>
	<20120412182049.GK1924@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120412182049.GK1924@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 12, 2012 at 6:20 PM, Josef Bacik <josef@redhat.com> wrote:
> On Thu, Apr 12, 2012 at 02:15:25PM -0400, Chris Mason wrote:
>> On Thu, Apr 12, 2012 at 02:08:37PM -0400, Josef Bacik wrote:
>> > On Wed, Apr 11, 2012 at 11:59:43PM +0000, Francesco Cepparo wrote:
>> > > I tried your patch but unfortunately the kernel still gives me t=
he
>> > > same error message :(
>> >
>> > Weird, will you apply this patch on top of the one I sent you and =
send me the
>> > dmesg when it panics again? =A0Thanks,
>> >
>> > Josef
>> >
>> > diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>> > index 2a3ddd2..51efb58 100644
>> > --- a/fs/btrfs/disk-io.c
>> > +++ b/fs/btrfs/disk-io.c
>> > @@ -652,6 +652,8 @@ static int btree_io_failed_hook(struct page *p=
age, int failed_mirror)
>> >
>> > =A0 =A0 eb =3D (struct extent_buffer *)page->private;
>> > =A0 =A0 set_bit(EXTENT_BUFFER_IOERR, &eb->bflags);
>> > + =A0 WARN_ON(!failed_mirror);
>> > + =A0 printk(KERN_ERR "io error, failed mirror %d\n");
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ^^^^^
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 , failed_mirror
>>
>
> pfft compiling debug patches before sending them out is for losers,
>
> Josef

I applied your second patch on top of the first one but the dmesg
output stays the same.... before you ask, I'm sure I'm compiling the
kernel correctly, as putting the WARN_ON(!failed_mirror) inside the if
(!failed_mirror) on line 391 correctly prints the warnings... I'm not
sure whether the warnings generated in that place are of any interest
but showing them anyway can't hurt:

[   87.041600] device fsid 0a6e2f08-5bfe-434c-ae27-f8670bef9a1c devid
1 transid 168138 /dev/sda6
[   87.041944] btrfs: disk space caching is enabled
[   87.417258] parent transid verify failed on 195091890176 wanted
168040 found 168229
[   87.418315] parent transid verify failed on 195091890176 wanted
168040 found 168229
[   87.418356] failed mirror was 0
[   87.418367] ------------[ cut here ]------------
[   87.418387] WARNING: at fs/btrfs/disk-io.c:394
btree_read_extent_buffer_pages.constprop.111+0x13a/0x160()
[   87.418416] Hardware name: P5Q SE/R
[   87.418428] Modules linked in: fuse ext4 crc16 jbd2 mbcache rt73usb
rt2x00usb snd_hda_codec_hdmi crc_itu_t rt2x00lib usbhid uvcvideo hid
videobuf2_vmalloc videobuf2_memops videobuf2_core arc4 stv0299
snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_pcm
snd_page_alloc snd_timer snd rtl8180 eeprom_93cx6 mac80211 budget_av
budget_core cfg80211 ttpci_eeprom radeon saa7146_vv i2c_algo_bit atl1e
soundcore rfkill saa7146 drm_kms_helper dvb_core videobuf_dma_sg
videobuf_core videodev evdev media ttm drm psmouse serio_raw iTCO_wdt
iTCO_vendor_support button coretemp intel_agp i2c_i801 microcode
intel_gtt processor i2c_core asus_atk0110 autofs4 uhci_hcd ehci_hcd
usbcore usb_common sd_mod ahci sr_mod cdrom libahci pata_marvell
libata scsi_mod
[   87.418835] Pid: 735, comm: mount Not tainted 3.4.0-rc2-mainline #5
[   87.418854] Call Trace:
[   87.418867]  [<ffffffff810515ff>] warn_slowpath_common+0x7f/0xc0
[   87.418887]  [<ffffffff8105165a>] warn_slowpath_null+0x1a/0x20
[   87.418907]  [<ffffffff81208aaa>]
btree_read_extent_buffer_pages.constprop.111+0x13a/0x160
[   87.418934]  [<ffffffff8120928a>] read_tree_block+0x3a/0x50
[   87.418953]  [<ffffffff811eec73>] read_block_for_search.isra.33+0x1f=
3/0x3a0
[   87.418975]  [<ffffffff811ee39b>] ?
generic_bin_search.constprop.35+0x6b/0x180
[   87.418998]  [<ffffffff811f107c>] btrfs_search_slot+0x3ec/0x900
[   87.419018]  [<ffffffff81206a00>] ? verify_parent_transid+0x160/0x16=
0
[   87.419039]  [<ffffffff8120089f>] btrfs_read_block_groups+0xdf/0x660
[   87.419060]  [<ffffffff811f43f9>] ? update_space_info+0x199/0x1f0
[   87.419080]  [<ffffffff8120ce12>] open_ctree+0x1392/0x1ac0
[   87.420210]  [<ffffffff812b0901>] ? disk_name+0x61/0xc0
[   87.421352]  [<ffffffff811e8666>] btrfs_mount+0x5b6/0x6a0
[   87.422469]  [<ffffffff8112cbcb>] ? pcpu_alloc+0x8bb/0x9d0
[   87.423598]  [<ffffffff812c3a38>] ? ida_get_new_above+0x218/0x2a0
[   87.424752]  [<ffffffff8116fce3>] mount_fs+0x43/0x1b0
[   87.425869]  [<ffffffff8112ccf0>] ? __alloc_percpu+0x10/0x20
[   87.426988]  [<ffffffff81189e70>] vfs_kern_mount+0x70/0x100
[   87.428123]  [<ffffffff8118a394>] do_kern_mount+0x54/0x110
[   87.429219]  [<ffffffff8118bc7a>] do_mount+0x26a/0x850
[   87.430320]  [<ffffffff811274bb>] ? strndup_user+0x5b/0x80
[   87.431401]  [<ffffffff8118c39d>] sys_mount+0x8d/0xe0
[   87.432473]  [<ffffffff814d15e9>] system_call_fastpath+0x16/0x1b
[   87.433554] ---[ end trace 63bca69dcc9ebeb7 ]---
[   87.434641] io error, failed mirror 0
[   87.435988] parent transid verify failed on 195091890176 wanted
168040 found 168229
[   87.437144] failed mirror was 0
[   87.438252] ------------[ cut here ]------------
[   87.439380] WARNING: at fs/btrfs/disk-io.c:394
btree_read_extent_buffer_pages.constprop.111+0x13a/0x160()
[   87.440551] Hardware name: P5Q SE/R
[   87.441722] Modules linked in: fuse ext4 crc16 jbd2 mbcache rt73usb
rt2x00usb snd_hda_codec_hdmi crc_itu_t rt2x00lib usbhid uvcvideo hid
videobuf2_vmalloc videobuf2_memops videobuf2_core arc4 stv0299
snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_pcm
snd_page_alloc snd_timer snd rtl8180 eeprom_93cx6 mac80211 budget_av
budget_core cfg80211 ttpci_eeprom radeon saa7146_vv i2c_algo_bit atl1e
soundcore rfkill saa7146 drm_kms_helper dvb_core videobuf_dma_sg
videobuf_core videodev evdev media ttm drm psmouse serio_raw iTCO_wdt
iTCO_vendor_support button coretemp intel_agp i2c_i801 microcode
intel_gtt processor i2c_core asus_atk0110 autofs4 uhci_hcd ehci_hcd
usbcore usb_common sd_mod ahci sr_mod cdrom libahci pata_marvell
libata scsi_mod
[   87.447250] Pid: 735, comm: mount Tainted: G        W
3.4.0-rc2-mainline #5
[   87.449907] Call Trace:
[   87.452654]  [<ffffffff810515ff>] warn_slowpath_common+0x7f/0xc0
[   87.455507]  [<ffffffff8105165a>] warn_slowpath_null+0x1a/0x20
[   87.458309]  [<ffffffff81208aaa>]
btree_read_extent_buffer_pages.constprop.111+0x13a/0x160
[   87.459966]  [<ffffffff8120928a>] read_tree_block+0x3a/0x50
[   87.461442]  [<ffffffff811eec73>] read_block_for_search.isra.33+0x1f=
3/0x3a0
[   87.462910]  [<ffffffff811ee39b>] ?
generic_bin_search.constprop.35+0x6b/0x180
[   87.464334]  [<ffffffff811f107c>] btrfs_search_slot+0x3ec/0x900
[   87.465752]  [<ffffffff81206a00>] ? verify_parent_transid+0x160/0x16=
0
[   87.467171]  [<ffffffff8120089f>] btrfs_read_block_groups+0xdf/0x660
[   87.468571]  [<ffffffff811f43f9>] ? update_space_info+0x199/0x1f0
[   87.469956]  [<ffffffff8120ce12>] open_ctree+0x1392/0x1ac0
[   87.471343]  [<ffffffff812b0901>] ? disk_name+0x61/0xc0
[   87.472709]  [<ffffffff811e8666>] btrfs_mount+0x5b6/0x6a0
[   87.474065]  [<ffffffff8112cbcb>] ? pcpu_alloc+0x8bb/0x9d0
[   87.475400]  [<ffffffff812c3a38>] ? ida_get_new_above+0x218/0x2a0
[   87.476729]  [<ffffffff8116fce3>] mount_fs+0x43/0x1b0
[   87.478048]  [<ffffffff8112ccf0>] ? __alloc_percpu+0x10/0x20
[   87.479364]  [<ffffffff81189e70>] vfs_kern_mount+0x70/0x100
[   87.480679]  [<ffffffff8118a394>] do_kern_mount+0x54/0x110
[   87.482187]  [<ffffffff8118bc7a>] do_mount+0x26a/0x850
[   87.483551]  [<ffffffff811274bb>] ? strndup_user+0x5b/0x80
[   87.484863]  [<ffffffff8118c39d>] sys_mount+0x8d/0xe0
[   87.486134]  [<ffffffff814d15e9>] system_call_fastpath+0x16/0x1b
[   87.487378] ---[ end trace 63bca69dcc9ebeb8 ]---
[   87.488578] io error, failed mirror 0
[   87.820244] parent transid verify failed on 195091890176 wanted
168040 found 168229
[   87.821396] failed mirror was 0
[   87.822499] ------------[ cut here ]------------
[   87.823624] WARNING: at fs/btrfs/disk-io.c:394
btree_read_extent_buffer_pages.constprop.111+0x13a/0x160()
[   87.824776] Hardware name: P5Q SE/R
[   87.825897] Modules linked in: fuse ext4 crc16 jbd2 mbcache rt73usb
rt2x00usb snd_hda_codec_hdmi crc_itu_t rt2x00lib usbhid uvcvideo hid
videobuf2_vmalloc videobuf2_memops videobuf2_core arc4 stv0299
snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_pcm
snd_page_alloc snd_timer snd rtl8180 eeprom_93cx6 mac80211 budget_av
budget_core cfg80211 ttpci_eeprom radeon saa7146_vv i2c_algo_bit atl1e
soundcore rfkill saa7146 drm_kms_helper dvb_core videobuf_dma_sg
videobuf_core videodev evdev media ttm drm psmouse serio_raw iTCO_wdt
iTCO_vendor_support button coretemp intel_agp i2c_i801 microcode
intel_gtt processor i2c_core asus_atk0110 autofs4 uhci_hcd ehci_hcd
usbcore usb_common sd_mod ahci sr_mod cdrom libahci pata_marvell
libata scsi_mod
[   87.831175] Pid: 735, comm: mount Tainted: G        W
3.4.0-rc2-mainline #5
[   87.832513] Call Trace:
[   87.833824]  [<ffffffff810515ff>] warn_slowpath_common+0x7f/0xc0
[   87.835136]  [<ffffffff8105165a>] warn_slowpath_null+0x1a/0x20
[   87.836445]  [<ffffffff81208aaa>]
btree_read_extent_buffer_pages.constprop.111+0x13a/0x160
[   87.837770]  [<ffffffff8120928a>] read_tree_block+0x3a/0x50
[   87.839178]  [<ffffffff811eec73>] read_block_for_search.isra.33+0x1f=
3/0x3a0
[   87.840799]  [<ffffffff811ee39b>] ?
generic_bin_search.constprop.35+0x6b/0x180
[   87.842409]  [<ffffffff811f107c>] btrfs_search_slot+0x3ec/0x900
[   87.844082]  [<ffffffff81206a00>] ? verify_parent_transid+0x160/0x16=
0
[   87.845743]  [<ffffffff8120089f>] btrfs_read_block_groups+0xdf/0x660
[   87.847231]  [<ffffffff811f43f9>] ? update_space_info+0x199/0x1f0
[   87.848757]  [<ffffffff8120ce12>] open_ctree+0x1392/0x1ac0
[   87.850403]  [<ffffffff812b0901>] ? disk_name+0x61/0xc0
[   87.851784]  [<ffffffff811e8666>] btrfs_mount+0x5b6/0x6a0
[   87.853314]  [<ffffffff8112cbcb>] ? pcpu_alloc+0x8bb/0x9d0
[   87.854756]  [<ffffffff812c3a38>] ? ida_get_new_above+0x218/0x2a0
[   87.856136]  [<ffffffff8116fce3>] mount_fs+0x43/0x1b0
[   87.857494]  [<ffffffff8112ccf0>] ? __alloc_percpu+0x10/0x20
[   87.858885]  [<ffffffff81189e70>] vfs_kern_mount+0x70/0x100
[   87.860213]  [<ffffffff8118a394>] do_kern_mount+0x54/0x110
[   87.861557]  [<ffffffff8118bc7a>] do_mount+0x26a/0x850
[   87.862857]  [<ffffffff811274bb>] ? strndup_user+0x5b/0x80
[   87.864167]  [<ffffffff8118c39d>] sys_mount+0x8d/0xe0
[   87.865451]  [<ffffffff814d15e9>] system_call_fastpath+0x16/0x1b
[   87.866689] ---[ end trace 63bca69dcc9ebeb9 ]---
[   87.867886] io error, failed mirror 0
[   87.869054] ------------[ cut here ]------------
[   87.870018] kernel BUG at fs/btrfs/extent_io.c:1890!
[   87.870018] invalid opcode: 0000 [#1] PREEMPT SMP
[   87.870018] CPU 1
[   87.870018] Modules linked in: fuse ext4 crc16 jbd2 mbcache rt73usb
rt2x00usb snd_hda_codec_hdmi crc_itu_t rt2x00lib usbhid uvcvideo hid
videobuf2_vmalloc videobuf2_memops videobuf2_core arc4 stv0299
snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_pcm
snd_page_alloc snd_timer snd rtl8180 eeprom_93cx6 mac80211 budget_av
budget_core cfg80211 ttpci_eeprom radeon saa7146_vv i2c_algo_bit atl1e
soundcore rfkill saa7146 drm_kms_helper dvb_core videobuf_dma_sg
videobuf_core videodev evdev media ttm drm psmouse serio_raw iTCO_wdt
iTCO_vendor_support button coretemp intel_agp i2c_i801 microcode
intel_gtt processor i2c_core asus_atk0110 autofs4 uhci_hcd ehci_hcd
usbcore usb_common sd_mod ahci sr_mod cdrom libahci pata_marvell
libata scsi_mod
[   87.870018]
[   87.870018] Pid: 735, comm: mount Tainted: G        W
3.4.0-rc2-mainline #5 System manufacturer P5Q SE/R/P5Q SE/R
[   87.870018] RIP: 0010:[<ffffffff8123207f>]  [<ffffffff8123207f>]
repair_io_failure+0x17f/0x1c0
[   87.870018] RSP: 0018:ffff88011705b7f8  EFLAGS: 00010246
[   87.870018] RAX: ffff88011705b828 RBX: 0000002d6c620000 RCX: 0000002=
d6c620000
[   87.870018] RDX: 0000000000001000 RSI: 0000002d6c620000 RDI: ffff880=
11f8f4108
[   87.870018] RBP: ffff88011705b868 R08: ffffea00045c6e80 R09: 0000000=
000000000
[   87.870018] R10: 0000000000000001 R11: 0000000000aaaaaa R12: 0000000=
000001000
[   87.870018] R13: ffffea00045c6e80 R14: ffff88011f8f4108 R15: 0000000=
000000000
[   87.870018] FS:  00007f2dd7d14740(0000) GS:ffff88012fc80000(0000)
knlGS:0000000000000000
[   87.870018] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   87.870018] CR2: 00007fd78eee0000 CR3: 000000011703d000 CR4: 0000000=
0000007e0
[   87.870018] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000=
000000000
[   87.870018] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000=
000000400
[   87.870018] Process mount (pid: 735, threadinfo ffff88011705a000,
task ffff880119284770)
[   87.870018] Stack:
[   87.870018]  ffff00205d363838 0000002d6c620000 0000000000000000
0000000000000000
[   87.870018]  ffff880100000000 000000002def0000 ffff88011705b828
ffff88011705b828
[   87.870018]  0000000000000000 0000002d6c620000 0000000000000000
ffff88011f8f4108
[   87.870018] Call Trace:
[   87.870018]  [<ffffffff81232a12>] repair_eb_io_failure+0x82/0xa0
[   87.870018]  [<ffffffff81208a82>]
btree_read_extent_buffer_pages.constprop.111+0x112/0x160
[   87.870018]  [<ffffffff8120928a>] read_tree_block+0x3a/0x50
[   87.870018]  [<ffffffff811eec73>] read_block_for_search.isra.33+0x1f=
3/0x3a0
[   87.870018]  [<ffffffff811ee39b>] ?
generic_bin_search.constprop.35+0x6b/0x180
[   87.870018]  [<ffffffff811f107c>] btrfs_search_slot+0x3ec/0x900
[   87.870018]  [<ffffffff81206a00>] ? verify_parent_transid+0x160/0x16=
0
[   87.870018]  [<ffffffff8120089f>] btrfs_read_block_groups+0xdf/0x660
[   87.870018]  [<ffffffff811f43f9>] ? update_space_info+0x199/0x1f0
[   87.870018]  [<ffffffff8120ce12>] open_ctree+0x1392/0x1ac0
[   87.870018]  [<ffffffff812b0901>] ? disk_name+0x61/0xc0
[   87.870018]  [<ffffffff811e8666>] btrfs_mount+0x5b6/0x6a0
[   87.870018]  [<ffffffff8112cbcb>] ? pcpu_alloc+0x8bb/0x9d0
[   87.870018]  [<ffffffff812c3a38>] ? ida_get_new_above+0x218/0x2a0
[   87.870018]  [<ffffffff8116fce3>] mount_fs+0x43/0x1b0
[   87.870018]  [<ffffffff8112ccf0>] ? __alloc_percpu+0x10/0x20
[   87.870018]  [<ffffffff81189e70>] vfs_kern_mount+0x70/0x100
[   87.870018]  [<ffffffff8118a394>] do_kern_mount+0x54/0x110
[   87.870018]  [<ffffffff8118bc7a>] do_mount+0x26a/0x850
[   87.870018]  [<ffffffff811274bb>] ? strndup_user+0x5b/0x80
[   87.870018]  [<ffffffff8118c39d>] sys_mount+0x8d/0xe0
[   87.870018]  [<ffffffff814d15e9>] system_call_fastpath+0x16/0x1b
[   87.870018] Code: e5 f6 ff b8 fb ff ff ff 48 8b 5d d8 4c 8b 65 e0
4c 8b 6d e8 4c 8b 75 f0 4c 8b 7d f8 c9 c3 66 0f 1f 44 00 00 b8 fb ff
ff ff eb dd <0f> 0b 0f 0b 49 8b 45 08 49 8b 8f 88 00 00 00 4d 89 f0 48
8b 55
[   87.870018] RIP  [<ffffffff8123207f>] repair_io_failure+0x17f/0x1c0
[   87.870018]  RSP <ffff88011705b7f8>
[   87.935444] ---[ end trace 63bca69dcc9ebeba ]---
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
