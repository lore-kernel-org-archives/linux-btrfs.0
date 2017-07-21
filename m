Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.palepurple.co.uk ([89.16.183.188]:50678 "EHLO
        mail.palepurple.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751709AbdGUHRi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 Jul 2017 03:17:38 -0400
Subject: Re: kernel btrfs file system wedged -- is it toast?
To: linux-btrfs@vger.kernel.org
References: <1500576442.3508802.1047392992.202A4606@webmail.messagingengine.com>
 <3dd83854-362d-001a-e075-2156931a5cc2@mendix.com>
 <1500593465.333509.1047657672.4D69CB55@webmail.messagingengine.com>
 <1500617212.422990.1047894640.3B975261@webmail.messagingengine.com>
From: David Goodwin <david@codepoets.co.uk>
Cc: Paul Jackson <pj@usa.net>
Message-ID: <6f8c41cc-39a0-270e-0b8b-5debbdf455c9@codepoets.co.uk>
Date: Fri, 21 Jul 2017 08:09:31 +0100
MIME-Version: 1.0
In-Reply-To: <1500617212.422990.1047894640.3B975261@webmail.messagingengine.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

....
> That shell is still hung in the kernel, on a "disk sleep" fifteen
> minutes later, and one of my CPU cores is pegged at 100%,
> and the disk activity light is not coming on at all.
>
> ......
> This is not disk bound activity ... it's kernel code bound.
>
> That's insane ... and sad.
>
'perf top' is my first thought.... it might at least highlight the area 
gobbling up cpu time.

I regularly see a limited balance (btrfs balance -musage=30 -dusage=30 
or something like that) take 3-4 days on a m3.medium (1 core) or 
m3.large (2 core?) EC2 VM with a 1Tb filesystem.

I see plenty of the 'hung kernel timeout' messages within dmesg (like 
your first post) but it eventually recovers and behaves.

About once every 6-9 months the filesystem will break on one of the 
single core VMs, and I'll end up wiping / starting again..... on a dual 
core VM it's run without issue and behaved much better.

(It's an 'offsite backup-backup server'. I tend to use one of the latest 
stable kernels - e.g. 4.9 at the moment).

David

