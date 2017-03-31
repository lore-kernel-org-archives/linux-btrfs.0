Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from azure.uno.uk.net ([95.172.254.11]:51519 "EHLO azure.uno.uk.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751032AbdCaLhR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 31 Mar 2017 07:37:17 -0400
Received: from ty.sabi.co.uk ([95.172.230.208]:57230)
        by azure.uno.uk.net with esmtpsa (TLSv1.2:DHE-RSA-AES128-SHA:128)
        (Exim 4.88)
        (envelope-from <pg@btrfs.list.to.sabi.co.uk>)
        id 1cturi-0039cv-Lw
        for linux-btrfs@vger.kernel.org; Fri, 31 Mar 2017 12:37:14 +0100
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
        by ty.sabi.co.UK with esmtps(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)(Exim 4.82 3)
        id 1ctu9U-0006Fl-9f
        for <linux-btrfs@vger.kernel.org>; Fri, 31 Mar 2017 11:51:32 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-ID: <22750.13491.844068.867462@tree.ty.sabi.co.uk>
Date: Fri, 31 Mar 2017 11:51:31 +0100
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Shrinking a device - performance?
In-Reply-To: <67132222-17c3-b198-70c1-c3ae0c1cb8e7@siedziba.pl>
References: <1CCB3887-A88C-41C1-A8EA-514146828A42@flyingcircus.io>
        <20170327130730.GN11714@carfax.org.uk>
        <3558CE2F-0B8F-437B-966C-11C1392B81F2@flyingcircus.io>
        <20170327194847.5c0c5545@natsu>
        <4E13254F-FDE8-47F7-A495-53BFED814C81@flyingcircus.io>
        <22746.30348.324000.636753@tree.ty.sabi.co.uk>
        <b0f6b00e-4c70-72d1-8683-c05bb72a0968@siedziba.pl>
        <22749.11946.474065.536986@tree.ty.sabi.co.uk>
        <67132222-17c3-b198-70c1-c3ae0c1cb8e7@siedziba.pl>
From: pg@btrfs.list.to.sabi.co.UK (Peter Grandi)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>>> The way btrfs is designed I'd actually expect shrinking to
>>> be fast in most cases. [ ... ]

>> The proposed "move whole chunks" implementation helps only if
>> there are enough unallocated chunks "below the line". If regular
>> 'balance' is done on the filesystem there will be some, but that
>> just spreads the cost of the 'balance' across time, it does not
>> by itself make a «risky, difficult, slow operation» any less so,
>> just spreads the risk, difficulty, slowness across time.

> Isn't that too pessimistic?

Maybe, it depends on the workload impacting the volume and how
much it churns the free/unallocated situation.

> Most of my filesystems have 90+% of free space unallocated,
> even those I never run balance on.

That seems quite lucky to me, as definitely is not my experience
or even my expectation in the general case: in my laptop and
desktop with relatively few updates I have to run 'balance'
fairly frequently, and "Knorrie" has produced a nice tools that
produces a graphical map of free vs. unallocated space and most
examples and users find quite a bit of balancing needs to be
done

> For me it wouldn't just spread the cost, it would reduce it
> considerably.

In your case the cost of the implicit or explicit 'balance'
simply does not arise because 'balance' is not necessary, and
then moving whole chunks is indeed cheap. The argument here is
in part whether used space (extents) or allocated space (chunks)
is more fragmented as well as the amount of metadata to update
in either case.
