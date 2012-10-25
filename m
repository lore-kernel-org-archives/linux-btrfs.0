Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from qmta11.emeryville.ca.mail.comcast.net ([76.96.27.211]:50568
	"EHLO qmta11.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935649Ab2JYUge convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Oct 2012 16:36:34 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: [RFC] New attempt to a better "btrfs fi df"
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CAE5mzvgem05HN1QTFb6FkhHv0U=e1PTo7idPy06SR97cMbpFLg@mail.gmail.com>
Date: Thu, 25 Oct 2012 14:36:31 -0600
Message-Id: <38F223BF-9890-4854-B622-62738235F022@colorremedies.com>
References: <50899151.1070503@inwind.it> <CAE5mzvgem05HN1QTFb6FkhHv0U=e1PTo7idPy06SR97cMbpFLg@mail.gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

My suggestion is that by default a summary similar to the existing df command be mimicked, where it makes sense, for btrfs fi df.

 - I like the Capacity %. If there is a reliable equivalent, it need not be inode based, that would be great.

-  I care far less about the actual physical device information, more about the btrfs volume(s) as a whole. How big is the volume, how much of that is used, and how much is available?

I understand the challenges behind estimating the amount available. So if the value for available/free is precided by a ~ in each case, or as a heading "~Avail" or "~Free" I'd be OK with that disclaimer.

I think the examples so far are reporting too much information and it's difficult to get just what I want.

Chris Murphy