Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f46.google.com ([209.85.213.46]:41682 "EHLO
        mail-vk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932980AbeD0Xoj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 27 Apr 2018 19:44:39 -0400
MIME-Version: 1.0
In-Reply-To: <20180427205313.GM5965@thunk.org>
References: <CA+EzBbC7rmYsKjy_+rkwJLK-bmU51q+a4rnezvOoZYyJ8kWGqg@mail.gmail.com>
 <34B2B717-B12D-44F4-B0D0-E3D606BBEFA6@fb.com> <CA+EzBbBaZjcdHi4O4W8LZ2JvpYhN_hFGvktaeFYRfSygW3sK7A@mail.gmail.com>
 <20180427160740.GD21272@twin.jikos.cz> <1A75793D-6487-4EE6-9F4D-AD538D7283CA@fb.com>
 <20180427205313.GM5965@thunk.org>
From: Jayashree Mohan <jayashree2912@gmail.com>
Date: Fri, 27 Apr 2018 18:44:37 -0500
Message-ID: <CA+EzBbAwsZf-AvGG15EnDinrzFyHaoPs_bTCVoZt_mHM06Jptg@mail.gmail.com>
Subject: Re: Inconsistent behavior of fsync in btrfs
To: "Theodore Y. Ts'o" <tytso@mit.edu>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.cz>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>,
        Vijaychidambaram Velayudhan Pillai <vijay@cs.utexas.edu>,
        Filipe Manana <fdmanana@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks Chris and Ted for putting down the expected fsync behaviour of
btrfs and ext4 clearly. This sort of information is not documented
anywhere; it would be really useful if all major filesystems
explicitly stated what fsync behavior to expect. Filesystems
definitely seem to provide more guarantees than POSIX and it would of
great help to researchers and developers, if you all documented what
guarantees we can expect from each filesystem.

On Fri, Apr 27, 2018 at 3:53 PM, Theodore Y. Ts'o <tytso@mit.edu> wrote:
> On Fri, Apr 27, 2018 at 11:33:29AM -0600, Chris Mason wrote:
>> My goal for the fsync tree log was to make it just do the right thing most
>> of the time.  We mostly got there, thanks to a ton of fixes and test cases
>> from Filipe.
>>
>> fsync(some file) -- all the names for this file will exist, without having
>> to fsync the directory.
>>
>> fsync(some dir) -- ugh, don't fsync the directory.  But if you do, all the
>> files/subdirs will exist, and unlinks will be done and renames will be
>> included.  This is slow and may require a full FS commit, which is why we
>> don't want dirs fsunk.
>
> What ext4 does is this:
>
> fsync(some file) -- for a newly created file, the filename that it was
>         created under will exist.  If the file has a hard-link added,
>         the hard link is not guarnateed to be written to disk
>
> fsync(some dir) -- all changes to file names in thentee directory will
>         exist after the crash.  It does *not* guarantee that any data
>         changes to any of files in the directories will persist after
>         a crash.
>
> It seems to me that it would be desirable if all of the major file
> systems have roughly the same minimum guarantee for fsync(2), so that
> application writers don't have to make file-system specific
> assumptions.  In general the goal ought to be "the right thing" should
> happen.
>
> The reason why ext4 doesn't sync all possible hard link names is that
> (a) that's not a common requiremnt for most applications, and (b) it's
> too hard to find all of the directories which might contain a hard
> link to a particular file.  But otherwise, the semantics seem to
> largely match up with what Chris as suggested for btrfs.
>
>                                     - Ted
