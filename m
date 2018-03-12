Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-17-i6.italiaonline.it ([213.209.14.17]:56351 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932242AbeCLVWU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Mar 2018 17:22:20 -0400
Reply-To: kreijack@inwind.it
Subject: Re: Ongoing Btrfs stability issues
To: Christoph Anton Mitterer <calestyo@scientia.net>
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
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <3fd8f21b-2e4d-3696-8e92-a20e4dda13ec@inwind.it>
Date: Mon, 12 Mar 2018 22:22:18 +0100
MIME-Version: 1.0
In-Reply-To: <1520807872.4281.11.camel@scientia.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 03/11/2018 11:37 PM, Christoph Anton Mitterer wrote:
> On Sun, 2018-03-11 at 18:51 +0100, Goffredo Baroncelli wrote:
>>
>> COW is needed to properly checksum the data. Otherwise is not
>> possible to ensure the coherency between data and checksum (however I
>> have to point out that BTRFS fails even in this case [*]).
>> We could rearrange this sentence, saying that: if you want checksum,
>> you need COW...
> 
> No,... not really... the meta-data is anyway always CoWed... so if you
> do checksum *and* notdatacow,..., the only thing that could possibly
> happen (in the worst case) is, that data that actually made it
> correctly to the disk is falsely determined bad, as the metadata (i.e.
> the checksums) weren't upgraded correctly.
> 
> That however is probably much less likely than the other way round,..
> i.e. bad data went to disk and would be detected with checksuming.

Unfortunately no, the likelihood might be 100%: there are some patterns which trigger this problem quite easily. See The link which I posted in my previous email. There was a program which creates a bad checksum (in COW+DATASUM mode), and the file became unreadable.

> 
> 
> I had lots of discussions about this here on the list, and no one ever
> brought up a real argument against it... I also had an off-list
> discussion with Chris Mason who IIRC confirmed that it would actually
> work as I imagine it... with the only two problems:
> - good data possibly be marked bad because of bad checksums
> - reads giving back EIO where people would rather prefer bad data

If you cannot know if a checksum is bad or the data is bad, the checksum is not useful at all!

If I read correctly what you wrote, it seems that you consider a "minor issue" the fact that the checksum is not correct. If you accept the possibility that a checksum might be wrong, you wont trust anymore the checksum; so the checksum became not useful.
 

> (not really sure if this were really his two arguments,... I'd have to
> look it up, so don't nail me down).
> 
> 
> Long story short:
> 
> In any case, I think giving back bad data without EIO is unacceptable.
> If someone really doesn't care (e.g. because he has higher level
> checksumming and possibly even repair) he could still manually disable
> checksumming.
> 
> The little chance of having a false positive weights IMO far less that
> have very large amounts of data (DBs, VM images are our typical cases)
> completely unprotected.

Again, you are assuming that the likelihood of having a bad checksum is low. Unfortunately this is not true. There are pattern which exploits this bug with a likelihood=100%.

> 
> And not having checksumming with notdatacow breaks any safe raid repair
> (so in that case "repair" may even overwrite good data),... which is
> IMO also unacceptable.
> And the typical use cases for nodatacow (VMs, DBs) are in turn not so
> uncommon to want RAID.
> 
> 
> I really like btrfs,... and it's not that other fs (which typically
> have no checksumming at all) would perform better here... but not
> having it for these major use case is a big disappointment for me.
> 
> 
> Cheers,
> Chris.
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
