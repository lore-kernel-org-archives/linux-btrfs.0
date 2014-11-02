Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:45570 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751204AbaKBBx2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 1 Nov 2014 21:53:28 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:52554 helo=[192.168.1.126])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:RC4-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1XkkMA-001WNp-R4
	for linux-btrfs@vger.kernel.org; Sat, 01 Nov 2014 19:53:27 -0600
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Quota question
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <BC83CB99-11A1-429E-B741-7B0CB9B96AEE@free.fr>
Date: Sat, 1 Nov 2014 19:53:26 -0600
Message-Id: <7A4F7864-B01A-4B69-B2DE-3140DA6216D8@colorremedies.com>
References: <23550138-C487-44E1-AA4A-B3B951D778D1@free.fr> <F924EC8F-D124-4E6D-A8FE-E03D82A8DAB8@free.fr> <pan$db0e5$7ee7229b$da3a292b$c1219b2@cox.net> <BC83CB99-11A1-429E-B741-7B0CB9B96AEE@free.fr>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Nov 1, 2014, at 2:53 PM, Cyril Scetbon <cyril.scetbon@free.fr> wrote:

> Hmm I chose btrfs because it's the only one supported by docker that supports quotas for the root user …

https://github.com/docker/docker/issues/3804

I don't think Docker is supporting quotas at all on anything yet. They want to do this but it seems the work hasn't been done yet, and they want it to be agnostic so it can work with device mapper, XFS, EXT4, and Btrfs.


> I'd really appreciate if someone can tell me exactly what should work and what shouldn't 

Well I haven't tested this at all yet, but maybe XFS project quotas fits your use case better than group quotas? With project quotas you can still also use user quotas if necessary (but project and group quotas on XFS are mutually exclusive).

Chris Murphy

