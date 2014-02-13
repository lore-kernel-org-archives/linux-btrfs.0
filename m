Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outrelay07.libero.it ([212.52.84.111]:44910 "EHLO
	outrelay07.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598AbaBMTTF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Feb 2014 14:19:05 -0500
Received: from venice.bhome (151.28.65.181) by outrelay07.libero.it (8.6.033) (authenticated as kreijack@libero.it)
        id 52EA696D03090162 for linux-btrfs@vger.kernel.org; Thu, 13 Feb 2014 20:19:04 +0100
Message-ID: <52FD1AAD.90407@libero.it>
Date: Thu, 13 Feb 2014 20:19:09 +0100
From: Goffredo Baroncelli <kreijack@libero.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/8] Create the man page entry for the command btrfs fi df
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <52FD1A72.5060307@libero.it>


Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
---
 man/btrfs.8.in | 52 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index b620348..4acf16d 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -35,6 +35,9 @@ btrfs \- control a btrfs filesystem
 .PP
 \fBbtrfs\fP \fBfilesystem label\fP [\fI<device>\fP|\fI<mount_point>\fP] [\fI<newlabel>\fP]
 .PP
+\fBbtrfs\fP \fBfilesystem df\fP\fI [-b] \fIpath [path..]\fR\fP
+.PP
+\fBbtrfs\fP \fBfilesystem balance\fP\fI <path> \fP
 .PP
 \fBbtrfs\fP \fB[filesystem] balance start\fP [\fIoptions\fP] \fI<path>\fP
 .PP
@@ -370,6 +373,55 @@ force reducing of metadata integrity
 
 \fB[filesystem] balance pause\fR\fI <path>\fR
 Pause running balance.
+
+.RE
+.TP
+
+\fBfilesystem df\fP [-b] \fIpath [path..]\fR
+
+Show space usage information for a mount point.
+
+\fB-b\fP Set byte as unit
+
+The command \fBbtrfs filesystem df\fP is used to query how many space on the 
+disk(s) are used and an estimation of the free
+space of the filesystem.
+The output of the command \fBbtrfs filesystem df\fP shows:
+
+.RS
+.IP \fBDisk\ size\fP
+the total size of the disks which compose the filesystem.
+
+.IP \fBDisk\ allocated\fP
+the size of the area of the disks used by the chunks.
+
+.IP \fBDisk\ unallocated\fP 
+the size of the area of the disks which is free (i.e.
+the differences of the values above).
+
+.IP \fBUsed\fP
+the portion of the logical space used by the file and metadata.
+
+.IP \fBFree\ (estimated)\fP
+the estimated free space available: i.e. how many space can be used
+by the user. The evaluation 
+cannot be rigorous because it depends by the allocation policy (DUP, Single,
+RAID1...) of the metadata and data chunks. If every chunk is stored as
+"Single" the sum of the \fBfree (estimated)\fP space and the \fBused\fP 
+space  is equal to the \fBdisk size\fP.
+Otherwise if all the chunk are mirrored (raid1 or raid10) or duplicated
+the sum of the \fBfree (estimated)\fP space and the \fBused\fP space is
+half of the \fBdisk size\fP. Normally the \fBfree (estimated)\fP is between
+these two limits.
+
+.IP \fBData\ to\ disk\ ratio\fP
+the ratio betwen the \fBlogical size\fP (i.e. the space available by
+the chunks) and the \fBdisk allocated\fP (by the chunks). Normally it is 
+lower than 100% because the metadata is duplicated for security reasons.
+If all the data and metadata are duplicated (or have a profile like RAID1)
+the \fBData\ to\ disk\ ratio\fP could be 50%.
+
+.RE
 .TP
 
 \fB[filesystem] balance cancel\fR\fI <path>\fR
-- 
1.8.5.3



-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
