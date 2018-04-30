Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:50956 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751511AbeD3Obf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 30 Apr 2018 10:31:35 -0400
From: Chris Mason <clm@fb.com>
To: "Theodore Y. Ts'o" <tytso@mit.edu>
CC: Vijay Chidambaram <vijay@cs.utexas.edu>,
        Jayashree Mohan <jayashree2912@gmail.com>,
        David Sterba <dsterba@suse.cz>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>, Filipe Manana <fdmanana@kernel.org>
Subject: Re: Inconsistent behavior of fsync in btrfs
Date: Mon, 30 Apr 2018 10:30:47 -0400
Message-ID: <79CF8EAE-4E37-4FC9-9C3F-2011482A9BFD@fb.com>
In-Reply-To: <20180429221606.GR5965@thunk.org>
References: <CA+EzBbC7rmYsKjy_+rkwJLK-bmU51q+a4rnezvOoZYyJ8kWGqg@mail.gmail.com>
 <34B2B717-B12D-44F4-B0D0-E3D606BBEFA6@fb.com>
 <CA+EzBbBaZjcdHi4O4W8LZ2JvpYhN_hFGvktaeFYRfSygW3sK7A@mail.gmail.com>
 <20180427160740.GD21272@twin.jikos.cz>
 <1A75793D-6487-4EE6-9F4D-AD538D7283CA@fb.com>
 <20180427205313.GM5965@thunk.org>
 <CA+EzBbAwsZf-AvGG15EnDinrzFyHaoPs_bTCVoZt_mHM06Jptg@mail.gmail.com>
 <CAPaz=EKt+zBSun725V5PuV2mO_v49HSgbMkcjYF5ARBKPkfOtA@mail.gmail.com>
 <20180429221606.GR5965@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 29 Apr 2018, at 18:16, Theodore Y. Ts'o wrote:

> On Sun, Apr 29, 2018 at 03:55:39PM -0500, Vijay Chidambaram wrote:
>> In the spirit of clarifying fsync behavior, we have one more case
>> where we'd like to find out what should be expected.
>>
>> Consider this:
>>
>> Mkdir A
>> Creat A/bar
>> Fsync A/bar
>> Rename A to B
>> Fsync B/bar
>> -- Crash --
>>
>> A/bar has been fsynced previously, so its not a newly created file.
>> After the crash, in ext4 and btrfs, can we expect directory B and
>> B/bar to exist?
>
> or ext4, no.  The POSIX semantics apply: bar will *either* be in A,
> or in B.

Same for btrfs.  If the rename for B goes down, it'll be a side effect 
of other decisions and not on purpose.  I'd actually like for the rename 
to be on disk in the normal case, but we won't always be able to catch 
it.

>
> If you modify the file bar such that the mod time has been updated,
> then fsync(2) --- but not necessarily fdatasync(2) --- will cause the
> inode modifications to be written committed, and this will cause the
> updates to directory B from the rename to be committed as a
> side-effect.
>
> Note though that there are plenty of people who consider this to be a
> performance bug, and not a feature, and there have been papers
> proposed by your fellow academics that if implemented, would change
> this to no longer be true.
>
> In general with these sorts of things it would be useful to reason
> about this in the context of real world applications and why they want
> such guarantees.  These guarantees can cost performance hits, and so
> there is a cost/benefit tradeoff involved.  So my preference is to
> negotiate with applicationt writes, and ask *why* they want such
> guarantees, and to explore whether there better ways of achieving
> their high level goals before we legislate this to be an iron-clad
> commitment which might application A happy, but performance-seeking
> user B unhappy.
>
>> I know this is not POSIX compliant, but from prior comments, it seems
>> like both ext4 and btrfs would like to persist directory entries upon
>> fsync of newly created files. So we were wondering if this extended 
>> to
>> this case.
>
> We had real world examples of users/applications who suffered data
> loss when the directory entries for newly created files were not
> persisted.  It was on the basis of these complaints that we made this
> commitment, since it seemed more important than the relatively minor
> performance hit.
>

Agreeing with Ted and expanding a bit.  If fsync(some file) doesn't 
persist the name for that file, applications need to fsync the 
directories, which can be double the log commits.  Getting everything 
down to disk in one fsync() is much better for both the application and 
the FS.

-chris
