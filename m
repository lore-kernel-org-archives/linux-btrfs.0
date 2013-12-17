Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64606 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753455Ab3LQQxd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Dec 2013 11:53:33 -0500
From: David Howells <dhowells@redhat.com>
To: Simon Wilkinson <simonxwilkinson@gmail.com>, jaltman@your-file-system.com
cc: dhowells@redhat.com,
        "openafs-devel@openafs.org" <openafs-devel@openafs.org>,
        linux-btrfs@vger.kernel.org, clm@fb.com
Subject: What is needed to build an AFS fileserver on top of BTRFS?
Date: Tue, 17 Dec 2013 16:53:16 +0000
Message-ID: <14884.1387299196@warthog.procyon.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


It has occurred to me and others that something like BTRFS could be a good fit
to build an AFS fileserver directly on top of.  The question is what facilities
would be needed from BTRFS to make this work?

So I thought I'd kick off a shopping list;-)

 (1) 64-bit data version numbers that increase monotonically with each write.

     Yes, this is likely to cause some performance degredation as it introduces
     an ordering over data writes and metadata writes to a file.  Maybe writes
     can be batched to improve performance?

 (2) Storage for ACLs and AFS UIDs.  Having shareable ACLs might also be useful.

     Xattrs would likely do for this.

 (3) The ability to snapshot a filesystem to make backups and for pushing to
     read-only volume servers.

 (4) A 32-bit vnode number and 32-bit vnode uniquifier/generation number.

     These don't necessarily have to be stored by BTRFS directly but could
     instead be in a separate database file that gets snapshotted also.

 (5) The ability to set the vnode number, vnode uniquifier and data version
     number to specific values.  Necessary to clone volumes and restore
     volume dumps.

David
