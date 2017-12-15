Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([91.121.75.85]:40080 "EHLO len.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752782AbdLOFeZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Dec 2017 00:34:25 -0500
Date: Fri, 15 Dec 2017 10:34:23 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Ian Kumlien <ian.kumlien@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: [4.14.3] btrfs out of space error
Message-ID: <20171215103423.0fd678a6@natsu>
In-Reply-To: <CAA85sZvo8_39nhyoZP6SGiXTAEi4MCNPDLgqe75LNuUUwQSMqQ@mail.gmail.com>
References: <CAA85sZvo8_39nhyoZP6SGiXTAEi4MCNPDLgqe75LNuUUwQSMqQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 15 Dec 2017 01:39:03 +0100
Ian Kumlien <ian.kumlien@gmail.com> wrote:

> Hi,
> 
> Running a 4.14.3 kernel, this just happened, but there should have
> been another 20 gigs or so available.
> 
> The filesystem seems fine after a reboot though

What are your mount options, and can you show the output of "btrfs fi
df" and "btrfs fi us" for the filesystem? And what does 
"cat /sys/block/sdb/queue/rotational" return.

I wonder if it's the same old "ssd allocation scheme" problem, and no
balancing done in a long time or at all.

-- 
With respect,
Roman
