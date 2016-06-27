Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:35059 "EHLO
	mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbcF0EfX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jun 2016 00:35:23 -0400
Received: by mail-lf0-f67.google.com with SMTP id w130so27470521lfd.2
        for <linux-btrfs@vger.kernel.org>; Sun, 26 Jun 2016 21:35:22 -0700 (PDT)
Subject: Re: [BUG] Btrfs scrub sometime recalculate wrong parity in raid5
To: Christoph Anton Mitterer <calestyo@scientia.net>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        Duncan <1i5t5.duncan@cox.net>
References: <8695beeb-f991-28c4-cf6b-8c92339e468f@inwind.it>
 <CAJCQCtTXJhgKsmQGUXrppntYj8u6vk3jzP9Q4UMBomJ255QTQw@mail.gmail.com>
 <pan$60ea0$54eb541$a3b060fc$181835e5@cox.net>
 <CAN05THQCJS8x0yF6DjDFfsNWzp1u4edv5dH-BMb1TTofZdtjgA@mail.gmail.com>
 <1466999436.13546.6.camel@scientia.net>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <5770AD08.3050201@gmail.com>
Date: Mon, 27 Jun 2016 07:35:20 +0300
MIME-Version: 1.0
In-Reply-To: <1466999436.13546.6.camel@scientia.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

27.06.2016 06:50, Christoph Anton Mitterer пишет:
> 
> What should IMHO be done as well is giving a big fat warning in the
> manpages/etc. that when nodatacow is used RAID recovery cannot produce
> valid data (at least as long as there isn't checksumming implemented
> for nodatacow).

The problem is that current implementation of RAID56 puts exactly CoW
data at risk. I.e. writing new (copy of) data may suddenly make old
(copy of) data inaccessible, even though it had been safely committed to
disk and is now in read-only snapshot.


