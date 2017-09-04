Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from azure.uno.uk.net ([95.172.254.11]:33368 "EHLO azure.uno.uk.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753474AbdIDLny (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 4 Sep 2017 07:43:54 -0400
Received: from ty.sabi.co.uk ([95.172.230.208]:37156)
        by azure.uno.uk.net with esmtpsa (TLSv1.2:DHE-RSA-AES128-SHA:128)
        (Exim 4.89)
        (envelope-from <postmaster@root.t00.sabi.co.uk>)
        id 1dopnE-0005xA-JA
        for linux-btrfs@vger.kernel.org; Mon, 04 Sep 2017 12:43:52 +0100
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
        by ty.sabi.co.UK with esmtps(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)(Exim 4.82 3)
        id 1dopn3-00069R-La
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Sep 2017 12:43:41 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <22957.15468.827250.540465@tree.ty.sabi.co.uk>
Date: Mon, 4 Sep 2017 12:43:40 +0100
To: linux-btrfs@vger.kernel.org
Subject: Re: speed up big btrfs volumes with ssds
In-Reply-To: <CAPmG0jaJFUpgAbtzNO2jnqbN7u7q6RM4T_BPw_hwhx2wS+Fnhg@mail.gmail.com>
References: <7318d2b7-73a0-1cc9-f9cc-e03314c19e85@profihost.ag>
        <CAPmG0jaJFUpgAbtzNO2jnqbN7u7q6RM4T_BPw_hwhx2wS+Fnhg@mail.gmail.com>
From: pg@btrfs.list.sabi.co.UK (Peter Grandi)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>> [ ... ] Currently the write speed is not as good as i would
>> like - especially for random 8k-16k I/O. [ ... ]

> [ ... ] So this 60TB is then 20 4TB disks or so and the 4x 1GB
> cache is simply not very helpful I think. The working set
> doesn't fit in it I guess. If there is mostly single or a few
> users of the fs, a single pcie based bcacheing 4 devices can
> work, but for SATA SSD, I would use 1 SSD per HWraid5. [ ... ]

Probably the idea of the cacheable working set of a random small
write workload is a major new scientific discovery. :-)
