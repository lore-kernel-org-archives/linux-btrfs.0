Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:50067 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752780AbdGUWA1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 Jul 2017 18:00:27 -0400
Date: Sat, 22 Jul 2017 00:00:05 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>,
        Christoph Anton Mitterer <calestyo@scientia.net>,
        Nikolay Borisov <nborisov@suse.com>, kernel-team@fb.com,
        stable@vger.kernel.org
Subject: Re: [PATCH RESEND] Btrfs: fix early ENOSPC due to delalloc
Message-ID: <20170721220005.idoz25yegjo5sgbb@angband.pl>
References: <33ac56aa74691de6109709168939cfe9f56cbd70.1500588286.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <33ac56aa74691de6109709168939cfe9f56cbd70.1500588286.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 20, 2017 at 03:10:35PM -0700, Omar Sandoval wrote:
> If a lot of metadata is reserved for outstanding delayed allocations, we
> rely on shrink_delalloc() to reclaim metadata space in order to fulfill
> reservation tickets. However, shrink_delalloc() has a shortcut where if
> it determines that space can be overcommitted, it will stop early. This
> made sense before the ticketed enospc system, but now it means that
> shrink_delalloc() will often not reclaim enough space to fulfill any
> tickets, leading to an early ENOSPC.

This happens a lot (like, 1/4 to 1/3 tries) when populating a freshly made
small filesystem, that makes running tests I've been recently doing (like
those degraded raid corruptions) really unfun.  These unexplained random
ENOSPCes were driving me mad — thanks for explaining those!  Now my tests
properly corrupt data as they should :þ.

-- 
⢀⣴⠾⠻⢶⣦⠀ 
⣾⠁⢠⠒⠀⣿⡁ A dumb species has no way to open a tuna can.
⢿⡄⠘⠷⠚⠋⠀ A smart species invents a can opener.
⠈⠳⣄⠀⠀⠀⠀ A master species delegates.
