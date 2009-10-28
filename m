From: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Subject: Re: [patch 1/2] grub-0.97: btrfs support for a singe device configuration
Date: Wed, 28 Oct 2009 01:01:55 +0100
Message-ID: <200910280101.55688.johannes.hirte@fem.tu-ilmenau.de>
References: <4ABBED68.6090801@redhat.com> <200910272335.04825.johannes.hirte@fem.tu-ilmenau.de> <4AE77BD3.2010400@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Cc: The development of BTRFS <linux-btrfs@vger.kernel.org>
To: Edward Shishkin <edward.shishkin@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4AE77BD3.2010400@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Am Mittwoch 28 Oktober 2009 00:01:39 schrieb Edward Shishkin:
> Johannes Hirte wrote:
> > Am Freitag 25 September 2009 00:06:32 schrieb Edward Shishkin:
> >   
> >>     
> > I was trying the patch and got a little confused. How did you get this work
> > without linking against libgcc?
> 
> Hmm.. Actually my Fedora stuff does link it:
> [...]
> 
> +btrfs_stage1_5_exec_LDADD = @LIBGCC@
> 
> [...]
> I guess you have missed it when porting to Gentoo..

"btrfs_stage1_5_exec_LDADD = @LIBGCC@" is in place, I've didn't missed.

My fault, the error log was too short. As far as I can see the error 
occours at pre_stage2_exec-stage2:

mv -f .deps/pre_stage2_exec-stage2.Tpo .deps/pre_stage2_exec-stage2.Po                                                                                                
mv -f .deps/pre_stage2_exec-graphics.Tpo .deps/pre_stage2_exec-graphics.Po                                                                                            
mv -f .deps/pre_stage2_exec-tparm.Tpo .deps/pre_stage2_exec-tparm.Po                                                                                                  
x86_64-pc-linux-gnu-gcc -m32 -Os -fno-stack-protector -fno-builtin -nostdinc  -DSUPPORT_SERIAL=1 -DSUPPORT_HERCULES=1 -DSUPPORT_GRAPHICS=1 -DFSYS_EXT2FS=1 -DFSYS_FAT=1 -DFSYS_FFS=1 -DFSYS_UFS2=1 -DFSYS_MINIX=1 -DFSYS_REISERFS=1 -DFSYS_BTRFS=1 -DFSYS_VSTAFS=1 -DFSYS_JFS=1 -DFSYS_XFS=1 -DFSYS_ISO9660=1 -DUSE_MD5_PASSWORDS=1 -g -nostdlib -Wl,-N -Wl,-Ttext -Wl,8200 -Wl,-O1 -Wl,--sort-common -Wl,-z,combreloc -Wl,--build-id=none -o pre_stage2.exec pre_stage2_exec-asm.o pre_stage2_exec-bios.o pre_stage2_exec-boot.o pre_stage2_exec-builtins.o pre_stage2_exec-char_io.o pre_stage2_exec-cmdline.o pre_stage2_exec-common.o pre_stage2_exec-console.o pre_stage2_exec-disk_io.o pre_stage2_exec-fsys_ext2fs.o pre_stage2_exec-fsys_fat.o pre_stage2_exec-fsys_ffs.o pre_stage2_exec-fsys_iso9660.o pre_stage2_exec
 -fsys_jfs.o pre_stage2_exec-fsys_minix.o pre_stage2_exec-fsys_reiserfs.o pre_stage2_exec-fsys_btrfs.o pre_stage2_exec-fsys_ufs2.o pre_stage2_exec-fsys_vstafs.o pre_stage2_exec-fsys_xfs.o pre_stage2_exec-gunzip.o pre_stage2_exec-hercules.o pre_stage2_exec-md5.o pre_stage2_exec-serial.o pre_stage2_exec-smp-imps.o pre_stage2_exec-stage2.o pre_stage2_exec-terminfo.o pre_stage2_exec-tparm.o pre_stage2_exec-graphics.o                                                                                                                 
pre_stage2_exec-fsys_btrfs.o: In function `__btrfs_map_block':                                                                                                        
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

I'm not very familiar with autotools, but I think btrfs_stage1_5_exec_LDADD 
isn't the right place to catch this.
