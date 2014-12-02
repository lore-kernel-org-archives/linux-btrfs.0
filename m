Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:41149 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932690AbaLBBZk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 1 Dec 2014 20:25:40 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XvcDi-0002RH-OE
	for linux-btrfs@vger.kernel.org; Tue, 02 Dec 2014 02:25:38 +0100
Received: from 50.245.141.77 ([50.245.141.77])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Dec 2014 02:25:38 +0100
Received: from eternaleye by 50.245.141.77 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Dec 2014 02:25:38 +0100
To: linux-btrfs@vger.kernel.org
From: Alex Elsayed <eternaleye@gmail.com>
Subject: Re: [RFC PATCH] Btrfs: add sha256 checksum option
Date: Mon, 01 Dec 2014 17:25:24 -0800
Message-ID: <m5j4e6$jfj$1@ger.gmane.org>
References: <1416806586-18050-1-git-send-email-bo.li.liu@oracle.com> <20141125163905.GJ26471@twin.jikos.cz> <m5dash$58v$1@ger.gmane.org> <CAJBj3vd5tY93jkN7S25Am=c1A5iW=msqFDrOe-i9vYx9Phxwcg@mail.gmail.com> <1417480114.12583.2.camel@scientia.net> <m5j1vf$et2$1@ger.gmane.org> <1417481583.12583.5.camel@scientia.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Christoph Anton Mitterer wrote:

> On Mon, 2014-12-01 at 16:43 -0800, Alex Elsayed wrote:
>> including that MAC-then-encrypt is fragile
>> against a number of attacks, mainly in the padding-oracle category (See:
>> TLS BEAST attack).
> Well but here we talk about disk encryption... how would the MtE oracle
> problems apply to that? Either you're already in the system, i.e. beyond
> disk encryption (and can measure any timing difference)... or you're
> not, but then you cannot measure anything.

Arguable. On a system with sufficiently little noise in the signal (say... 
systemd, on SSD, etc) you could possibly get some real information from 
corrupting padding on a relatively long extent used early in the boot 
process, by measuring how it affects time-to-boot.

And padding oracles are just one issue. Overall, the problem is that MtE 
isn't generically secure. EtM or pure AEAD modes are, which means you can 
simply mark any attack that doesn't rely on one of the underlying primitives 
being weak as "Not applicable." It also means you can compose it out of 
arbitrary secure primitives, rather than needing to do your proof of 
security over again for every combination.

That's an _enormous_ win in terms of how easy it is to be sure a system is 
secure. Without it, you can't really be sure there isn't Yet Another Vector 
You Missed.


