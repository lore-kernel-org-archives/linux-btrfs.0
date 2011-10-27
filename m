From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: [PATCH 1/3] btrfs-progs: Update/clean up btrfs help and man page
 V2 (cont.)
Date: Thu, 27 Oct 2011 13:39:55 +0900
Message-ID: <4EA8E09B.8000607@jp.fujitsu.com>
References: <4EA8DFF5.1060400@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Cc: Hugo Mills <hugo@carfax.org.uk>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EA8DFF5.1060400@jp.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

The commit 6f81e1197015ab2dc41beec92c347919feb26967 in for-chris
branch is strange; somehow it does not apply a part of fixes and
contains the dropped hunk in its patch description.

This patch is to apply the dropped hunk.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 man/btrfs.8.in |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index faa7bf8..24bd933 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -195,21 +195,21 @@ NOTE: Currently there are the following limitations:
 - the filesystem should not have more than one device.
 .TP
 
-\fBfilesystem show\fR [<uuid>|<label>]\fR
-Show the btrfs filesystem with some additional info. If no UUID or label is
-passed, \fBbtrfs\fR show info of all the btrfs filesystem.
+\fBfilesystem show\fR [<device>|<uuid>|<label>]\fR
+Show the btrfs filesystem with some additional info. If no argument is
+passed, \fBbtrfs\fR shows info of all the btrfs filesystems.
 .TP
 
-\fBdevice balance\fR \fI<path>\fR
+\fBfilesystem balance\fR \fI<path>\fR
 Balance the chunks of the filesystem identified by \fI<path>\fR
 across the devices.
 .TP
 
-\fBdevice add\fR\fI <dev> [<dev>..] <path>\fR
+\fBdevice add\fR\fI <device> [<device>..] <path>\fR
 Add device(s) to the filesystem identified by \fI<path>\fR.
 .TP
 
-\fBdevice delete\fR\fI <dev> [<dev>..] <path>\fR
+\fBdevice delete\fR\fI <device> [<device>..] <path>\fR
 Remove device(s) from a filesystem identified by \fI<path>\fR.
 .PP
 
-- 
1.7.6.4


