Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from azure.uno.uk.net ([95.172.254.11]:45812 "EHLO azure.uno.uk.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754264AbdC3QN4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Mar 2017 12:13:56 -0400
Received: from ty.sabi.co.uk ([95.172.230.208]:58340)
        by azure.uno.uk.net with esmtpsa (TLSv1.2:DHE-RSA-AES128-SHA:128)
        (Exim 4.88)
        (envelope-from <pg@btrfs.list.sabi.co.uk>)
        id 1ctchu-001MrF-04
        for linux-btrfs@vger.kernel.org; Thu, 30 Mar 2017 17:13:54 +0100
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
        by ty.sabi.co.UK with esmtps(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)(Exim 4.82 3)
        id 1ctchY-0007PY-Ho
        for <linux-btrfs@vger.kernel.org>; Thu, 30 Mar 2017 17:13:32 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-ID: <22749.11946.474065.536986@tree.ty.sabi.co.uk>
Date: Thu, 30 Mar 2017 17:13:30 +0100
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Shrinking a device - performance?
In-Reply-To: <b0f6b00e-4c70-72d1-8683-c05bb72a0968@siedziba.pl>
References: <1CCB3887-A88C-41C1-A8EA-514146828A42@flyingcircus.io>
        <20170327130730.GN11714@carfax.org.uk>
        <3558CE2F-0B8F-437B-966C-11C1392B81F2@flyingcircus.io>
        <20170327194847.5c0c5545@natsu>
        <4E13254F-FDE8-47F7-A495-53BFED814C81@flyingcircus.io>
        <22746.30348.324000.636753@tree.ty.sabi.co.uk>
        <b0f6b00e-4c70-72d1-8683-c05bb72a0968@siedziba.pl>
From: pg@btrfs.list.sabi.co.UK (Peter Grandi)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>> As a general consideration, shrinking a large filetree online
>> in-place is an amazingly risky, difficult, slow operation and
>> should be a last desperate resort (as apparently in this case),
>> regardless of the filesystem type, and expecting otherwise is
>> "optimistic".

> The way btrfs is designed I'd actually expect shrinking to be
> fast in most cases. It could probably be done by moving whole
> chunks at near platter speed, [ ... ] It just hasn't been
> implemented yet.

That seems to me a rather "optimistic" argument, as most of the
cost of shrinking is the 'balance' to pack extents into chunks.

As that thread implies, the current implementation in effect
does a "balance" while shrinking, by moving extents from chunks
"above the line" to free space in chunks "below the line".

The proposed "move whole chunks" implementation helps only if
there are enough unallocated chunks "below the line". If regular
'balance' is done on the filesystem there will be some, but that
just spreads the cost of the 'balance' across time, it does not
by itself make a «risky, difficult, slow operation» any less so,
just spreads the risk, difficulty, slowness across time.

More generally one of the downsides of Btrfs is that because of
its two-level (allocated/unallocated chunks, used/free nodes or
blocks) design it requires more than most other designs to do
regular 'balance', which is indeed «risky, difficult, slow».

Compare an even more COW design like NILFS2, which requires, but a
bit less, to run its garbage collector, which is also «risky,
difficult, slow». Just like in Btrfs that is a tradeoff that
shrinks the performance envelope in one direction and expands it
in another.

But in the case of Btrfs it shrinks it perhaps a bit more than it
expands it, as the added flexibility of having chunk-based
'profiles' is only very partially taken advantage of.
