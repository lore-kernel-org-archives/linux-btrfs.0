Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:40031 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755354Ab3DTVP2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 20 Apr 2013 17:15:28 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UTf82-0004Tu-UZ
	for linux-btrfs@vger.kernel.org; Sat, 20 Apr 2013 23:15:26 +0200
Received: from 50-0-67-239.dsl.static.fusionbroadband.com ([50.0.67.239])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 20 Apr 2013 23:15:26 +0200
Received: from rogerb by 50-0-67-239.dsl.static.fusionbroadband.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 20 Apr 2013 23:15:26 +0200
To: linux-btrfs@vger.kernel.org
From: Roger Binns <rogerb@rogerbinns.com>
Subject: Re: data DUP
Date: Sat, 20 Apr 2013 14:15:14 -0700
Message-ID: <kkv0gv$jpo$1@ger.gmane.org>
References: <kkut3u$lp1$1@ger.gmane.org> <20130420204814.GN7639@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
In-Reply-To: <20130420204814.GN7639@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 20/04/13 13:48, Hugo Mills wrote:> On Sat, Apr 20, 2013 at 01:17:06PM
- -0700, Roger Binns wrote:
>> Is there any particular reason why I can't use DUP for data?
> 
> Technically, no. Performance is likely to suck if you use rotational
> disks, and you may find some SSDs deduplicate blocks, making it fairly
> pointless for those devices.

Wanting dup is because I care about resilience in the face of errors over
performance, so I don't actually care how bad performance sucks.  I only
put data on SSDs that I can afford to lose (usually backed up to
Dropbox/github/spinning disks).

>> When I try to set it with balance there is a kernel message:
>> 
>> btrfs: dup for data is not allowed
> 
> What kernel and userspace versions are you using? I thought the 
> restriction had been removed at some point (but possibly I'm just 
> misremembering it).

Whatever Ubuntu 12.10 ships with.  Kernel package is 3.5.0.27.43 and
btrfs-tools is 0.19+20120328-7ubuntu1.  Note the message came from the
kernel so it would appear to be solely to blame for refusing my request.

> it can be quite hard to find every single implication of a feature when
> that feature gets changd/updated.

I'm more amused that someone went to the trouble of putting in kernel
detection and messages plus updating the documentation in order to prevent
using DUP for data!

Roger
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAlFzBWEACgkQmOOfHg372QT5twCeI5KOgHYT1wcPNPtni9TYKQaG
aeIAmQGw/nL/ziTDAu4gUJIFPwCLI5td
=ABih
-----END PGP SIGNATURE-----

