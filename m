Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:39102 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752480AbcKHWs6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 8 Nov 2016 17:48:58 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 2B2FC20775
        for <linux-btrfs@vger.kernel.org>; Tue,  8 Nov 2016 17:48:57 -0500 (EST)
Message-Id: <1478645336.2739242.781712345.6ADE1927@webmail.messagingengine.com>
From: Ian Kelling <ian@iankelling.org>
To: linux-btrfs@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain
Date: Tue, 08 Nov 2016 14:48:56 -0800
Subject: Could receive allow updating an existing subvolume?
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It seems to be an artificially imposed limitation which hurts which
hurts its usefulness. Let me know if this makes sense. If so, perhaps it
can be implemented eventually. It seems a bit obvious but I couldn't
find any existing discussion of it.

Say you have this situation:
a/1, a/2 (parent is a/1)
b/1 (received from a/1)
Currently, you can (abbreviated) "send -p a/1 a/2 | receive" to create
b/2 (received from a/2, parent is b/1).

b/2 must start out as a rw snapshot from b/1, so we start out with 2
identical subvolumes except for some metadata and rw status, why not
have an option to update the existing subvol instead of the new one?
For example, when receive starts, rename b/1 to b/2, take an ro snapshot
of b/2 named b/1, set b/2 to rw, update b/2's metadata, then update b/2
with the new incremental data just as before.

The current situation severely limits the use case of having a host
which has read-only data which is incrementally updated, which is
read/served by standard programs, not just backup restore tools, because
to have any persistent paths, you need to remount using the new
subvolume (generally means killing programs reading from it), or using
paths that begin like /dir/b{1,2} and then renaming subvolumes, and then
requesting that all reading programs reopen their files because they
will still have references in the old subvolume (again, often means
killing programs).
