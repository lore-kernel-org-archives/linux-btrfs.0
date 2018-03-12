Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailgw-02.dd24.net ([193.46.215.43]:40277 "EHLO
        mailgw-02.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932265AbeCLVtC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Mar 2018 17:49:02 -0400
Message-ID: <1520891338.4266.16.camel@scientia.net>
Subject: Re: Ongoing Btrfs stability issues
From: Christoph Anton Mitterer <calestyo@scientia.net>
To: kreijack@inwind.it
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Date: Mon, 12 Mar 2018 22:48:58 +0100
In-Reply-To: <3fd8f21b-2e4d-3696-8e92-a20e4dda13ec@inwind.it>
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
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2018-03-12 at 22:22 +0100, Goffredo Baroncelli wrote:
> Unfortunately no, the likelihood might be 100%: there are some
> patterns which trigger this problem quite easily. See The link which
> I posted in my previous email. There was a program which creates a
> bad checksum (in COW+DATASUM mode), and the file became unreadable.
But that rather seems like a plain bug?!

No reason that would conceptually make checksumming+notdatacow
impossible.

AFAIU, the conceptual thin would be about:
- data is written in nodatacow
  => thus a checksum must be written as well, so write it
- what can then of course happen is
  - both csum and data are written => fine
  - csum is written but data not and then some crash => csum will show
    that => fine
  - data is written but csum not and then some crash => csum will give
    false positive

Still better few false positives, as many unnoticed data corruptions
and no true raid repair.


> If you cannot know if a checksum is bad or the data is bad, the
> checksum is not useful at all!
Why not? It's anyway only uncertain in the case of crash,... and it at
least tells you that something is fishy.
A program which cares about its data will ensure its own journaling
means and can simply recover by this... or users could then just roll
in a backup.
Or one could provide some API/userland tool to recompute the csums of
the affected file (and possibly live with bad data).


> If I read correctly what you wrote, it seems that you consider a
> "minor issue" the fact that the checksum is not correct. If you
> accept the possibility that a checksum might be wrong, you wont trust
> anymore the checksum; so the checksum became not useful.
There's simply no disadvantage to not having checksumming at all in the
nodatacow case.
Cause then you never have an idea whether your data is correct or
not... the case with checksumming + datacow, which can give a false
positive on a crash when data was written correctly, but not the
checksum, covers at least the other cases of data corruption (silent
data corruption, csum written, but data not or only partially in case
of a crash).


> Again, you are assuming that the likelihood of having a bad checksum
> is low. Unfortunately this is not true. There are pattern which
> exploits this bug with a likelihood=100%.

Okay I don't understand why this would be so and wouldn't assume that
the IO pattern can affect it heavily... but I'm not really btrfs
expert.

My blind assumption would have been that writing an extent of data
takes much longer to complete than writing the corresponding checksum.

Even if not... I should be only a problem in case of a crash during
that,.. and than I'd still prefer to get the false positive than bad
data.


Anyway... it's not going to happen so the discussion is pointless.
I think people can probably use dm-integrity (which btw: does no CoW
either (IIRC) and still can provide integrity... ;-) ) to see whether
their data is valid.
No nice but since it won't change on btrfs, a possible alternative.


Cheers,
Chris.
