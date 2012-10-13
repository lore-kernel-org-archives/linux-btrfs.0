Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:34879 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754027Ab2JMTOt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 13 Oct 2012 15:14:49 -0400
Received: by mail-ee0-f46.google.com with SMTP id b15so2404120eek.19
        for <linux-btrfs@vger.kernel.org>; Sat, 13 Oct 2012 12:14:48 -0700 (PDT)
From: Goffredo Baroncelli <kreijack@gmail.com>
To: Chris Mason <chris.mason@fusionio.com>
Cc: Goffredo Baroncelli <kreijack@gmail.com>, Hugo Mills <hugo@carfax.org.uk>,
        Roman Mamedov <rm@romanrm.ru>,
        =?UTF-8?B?U8OpYmFzdGllbiBNYXVyeQ==?= <sebastien.maury@inserm.fr>,
        Ilya Dryomov <idryomov@gmail.com>, linux-btrfs@vger.kernel.org,
        Martin Steigerwald <Martin@lichtvoll.de>,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 2/2] Update help page
Date: Sat, 13 Oct 2012 21:14:59 +0200
Message-Id: <1350155699-14338-3-git-send-email-kreijack@gmail.com>
In-Reply-To: <1350155699-14338-1-git-send-email-kreijack@gmail.com>
References: <1350155699-14338-1-git-send-email-kreijack@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Goffredo Baroncelli <kreijack@inwind.it>

---
 man/btrfs.8.in |  100 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 100 insertions(+)

diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index 9222580..7048273 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -27,6 +27,8 @@ btrfs \- control a btrfs filesystem
 .PP
 \fBbtrfs\fP \fBfilesystem label\fP\fI <dev> [newlabel]\fP
 .PP
+\fBbtrfs\fP \fBfilesystem df\fP\fI [-k] \fIpath [path..]\fR\fP
+.PP
 \fBbtrfs\fP \fBsubvolume find-new\fP\fI <subvolume> <last_gen>\fP
 .PP
 \fBbtrfs\fP \fBfilesystem balance\fP\fI <path> \fP
@@ -242,6 +244,104 @@ NOTE: Currently there are the following limitations:
 - the filesystem should not have more than one device.
 .TP
 
+\fBfilesystem df\fP [-k] \fIpath [path..]\fR
+
+Show space usage information for a mount point.
+
+\fIOptions\fP
+
+\fB-k\fP Set KB (1024 bytes) as unit
+
+\fIUsage information\fP
+
+.\"
+.\" this section is extract from 
+.\"	http://en.wikipedia.org/wiki/Btrfs#Chunk_and_device_trees
+The disk(s) of a btrfs filesystem are divided into chunks of 256 MB or more. 
+Chunks may be mirrored or striped across multiple devices, depending by
+the allocation policy.
+The mirroring/striping arrangement is transparent to the rest of the 
+file system, which simply sees the single, logical address space that 
+chunks are mapped into.
+Chunks are allocated on demand. In the default allocation policy 
+the data chunks are not duplicated and the metadata chunks
+are duplicated. This default can be changed during the filesystem
+creation, and in general the chunks allocation policy may change
+during the filesystem life. 
+
+Depending by the allocation policy a chunk may require a space on
+the disk greater than the logical space that it provides. E.g.
+a chunk DUPlicated or with a RAID1/RAID10 level 
+requires a space on the disk 
+two times greater than the logical space provided. 
+Different RAID levels
+have a different ratio disk-usage / logical space offered.
+
+Normally the file contents are stored in the Data chunks; however
+small files (which fit into a btree leaf) are stored in the 
+metadata chunks. So the computation of the \fIfree space\fP 
+and \fIused space\fP
+is complex: depending by the file size different 
+allocation policies are used.
+
+The command \fBbtrfs filesystem df\fP is used to query the status
+of the chunks, how many space on the disk(s) are used by the chunks, 
+how many space are available in the chunks, and an estimation of the free
+space of the filesystem.
+The output of the command \fBbtrfs filesystem df\fP shows:
+
+.RS
+.IP \fBDisk\ size\fP
+the total size of the disks which compose the filesystem.
+
+.IP \fBDisk\ allocated\fP\ or\ \fBSize_(disk)\fP
+the size of the area of the disks used by the chunks.
+
+.IP \fBDisk\ unallocated\fP 
+the size of the area of the disks which is free (i.e.
+the differences of the values above).
+
+.IP \fBLogical\ size\fP\ or\ \fBSize_(logical)\fP
+the available logical space of chunk. 
+
+.IP \fBUsed\fP
+the portion of the logical space used by the file and metadata.
+
+.IP \fBFree\ (estimated)\fP
+the estimated free space available. The evaluation 
+cannot be rigorous because it depends by the allocation policy (DUP,Single,
+RAID1...) of the metadata and data chunks. If every chunks is stored as
+"Single" the sum of the \fBfree (estimated)\fP space and the \fBused\fP 
+space  is equal to the \fBdisk size\fP.
+Otherwise if all the chunk are mirrored (raid1 or raid10) or duplicated
+the sum of the \fBfree (estimated)\fP space and the \fBused\fP space is
+half of the \fBdisk size\fP. Normally the \fBfree (estimated)\fP is between
+these two limits.
+
+.IP \fBData\ to\ disk\ ratio\fP
+the ratio betwen the \fBlogical size\fP and the \fBdisk allocated\fP.
+
+.IP \fBMode\fP
+the kind of allocation policy used by the chunk (e.g. DUPlicated,
+RAID1, RAID10, Single....)
+
+.IP \fBType\fP
+the kind of chunk (Data, Metdata, System...)
+
+.RE
+.RS
+\fINOTE\fP
+
+When a chunk is allocated, its disk-area is used and its allocation
+policy is fixed.
+A rebalance operation could rearrange the chunks, moving data in the chunks
+and resizing the allocated chunks. This causes the change of all the values 
+discussed above, with the exception of the \fBused\fP and 
+\fBdisk size\fP values.
+
+.RE
+.TP
+
 \fBfilesystem show\fR [--all-devices|<uuid>|<label>]\fR
 Show the btrfs filesystem with some additional info. If no \fIUUID\fP or 
 \fIlabel\fP is passed, \fBbtrfs\fR show info of all the btrfs filesystem.
-- 
1.7.10.4

