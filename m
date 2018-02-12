Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-by2nam03on0044.outbound.protection.outlook.com ([104.47.42.44]:29078
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S964902AbeBLQjq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Feb 2018 11:39:46 -0500
Subject: Re: btrfs-cleaner / snapshot performance analysis
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
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
 <57d8d368-9c96-db65-14a6-2af39cc509f9@gmail.com>
From: "Ellis H. Wilson III" <ellisw@panasas.com>
Message-ID: <41d6badc-90d4-54f9-085e-fd75afde74eb@panasas.com>
Date: Mon, 12 Feb 2018 11:39:54 -0500
MIME-Version: 1.0
In-Reply-To: <57d8d368-9c96-db65-14a6-2af39cc509f9@gmail.com>
Content-Type: text/plain; charset=iso-8859-2; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/12/2018 11:02 AM, Austin S. Hemmelgarn wrote:
>> I will look into that if using built-in group capacity functionality 
>> proves to be truly untenable.  Thanks!
> As a general rule, unless you really need to actively prevent a 
> subvolume from exceeding it's quota, this will generally be more 
> reliable and have much less performance impact than using qgroups.

Ok ok :).  I will plan to go this route, but since I'll want to 
benchmark it either way, I'll include qgroups enabled in the benchmark 
and will report back.

> With qgroups involved, I really can't say for certain, as I've never 
> done much with them myself, but based on my understanding of how it all 
> works, I would expect multiple subvolumes with a small number of 
> snapshots each to not have as many performance issues as a single 
> subvolume with the same total number of snapshots.

Glad to hear that.  That was my expectation as well.

> BTRFS in general works fine at that scale, dependent of course on the 
> level of concurrent access you need to support.  Each tree update needs 
> to lock a bunch of things in the tree itself, and having large numbers 
> of clients writing to the same set of files concurrently can cause lock 
> contention issues because of this, especially if all of them are calling 
> fsync() or fdatasync() regularly.  These issues can be mitigated by 
> segregating workloads into their own subvolumes (each subvolume is a 
> mostly independent filesystem tree), but it sounds like you're already 
> doing that, so I don't think that would be an issue for you.
Hmm...I'll think harder about this.  There is potential for us to 
artificially divide access to files across subvolumes automatically 
because of the way we are using BTRFS as a backing store for our 
parallel file system.  So far even with around 1000 threads across about 
10 machines accessing BTRFS via our parallel filesystem over the wire 
we've not seen issues, but if we do I have some ways out I've not 
explored yet.  Thanks!

> Now, there are some other odd theoretical cases that may cause issues 
> when dealing with really big filesystems, but they're either really 
> specific edge cases (for example, starting with a really small 
> filesystem and gradually scaling it up in size as it gets full) or 
> happen at scales far larger than what you're talking about (on the order 
> of at least double digit petabyte scale).

Yea, our use case will be in the tens of TB to hundreds of TB for the 
foreseeable future, so I'm glad to hear this is relatively standard. 
That was my read of the situation as well.

Thanks!

ellis
