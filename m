Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cobra.newdream.net ([66.33.216.30]:56644 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792Ab3A2AMM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Jan 2013 19:12:12 -0500
Date: Mon, 28 Jan 2013 16:12:12 -0800 (PST)
From: Sage Weil <sage@inktank.com>
To: linux-btrfs@vger.kernel.org
cc: j.michael.lowe@gmail.com, billk@iinet.net.au
Subject: corrupted file size on inline extent conversion?
Message-ID: <alpine.DEB.2.00.1301281602060.8729@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A ceph user observed a incorrect i_size on btrfs.  The pattern looks like 
this:

- some writes at low file offsets
- a write to 4185600 len 8704 (i_size should be 4MB)
- more writes to low offsets
- a write to 4181504 len 4096 (abutts the write above)
- a bit of time goes by...
- stat returns 4186112 (4MB - 8192)
 - that's a fwe bytes to the right of the top write above.

There are some logs showing the full read/write activity to the file at

	http://tracker.newdream.net/attachments/658/object_log.txt

on issue

	http://tracker.newdream.net/issues/3810

The kernel was 3.7.0-030700-generic (and probably also observed on 3.7.1).

Is this a known bug?

Thanks!
sage

