Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:42779 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750933AbcLRX1c (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 18 Dec 2016 18:27:32 -0500
Received: from [IPv6:2001:980:4a41:fb::12] (unknown [IPv6:2001:980:4a41:fb::12])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by syrinx.knorrie.org (Postfix) with ESMTPSA id 0C15D6002F
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Dec 2016 00:27:26 +0100 (CET)
To: linux-btrfs@vger.kernel.org
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Subject: python-btrfs v4, yay
Message-ID: <1d9ac517-8723-8e60-2478-718ee544b3ea@mendix.com>
Date: Mon, 19 Dec 2016 00:27:25 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I just tagged v4 of the python btrfs library.

https://github.com/knorrie/python-btrfs

>From CHANGES:

python-btfs v4, Dec 18 2016
  * Bump/inverse versioning, there will never be a v1.0, just keep
    developing and releasing. \:D/
  * IOCTLs: LOGICAL_INO
  * New datastructures: InodeItem, RootItem, DiskKey, TimeSpec
  * Add all constants to pretty print tree keys
  * Behaviour change: don't load extent refs by default
  * Keep transid value when retrieving a BlockGroupItem
  * Known issue:
    - SHARED_BLOCK_REF and TREE_BLOCK_REF are missing in extent refs

Actually, there's another known issue, (except for the typo in btrfs
above...) which I just forgot to mention there:

 * the IOCTL number handling only works correctly for amd64 now

As usual, there is a huge amount of information in commit messages,
which explains all the what why and hows of each change or added
feature. So, you're invited to browse the commits and get news ideas
about exploring the internals of your btrfs file system.

Writing tutorial-style documentation is planned later, so for now the
source code, together with the contents of examples/ which shows a few
simple ideas of what can be done is the documentation.

Have fun,

-- 
Hans van Kranenburg
