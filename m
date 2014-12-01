Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:35969 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932623AbaLAXXQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 1 Dec 2014 18:23:16 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XvaJG-0000Yf-9p
	for linux-btrfs@vger.kernel.org; Tue, 02 Dec 2014 00:23:14 +0100
Received: from 50.245.141.77 ([50.245.141.77])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Dec 2014 00:23:14 +0100
Received: from eternaleye by 50.245.141.77 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Dec 2014 00:23:14 +0100
To: linux-btrfs@vger.kernel.org
From: Alex Elsayed <eternaleye@gmail.com>
Subject: Re: [RFC PATCH] Btrfs: add sha256 checksum option
Date: Mon, 01 Dec 2014 15:23:03 -0800
Message-ID: <m5it8o$8gf$1@ger.gmane.org>
References: <1416806586-18050-1-git-send-email-bo.li.liu@oracle.com> <1416859665.3019.6@mail.thefacebook.com> <20141125164717.GK26471@twin.jikos.cz> <5475D7F3.4040408@swiftspirit.co.za> <5475DC9A.3060003@gmail.com> <20141201183729.GM12140@twin.jikos.cz> <547CD129.2030007@gmail.com> <CAJBj3vfr+awjY1iztH-wcy9PSzsCa2cYsDhmRz2cV-O=SFifHw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

John Williams wrote:

> On Mon, Dec 1, 2014 at 12:35 PM, Austin S Hemmelgarn
> <ahferroin7@gmail.com> wrote:
>> My only reasoning is that with this set of hashes (crc32c, adler32, and
>> md5), the statistical likely-hood of running into a hash collision with
>> more than one of them at a time is infinitesimally small compared to the
>> likely-hood of any one of them having a collision (or even compared to
>> something ridiculous like the probability of being killed by a meteor
>> strike), and the combination is faster on most systems that I have tried
>> than many 256-bit crypto hashes.
> 
> I have not seen any evidence that combining hashes like that actually
> reduces the chances of collision, but if we assume it does, then
> again, the non-crypto hashes would be faster. For example, 128-bit
> Spooky2 combined with 128-bit CityHash would produce a 256-bit hash
> and would be faster than MD5 + whatever.

It has no real benefit, but _why_ depends on what your model is.

There's a saying that engineers worry about stochastic failure; security 
professionals have to worry about malicious failure.

If your only concern is stochastic failure (random bitflips, etc), then the 
chances of collision with 128-bit CityHash or MurmurHash or SipHash or what-
have-you are already so small that every single component in your laptop 
dying simultaneously is more likely. Adding another hash is thus just a 
waste of cycles.

If your concern is malicious failure (in-band deduplication attack or 
similar, ignoring for now that btrfs actually compares the extent data as 
well IIRC), then it's well-known in the cryptographic community that the 
concatenation of multiple hashes is as strong as the strongest hash, _but no 
stronger_ [1].

Since the strongest cipher in the above list is either a non-cryptographic 
hash or MD5, which is known-weak to the point of there being numerous toy 
programs finding collisions for arbitrary data, it would not be worth much.

The only place this might be of use is if you used N strong/unbroken hashes, 
in order to hedge against up to N-1 of them being broken. However, the gain 
of that is (again) infinetismal, and the performance cost quite large 
indeed.

[1] http://eprint.iacr.org/2008/075

