From: Edward Shishkin <edward.shishkin@gmail.com>
Subject: Re: [patch 0/2] grub-0.97: btrfs support
Date: Fri, 11 Dec 2009 12:17:29 +0100
Message-ID: <4B222A49.8090107@gmail.com>
References: <4ABBED5F.6000008@gmail.com> <200912110016.04548.johannes.hirte@fem.tu-ilmenau.de> <200912110104.35119.johannes.hirte@fem.tu-ilmenau.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: The development of BTRFS <linux-btrfs@vger.kernel.org>
To: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200912110104.35119.johannes.hirte@fem.tu-ilmenau.de>
List-ID: <linux-btrfs.vger.kernel.org>

Johannes Hirte wrote:
> Am Freitag 11 Dezember 2009 00:15:46 schrieb Johannes Hirte:
>   
>> Am Freitag 25 September 2009 00:06:23 schrieb Edward Shishkin:
>>     
>>> Hello everyone.
>>>       
>> ...
>>
>>     
>>> The following patches are for Fedora 10(**).
>>> The distro-independent package will be put to kernel.org a bit later.
>>>
>>>
>>> All comments, bugreports, etc. are welcome as usual.
>>>       
>> Ok, I have another comment/bugreport *g*.
>>
>> I'm testing this patch with gentoo, so the grub sources are not identicaly
>>  the same. With this patches applied, grub is unable to detect JFS or XFS
>>  filesystems. XFS is reported as unknown, JFS is reported as btrfs.
>>  Reiserfs and ext2/3 are detected as expected.
>>     

Yes, this patch is for Fedora. For other distros
some issues are possible, so please be careful..

Thanks,
Edward.

>
> A possible solution is to put FSYS_BTRFS on the end of struct fsys_entry 
> fsys_table. I've tested with FSYS_BTFS as the second last entry, the last is 
> still FFS.
>
> diff -Nru grub-0.97-r9/stage2/disk_io.c grub-0.97-r10/stage2/disk_io.c
> --- grub-0.97-r9/stage2/disk_io.c       2009-12-10 23:41:37.000000000 +0100
> +++ grub-0.97-r10/stage2/disk_io.c      2009-12-11 00:50:51.555007247 +0100
> @@ -79,6 +79,9 @@
>  # ifdef FSYS_ISO9660
>    {"iso9660", iso9660_mount, iso9660_read, iso9660_dir, 0, 0},
>  # endif
> +# ifdef FSYS_BTRFS
> +  {"btrfs", btrfs_mount, btrfs_read, btrfs_dir, 0, btrfs_embed},
> +# endif
>    /* XX FFS should come last as it's superblock is commonly crossing tracks
>       on floppies from track 1 to 2, while others only use 1.  */
>  # ifdef FSYS_FFS
>
> With this order, XFS and JFS filesystems are identified correct. But I think, 
> this is just a workaround.
>
>
> regards,
>   Johannes
>
>   

