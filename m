From: David Nicol <davidnicol@gmail.com>
Subject: Re: reserving an IOCTL number; other details
Date: Sun, 12 Sep 2010 17:08:07 -0500
Message-ID: <AANLkTinWg7o3KwDS9vHKpZV0mUyk6xKsuFvwVUjiynPk@mail.gmail.com>
References: <AANLkTi=GzqHy5h2gAmkQSSMQOCaYza=yTtWZrcyd8RSC@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: BTRFS MAILING LIST <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=GzqHy5h2gAmkQSSMQOCaYza=yTtWZrcyd8RSC@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

this I can release, the user-facing API.


diff --git a/man/btrfsctl.8.in b/man/btrfsctl.8.in
index c2d4488..94403a4 100644
--- a/man/btrfsctl.8.in
+++ b/man/btrfsctl.8.in
@@ -35,6 +35,10 @@ Scans all devices present in the system for btrfs filesystem.
 .TP
 \fB\-c\fR
 Forces a filesystem sync.
+.TP
+\fB\-C\fR \fIdirectory [ms]\fR
+Wait until all the space from all deleted snapshots have been recovered.
+The optional timeout parameter is in milliseconds.
 .SH AVAILABILITY
 .B btrfsctl
 is part of btrfs-progs. Btrfs is currently under heavy development,
