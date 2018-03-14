Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-31-i6.italiaonline.it ([213.209.14.31]:44295 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751279AbeCNWRk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Mar 2018 18:17:40 -0400
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
 <fc0c1f0d-59cd-f593-b63d-e62b8ffa3a43@inwind.it>
 <1c54d4ed-a1ce-e6c4-a79b-f75ec1c14556@gmail.com>
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <01aa532e-c39a-3616-8948-88caa5c82417@inwind.it>
Date: Wed, 14 Mar 2018 23:17:36 +0100
MIME-Version: 1.0
In-Reply-To: <1c54d4ed-a1ce-e6c4-a79b-f75ec1c14556@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 03/14/2018 08:27 PM, Austin S. Hemmelgarn wrote:
> On 2018-03-14 14:39, Goffredo Baroncelli wrote:
>> On 03/14/2018 01:02 PM, Austin S. Hemmelgarn wrote:
>> [...]
>>>>
>>>> In btrfs, a checksum mismatch creates an -EIO error during the reading. In a conventional filesystem (or a btrfs filesystem w/o datasum) there is no checksum, so this problem doesn't exist.
>>>>
>>>> I am curious how ZFS solves this problem.
>>> It doesn't support disabling COW or the O_DIRECT flag, so it just never has the problem in the first place.
>>
>> I would like to perform some tests: however I think that you are right. if you make a "double buffering" approach (copy the data in the page cache, compute the checksum, then write the data to disk), the mismatch should not happen. Of course this is incompatible with O_DIRECT; but disabling O_DIRECT is a prerequisite to the "double buffering"; alone it couldn't be sufficient; what about mmap ? Are we sure that this does a double buffering ?
> There's a whole lot of applications that would be showing some pretty serious issues if checksumming didn't work correctly with mmap(), so I think it does work correctly given that we don't have hordes of angry users and sysadmins beating down the doors.

I tried to do in parallel updating a page and writing in different thread; I was unable to reproduce a checksum mismatch; so it seems that mmap are safe from this point of view;

>>
>> I would prefer that btrfs doesn't allow O_DIRECT with the COW files. I prefer this to the checksum mismatch bug.
> This is only reasonable if you are writing to the files.  Checksums appear to be checked on O_DIRECT reads, and outside of databases and VM's, read-only access accounts for a significant percentage of O_DIRECT usage, partly because it is needed for AIO support (nginx for example can serve files using AIO and O_DIRECT and gets a pretty serious performance boost on heavily loaded systems by doing so).
> 

So O_DIRECT should be unsupported/ignored only for the writing ? It could be a good compromise...

BR
G.Baroncelli
-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
