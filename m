Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:65344 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752316AbaKQLAI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Nov 2014 06:00:08 -0500
Message-ID: <5469D524.7010808@web.de>
Date: Mon, 17 Nov 2014 11:59:48 +0100
From: Konstantin <newsbox1026@web.de>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fb.com>, Hugo Mills <hugo@carfax.org.uk>,
        Btrfs mailing list <linux-btrfs@vger.kernel.org>,
        Chris Mason <clm@fb.com>
Subject: Re: Two persistent problems
References: <20141114215159.GA32735@carfax.org.uk> <54667B7A.8050704@fb.com>
In-Reply-To: <54667B7A.8050704@fb.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Josef Bacik wrote on 14.11.2014 at 23:00:
> On 11/14/2014 04:51 PM, Hugo Mills wrote:
>>     Chris, Josef, anyone else who's interested,
>>
>>     On IRC, I've been seeing reports of two persistent unsolved
>> problems. Neither is showing up very often, but both have turned up
>> often enough to indicate that there's something specific going on
>> worthy of investigation.
>>
>>     One of them is definitely a btrfs problem. The other may be btrfs,
>> or something in the block layer, or just broken hardware; it's hard to
>> tell from where I sit.
>>
>> Problem 1: ENOSPC on balance
>>
>>     This has been going on since about March this year. I can
>> reasonably certainly recall 8-10 cases, possibly a number more. When
>> running a balance, the operation fails with ENOSPC when there's plenty
>> of space remaining unallocated. This happens on full balance, filtered
>> balance, and device delete. Other than the ENOSPC on balance, the FS
>> seems to work OK. It seems to be more prevalent on filesystems
>> converted from ext*. The first few or more reports of this didn't make
>> it to bugzilla, but a few of them since then have gone in.
>>
>> Problem 2: Unexplained zeroes
>>
>>     Failure to mount. Transid failure, "expected xyz, have 0". Chris
>> looked at an early one of these (for Ke, on IRC) back in September
>> (the 27th -- sadly, the public IRC logs aren't there for it, but I can
>> supply a copy of the private log). He rapidly came to the conclusion
>> that it was something bad going on with TRIM, replacing some blocks
>> with zeroes. Since then, I've seen a bunch of these coming past on
>> IRC. It seems to be a 3.17 thing. I can successfully predict the
>> presence of an SSD and -odiscard from the "have 0". I've successfully
>> persuaded several people to put this into bugzilla and capture
>> btrfs-images.  btrfs recover doesn't generally seem to be helpful in
>> recovering data.
>>
>>
>>     I think Josef had problem 1 in his sights, but I don't know if
>> additional images or reports are helpful at this point. For problem 2,
>> there's obviously something bad going on, but there's not much else to
>> go on -- and the inability to recover data isn't good.
>>
>>     For each of these, what more information should I be trying to
>> collect from any future reporters?
>>
>>
>
> So for #2 I've been looking at that the last two weeks.  I'm always
> paranoid we're screwing up one of our data integrity sort of things,
> either not waiting on IO to complete properly or something like that.
> I've built a dm target to be as evil as possible and have been running
> it trying to make bad things happen.  I got slightly side tracked
> since my stress test exposed a bug in the tree log stuff an csums
> which I just fixed.  Now that I've fixed that I'm going back to try
> and make the "expected blah, have 0" type errors happen.
>
> As for the ENOSPC I keep meaning to look into it and I keep getting
> distracted with other more horrible things.  Ideally I'd like to
> reproduce it myself, so more info on that front would be good, like do
> all reports use RAID/compression/some other odd set of features? 
> Thanks for taking care of this stuff Hugo, #2 is the worst one and I'd
> like to be absolutely sure it's not our bug, once I'm happy we aren't
> I'll look at the balance thing.
>
> Josef

For #2, I had a strangely damaged BTRFS I reported a week or so ago
which may have similar background. Dmesg gives:

parent transid verify failed on 586239082496 wanted 13329746340512024838
found 588
BTRFS: open_ctree failed

The thing is that btrfsck crashes when trying to check this. As nobody
seemed to be interested I reformatted this disk today.

