Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f46.google.com ([209.85.213.46]:45225 "EHLO
        mail-vk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751626AbeD0A7Z (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 26 Apr 2018 20:59:25 -0400
MIME-Version: 1.0
In-Reply-To: <34B2B717-B12D-44F4-B0D0-E3D606BBEFA6@fb.com>
References: <CA+EzBbC7rmYsKjy_+rkwJLK-bmU51q+a4rnezvOoZYyJ8kWGqg@mail.gmail.com>
 <34B2B717-B12D-44F4-B0D0-E3D606BBEFA6@fb.com>
From: Jayashree Mohan <jayashree2912@gmail.com>
Date: Thu, 26 Apr 2018 19:59:23 -0500
Message-ID: <CA+EzBbBaZjcdHi4O4W8LZ2JvpYhN_hFGvktaeFYRfSygW3sK7A@mail.gmail.com>
Subject: Re: Inconsistent behavior of fsync in btrfs
To: Chris Mason <clm@fb.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>,
        Vijaychidambaram Velayudhan Pillai <vijay@cs.utexas.edu>,
        Filipe Manana <fdmanana@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

Thanks for the response. We are using a tool we developed called
CrashMonkey[1] to run crash consistency tests and generate the bug
reports above. We'd be happy to guide you through setting up
CrashMonkey and getting these bugs reproduced. However, if you want to
be able to reproduce them with your current setup (xfstest +
dm-flakey), I have the workload scripts attached to the end of the
mail which might make your task simpler.

Interestingly we seem to have found another bug that breaks rename
atomicity and results in a previously fsynced file missing.

Workload:
1. mkdir A
2. creat A/bar (*)
3. fsync A/bar
4. mkdir B
5. creat B/bar
6. rename B/bar A/bar
7. creat A/foo
8. fsync A/foo
9. fsync A
--- crash---

When we recover from the crash, we see that file A/bar goes missing.
If the rename did not persist, we expect to see A/bar(*) created in
step 2 above, or if the rename indeed persisted, we still expect file
A/bar to be present. A previously fsynced file going missing is a
concern, especially when you fsync the directory that contains this
file as well. This appears as if rename was not atomic and ended up
losing the files. What do you think about this scenario?

As stated above, please find the xfstest codes to reproduce the bugs
we reported:

_init_flakey
_mount_flakey

-----------------------------------------------------------------------
Workload 1 : File foo is missing

touch  $SCRATCH_MNT/foo
mkdir  $SCRATCH_MNT/a
touch  $SCRATCH_MNT/a/foo
$XFS_IO_PROG  -c  "fsync"   $SCRATCH_MNT/a/foo
$XFS_IO_PROG  -c  "fsync"   $SCRATCH_MNT

-----------------------------------------------------------------------
Workload 2 : Directory b and file b/foo are missing - instead foo
appears in directory a

mkdir  $SCRATCH_MNT/a
sync
mv  $SCRATCH_MNT/a   $SCRATCH_MNT/b
touch $SCRATCH_MNT/b/foo
$XFS_IO_PROG  -c  "fsync"   $SCRATCH_MNT/b/foo
$XFS_IO_PROG  -c  "fsync"   $SCRATCH_MNT/b


-----------------------------------------------------------------------
Workload 3 : File a/foo is missing

mkdir  $SCRATCH_MNT/a
mkdir  $SCRATCH_MNT/b
touch $SCRATCH_MNT/a/foo
ln  $SCRATCH_MNT/a/foo   $SCRATCH_MNT/b/foo
$XFS_IO_PROG  -c  "fsync"   $SCRATCH_MNT/b/foo
$XFS_IO_PROG  -c  "fsync"   $SCRATCH_MNT/a/foo

-----------------------------------------------------------------------
_flakey_drop_and_remount
_unmount_flakey

Thanks for your time!

[1] https://github.com/utsaslab/crashmonkey

Thanks,
Jayashree Mohan



On Thu, Apr 26, 2018 at 11:28 AM, Chris Mason <clm@fb.com> wrote:
> On 24 Apr 2018, at 20:35, Jayashree Mohan wrote:
>
>> Hi,
>>
>> While investigating crash consistency bugs on btrfs, we came across
>> workloads that demonstrate inconsistent behavior of fsync.
>>
>> Consider the following workload where fsync on the directory did not
>> persist it.
>
>
>> Only file B/foo gets persisted, and both A/foo and C/foo are missing.
>>
>> This seems like inconsistent behavior as only the first fsync persists
>> the file, while all others don't seem to. Do you agree if this is
>> indeed incorrect and needs fixing?
>>
>> All the above tests pass on ext4 and xfs.
>>
>> Please let us know what you feel about such inconsistency.
>>
>
> The btrfs fsync log is more fine grained than xfs/ext, but fsync(any file)
> should be enough to persist that file in its current directory.
>
> I'll get these reproduced and see if we can nail down why we're not logging
> the location properly.
>
> -chris
