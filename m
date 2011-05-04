From: Goffredo Baroncelli <kreijack@libero.it>
Subject: Re: Cannot resize btrfs volume
Date: Wed, 04 May 2011 20:16:14 +0200
Message-ID: <4DC197EE.1030600@libero.it>
References: <ipr2t2$70c$1@dough.gmane.org> <ipr3gg$70c$2@dough.gmane.org>
Reply-To: kreijack@inwind.it
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Lubos Kolouch <lubos.kolouch@gmail.com>,
	Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <ipr3gg$70c$2@dough.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

several time ago I posted a patch which addressed this lack of
documentation [1]. Unfortunately when I revised this patch I missed this
chunk, and now Chris merged the last (uncompleted) revision.

So now I am publish a new patch which address this issue.

Chris, if you want you can pull it from

	http://cassiopea.homelinux.net/git/btrfs-progs-unstable.git

or browse it at
"http://cassiopea.homelinux.net/git/?p=btrfs-progs-unstable.git;a=summary".

Below the patch.
Regards
G.Baroncelli

diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index 6f92f91..220bcbd 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -147,7 +147,7 @@ Force a sync for the filesystem identified by
\fI<path>\fR.
 .\" Some wording are extracted by the resize2fs man page
 .\"

-\fBfilesystem resize\fR\fI [+/\-]<size>[gkm]|max <path>\fR
+\fBfilesystem resize\fR\fI [<devid>:][+/\-]<size>[gkm]|max <path>\fR
 Resize a filesystem identified by \fI<path>\fR.
 The \fI<size>\fR parameter specifies the new size of the filesystem.
 If the prefix \fI+\fR or \fI\-\fR is present the size is increased or
decreased
@@ -164,6 +164,9 @@ The \fBresize\fR command \fBdoes not\fR manipulate
the size
 partition.  If you wish to enlarge/reduce a filesystem, you must make
sure you
 can expand the partition before enlarging the filesystem and shrink the
 partition after reducing the size of the filesystem.
+
+<devid> is the ID of the device which was enlarged or which will be
reduced.
+To know the ID of a device use the command \fBbtrfs filesystem show\fR.
 .TP

 \fBbtrfs\fP \fBfilesystem label\fP\fI <dev> [newlabel]\fP
@@ -188,7 +191,7 @@ Show the btrfs filesystem with some additional info.
If no U
 passed, \fBbtrfs\fR show info of all the btrfs filesystem.
 .TP

-\fBdevice balance\fR \fI<path>\fR
+\fBfilesystem balance\fR \fI<path>\fR
 Balance the chunks of the filesystem identified by \fI<path>\fR
 across the devices.
 .TP
@@ -199,6 +202,7 @@ Add device(s) to the filesystem identified by
\fI<path>\fR.

 \fBdevice delete\fR\fI <dev> [<dev>..] <path>\fR
 Remove device(s) from a filesystem identified by \fI<path>\fR.
+
 .PP

 .SH EXIT STATUS
----


[1] email "Re: [PATCH][btrfs progs] Update/clean up btrfs help and man
page" on 10/9/2010

On 05/04/2011 10:41 AM, Lubos Kolouch wrote:
> Hello again,
> 
> OK I found it (randomly) on the wiki:
> btrfs filesystem resize 3:max /home
> 
> Seems like btrfs help is not up-to-date and the wiki is...
> 
> Thank you again
> 
> Lubos
> 
> Lubos Kolouch, Wed, 04 May 2011 08:31:30 +0000:
> 
>> Hello,
>>
>> I added a new disk into our RAID5 array, it looks like this:
>>
>> md2 : active raid5 sdd4[3] sde4[4] sda4[0] sdc4[2] sdb4[1]
>>       3767274240 blocks level 5, 64k chunk, algorithm 2 [5/5] [UUUUU]
>>
>> # btrfs fi sh
>> Label: none  uuid: 5534d2e7-be31-49c7-8ab7-90c5ab8afe18
>> 	Total devices 1 FS bytes used 2.24TB
>> 	devid    3 size 2.63TB used 2.63TB path /dev/md2
>>
>> # mount
>> ...
>> /dev/md2 on /home type btrfs (rw,noatime,compress)
>>
>> # btrfs filesystem resize max /home
>> Resize '/home' of 'max'
>> ERROR: unable to resize '/home'
>>
>> # umount /home/
>> # btrfs filesystem resize max /dev/md2 Resize '/dev/md2' of 'max'
>> ERROR: unable to resize '/dev/md2'
>>
>> # tail /var/log/messages
>> May  4 10:28:57 localhost kernel: resizer unable to find device 1
>>
>> 2.6.38-gentoo-r3, latest git btrfs-progs
>>
>> Can you please advice what to do?
>>
>> Thank you
>>
>> Lubos
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> .
> 

