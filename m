From: Diego Calleja <diegocg@gmail.com>
Subject: Warning and BUG using btrfs-vol -b
Date: Tue, 6 Oct 2009 20:48:32 +0200
Message-ID: <200910062048.32381.diegocg@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
To: "linux-btrfs" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I was playing with btrfs with 2 files of 3.5 GB (using loop), I completely
zeroed one of the files. As expected, I had checksum failures, and I run
btrfs-vol -b just to see what happened, and I got this (using -rc3):


[25765.340492] btrfs csum failed ino 260 off 122880 csum 2566472073 private 3262812575                                        
[25765.340530] btrfs csum failed ino 260 off 118784 csum 2566472073 private 1515197691                                        
[25765.340560] btrfs csum failed ino 260 off 114688 csum 2566472073 private 1467250717                                        
[25765.340589] btrfs csum failed ino 260 off 110592 csum 2566472073 private 551456760                                         
[25765.340618] btrfs csum failed ino 260 off 106496 csum 2566472073 private 2751401677                                        
[25765.340647] btrfs csum failed ino 260 off 102400 csum 2566472073 private 2648834377                                        
[25765.340675] btrfs csum failed ino 260 off 98304 csum 2566472073 private 467965630                                          
[25765.340703] btrfs csum failed ino 260 off 94208 csum 2566472073 private 3164409631                                         
[25765.340732] btrfs csum failed ino 260 off 90112 csum 2566472073 private 2042500030                                         
[25765.340760] btrfs csum failed ino 260 off 86016 csum 2566472073 private 830495785                                          
[25809.292651] btrfs: relocating block group 3541041152 flags 9                                                               
[25809.416493] __ratelimit: 158 callbacks suppressed                                                                          
[25809.416498] btrfs csum failed ino 257 off 61440 csum 2566472073 private 1989812792                                         
[25809.416537] btrfs csum failed ino 257 off 57344 csum 2566472073 private 3105762401                                         
[25809.416603] btrfs csum failed ino 257 off 53248 csum 2566472073 private 2215503813                                         
[25809.416719] btrfs csum failed ino 257 off 323584 csum 2566472073 private 883932373                                         
[25809.416731] btrfs csum failed ino 257 off 49152 csum 2566472073 private 1747807236                                         
[25809.416752] btrfs csum failed ino 257 off 319488 csum 2566472073 private 2519068844                                        
[25809.416774] btrfs csum failed ino 257 off 45056 csum 2566472073 private 3487590687                                         
[25809.416783] btrfs csum failed ino 257 off 315392 csum 2566472073 private 2599709027                                        
[25809.416813] btrfs csum failed ino 257 off 311296 csum 2566472073 private 157132003                                         
[25809.416823] btrfs csum failed ino 257 off 40960 csum 2566472073 private 599615997                                          
[25809.657271] ------------[ cut here ]------------                                                                           
[25809.657294] WARNING: at fs/btrfs/relocation.c:3588 btrfs_relocate_block_group+0x27f/0x390 [btrfs]()                        
[25809.657298] Hardware name: System Product Name                                                                             
[25809.657300] Modules linked in: btrfs loop crc32c libcrc32c ppp_deflate zlib_deflate bsd_comp ppp_async crc_ccitt ppp_generic slhc kvm_intel kvm i915 snd_ca0106 snd_rawmidi drm_kms_helper cfbcopyarea snd_ac97_codec ac97_bus video snd_pcm_oss snd_mixer_oss snd_pcm backlight snd_timer cfbimgblt snd processor button cfbfillrect intel_agp wacom soundcore snd_page_alloc usbhid fan fuse ehci_hcd uhci_hcd thermal thermal_sys usbcore atl1 mii [last unloaded: btrfs]                                         
[25809.657350] Pid: 15354, comm: btrfs-vol Not tainted 2.6.32-rc3 #1                                                          
[25809.657353] Call Trace:                                                                                                    
[25809.657361]  [<ffffffff8104f9bb>] warn_slowpath_common+0x7b/0xc0                                                           
[25809.657366]  [<ffffffff8104fa14>] warn_slowpath_null+0x14/0x20                                                             
[25809.657377]  [<ffffffffa0396b7f>] btrfs_relocate_block_group+0x27f/0x390 [btrfs]                                           
[25809.657390]  [<ffffffffa037cfab>] btrfs_relocate_chunk+0x8b/0x5e0 [btrfs]                                                  
[25809.657404]  [<ffffffffa0372a0b>] ? map_extent_buffer+0xdb/0xe0 [btrfs]                                                    
[25809.657417]  [<ffffffffa0371b13>] ? unmap_extent_buffer+0x13/0x40 [btrfs]                                                  
[25809.657431]  [<ffffffffa0366c54>] ? btrfs_item_offset+0xe4/0xf0 [btrfs]                                                    
[25809.657444]  [<ffffffffa037db3f>] btrfs_balance+0x1ef/0x270 [btrfs]                                                        
[25809.657449]  [<ffffffff810cc0ef>] ? find_get_page+0x7f/0xf0                                                                
[25809.657461]  [<ffffffffa0382e10>] btrfs_ioctl+0x510/0xa20 [btrfs]                                                          
[25809.657465]  [<ffffffff810cc3e7>] ? unlock_page+0x27/0x30                                                                  
[25809.657470]  [<ffffffff810e8409>] ? __do_fault+0x449/0x540                                                                 
[25809.657476]  [<ffffffff8111bf62>] vfs_ioctl+0x22/0xa0                                                                      
[25809.657481]  [<ffffffff813cf4e9>] ? sub_preempt_count+0x59/0x60                                                            
[25809.657486]  [<ffffffff8111c108>] do_vfs_ioctl+0x88/0x570                                                                  
[25809.657491]  [<ffffffff8120ecc9>] ? __up_read+0x99/0xc0                                                                    
[25809.657497]  [<ffffffff8107323e>] ? up_read+0xe/0x10                                                                       
[25809.657501]  [<ffffffff8111c63f>] sys_ioctl+0x4f/0x80                                                                      
[25809.657507]  [<ffffffff8100b5db>] system_call_fastpath+0x16/0x1b                                                           
[25809.657511] ---[ end trace b3050419e02a5436 ]---                                                                           
[25809.662186] ------------[ cut here ]------------                                                                           
[25809.662190] kernel BUG at fs/btrfs/volumes.c:1746!                                                                         
[25809.662193] invalid opcode: 0000 [#1] PREEMPT SMP                                                                          
[25809.662198] last sysfs file: /sys/devices/pci0000:00/0000:00:1f.2/host3/target3:0:0/3:0:0:0/model                          
[25809.662201] CPU 0                                                                                                          
[25809.662203] Modules linked in: btrfs loop crc32c libcrc32c ppp_deflate zlib_deflate bsd_comp ppp_async crc_ccitt ppp_generic slhc kvm_intel kvm i915 snd_ca0106 snd_rawmidi drm_kms_helper cfbcopyarea snd_ac97_codec ac97_bus video snd_pcm_oss snd_mixer_oss snd_pcm backlight snd_timer cfbimgblt snd processor button cfbfillrect intel_agp wacom soundcore snd_page_alloc usbhid fan fuse ehci_hcd uhci_hcd thermal thermal_sys usbcore atl1 mii [last unloaded: btrfs]
[25809.662245] Pid: 15354, comm: btrfs-vol Tainted: G        W  2.6.32-rc3 #1 System Product Name
[25809.662248] RIP: 0010:[<ffffffffa037d4e4>]  [<ffffffffa037d4e4>] btrfs_relocate_chunk+0x5c4/0x5e0 [btrfs]
[25809.662261] RSP: 0018:ffff880073afdc18  EFLAGS: 00010282
[25809.662263] RAX: 00000000fffffffb RBX: ffff880077210000 RCX: ffffffffa0396ae7
[25809.662266] RDX: 0000000000000007 RSI: ffffffff8110670f RDI: ffffffff811044d5
[25809.662269] RBP: ffff880073afdd08 R08: 0000000000000000 R09: ffff880073afd938
[25809.662271] R10: 0000000000000000 R11: 0000000000000000 R12: ffff880077153000
[25809.662274] R13: 0000000000000000 R14: 00000000d3100000 R15: ffff880073afdd48
[25809.662277] FS:  00007f3e04ec5730(0000) GS:ffff880001800000(0000) knlGS:0000000000000000
[25809.662281] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[25809.662283] CR2: 00007f79213f8000 CR3: 00000000bc95f000 CR4: 00000000000026e0
[25809.662286] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[25809.662289] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[25809.662292] Process btrfs-vol (pid: 15354, threadinfo ffff880073afc000, task ffff880001a84500)
[25809.662294] Stack:
[25809.662296]  ffff880073afdc88 ffffffffa0372a0b ffff880073afdcc0 0000000000000001
[25809.662300] <0> 0000000000000100 0000000000000000 ffff8800b65e1800 ffff880073afdd48
[25809.662306] <0> ffff880077153000 00000000d3100000 00000000000000fb ffff88007b6ee990
[25809.662312] Call Trace:
[25809.662324]  [<ffffffffa0372a0b>] ? map_extent_buffer+0xdb/0xe0 [btrfs]
[25809.662335]  [<ffffffffa0371b13>] ? unmap_extent_buffer+0x13/0x40 [btrfs]
[25809.662347]  [<ffffffffa0366c54>] ? btrfs_item_offset+0xe4/0xf0 [btrfs]
[25809.662358]  [<ffffffffa037db3f>] btrfs_balance+0x1ef/0x270 [btrfs]
[25809.662362]  [<ffffffff810cc0ef>] ? find_get_page+0x7f/0xf0
[25809.662373]  [<ffffffffa0382e10>] btrfs_ioctl+0x510/0xa20 [btrfs]
[25809.662376]  [<ffffffff810cc3e7>] ? unlock_page+0x27/0x30
[25809.662380]  [<ffffffff810e8409>] ? __do_fault+0x449/0x540
[25809.662385]  [<ffffffff8111bf62>] vfs_ioctl+0x22/0xa0
[25809.662388]  [<ffffffff813cf4e9>] ? sub_preempt_count+0x59/0x60
[25809.662392]  [<ffffffff8111c108>] do_vfs_ioctl+0x88/0x570
[25809.662396]  [<ffffffff8120ecc9>] ? __up_read+0x99/0xc0
[25809.662400]  [<ffffffff8107323e>] ? up_read+0xe/0x10
[25809.662404]  [<ffffffff8111c63f>] sys_ioctl+0x4f/0x80
[25809.662409]  [<ffffffff8100b5db>] system_call_fastpath+0x16/0x1b
[25809.662411] Code: ff 31 c0 e9 c0 fa ff ff 0f 1f 80 00 00 00 00 0f 0b eb fe 0f 1f 40 00 0f 0b eb fe 0f 0b eb fe 0f 0b eb fe 0f 0b eb fe 0f 0b eb fe <0f> 0b eb fe 0f 0b eb fe 0f 0b eb fe 0f 0b eb fe 0f 0b eb fe 0f
[25809.662463] RIP  [<ffffffffa037d4e4>] btrfs_relocate_chunk+0x5c4/0x5e0 [btrfs]
[25809.662475]  RSP <ffff880073afdc18>
[25809.662478] ---[ end trace b3050419e02a5437 ]---
