Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nm12.bullet.mail.ird.yahoo.com ([77.238.189.65]:38352 "HELO
	nm12.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759075Ab3BWNpQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 23 Feb 2013 08:45:16 -0500
From: Goffredo Baroncelli <goffredo.baroncelli@yahoo.com>
To: linux-btrfs@vger.kernel.org
Cc: Hugo Mills <hugo@carfax.org.uk>,
        Michael =?utf-8?q?Kj=C3=B6rling?= <michael@kjorling.se>,
        Martin Steigerwald <Martin@lichtvoll.de>, cwillu <cwillu@cwillu.com>,
        Chris Murphy <lists@colorremedies.com>, David Sterba <dsterba@suse.cz>,
        Zach Brown <zab@zabbo.net>, Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 3/8] Create the man page entry for the command btrfs fi df
Date: Sat, 23 Feb 2013 14:46:06 +0100
Message-Id: <1361627171-8246-4-git-send-email-goffredo.baroncelli@yahoo.com>
In-Reply-To: <1361627171-8246-1-git-send-email-goffredo.baroncelli@yahoo.com>
References: <1361627171-8246-1-git-send-email-goffredo.baroncelli@yahoo.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Goffredo Baroncelli <kreijack@inwind.it>

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
---
 man/btrfs.8.in |   49 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index 94f4ffe..e2f86ea 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -31,6 +31,8 @@ btrfs \- control a btrfs filesystem
 .PP
 \fBbtrfs\fP \fBfilesystem label\fP\fI <dev> [newlabel]\fP
 .PP
+\fBbtrfs\fP \fBfilesystem df\fP\fI [-b] \fIpath [path..]\fR\fP
+.PP
 \fBbtrfs\fP \fBfilesystem balance\fP\fI <path> \fP
 .PP
 \fBbtrfs\fP \fBdevice scan\fP\fI [--all-devices|<device> [<device>...]]\fP
@@ -266,6 +268,53 @@ NOTE: Currently there are the following limitations:
 - the filesystem should not have more than one device.
 .TP
 
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
+.TP
+
 \fBfilesystem show\fR [--all-devices|<uuid>|<label>]\fR
 Show the btrfs filesystem with some additional info. If no \fIUUID\fP or 
 \fIlabel\fP is passed, \fBbtrfs\fR show info of all the btrfs filesystem.
-- 
1.7.10.4

