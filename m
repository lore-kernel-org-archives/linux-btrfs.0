Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from azure.uno.uk.net ([95.172.254.11]:45814 "EHLO azure.uno.uk.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933780AbdC3QN5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Mar 2017 12:13:57 -0400
Received: from ty.sabi.co.uk ([95.172.230.208]:58344)
        by azure.uno.uk.net with esmtpsa (TLSv1.2:DHE-RSA-AES128-SHA:128)
        (Exim 4.88)
        (envelope-from <pg@btrfs.list.sabi.co.uk>)
        id 1ctchv-001Mrf-5Z
        for linux-btrfs@vger.kernel.org; Thu, 30 Mar 2017 17:13:55 +0100
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
        by ty.sabi.co.UK with esmtps(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)(Exim 4.82 3)
        id 1ctcQY-0007JK-3i
        for <linux-btrfs@vger.kernel.org>; Thu, 30 Mar 2017 16:55:58 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <22749.10893.729399.275210@tree.ty.sabi.co.uk>
Date: Thu, 30 Mar 2017 16:55:57 +0100
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Shrinking a device - performance?
In-Reply-To: <43e29da2-1d1b-1680-f262-1c95575645d8@gmail.com>
References: <1CCB3887-A88C-41C1-A8EA-514146828A42@flyingcircus.io>
        <20170327130730.GN11714@carfax.org.uk>
        <3558CE2F-0B8F-437B-966C-11C1392B81F2@flyingcircus.io>
        <20170327194847.5c0c5545@natsu>
        <4E13254F-FDE8-47F7-A495-53BFED814C81@flyingcircus.io>
        <22746.30348.324000.636753@tree.ty.sabi.co.uk>
        <43e29da2-1d1b-1680-f262-1c95575645d8@gmail.com>
From: pg@btrfs.list.sabi.co.UK (Peter Grandi)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>> My guess is that very complex risky slow operations like that are
>> provided by "clever" filesystem developers for "marketing" purposes,
>> to win box-ticking competitions. That applies to those system
>> developers who do know better; I suspect that even some filesystem
>> developers are "optimistic" as to what they can actually achieve.

> There are cases where there really is no other sane option. Not
> everyone has the kind of budget needed for proper HA setups,

Thnaks for letting me know, that must have never occurred to me, just as
it must have never occurred to me that some people expect extremely
advanced features that imply big-budget high-IOPS high-reliability
storage to be fast and reliable on small-budget storage too :-)

> and if you need maximal uptime and as a result have to reprovision the
> system online, then you pretty much need a filesystem that supports
> online shrinking.

That's a bigger topic than we can address here. The topic used to be
known in one related domain as "Very Large Databases", which were
defined as databases so large and critical that they the time needed for
maintenance and backup were too slow for taking them them offline etc.;
that is a topics that has largely vanished for discussion, I guess
because most management just don't want to hear it :-).

> Also, it's not really all that slow on most filesystem, BTRFS is just
> hurt by it's comparatively poor performance, and the COW metadata
> updates that are needed.

Btrfs in realistic situations has pretty good speed *and* performance,
and COW actually helps, as it often results in less head repositioning
than update-in-place. What makes it a bit slower with metadata is having
'dup' by default to recover from especially damaging bitflips in
metadata, but then that does not impact performance, only speed.

>> That feature set is arguably not appropriate for VM images, but
>> lots of people know better :-).

> That depends on a lot of factors.  I have no issues personally running
> small VM images on BTRFS, but I'm also running on decent SSD's
> (>500MB/s read and write speeds), using sparse files, and keeping on
> top of managing them. [ ... ]

Having (relatively) big-budget high-IOPS storage for high-IOPS workloads
helps, that must have never occurred to me either :-).

>> XFS and 'ext4' are essentially equivalent, except for the fixed-size
>> inode table limitation of 'ext4' (and XFS reportedly has finer
>> grained locking). Btrfs is nearly as good as either on most workloads
>> is single-device mode [ ... ]

> No, if you look at actual data, [ ... ]

Well, I have looked at actual data in many published but often poorly
made "benchmarks", and to me they seem they seem quite equivalent
indeed, within somewhat differently shaped performance envelopes, so the
results depend on the testing point within that envelope. I have been
done my own simplistic actual data gathering, most recently here:

  http://www.sabi.co.uk/blog/17-one.html?170302#170302
  http://www.sabi.co.uk/blog/17-one.html?170228#170228

and however simplistic they are fairly informative (and for writes they
point a finger at a layer below the filesystem type).

[ ... ]

>> "Flexibility" in filesystems, especially on rotating disk
>> storage with extremely anisotropic performance envelopes, is
>> very expensive, but of course lots of people know better :-).

> Time is not free,

Your time seems especially and uniquely precious as you "waste"
as little as possible editing your replies into readability.

> and humans generally prefer to minimize the amount of time they have
> to work on things. This is why ZFS is so popular, it handles most
> errors correctly by itself and usually requires very little human
> intervention for maintenance.

That seems to me a pretty illusion, as it does not contain any magical
AI, just pretty ordinary and limited error correction for trivial cases.

> 'Flexibility' in a filesystem costs some time on a regular basis, but
> can save a huge amount of time in the long run.

Like everything else. The difficulty is having flexibility at scale with
challenging workloads. "An engineer can do  for a nickel what  any damn
fool can do for a dollar" :-).

> To look at it another way, I have a home server system running BTRFS
> on top of LVM. [ ... ]

But usually home servers have "unchallenging" workloads, and it is
relatively easy to overbudget their storage, because the total absolute
cost is "affordable".
