Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:44397 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751503AbcABQpu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 2 Jan 2016 11:45:50 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
	by mailout.nyi.internal (Postfix) with ESMTP id D8AB12010F
	for <linux-btrfs@vger.kernel.org>; Sat,  2 Jan 2016 11:45:49 -0500 (EST)
Received: from [10.0.0.5] (x1-6-20-0c-c8-26-c9-2d.cpe.webspeed.dk [176.23.125.70])
	by mail.messagingengine.com (Postfix) with ESMTPA id 7143AC016C4
	for <linux-btrfs@vger.kernel.org>; Sat,  2 Jan 2016 11:45:49 -0500 (EST)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 9.2 \(3112\))
Subject: Re: Add big device, remove small device, read-only
From: Rasmus Abrahamsen <btrfs@rasmusa.net>
In-Reply-To: <13CBB600-0779-40B7-BD20-ED571A3336D7@rasmusa.net>
Date: Sat, 2 Jan 2016 17:45:47 +0100
Message-Id: <3147B5E0-34C1-40F5-953A-7A40D1F28C51@rasmusa.net>
References: <9E462AAE-481A-4A0D-9918-FF56A73D6F6D@rasmusa.net> <CAJCQCtSCJ91FaJ20g-+TKMwGkXeQdEkn1yDf6w+H3=V_8_xshA@mail.gmail.com> <1451679613.2761176.480641362.3ADA17DB@webmail.messagingengine.com> <1451729336.2917121.480913242.132825EE@webmail.messagingengine.com> <13CBB600-0779-40B7-BD20-ED571A3336D7@rasmusa.net>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Okay, the scrub seemingly did nothing, I am now running balance. This is what I am getting so far:

https://www.dropbox.com/s/02rpab0zcc6er2u/2016-01-02%20IMG_8483.jpg?dl=0