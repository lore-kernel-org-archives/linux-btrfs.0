Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f52.google.com ([209.85.214.52]:37228 "EHLO
	mail-it0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752145AbcF1LXn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Jun 2016 07:23:43 -0400
Received: by mail-it0-f52.google.com with SMTP id f6so12344392ith.0
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Jun 2016 04:23:11 -0700 (PDT)
Subject: Re: Adventures in btrfs raid5 disk recovery
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
        Chris Murphy <lists@colorremedies.com>
References: <576D6C0A.7070502@gmail.com>
 <CAJCQCtSskA4PC_a8tgQopHFNO83NQ=Gkx406haB7G0nBi5e=2A@mail.gmail.com>
 <c2a320a6-261b-723d-ab83-58f883e6315b@gmail.com>
 <CAJCQCtSqO4GNm8kBDuzUXEXYx+54zFgsD6=ARNsRgVUb53LQZw@mail.gmail.com>
 <fd7d250c-0a5a-ea3e-9ea2-ec6e50e14169@gmail.com>
 <CAJCQCtQugDoR6fnPeion37FLS3LarjfP6dt+-Z3jPgLG0Xkmwg@mail.gmail.com>
 <20160627215726.GG14667@hungrycats.org>
 <CAJCQCtRbrLaXSGm9DA6FrHO9Pd9ozaaJpKd6HjMGXCojdxbZoQ@mail.gmail.com>
 <20160628015245.GI14667@hungrycats.org>
 <CAJCQCtTQTo7JRBuWgTWZ=T+EA5P-uRLjoiknTzv9gwy4Z290XQ@mail.gmail.com>
 <20160628031726.GJ14667@hungrycats.org>
Cc: Andrei Borzenkov <arvidjaar@gmail.com>, Hugo Mills <hugo@carfax.org.uk>,
        kreijack@inwind.it, Roman Mamedov <rm@romanrm.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <188e0845-af90-44bc-a07a-424991e954ea@gmail.com>
Date: Tue, 28 Jun 2016 07:23:01 -0400
MIME-Version: 1.0
In-Reply-To: <20160628031726.GJ14667@hungrycats.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-06-27 23:17, Zygo Blaxell wrote:
> On Mon, Jun 27, 2016 at 08:39:21PM -0600, Chris Murphy wrote:
>> On Mon, Jun 27, 2016 at 7:52 PM, Zygo Blaxell
>> <ce3g8jdj@umail.furryterror.org> wrote:
>>> On Mon, Jun 27, 2016 at 04:30:23PM -0600, Chris Murphy wrote:
>>>> Btrfs does have something of a work around for when things get slow,
>>>> and that's balance, read and rewrite everything. The write forces
>>>> sector remapping by the drive firmware for bad sectors.
>>>
>>> It's a crude form of "resilvering" as ZFS calls it.
>>
>> In what manner is it crude?
>
> Balance relocates extents, looks up backrefs, and rewrites metadata, all
> of which are extra work above what is required by resilvering (and extra
> work that is proportional to the number of backrefs and the (currently
> extremely poor) performance of the backref walking code, so snapshots
> and large files multiply the workload).
>
> Resilvering should just read data, reconstruct it from a mirror if
> necessary, and write it back to the original location (or read one
> mirror and rewrite the other).  That's more like what scrub does, except
> scrub rewrites only the blocks it couldn't read (or that failed csum).
It's worth pointing out that balance was not designed for resilvering, 
it was designed for reshaping arrays, converting replication profiles, 
and compaction at the chunk level.  Balance is not a resilvering tool, 
that just happens to be a useful side effect of running a balance 
(actually, so is the chunk level compaction).


