Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailgw-01.dd24.net ([193.46.215.41]:37323 "EHLO
        mailgw-01.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932334AbeCKWh4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 11 Mar 2018 18:37:56 -0400
Message-ID: <1520807872.4281.11.camel@scientia.net>
Subject: Re: Ongoing Btrfs stability issues
From: Christoph Anton Mitterer <calestyo@scientia.net>
To: kreijack@inwind.it
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Date: Sun, 11 Mar 2018 23:37:52 +0100
In-Reply-To: <01ddb562-f1e2-25cf-0a8a-ffaa43b867d3@libero.it>
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
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 2018-03-11 at 18:51 +0100, Goffredo Baroncelli wrote:
> 
> COW is needed to properly checksum the data. Otherwise is not
> possible to ensure the coherency between data and checksum (however I
> have to point out that BTRFS fails even in this case [*]).
> We could rearrange this sentence, saying that: if you want checksum,
> you need COW...

No,... not really... the meta-data is anyway always CoWed... so if you
do checksum *and* notdatacow,..., the only thing that could possibly
happen (in the worst case) is, that data that actually made it
correctly to the disk is falsely determined bad, as the metadata (i.e.
the checksums) weren't upgraded correctly.

That however is probably much less likely than the other way round,..
i.e. bad data went to disk and would be detected with checksuming.


I had lots of discussions about this here on the list, and no one ever
brought up a real argument against it... I also had an off-list
discussion with Chris Mason who IIRC confirmed that it would actually
work as I imagine it... with the only two problems:
- good data possibly be marked bad because of bad checksums
- reads giving back EIO where people would rather prefer bad data
(not really sure if this were really his two arguments,... I'd have to
look it up, so don't nail me down).


Long story short:

In any case, I think giving back bad data without EIO is unacceptable.
If someone really doesn't care (e.g. because he has higher level
checksumming and possibly even repair) he could still manually disable
checksumming.

The little chance of having a false positive weights IMO far less that
have very large amounts of data (DBs, VM images are our typical cases)
completely unprotected.

And not having checksumming with notdatacow breaks any safe raid repair
(so in that case "repair" may even overwrite good data),... which is
IMO also unacceptable.
And the typical use cases for nodatacow (VMs, DBs) are in turn not so
uncommon to want RAID.


I really like btrfs,... and it's not that other fs (which typically
have no checksumming at all) would perform better here... but not
having it for these major use case is a big disappointment for me.


Cheers,
Chris.
