Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:38623 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1425080AbcBRQsK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Feb 2016 11:48:10 -0500
MIME-Version: 1.0
In-Reply-To: <20160218164341.GI6346@birch.djwong.org>
References: <1455533663-7704-1-git-send-email-fdmanana@kernel.org>
	<20160218013046.GU14668@dastard>
	<CAL3q7H4oF1adZX+TRC_V0HZEkBmLcC-26kBzJtR9Yj3+8FSBoA@mail.gmail.com>
	<20160218164341.GI6346@birch.djwong.org>
Date: Thu, 18 Feb 2016 16:48:05 +0000
Message-ID: <CAL3q7H5OfRk57Z0hD8cpRAbfie081zE+Vxg3txSSmAhCTdvWtw@mail.gmail.com>
Subject: Re: [PATCH 1/2] fstests: generic test for directory fsync after
 rename operation
From: Filipe Manana <fdmanana@kernel.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>, fstests@vger.kernel.org,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Filipe Manana <fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 18, 2016 at 4:43 PM, Darrick J. Wong
<darrick.wong@oracle.com> wrote:
> On Thu, Feb 18, 2016 at 01:38:41PM +0000, Filipe Manana wrote:
>> On Thu, Feb 18, 2016 at 1:30 AM, Dave Chinner <david@fromorbit.com> wrote:
>> > On Mon, Feb 15, 2016 at 10:54:23AM +0000, fdmanana@kernel.org wrote:
>> >> From: Filipe Manana <fdmanana@suse.com>
>> >>
>> >> Test that if we move one file between directories, fsync the parent
>> >> directory of the old directory, power fail and remount the filesystem,
>> >> the file is not lost and it's located at the destination directory.
>> >>
>> >> This is motivated by a bug found in btrfs, which is fixed by the patch
>> >> (for the linux kernel) titled:
>> >>
>> >>   "Btrfs: fix file loss on log replay after renaming a file and fsync"
>> >>
>> >> Tested against ext3, ext4, xfs, f2fs and reiserfs.
>> >>
>> >> Signed-off-by: Filipe Manana <fdmanana@suse.com>
>> > ....
>> >> +# We expect our file foo to exist, have an entry in the new parent
>> >> +# directory (c/) and not have anymore an entry in the old parent directory
>> >> +# (a/b/).
>> >> +[ -e $SCRATCH_MNT/a/b/foo ] && echo "File foo is still at directory a/b/"
>> >> +[ -e $SCRATCH_MNT/c/foo ] || echo "File foo is not at directory c/"
>> >> +
>> >> +# The new file named bar should also exist.
>> >> +[ -e $SCRATCH_MNT/a/bar ] || echo "File bar is missing"
>> >
>> > This can all be replaced simply by:
>> >
>> > ls -R $SCRATCH_MNT | _filter_scratch
>> >
>> > Because the golden image match will tell us if files are missing or
>> > in the wrong place.
>>
>> The problem with that is ext3/4 have the lost+found directory that
>> xfs, btrfs, etc don't have.
>
> XFS can have lost+found too, though this seems unlikely on the scratch mount.
>
>> Do you mind about something like this:
>>
>> # exclude lost+found directory specific to some filesystems (ext3/4)
>> ls -R $SCRATCH_MNT | grep -v 'lost+found' | tr -s '\n' | _filter_scratch
>
> Why not put "a" and "c" under $SCRATCH_MNT/test-335/?

Would work as well. I was thinking earlier of just doing two ls -R
calls, one for a/ and other for c/.
Thanks Darrick.

>
> --D
>
>>
>> (since you usually dislike generic tests having any specific logic for
>> specific filesystems)
>>
>> Also do I need to remove _need_to_be_root for the 3 tests I submitted?
>> I only noticed there was a submitted patch that kills that function
>> after sending them.
>>
>> thanks
>>
>>
>> >
>> > Cheers,
>> >
>> > Dave.
>> > --
>> > Dave Chinner
>> > david@fromorbit.com
>> --
>> To unsubscribe from this list: send the line "unsubscribe fstests" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
