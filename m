Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:39545 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932216AbaLBAnm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 1 Dec 2014 19:43:42 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XvbZ7-0004p1-3h
	for linux-btrfs@vger.kernel.org; Tue, 02 Dec 2014 01:43:41 +0100
Received: from 50.245.141.77 ([50.245.141.77])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Dec 2014 01:43:41 +0100
Received: from eternaleye by 50.245.141.77 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Dec 2014 01:43:41 +0100
To: linux-btrfs@vger.kernel.org
From: Alex Elsayed <eternaleye@gmail.com>
Subject: Re: [RFC PATCH] Btrfs: add sha256 checksum option
Date: Mon, 01 Dec 2014 16:43:27 -0800
Message-ID: <m5j1vf$et2$1@ger.gmane.org>
References: <1416806586-18050-1-git-send-email-bo.li.liu@oracle.com> <20141125163905.GJ26471@twin.jikos.cz> <m5dash$58v$1@ger.gmane.org> <CAJBj3vd5tY93jkN7S25Am=c1A5iW=msqFDrOe-i9vYx9Phxwcg@mail.gmail.com> <1417480114.12583.2.camel@scientia.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Christoph Anton Mitterer wrote:

> On Sat, 2014-11-29 at 13:00 -0800, John Williams wrote:
>> On Sat, Nov 29, 2014 at 12:38 PM, Alex Elsayed <eternaleye@gmail.com>
>> wrote:
>> > Why not just use the kernel crypto API? Then the user can just specify
>> > any hash the kernel supports.
>> 
>> One reason is that crytographic hashes are an order of magnitude
>> slower than the fastest non-cryptographic hashes. And for filesystem
>> checksums, I do not see a need for crypotgraphic hashes.
> 
> I'm not that crypto expert, but wouldn't the combination of a
> cryptographic hash, in combination with e.g. dm-crypt below the
> filesystem give us what dm-crypt alone cannot really give us
> (authenticated integrity)?
> 
> Would that combination of hash+encrypt basically work like a MAC?

Sadly, no. Partially because in order for an encrypted hash to be a secure 
MAC, the encryption must be nonmalleable, which would require CMC or EME - 
encryption modes which Linux does not presently support as I understand it. 
There are other issues as well, including that MAC-then-encrypt is fragile 
against a number of attacks, mainly in the padding-oracle category (See: TLS 
BEAST attack).

AEAD modes are also nonmalleable, but as they are length-expanding they 
cannot be used for LUKS. However, as eCryptFS and possibly the recent ext4 
encryption work shows, using them at a higher-level (encrypting extents or 
files) does work. Of course, if you're using an AEAD mode in the filesystem 
anyway, just use it directly and have done with it.

