Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:50860 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932866AbaKMSGi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Nov 2014 13:06:38 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Xoymy-0003UB-2x
	for linux-btrfs@vger.kernel.org; Thu, 13 Nov 2014 19:06:36 +0100
Received: from pd953ede5.dip0.t-ipconnect.de ([217.83.237.229])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Nov 2014 19:06:36 +0100
Received: from holger.hoffstaette by pd953ede5.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Nov 2014 19:06:36 +0100
To: linux-btrfs@vger.kernel.org
From: Holger =?iso-8859-1?q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Subject: Re: [PATCH] Btrfs: don't ignore log btree writeback errors
Date: Thu, 13 Nov 2014 18:06:23 +0000 (UTC)
Message-ID: <pan.2014.11.13.18.06.23@googlemail.com>
References: <1415897993-7556-1-git-send-email-fdmanana@suse.com>
	<pan.2014.11.13.17.33.19@googlemail.com>
	<CAL3q7H7KcRDapbizQK6Dy5ECTWzVuHxyF3wmM8CJA34WEhccXw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 13 Nov 2014 17:47:51 +0000, Filipe David Manana wrote:

[snip]

> While Chris' integration/for-linus branches don't have the patch
> included yet (nor do I in my local branch). Nevertheless, it's a
> trivial conflict to solve, just leave Josef's changes and mine.

So if I read this correctly the combined patch should look like this,
right?

--snip--
-		btrfs_wait_marked_extents(log, &log->dirty_log_pages, mark);
+		ret = btrfs_wait_marked_extents(log, &log->dirty_log_pages,
+						mark);
		btrfs_wait_logged_extents(log, log_transid);
 		wait_log_commit(trans, log_root_tree,
 				root_log_ctx.log_transid);
 		mutex_unlock(&log_root_tree->log_mutex);
-		ret = root_log_ctx.log_ret;
+		if (!ret)
+			ret = root_log_ctx.log_ret;
 		goto out;
--snip--

This saves the ret, logs the extents, commits and then handles any
error.

-h

