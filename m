Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:52304 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751649AbaK2V1U (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 29 Nov 2014 16:27:20 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XupXy-000152-FD
	for linux-btrfs@vger.kernel.org; Sat, 29 Nov 2014 22:27:18 +0100
Received: from 66.87.138.157 ([66.87.138.157])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 29 Nov 2014 22:27:18 +0100
Received: from eternaleye by 66.87.138.157 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 29 Nov 2014 22:27:18 +0100
To: linux-btrfs@vger.kernel.org
From: Alex Elsayed <eternaleye@gmail.com>
Subject: Re: [RFC PATCH] Btrfs: add sha256 checksum option
Date: Sat, 29 Nov 2014 13:27:02 -0800
Message-ID: <m5ddn8$fd8$1@ger.gmane.org>
References: <1416806586-18050-1-git-send-email-bo.li.liu@oracle.com> <20141125163905.GJ26471@twin.jikos.cz> <m5dash$58v$1@ger.gmane.org> <CAJBj3vd5tY93jkN7S25Am=c1A5iW=msqFDrOe-i9vYx9Phxwcg@mail.gmail.com> <m5dcia$tk8$1@ger.gmane.org> <CAJBj3ve8rfdAVLNwQ0ZxD8nQ3+5TwtTYXZ6BOMK0NquzHK15WA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

John Williams wrote:

> On Sat, Nov 29, 2014 at 1:07 PM, Alex Elsayed <eternaleye@gmail.com>
> wrote:
>> I'd suggest looking more closely at the crypto api section of menuconfig
>> - it already has crc32c, among others. Just because it's called the
>> "crypto api" doesn't mean it only has cryptographically-strong
>> algorithms.
> 
> I have looked. What 128- or 256-bit hash functions in "crypto api" are
> you referring to that are as fast as Spooky2 or CityHash?

I'm saying that neither of those are in the kernel _anywhere_ now, so if 
someone's adding them the sensible thing seems to be to add them to the 
crypto api, access them through it, and then if we ever add more we get them 
for free on the btrfs side instead of needing to reinvent the wheel every 
time.

In short, there's a place for hashes - why not use it?

