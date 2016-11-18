Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zlom.siedziba.pl ([83.144.122.22]:52129 "EHLO zlom.siedziba.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751058AbcKRHZu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Nov 2016 02:25:50 -0500
Subject: Re: Send/receive snapshot from/between backup
To: =?UTF-8?B?UmVuw6kgQsO8aGxtYW5u?= <rene@buehlmann.net>,
        linux-btrfs@vger.kernel.org
References: <a58d070d-30f8-9abe-04cd-4cb4ba88697b@buehlmann.net>
 <7bc4c937-fbe6-2e0f-8f2c-471d6b9481ad@siedziba.pl>
 <b7fae3c7-848e-f09b-4acd-1b9ce824ce99@buehlmann.net>
From: =?UTF-8?Q?Piotr_Paw=c5=82ow?= <pp@siedziba.pl>
Message-ID: <0d479a7d-6106-0e22-67dc-4182b2b25414@siedziba.pl>
Date: Fri, 18 Nov 2016 08:23:46 +0100
MIME-Version: 1.0
In-Reply-To: <b7fae3c7-848e-f09b-4acd-1b9ce824ce99@buehlmann.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 16.11.2016 21:32, René Bühlmann wrote:
>
>> 1. Change received uuid of S1 on SSH to match S1 uuid on USB.
>> [...]
> 2. Full transfer S1 from SSH to SSH'
>
> 3. Incremental transfer S2 from USB to SSH' (S1 as parent)
>
> 4. Incremental transfer S3 from Origin to SSH' (S2 as parent)
>
> [..]
> Step 3 and 4 did work as well and surprisingly, I did not even had to
> update the "received uuid". They cant be full transfers as that would
> have taken months with my bandwidth. How can this be?

Hans van Kranenburg wrote in another post that you can send back an
incremental snapshot, so I guess the algorithm is more complicated.

Since S1 on SSH was faked to be received from USB, and S1 on SSH' is
received from S1 on SSH, and SSH is the same host as SSH' so both
subvolumes are visible by btrfs receive tool, maybe it can follow the
path and see that S1 on SSH' came from USB? I don't know.

I wonder why does it even matter for send / receive where a subvolume
comes from. Why not base it only on the content? Do I have a subvolume
that has the same content as the parent used for incremental send? - if
yes, then use it for receive.

If btrfs used a Merkle tree and had strong checksums, then a subvolume
checksum could be used as the content identifier (does it use a Merkle
tree? - Wikipedia article about the tree lists btrfs, but I can't find
any source).

Otherwise there could be a "fake" content identifier. A random "content
uuid" generated when setting subvolume read-only, and removed when
setting read/write (read only snapshot would preserve it, and rw
snapshot would remove it). Send / receive would preserve "content uuid",
and compare parent's "content uuid" for incremental send. Wouldn't it be
easier and more flexible than the current "received uuid" scheme? Am I
missing something?

Regards
