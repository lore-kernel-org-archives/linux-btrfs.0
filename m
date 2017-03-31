Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from azure.uno.uk.net ([95.172.254.11]:51835 "EHLO azure.uno.uk.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932927AbdCaMhd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 31 Mar 2017 08:37:33 -0400
Received: from ty.sabi.co.uk ([95.172.230.208]:57492)
        by azure.uno.uk.net with esmtpsa (TLSv1.2:DHE-RSA-AES128-SHA:128)
        (Exim 4.88)
        (envelope-from <pg@btrfs.list.sabi.co.uk>)
        id 1ctvo2-003Fn8-6Y
        for linux-btrfs@vger.kernel.org; Fri, 31 Mar 2017 13:37:30 +0100
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
        by ty.sabi.co.UK with esmtps(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)(Exim 4.82 3)
        id 1ctvnw-0006s1-DJ
        for <linux-btrfs@vger.kernel.org>; Fri, 31 Mar 2017 13:37:24 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <22750.19844.32252.497948@tree.ty.sabi.co.uk>
Date: Fri, 31 Mar 2017 13:37:24 +0100
To: linux-btrfs@vger.kernel.org
Subject: Re: Shrinking a device - performance?
In-Reply-To: <pan$76dc7$170a959f$9df83808$fddf3918@cox.net>
References: <1CCB3887-A88C-41C1-A8EA-514146828A42@flyingcircus.io>
        <20170327130730.GN11714@carfax.org.uk>
        <3558CE2F-0B8F-437B-966C-11C1392B81F2@flyingcircus.io>
        <20170327194847.5c0c5545@natsu>
        <4E13254F-FDE8-47F7-A495-53BFED814C81@flyingcircus.io>
        <22746.30348.324000.636753@tree.ty.sabi.co.uk>
        <b0f6b00e-4c70-72d1-8683-c05bb72a0968@siedziba.pl>
        <22749.11946.474065.536986@tree.ty.sabi.co.uk>
        <67132222-17c3-b198-70c1-c3ae0c1cb8e7@siedziba.pl>
        <CAP8EXU2ufgLWL+kgKtaLjqHDBGV1OB8GWy+efCJf4Knb0DaEPQ@mail.gmail.com>
        <pan$5c23$ddaeadec$128532fd$8595ddc4@cox.net>
        <pan$76dc7$170a959f$9df83808$fddf3918@cox.net>
From: pg@btrfs.list.sabi.co.UK (Peter Grandi)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>> [ ... ] CentOS, Redhat, and Oracle seem to take the position
>> that very large data subvolumes using btrfs should work
>> fine. But I would be curious what the rest of the list thinks
>> about 20 TiB in one volume/subvolume.

> To be sure I'm a biased voice here, as I have multiple
> independent btrfs on multiple partitions here, with no btrfs
> over 100 GiB in size, and that's on ssd so maintenance
> commands normally return in minutes or even seconds,

That's a bit extreme I think, as there are downsides to have
many too small volumes too.

> not the hours to days or even weeks it takes on multi-TB btrfs
> on spinning rust.

Or months :-).

> But FWIW... 1) Don't put all your data eggs in one basket,
> especially when that basket isn't yet entirely stable and
> mature.

Really good point here.

> A mantra commonly repeated on this list is that btrfs is still
> stabilizing,

My impression is that most 4.x and later versions are very
reliable for "base" functionality, that is excluding
multi-device, compression, qgroups, ... Put another way, what
scratches the Facebook itches works well :-).

> [ ... ] the time/cost/hassle-factor of the backup, and being
> practically prepared to use them, is even *MORE* important
> than it is on fully mature and stable filesystems.

Indeed, or at least *different* filesystems. I backup JFS
filesystems to XFS ones, and Btrfs filesystems to NILFS2 ones,
for example.

> 2) Don't make your filesystems so large that any maintenance
> on them, including both filesystem maintenance like btrfs
> balance/scrub/check/ whatever, and normal backup and restore
> operations, takes impractically long,

As per my preceding post, that's the big deal, but so many
people "know better" :-).

> where "impractically" can be reasonably defined as so long it
> discourages you from doing them in the first place and/or so
> long that it's going to cause unwarranted downtime.

That's the "Very Large DataBase" level of trouble.

> Some years ago, before I started using btrfs and while I was
> using mdraid, I learned this one the hard way. I had a bunch
> of rather large mdraids setup, [ ... ]

I have recently seen another much "funnier" example: people who
"know better" and follow every cool trend decide to consolidate
their server farm on VMs, backed by a storage server with a
largish single pool of storage holding the virtual disk images
of all the server VMs. They look like geniuses until the storage
pool system crashes, and a minimal integrity check on restart
takes two days during which the whole organization is without
access to any email, files, databases, ...

> [ ... ] And there was a good chance it was /not/ active and
> mounted at the time of the crash and thus didn't need
> repaired, saving that time entirely! =:^)

As to that I have switched to using 'autofs' to mount volumes
only on access, using a simple script that turns '/etc/fstab'
into an automounter dynamic map, which means that most of the
time most volumes on my (home) systems are not mounted:

  http://www.sabi.co.uk/blog/anno06-3rd.html?060928#060928

> Eventually I arranged things so I could keep root mounted
> read-only unless I was updating it, and that's still the way I
> run it today.

The ancient way, instead of having '/' RO and '/var' RW, to have
'/' RW and '/usr' RO (so for example it could be shared across
many systems via NFS etc.), and while both are good ideas, I
prefer the ancient way. But then some people who know better are
moving to merge '/' with '/usr' without understanding what's the
history and the advantages.

> [ ... ] If it's multiple TBs, chances are it's going to be
> faster to simply blow away and recreate from backup, than it
> is to try to repair... [ ... ]

Or to shrink or defragment or dedup etc., except on very high
IOPS-per-TB storage.

> [ ... ] how much simpler it would have been had they had an
> independent btrfs of say a TB or two for each system they were
> backing up.

That is the general alternative to a single large pool/volume:
sharding/chunking of filetrees, sometimes, like with Lustre or
Ceph etc. with a "metafilesystem" layer on top.

Done manually my suggestion is to do the sharding per-week (or
other suitable period) rather than per-system, in a circular
"crop rotation" scheme. So that once a volume has been filled,
it becomes read-only and can even be unmounted until it needs
to be reused:

  http://www.sabi.co.uk/blog/12-fou.html?121218b#121218b

Then there is the problem that "a TB or two" is less easy with
increasing disk capacities, but then I think that disks with a
capacity larger than 1TB are not suitable for ordinary
workloads, and more for tape-cartridge like usage.

> What would they have done had the btrfs gone bad and needed
> repaired? [ ... ]

In most cases I have seen of designs aimed at achieving the
lowest cost and highest flexibility "low IOPS single poool" at
the expense of scalability and maintainability, the "clever"
designer had been promoted or had wisely moved to another job
while the storage system was still mostly empty so the problems
had not yet happened.

[ ... ]

> But like I said I'm biased.  By hard experience, yes, and
> getting the sizes for the partitions wrong can be a hassle
> until you get to know your use-case and size them correctly,
> but it's a definite bias.

Yes, I am very pleased that this post shares this and many
other insights from the wisdom of the ancients, not everybody
knows better :-).

[ ... ]
