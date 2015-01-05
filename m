Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from gardel.0pointer.net ([85.214.157.71]:46303 "EHLO
	gardel.0pointer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754087AbbAERVy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Jan 2015 12:21:54 -0500
Received: from gardel-login.0pointer.net (gardel.0pointer.net [IPv6:2a01:238:43ed:c300:10c3:bcf3:3266:da74])
	by gardel.0pointer.net (Postfix) with ESMTP id F105CE80F5C
	for <linux-btrfs@vger.kernel.org>; Mon,  5 Jan 2015 18:21:52 +0100 (CET)
Date: Mon, 5 Jan 2015 18:21:52 +0100
From: Lennart Poettering <lennart@poettering.net>
To: linux-btrfs@vger.kernel.org
Subject: btrfs_inode_item's otime?
Message-ID: <20150105172152.GB19126@gardel-login>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Heya!

btrfs' btrfs_inode_item structure contains a field for the birth time
of a file, .otime. This field could be quite useful, and I'd like to
make use of it. I can query it with the BTRFS_IOC_TREE_SEARCH ioctl
from userspace, alas it appears that the entry is never actually
initialized to anything other than 0?

Is this on purpose, or simply an oversight? It should be easy to
initialize it to the mtime when the inode is first created...

I am aware of the discussions about introducing the birth time as
something queriable with a future xstat() call. Even if that
high-level API doesn't exist yet, and even if it might be messy to use
BTRFS_IOC_TREE_SEARCH to query the otime currently, I think it would
be good to properly initialize the field, so that pre-existing file
systems would report useful data when xstat() is added one day...

(Of course, even without xstat(), I think it would be good to have an
unprivileged ioctl to query the otime in btrfs... the TREE_SEARCH
ioctl after all requires privileges...)

Lennart

-- 
Lennart Poettering, Red Hat
