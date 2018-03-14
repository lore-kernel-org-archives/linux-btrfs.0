Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-31-i6.italiaonline.it ([213.209.14.31]:39739 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751739AbeCNSj2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Mar 2018 14:39:28 -0400
Reply-To: kreijack@inwind.it
Subject: Re: Ongoing Btrfs stability issues
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Christoph Anton Mitterer <calestyo@scientia.net>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <SN2PR03MB22697EDC5BC991C819353117A9F40@SN2PR03MB2269.namprd03.prod.outlook.com>
 <3b483ff8-cd89-d62a-67d8-d1da6a28ef64@gmail.com>
 <595ED26B-1FCD-4693-8E11-8F4CB267D1C7@oseberg.io>
 <0ca621b4-6307-1acf-65b7-4584dd678d80@suse.com>
 <20180302172951.GC30920@dhcp-10-211-47-181.usdhcp.oraclecorp.com>
 <DBEFB1DF-D6A7-48D9-AF90-88759597A777@oseberg.io>
 <fc88341d-e440-3007-4b54-e21f74182036@suse.com>
 <D15AA258-5C89-433A-94E3-6C16A0DA4297@oseberg.io>
 <5a12a7b7-6cf3-82f8-d5fa-2915fc3d6680@suse.com>
 <1520692153.24363.15.camel@scientia.net>
 <01ddb562-f1e2-25cf-0a8a-ffaa43b867d3@libero.it>
 <1520807872.4281.11.camel@scientia.net>
 <3fd8f21b-2e4d-3696-8e92-a20e4dda13ec@inwind.it>
 <1520891338.4266.16.camel@scientia.net>
 <d6e007af-7980-3d9b-a497-acb3be90dac9@inwind.it>
 <96d34674-b1f0-25db-ba36-5a48f1b7c047@gmail.com>
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <fc0c1f0d-59cd-f593-b63d-e62b8ffa3a43@inwind.it>
Date: Wed, 14 Mar 2018 19:39:25 +0100
MIME-Version: 1.0
In-Reply-To: <96d34674-b1f0-25db-ba36-5a48f1b7c047@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 03/14/2018 01:02 PM, Austin S. Hemmelgarn wrote:
[...]
>>
>> In btrfs, a checksum mismatch creates an -EIO error during the reading. In a conventional filesystem (or a btrfs filesystem w/o datasum) there is no checksum, so this problem doesn't exist.
>>
>> I am curious how ZFS solves this problem.
> It doesn't support disabling COW or the O_DIRECT flag, so it just never has the problem in the first place.

I would like to perform some tests: however I think that you are right. if you make a "double buffering" approach (copy the data in the page cache, compute the checksum, then write the data to disk), the mismatch should not happen. Of course this is incompatible with O_DIRECT; but disabling O_DIRECT is a prerequisite to the "double buffering"; alone it couldn't be sufficient; what about mmap ? Are we sure that this does a double buffering ?

I would prefer that btrfs doesn't allow O_DIRECT with the COW files. I prefer this to the checksum mismatch bug.


>>
>> However I have to point out that this problem is not solved by the COW. COW solved only the problem about an interrupted commit of the filesystem, where the data is update in place (so it is available by the user), but the metadata not.
> COW is irrelevant if you're bypassing it.  It's only enforced for metadata so that you don't have to check the FS every time you mount it (because the way BTRFS uses it guarantees consistency of the metadata).
>>
>>>
>>> Even if not... I should be only a problem in case of a crash during
>>> that,.. and than I'd still prefer to get the false positive than bad
>>> data.
>>
>> How you can know if it is a "bad data" or a "bad checksum" ?
> You can't directly.  Just like you can't know which copy in a two-device MD RAID1 array is bad when they mismatch.
> 
> That's part of why I'm not all that fond of the idea of having checksums without COW, you need to verify the data using secondary means anyway, so why exactly should you waste time verifying it twice?

This is true

>>
>>>
>>> Anyway... it's not going to happen so the discussion is pointless.
>>> I think people can probably use dm-integrity (which btw: does no CoW
>>> either (IIRC) and still can provide integrity... ;-) ) to see whether
>>> their data is valid.
>>> No nice but since it won't change on btrfs, a possible alternative.
>>
>> Even in this case I am curious about dm-integrity would sole this issue.
> dm-integrity uses journaling, and actually based on the testing I've done, will typically have much worse performance than the overhead of just enabling COW on files on BTRFS and manually defragmenting them on a regular basis.

Good to know
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
