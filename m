Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:59471 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750849AbdGUGGx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 Jul 2017 02:06:53 -0400
Message-Id: <1500617212.422990.1047894640.3B975261@webmail.messagingengine.com>
From: Paul Jackson <pj@usa.net>
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        linux-btrfs@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Date: Fri, 21 Jul 2017 01:06:52 -0500
Subject: Re: kernel btrfs file system wedged -- is it toast?
In-Reply-To: <1500593465.333509.1047657672.4D69CB55@webmail.messagingengine.com>
References: <1500576442.3508802.1047392992.202A4606@webmail.messagingengine.com>
 <3dd83854-362d-001a-e075-2156931a5cc2@mendix.com>
 <1500593465.333509.1047657672.4D69CB55@webmail.messagingengine.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Regarding CPU vs disk hanging ... fifteen minutes ago, after
doing a "mount -oclear_cache", then a "mount -ospace_cache",
to clear some space cache errors reported by btrfs check,
I changed a shell's working directory into the top directory
of the freshly remounted btrfs file system, and then entered
"cd dir\t", where that tab was the completion character for
my shell.

That shell is still hung in the kernel, on a "disk sleep" fifteen
minutes later, and one of my CPU cores is pegged at 100%,
and the disk activity light is not coming on at all.

Apparently the way that btrfs gets all those nice features is
by placing a lower priority on fast, reliable, responsive,
robust, multi-tasking and on rock solid data integrity under
all manner of simultaneous operations.

What in god green's earth can kernel file system code be
doing that takes fifteen minutes (so far, in this case) or
fifty minutes (in the case I first reported on this thread?

This is not disk bound activity ... it's kernel code bound.

That's insane ... and sad.

-- 
                Paul Jackson
                pj@usa.net
