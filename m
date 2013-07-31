Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([74.208.4.200]:59649 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752517Ab3GaWKK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 31 Jul 2013 18:10:10 -0400
Received: from mailout-us.gmx.com ([172.19.198.46]) by mrigmx.server.lan
 (mrigmxus002) with ESMTP (Nemesis) id 0MWjWR-1UY2V02GgV-00XxCD for
 <linux-btrfs@vger.kernel.org>; Thu, 01 Aug 2013 00:10:09 +0200
Cc: linux-btrfs@vger.kernel.org
Content-Type: multipart/mixed; boundary="========GMX156771375308608111082"
Date: Wed, 31 Jul 2013 18:10:08 -0400
From: "Mike Audia" <mikey_a@gmx.com>
Message-ID: <20130731221008.156770@gmx.com>
MIME-Version: 1.0
Subject: Re: Is the checkpoint interval adjustable?
To: "Zach Brown" <zab@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--========GMX156771375308608111082
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

> On Wed, Jul 31, 2013 at 04:02:29PM -0400, Mike Audia wrote:
> > I believe 30 sec is the default for the checkpoint interval.  Is this adjustable?
>
> It doesn't look like it. It looks like it's implemented with raw '30's
> in the code.
>
>  delay = HZ * 30;
> ...
>  (now < cur->start_time || now - cur->start_time <
> 30)) {
>
> If you want more frequent forced commits you could always syncfs()
> regularly from userspace, I suppose.

Thank you kindly for the prompt reply.  My goal is to make them _less_ frequent.  I am NO programmer by any stretch.  Let's say I want them to be once every 5 min (300 sec).  Is the attached patch sane to acheive this?  Are there any unforeseen and effects of doing this?  Thank you for the consideration.

--========GMX156771375308608111082
Content-Type: text/x-patch; charset="utf-8"; name="10_minute_checkpoints.patch"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment; filename="10_minute_checkpoints.patch"
Content-Description: Attachment: 10_minute_checkpoints.patch

--- a/fs/btrfs/disk-io.c	2013-07-31 18:05:22.581062955 -0400
+++ b/fs/btrfs/disk-io.c	2013-07-31 18:06:15.243201652 -0400
@@ -1713,7 +1713,7 @@
 
 	do {
 		cannot_commit = false;
-		delay = HZ * 30;
+		delay = HZ * 300;
 		mutex_lock(&root->fs_info->transaction_kthread_mutex);
 
 		spin_lock(&root->fs_info->trans_lock);
@@ -1725,7 +1725,7 @@
 
 		now = get_seconds();
 		if (!cur->blocked &&
-		    (now < cur->start_time || now - cur->start_time < 30)) {
+		    (now < cur->start_time || now - cur->start_time < 300)) {
 			spin_unlock(&root->fs_info->trans_lock);
 			delay = HZ * 5;
 			goto sleep;

--========GMX156771375308608111082--
