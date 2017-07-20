Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:34251 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S935389AbdGTXbG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 20 Jul 2017 19:31:06 -0400
Message-Id: <1500593465.333509.1047657672.4D69CB55@webmail.messagingengine.com>
From: Paul Jackson <pj@usa.net>
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        linux-btrfs@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Subject: Re: kernel btrfs file system wedged -- is it toast?
Date: Thu, 20 Jul 2017 18:31:05 -0500
References: <1500576442.3508802.1047392992.202A4606@webmail.messagingengine.com>
 <3dd83854-362d-001a-e075-2156931a5cc2@mendix.com>
In-Reply-To: <3dd83854-362d-001a-e075-2156931a5cc2@mendix.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Thanks for you thoughtful answer, Hans.

>> what was the reason for using balance?

I had filled up that 8TB btrfs file system a couple of days ago,
which made me worry about it,  and do what things I thought
might ensure it was healthy again (after I removed a bunch
of stuff.)    I am not using RAID or any of the obvious reasons
to rebalance, but was guessing that the removals had left
lots of "blocks" (whatever  btrfs calls its chunks of data) half
full, so the rebalance was one of the operations I superstitiously
included in my "spring housecleaning"

>>  100% cpu? or a lot of disk reads and writes?

The disk light was off ...which is what I first noticed.  So I don't
think it was disk bound during that 50 minutes.

I did not look at CPU usage during that 50 minutes, and was
not doing anything else that needed much CPU, so would not
have known if one or two CPU cores were busy, or not.  I had
been assuming, without checking, that these kernel threads
were deadlocked, and would be so until reboot.  Apparently
that wasn't so, and one of them was busy doing something.

I already systematically use user level locking to
keep myself or my cron jobs from doing multiple things
at once to any given btrfs file system.  Looks like I need
to apply that locking to my balance/scrub/... jobs as well.

===

Two more, perhaps the last two, questions:

What could possibly take 50 minutes of kernel thread blocking
CPU time (since this wasn't disk bound, as best I know) in this
workload?

What are the "good things to do" to a btrfs file system that
has been filled up, after removing some stuff, of course?

Thanks!

-- 
                Paul Jackson
                pj@usa.net
