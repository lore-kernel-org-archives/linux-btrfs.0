Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:46871 "EHLO
	relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781AbaDDIC0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Apr 2014 04:02:26 -0400
Received: from mfilter15-d.gandi.net (mfilter15-d.gandi.net [217.70.178.143])
	by relay6-d.mail.gandi.net (Postfix) with ESMTP id 61594FB8B6
	for <linux-btrfs@vger.kernel.org>; Fri,  4 Apr 2014 10:02:24 +0200 (CEST)
Received: from relay6-d.mail.gandi.net ([217.70.183.198])
	by mfilter15-d.gandi.net (mfilter15-d.gandi.net [10.0.15.180]) (amavisd-new, port 10024)
	with ESMTP id jsNbKJy7F4g4 for <linux-btrfs@vger.kernel.org>;
	Fri,  4 Apr 2014 10:02:22 +0200 (CEST)
Received: from fnix.localnet (dhcp236.cr2i.univ-montp2.fr [162.38.105.236])
	(Authenticated sender: michel@bouissou.net)
	by relay6-d.mail.gandi.net (Postfix) with ESMTPSA id 05485FB8BF
	for <linux-btrfs@vger.kernel.org>; Fri,  4 Apr 2014 10:02:21 +0200 (CEST)
From: =?ISO-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
To: linux-btrfs@vger.kernel.org
Subject: BTRFS setup advice for laptop performance ?
Date: Fri, 04 Apr 2014 10:02:27 +0200
Message-ID: <2692878.dRG1K49eOP@fnix>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I'm going to receive a new small laptop with a 500 GB 5400 RPM mechanical 
"ole' rust"  HD, and I plan ton install BTRFS on it.

It will have a kernel 3.13 for now, until 3.14 gets released.

However I'm still concerned with chronic BTRFS dreadful performance and still 
find that BRTFS degrades much over time even with periodic defrag and "best 
practices" etc.

So I'd like to start with the best possible options and have a few questions :

- Is it still recommended to mkfs with a nodesize or leafsize different 
(bigger) than the default ? I wouldn't like to lose too much disk space anyway 
(1/2 nodesize per file on average ?), as it will be limited...

- Is it recommended to alter the FS to have "skinny extents" ? I've done this 
on all of my BTRFS machines without problem, still the kernel spits a notice 
at mount time, and I'm worrying kind of "Why is the kernel warning me I have 
skinny extents ? Is it bad ? Is it something I should avoid ?"

- Are there other optimization tricks I should perform at mkfs time because 
thay can't be changed later on ?

- Are there other btrfstune or mount options I should pass before starting to 
populate the FS with a system and data ?

- Generally speaking, does LZO compression improve or degrade performance ? 
I'm not able to figure it out clearly.

TIA for the insight.

-- 
Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E

