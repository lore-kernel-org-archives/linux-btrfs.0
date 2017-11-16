Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail02.iobjects.de ([188.40.134.68]:33026 "EHLO
        mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933840AbdKPWcf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 16 Nov 2017 17:32:35 -0500
Subject: Re: 4.13.12: kernel BUG at fs/btrfs/ctree.h:1802!
To: Marc MERLIN <marc@merlins.org>
Cc: linux-btrfs@vger.kernel.org
References: <20171116170445.24n57phzltgiehj6@merlins.org>
 <20171116170742.vyhxckxrgjzwqyvf@merlins.org>
 <70b25128-d724-4e8e-9835-4a092cf8d5a6@applied-asynchrony.com>
 <20171116214551.vpp4eevs7b4bszjt@merlins.org>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Message-ID: <2b97e49b-74fd-77c1-a340-8254f8999bb1@applied-asynchrony.com>
Date: Thu, 16 Nov 2017 23:32:33 +0100
MIME-Version: 1.0
In-Reply-To: <20171116214551.vpp4eevs7b4bszjt@merlins.org>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/16/17 22:45, Marc MERLIN wrote:
(snip)
>> This BUG() was recently removed and seems to be caused by some kind
>> of persistent corruption, which is seen as invalid inline extent.
>> See [1], [2] for details. Maybe you can backport them?
>> Alternatively just give 4.14 a whirl, it's great.
>>
>> -h
>>
>> [1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=167ce953ca55bdee20fe56c3c0fa51002435f745
>> [2] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=4335958de2a43c6790c7f6aa0682aa7189983fa4
> 
> First thanks a lot for the quick reply, it was super timely considering
> my server was rebooting every 20mn :)
> I've now been running 4.14 for a couple of hours, and things seem ok
> btrfs-wise.

Don't pop the champagne just yet, I just read that apprently 4.14 broke
bcache for some people [1]. Not sure how much that affects you, but it might
well make things worse. Yeah, I know, wonderful.

> So, just so that I understand:
> 1) I do have some kind of FS problem/corruption (minor? major?)

All I know is what's in those commits, I just remembered the description. ;)
If I understand the patches correctly you're still supposed to get an
"invalid extent inline ref type" message.

> 2) it started crashing 4.9.36 and then 4.13 today, every 20mn, probably due to some background
> cleaner process that kept starting and hitting the problem spot

Sounds like.

> 3) 4.14 does not crash anymore, but it doesn't even report any problem either. Does it mean
> the error that crashed the old kernel is minor enough that the new kernel doesn't bother even
> logging it?

See above, you should still get a warning. OTOH it's hard to tell what is
going on when you seem to have dm/dmcrypt/bcache lasagne going on..

> 4) I just ran scrub on the filesystem and it ran fine.

That's not too depressing. :)

> I'm asusming that running btrfs check --force on a mounted filesystem
> that is being used is not going to give useful results, unless I leave
> the FS read only. Correct?

Think so, yes.

> As for 4.14, the serial console code seems broken though, I can't get login or bash
> to work anymore on them:
> [ 2786.305004] INFO: task login:5636 blocked for more than 120 seconds.
> [ 2786.324648]       Tainted: G     U  W       4.14.0-amd64-stkreg-sysrq-20171018 #1
> [ 2786.347692] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [ 2786.371742] login           D    0  5636      1 0xa0020006

I'm out. :/

-h

[1] https://marc.info/?t=151082126000001
