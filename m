Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:57034 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751115AbdCQJmY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Mar 2017 05:42:24 -0400
Subject: Re: help : "bad tree block start" -> btrfs forced readonly
To: Lionel Bouton <lionel-subscription@bouton.name>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <0ec911af-2932-72df-d9b3-bd27616e101e@bouton.name>
 <c704f24e-4ea2-43fe-909e-92ad98bf6d28@bouton.name>
 <4866fa5d-d9bc-653a-17d8-b555fc55491e@mendix.com>
 <2994d13d-c65c-0794-8a83-a68ff258f109@bouton.name>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <9a41b998-746f-53d5-c208-805f1b9fdc86@mendix.com>
Date: Fri, 17 Mar 2017 10:42:22 +0100
MIME-Version: 1.0
In-Reply-To: <2994d13d-c65c-0794-8a83-a68ff258f109@bouton.name>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 03/17/2017 10:27 AM, Lionel Bouton wrote:
> Hi,
> 
> Le 17/03/2017 à 09:43, Hans van Kranenburg a écrit :
>> btrfs-debug-tree -b 3415463870464
> 
> Here is what it gives me back :
> 
> btrfs-debug-tree -b 3415463870464 /dev/sdb
> btrfs-progs v4.6.1
> checksum verify failed on 3415463870464 found A85405B7 wanted 01010101
> checksum verify failed on 3415463870464 found A85405B7 wanted 01010101
> bytenr mismatch, want=3415463870464, have=72340172838076673
> ERROR: failed to read 3415463870464

So in the place where checksum is supposed to be stored, it has 01010101
and recomputing the checksum of the garbage results in A85405B7. Found /
wanted is also confusing here, since 01010101 is what it found, but
A85405B7 is what it 'found out'.

> Is there a way to remove part of the tree and keep the rest ? It could
> help minimize the time needed to restore data.

No, that's not how it works. Those trees are not file/directory
structure trees.

You can try btrfs-debug-tree <blockdevice> and see how far it gets
dumping everything it can find, and then search for 3415463870464 in the
output. Somewhere, there has to be another object (one level higher)
which points to this address. If you find it, you can find out in which
tree the block lives.

-- 
Hans van Kranenburg
