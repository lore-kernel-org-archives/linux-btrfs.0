Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:33439 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754744Ab3C0FZK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Mar 2013 01:25:10 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UKirb-0001Gx-JU
	for linux-btrfs@vger.kernel.org; Wed, 27 Mar 2013 06:25:31 +0100
Received: from 50-0-67-239.dsl.static.fusionbroadband.com ([50.0.67.239])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Mar 2013 06:25:31 +0100
Received: from rogerb by 50-0-67-239.dsl.static.fusionbroadband.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Mar 2013 06:25:31 +0100
To: linux-btrfs@vger.kernel.org
From: Roger Binns <rogerb@rogerbinns.com>
Subject: Re: [PATCH 0/5] [RFC] RAID-level terminology change
Date: Tue, 26 Mar 2013 22:24:55 -0700
Message-ID: <kitvr4$ogo$1@ger.gmane.org>
References: <1362861071-12589-1-git-send-email-hugo@carfax.org.uk> <khgcsi$1k4$1@ger.gmane.org> <20130310014434.GB30771@carfax.org.uk> <khh6er$nmk$1@ger.gmane.org> <20130310220422.GF30771@carfax.org.uk> <khj826$386$1@ger.gmane.org> <51527547.2010007@swiftspirit.co.za>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <51527547.2010007@swiftspirit.co.za>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 26/03/13 21:27, Brendan Hide wrote:

> On 11/03/13 02:21, Roger Binns wrote:
>> Why does all data have to be rewritten?  Why does every piece of data
>> have to have exactly the same storage parameters in terms of 
>> non-redundancy/performance/striping options?

> This is a good point. You don't necessarily have to rewrite everything
> all at once so the performance penalty is not necessarily that bad.
> More importantly, some "restripe" operations actually don't need much
> change on-disk (in theory).

Note that is not what I was describing.  What I meant was that if I put
10GB of data onto 100GB of space that btrfs is free to go above and beyond
the minimums, and to do so differently for different pieces of data.  For
example  btrfs could make 6 copies of files beginning with 'a', 10 of
files beginning with 'c' and 274 of all others.  Obviously that is a bad
heuristic, but anything it deems useful for all that unused space is fine
by me, and there is absolutely no need for every block to have exactly the
same parameters all others.

Roger



-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAlFSgqcACgkQmOOfHg372QRIWwCgs/1ou96E5S0d93XEcAnIDvTd
f08AoNn6F4zjfQSzXAnkZk4RS4KWZq0b
=+kL4
-----END PGP SIGNATURE-----

