Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from newman.cs.utexas.edu ([128.83.139.110]:49888 "EHLO
        newman.cs.utexas.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750815AbeD2U41 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 29 Apr 2018 16:56:27 -0400
MIME-Version: 1.0
Reply-To: vijay@cs.utexas.edu
In-Reply-To: <CA+EzBbAwsZf-AvGG15EnDinrzFyHaoPs_bTCVoZt_mHM06Jptg@mail.gmail.com>
References: <CA+EzBbC7rmYsKjy_+rkwJLK-bmU51q+a4rnezvOoZYyJ8kWGqg@mail.gmail.com>
 <34B2B717-B12D-44F4-B0D0-E3D606BBEFA6@fb.com> <CA+EzBbBaZjcdHi4O4W8LZ2JvpYhN_hFGvktaeFYRfSygW3sK7A@mail.gmail.com>
 <20180427160740.GD21272@twin.jikos.cz> <1A75793D-6487-4EE6-9F4D-AD538D7283CA@fb.com>
 <20180427205313.GM5965@thunk.org> <CA+EzBbAwsZf-AvGG15EnDinrzFyHaoPs_bTCVoZt_mHM06Jptg@mail.gmail.com>
From: Vijay Chidambaram <vijay@cs.utexas.edu>
Date: Sun, 29 Apr 2018 15:55:39 -0500
Message-ID: <CAPaz=EKt+zBSun725V5PuV2mO_v49HSgbMkcjYF5ARBKPkfOtA@mail.gmail.com>
Subject: Re: Inconsistent behavior of fsync in btrfs
To: Jayashree Mohan <jayashree2912@gmail.com>
Cc: "Theodore Y. Ts'o" <tytso@mit.edu>, Chris Mason <clm@fb.com>,
        David Sterba <dsterba@suse.cz>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>, Filipe Manana <fdmanana@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> On Fri, Apr 27, 2018 at 3:53 PM, Theodore Y. Ts'o <tytso@mit.edu> wrote:
>> On Fri, Apr 27, 2018 at 11:33:29AM -0600, Chris Mason wrote:
>>> My goal for the fsync tree log was to make it just do the right thing most
>>> of the time.  We mostly got there, thanks to a ton of fixes and test cases
>>> from Filipe.
>>>
>>> fsync(some file) -- all the names for this file will exist, without having
>>> to fsync the directory.
>>>
>>> fsync(some dir) -- ugh, don't fsync the directory.  But if you do, all the
>>> files/subdirs will exist, and unlinks will be done and renames will be
>>> included.  This is slow and may require a full FS commit, which is why we
>>> don't want dirs fsunk.
>>
>> What ext4 does is this:
>>
>> fsync(some file) -- for a newly created file, the filename that it was
>>         created under will exist.  If the file has a hard-link added,
>>         the hard link is not guarnateed to be written to disk
>>
>> fsync(some dir) -- all changes to file names in thentee directory will
>>         exist after the crash.  It does *not* guarantee that any data
>>         changes to any of files in the directories will persist after
>>         a crash.

In the spirit of clarifying fsync behavior, we have one more case
where we'd like to find out what should be expected.

Consider this:

Mkdir A
Creat A/bar
Fsync A/bar
Rename A to B
Fsync B/bar
-- Crash --

A/bar has been fsynced previously, so its not a newly created file.
After the crash, in ext4 and btrfs, can we expect directory B and
B/bar to exist?

I know this is not POSIX compliant, but from prior comments, it seems
like both ext4 and btrfs would like to persist directory entries upon
fsync of newly created files. So we were wondering if this extended to
this case.
