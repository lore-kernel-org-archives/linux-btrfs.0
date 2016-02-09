Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:39138 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932948AbcBIWR2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Feb 2016 17:17:28 -0500
MIME-Version: 1.0
In-Reply-To: <20160204212134.GE31407@dastard>
References: <1454544688-18723-1-git-send-email-fdmanana@kernel.org>
	<20160204212134.GE31407@dastard>
Date: Tue, 9 Feb 2016 22:17:26 +0000
Message-ID: <CAL3q7H4g9NdAktgQdVAF4t-5r=9uqTZhLF=EHw2Go4SsC_d+UA@mail.gmail.com>
Subject: Re: [PATCH] fstests: btrfs, test for send with clone operations
From: Filipe Manana <fdmanana@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: fstests@vger.kernel.org,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Filipe Manana <fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 4, 2016 at 9:21 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Thu, Feb 04, 2016 at 12:11:28AM +0000, fdmanana@kernel.org wrote:
>> From: Filipe Manana <fdmanana@suse.com>
>>
>> Test that an incremental send operation which issues clone operations
>> works for files that have a full path containing more than one parent
>> directory component.
>>
>> This used to fail before the following patch for the linux kernel:
>>
>>   "[PATCH] Btrfs: send, fix extent buffer tree lock assertion failure"
>>
>> Signed-off-by: Filipe Manana <fdmanana@suse.com>
>
> Looks ok, I've pulled it in. Something to think about:
>
>> +# Create a bunch of small and empty files, this is just to make sure our
>> +# subvolume's btree gets more than 1 leaf, a condition necessary to trigger a
>> +# past bug (1000 files is enough even for a leaf/node size of 64K, the largest
>> +# possible size).
>> +for ((i = 1; i <= 1000; i++)); do
>> +     echo -n > $SCRATCH_MNT/a/b/c/z_$i
>> +done
>
> We already do have a generic function for doing this called
> _populate_fs(), it's just not optimised for speed with large numbers
> of files being created.
>
> i.e. The above is simple a single directory tree with a single level
> with 1000 files of size 0:
>
>         _populate_fs() -d 1 -n 1 -f 1000 -s 0 -r $SCRATCH_MNT/a/b/
>
> Can you look into optimising _populate_fs() to use multiple threads
> (say up to 4 by default) and "echo -n" to create files, and then
> convert all our open coded "create lots of files" loops in tests to
> use it?

Sure, I'll take a look at it when I get some spare time.
Thanks Dave.

>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
