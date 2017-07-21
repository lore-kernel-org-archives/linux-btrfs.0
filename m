Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:55654 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753853AbdGUWth (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 Jul 2017 18:49:37 -0400
Subject: Re: kernel btrfs file system wedged -- is it toast?
To: Paul Jackson <pj@usa.net>, David Goodwin <david@codepoets.co.uk>,
        linux-btrfs@vger.kernel.org
References: <1500576442.3508802.1047392992.202A4606@webmail.messagingengine.com>
 <3dd83854-362d-001a-e075-2156931a5cc2@mendix.com>
 <1500593465.333509.1047657672.4D69CB55@webmail.messagingengine.com>
 <1500617212.422990.1047894640.3B975261@webmail.messagingengine.com>
 <6f8c41cc-39a0-270e-0b8b-5debbdf455c9@codepoets.co.uk>
 <1500663236.2611541.1048467944.0014B72B@webmail.messagingengine.com>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <98d34892-2ed9-8f84-2c02-024209b2ccdf@mendix.com>
Date: Sat, 22 Jul 2017 00:49:33 +0200
MIME-Version: 1.0
In-Reply-To: <1500663236.2611541.1048467944.0014B72B@webmail.messagingengine.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hey,

On 07/21/2017 08:53 PM, Paul Jackson wrote:
> 
> My btrfs file system, after doing a "mount -oclear_cache", followed
> by a "mount -ospace_cache", eleven hours ago now, is still hung.
> 
> David Goodwin suggested:
>>> 'perf top' is my first thought.... it might at least highlight the area 
>>> gobbling up cpu time.
> 
> Thanks for suggesting that. It has been a long time since I've done
> any kernel work, and I didn't know of (or had forgotten about)
> perf-tools.   I just now installed these perf tools, and perf-top shows
> this btrfs activity on the system stil trying to handle the above
> "mount -ospace_cache":
> 
> +   78.00%    78.00%  [btrfs]                      [k] btrfs_merge_delayed_refs
> +   38.56%     0.00%  [btrfs]                      [k] transaction_kthread
> +   38.56%     0.00%  [btrfs]                      [k] btrfs_commit_transaction
> +   38.56%     0.00%  [btrfs]                      [k] btrfs_start_dirty_block_groups
> +   38.56%     0.00%  [btrfs]                      [k] btrfs_run_delayed_refs
> +   38.56%     0.00%  [btrfs]                      [k] __btrfs_run_delayed_refs
> 
> Regarding the time to balance - yes I too have many  snapshots,
> perhaps 100's to over a 1000 snapshots on each of a half dozen
> subvolumes, with major sharing within the subvolumes.
> 
> Graham Cobb wrote:
>>>  If I understand correctly, this is because btrfs does not have
>>> an efficient structure to help find all the references 
> 
> Yeah this feels like  an Order n^2 or n^3 algorithm, or worse,  in
> the wrong place(s).
> 
> If this conclusion  is anywhere close to acccurate, then I would
> STRONGLY encourage the key developers of btrfs to announce [...]

Well, there it is:

https://btrfs.wiki.kernel.org/index.php/Gotchas#Having_many_subvolumes_can_be_very_slow

It says that having "subvolumes with more than a dozen snapshots" (a
dozen is 12) starts bringing you into areas where some things might not
be optimized yet. So your "100's to over a 1000 snapshots" falls well
outside of the recommended documented limits.

> Would you buy a car with an "unusual" engine that, whenever
> it [...rant...]

Be aware that the attitude displayed in your ramblings is not helping
the situation. Reading them does not likely encourage other people to
spend their spare time to start explaining more things to you and
helping you to overcome issues. Things are not going to improve by
shouting at them. Other people are scared away instead.

What you got (the btrfs program code) is something other people have
been working on for hours, days or years, and they provide it to you
with the possibility to use it for free. But, it also comes with a big
disclaimer, which says, quoting the GPL-2... that what you get is "THE
PROGRAM "AS IS" WITHOUT WARRANTY OF ANY KIND" and it even says that
there is no guarantee at all that it has any "FITNESS FOR A PARTICULAR
PURPOSE".

So the analogy, when you are at the car dealer is more like: "Yes, you
can buy this car, it has security certifications, bla bla tested bla bla
guarantee, but, you can also get this other model for free. If you take
the free model, we cannot give you any guarantee that it will work, set
itself on fire while locking all doors, kill you and your family within
a day or do anything else you wouldn't suspect. And if it does, you
cannot sue us."

Have fun,

-- 
Hans van Kranenburg
