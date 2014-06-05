Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:41351 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbaFEPOg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Jun 2014 11:14:36 -0400
Received: from mfilter7-d.gandi.net (mfilter7-d.gandi.net [217.70.178.136])
	by relay5-d.mail.gandi.net (Postfix) with ESMTP id A141F41C086
	for <linux-btrfs@vger.kernel.org>; Thu,  5 Jun 2014 17:14:34 +0200 (CEST)
Received: from relay5-d.mail.gandi.net ([217.70.183.197])
	by mfilter7-d.gandi.net (mfilter7-d.gandi.net [10.0.15.180]) (amavisd-new, port 10024)
	with ESMTP id 4FB7+Ga-hN4V for <linux-btrfs@vger.kernel.org>;
	Thu,  5 Jun 2014 17:14:33 +0200 (CEST)
Received: from zafu.localnet (dhcp231.cr2i.univ-montp2.fr [162.38.105.231])
	(Authenticated sender: michel@bouissou.net)
	by relay5-d.mail.gandi.net (Postfix) with ESMTPSA id 0DF7141C05D
	for <linux-btrfs@vger.kernel.org>; Thu,  5 Jun 2014 17:14:32 +0200 (CEST)
From: =?ISO-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Using BTRFS on SSD now ?
Date: Thu, 05 Jun 2014 17:14:29 +0200
Message-ID: <1493894.GW2nr4reAA@zafu>
In-Reply-To: <1693566.Q9bXme5jtu@xev>
References: <2215647.hErg5R77lo@zafu> <1693566.Q9bXme5jtu@xev>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for the reply Russell :-)

Le vendredi 6 juin 2014 00:42:12 Russell Coker a écrit :
> 
> Also I think that laptops tend to have less use than workstations, so unless
> your laptop is your main desktop system it should get less disk use than a
> typical workstation.

My laptop (+ docking station) is going to be my daily main machine...

> I don't believe that LVM offers any benefit if you use BTRFS.

BTRFS cannot handle swap. A full disk encryption needs the swap to be 
encrypted as well. The only solution for getting both the swap and filesystems 
encrypted using the same key is to put both of them on an LVM itself luks-
encrypted using dm-crypt.

All my machines have been made this way for *years*, so I know it works damn 
well ;-)

...And it also allows for hibernateing the system to (encrypted) swap space...

That's a pretty fine setup :-)

-- 
Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E

