Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f179.google.com ([209.85.223.179]:38316 "EHLO
        mail-io0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750967AbdIIXuK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 9 Sep 2017 19:50:10 -0400
Received: by mail-io0-f179.google.com with SMTP id n69so10652654ioi.5
        for <linux-btrfs@vger.kernel.org>; Sat, 09 Sep 2017 16:50:10 -0700 (PDT)
MIME-Version: 1.0
From: Rohan Kadekodi <kadekodirohan@gmail.com>
Date: Sat, 9 Sep 2017 18:50:09 -0500
Message-ID: <CADb0YN=G1MT=VwLcfbbrnppeXRKe3Zi4EsmwSs+xw89wR9rb4A@mail.gmail.com>
Subject: Regarding handling of file renames in Btrfs
To: linux-btrfs@vger.kernel.org
Cc: Vijaychidambaram Velayudhan Pillai <vijay@cs.utexas.edu>,
        Jayashree Mohan <jayashree2912@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I was trying to understand how file renames are handled in Btrfs. I
read the code documentation, but had a problem understanding a few
things.

During a file rename, btrfs_commit_transaction() is called which is
because Btrfs has to commit the whole FS before storing the
information related to the new renamed file. It has to commit the FS
because a rename first does an unlink, which is not recorded in the
btrfs_rename() transaction and so is not logged in the log tree. Is my
understanding correct? If yes, my questions are as follows:

1. What does committing the whole FS mean? Blktrace shows that there
are 2       256KB writes, which are essentially writes to the data of
the root directory of the file system (which I found out through
btrfs-debug-tree). Is this equivalent to doing a shell sync, as the
same block groups are written during a shell sync too? Also, does it
imply that all the metadata held by the log tree is now checkpointed
to the respective trees?

2. Why are there 2 complete writes to the data held by the root
directory and not just 1? These writes are 256KB each, which is the
size of the extent allocated to the root directory

3. Why are the writes being done to the root directory of the file
system / subvolume and not just the parent directory where the unlink
happened?

It would be great if I could get the answers to these questions.

Thanks,
Rohan
