Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from azure.uno.uk.net ([95.172.254.11]:54557 "EHLO azure.uno.uk.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751173AbdCQNvp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Mar 2017 09:51:45 -0400
Received: from ty.sabi.co.uk ([95.172.230.208]:50946)
        by azure.uno.uk.net with esmtpsa (TLSv1.2:DHE-RSA-AES128-SHA:128)
        (Exim 4.88)
        (envelope-from <pg@btrfs.list.sabi.co.uk>)
        id 1cosIA-002j9x-71
        for linux-btrfs@vger.kernel.org; Fri, 17 Mar 2017 13:51:42 +0000
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
        by ty.sabi.co.UK with esmtps(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)(Exim 4.82 3)
        id 1cosI3-0002op-2J
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Mar 2017 13:51:35 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <22731.59878.724789.333618@tree.ty.sabi.co.uk>
Date: Fri, 17 Mar 2017 13:51:34 +0000
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: BTRFS Metadata Corruption Prevents Scrub and btrfs check
In-Reply-To: <CAAafysHAZ_1-4rTqsY4cw0rkBgq3f_F29nM+=XsDEhNvR8CkJQ@mail.gmail.com>
References: <CAAafysHAZ_1-4rTqsY4cw0rkBgq3f_F29nM+=XsDEhNvR8CkJQ@mail.gmail.com>
From: pg@btrfs.list.sabi.co.UK (Peter Grandi)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> Read error at byte 0, while reading 3975 bytes: Input/output error

Bad news. That means that probably the disk is damaged and
further issues may happen.

>         corrected errors: 0, uncorrectable errors: 2, unverified errors: 0

Even worse news.

> Incorrect local backref count on 5165855678464 root 259 owner 1732872
> offset 0 found 0 wanted 1 back 0x3ba80f40
> Backref disk bytenr does not match extent record,
> bytenr=5165855678464, ref bytenr=7880454922968236032
> backpointer mismatch on [5165855678464 28672]

"Better" news. In practice a single metadata leaf node is
corrupted in back references. You might be lucky and that might
be rebuildable, but I don't know enough about the somewhat
intricate Btrfs metadata trees to figure that out. Some metadata
is rebuildable from other metadata with a tree scan, some not.

In general metadata in Btrfs is fairly intricate and metadata
block loss is pretty fatal, that's why metadata should most
times be redundant as in 'dup' or 'raid1' or similar:

http://www.sabi.co.uk/blog/16-two.html?160817#160817
