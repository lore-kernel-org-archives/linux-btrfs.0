From: Edward Shishkin <edward.shishkin@gmail.com>
Subject: Re: [patch 0/2] grub-0.97: btrfs support
Date: Fri, 11 Dec 2009 16:27:54 +0100
Message-ID: <4B2264FA.6020804@gmail.com>
References: <4ABBED5F.6000008@gmail.com> <200912110104.35119.johannes.hirte@fem.tu-ilmenau.de> <4B222A49.8090107@gmail.com> <200912111504.58646.johannes.hirte@fem.tu-ilmenau.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000408050102000005080207"
Cc: The development of BTRFS <linux-btrfs@vger.kernel.org>,
	Edward Shishkin <edward@redhat.com>
To: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200912111504.58646.johannes.hirte@fem.tu-ilmenau.de>
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------000408050102000005080207
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Johannes Hirte wrote:
> Am Freitag 11 Dezember 2009 12:17:29 schrieb Edward Shishkin:
>   
>> Johannes Hirte wrote:
>>     
>>> Am Freitag 11 Dezember 2009 00:15:46 schrieb Johannes Hirte:
>>>   
>>>       
>>>> Am Freitag 25 September 2009 00:06:23 schrieb Edward Shishkin:
>>>>     
>>>>         
>>>>> Hello everyone.
>>>>>       
>>>>>           
>>>> ...
>>>>
>>>>     
>>>>         
>>>>> The following patches are for Fedora 10(**).
>>>>> The distro-independent package will be put to kernel.org a bit later.
>>>>>
>>>>>
>>>>> All comments, bugreports, etc. are welcome as usual.
>>>>>       
>>>>>           
>>>> Ok, I have another comment/bugreport *g*.
>>>>
>>>> I'm testing this patch with gentoo, so the grub sources are not identicaly
>>>>  the same. With this patches applied, grub is unable to detect JFS or XFS
>>>>  filesystems. XFS is reported as unknown, JFS is reported as btrfs.
>>>>  Reiserfs and ext2/3 are detected as expected.
>>>>     
>>>>         
>> Yes, this patch is for Fedora. For other distros
>> some issues are possible, so please be careful..
>>     
>
> I've also tested now with the fedora sources. There is the same bug. The btrfs
> patch breaks the filesystem detection. All filesystems after btrfs in fsys_table 
> aren't detected. Moving btrfs to the end of fsys_table is a workaround but will
> interfere with FFS. So this should better be fixed in the btrfs-part of grub,
> so that it:
>
> a) doesn't missdetect a JFS filesystem as btrfs
> b) doesn't break the detection for remaining filesystems in the array.
>   

Hello.

Yes, I confirm that xfs, etc. file systems are not detected,
but missdetection jfs as btrfs looks rather fantastic :)

Please, try the attached patch. Report if any problems.

Thanks,
Edward.

--------------000408050102000005080207
Content-Type: text/plain;
 name="grub-btrfs-mount-fix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="grub-btrfs-mount-fix.patch"

Problem:
XFS, JFS, etc. file systems of the fsys_table are not
detected by grub with grub-0.97-btrfs.patch applied.

BUG:
btrfs_mount() sets ERR_FSYS_MOUNT to the global variable
errnum if no btrfs metadata were found on a partition.
As the result all next calls of devread() (and, hence,
attempts to find metadata of other file systems) failed.

Solution:
Don't set ERR_FSYS_MOUNT, if btrfs metadata were found,
just return 0.

Signed-off-by: Edward Shishkin <edward@redhat.com>
---
 stage2/fsys_btrfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- grub-0.97.orig/stage2/fsys_btrfs.c
+++ grub-0.97/stage2/fsys_btrfs.c
@@ -638,7 +638,7 @@ int btrfs_mount(void)
 	if (ret) {
 		btrfs_msg("Drive %lu, partition %lu: no Btrfs metadata\n",
 			  current_drive, part_start);
-		goto error;
+		return 0;
 	}
 	ret = btrfs_uptodate_super_copy(BTRFS_FS_INFO);
 	if (ret)

--------------000408050102000005080207--
