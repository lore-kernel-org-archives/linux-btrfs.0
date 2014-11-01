Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:61181 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759506AbaKAUxd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 1 Nov 2014 16:53:33 -0400
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (1.0)
Subject: Re: Quota question
From: Cyril Scetbon <cyril.scetbon@free.fr>
In-Reply-To: <pan$db0e5$7ee7229b$da3a292b$c1219b2@cox.net>
Date: Sat, 1 Nov 2014 21:53:30 +0100
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-Id: <BC83CB99-11A1-429E-B741-7B0CB9B96AEE@free.fr>
References: <23550138-C487-44E1-AA4A-B3B951D778D1@free.fr> <F924EC8F-D124-4E6D-A8FE-E03D82A8DAB8@free.fr> <pan$db0e5$7ee7229b$da3a292b$c1219b2@cox.net>
To: Duncan <1i5t5.duncan@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hmm I chose btrfs because it's the only one supported by docker that supports quotas for the root user ...
Si i need to be sure it's really broken as I must use the version provided by distribution I will use, i.e Ubuntu trusty.

I tried simple quotas and it seems to work, but I have an issue with group of quotas 
I'd really appreciate if someone can tell me exactly what should work and what shouldn't 

Thanks

Cyril Scetbon

> On 01 Nov 2014, at 08:00, Duncan <1i5t5.duncan@cox.net> wrote:
> 
> So I honestly can't say what the state of the new quota code is, but one 
> thing I can say for sure is that the quota code in 3.12 is the old code, 
> known to be broken and now rewritten, dead quota code.
