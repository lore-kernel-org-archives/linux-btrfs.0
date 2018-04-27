Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:33018 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751727AbeD0Rd5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 27 Apr 2018 13:33:57 -0400
From: Chris Mason <clm@fb.com>
To: David Sterba <dsterba@suse.cz>
CC: Jayashree Mohan <jayashree2912@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>,
        Vijaychidambaram Velayudhan Pillai <vijay@cs.utexas.edu>,
        Filipe Manana <fdmanana@kernel.org>
Subject: Re: Inconsistent behavior of fsync in btrfs
Date: Fri, 27 Apr 2018 11:33:29 -0600
Message-ID: <1A75793D-6487-4EE6-9F4D-AD538D7283CA@fb.com>
In-Reply-To: <20180427160740.GD21272@twin.jikos.cz>
References: <CA+EzBbC7rmYsKjy_+rkwJLK-bmU51q+a4rnezvOoZYyJ8kWGqg@mail.gmail.com>
 <34B2B717-B12D-44F4-B0D0-E3D606BBEFA6@fb.com>
 <CA+EzBbBaZjcdHi4O4W8LZ2JvpYhN_hFGvktaeFYRfSygW3sK7A@mail.gmail.com>
 <20180427160740.GD21272@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; markup=markdown
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 27 Apr 2018, at 10:07, David Sterba wrote:

> On Thu, Apr 26, 2018 at 07:59:23PM -0500, Jayashree Mohan wrote:
>> Thanks for the response. We are using a tool we developed called
>> CrashMonkey[1] to run crash consistency tests and generate the bug
>> reports above. We'd be happy to guide you through setting up
>> CrashMonkey and getting these bugs reproduced. However, if you want 
>> to
>> be able to reproduce them with your current setup (xfstest +
>> dm-flakey), I have the workload scripts attached to the end of the
>> mail which might make your task simpler.
>>
>> Interestingly we seem to have found another bug that breaks rename
>> atomicity and results in a previously fsynced file missing.
>>
>> Workload:
>> 1. mkdir A
>> 2. creat A/bar (*)
>> 3. fsync A/bar
>> 4. mkdir B
>> 5. creat B/bar
>> 6. rename B/bar A/bar
>> 7. creat A/foo
>> 8. fsync A/foo
>> 9. fsync A
>> --- crash---
>>
>> When we recover from the crash, we see that file A/bar goes missing.
>> If the rename did not persist, we expect to see A/bar(*) created in
>> step 2 above, or if the rename indeed persisted, we still expect file
>> A/bar to be present.
>
> I'm no fsync expert and the lack of standard or well defined behaviour
> (mentioned elsewhere) leads me to question, on what do you base your
> expectations? Not only for this report, but in general during your
> testing.
>
> Comparing various filesystems will show that at best it's 
> implementation
> defined and everybody has their own reasons for doing it one way or
> another, or request fsync at particular time etc.
>
> We have a manual page in section 5 that contains general topics of
> btrfs, so documenting the fsync specifics would be good.

My goal for the fsync tree log was to make it just do the right thing 
most of the time.  We mostly got there, thanks to a ton of fixes and 
test cases from Filipe.

fsync(some file) -- all the names for this file will exist, without 
having to fsync the directory.

fsync(some dir) -- ugh, don't fsync the directory.  But if you do, all 
the files/subdirs will exist, and unlinks will be done and renames will 
be included.  This is slow and may require a full FS commit, which is 
why we don't want dirs fsunk.

-chris
