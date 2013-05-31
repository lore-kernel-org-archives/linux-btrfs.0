Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:38493 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756Ab3EaFMF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 31 May 2013 01:12:05 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 3E5409A064D
	for <linux-btrfs@vger.kernel.org>; Thu, 30 May 2013 23:12:04 -0600 (MDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
From: Chris Mason <chris.mason@fusionio.com>
To: Zach Brown <zab@redhat.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <20130530223610.GA24721@lenny.home.zabbo.net>
In-Reply-To: <20130530223610.GA24721@lenny.home.zabbo.net>
Message-ID: <20130531051158.7927.24213@localhost.localdomain>
Subject: Re: testing stable pages being modified
Date: Fri, 31 May 2013 01:11:58 -0400
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Quoting Zach Brown (2013-05-30 18:36:10)
> 'stable' pages have always been a bit of a fiction.  It's easy to
> intentionally modify stable pages under io with some help from page
> references that ignore mappings and page state.
> 
> Here's little test that uses O_DIRECT to get the pinned aio ring pages
> under IO and then has event completion stores modify them while they're
> in flight.
> 
> It's a nice quick way to test the consequences of stable pages being
> modified.  It can be used to burp out ratelimited csum failure kernel
> messages with btrfs, for example.

Changing O_DIRECT in flight has always been a deep dark corner case, and
crc errors are the expected result.  Have you found anyone doing this in
real life?

I do like the small test program though, we should extend it into a test
to make sure crcs are really crcing.

-chris

