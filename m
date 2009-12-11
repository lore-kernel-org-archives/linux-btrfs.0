From: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Subject: Re: [patch 0/2] grub-0.97: btrfs support
Date: Fri, 11 Dec 2009 15:04:57 +0100
Message-ID: <200912111504.58646.johannes.hirte@fem.tu-ilmenau.de>
References: <4ABBED5F.6000008@gmail.com> <200912110104.35119.johannes.hirte@fem.tu-ilmenau.de> <4B222A49.8090107@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Cc: The development of BTRFS <linux-btrfs@vger.kernel.org>
To: Edward Shishkin <edward.shishkin@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4B222A49.8090107@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Am Freitag 11 Dezember 2009 12:17:29 schrieb Edward Shishkin:
> Johannes Hirte wrote:
> > Am Freitag 11 Dezember 2009 00:15:46 schrieb Johannes Hirte:
> >   
> >> Am Freitag 25 September 2009 00:06:23 schrieb Edward Shishkin:
> >>     
> >>> Hello everyone.
> >>>       
> >> ...
> >>
> >>     
> >>> The following patches are for Fedora 10(**).
> >>> The distro-independent package will be put to kernel.org a bit later.
> >>>
> >>>
> >>> All comments, bugreports, etc. are welcome as usual.
> >>>       
> >> Ok, I have another comment/bugreport *g*.
> >>
> >> I'm testing this patch with gentoo, so the grub sources are not identicaly
> >>  the same. With this patches applied, grub is unable to detect JFS or XFS
> >>  filesystems. XFS is reported as unknown, JFS is reported as btrfs.
> >>  Reiserfs and ext2/3 are detected as expected.
> >>     
> 
> Yes, this patch is for Fedora. For other distros
> some issues are possible, so please be careful..

I've also tested now with the fedora sources. There is the same bug. The btrfs
patch breaks the filesystem detection. All filesystems after btrfs in fsys_table 
aren't detected. Moving btrfs to the end of fsys_table is a workaround but will
interfere with FFS. So this should better be fixed in the btrfs-part of grub,
so that it:

a) doesn't missdetect a JFS filesystem as btrfs
b) doesn't break the detection for remaining filesystems in the array.


regards,
  Johannes
