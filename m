Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:44033 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750872Ab3CJFmB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 Mar 2013 00:42:01 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UEZ1Z-0002To-RM
	for linux-btrfs@vger.kernel.org; Sun, 10 Mar 2013 06:42:21 +0100
Received: from 50-0-67-239.dsl.static.fusionbroadband.com ([50.0.67.239])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 10 Mar 2013 06:42:21 +0100
Received: from rogerb by 50-0-67-239.dsl.static.fusionbroadband.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 10 Mar 2013 06:42:21 +0100
To: linux-btrfs@vger.kernel.org
From: Roger Binns <rogerb@rogerbinns.com>
Subject: Re: [PATCH 0/5] [RFC] RAID-level terminology change
Date: Sat, 09 Mar 2013 21:41:50 -0800
Message-ID: <khh6er$nmk$1@ger.gmane.org>
References: <1362861071-12589-1-git-send-email-hugo@carfax.org.uk> <khgcsi$1k4$1@ger.gmane.org> <20130310014434.GB30771@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
In-Reply-To: <20130310014434.GB30771@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 09/03/13 17:44, Hugo Mills wrote:
> You've got at least three independent parameters to the system in order
> to make that choice, though, and it's a fairly fuzzy decision problem.
> You've got:
> 
> - Device redundancy - Storage overhead - Performance

Overhead and performance aren't separate goals.  More accurately the goal
is best performance given the devices available and constrained by redundancy.

If I have 1GB of unique data and 10GB of underlying space available then
feel free to make 9 additional copies of each piece of data if that helps
performance.  As I increase the unique data the overhead available will
decrease, but I doubt anyone has a goal of micromanaging overhead usage.
Why can't the filesystem just figure it out and do the best job available
given minimal constraints?

> I definitely want to report the results in nCmSpP form, which tells you
> what it's actually done. The internal implementation, while not 
> expressing the full gamut of possibilities, maps directly from the 
> internal configuration to that form, and so it should at least be an 
> allowable input for configuration (e.g. mkfs.btrfs and the restriper).

Agreed on that for the micromanagers :-)

> If you'd like to suggest a usable set of configuration axes [say, 
> (redundancy, overhead) ], and a set of rules for converting those
> requirements to the internal representation, then there's no reason we
> can't add them as well in a later set of patches.

The only constraints that matter are surviving N device failures, and data
not lost if at least N devices are still present.  Under the hood the best
way of meeting those can be heuristically determined, and I'd expect
things like overhead to dynamically adjust as storage fills up or empties.

Roger
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAlE8HR0ACgkQmOOfHg372QSyngCgpE9PTyBl3MsJ1kCYODtQWno/
85cAn0dcqE8ZWhOpFbZnQISmpe/KYceN
=LTf8
-----END PGP SIGNATURE-----

