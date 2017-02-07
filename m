Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:59046 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932313AbdBGWI0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Feb 2017 17:08:26 -0500
Subject: Re: BTRFS for OLTP Databases
To: Peter Zaitsev <pz@percona.com>
References: <CA+RUij3aW1ZYyJPNRLzckwOCCmoWa15Eu4h142jB_-qKc49hBw@mail.gmail.com>
 <579c53e4-f993-dd85-b5a4-76a0b201b899@suse.com>
 <CA+RUij2QOP=bJos8p6NswZqSdbhwZ7frTdaLtZaiGBc4vKajCg@mail.gmail.com>
Cc: linux-btrfs@vger.kernel.org
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <03f972ec-67f3-f6f5-c8d7-b281b626a753@mendix.com>
Date: Tue, 7 Feb 2017 23:08:21 +0100
MIME-Version: 1.0
In-Reply-To: <CA+RUij2QOP=bJos8p6NswZqSdbhwZ7frTdaLtZaiGBc4vKajCg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/07/2017 07:59 PM, Peter Zaitsev wrote:
> 
> So far the most frustating for me was periodic stalls for many seconds
>  (running sysbench workload).  What was the most puzzling  I get this
> even if I run workload at the  50% or less of the full load  -  Ie
> database can handle 1000 transactions/sec and I only inject 500/sec
> and I still have those stalls.
> 
> This is where it looks to me like some work is being delayed and when
> it requires stall for a few seconds to catch up.    I wonder  if there
> are some configuration options available to play with.

What happens during these stalls? Do you mean a 'stall' like it seems
nothing is happening at all, or a 'stall' during which something is so
busy that something else cannot continue?

Is there some kernel thread doing a lot of cpu? What does the
/proc/<pid>/stack show?

Is it huge write spikes with not many writes in between, or do you
generate enough action to be writing to disk all the time?

If the stalls show the behaviour of huge disk-write spikes, during which
applications seem to be blocked from continuing to write more, and if
during that time you see btrfs-transaction active in the kernel, aaaand,
if your test is doing a lot of writes all over the place (not only
simply appending table files sequentially, but changing a lot and
touching a lot of metadata) and you're pushing it, it might be space
cache related.

I think the /proc/<pid>/stack of the btrfs-transaction will show you
something related to free space cache in this case.

In this case, it might be interesting to test the free space tree
(instead of the default free space cache):

http://events.linuxfoundation.org/sites/events/files/slides/vault2016_0.pdf

Using free space tree helped me a lot on write-heavy filesystems (like a
backup server with concurrent rsync data streaming in, also doing
snapshotting) from having incoming traffic drop to the ground every time
there was a transaction commit.

-- 
Hans van Kranenburg
