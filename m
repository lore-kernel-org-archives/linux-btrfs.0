Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:45249 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753262Ab3CKAVm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 Mar 2013 20:21:42 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UEqV8-0006FL-1F
	for linux-btrfs@vger.kernel.org; Mon, 11 Mar 2013 01:22:02 +0100
Received: from 50-0-67-239.dsl.static.fusionbroadband.com ([50.0.67.239])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Mar 2013 01:22:02 +0100
Received: from rogerb by 50-0-67-239.dsl.static.fusionbroadband.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Mar 2013 01:22:02 +0100
To: linux-btrfs@vger.kernel.org
From: Roger Binns <rogerb@rogerbinns.com>
Subject: Re: [PATCH 0/5] [RFC] RAID-level terminology change
Date: Sun, 10 Mar 2013 17:21:28 -0700
Message-ID: <khj826$386$1@ger.gmane.org>
References: <1362861071-12589-1-git-send-email-hugo@carfax.org.uk> <khgcsi$1k4$1@ger.gmane.org> <20130310014434.GB30771@carfax.org.uk> <khh6er$nmk$1@ger.gmane.org> <20130310220422.GF30771@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
In-Reply-To: <20130310220422.GF30771@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 10/03/13 15:04, Hugo Mills wrote:
> On Sat, Mar 09, 2013 at 09:41:50PM -0800, Roger Binns wrote:
>> The only constraints that matter are surviving N device failures, and
>> data not lost if at least N devices are still present.  Under the
>> hood the best way of meeting those can be heuristically determined,
>> and I'd expect things like overhead to dynamically adjust as storage
>> fills up or empties.
> 
> That's really not going to work happily -- you'd have to run the 
> restriper in the background automatically as the device fills up.

Which is the better approach - the administrator has to sit there
adjusting various parameters after having done some difficult calculations
redoing it as data and devices increase or decrease - or a computer with
billions of bytes of memory and billions of cpu cycles per second just
figures it out based on experience :-)

> Given that this is going to end up rewriting *all* of the data on the 
> FS,

Why does all data have to be rewritten?  Why does every piece of data have
to have exactly the same storage parameters in terms of
non-redundancy/performance/striping options?

I can easily imagine the final implementation being informed by hot data
tracking.  There is absolutely no need for data that is rarely read to be
using the maximum striping/performance/overhead options.

There is no need to rewrite everything anyway - if a filesystem with 1GB
of data is heading towards 2GB of data then only enough readjusts need to
be made to release that additional 1GB of overhead.

I also assume that the probability of all devices being exactly the same
size and exactly the same performance characteristics is going to
decrease.  Many will expect that they can add an SSD to the soup, and over
time add/update devices.  ie the homogenous case that regular RAID
implicitly assumes will become increasingly rare.

> If you want maximum storage (with some given redundancy), regardless of
> performance, then you might as well start with the parity-based levels
> and just leave it at that.

In the short term it would certainly make sense to have an online
calculator or mkfs helper where you specify the device sizes and
redundancy requirements together with how much data you have, and it then
spits out the string of numbers and letters to use for mkfs/balance.

> Thinking about it, specifying a (redundancy, acceptable_wastage) pair
> is fairly pointless in controlling the performance levels,

I don't think there is merit in specifying acceptable message - the answer
is obvious in that any unused space is acceptable for use.  That also
means it changes over time as storage is used/freed.

> There's not much else a heuristic can do, without effectively exposing
> all the config options to the admin, in some obfuscated form.

There is lots heuristics can do.  At the simplest level btrfs can monitor
device performance characteristics and use that as a first pass.  One
database that I use has an interesting approach for queries - rather than
trying to work out the single best perfect execution strategy (eg which
indices in which order) it actually tries them all out concurrently and
picks the quickest.  That is then used for future similar queries with the
performance being monitored.  Once responses times no longer match the
strategy it tries them all again to pick a new winner.

There is no reason btrfs can't try a similar approach.  When presented
with a pile of heterogenous storage with different sizes and performance
characteristics, use all reasonable approaches and monitor resulting
read/write performance.  Then start biasing towards what works best.  Use
hot data tracking to determine which data would most benefit from its
approach being changed to more optimal values.

Roger
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAlE9I4UACgkQmOOfHg372QTNZgCeJe7H9FDiwMq1CWWZTWE89/4O
fDsAn1s6/J1am4mxHhOYUnz/3JUZ6VJx
=/XF8
-----END PGP SIGNATURE-----

