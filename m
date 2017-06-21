Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from azure.uno.uk.net ([95.172.254.11]:36447 "EHLO azure.uno.uk.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751927AbdFUHb7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Jun 2017 03:31:59 -0400
Received: from ty.sabi.co.uk ([95.172.230.208]:47908)
        by azure.uno.uk.net with esmtpsa (TLSv1.2:DHE-RSA-AES128-SHA:128)
        (Exim 4.89)
        (envelope-from <pg@btrfs.list.sabi.co.uk>)
        id 1dNa7J-003hZn-RO
        for linux-btrfs@vger.kernel.org; Wed, 21 Jun 2017 08:31:57 +0100
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
        by ty.sabi.co.UK with esmtps(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)(Exim 4.82 3)
        id 1dNa7C-0007Fb-7e
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Jun 2017 08:31:50 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <22858.8419.929641.516486@tree.ty.sabi.co.uk>
Date: Wed, 21 Jun 2017 08:31:47 +0100
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Exactly what is wrong with RAID5/6
In-Reply-To: <a88f7896-5693-ad90-383e-a24c61110e8a@rqc.ru>
References: <1f5a4702-d264-51c6-aadd-d2cf521a45eb@dirtcellar.net>
        <20170620232525.GF7140@carfax.org.uk>
        <CAJCQCtSMGjsrZ7N0gWQE744w_au7g1nUMXb1wL2nTa9kgmzYrA@mail.gmail.com>
        <a88f7896-5693-ad90-383e-a24c61110e8a@rqc.ru>
From: pg@btrfs.list.sabi.co.UK (Peter Grandi)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> [ ... ] This will make some filesystems mostly RAID1, negating
> all space savings of RAID5, won't it? [ ... ]

RAID5/RAID6/... don't merely save space, more precisely they
trade lower resilience and a more anisotropic and smaller
performance envelope to gain lower redundancy (= save space).
