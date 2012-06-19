Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from terminus.zytor.com ([198.137.202.10]:47839 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751656Ab2FSAaA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Jun 2012 20:30:00 -0400
Message-ID: <4FDFC807.2080209@zytor.com>
Date: Mon, 18 Jun 2012 17:29:59 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Device names
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I just found out that all the device handling in btrfs is based on
pathnames, but shorter pathnames (1024) that PATH_MAX (4096).

This is confusing, and concerning for multiple reasons:

1. pathnames are namespace-specific; what is a pathname in one namespace
might not be in another.
2. different truncation rules in the rest of the kernel.

There seem to be no way one can do the equivalent of BTRFS_IOC_DEV_INFO
but actually get a device number or other stable information for that
device (that could be compared to a file descriptor for verification);
is that an accurate observation?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

