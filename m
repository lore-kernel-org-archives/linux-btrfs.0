Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:34877 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754035Ab2FTKfL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Jun 2012 06:35:11 -0400
From: Alexander Block <ablock84@googlemail.com>
To: linux-btrfs@vger.kernel.org
Cc: dave@jikos.cz, hch@infradead.org, linux-fsdevel@vger.kernel.org,
        chris.mason@fusionio.com, linux-kernel@vger.kernel.org,
        Alexander Block <ablock84@googlemail.com>
Subject: [PATCH] Allow cross subvolume reflinks (2nd attempt)
Date: Wed, 20 Jun 2012 12:35:11 +0200
Message-Id: <1340188512-5761-1-git-send-email-ablock84@googlemail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

This is the second attempt to bring in cross subvolume reflinks into btrfs.
The first attempt was NAKed due to missing vfs mount checks and a clear
description of what btrfs subvolumes are and probably also why cross 
subvolume reflinks are ok in the case of btrfs. This version of the patch 
comes from David and is in SUSE kernels since a long time, so it is tested 
and working. The patch also does proper vfs mount checks, so cross mount 
point reflinks are not possible with this patch. It only allows cross 
reflinks between two subvolumes which are in the same mount point. 

As requested in the older discussion, I'll try to describe what subvolumes
in btrfs are. From the users point of view, a subvolume is just a directory
in the mounted fs with its own inode space. This means, that two inodes
with the same number from different subvolumes are different files. 
Parallel to the sub directory form, a subvolume may be mounted in its own
vfs mount point (I'm however not sure if this is already possible or just
planned). Internally, a btrfs subvolume is a separate btree, containing
all the metadata needed to store the fs of the subvolume.
Additionally to the subvolumes, btrfs has snapshots, which are basically
the same as subvolumes, with the difference that they share metadata and
data with the snapshot origin/parent. Everything that applies to 
subvolumes also applies to snapshots.

The clone ioctl requires the destination file to be already existing and
opened for writing. This means that we do not touch any vfs semantics
regarding creation/opening of files. The ioctl only copies the extents 
information from the source to the destination, doing proper access 
checks before. In my opinion, we can compare the clone ioctl to the 
sendfile syscall, with the difference that we don't copy data but the 
information where the data lies.

Link to the old discussion:
http://thread.gmane.org/gmane.comp.file-systems.btrfs/9864 
Only PATCH 2/2 is of interrest now. The discussion also contains some
arguments why cross subvolume reflinks are a good thing, but I think
this should not be the matter of the new discussion.

Alex.

David Sterba (1):
  btrfs: allow cross-subvolume file clone

 fs/btrfs/ioctl.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

-- 
1.7.10

