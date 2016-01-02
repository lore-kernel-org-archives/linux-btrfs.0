Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:34358 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751210AbcABTrL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 2 Jan 2016 14:47:11 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
	by mailout.nyi.internal (Postfix) with ESMTP id CD417203D3
	for <linux-btrfs@vger.kernel.org>; Sat,  2 Jan 2016 14:47:10 -0500 (EST)
Message-Id: <1451764030.3014437.481190514.24FF8F10@webmail.messagingengine.com>
From: Rasmus Abrahamsen <btrfs@rasmusa.net>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
In-Reply-To: <3147B5E0-34C1-40F5-953A-7A40D1F28C51@rasmusa.net>
References: <9E462AAE-481A-4A0D-9918-FF56A73D6F6D@rasmusa.net>
 <CAJCQCtSCJ91FaJ20g-+TKMwGkXeQdEkn1yDf6w+H3=V_8_xshA@mail.gmail.com>
 <1451679613.2761176.480641362.3ADA17DB@webmail.messagingengine.com>
 <1451729336.2917121.480913242.132825EE@webmail.messagingengine.com>
 <13CBB600-0779-40B7-BD20-ED571A3336D7@rasmusa.net>
 <3147B5E0-34C1-40F5-953A-7A40D1F28C51@rasmusa.net>
Subject: Re: Add big device, remove small device, read-only
Date: Sat, 02 Jan 2016 20:47:10 +0100
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The scrub was frozen. I tried to cancel it but it had become read-only.
I rebooted and am now looking into what btrfsck can do for me

On Sat, Jan 2, 2016, at 05:45 PM, Rasmus Abrahamsen wrote:
> Okay, the scrub seemingly did nothing, I am now running balance. This is
> what I am getting so far:
> 
> https://www.dropbox.com/s/02rpab0zcc6er2u/2016-01-02%20IMG_8483.jpg?dl=0--
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
