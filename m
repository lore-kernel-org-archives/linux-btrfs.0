From: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Subject: Re: [patch 1/2] grub-0.97: btrfs support for a singe device configuration
Date: Tue, 27 Oct 2009 23:35:04 +0100
Message-ID: <200910272335.04825.johannes.hirte@fem.tu-ilmenau.de>
References: <4ABBED68.6090801@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Cc: The development of BTRFS <linux-btrfs@vger.kernel.org>
To: Edward Shishkin <edward@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4ABBED68.6090801@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

Am Freitag 25 September 2009 00:06:32 schrieb Edward Shishkin:
> 
> 
I was trying the patch and got a little confused. How did you get this work
without linking against libgcc? I've tested it with the gentoo patches for
grub and get

/usr/src/portage/portage/sys-boot/grub-0.97-r10/work/grub-0.97/stage2/fsys_btrfs.c:551: undefined reference to `__udivdi3'                                            
/usr/src/portage/portage/sys-boot/grub-0.97-r10/work/grub-0.97/stage2/fsys_btrfs.c:571: undefined reference to `__umoddi3'                                            
/usr/src/portage/portage/sys-boot/grub-0.97-r10/work/grub-0.97/stage2/fsys_btrfs.c:575: undefined reference to `__umoddi3'                                            
/usr/src/portage/portage/sys-boot/grub-0.97-r10/work/grub-0.97/stage2/fsys_btrfs.c:581: undefined reference to `__umoddi3'                                            
/usr/src/portage/portage/sys-boot/grub-0.97-r10/work/grub-0.97/stage2/fsys_btrfs.c:583: undefined reference to `__udivdi3'                                            
/usr/src/portage/portage/sys-boot/grub-0.97-r10/work/grub-0.97/stage2/fsys_btrfs.c:588: undefined reference to `__umoddi3'                                            
/usr/src/portage/portage/sys-boot/grub-0.97-r10/work/grub-0.97/stage2/fsys_btrfs.c:589: undefined reference to `__udivdi3'                                            
collect2: ld returned 1 exit status
make[2]: *** [pre_stage2.exec] Error 1                                                                                                                                
make[2]: Leaving directory `/usr/src/portage/portage/sys-boot/grub-0.97-r10/work/grub-0.97/stage2'                                                                    
make[1]: *** [all-recursive] Error 1                                                                                                                                  
make[1]: Leaving directory `/usr/src/portage/portage/sys-boot/grub-0.97-r10/work/grub-0.97'                                                                           
make: *** [all] Error 2
