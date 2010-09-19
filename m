From: C Anthony Risinger <anthony@extof.me>
Subject: Re: Question of stability
Date: Sat, 18 Sep 2010 23:50:52 -0500
Message-ID: <AANLkTi=-b6hQz+6xBPqKvSv+8uaKz2maURi_LH7hLV2T@mail.gmail.com>
References: <-2391411343414296963@unknownmsgid>
	<19323412.131.1284861637528.JavaMail.root@zimbra>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: linux-btrfs@vger.kernel.org
To: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <19323412.131.1284861637528.JavaMail.root@zimbra>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Sep 18, 2010 at 9:00 PM, Roy Sigurd Karlsbakk <roy@karlsbakk.net> wrote:
>> Stable is a pretty subjective term; many don't even think ext4 is
>> stable. I've used it on my personal machine since .30-31-ish without
>> problems, and on a server w/raid 1 for about a year (btrfs + lxc is
>> niiice, for VMs) also free of problems.
>>
>> However, if you've been on the list you know that some do encounter
>> seemingly catastrophic problems, though the list is helpful in
>> recovering data. So, it's really going to depends on your workload
>> and integrity needs. I remeber someone recently using it for
>> continuous build servers successfully
>
> The term stable may be subjective at times, but for btrfs to be stable, it needs a working filesystem, with offline or online fsck abilities, and allowing for what's in the idea of btrfs, that is, checksumming everything, allowing snapshots and rollbacks et cetera. If btrfs is only stable as in ext4, well, why not just use ext4? The whole reason for btrfs to exist is to bring something new into the Linux world, and if those features aren't stable, then btrfs isn't. It's as simple as that. Would you buy a Subaru (or something) 4wd with a 2wd working?

whoa, relax; that's a terrible analogy ;-)

) the term stability is _always_ subjective
) fsck has nothing to do with the filesystem itself, and does not
contribute to it's operational stability
) checksums work fine
) snapshots work fine
) rollbacks are an implementation detail using snapshots; has nothing
to do w/filesystem, afiak
) ehm, i suppose you would use btrfs over ext4 because you need it's
features? beats me; you decide :-)
) ^^^^ have proper backup/failover options and it won't matter which you choose
) i'm sure that's not a reason ;-)
) ^^^^ btrfs has several pending/potential features/patches/branches
floating around such as raid5/6, hot data awareness, etc. -- these
unimplemented features (likely) do not detract from the stability of
what's implemented now

i apologize for the terseness, but i'm not sure what you're after
exactly -- you said you have been on the list for a year, and thus
should already have a pretty good idea of the current state, and what
you can/cannot do?  this (vague and _subjective_) question pops up
from time to time, along with questions about raid5/6, etc., and they
pretty much receive the same response i gave you:

) not everything possible/interesting is planned
) not everything planned is implemented
) some people run into big problems
) the majority likely does not
) use at your own risk
) many, including myself and the previous responder, are currently
using it for a wide range of capacities, successfully, and
collectively believe the minds responsible for btrfs must be rather
competent folk, because for the most part... things are pretty quiet
around here :-)

C Anthony
