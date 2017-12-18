Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from azure.uno.uk.net ([95.172.254.11]:43552 "EHLO azure.uno.uk.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758109AbdLRKiT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Dec 2017 05:38:19 -0500
Received: from 82-132-244-111.dab.02.net ([82.132.244.111]:36095 helo=ty.sabi.co.UK)
        by azure.uno.uk.net with esmtpsa (TLSv1.2:DHE-RSA-AES128-SHA:128)
        (Exim 4.89_1)
        (envelope-from <postmaster@root.t00.sabi.co.uk>)
        id 1eQsoL-0004f0-RE
        for linux-btrfs@vger.kernel.org; Mon, 18 Dec 2017 10:38:17 +0000
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
        by ty.sabi.co.UK with esmtps(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)(Exim 4.82 3)
        id 1eQsm9-0002ip-Fo
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Dec 2017 10:36:01 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <23095.39440.745253.138723@tree.ty.sabi.co.uk>
Date: Mon, 18 Dec 2017 10:36:00 +0000
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Unexpected raid1 behaviour
In-Reply-To: <be7e5573-4247-89bd-00f0-7d84120ce582@oracle.com>
References: <5A357909.8010206@yandex.ru>
        <pan$36ed4$200dd538$4324239e$ed0f9f4@cox.net>
        <23094.37316.66397.431081@tree.ty.sabi.co.uk>
        <be7e5573-4247-89bd-00f0-7d84120ce582@oracle.com>
From: pg@btrfs.list.sabi.co.UK (Peter Grandi)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>> I haven't seen that, but I doubt that it is the radical
>> redesign of the multi-device layer of Btrfs that is needed to
>> give it operational semantics similar to those of MD RAID,
>> and that I have vaguely described previously.

> I agree that btrfs volume manager is incomplete in view of
> data center RAS requisites, there are couple of critical
> bugs and inconsistent design between raid profiles, but I
> doubt if it needs a radical redesign.

Well it needs a radical redesign because the original design was
based on an entirely consistent and logical concept that was
quite different from that required for sensible operations, and
then special-case case was added (and keeps being added) to
fix the consequences.

But I suspect that it does not need a radical *recoding*,
because most if not all of the needed code is already there.
All tha needs changing most likely is the member state-machine,
that's the bit that need a radical redesign, and it is a
relatively small part of the whole.

The closer the member state-machine design is to the MD RAID one
the better as it is a very workable, proven model.

Sometimes I suspect that the design needs to be changed to also
add a formal notion of "stripe" to the Btrfs internals, where a
"stripe" is a collection of chunks that are "related" (and
something like that is already part of the 'raid10' profile),
but I think that needs not be user-visible.
