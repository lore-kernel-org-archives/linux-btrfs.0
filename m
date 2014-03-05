Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:41940 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879AbaCER0H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 5 Mar 2014 12:26:07 -0500
Received: from mfilter13-d.gandi.net (mfilter13-d.gandi.net [217.70.178.141])
	by relay4-d.mail.gandi.net (Postfix) with ESMTP id 29BDE172077
	for <linux-btrfs@vger.kernel.org>; Wed,  5 Mar 2014 18:26:04 +0100 (CET)
Received: from relay4-d.mail.gandi.net ([217.70.183.196])
	by mfilter13-d.gandi.net (mfilter13-d.gandi.net [10.0.15.180]) (amavisd-new, port 10024)
	with ESMTP id YCRYUgornZhK for <linux-btrfs@vger.kernel.org>;
	Wed,  5 Mar 2014 18:26:02 +0100 (CET)
Received: from tethys.localnet (AMontpellier-256-1-106-82.w90-28.abo.wanadoo.fr [90.28.161.82])
	(Authenticated sender: michel@bouissou.net)
	by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id 755771720AC
	for <linux-btrfs@vger.kernel.org>; Wed,  5 Mar 2014 18:26:02 +0100 (CET)
From: =?ISO-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
To: linux-btrfs@vger.kernel.org
Subject: [Repost] Is BTRFS "bedup" maintained ?
Date: Wed, 05 Mar 2014 18:24:40 +0100
Message-ID: <13941240.S910jBrBmq@tethys>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

(Not having received a single answer, I repost this...)

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

