Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f49.google.com ([209.85.213.49]:43944 "EHLO
        mail-vk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750841AbeDYCfu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Apr 2018 22:35:50 -0400
MIME-Version: 1.0
From: Jayashree Mohan <jayashree2912@gmail.com>
Date: Tue, 24 Apr 2018 21:35:48 -0500
Message-ID: <CA+EzBbC7rmYsKjy_+rkwJLK-bmU51q+a4rnezvOoZYyJ8kWGqg@mail.gmail.com>
Subject: Inconsistent behavior of fsync in btrfs
To: linux-btrfs <linux-btrfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
Cc: Vijaychidambaram Velayudhan Pillai <vijay@cs.utexas.edu>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

While investigating crash consistency bugs on btrfs, we came across
workloads that demonstrate inconsistent behavior of fsync.

Consider the following workload where fsync on the directory did not persist it.

Workload 1:

mkdir A
Sync
rename (A, B)
creat B/foo
fsync B/foo
fsync B
---crash---

In this case, the directory B as well as file B/foo are missing.
What's more worrying is that, on recovery from crash, we expect the
contents of directory to be

Dir A : should not exist
Dir B :
    foo

But instead, what we see is that:
Dir A :
    foo
Dir B : doesn't exist


This state is acceptable if we had created the file foo in dir A and
then renamed the directory - in that case it would mean the rename did
not persist. However what we see here is that, a file created in
directory B falsely appears in A, which is incorrect.

However, if we did not persist the initial create of directory A, i.e

Workload 2:

mkdir A
rename (A, B)
creat B/foo
fsync B/foo
fsync B
---crash---

the directory B and its entry both get persisted in this case.

Is this something to do with the directory entry A being already
present in the FS/subvolume tree and then the changes to the directory
inode going into the fsync log?

We do not clearly understand the reason for such inconsistent
behavior, but it does seem incorrect.

Consider another case where we found inconsistent behavior in the way
fsync is handled.

Workload 3:

mkdir A
mkdir B
creat A/foo
link (A/foo, B/foo)
fsync A/foo
fsync B/foo
---crash---

In this case,  file A/foo is persisted, but inspite of an explicit
fsync on B/foo, the file goes missing.

Workload 4:

mkdir A
mkdir B
creat A/foo
link (A/foo, B/foo)
fsync B/foo
fsync A/foo
---crash---

Note that, the only difference between workload 3 and 4 is the order
of fsync on files A/foo and B/foo. In this case, the file B/foo is
persisted, but A/foo is missing.

What we interpret from the above workloads is that, the second fsync
is behaving like a no-op, and in either cases, only the file that is
fsynced first gets persisted. If we insert a sleep(45) between the two
fsyncs in the workloads above, we see both the files A/foo and B/foo
being persisted.

No matter how many more links we create and fsync, only the first
fsync persists the file, i.e for example,

Workload 5:

mkdir A
mkdir B
mkdir C
creat A/foo
link (A/foo, B/foo)
link (A/foo, C/foo)
fsync B/foo
fsync A/foo
fsync C/foo
---crash---

Only file B/foo gets persisted, and both A/foo and C/foo are missing.

This seems like inconsistent behavior as only the first fsync persists
the file, while all others don't seem to. Do you agree if this is
indeed incorrect and needs fixing?

All the above tests pass on ext4 and xfs.

Please let us know what you feel about such inconsistency.


Thanks,
Jayashree Mohan
