Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:46826 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751861AbbBWUev (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Feb 2015 15:34:51 -0500
Message-ID: <54EB8EE5.3000303@sandeen.net>
Date: Mon, 23 Feb 2015 14:34:45 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
To: fdmanana@gmail.com
CC: Filipe Manana <fdmanana@suse.com>, fstests@vger.kernel.org,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] fstests: generic test for fsync after removing xattrs
References: <1424721327-25972-1-git-send-email-fdmanana@suse.com>	<54EB8A1F.2050207@sandeen.net> <CAL3q7H49ZtC+5mgtp5C5fDyXjCzMysWOUsA=kFAg9KATq4ot5A@mail.gmail.com>
In-Reply-To: <CAL3q7H49ZtC+5mgtp5C5fDyXjCzMysWOUsA=kFAg9KATq4ot5A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2/23/15 2:24 PM, Filipe David Manana wrote:
> On Mon, Feb 23, 2015 at 8:14 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
>> On 2/23/15 1:55 PM, Filipe Manana wrote:
>>> This test is motivated by an fsync issue discovered in btrfs.
>>> The issue was that the fsync log replay code did not remove xattrs that
>>> were deleted before the inode was fsynced. The result was unexpected
>>> and differed from xfs and ext3/4 for example.
>>>
>>> The btrfs issue was fixed by the following linux kernel patch:
>>>
>>>    Btrfs: remove deleted xattrs on fsync log replay
>>>
>>> Signed-off-by: Filipe Manana <fdmanana@suse.com>
>>> ---
>>>  tests/generic/061     | 115 ++++++++++++++++++++++++++++++++++++++++++++++++++
>>>  tests/generic/061.out |  10 +++++
>>>  tests/generic/group   |   1 +
>>>  3 files changed, 126 insertions(+)
>>>  create mode 100755 tests/generic/061
>>>  create mode 100644 tests/generic/061.out
>>>
>>> diff --git a/tests/generic/061 b/tests/generic/061
>>> new file mode 100755
>>> index 0000000..a5eb668
>>> --- /dev/null
>>> +++ b/tests/generic/061
>>> @@ -0,0 +1,115 @@
>>> +#! /bin/bash
>>> +# FS QA Test No. 061
>>
>> Could you describe what the test actually does first in the header
>> comment?  You have the btrfs-specific flaw, but (I say this after
>> having looked at 034 just this morning) sometimes it's nice to
>> have a concise description of the test.
>>
>> i.e.:
>>
>> # Test that log replay properly handles deleted xattrs after an fsync
>> <or whatever is the proper operational description>
>>
>> at the very top, so it's clear from a glance what the test *does*
>> without having to read through it.
> 
> Hi Eric,
> 
> I thought the initial summary was clear enough:
> 
> # FS QA Test No. 061
> #
> # This test is motivated by an fsync issue discovered in btrfs.
> # The issue was that the fsync log replay code did not remove xattrs that
> # were deleted before the inode was fsynced.
> 
> How more detailed/clear would you put it?

Eh, it's ok; it describes why you decided to write the test, not what the
test does.  Subtle difference?

...

>> I think maybe a
>>
>> _requires_metadata_journaling
>>
>> or similar might be a good idea.  Thoughts?  Unfortunately that would
>> need some special-casing for ext4, to see if it has jbd2 turned on or
>> not, but I can help with that.
>>
>> (dumpe2fs -h $TEST_DEV | grep has_journal)
> 
> Thanks for the heads up on that detail.
> 
> For the ext4 case, since the test creates the fs, if FSTYP == ext4,
> could we force passing -O has_journal to mkfs (or make sure -O
> ^has_journal is filtered out).

Well, if someone is explicitly testing nojournal ext4, I wouldn't turn
it on behind their backs just for this test; that'd be a bit odd.

Let me take a stab at a _requires_metadata_journaling() helper.

-Eric


