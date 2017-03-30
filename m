Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:38538 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932294AbdC3XBa (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Mar 2017 19:01:30 -0400
Received: from [IPv6:2001:980:4a41:fb::12] (unknown [IPv6:2001:980:4a41:fb::12])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by syrinx.knorrie.org (Postfix) with ESMTPSA id 8B88560012
        for <linux-btrfs@vger.kernel.org>; Fri, 31 Mar 2017 01:01:28 +0200 (CEST)
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Subject: Cosmetics bug: remounting ssd does not clear nossd
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <0939c5df-3abd-ec68-16ef-538ad04251aa@mendix.com>
Date: Fri, 31 Mar 2017 01:01:28 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If I have a filesystem that shows this...

rw,relatime,ssd,space_cache=v2,subvolid=5,subvol=/

...and then I do this...

-# mount -o remount,nossd /mnt/btrfs/

...then it shows...

rw,relatime,nossd,space_cache=v2,subvolid=5,subvol=/

...but when I do this...

-# mount -o remount,ssd /mnt/btrfs/

...it ends up with a rotational identity crisis:

rw,relatime,nossd,ssd,space_cache=v2,subvolid=5,subvol=/
            ^^^^^ ^^^

The only thing the nossd option does when mounting first time is
preventing that ssd gets enabled automatically. When doing nossd with
remount, it clears out the ssd flag, but telling it to ssd again does
not clear the nossd flag.

The actual kernel code which changes behaviour based on these options
only ever checks for SSD, never for NOSSD.

So, the situation does not lead to any wrong behaviour right now, but
it's confusing, and it could be a source of bugs in the future, when
anything would test for NOSSD explicitely and make a decision based on
the result.

Moo,
-- 
Hans van Kranenburg
