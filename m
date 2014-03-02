Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:34384 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105AbaCBK7h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 2 Mar 2014 05:59:37 -0500
Received: from mfilter30-d.gandi.net (mfilter30-d.gandi.net [217.70.178.161])
	by relay5-d.mail.gandi.net (Postfix) with ESMTP id 39D6541C054
	for <linux-btrfs@vger.kernel.org>; Sun,  2 Mar 2014 11:59:36 +0100 (CET)
Received: from relay5-d.mail.gandi.net ([217.70.183.197])
	by mfilter30-d.gandi.net (mfilter30-d.gandi.net [10.0.15.180]) (amavisd-new, port 10024)
	with ESMTP id sxgN5zAysKgk for <linux-btrfs@vger.kernel.org>;
	Sun,  2 Mar 2014 11:59:34 +0100 (CET)
Received: from fnix.localnet (AMontpellier-256-1-52-154.w90-28.abo.wanadoo.fr [90.28.19.154])
	(Authenticated sender: michel@bouissou.net)
	by relay5-d.mail.gandi.net (Postfix) with ESMTPSA id CA4A541C056
	for <linux-btrfs@vger.kernel.org>; Sun,  2 Mar 2014 11:59:34 +0100 (CET)
From: =?ISO-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
To: linux-btrfs@vger.kernel.org
Subject: Is BTRFS "bedup" maintained ?
Date: Sun, 02 Mar 2014 12:00:51 +0100
Message-ID: <2507621.pWqlrcrh1e@fnix>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I tried to use "bedup" BTRFS offline deduplication tool on several BTRFS 
machines, with mixed results :

1/ Crashes with messages stating "programming error", sqlite objects must be 
used inside of the thread that created them, blah-blah...

2/ Crashes stating that some file/objects miss a "live" attribute (?)

3/ bedup eating all my system RAM, then swap over 7GB until the system trashes 
itself.

Wel, besides that and restarting over and over, I could deduplicate some files 
and gain some noticeable space, but it looks extremely bugged and unreliable.

I tried to email the maintainer with details, twice, thru 2 different channels, 
got no anwser...

And it looks like the GIT has not evolved since August, 2013.

So my questions are : 

- Is "bedup" maintained or abandoned ?
- Is it supposed to be usable ?
- Should I use it ?
- Is there a risk that it causes data loss or corruption ?

TIA.

Kind regards.

-- 
Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E

