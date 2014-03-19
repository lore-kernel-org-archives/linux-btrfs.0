Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:55021 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752899AbaCSGKS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Mar 2014 02:10:18 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s2J69w9P013049
	for <linux-btrfs@vger.kernel.org>; Wed, 19 Mar 2014 14:09:58 +0800
From: "quwenruo@cn.fujitsu.com" <quwenruo@cn.fujitsu.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: [PATCH 2/3] btrfs-progs: Fix minor problems in man page of btrfs
Date: Wed, 19 Mar 2014 06:10:02 +0000
Message-ID: <1395209466-17042-2-git-send-email-quwenruo@cn.fujitsu.com>
References: <1395209466-17042-1-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1395209466-17042-1-git-send-email-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset="iso-2022-jp"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Man page of btrfs has some minor problem like:
1. Duplicant entry for "filesystem df"
2. Inconsistent parameters
3. Non-paired parens
4. Missing options
5. Wrong parameters

This patch fixes these minor bug.
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 man/btrfs.8.in | 184 ++++++++++++++++++++++++++++++++-------------------------
 1 file changed, 102 insertions(+), 82 deletions(-)

diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index 7fbde82..3846f19 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -23,9 +23,9 @@ btrfs \- control a btrfs filesystem
 \fBbtrfs\fP \fBsubvolume show\fP\fI <path>\fP
 .PP
 .PP
-\fBbtrfs\fP \fBfilesystem df\fP\fI <path>\fP
+\fBbtrfs\fP \fBfilesystem df\fP\fI [-b] \fIpath [path..]\fR\fP
 .PP
-\fBbtrfs\fP \fBfilesystem show\fP [\fI--mounted\fP|\fI--all-devices\fP|\fI<uuid>\fP]\fP
+\fBbtrfs\fP \fBfilesystem show\fP [\fI--mounted\fP|\fI--all-devices\fP|\fI<path>\fP|\fI<uuid>\fP|\fI<device>\fP|\fI<lable>\fP]\fP
 .PP
 \fBbtrfs\fP \fBfilesystem sync\fP\fI <path> \fP
 .PP
@@ -35,12 +35,11 @@ btrfs \- control a btrfs filesystem
 .PP
 \fBbtrfs\fP \fBfilesystem label\fP [\fI<device>\fP|\fI<mount_point>\fP] [\fI<newlabel>\fP]
 .PP
-\fBbtrfs\fP \fBfilesystem filesystem disk-usage [-t][-b]\fP\fI <path> 
+\fBbtrfs\fP \fBfilesystem disk-usage [-tb]\fP\fI <path> 
 [path..]\fP
 .PP
-\fBbtrfs\fP \fBfilesystem df\fP\fI [-b] \fIpath [path..]\fR\fP
 .PP
-\fBbtrfs\fP \fBfilesystem balance\fP\fI <path> \fP
+\fBbtrfs\fP \fB[filesystem] balance\fP\fI <path> \fP
 .PP
 \fBbtrfs\fP \fB[filesystem] balance start\fP [\fIoptions\fP] \fI<path>\fP
 .PP
@@ -57,11 +56,10 @@ btrfs \- control a btrfs filesystem
 .PP
 \fBbtrfs\fP \fBdevice delete\fP \fI<device>\fP [\fI<device>...\fP] \fI<path>\fP
 .PP
-\fBbtrfs\fP \fBdevice scan\fP [\fI--all-devices\fP|\fI<device> \P[\fI<device>...\fP]
+\fBbtrfs\fP \fBdevice scan\fP [(\fI-d\fP|\fI--all-devices\fP)|\fI<device>\fP [\fI<device>...\fP]]
 .PP
 \fBbtrfs\fP \fBdevice disk-usage\fP\fI [-b] <path> [<path>...] \fP
 .PP
-.PP
 \fBbtrfs\fP \fBdevice ready\fP\fI <device>\fP
 .PP
 \fBbtrfs\fP \fBdevice stats\fP [-z] {\fI<path>\fP|\fI<device>\fP}
@@ -78,11 +76,11 @@ btrfs \- control a btrfs filesystem
 .PP
 \fBbtrfs\fP \fBcheck\fP [\fIoptions\fP] \fI<device>\fP
 .PP
-\fBbtrfs\fP \fBrescue chunk-recover\fP [\fIoptions\fP] \fI<path>\fP
+\fBbtrfs\fP \fBrescue chunk-recover\fP [\fIoptions\fP] \fI<device>\fP
 .PP
-\fBbtrfs\fP \fBrescue super-recover\fP [\fIoptions\fP] \fI<path>\fP
+\fBbtrfs\fP \fBrescue super-recover\fP [\fIoptions\fP] \fI<device>\fP
 .PP
-\fBbtrfs\fP \fBrestore\fP [\fIoptions\fP] \fI<device>\fP
+\fBbtrfs\fP \fBrestore\fP [\fIoptions\fP] \fI<device>\fP \fI<path>\fP | -l \fI<device>\fP
 .PP
 .PP
 \fBbtrfs\fP \fBinspect-internal inode-resolve\fP [-v] \fI<inode>\fP \fI<path>\fP
@@ -103,7 +101,7 @@ btrfs \- control a btrfs filesystem
 .PP
 \fBbtrfs\fP \fBquota disable\fP\fI <path>\fP
 .PP
-\fBbtrfs\fP \fBquota rescan\fP [-s] \fI<path>\fP
+\fBbtrfs\fP \fBquota rescan\fP [-sw] \fI<path>\fP
 .PP
 .PP
 \fBbtrfs\fP \fBqgroup assign\fP \fI<src>\fP \fI<dst>\fP \fI<path>\fP
@@ -114,7 +112,7 @@ btrfs \- control a btrfs filesystem
 .PP
 \fBbtrfs\fP \fBqgroup destroy\fP \fI<qgroupid>\fP \fI<path>\fP
 .PP
-\fBbtrfs\fP \fBqgroup show\fP \fI<path>\fP
+\fBbtrfs\fP \fBqgroup show\fP [\fIoptions\fP] \fI<path>\fP
 .PP
 \fBbtrfs\fP \fBqgroup limit\fP [\fIoptions\fP] \fI<size>\fP|\fBnone\fP [\fI<qgroupid>\fP] \fI<path>\fP
 .PP
@@ -286,12 +284,55 @@ List the recently modified files in a subvolume, after \fI<last_gen>\fR ID.
 Show information of a given subvolume in the \fI<path>\fR.
 .TP
 
-\fBfilesystem df\fP\fI <path>\fR
+\fBfilesystem df\fP [-b] \fIpath [path..]\fR
+
 Show space usage information for a mount point.
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
+.RE
 .TP
 
-\fBfilesystem show\fR [\fI--mounted\fP|\fI--all-devices\fP|\fI<uuid>\fR]\fR
-Show the btrfs filesystem with some additional info. If no option or \fIUUID\fP
+\fBfilesystem show\fR [\fI--mounted\fP|\fI--all-devices\fP|\fI<path>\fP|\fI<uuid>\fP|\fI<device>\fP|\fI<lable>\fP]\fR
+Show the btrfs filesystem with some additional info. If no option or
+\fIPATH\fP|\fIUUID\fP|\fIDEVICE\fP|\fILABEL\fP
 is passed, \fBbtrfs\fR shows information of all the btrfs filesystem both mounted
 and unmounted.
 If \fB--mounted\fP is passed, it would probe btrfs kernel to list mounted btrfs filesystem(s);
@@ -370,8 +411,13 @@ the same starting disk cylinder as before.
 \fBfilesystem label\fP [\fI<dev>\fP|\fI<mount_point>\fP] [\fInewlabel\fP]\fP
 Show or update the label of a filesystem. \fI[<device>|<mountpoint>]\fR is used
 to identify the filesystem. 
+
+If a \fInewlabel\fR optional argument is passed, the label is changed. The
+following constraints exist for a label:
+.IP
+- the maximum allowable length shall be less than 256 chars
 .TP
-\fBfilesystem disk-usage\fP [-t][-b] \fIpath [path..]\fR
+\fBfilesystem disk-usage\fP [-tb] \fIpath [path..]\fR
 
 Show in which disk the chunks are allocated.
 
@@ -381,12 +427,13 @@ Show in which disk the chunks are allocated.
 
 .TP
 
-If a \fInewlabel\fR optional argument is passed, the label is changed. The
-following constraints exist for a label:
-.IP
-- the maximum allowable length shall be less than 256 chars
-.TP
+\fB[filesystem] balance \fI<path>\fR
+Blanace chunks across the devices
+
+\fBbtrfs balance \fI<path>\fR is deprecated,
+please use \fBbtrfs balance start\fR command instead.
 
+.TP
 \fB[filesystem] balance start\fR [\fIoptions\fP] \fI<path>\fR
 Balance chunks across the devices
 Balance and/or convert (change allocation profile of) chunks that
@@ -417,53 +464,6 @@ Pause running balance.
 .RE
 .TP
 
-\fBfilesystem df\fP [-b] \fIpath [path..]\fR
-
-Show space usage information for a mount point.
-
-\fB-b\fP Set byte as unit
-
-The command \fBbtrfs filesystem df\fP is used to query how many space on the 
-disk(s) are used and an estimation of the free
-space of the filesystem.
-The output of the command \fBbtrfs filesystem df\fP shows:
-
-.RS
-.IP \fBDisk\ size\fP
-the total size of the disks which compose the filesystem.
-
-.IP \fBDisk\ allocated\fP
-the size of the area of the disks used by the chunks.
-
-.IP \fBDisk\ unallocated\fP 
-the size of the area of the disks which is free (i.e.
-the differences of the values above).
-
-.IP \fBUsed\fP
-the portion of the logical space used by the file and metadata.
-
-.IP \fBFree\ (estimated)\fP
-the estimated free space available: i.e. how many space can be used
-by the user. The evaluation 
-cannot be rigorous because it depends by the allocation policy (DUP, Single,
-RAID1...) of the metadata and data chunks. If every chunk is stored as
-"Single" the sum of the \fBfree (estimated)\fP space and the \fBused\fP 
-space  is equal to the \fBdisk size\fP.
-Otherwise if all the chunk are mirrored (raid1 or raid10) or duplicated
-the sum of the \fBfree (estimated)\fP space and the \fBused\fP space is
-half of the \fBdisk size\fP. Normally the \fBfree (estimated)\fP is between
-these two limits.
-
-.IP \fBData\ to\ disk\ ratio\fP
-the ratio betwen the \fBlogical size\fP (i.e. the space available by
-the chunks) and the \fBdisk allocated\fP (by the chunks). Normally it is 
-lower than 100% because the metadata is duplicated for security reasons.
-If all the data and metadata are duplicated (or have a profile like RAID1)
-the \fBData\ to\ disk\ ratio\fP could be 50%.
-
-.RE
-.TP
-
 \fB[filesystem] balance cancel\fR\fI <path>\fR
 Cancel running or paused balance.
 .TP
@@ -482,7 +482,7 @@ be verbose
 .RE
 .TP
 
-\fBdevice add\fR\fI [-Kf] <dev> \fP[\fI<dev>...\fP] \fI<path>\fR
+\fBdevice add\fR [-Kf] \fI<dev> \fP[\fI<dev>...\fP] \fI<path>\fR
 Add device(s) to the filesystem identified by \fI<path>\fR.
 If applicable, a whole device discard (TRIM) operation is performed.
 .RS
@@ -499,22 +499,20 @@ force overwrite of existing filesystem on the given disk(s)
 Remove device(s) from a filesystem identified by \fI<path>\fR.
 .TP
 
-\fBdevice scan\fR [--all-devices|\fI<device> \fP[\fI<device>...\fP]\fR
+\fBdevice scan\fR [(--all-devices|-d)|\fI<device> \fP[\fI<device>...\fP]]\fR
+If one or more devices are passed, these are scanned for a btrfs filesystem. 
+If no devices are passed, \fBbtrfs\fR uses block devices containing btrfs
+filesystem as listed by blkid.
+Finally, if \fB--all-devices\fP or \fB-d\fP is passed, all the devices under /dev are 
+scanned.
 .TP
 
-\fBdevice disk-usage\fR\fI [-b] <path> [<path>..] <path>\fR
+\fBdevice disk-usage\fR\fI [-b] <path> [<path>..]\fR
 Show which chunks are in a device.
 
 \fB-b\fP set byte as unit.
 .TP
 
-If one or more devices are passed, these are scanned for a btrfs filesystem. 
-If no devices are passed, \fBbtrfs\fR uses block devices containing btrfs
-filesystem as listed by blkid.
-Finally, if \fB--all-devices\fP is passed, all the devices under /dev are 
-scanned.
-.TP
-
 \fBdevice ready\fR \fI<device>\fR
 Check device to see if it has all of it's devices in cache for mounting.
 .TP
@@ -530,7 +528,7 @@ Reset stats to zero after reading them.
 .RE
 .TP
 
-\fBscrub start\fP [-BdqrR] [-c \fIioprio_class\fP -n \fIioprio_classdata\fP] {\fI<path>\fP|\fI<device>\fP}
+\fBscrub start\fP [-BdqrRf] [-c \fIioprio_class\fP -n \fIioprio_classdata\fP] {\fI<path>\fP|\fI<device>\fP}
 Start a scrub on all devices of the filesystem identified by \fI<path>\fR or on
 a single \fI<device>\fR. Without options, scrub is started as a background
 process. Progress can be obtained with the \fBscrub status\fR command. Scrubbing
@@ -642,8 +640,8 @@ verbose mode.
 .RE
 .TP
 
-\fBrestore\fR [\fIoptions\fP] <device>\fR
-Try to restore files from a damaged filesystem(unmounted).
+\fBrestore\fR [\fIoptions\fP] \fI<device>\fR \fI<path>\fR | -l \fI<device>\fP
+Try to restore files from a damaged filesystem(unmounted) to given \fI<path>\fR or list  tree roots.
 .RS
 
 \fIOptions\fR
@@ -785,6 +783,8 @@ Trash all qgroup numbers and scan the metadata again with the current config.
 \fIOptions\fR
 .IP "\fB-s\fP" 5
 show status of a running rescan operation.
+.IP "\fB-w\fP" 5
+wait for rescan operation to finish(can be already in progress).
 .RE
 .TP
 
@@ -804,8 +804,28 @@ Create a subvolume quota group.
 Destroy a subvolume quota group.
 .TP
 
-\fBqgroup show\fP \fI<path>\fP
+\fBqgroup show\fP [\fIoptions\fP] \fI<path>\fP
 Show all subvolume quota groups.
+.RS
+
+\fIOptions\fR
+.IP "\fB-p\fP" 5
+print parent qgroup id.
+.IP "\fB-c\fP" 5
+print child qgroup id.
+.IP "\fB-r\fP" 5
+print max referenced size of qgroup.
+.IP "\fB-e\fP" 5
+print max exclusive size of qgroup.
+.IP "\fB-F\fP" 5
+list all qgroups which impact the given path(include ancestral qgroups)
+.IP "\fB-f\fP" 5
+list all qgroups which impact the given path(exclude ancestral qgroups)
+.IP "\fB--sort=ATTR\fP" 5
+list qgroups in order of ATTR.
+ATTR can be one or more of \fBqgroupid\fP,\fBrfer\fP,\fBexcl\fP,\fBmax_rfer\fP,\fBmax_excl\fP.
+If multiple ATTRs is given, use comma to seperate.
+.RE
 .TP
 
 \fBqgroup limit\fP [\fIoptions\fP] \fI<size>\fP|\fBnone\fP [\fI<qgroupid>\fP] \fI<path>\fP
-- 
1.9.0
