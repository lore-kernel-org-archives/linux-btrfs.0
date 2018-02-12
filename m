Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f44.google.com ([209.85.214.44]:56259 "EHLO
        mail-it0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964852AbeBLQCI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Feb 2018 11:02:08 -0500
Received: by mail-it0-f44.google.com with SMTP id b66so7230788itd.5
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Feb 2018 08:02:08 -0800 (PST)
Subject: Re: btrfs-cleaner / snapshot performance analysis
To: "Ellis H. Wilson III" <ellisw@panasas.com>,
        Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        Tomasz Pala <gotar@polanet.pl>
Cc: linux-btrfs@vger.kernel.org
References: <346220b8-d129-1de9-eb28-6344ec0b0d3a@panasas.com>
 <96cd9e57-cde4-5bc4-0312-02b54668e59a@mendix.com>
 <76e7f364-62b9-5ef1-a8ed-f6fb9e534963@panasas.com>
 <20180210220549.GA30438@polanet.pl>
 <6abc187c-b5fe-a776-6b89-ca5b6c7ee790@panasas.com>
 <20c617b6-7179-a67a-3997-8fee766088a5@mendix.com>
 <c7e267a4-d47d-9713-c222-81dcb441e009@panasas.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <57d8d368-9c96-db65-14a6-2af39cc509f9@gmail.com>
Date: Mon, 12 Feb 2018 11:02:02 -0500
MIME-Version: 1.0
In-Reply-To: <c7e267a4-d47d-9713-c222-81dcb441e009@panasas.com>
Content-Type: text/plain; charset=iso-8859-2; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-02-12 10:37, Ellis H. Wilson III wrote:
> On 02/11/2018 01:24 PM, Hans van Kranenburg wrote:
>> Why not just use `btrfs fi du <subvol> <snap1> <snap2>` now and then and
>> update your administration with the results? .. Instead of putting the
>> burden of keeping track of all administration during every tiny change
>> all day long?
> 
> I will look into that if using built-in group capacity functionality 
> proves to be truly untenable.  Thanks!
As a general rule, unless you really need to actively prevent a 
subvolume from exceeding it's quota, this will generally be more 
reliable and have much less performance impact than using qgroups.
> 
>>> CoW is still valuable for us as we're shooting to support on the order
>>> of hundreds of snapshots per subvolume,
>>
>> Hundreds will get you into trouble even without qgroups.
> 
> I should have been more specific.  We are looking to use up to a few 
> dozen snapshots per subvolume, but will have many (tens to hundreds of) 
> discrete subvolumes (each with up to a few dozen snapshots) in a BTRFS 
> filesystem.  If I have it wrong and the scalability issues in BTRFS do 
> not solely apply to subvolumes and their snapshot counts, please let me 
> know.
The issue isn't so much total number of snapshots as it is how many 
snapshots are sharing data.  If each of your individual subvolumes 
shares no data with any of the others via reflinks (so no deduplication 
across subvolumes, and no copying files around using reflinks or the 
clone ioctl), then I would expect things will be just fine without 
qgroups provided that you're not deleting huge numbers of snapshots at 
the same time.

With qgroups involved, I really can't say for certain, as I've never 
done much with them myself, but based on my understanding of how it all 
works, I would expect multiple subvolumes with a small number of 
snapshots each to not have as many performance issues as a single 
subvolume with the same total number of snapshots.
> 
> I will note you focused on my tiny desktop filesystem when making some 
> of your previous comments -- this is why I didn't want to share specific 
> details.  Our filesystem will be RAID0 with six large HDDs (12TB each). 
> Reliability concerns do not apply to our situation for technical 
> reasons, but if there are capacity scaling issues with BTRFS I should be 
> made aware of, I'd be glad to hear them.  I have not seen any in 
> technical documentation of such a limit, and experiments so far on 6x6TB 
> arrays has not shown any performance problems, so I'm inclined to 
> believe the only scaling issue exists with reflinks.  Correct me if I'm 
> wrong.
BTRFS in general works fine at that scale, dependent of course on the 
level of concurrent access you need to support.  Each tree update needs 
to lock a bunch of things in the tree itself, and having large numbers 
of clients writing to the same set of files concurrently can cause lock 
contention issues because of this, especially if all of them are calling 
fsync() or fdatasync() regularly.  These issues can be mitigated by 
segregating workloads into their own subvolumes (each subvolume is a 
mostly independent filesystem tree), but it sounds like you're already 
doing that, so I don't think that would be an issue for you.

The only other possibility I can think of is that the performance hit 
from qgroups may scale not just based on the number of snapshots of a 
given subvolume, but also the total size of the subvolume (more data 
means more accounting work), though I'm not certain about that (it's 
just a hunch based on what I do know about qgroups).

Now, there are some other odd theoretical cases that may cause issues 
when dealing with really big filesystems, but they're either really 
specific edge cases (for example, starting with a really small 
filesystem and gradually scaling it up in size as it gets full) or 
happen at scales far larger than what you're talking about (on the order 
of at least double digit petabyte scale).
