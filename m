Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:57391 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752672Ab2JLDY6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Oct 2012 23:24:58 -0400
Received: from m3.gw.fujitsu.co.jp (unknown [10.0.50.73])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id 5ED023EE0C0
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2012 12:24:57 +0900 (JST)
Received: from smail (m3 [127.0.0.1])
	by outgoing.m3.gw.fujitsu.co.jp (Postfix) with ESMTP id 4712745DEB5
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2012 12:24:57 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (s3.gw.fujitsu.co.jp [10.0.50.93])
	by m3.gw.fujitsu.co.jp (Postfix) with ESMTP id 2FB3245DEB2
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2012 12:24:57 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id 23B691DB803F
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2012 12:24:57 +0900 (JST)
Received: from ml14.s.css.fujitsu.com (ml14.s.css.fujitsu.com [10.240.81.134])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id D07B11DB803B
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2012 12:24:56 +0900 (JST)
Received: from ml14.css.fujitsu.com (ml14 [127.0.0.1])
	by ml14.s.css.fujitsu.com (Postfix) with ESMTP id A92D49F7991
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2012 12:24:56 +0900 (JST)
Received: from [127.0.0.1] (unknown [10.124.101.110])
	by ml14.s.css.fujitsu.com (Postfix) with ESMTP id 58EAD9F6C65
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2012 12:24:56 +0900 (JST)
Message-ID: <50778D7D.4080803@jp.fujitsu.com>
Date: Fri, 12 Oct 2012 12:24:45 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 2/4] Btrfs-progs: add mount-option command man page
References: <50778C1D.4060807@jp.fujitsu.com>
In-Reply-To: <50778C1D.4060807@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add mount-option command man page.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 man/btrfs.8.in |   25 +++++++++++++++++++++++++
 1 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index 4b0a9f9..85d5030 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -52,6 +52,12 @@ btrfs \- control a btrfs filesystem
 \fBbtrfs\fP \fBinspect-internal logical-resolve\fP
 [-Pv] \fI<logical>\fP \fI<path>\fP
 .PP
+\fBbtrfs\fP \fBmount-option set\fP \fI[[<+/-/=><option>,...]...]\fP \fI<device>\fP
+.PP
+\fBbtrfs\fP \fBmount-option get\fP \fI<device>\fP
+.PP
+\fBbtrfs\fP \fBmount-option clear\fP \fI<device>\fP
+.PP
 \fBbtrfs\fP \fBhelp|\-\-help|\-h \fP\fI\fP
 .PP
 \fBbtrfs\fP \fB<command> \-\-help \fP\fI\fP
@@ -319,6 +325,25 @@ skip the path resolving and print the inodes instead
 .IP -v 5
 verbose mode. print count of returned paths and all ioctl() return values
 .RE
+.TP
+
+\fBmount-option set\fP \fI[<+/-/=><option>,...]...]\fP \fI<device>\fP
+With some operators \fB+\fP,\fB-\fP,\fB=\fP and some options,
+set default mount options to the \fI<device>\fP.
+These \fB+\fP,\fB-\fP,\fB=\fP operators mean like \fBchmod\fP operators.
+The operator \fB+\fP causes the selected mount options to be added to existing
+default mount options of the \fI<device>\fP; \fB-\fP causes them to be removed;
+and \fB=\fP causes them to be added and causes unmentioned options to be removed.
+Without options, print default mount options of the \fI<device>\fR.
+.TP
+
+\fBmount-option get\fP \fI<device>\fP
+Print default mount options of the \fI<device>\fR.
+.TP
+
+\fBmount-option clear\fP \fI<device>\fP
+Clear default mount options of the \fI<device>\fR.
+.TP
 
 .SH EXIT STATUS
 \fBbtrfs\fR returns a zero exist status if it succeeds. Non zero is returned in
-- 
1.7.7.6


