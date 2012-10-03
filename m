Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:61298 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241Ab2JCLn1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Oct 2012 07:43:27 -0400
Received: by bkcjk13 with SMTP id jk13so6051892bkc.19
        for <linux-btrfs@vger.kernel.org>; Wed, 03 Oct 2012 04:43:26 -0700 (PDT)
From: Goffredo Baroncelli <kreijack@gmail.com>
To: Chris Mason <chris.mason@fusionio.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 2/2] Update help page
Date: Wed,  3 Oct 2012 13:43:16 +0200
Message-Id: <1349264596-9383-3-git-send-email-kreijack@inwind.it>
In-Reply-To: <1349264596-9383-1-git-send-email-kreijack@inwind.it>
References: <1349264596-9383-1-git-send-email-kreijack@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

---
 man/btrfs.8.in |   94 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 94 insertions(+)

diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index 4b0a9f9..ed20448 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -27,6 +27,8 @@ btrfs \- control a btrfs filesystem
 .PP
 \fBbtrfs\fP \fBfilesystem label\fP\fI <dev> [newlabel]\fP
 .PP
+\fBbtrfs\fP \fBfilesystem df\fP\fI [-s][-d][-k] \fIpath [path..]\fR\fP
+.PP
 \fBbtrfs\fP \fBsubvolume find-new\fP\fI <subvolume> <last_gen>\fP
 .PP
 \fBbtrfs\fP \fBfilesystem balance\fP\fI <path> \fP
@@ -214,6 +216,98 @@ NOTE: Currently there are the following limitations:
 - the filesystem should not have more than one device.
 .TP
 
+\fBfilesystem df\fP [-s][-d][-k] \fIpath [path..]\fR
+
+Show space usage information for a mount point.
+
+\fIOptions\fP
+
+\fB-k\fP Set KB (1024 bytes) as unit
+
+\fB-s\fP Don't show the summary section
+
+\fB-d\fP Don't show the detail section
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
+A chunk DUPlicated or with a RAID1/RAID10 level 
+requires a space two time greater than the logical one. Different RAID levels
+have a different ratio disk-usage / logical space offered.
+
+Because some files (the small ones) are stored in the 
+metadata chunks the computation of the \fIfree space\fP and \fIused space\fP
+is complex: depending by the file size different allocation policies are used.
+
+The command \fBbtrfs filesystem df\fP is used to query the status
+of the chunks, how many space on the disk(s) are used by the chunks, 
+how many space are available in the chunks, and an estimation of the free
+space of the filesystem.
+The output of the command \fBbtrfs filesystem df\fP shows:
+
+.RS
+.IP Disk\ size 
+the total size of the disks which compose the filesystem.
+
+.IP Disk\ allocated 
+the size of the area of the disks used by the chunks.
+
+.IP Disk\ unallocated 
+the size of the area of the disks which is free (i.e.
+the differences of the values above).
+
+.IP Logical\ size 
+the available logical space of chunk. 
+
+.IP Used 
+the portion of the logical space used by the file and metadata.
+
+.IP Free\ (estimated) 
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
+.IP Data\ to\ disk\ ratio
+the ratio betwen the \fBlogical size\fP and the \fBdisk allocated\fP.
+
+.IP Mode
+the kind of allocation policy used by the chunk (e.g. DUPlicated,
+RAID1, RAID10, Single....)
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

