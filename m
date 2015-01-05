Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from gardel.0pointer.net ([85.214.157.71]:46287 "EHLO
	gardel.0pointer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222AbbAERPP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Jan 2015 12:15:15 -0500
Received: from gardel-login.0pointer.net (gardel.0pointer.net [IPv6:2a01:238:43ed:c300:10c3:bcf3:3266:da74])
	by gardel.0pointer.net (Postfix) with ESMTP id C2EC3E80F5C
	for <linux-btrfs@vger.kernel.org>; Mon,  5 Jan 2015 18:15:13 +0100 (CET)
Date: Mon, 5 Jan 2015 18:15:12 +0100
From: Lennart Poettering <lennart@poettering.net>
To: linux-btrfs@vger.kernel.org
Subject: BTRFS_IOC_TREE_SEARCH ioctl
Message-ID: <20150105171512.GA19126@gardel-login>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Heya,

I recently added some btrfs magic to systemd's machinectl/nspawn
tool. More specifically it can now show the disk usage of a container
that is stored in a btrfs subvolume. For that I made use of the btrfs
quota logic. To read the current disk usage of a subvolume I took
inspiration from btrfs-progs, most specifically the
BTRFS_IOC_TREE_SEARCH ioctl(). Unfortunately, documentation for the
ioctl seems to to be lacking, but there are some things about it I
fail to grok:

What precisely are the semantics of the ioctl, regarding the search
key min/max values (the fields of "struct btrfs_ioctl_search_key")? I
kinda assumed that setting them would result in in only objects to be
returned that are within the min/max ranges. However, that appears not
to be the case. At least the min_offset/max_offset setting appears to
be ignored?

The code I hacked up is this one:

http://cgit.freedesktop.org/systemd/systemd/tree/src/shared/btrfs-util.c#n427

I try to read the BTRFS_QGROUP_STATUS_KEY and BTRFS_QGROUP_LIMIT_KEY
objects for the subvolume I care about. Hence I initialize .min_type
and .max_type to the two types (in the right order), and then
.min_offset and .max_offset to subvolume id. However, the search ioctl
will still give me entries back with offsets != the subvolume id...

Is this intended behaviour of the search ioctl? If so, what's the
rationale?

My code currently invokes the search ioctl in a loop to work around
the fact that .min_offset/.max_offset don't work as I wish they
did... I wish I could get rid of this loop and filtering out of the
entries I get back that aren't in th range I specified...

Lennart
