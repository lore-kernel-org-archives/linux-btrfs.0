Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:44664 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755093Ab2LILUu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 9 Dec 2012 06:20:50 -0500
Received: from mfilter10-d.gandi.net (mfilter10-d.gandi.net [217.70.178.139])
	by relay4-d.mail.gandi.net (Postfix) with ESMTP id 560D717207E
	for <linux-btrfs@vger.kernel.org>; Sun,  9 Dec 2012 12:20:49 +0100 (CET)
Received: from relay4-d.mail.gandi.net ([217.70.183.196])
	by mfilter10-d.gandi.net (mfilter10-d.gandi.net [10.0.15.180]) (amavisd-new, port 10024)
	with ESMTP id jqPc2aVcCz24 for <linux-btrfs@vger.kernel.org>;
	Sun,  9 Dec 2012 12:20:48 +0100 (CET)
Received: from [192.168.1.66] (AMontpellier-256-1-59-175.w90-28.abo.wanadoo.fr [90.28.26.175])
	(Authenticated sender: swami@petaramesh.org)
	by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id DE463172074
	for <linux-btrfs@vger.kernel.org>; Sun,  9 Dec 2012 12:20:47 +0100 (CET)
Message-ID: <50C4740E.1060906@petaramesh.org>
Date: Sun, 09 Dec 2012 12:20:46 +0100
From: =?ISO-8859-1?Q?Sw=E2mi_Petaramesh?= <swami@petaramesh.org>
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: BTRFS, getting darn slower everyday
References: <50714AC8.4010100@petaramesh.org> <201210071259.05801.Martin@lichtvoll.de> <50718C44.2080701@petaramesh.org> <201210071648.54027.Martin@lichtvoll.de> <alpine.LNX.2.01.1212090614400.31120@nerf07.vanv.qr> <20121209164125.1bd91f23@natsu>
In-Reply-To: <20121209164125.1bd91f23@natsu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le 09/12/2012 11:41, Roman Mamedov a écrit :
> CoW filesystem incurs fragmentation by its nature, not specifically snapshots.
> Even without snapshots, rewriting portions of existing files will write the
> new blocks not over the original ones, but elsewhere, thus increasing
> fragmentation.

Is it to expect that somewhere in the future, BTRFS will be able to
defragment itself without duplicating snapshot data ?

-- 
Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E
Ne cherchez pas : Je ne suis pas sur Facebook.

