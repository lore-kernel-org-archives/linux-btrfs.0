From: David Nicol <davidnicol@gmail.com>
Subject: Re: Updating the wiki pages adding btrfs command [Was Re: reserving
 an IOCTL number; other details]
Date: Wed, 15 Sep 2010 09:10:39 -0500
Message-ID: <AANLkTimB-tHAL8U8-_=9QsKisQgO-QPt4=X89QOsiPaK@mail.gmail.com>
References: <AANLkTi=GzqHy5h2gAmkQSSMQOCaYza=yTtWZrcyd8RSC@mail.gmail.com>
	<201009131923.53227.kreijack@libero.it>
	<AANLkTi=RFO1kQEQ3FJYJ2XBYh4++TDYakrLxhoQDwA3k@mail.gmail.com>
	<201009142125.56710.kreijack@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: kreijack <kreijack@libero.it>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201009142125.56710.kreijack@libero.it>
List-ID: <linux-btrfs.vger.kernel.org>

Does the manpatch below describe an acceptable API for a hook to a
facility for waiting for the completion of deleted snapshot cleanup?

diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index 26ef982..290d202 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -19,6 +19,8 @@ btrfs \- control a btrfs filesystem
 .PP
 \fBbtrfs\fP \fBfilesystem sync\fP\fI <path> \fP
 .PP
+\fBbtrfs\fP \fBfilesystem GC\fP\fI <path> [ms] \fP
+.PP
 \fBbtrfs\fP \fBfilesystem resize\fP\fI [+/\-]<size>[gkm]|max <filesystem>\fP
 .PP
 \fBbtrfs\fP \fBdevice scan\fP\fI [<device> [<device>..]]\fP
@@ -115,6 +117,12 @@ all the block devices.
 Force a sync for the filesystem identified by \fI<path>\fR.
 .TP

+\fBfilesystem GC\fR\fI <path> [ms] \fR
+wait for completion of salvage of deleted subvolumes on
+the filesystem identified by \fI<path>\fR. The optional
+timeout is in milliseconds.
+.TP
+
 .\"
 .\" Some wording are extracted by the resize2fs man page
 .\"
