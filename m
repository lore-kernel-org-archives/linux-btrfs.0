Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from terminus.zytor.com ([198.137.202.10]:47893 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753110Ab2FSAjc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Jun 2012 20:39:32 -0400
Message-ID: <4FDFCA43.2070407@zytor.com>
Date: Mon, 18 Jun 2012 17:39:31 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Subvolumes and /proc/self/mountinfo
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm trying to figure out an algorithm from taking an arbitrary mounted
btrfs directory and break it down into:

<device(s), subvolume, subpath>

where, keep in mind, <subpath> may not actually be part of the mount.

/proc/self/mountinfo seems to have some of that information, however, it
does not appear to distinguish between non-default subvolumes and
directories.  At the same time, once I have mounted a subvolume I see
its name in the root btrfs directory even if I didn't access it.

Questions, thus:

a. Are subvolumes always part of the "root" namespace?  If so, is it the
mounted root, the default subvolume, or subvolume 0 which always exposes
these other subvolumes?  Are there disambiguation rules so that if I
have /btrfs/root/blah and "blah" is both a subvolume and a directory (I
presume that can happen?)

b. Are there better ways (walking the tree using BTRFS_IOC_TREE_SEARCH?)
to accomplish this than using /proc/self/mountinfo?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

