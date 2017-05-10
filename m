Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rin.romanrm.net ([91.121.86.59]:45712 "EHLO rin.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752314AbdEJIw5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 May 2017 04:52:57 -0400
Date: Wed, 10 May 2017 13:52:55 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Martin Steigerwald <martin@lichtvoll.de>
Cc: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: runtime btrfsck
Message-ID: <20170510135255.790fbe39@natsu>
In-Reply-To: <1801706.Ls22q1bWhG@merkaba>
References: <9267c96a-72a7-0726-d058-4b2589d7e73e@profihost.ag>
        <f5c610b2-7400-2507-9db2-021b22c0b6d9@profihost.ag>
        <5d86903f-96f8-b61c-16b0-15ba9ac48986@profihost.ag>
        <1801706.Ls22q1bWhG@merkaba>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 10 May 2017 09:48:07 +0200
Martin Steigerwald <martin@lichtvoll.de> wrote:

> Yet, when it comes to btrfs check? Its still quite rudimentary if you ask me.  

Indeed it is. It may or may not be possible to build a perfect Fsck, but IMO
for the time being, what's most sorely missing, is some sort of a knowingly
destructive repair mode, as in "I don't care about partial user data loss,
just whack the FS metadata into full logical consistency at any means
necessary".

Also feels like it doesn't currently deal with the majority of actual
in-real-world corruptions, notably the "parent transid failure" (even by a few
dozens increments) which it can only helpfully "Ignore" during repair.

So even with a minor corruption (something wonky in just ONE block of a
multi-terabyte FS) the answer is way too often "nuke the entire thing and
restore from backups".

-- 
With respect,
Roman
