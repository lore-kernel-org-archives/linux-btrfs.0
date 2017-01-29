Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:49184 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751576AbdA2T20 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 29 Jan 2017 14:28:26 -0500
Subject: Re: btrfs recovery
To: Oliver Freyermuth <o.freyermuth@googlemail.com>,
        Hugo Mills <hugo@carfax.org.uk>
References: <961e2f81-40e6-cced-f14a-7af7effe1e5e@googlemail.com>
 <20170126092559.GD24076@carfax.org.uk>
 <24f6cfb2-d008-af12-ad94-4a4da1be1ee2@googlemail.com>
 <9c38e493-e4aa-a718-c6a8-d400bcff0df8@googlemail.com>
 <3255da6a-c4a6-c464-7bc7-56fcff281937@googlemail.com>
 <42184069-91dd-9e32-5b41-f13f95960e86@mendix.com>
 <dab6c1c7-ebfc-5578-d9f4-ae3001b9efbf@googlemail.com>
 <0ab48f84-7e37-02aa-1de9-612fac3f02da@mendix.com>
 <58d4a6a0-fba9-79ca-9077-1c708b7a65a3@googlemail.com>
Cc: linux-btrfs@vger.kernel.org
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <53a7797d-05b1-16f3-42f3-e6e9509cce4f@mendix.com>
Date: Sun, 29 Jan 2017 20:28:24 +0100
MIME-Version: 1.0
In-Reply-To: <58d4a6a0-fba9-79ca-9077-1c708b7a65a3@googlemail.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 01/29/2017 08:09 PM, Oliver Freyermuth wrote:
>> [..whaaa.. text.. see previous message..]
> Wow - this nice python toolset really makes it easy, bigmomma holding your hands ;-) . 
> 
> Indeed, I get exactly the same output you did show in your example, which almost matches my manual change, apart from one bit here:
> -00001fb0  d9 4f 00 00 00 00 00 00  00 20 a1 4d 01 00 95 d8
> +00001fb0  d9 4f 00 00 00 00 00 00  00 20 a1 4d 00 00 00 00
> I do not understand this change from 01 to 00, is this some parity information which python-btrfs fixed up automatically?
> 
> Trusting the output, I did:
> dd if=mblock_first_fixed of=/dev/sdb1 bs=1 seek=43417600 count=16384
> dd if=mblock_first_fixed of=/dev/sdb1 bs=1 seek=1117159424 count=16384
> and re-ran "btrfs-debug-tree -b 35028992 /dev/sdb1" to confirm, item 243 is now:
> ...
>         key (5547032576 EXTENT_ITEM 204800) block 596426752 (36403) gen 20441
>         key (5561905152 EXTENT_ITEM 184320) block 596443136 (36404) gen 20441
> =>      key (1302405120 EXTENT_ITEM 303104) block 596459520 (36405) gen 20441
>         key (5726711808 EXTENT_ITEM 524288) block 596475904 (36406) gen 20441
>         key (5820571648 EXTENT_ITEM 524288) block 350322688 (21382) gen 20427

Ehm, oh yes, that was obviously a mistake in what I showed. The
0xffffffff cuts off too much..

>>> 0xd89500014da12000 & 0xffffffff
1302405120L

This is better...

>>> 0xd89500014da12000 & 0xffffffffff
5597372416L

...which is the value Hugo also mentioned to likely be the value that
has to be there, since it nicely fits in between the surrounding keys.

> ...
> Sadly, trying to mount, I still get:
> [190422.147717] BTRFS info (device sdb1): use lzo compression
> [190422.147846] BTRFS info (device sdb1): disk space caching is enabled
> [190422.229227] BTRFS critical (device sdb1): corrupt node, bad key order: block=35028992, root=1, slot=242
> [190422.241635] BTRFS critical (device sdb1): corrupt node, bad key order: block=35028992, root=1, slot=242
> [190422.241644] BTRFS error (device sdb1): failed to read block groups: -5
> [190422.254824] BTRFS error (device sdb1): open_ctree failed
> The notable difference is that previously, the message was:
> corrupt node, bad key order: block=35028992, root=1, slot=243
> So does this tell me that also item 242 was corrupted?

No, I was just going too fast.

A nice extra excercise is to look up the block at 596459520, which this
item points to, and then see which object is the first one in the part
of the tree stored in that page. It should be (5597372416 EXTENT_ITEM
303104) I guess.

-- 
Hans van Kranenburg
