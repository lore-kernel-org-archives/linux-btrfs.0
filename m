From: Sandra Schlichting <littlesandra88@gmail.com>
Subject: Encryption implementation like ZFS?
Date: Fri, 30 Dec 2011 19:32:14 +0100
Message-ID: <CAELiMBN7vPQ=42eNwT3oGztWS-666RrpzDzv7nDF_LX+0gjxhQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi everybody,

According to [0] ZFS does encryption:

One exception to this is the encryption support being added to the ZFS
filesystem. Filesystem metadata such as filenames, ownership, ACLs,
extended attributes are all stored encrypted on disk. The ZFS metadata
about the storage pool is still stored in the clear so it is possible
to determine how many filesystems (datasets) are available in the pool
and even which ones are encrypted but not what the content of the
stored files or directories are.

Will btrfs implement encryption the same way?

I read that the XFS encryption work have stalled. Does this impact btrfs?

Best regards,
Sandra

[0] http://en.wikipedia.org/wiki/Filesystem-level_encryption
